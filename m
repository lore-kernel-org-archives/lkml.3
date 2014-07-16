Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbaGPKQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:16:03 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:59243 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbaGPKP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:15:59 -0400
Message-ID: <1405505756.4408.24.camel@x220>
Subject: Re: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Wed, 16 Jul 2014 12:15:56 +0200
In-Reply-To: <1404496099-26708-19-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <1404496099-26708-19-git-send-email-t.figa@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2014 10:15:56.0951 (UTC) FILETIME=[EEF8F270:01CFA0DE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 19:48 +0200, Tomasz Figa wrote:
> After refactoring suspend/resume, which was last part with dependencies
> on legacy code, all Kconfig symbols related to Samsung ATAGS support can
> be deselected and more unused code removed. This includes most of s5p-*
> code as well, as s5pv210 was their last user.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---

I noticed another thing now this patch showed up in next-20140716.

>  [...]
> diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> index f8185b5..1091b0a 100644
> --- a/arch/arm/plat-samsung/Kconfig
> +++ b/arch/arm/plat-samsung/Kconfig
> @@ -6,29 +6,16 @@
>  
>  config PLAT_SAMSUNG
>  	bool
> -	depends on PLAT_S3C24XX || ARCH_S3C64XX || PLAT_S5P || ARCH_EXYNOS
> +	depends on PLAT_S3C24XX || ARCH_S3C64XX || ARCH_EXYNOS || ARCH_S5PV210
>  	default y
>  	select GENERIC_IRQ_CHIP
>  	select NO_IOPORT_MAP
>  	help
>  	  Base platform code for all Samsung SoC based systems
>  
> -config PLAT_S5P
> -	bool
> -	depends on ARCH_S5PV210
> -	default y
> -	select ARCH_REQUIRE_GPIOLIB
> -	select ARM_VIC
> -	select NO_IOPORT_MAP
> -	select PLAT_SAMSUNG
> -	select S3C_GPIO_TRACK
> -	select S5P_GPIO_DRVSTR
> -	help
> -	  Base platform code for Samsung's S5P series SoC.
> -

After this patch that symbol is still referenced in:
drivers/media/platform/Kconfig:159:     depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
drivers/media/platform/Kconfig:169:     depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
drivers/media/platform/Kconfig:177:     depends on VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
drivers/media/platform/exynos4-is/Kconfig:5:    depends on (PLAT_S5P || ARCH_EXYNOS)
drivers/media/platform/s5p-tv/Kconfig:11:       depends on (PLAT_S5P || ARCH_EXYNOS) && PM_RUNTIME
drivers/usb/host/Kconfig:223:       depends on PLAT_S5P || ARCH_EXYNOS
drivers/usb/host/Kconfig:530:   depends on PLAT_S5P || ARCH_EXYNOS

Again, I assume patches to remove these references are pending. But is
that correct?


Paul Bolle

