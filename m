Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab3JGJ5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 05:57:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33522 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3JGJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:57:43 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-9c-525285952dde
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] thermal: offer TI thermal support only when ARCH_OMAP2PLUS
 is defined
Date: Mon, 07 Oct 2013 11:57:16 +0200
Message-id: <5727785.7GtnvaVLcG@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <524F0766.8070302@ti.com>
References: <3702969.8rn3SOscJE@amdc1032> <524F0766.8070302@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQd2prUFBBpNa9Cz+TjrGbrFm/08m
	i7NNb9gtLu+aw2bxufcIo8WTh31sDmwev39NYvRYvOclk0ffllWMHsdvbGfy+LxJLoA1issm
	JTUnsyy1SN8ugSvjzZIvLAVPpCp6Xq9gaWDcIdLFyMkhIWAiMXXDVGYIW0ziwr31bCC2kMB0
	Ronf78K7GLmA7BYmiYvfGlhAEmwCVhIT21cxgtgiAnoSN148YQIpYhZYySixo+skO0hCWCBG
	YtqBViYQm0VAVaJj0m6wZl4BTYmlB/vBbFEBT4lPk5aCbeYUUJOY8HMfO8RmZ4mGxefYIeoF
	JX5MvgdWzywgL7Fv/1RWCFtHYn/rNLYJjAKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJ
	ucWleel6yfm5mxjBwf1MegfjqgaLQ4wCHIxKPLw77gcGCbEmlhVX5h5ilOBgVhLhXdMcFCTE
	m5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBcU2DBlNAE69e
	7PHOqXnuO5qDk1zeKM8q53zzb/run5nHAtlz5Y9dW7B3s7XDjbWOYppefczRcVOs/TgDTXKz
	7qr9ucnIILPmLYtTptNCjh0lWov/WWxKFf+hZTnV9GTlLueAHrmDUy/fe7jfLD7gU2FbrNNN
	k/r9ay6k227cM6f7/TO+mze2K7EUZyQaajEXFScCAFgOjyZqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, October 04, 2013 02:22:30 PM Eduardo Valentin wrote:
> On 04-10-2013 08:35, Bartlomiej Zolnierkiewicz wrote:
> > Menu for Texas Instruments thermal support is visible on all
> > platforms and TI_SOC_THERMAL + TI_THERMAL config options can
> > be selected also on EXYNOS platform (on which ARCH_HAS_BANDGAP
> > config option is selected by SoCs config options to fulfill
> > EXYNOS_THERMAL config option dependency). Thus the code which
> > is never used can be build. Fix it by making TI menu dependent
> > on ARCH_OMAP2PLUS config option.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/thermal/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > index 57e06a9..a709c63 100644
> > --- a/drivers/thermal/Kconfig
> > +++ b/drivers/thermal/Kconfig
> > @@ -193,6 +193,7 @@ config X86_PKG_TEMP_THERMAL
> >  	  notification methods.
> >  
> >  menu "Texas Instruments thermal drivers"
> > +depends on ARCH_OMAP2PLUS
> 
> No, this driver is not for ARCH_OMAP*, but for TI bandgap, with the
> option to offer thermal control. So, the HW supported is TI bandgap IP,
> not ARCH_OMAP*. It happens to be so that OMAP2PLUS all have a
> (different) version of this device.
> 
> However, DRA7 devices, for instance, also feature the bandgap IP
> (different version of those present in OMAP devices), and it is not
> ARCH_OMAP2PLUS.

Then you have wrong dependencies anyway since ARCH_BANDGAP is selected
currently only by ARCH_OMAP2PLUS and EXYNOS SoCs.

arch/arm/mach-omap2/Kconfig (next-20130927):

config ARCH_OMAP2PLUS
        bool
        select ARCH_HAS_BANDGAP
        select ARCH_HAS_CPUFREQ
        select ARCH_HAS_HOLES_MEMORYMODEL
        select ARCH_OMAP
        select ARCH_REQUIRE_GPIOLIB
        select CLKDEV_LOOKUP
        select CLKSRC_MMIO
        select GENERIC_CLOCKEVENTS
        select GENERIC_IRQ_CHIP
        select HAVE_CLK
        select OMAP_DM_TIMER
        select PINCTRL
        select PROC_DEVICETREE if PROC_FS
        select SOC_BUS
        select SPARSE_IRQ
        select TI_PRIV_EDMA
        select USE_OF
        help
          Systems based on OMAP2, OMAP3, OMAP4 or OMAP5

drivers/thermal/ti-soc-thermal/Kconfig (next-20130927):

config TI_SOC_THERMAL
        tristate "Texas Instruments SoCs temperature sensor driver"
        depends on THERMAL
        depends on ARCH_HAS_BANDGAP
        help
          If you say yes here you get support for the Texas Instruments
          OMAP4460+ on die bandgap temperature sensor support. The register
          set is part of system control module.

          This includes alert interrupts generation and also the TSHUT
          support.

> And because of that, the design of this driver is different. It is not
> expected to depend on an arch, but the arch code is expected to select
> ARCH_HAS_BANDGAP.

There should be additional dependencies beside ARCH_BANDGAP, i.e. on
EXYNOS platforms we currently also have dependency on PLAT_SAMSUNG
(should be ARCH_EXYNOS instead, my other patch fixes it).

> >  source "drivers/thermal/ti-soc-thermal/Kconfig"
> >  endmenu

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

