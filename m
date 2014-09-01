Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaIAKBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:01:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48975 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbaIAKBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:01:40 -0400
X-AuditID: cbfee61b-f79f86d00000144c-fc-54044401e276
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
Date: Mon, 01 Sep 2014 12:01:35 +0200
Message-id: <140959597.EmCWO5CWP9@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140829183304.GB9380@kroah.com>
References: <2141307.zYQLjP6V6U@amdc1032> <2682311.psIh2sovYX@amdc1032>
 <20140829183304.GB9380@kroah.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jQV0mF5YQg997WC0O3q+3aLtykN2i
	efF6NoveBVfZLM42vWG3uLxrDpvFjPP7mCwWLWtltjh1/TObxYTfF9gcuDz2z13D7nHlRBOr
	x+y7Pxg9+rasYvQ4fmM7k8fnTXIBbFFcNimpOZllqUX6dglcGVdePmMp2KJa8a79CmMD40WZ
	LkZODgkBE4l7H+cxQdhiEhfurWcDsYUEpjNKdC5x6WLkArJbmCRO7e1mBUmwCVhJTGxfxQhi
	iwgYS/SfncUOUsQssIJZ4tbEV2BFwgJuEt3XrwDZHBwsAqoSc/6Zg4R5BbQlbvfdYwGxRQU8
	JXZsXwm2jFNAT6Lt81MWiMXZEqvXfGGGqBeU+DEZop5ZQF5i3/6prBC2lsT6nceZJjAKzEJS
	NgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfCM+kdjKsaLA4xCnAwKvHw
	PpjFHCLEmlhWXJl7iFGCg1lJhLfQkSVEiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0
	xJLU7NTUgtQimCwTB6dUAyOr6pnD156vN2kIaJFULwu5fcBf78mdI0uFHnyMjDw2/1ap+Vyn
	mztMppaJOUSy5q1IFmBcNfnw/lNvZzO7RisFcsr/qhJS5s+MkLI+qbJKVG4T2+MkrnxhjtqZ
	H5vZVZ5MCJB+P/twS3BuhqHSY5ErK4UUbn2QO9S3183BvUfl4FfpfVNko5RYijMSDbWYi4oT
	AapmV4aBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, August 29, 2014 11:33:04 AM Greg Kroah-Hartman wrote:
> On Fri, Aug 29, 2014 at 11:02:52AM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday, August 28, 2014 12:29:52 PM Greg Kroah-Hartman wrote:
> > > On Thu, Aug 28, 2014 at 08:11:04PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > 
> > > > [ added Alan and Greg to cc: ]
> > > > 
> > > > Hi,
> > > > 
> > > > On Wednesday, August 27, 2014 11:42:25 PM Vivek Gautam wrote:
> > > > > Hi Baltlomiej,
> > > > > 
> > > > > 
> > > > > On Wed, Aug 27, 2014 at 1:22 PM, Bartlomiej Zolnierkiewicz
> > > > > <b.zolnierkie@samsung.com> wrote:
> > > > > > dwc3 driver is using the new Exynos5 SoC series USB DRD PHY driver
> > > > > > (PHY_EXYNOS5_USBDRD which selects GENERIC_PHY) as can be seen by
> > > > > > looking at the following commits:
> > > > > >
> > > > > >   7a4cf0fde054 ("ARM: dts: Update DWC3 usb controller to use new
> > > > > >   phy driver for exynos5250")
> > > > > >
> > > > > >   f070267b5fc1 ("ARM: dts: Enable support for DWC3 controller for
> > > > > >   exynos5420")
> > > > > >
> > > > > > Thus remove unused usb_phy_generic support from dwc3 Exynos glue
> > > > > > layer.
> > > > > >
> > > > > > [ The code that is being removed is harmful in the context of
> > > > > >   multi_v7_defconfig and enabling "EHCI support for Samsung
> > > > > >   S5P/EXYNOS SoC Series" (USB_EHCI_EXYNOS) + "OHCI support for
> > > > > >   Samsung S5P/EXYNOS SoC Series" (USB_OHCI_EXYNOS) because "EHCI
> > > > > >   support for OMAP3 and later chips" (USB_EHCI_HCD_OMAP) selects
> > > > > >   "NOP USB Transceiver Driver" (NOP_USB_XCEIV).  NOP USB driver
> > > > > >   attaches itself to usb_phy_generic platform devices created by
> > > > > >   dwc3 Exynos glue layer and later causes Exynos EHCI driver to
> > > > > >   fail probe and Exynos OHCI driver to hang on probe (as observed
> > > > > >   on Exynos5250 Arndale board). ]
> > > > > 
> > > > > The issue with EHCI and OHCI on exynos platforms is that until now
> > > > > they also request
> > > > > usb-phy and only later if they don't find one, they go ahead and get a
> > > > > 'phy' generic.
> > > > > 
> > > > > Fortunately we missed this issue with exynos_defconfig, and as you rightly
> > > > > mentioned with multi_v7_defconfig, the NOP_USB_XCEIV gets enabled and
> > > > > EHCI and OHCI exynos get no-op usb-phy, which actually blocks EHCI/OHCI from
> > > > > initializing the real PHYs.
> > > > > 
> > > > > This issue is resolved with patches:
> > > > > [PATCH v2 1/2] usb: host: ehci-exynos: Remove unnecessary usb-phy support
> > > > > [PATCH v2 2/2] usb: host: ohci-exynos: Remove unnecessary usb-phy support
> > > > > wherein we are completely removing the usb-phy support from ehci/ohci-exynos.
> > > > > So with these patches we should not see the issue mentioned by you.
> > > > 
> > > > Indeed, your patches fix the issue.
> > > > 
> > > > Greg, could these two patches ([1] & [2]) get merged quickly, pretty please
> > > > (they were already acked by Alan)?  They are not a mere cleanups because
> > > > they fix the actual problem with using multi_v7_defconfig which in turn has
> > > > been blocking Olof's defconfig update patch [3] for quite some time now.
> > > > Moreover these patches are limited to Exynos host drivers so they should be
> > > > pretty safe when it comes to potential regressions.
> > > > 
> > > > [1] http://www.spinics.net/lists/linux-usb/msg112294.html
> > > > [2] http://www.spinics.net/lists/linux-usb/msg112293.html
> > > > [3] http://www.spinics.net/lists/arm-kernel/msg349654.html
> > > 
> > > merged for 3.18-rc1, or do you "need" them for 3.17-final?
> > 
> > If it is not too much trouble please push them to 3.17-final.
> 
> They don't meet the "regression or bugfix" rule at all, so I can't do
> this, sorry.  I'll queue them up for 3.18.

These patches fix a real problem of boot hang when enabling Exynos USB
host drivers and using ARM multiplatform config so IMHO they fall into
bugfix category.

> > > I already reverted one patch for exynos for 3.17-final that is sitting
> > > in my tree to go to Linus soon as you all didn't seem to want it
> > > anymore, so I'm getting really confused here...
> > 
> > These two patches are a replacement for the one reverted and
> > they just remove the old code instead of keeping it as fallback.
> > This means that the reverted patch was not breaking anything and
> > these two new patches could have been also done as incremental
> > ones.  Sorry for the confusion.
> 
> As they came in too late for 3.17-rc1, they will have to wait for
> 3.18-rc1.

Okay..

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

