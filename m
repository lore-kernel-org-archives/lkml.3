Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3FRNN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:13:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55278 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab3FRNNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:13:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/3] ARM: ux500: Correct the EN_3v3 regulator's on/off GPIO
Date: Tue, 18 Jun 2013 15:12:58 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
References: <1371545519-27119-1-git-send-email-lee.jones@linaro.org> <1371545519-27119-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1371545519-27119-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306181512.58546.arnd@arndb.de>
X-Provags-ID: V02:K0:JkZLzAeU6HhdDVsl8Qa1wiCYXACEM+fb0KzyvmtQWDX
 oOhKEyUn3euqG3hCzUxd3KLn4dnygzfgIol2+HVjQrXEYTeGhR
 0zWJWFaS1ZkY4if2+BK2JRIpjrS29lP73ezK4XeI+aCgYL4i44
 W+8Dox/VXWcCdZMdNc7M3nhGO3J4cVx5fIm2EP1o56rWVgoydM
 clEkvKjawcUSuHA/5S0c71Yildc0ArMz8/Dh/1Iz810hxgeI6w
 d94NcyGTZKz7EPe4BE7Br/ZMur6FMZIA88I2iGk/o70h9r0Z9q
 9A1NRnIYxVZZjyl4LW8whFJDyH37H8Dt1gP7lCadHphitUYoGl
 xX17aHLVWQZ2DYvrxQ6I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 June 2013, Lee Jones wrote:
> -                gpios = <&gpio0 26  0x4>; // 26
> -                startup-delay-us = <5000>;
> -                enable-active-high;
> +               regulator-name = "en-3v3-fixed-supply";
> +               regulator-min-microvolt = <3300000>;
> +               regulator-max-microvolt = <3300000>;
> +               /* AB8500 GPIOs start from 1 - offset 25 is GPIO26. */
> +               gpio = <&ab8500_gpio 25 0x4>;

Is it intentional that you had "gpios" before and "gpio" after the change
as the property name?

	Arnd
