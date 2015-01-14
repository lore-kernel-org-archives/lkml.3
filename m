Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbbANNpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:45:54 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:33371 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbbANNpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:45:52 -0500
Message-ID: <54B6730E.3060709@atmel.com>
Date: Wed, 14 Jan 2015 14:45:50 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] ARM: at91/dt: select DUMB_IRQ_DEMUX for all at91
 SoCs
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com> <1421174781-4340-4-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1421174781-4340-4-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/01/2015 19:46, Boris Brezillon a écrit :
> at91 SoCs need an dumb irq demuxer to gracefully support the fact that

"Older AT91 SoCs" please ;-)

Nit.: "an dumb demuxer" => "a virtual dumb demuxer"

> irq1 is shared by several devices and a timer.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

As the newer SoCs don't need it, we can't select this option for the
whole CONFIG_ARCH_AT91, so indeed:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  arch/arm/mach-at91/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 2395c68..8ff2c2a 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -28,6 +28,7 @@ config HAVE_AT91_H32MX
>  config SOC_AT91SAM9
>  	bool
>  	select ATMEL_AIC_IRQ
> +	select DUMB_DEMUX_IRQ
>  	select COMMON_CLK_AT91
>  	select CPU_ARM926T
>  	select GENERIC_CLOCKEVENTS
> @@ -98,6 +99,7 @@ if SOC_SAM_V4_V5
>  config SOC_AT91RM9200
>  	bool "AT91RM9200"
>  	select ATMEL_AIC_IRQ
> +	select DUMB_DEMUX_IRQ
>  	select COMMON_CLK_AT91
>  	select CPU_ARM920T
>  	select GENERIC_CLOCKEVENTS
> 


-- 
Nicolas Ferre
