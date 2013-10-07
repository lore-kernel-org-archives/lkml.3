Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3JGKvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:51:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50296 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3JGKv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:51:28 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-64-5252922e0e73
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] thermal: offer TI thermal support only when ARCH_OMAP2PLUS
 is defined
Date: Mon, 07 Oct 2013 12:51:18 +0200
Message-id: <1777775.ZWYXb1l2UF@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <24683815.qjRRgfGo3Z@amdc1032>
References: <3702969.8rn3SOscJE@amdc1032> <524F086E.4020608@ti.com>
 <24683815.qjRRgfGo3Z@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAV29SUFBBiubVSz+TjrGbrFm/08m
	i7NNb9gtLu+aw2bxufcIo8WTh31sDmwev39NYvRYvOclk0ffllWMHsdvbGfy+LxJLoA1issm
	JTUnsyy1SN8ugSvjw9SNjAXvxSpufz3D1sA4Q6iLkZNDQsBEYvex00wQtpjEhXvr2boYuTiE
	BBYxSvRN3ccI4bQwSZw+9pYFpIpNwEpiYvsqRhBbREBP4saLJ0wgRcwCKxkldnSdZAdJCAvE
	SEw70Ao2lkVAVeLZ/oWsIDavgKbE0o+rwAaJCnhKfJq0lBnE5hTQlnj6YRdYr5BAisTfjQ+Z
	IOoFJX5MvgdWzywgL7Fv/1RWCFtHYn/rNLYJjAKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blG
	esWJucWleel6yfm5mxjB4f1MegfjqgaLQ4wCHIxKPLw77gcGCbEmlhVX5h5ilOBgVhLh7WkN
	ChLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAyGiZ/+jo
	hHdMhVHhn4PuZ5dOOiPE80UpeGPrktxV+3WLO+YUVmYuVw1OKk3frd34W0qE54XvYp+bEwRU
	WZ+cO8bnUiDvY9i0YNmkz1/t+8U+n7m+adcDqRdO+0TvG1T3ZWo+qfxUubbjDM/0M0KlGw2s
	909oV8/POOy/J+MC+4bAq4YZUxLNlViKMxINtZiLihMBZjm/TmsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 07, 2013 12:05:05 PM Bartlomiej Zolnierkiewicz wrote:
> On Friday, October 04, 2013 02:26:54 PM Eduardo Valentin wrote:
> > On 04-10-2013 14:22, Eduardo Valentin wrote:
> > > On 04-10-2013 08:35, Bartlomiej Zolnierkiewicz wrote:
> > >> Menu for Texas Instruments thermal support is visible on all
> > >> platforms and TI_SOC_THERMAL + TI_THERMAL config options can
> > >> be selected also on EXYNOS platform (on which ARCH_HAS_BANDGAP
> > >> config option is selected by SoCs config options to fulfill
> > >> EXYNOS_THERMAL config option dependency). Thus the code which
> > >> is never used can be build. Fix it by making TI menu dependent
> > >> on ARCH_OMAP2PLUS config option.
> > >>
> > 
> > 
> > Besides, you can always disable the driver if you are not interested in
> > compiling it.
> 
> You should not have TI-specific drivers visible without any TI dependencies.
> ARCH_BANDGAP dependency is not enough, ARCH_BANDGAP is also used by EXYNOS

s/ARCH_BANDGAP/ARCH_HAS_BANDGAP/ of course

> to indicate thermal support. Currently you can select TI thermal drivers on
> EXYNOS platforms without any other dependencies on TI. This is just wrong,
> it can result in unused code being build currently but can result in more
> severe problems in the future (build break).

Arnd, could you please give your opinion on the issue?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

 
> > >> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > >> ---
> > >>  drivers/thermal/Kconfig | 1 +
> > >>  1 file changed, 1 insertion(+)
> > >>
> > >> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > >> index 57e06a9..a709c63 100644
> > >> --- a/drivers/thermal/Kconfig
> > >> +++ b/drivers/thermal/Kconfig
> > >> @@ -193,6 +193,7 @@ config X86_PKG_TEMP_THERMAL
> > >>  	  notification methods.
> > >>  
> > >>  menu "Texas Instruments thermal drivers"
> > >> +depends on ARCH_OMAP2PLUS
> > > 
> > > No, this driver is not for ARCH_OMAP*, but for TI bandgap, with the
> > > option to offer thermal control. So, the HW supported is TI bandgap IP,
> > > not ARCH_OMAP*. It happens to be so that OMAP2PLUS all have a
> > > (different) version of this device.
> > > 
> > > However, DRA7 devices, for instance, also feature the bandgap IP
> > > (different version of those present in OMAP devices), and it is not
> > > ARCH_OMAP2PLUS.
> > > 
> > > And because of that, the design of this driver is different. It is not
> > > expected to depend on an arch, but the arch code is expected to select
> > > ARCH_HAS_BANDGAP.
> > > 
> > >>  source "drivers/thermal/ti-soc-thermal/Kconfig"
> > >>  endmenu
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics

