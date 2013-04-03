Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762981Ab3DCSOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:14:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57877 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762817Ab3DCSOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:14:03 -0400
Date: Wed, 3 Apr 2013 14:14:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Vivek Gautam <gautamvivek1987@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <sarah.a.sharp@linux.intel.com>, <rob.herring@calxeda.com>,
        <kgene.kim@samsung.com>, <dianders@chromium.org>, <t.figa@samsung.com>,
        <p.paneri@samsung.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
In-Reply-To: <20130403141831.GJ14680@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1304031410320.2027-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Apr 2013, Felipe Balbi wrote:

> > Lets suppose DWC3 enables runtime_pm on USB 2 type phy,
> > it will try to go into suspend state and thereby call runtime_suspend(), if any.
> > And PHY will come to active state only when its consumer wakes it up,
> > and this consumer is operational
> > only when its related PHY is in fully functional state.
> > So do we have a situation in which this PHY goes into low power state
> > in its runtime_suspend(),
> > resulting in non-detection of devices on further attach (since PHY is
> > in low power state) ?
> > 
> > Will the controller (like EHCI/OHCI) be functional now ?
> 
> ehci/ohci need to cope with that by calling usb_phy_autopm_get_sync(),
> right ? (so does DWC3 :-)

Maybe you guys have already got this all figured out -- if so, feel 
free to ignore this email.

Some subsystems handle this issue by calling pm_runtime_get_sync() 
before probing a driver and pm_runtime_put_sync() after unbinding the 
driver.  If the driver is runtime-PM-enabled, it then does its own 
put_sync near the end of its probe routine and get_sync in its release 
routine.

With PHYs you don't have probing and releasing, but you do have 
consumers registering and unregistering themselves, which is about the 
same thing.

Alan Stern

