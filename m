Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaH2JDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:03:02 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60617 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaH2JC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:02:58 -0400
X-AuditID: cbfee61b-f79f86d00000144c-c3-540041be64aa
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: dwc3: exynos: remove usb_phy_generic support
Date: Fri, 29 Aug 2014 11:02:52 +0200
Message-id: <2682311.psIh2sovYX@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140828192952.GA31255@kroah.com>
References: <2141307.zYQLjP6V6U@amdc1032> <44042073.hjFrXas7t7@amdc1032>
 <20140828192952.GA31255@kroah.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jAd19jgwhBnuP6FscvF9v0XblILtF
	8+L1bBa9C66yWZxtesNucXnXHDaLGef3MVksWtbKbHHq+mc2iwm/L7A5cHnsn7uG3ePKiSZW
	j9l3fzB69G1Zxehx/MZ2Jo/Pm+QC2KK4bFJSczLLUov07RK4Mn6f8yt4Jlex+0QHcwPjZIku
	Rk4OCQETiTldZ5ghbDGJC/fWs3UxcnEICSxilLi0/wOU08Ik0XLlAVgVm4CVxMT2VYwgtoiA
	sUT/2VnsIEXMAiuYJW5NfMUKkhAWcJPovn4FzGYRUJWYeOAvWAOvgKbEl2O9TCC2qICnxI7t
	K9lAbE4BfYnN53eC1QsJ5Erc2LeaGaJeUOLH5HssIDazgLzEvv1TWSFsLYn1O48zTWAUmIWk
	bBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI6GZ9I7GFc1WBxiFOBgVOLh
	7Tj5P1iINbGsuDL3EKMEB7OSCO9xQ4YQId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTS
	E0tSs1NTC1KLYLJMHJxSDYyBV2r4448d3cZ4Zt8tgeyZ79eEzjmenGCTY3edRe2MskhitI3H
	p5kFq2UuzDnkZxdRs7GeJyN65skw+awTndmTHhp6HtsScWG9pWVbs/2+k8eSPPf5FEzoP5yT
	o6xamVH6NEjruovLoZBJjVxmLWee8HX7/pq60e7ySu2gpqrM6BidBoOJ05RYijMSDbWYi4oT
	AeVv3YWCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 28, 2014 12:29:52 PM Greg Kroah-Hartman wrote:
> On Thu, Aug 28, 2014 at 08:11:04PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > [ added Alan and Greg to cc: ]
> > 
> > Hi,
> > 
> > On Wednesday, August 27, 2014 11:42:25 PM Vivek Gautam wrote:
> > > Hi Baltlomiej,
> > > 
> > > 
> > > On Wed, Aug 27, 2014 at 1:22 PM, Bartlomiej Zolnierkiewicz
> > > <b.zolnierkie@samsung.com> wrote:
> > > > dwc3 driver is using the new Exynos5 SoC series USB DRD PHY driver
> > > > (PHY_EXYNOS5_USBDRD which selects GENERIC_PHY) as can be seen by
> > > > looking at the following commits:
> > > >
> > > >   7a4cf0fde054 ("ARM: dts: Update DWC3 usb controller to use new
> > > >   phy driver for exynos5250")
> > > >
> > > >   f070267b5fc1 ("ARM: dts: Enable support for DWC3 controller for
> > > >   exynos5420")
> > > >
> > > > Thus remove unused usb_phy_generic support from dwc3 Exynos glue
> > > > layer.
> > > >
> > > > [ The code that is being removed is harmful in the context of
> > > >   multi_v7_defconfig and enabling "EHCI support for Samsung
> > > >   S5P/EXYNOS SoC Series" (USB_EHCI_EXYNOS) + "OHCI support for
> > > >   Samsung S5P/EXYNOS SoC Series" (USB_OHCI_EXYNOS) because "EHCI
> > > >   support for OMAP3 and later chips" (USB_EHCI_HCD_OMAP) selects
> > > >   "NOP USB Transceiver Driver" (NOP_USB_XCEIV).  NOP USB driver
> > > >   attaches itself to usb_phy_generic platform devices created by
> > > >   dwc3 Exynos glue layer and later causes Exynos EHCI driver to
> > > >   fail probe and Exynos OHCI driver to hang on probe (as observed
> > > >   on Exynos5250 Arndale board). ]
> > > 
> > > The issue with EHCI and OHCI on exynos platforms is that until now
> > > they also request
> > > usb-phy and only later if they don't find one, they go ahead and get a
> > > 'phy' generic.
> > > 
> > > Fortunately we missed this issue with exynos_defconfig, and as you rightly
> > > mentioned with multi_v7_defconfig, the NOP_USB_XCEIV gets enabled and
> > > EHCI and OHCI exynos get no-op usb-phy, which actually blocks EHCI/OHCI from
> > > initializing the real PHYs.
> > > 
> > > This issue is resolved with patches:
> > > [PATCH v2 1/2] usb: host: ehci-exynos: Remove unnecessary usb-phy support
> > > [PATCH v2 2/2] usb: host: ohci-exynos: Remove unnecessary usb-phy support
> > > wherein we are completely removing the usb-phy support from ehci/ohci-exynos.
> > > So with these patches we should not see the issue mentioned by you.
> > 
> > Indeed, your patches fix the issue.
> > 
> > Greg, could these two patches ([1] & [2]) get merged quickly, pretty please
> > (they were already acked by Alan)?  They are not a mere cleanups because
> > they fix the actual problem with using multi_v7_defconfig which in turn has
> > been blocking Olof's defconfig update patch [3] for quite some time now.
> > Moreover these patches are limited to Exynos host drivers so they should be
> > pretty safe when it comes to potential regressions.
> > 
> > [1] http://www.spinics.net/lists/linux-usb/msg112294.html
> > [2] http://www.spinics.net/lists/linux-usb/msg112293.html
> > [3] http://www.spinics.net/lists/arm-kernel/msg349654.html
> 
> merged for 3.18-rc1, or do you "need" them for 3.17-final?

If it is not too much trouble please push them to 3.17-final.

> I already reverted one patch for exynos for 3.17-final that is sitting
> in my tree to go to Linus soon as you all didn't seem to want it
> anymore, so I'm getting really confused here...

These two patches are a replacement for the one reverted and
they just remove the old code instead of keeping it as fallback.
This means that the reverted patch was not breaking anything and
these two new patches could have been also done as incremental
ones.  Sorry for the confusion.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

