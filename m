Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaBET43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:56:29 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45835 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752800AbaBETzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:55:53 -0500
Date: Wed, 5 Feb 2014 14:55:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kamil Debski <k.debski@samsung.com>
cc: linux-kernel@vger.kernel.org, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <kyungmin.park@samsung.com>, <kishon@ti.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>,
        <tjakobi@math.uni-bielefeld.de>
Subject: RE: [PATCH v6 8/8] usb: ehci-exynos: Change to use phy provided by
 the generic phy framework
In-Reply-To: <054301cf228a$eb58a480$c209ed80$%debski@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1402051453150.1312-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Kamil Debski wrote:

> Hi Alan,
> 
> Thank you for your review.

You're welcome.

> > 
> > > Change the phy provider used from the old one using the USB phy
> > You have removed all the OTG stuff from the driver.  This wasn't
> > mentioned in the patch description, and it has no connection with the
> > PHY work.
> 
> Maybe I'll explain more about what are we trying to achieve. The goal
> is to replace the old phy driver with the new one. In the old driver it was
> difficult to add support to new SoC. It also had issues with having device
> and
> host working together.
> 
> You're right that until the old phy driver is removed support for the it
> should
> remain. To be able to remove the old driver both new USB2 and new USB3 phy
> drivers
> have to be ready. The USB3 driver is written by Vivek Gautam and as I see
> it, he
> is also close to completion.
> 
> Regarding the otg part. The old phy driver is the only provider of the otg
> structure. It sets the host field of the structure. It is then used by
> samsung_usb2phy_init (drivers/usb/phy/phy-samsung-usb2.c) to check which
> driver is requesting the phy (is it host or device). In the new driver this
> is determined by the entry in device tree. So no need to check the otg
> struct
> and strstr (!) to check if dev_name is ehci, ohci or other, like the old
> driver.

Okay, that's fine.  But please explain this in the patch description
next time.  Otherwise the connection between the phy driver and the otg
structure is not at all clear; they look like two unrelated things.

Alan Stern

