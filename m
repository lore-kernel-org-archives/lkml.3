Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3JGKFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:05:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44711 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab3JGKFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:05:14 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-6d-52528758e705
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] thermal: offer TI thermal support only when ARCH_OMAP2PLUS
 is defined
Date: Mon, 07 Oct 2013 12:05:05 +0200
Message-id: <24683815.qjRRgfGo3Z@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <524F086E.4020608@ti.com>
References: <3702969.8rn3SOscJE@amdc1032> <524F0766.8070302@ti.com>
 <524F086E.4020608@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQd2I9qAggx3bjCz+TjrGbrFm/08m
	i7NNb9gtLu+aw2bxufcIo8WTh31sDmwev39NYvRYvOclk0ffllWMHsdvbGfy+LxJLoA1issm
	JTUnsyy1SN8ugSvjz7UGxoL7whXPn8Y2MP7g72Lk5JAQMJFY0v+dGcIWk7hwbz1bFyMXh5DA
	dEaJR6uaWSGcFiaJmQ+2MYFUsQlYSUxsX8UIYosI6EncePGECaSIWWAlo8SOrpPsIAlhgRiJ
	aQdawRpYBFQlJtyYxgJi8wpoSZyduxesWVTAU+LTpKVgqzkF1CR+LGgA6xUSiJdYs+gEI0S9
	oMSPyffAepkF5CX27Z/KCmHrSOxvncY2gVFgFpKyWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84
	Mbe4NC9dLzk/dxMjOLifSe1gXNlgcYhRgINRiYd3x/3AICHWxLLiytxDjBIczEoivD2tQUFC
	vCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGM2Wzp/++mNI
	gMsd4aMPf73WdhT4Y+YxS8r4zQLjx0+fSK69++6MUlF5n1H2x9+a5zasfLpk1ZuTJQ+nCBbW
	ywWvX/pm6jOPuXeOvD61NEbqcPCDKStvTf78RU+q7/id5vdpt3s3M1587ywhEJRTeCeHITii
	5rNF4U8TI8v+7e7skXs/CG67a7lSiaU4I9FQi7moOBEAa8KLNmoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 04, 2013 02:26:54 PM Eduardo Valentin wrote:
> On 04-10-2013 14:22, Eduardo Valentin wrote:
> > On 04-10-2013 08:35, Bartlomiej Zolnierkiewicz wrote:
> >> Menu for Texas Instruments thermal support is visible on all
> >> platforms and TI_SOC_THERMAL + TI_THERMAL config options can
> >> be selected also on EXYNOS platform (on which ARCH_HAS_BANDGAP
> >> config option is selected by SoCs config options to fulfill
> >> EXYNOS_THERMAL config option dependency). Thus the code which
> >> is never used can be build. Fix it by making TI menu dependent
> >> on ARCH_OMAP2PLUS config option.
> >>
> 
> 
> Besides, you can always disable the driver if you are not interested in
> compiling it.

You should not have TI-specific drivers visible without any TI dependencies.
ARCH_BANDGAP dependency is not enough, ARCH_BANDGAP is also used by EXYNOS
to indicate thermal support. Currently you can select TI thermal drivers on
EXYNOS platforms without any other dependencies on TI. This is just wrong,
it can result in unused code being build currently but can result in more
severe problems in the future (build break).

> >> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >>  drivers/thermal/Kconfig | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> >> index 57e06a9..a709c63 100644
> >> --- a/drivers/thermal/Kconfig
> >> +++ b/drivers/thermal/Kconfig
> >> @@ -193,6 +193,7 @@ config X86_PKG_TEMP_THERMAL
> >>  	  notification methods.
> >>  
> >>  menu "Texas Instruments thermal drivers"
> >> +depends on ARCH_OMAP2PLUS
> > 
> > No, this driver is not for ARCH_OMAP*, but for TI bandgap, with the
> > option to offer thermal control. So, the HW supported is TI bandgap IP,
> > not ARCH_OMAP*. It happens to be so that OMAP2PLUS all have a
> > (different) version of this device.
> > 
> > However, DRA7 devices, for instance, also feature the bandgap IP
> > (different version of those present in OMAP devices), and it is not
> > ARCH_OMAP2PLUS.
> > 
> > And because of that, the design of this driver is different. It is not
> > expected to depend on an arch, but the arch code is expected to select
> > ARCH_HAS_BANDGAP.
> > 
> >>  source "drivers/thermal/ti-soc-thermal/Kconfig"
> >>  endmenu

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

