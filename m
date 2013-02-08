Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960Ab3BHGkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:40:00 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8613 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3BHGj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:39:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Feb 2013 22:39:29 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, kishon <kishon@ti.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Fri, 8 Feb 2013 12:09:47 +0530
Subject: RE: [PATCH v3] usb: phy: moving all PHY API definitions to usb/phy
 directory
Thread-Topic: [PATCH v3] usb: phy: moving all PHY API definitions to usb/phy
 directory
Thread-Index: Ac4FVBkzoFR9k8qtRE+9hp7lvDck+gAclmVQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6E1B6C6DAD@BGMAIL02.nvidia.com>
References: <1360236751-23183-1-git-send-email-vbyravarasu@nvidia.com>
 <5113AE42.8090401@ti.com> <5113DCAC.6080003@wwwdotorg.org>
In-Reply-To: <5113DCAC.6080003@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Stephen Warren
> Sent: Thursday, February 07, 2013 10:26 PM
> To: kishon
> Cc: Venu Byravarasu; balbi@ti.com; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH v3] usb: phy: moving all PHY API definitions to usb/phy
> directory
> 
> On 02/07/2013 06:38 AM, kishon wrote:
> > On Thursday 07 February 2013 05:02 PM, Venu Byravarasu wrote:
> >> As drivers/usb/otg/otg.c contains most of the PHY related APIs which
> >> are not OTG specific, moving them to more logical place under
> >> drivers/usb/phy.
> 
> >> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> >> index b13faa1..886be13 100644
> >> --- a/drivers/usb/phy/Makefile
> >> +++ b/drivers/usb/phy/Makefile
> >> @@ -4,6 +4,7 @@
> >>
> >>   ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG
> >>
> >> +obj-$(CONFIG_USB_COMMON)            += phy.o
> >
> > I think we should have a separate config for PHYs. There might be
> > controllers which dont need separate PHY. But we can have that as a
> > separate patch later since we might want to change the Kconfig of other
> > UDC drivers.

Thanks Kishon for review comments.
Agree to your comments that we can add a new config for PHY & push it in a separate patch. 

> 
> >> +/*
> >> + * phy.c -- USB PHY utility code
> >> + *
> >> + * Copyright (C) 2004 Texas Instruments
> >
> > You can update this to 2013.
> 
> I'm not sure if anyone other that TI can do that?
> 
> >> +EXPORT_SYMBOL_GPL(usb_bind_phy);
> >> +
> >> +
> >
> > Unnecessary spaces here.
> 

Will remove them in next patch update. 

> Thanks for the review. It was very difficult to find you review comments
> since you quoted the entire patch rather than just the few pieces you
> were commenting on...
> 
> > You might want to do this patch after applying *[PATCH] usb: otg: use
> > try_module_get in all usb_get_phy functions and add missing module_put*
> > by Marc.
> 
> Venu, please make sure you include the changes in that patch in your
> Tegra USB/PHY driver rework too, before you post it upstream.

Sure Stephen, thanks for your comments.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
