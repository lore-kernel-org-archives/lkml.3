Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbaISTDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:03:23 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:41540 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739AbaISTDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:03:21 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv4 01/12] usb: dwc2: Update Kconfig to support dual-role
Thread-Topic: [PATCHv4 01/12] usb: dwc2: Update Kconfig to support dual-role
Thread-Index: AQHPwUoTG0V0UOa4iEiY4yP+9i85Ppv+NSoAgAlvPQCAAYBTgP//yNZw
Date: Fri, 19 Sep 2014 19:02:49 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844D9C0D@US01WEMBX2.internal.synopsys.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
 <2539965.N1OFkvgc6j@amdc1032> <541B0030.3000904@opensource.altera.com>
 <2442120.cO7eVJ7tnO@amdc1032>
In-Reply-To: <2442120.cO7eVJ7tnO@amdc1032>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> Sent: Friday, September 19, 2014 7:50 AM
> 
> Unfortunately after second look there are even more problems with Kconfig
> changes, please see below.
> 
> > >
> > >>  if USB_DWC2
> > >>
> > >> +choice
> > >> +	bool "DWC2 Mode Selection"
> > >> +	default USB_DWC2_DUAL_ROLE if (USB && USB_GADGET)
> > >> +	default USB_DWC2_HOST if (USB && !USB_GADGET)
> > >> +	default USB_DWC2_PERIPHERAL if (!USB && USB_GADGET)
> 
> Previously it was possible to have following functionalities in
> one kernel (for multiplatform kernels):
> 
> - host PCI support
> - host platform support
> - gadget platform support
> 
> Now mode selection will determine the used mode for combined
> host+gadget platform driver.  It is no longer possible to have
> host platform and gadget platform support in one kernel.

Why not? Why wouldn't it work if you enable USB_DWC2_DUAL_ROLE? The
dwc3 driver uses the same scheme as this, and I have not heard any
complaints about that not working.
 
> Also there is only one mode selection for both PCI and platform
> drivers so it is no longer possible to have both gadget platform
> support and host PCI support in one kernel.

There will be, once I update the dwc2 PCI support to include the gadget
functionality. Then, if you enable USB_DWC2_DUAL_ROLE and DWC2_PCI, you
should be set.

In the meantime, I believe the only platform today that needs PCI support
for dwc2 is our internal Synopsys development board, which is not an ARM
platform. So I don't think there is a real issue here.

> I think it would be the best to replace global mode selection
> choice option with just two independent suboptions for combined
> host+gadget platform driver which will enable host and gadget
> support to be compiled into the driver (you would need to enable
> both for dual role support).  The actual selection of the mode
> used should be done at runtime using device tree.

See above. The dwc3 driver uses the same scheme as Dinh has implemented,
and I don't think there have been any problems with it.

-- 
Paul

