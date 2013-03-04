Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab3CDP3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:29:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44943 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758075Ab3CDP3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:29:34 -0500
Date: Mon, 4 Mar 2013 10:29:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautamvivek1987@gmail.com>
cc: Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <sarah.a.sharp@linux.intel.com>,
        <kgene.kim@samsung.com>, <kishon@ti.com>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 06/10] usb: xhci: Enable runtime pm in xhci-plat
In-Reply-To: <CAFp+6iFsR1H8kRmg2ynGto0ZERydOc-Vk+niS_ucH20o2R7SCg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303041027250.1750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013, Vivek Gautam wrote:

> >> @@ -149,6 +150,8 @@ static int xhci_plat_probe(struct platform_device *pdev)
> >>       if (ret)
> >>               goto put_usb3_hcd;
> >>
> >> +     pm_runtime_enable(&pdev->dev);
> >
> > This is generally not a good idea.  You shouldn't enable a device for
> > runtime PM without first telling the PM core what state it is in.
> >
> Right, but i am not completely sure on any fixed path to follow for
> enabling runtime
> power management on a device. :-(
> Does it become necessary to "pm_runtime_set_active" or
> "pm_runtime_set_suspended" a device
> before "pm_runtime_enable" ?

Yes, it usually is necesary.  And especially here, because the runtime
PM core sets the initial status of every device to RPM_SUSPENDED.

>  pm_runtime_enable would just try to
> decrement the disable_depth
> of the device.

That's right.  And once that happens, the PM core would think the 
device was suspended even though it was really at full power.

Alan Stern

