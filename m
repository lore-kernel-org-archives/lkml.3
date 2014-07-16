Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbaGPKEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:04:38 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:63272 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171AbaGPKEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:04:34 -0400
Message-ID: <1405505072.4408.17.camel@x220>
Subject: Re: [PATCH 11/19] ARM: S5PV210: Remove support for board files
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Wed, 16 Jul 2014 12:04:32 +0200
In-Reply-To: <1404496099-26708-12-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <1404496099-26708-12-git-send-email-t.figa@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2014 10:04:32.0559 (UTC) FILETIME=[570B03F0:01CFA0DD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 19:48 +0200, Tomasz Figa wrote:
> Since all in-tree boards have been moved to device tree, we can now drop
> legacy code and make mach-s5pv210 DT-only. This patch does it.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---

This patch showed up in next-20140716 too.

>[...]
> diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
> index ed492cf..d6d0f92 100644
> --- a/arch/arm/mach-s5pv210/Kconfig
> +++ b/arch/arm/mach-s5pv210/Kconfig
> @@ -19,181 +19,8 @@ config CPU_S5PV210
>  	help
>  	  Enable S5PV210 CPU support
>  
> -config S5PV210_SETUP_I2C1
> -	bool
> -	help
> -	  Common setup code for i2c bus 1.
> -
> -config S5PV210_SETUP_I2C2
> -	bool
> -	help
> -	  Common setup code for i2c bus 2.
> -
> -config S5PV210_SETUP_IDE
> -	bool
> -	help
> -	  Common setup code for S5PV210 IDE GPIO configurations
> -
> -config S5PV210_SETUP_FB_24BPP
> -	bool
> -	help
> -          Common setup code for S5PV210 with an 24bpp RGB display helper.
> -
> -config S5PV210_SETUP_KEYPAD
> -	bool
> -	help
> -	  Common setup code for keypad.
> -
> -config S5PV210_SETUP_SDHCI
> -        bool
> -        select S5PV210_SETUP_SDHCI_GPIO
> -        help
> -          Internal helper functions for S5PV210 based SDHCI systems
> -
> -config S5PV210_SETUP_SDHCI_GPIO
> -	bool
> -	help
> -	  Common setup code for SDHCI gpio.
> -
> -config S5PV210_SETUP_FIMC
> -	bool
> -	help
> -	  Common setup code for the camera interfaces.
> -
> -config S5PV210_SETUP_SPI
> -	bool
> -	help
> -	  Common setup code for SPI GPIO configurations.
> -
> -config S5PV210_SETUP_USB_PHY
> -	bool
> -	help
> -	  Common setup code for USB PHY controller
> -
> -menu "S5PC110 Machines"
> -
> -config MACH_AQUILA
> -	bool "Aquila"
> -	select CPU_S5PV210
> -	select S3C_DEV_FB
> -	select S3C_DEV_HSMMC
> -	select S3C_DEV_HSMMC1
> -	select S3C_DEV_HSMMC2
> -	select S5PV210_SETUP_FB_24BPP
> -	select S5PV210_SETUP_SDHCI
> -	select S5PV210_SETUP_USB_PHY
> -	select S5P_DEV_FIMC0
> -	select S5P_DEV_FIMC1
> -	select S5P_DEV_FIMC2
> -	select S5P_DEV_ONENAND
> -	help
> -	  Machine support for the Samsung Aquila target based on S5PC110 SoC
> -

This symbol is still referenced in sound/soc/samsung/Kconfig.

> -config MACH_GONI
> -	bool "GONI"
> -	select CPU_S5PV210
> -	select S3C_DEV_FB
> -	select S3C_DEV_HSMMC
> -	select S3C_DEV_HSMMC1
> -	select S3C_DEV_HSMMC2
> -	select S3C_DEV_I2C1
> -	select S3C_DEV_I2C2
> -	select S3C_DEV_USB_HSOTG
> -	select S5PV210_SETUP_FB_24BPP
> -	select S5PV210_SETUP_FIMC
> -	select S5PV210_SETUP_I2C1
> -	select S5PV210_SETUP_I2C2
> -	select S5PV210_SETUP_KEYPAD
> -	select S5PV210_SETUP_SDHCI
> -	select S5PV210_SETUP_USB_PHY
> -	select S5P_DEV_FIMC0
> -	select S5P_DEV_FIMC1
> -	select S5P_DEV_FIMC2
> -	select S5P_DEV_MFC
> -	select S5P_DEV_ONENAND
> -	select S5P_DEV_TV
> -	select S5P_GPIO_INT
> -	select SAMSUNG_DEV_KEYPAD
> -	help
> -	  Machine support for Samsung GONI board
> -	  S5PC110(MCP) is one of package option of S5PV210

Ditto.

> -config MACH_SMDKC110
> -	bool "SMDKC110"
> -	select CPU_S5PV210
> -	select S3C_DEV_I2C1
> -	select S3C_DEV_I2C2
> -	select S3C_DEV_RTC
> -	select S3C_DEV_WDT
> -	select S5PV210_SETUP_I2C1
> -	select S5PV210_SETUP_I2C2
> -	select S5PV210_SETUP_IDE
> -	select S5P_DEV_FIMC0
> -	select S5P_DEV_FIMC1
> -	select S5P_DEV_FIMC2
> -	select S5P_DEV_MFC
> -	select SAMSUNG_DEV_IDE
> -	help
> -	  Machine support for Samsung SMDKC110
> -	  S5PC110(MCP) is one of package option of S5PV210

Ditto.

> -endmenu
> -
>  menu "S5PV210 Machines"
>  
> -config MACH_SMDKV210
> -	bool "SMDKV210"
> -	select CPU_S5PV210
> -	select S3C_DEV_FB
> -	select S3C_DEV_HSMMC
> -	select S3C_DEV_HSMMC1
> -	select S3C_DEV_HSMMC2
> -	select S3C_DEV_HSMMC3
> -	select S3C_DEV_I2C1
> -	select S3C_DEV_I2C2
> -	select S3C_DEV_RTC
> -	select S3C_DEV_USB_HSOTG
> -	select S3C_DEV_WDT
> -	select S5PV210_SETUP_FB_24BPP
> -	select S5PV210_SETUP_I2C1
> -	select S5PV210_SETUP_I2C2
> -	select S5PV210_SETUP_IDE
> -	select S5PV210_SETUP_KEYPAD
> -	select S5PV210_SETUP_SDHCI
> -	select S5PV210_SETUP_USB_PHY
> -	select S5P_DEV_FIMC0
> -	select S5P_DEV_FIMC1
> -	select S5P_DEV_FIMC2
> -	select S5P_DEV_JPEG
> -	select S5P_DEV_MFC
> -	select SAMSUNG_DEV_ADC
> -	select SAMSUNG_DEV_BACKLIGHT
> -	select SAMSUNG_DEV_IDE
> -	select SAMSUNG_DEV_KEYPAD
> -	select SAMSUNG_DEV_PWM
> -	select SAMSUNG_DEV_TS
> -	help
> -	  Machine support for Samsung SMDKV210
> -

Ditto.

> -config MACH_TORBRECK
> -	bool "Torbreck"
> -	select ARCH_SPARSEMEM_ENABLE
> -	select CPU_S5PV210
> -	select S3C_DEV_HSMMC
> -	select S3C_DEV_HSMMC1
> -	select S3C_DEV_HSMMC2
> -	select S3C_DEV_HSMMC3
> -	select S3C_DEV_I2C1
> -	select S3C_DEV_I2C2
> -	select S3C_DEV_RTC
> -	select S3C_DEV_WDT
> -	select S5PV210_SETUP_I2C1
> -	select S5PV210_SETUP_I2C2
> -	select S5PV210_SETUP_SDHCI
> -	select SAMSUNG_DEV_IDE
> -	help
> -	  Machine support for aESOP Torbreck
> -
>  config MACH_S5PV210_DT
>  	bool "Samsung S5PV210/S5PC110 machine using Device Tree"
>  	select CLKSRC_OF

I assume one or more patches to remove the references to these symbols
in sound/soc/samsung/Kconfig are pending. Is that correct?


Paul Bolle

