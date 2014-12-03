Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaLCK5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:57:20 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:54216 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaLCK5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:57:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stefan Agner <stefan@agner.ch>, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] ARM: vf610m4: add new machine and SoC for Vybrid on Cortex-M4
Date: Wed, 03 Dec 2014 11:56:29 +0100
Message-ID: <2188062.Vg1qCai6yo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417565531-4507-11-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <1417565531-4507-11-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Vt4YjZ6hfMxOyYfFBfuxVNP/fBsxBDJ9j7z70GNNwRf
 ax8qcrjQeXBxjt25rGSZs4cfPhf7rNpCd2oVtfqrnBRKZ21y/B
 wHAOqSFoARWbluwTyI49UmSocmQMN+QSXuKbrCqE43Gi5vhMmX
 bzCszDoJAkb3ph9NQyGZdbdsFA7SybaBIJwLCdSofZh4ZEfEyF
 g2/R8aIuQSpeIIKzJrbUtWRlV9ILyOL2bC/J64xNfcNatCM5Ss
 M6oGYUThrjGcGZVXGZGdTrNZSuXidvKIBGdtRdsKnfIjYBkjXz
 K8FYQYofXvatbrhDtpglvb4VUVriaykXmeXDqlMoGRH+9y925w
 wzyyiPFoom1vxOPRXeNI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 01:12:09 Stefan Agner wrote:
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 89c4b5c..fdebe18 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -459,6 +459,18 @@ config ARCH_FOOTBRIDGE
>  	  Support for systems based on the DC21285 companion chip
>  	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
>  
> +menuconfig ARCH_MXCM4
> +	bool "Freescale Vybrid/i.MX family on Cortex-M4" if !MMU
> +	select ARCH_REQUIRE_GPIOLIB
> +	select ARM_CPU_SUSPEND if PM
> +	select CLKSRC_MMIO
> +	select GENERIC_IRQ_CHIP
> +	select PINCTRL
> +	select PM_OPP if PM
> +	select SOC_BUS
> +	help
> +	  Support for Freescale Vybrid/iMX-based family of processors on Cortex-M4
> +
>  config ARCH_NETX
>  	bool "Hilscher NetX based"
>  	select ARM_VIC

I would really prefer not to see any more standalone machine types,
but rather have ARMv7-M as one of the options for the
multiplatform configuration. In particular, that would let us
do *build* testing on a combined mxcm4/efm32/vexpress kernel,
although that kernel would clearly not be usable anywhere
because of the restrictions of nommu machines.

> +static void __init vf610m4_init_irq(void)
> +{
> +	vf610_mscm_init();
> +	irqchip_init();
> +}

Can you make vf610_mscm_init get called from irqchip and remove this
function?

	Arnd
