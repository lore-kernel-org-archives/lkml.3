Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaIVQKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:10:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45044 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaIVQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:10:11 -0400
X-AuditID: cbfee61a-f79c06d000004e71-1d-542049e1737f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Subject: Re: [PATCHv4 01/12] usb: dwc2: Update Kconfig to support dual-role
Date: Mon, 22 Sep 2014 18:10:04 +0200
Message-id: <33607368.413ZH3sNbT@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <A2CA0424C0A6F04399FB9E1CD98E0304844D9C0D@US01WEMBX2.internal.synopsys.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
 <2442120.cO7eVJ7tnO@amdc1032>
 <A2CA0424C0A6F04399FB9E1CD98E0304844D9C0D@US01WEMBX2.internal.synopsys.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t9jQd2HngohBn9uGlkcvF9vMWndASaL
	s8sOslms+rSG2WLlSW2L5sXr2SwuL7zEarFt+k8ga9ccNotFy1qZLRa+vsZi8ejhVlaLB4d3
	sluc/NPLaPHqYBuLA7/H7IaLLB5/V71g9tg56y67x51re9g89s9dw+7Rf20Su8ffWftZPPq2
	rGL0+PLjH4vHlv2fGT2O39jO5PF5k5zHxrmhAbxRXDYpqTmZZalF+nYJXBk73hgVvOarWPvx
	HGsD4zXuLkYODgkBE4mWj2VdjJxAppjEhXvr2boYuTiEBKYzSsz70MQMkhASaGGSWN1RCWKz
	CVhJTGxfxQhiiwgYSGw4Og2sgVngLKvE+Y6rbCAJYQFviSm3noPZLAKqEhuPv2EEWcYroCWx
	eZUBSFhUwFNix/aVYCWcAlESO1ZMYYFYvIdR4tKjhWALeAUEJX5MvscCYjMLyEvs2z+VFcLW
	kli/8zjTBEaBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Oh7JrWD
	cWWDxSFGAQ5GJR7eBU3yIUKsiWXFlbmHGCU4mJVEeIOkFUKEeFMSK6tSi/Lji0pzUosPMUpz
	sCiJ8x5otQ4UEkhPLEnNTk0tSC2CyTJxcEo1ME5t8+LbsX7p2jOHdmwyk0jj2dK5JGLHMz3Z
	W20Fis8u59TJuxQdFeXLS80JCNPaEhkgcvNi/t5lpptTb7BMzyk7tZbl9YVq5fy/Ej6ur04W
	2l7elbiA1+Ju/2dfVp69B2VqvP0etrvJKf9vbntfXrvGc8OjC0pOEnetFt1Xdn8k+OkA199i
	KSWW4oxEQy3mouJEABMe8da6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, September 19, 2014 07:02:49 PM Paul Zimmerman wrote:
> > From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> > Sent: Friday, September 19, 2014 7:50 AM
> > 
> > Unfortunately after second look there are even more problems with Kconfig
> > changes, please see below.
> > 
> > > >
> > > >>  if USB_DWC2
> > > >>
> > > >> +choice
> > > >> +	bool "DWC2 Mode Selection"
> > > >> +	default USB_DWC2_DUAL_ROLE if (USB && USB_GADGET)
> > > >> +	default USB_DWC2_HOST if (USB && !USB_GADGET)
> > > >> +	default USB_DWC2_PERIPHERAL if (!USB && USB_GADGET)
> > 
> > Previously it was possible to have following functionalities in
> > one kernel (for multiplatform kernels):
> > 
> > - host PCI support
> > - host platform support
> > - gadget platform support
> > 
> > Now mode selection will determine the used mode for combined
> > host+gadget platform driver.  It is no longer possible to have
> > host platform and gadget platform support in one kernel.
> 
> Why not? Why wouldn't it work if you enable USB_DWC2_DUAL_ROLE? The
> dwc3 driver uses the same scheme as this, and I have not heard any
> complaints about that not working.

Ok, it seems that this should work fine if:

- USB_DWC2_DUAL_ROLE is set

- dwc2 handles dr_mode properly

[ BTW dwc3 has the following code in its ->probe which dwc2 lacks
  (the code sets the default dr_mode value):

	if (IS_ENABLED(CONFIG_USB_DWC3_HOST))
		dwc->dr_mode = USB_DR_MODE_HOST;
	else if (IS_ENABLED(CONFIG_USB_DWC3_GADGET))
		dwc->dr_mode = USB_DR_MODE_PERIPHERAL;

	if (dwc->dr_mode == USB_DR_MODE_UNKNOWN)
		dwc->dr_mode = USB_DR_MODE_OTG;

  It seems that correspoding changes are needed for dwc2. ]

- proper dr_mode is set in the DT dwc2 entry if the board needs it

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

