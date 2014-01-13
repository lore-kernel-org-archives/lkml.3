Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaAMDTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:19:51 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:39144
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbaAMDTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:19:48 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 13 Jan 2014 11:20:45 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: John Tobias <john.tobias.ph@gmail.com>
CC: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <festevam@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: imx: add select on ARCH_MXC for cpufreq
 support
Message-ID: <20140113032043.GF23525@S2101-09.ap.freescale.net>
References: <1389321592-33220-1-git-send-email-john.tobias.ph@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1389321592-33220-1-git-send-email-john.tobias.ph@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 06:39:51PM -0800, John Tobias wrote:
> Moved ARCH_HAS_CPUFREQ, HAVE_IMX_ANATOP and PM_OPP on ARCH_MXC so that
> the user can enable the cpufreq support for iMX6Q and/or iMX6SL.

All I was asking is to move the following:

	select ARCH_HAS_CPUFREQ
	select ARCH_HAS_OPP
	select PM_OPP if PM

So leave HAVE_IMX_ANATOP out there, and only move the above ones please.

Shawn

> 
> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
> ---
>  arch/arm/mach-imx/Kconfig | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 7a6e6f7..d6aa34d 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -1,5 +1,6 @@
>  config ARCH_MXC
>  	bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 || ARCH_MULTI_V6_V7
> +	select ARCH_HAS_CPUFREQ
>  	select ARCH_REQUIRE_GPIOLIB
>  	select ARM_CPU_SUSPEND if PM
>  	select ARM_PATCH_PHYS_VIRT
> @@ -9,8 +10,10 @@ config ARCH_MXC
>  	select GENERIC_ALLOCATOR
>  	select GENERIC_CLOCKEVENTS
>  	select GENERIC_IRQ_CHIP
> +	select HAVE_IMX_ANATOP if SOC_IMX6Q || SOC_IMX6SL
>  	select MIGHT_HAVE_CACHE_L2X0 if ARCH_MULTI_V6_V7
>  	select MULTI_IRQ_HANDLER
> +	select PM_OPP if PM
>  	select SOC_BUS
>  	select SPARSE_IRQ
>  	select USE_OF
> @@ -779,16 +782,14 @@ config	SOC_IMX53
>  
>  config SOC_IMX6Q
>  	bool "i.MX6 Quad/DualLite support"
> -	select ARCH_HAS_CPUFREQ
> -	select ARCH_HAS_OPP
> +	select ARCH_HAS_OPP	
>  	select ARM_ERRATA_754322
>  	select ARM_ERRATA_764369 if SMP
>  	select ARM_ERRATA_775420
>  	select ARM_GIC
>  	select CPU_V7
>  	select HAVE_ARM_SCU if SMP
> -	select HAVE_ARM_TWD if SMP
> -	select HAVE_IMX_ANATOP
> +	select HAVE_ARM_TWD if SMP	
>  	select HAVE_IMX_GPC
>  	select HAVE_IMX_MMDC
>  	select HAVE_IMX_SRC
> @@ -800,8 +801,7 @@ config SOC_IMX6Q
>  	select PINCTRL_IMX6Q
>  	select PL310_ERRATA_588369 if CACHE_PL310
>  	select PL310_ERRATA_727915 if CACHE_PL310
> -	select PL310_ERRATA_769419 if CACHE_PL310
> -	select PM_OPP if PM
> +	select PL310_ERRATA_769419 if CACHE_PL310	
>  
>  	help
>  	  This enables support for Freescale i.MX6 Quad processor.
> @@ -812,7 +812,6 @@ config SOC_IMX6SL
>  	select ARM_ERRATA_775420
>  	select ARM_GIC
>  	select CPU_V7
> -	select HAVE_IMX_ANATOP
>  	select HAVE_IMX_GPC
>  	select HAVE_IMX_MMDC
>  	select HAVE_IMX_SRC
> -- 
> 1.8.3.2
> 

