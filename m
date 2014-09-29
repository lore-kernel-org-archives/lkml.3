Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbaI2NhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:37:06 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:50486 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaI2NhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:37:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: zhang.lyra@gmail.com
Cc: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: Re: [PATCH 5/6] tty/serial: Add Spreadtrum's serial earlycon
Date: Mon, 29 Sep 2014 15:36:31 +0200
Message-ID: <3038755.G9Y3LOUCHH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411992293-7729-6-git-send-email-zhang.lyra@gmail.com>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com> <1411992293-7729-6-git-send-email-zhang.lyra@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IPSQmzUVUj8qCO4Ga+GtMlZoUB9l+iK639LuuJWJ2R+
 8tgKVHQsOMsMzDl65exkUGHpmuVpQ17QE3tBBRbqcYkH+gkmdt
 tdPPnH1OhLngJb9zM62fIYk3a8/uDTcFVt3z8zAf3GZ24zgT80
 OH4GFR3oOE0rt8Jp3Az2KRkbVPkBXZJKMLE/TDNBzkofAsDE9m
 09wMTx80OW/q2ZLx8jOp0Lu8FF51DdQlW6f6hVK/z7LQsMUvGZ
 BCV8seT1SgbAWKHzo0KuWtGZtIAyssn4WyChpboB00nwdrJltS
 NOqi1An+X75+HH6gGvTU2JPHi8u3n+xNIRugQ6fJ/CGy5f5E66
 XjRoCKusHBeHSj22sDBI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2014 20:04:52 zhang.lyra@gmail.com wrote:
> From: "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
> 
> Adds earlycon support for the Spreadtrum's serial.
> 
> Signed-off-by: chunyan.zhang <chunyan.zhang@spreadtrum.com>
> ---
>  drivers/tty/serial/Kconfig             |   12 ++++++
>  drivers/tty/serial/Makefile            |    1 +
>  drivers/tty/serial/serial_sprd_early.c |   64 ++++++++++++++++++++++++++++++++
>  3 files changed, 77 insertions(+)
>  create mode 100644 drivers/tty/serial/serial_sprd_early.c
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 26cec64..ede16e6 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -85,6 +85,18 @@ config SERIAL_EARLYCON_ARM_SEMIHOST
>  	  with "earlycon=smh" on the kernel command line. The console is
>  	  enabled when early_param is processed.
>  
> +config SERIAL_EARLYCON_SPRD
> +	bool "Early console using SPRD serial"
> +	depends on ARM64
> +	select SERIAL_CORE
> +	select SERIAL_CORE_CONSOLE
> +	select SERIAL_EARLYCON
> +	help

I assume you will later want to have a proper device driver for
this hardware, so it would be better to make the Kconfig symbol
and the file name what you are going to use in the long run, but
for now only have the earlycon support included.


> +static int __init serial_sprd_early_console_setup(
> +				struct earlycon_device *device,
> +				const char *opt)
> +{
> +	if (!device->port.membase)
> +		return -ENODEV;
> +
> +	device->con->write = serial_sprd_early_write;
> +	return 0;
> +}
> +EARLYCON_DECLARE(serial_sprd, serial_sprd_early_console_setup);
> +OF_EARLYCON_DECLARE(serial_sprd, "sprd,serial",
> +		    serial_sprd_early_console_setup);
> 

I think you should drop the EARLYCON_DECLARE() line, using
OF_EARLYCON_DECLARE should be enough.

	Arnd
