Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab3HTL7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:59:50 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:51635 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3HTL7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:59:48 -0400
Date: Tue, 20 Aug 2013 12:59:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Florian Lobmaier <florian.lobmaier@ams.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 1/4] mfd: as3722: driver introduction in Kconfig and
 Makefile
Message-ID: <20130820115943.GK23699@lee--X1>
References: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
 <1376997210-32631-2-git-send-email-florian.lobmaier@ams.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376997210-32631-2-git-send-email-florian.lobmaier@ams.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Florian Lobmaier wrote:

> 
> Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
> ---
>  drivers/mfd/Kconfig  |   15 +++++++++++++++
>  drivers/mfd/Makefile |    1 +
>  2 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index aecd6dd..a02777c 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -27,6 +27,21 @@ config MFD_AS3711
>  	help
>  	  Support for the AS3711 PMIC from AMS
>  
> +config MFD_AS3722
> +        tristate "Support for ams AS3722 PMIC"
> +        select MFD_CORE
> +        select REGMAP_I2C
> +        select REGMAP_IRQ
> +        depends on I2C=y
> +        help
> +          Core support for the ams AS3722 PMIC. Additional
> +          drivers must be enabled in order to use the functionality of the
> +          device.
> +          Related drivers are:
> +                * ams AS3722 PMIC regulators
> +                * ams AS3722 GPIO
> +                * ams AS3722 RTC
> +
>  config PMIC_ADP5520
>  	bool "Analog Devices ADP5520/01 MFD PMIC Core Support"
>  	depends on I2C=y
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 3c90051..358e46e 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -159,3 +159,4 @@ obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
>  obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o vexpress-sysreg.o
>  obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
>  obj-$(CONFIG_MFD_AS3711)	+= as3711.o
> +obj-$(CONFIG_MFD_AS3722)        += as3722-core.o as3722-regmap.o

Your patches need to be orthogonal. To say that if I applied this
[PATCH 1/4] then it needs to be functional and buildable. This
isn't. This is telling the build system that these files exist and
here's how to build them, but the files do not exist yet. With this
patch should be *some* of the core driver. Probably just enough to
probe() and remove() the device and perhaps a version check if it has
one.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
