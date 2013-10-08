Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3JHXZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 19:25:06 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:21133 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755710Ab3JHXZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 19:25:03 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI936eI154dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275ch1de098h1de097h8275bh8275dhz2fh2a8h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1381274699.5184.2.camel@linux-builds1>
Subject: Re: [PATCH 8/8] ARM: add initial support for Marvell Berlin SoCs
From: Dinh Nguyen <dinguyen@altera.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Tue, 8 Oct 2013 18:24:59 -0500
In-Reply-To: <1381235073-17134-9-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com>
	 <1381235073-17134-9-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Tue, 2013-10-08 at 14:24 +0200, Sebastian Hesselbarth wrote:
> This adds initial support for the Marvell Berlin (88DE3xxx) SoC family
> and basic machine setup for Armada 1500 (88DE3100) SoCs.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reviewed-by: Jason Cooper <jason@lakedaemon.net>
> Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changelog:
> RFCv2->v1:
> - remove custom .init_time, adds dependency for arch-wide of_clk_init call
> RFCv1->RFCv2:
> - nuke .map_io (Reported by Arnd Bergmann)
> - add copyright reference
> - switch to mach-berlin instead of mach-mvebu
> 
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/Kconfig              |    2 ++
>  arch/arm/Makefile             |    1 +
>  arch/arm/mach-berlin/Kconfig  |   24 ++++++++++++++++++++++++
>  arch/arm/mach-berlin/Makefile |    1 +
>  arch/arm/mach-berlin/berlin.c |   39 +++++++++++++++++++++++++++++++++++++++
>  5 files changed, 67 insertions(+)
>  create mode 100644 arch/arm/mach-berlin/Kconfig
>  create mode 100644 arch/arm/mach-berlin/Makefile
>  create mode 100644 arch/arm/mach-berlin/berlin.c
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 1ad6fb6..5692426 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -932,6 +932,8 @@ source "arch/arm/mach-bcm/Kconfig"
>  
>  source "arch/arm/mach-bcm2835/Kconfig"
>  
> +source "arch/arm/mach-berlin/Kconfig"
> +
>  source "arch/arm/mach-clps711x/Kconfig"
>  
>  source "arch/arm/mach-cns3xxx/Kconfig"
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index a37a50f..3ba332b 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -147,6 +147,7 @@ textofs-$(CONFIG_ARCH_MSM8960) := 0x00208000
>  machine-$(CONFIG_ARCH_AT91)		+= at91
>  machine-$(CONFIG_ARCH_BCM)		+= bcm
>  machine-$(CONFIG_ARCH_BCM2835)		+= bcm2835
> +machine-$(CONFIG_ARCH_BERLIN)		+= berlin
>  machine-$(CONFIG_ARCH_CLPS711X)		+= clps711x
>  machine-$(CONFIG_ARCH_CNS3XXX)		+= cns3xxx
>  machine-$(CONFIG_ARCH_DAVINCI)		+= davinci
> diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
> new file mode 100644
> index 0000000..56a671e
> --- /dev/null
> +++ b/arch/arm/mach-berlin/Kconfig
> @@ -0,0 +1,24 @@
> +config ARCH_BERLIN
> +	bool "Marvell Berlin (88DE3xxx) SoCs" if ARCH_MULTI_V7
> +	select GENERIC_CLOCKEVENTS
> +	select GENERIC_IRQ_CHIP
> +	select COMMON_CLK
> +	select DW_APB_ICTL
> +	select DW_APB_TIMER_OF
> +
> +if ARCH_BERLIN
> +
> +menu "Marvell Berlin (88DE3xxx) SoC variants"
> +
> +config MACH_MV88DE3100
> +	bool "Marvell 88DE3100 (Armada 1500)"
> +	select ARM_GIC
> +	select CACHE_L2X0
> +	select CPU_PJ4B
> +	select HAVE_ARM_TWD if LOCAL_TIMERS
> +	select HAVE_SMP
> +	select LOCAL_TIMERS if SMP

I think because of commit: 

a894fcc2d [ARM: smp_twd: Divorce smp_twd from local timer API]

you can remove the LOCAL_TIMERS for HAVE_ARM_TWD.

Dinh


