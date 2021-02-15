#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat 

#FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019
#ARG source
#WORKDIR /inetpub/wwwroot
#COPY ${source:-obj/Docker/publish} .

FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
WORKDIR /app
# copy csproj and restore as distinct layers
COPY *.sln .
COPY ./*.csproj ./ASP.netFr4.7.2DockerImage/
COPY ./*.config ./ASP.netFr4.7.2DockerImage/
RUN nuget restore
# copy everything else and build app
COPY ./. ./ASP.netFr4.7.2DockerImage/
WORKDIR /app/ASP.netFr4.7.2DockerImage
RUN msbuild /p:Configuration=Release
# copy build artifacts into runtime image
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8
WORKDIR /inetpub/wwwroot
COPY --chown=1000 --from=build ./app/ASP.netFr4.7.2DockerImage/. ./
