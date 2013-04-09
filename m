Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965028Ab3DIQtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:49:41 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49051 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964938Ab3DIQti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:49:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19u+mBtUJX8j9dHjoNL2VP2
Date: Tue, 9 Apr 2013 09:49:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: b-cousson@ti.com, linux@arm.linux.org.uk, rnayak@ti.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
        "Menon, Nishanth" <nm@ti.com>, grygorii.strashko@ti.com
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support
 for AUXCLKs
Message-ID: <20130409164928.GL10155@atomide.com>
References: <1363703220-4777-1-git-send-email-rogerq@ti.com>
 <1363703220-4777-2-git-send-email-rogerq@ti.com>
 <20130403234242.GE10155@atomide.com>
 <515D2D30.3000306@ti.com>
 <20130404164137.GH10155@atomide.com>
 <515EA9E3.1010409@ti.com>
 <20130405155851.GA10155@atomide.com>
 <5163E589.1040809@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5163E589.1040809@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130409 03:00]:
> On 04/05/2013 06:58 PM, Tony Lindgren wrote:
> > 
> > Well your approach is fine as a first step moving all the clock
> > code, but it needs to be a real driver under drivers/clock/omap.
> > And the DT binding needs to stay the same for the driver(s) in the
> > long term as we start moving clocks to DT + /lib/firmware.
> 
> The code needs to be there were the clock structs are defined.
> Currently they are in arch/arm/mach-omap2/cclock44xx_data.c for OMAP4.

But if you do just a passthrough driver then that should not
be needed. 
 
> > If this all is too late for v3.10, I suggest you just set up the
> > right clock alias for panda with machine_is_compatible flag in
> > board-generic.c so we get EHCI working with DT for v3.10. Then
> > it's easy to to deal with it properly for v3.11.
> 
> OK, let's do it this way for Panda for 3.10.

Yes otherwise we'll be delaying omap4 DT conversion again. 
 
> >> How can that driver do clk_get() from cclock44xx_data.c?
> >> from where does it get the clk_id to pass into clk_get()?
> > 
> > Can't you just use the clock name there to get it?
> 
> In device tree we don't pass around clock names. You can either get
> a phandle or an index to the clock.
> 
> e.g. Documentation/devicetree/bindings/clock/imx31-clock.txt

Yes I understand that. But the driver/clock/omap driver can just
remap the DT device initially so the board specific clock is
found from the clock alias table. Basically initially a passthrough
driver that can be enhanced to parse DT clock bindings and load
data from /lib/firmware.

> > As long as the binding stays the same in the long run too, this
> > clock remapping approach is just fine as a starting point. And
> > the driver needs to go to drivers/clock/omap. But in the long run
> > we just want to get the huge amounts static data out of the kernel
> > for clocks and hwmod data to fix things for good.
> 
> In that case we need to identify what clocks need to be supported.
> If it is all (~200) of them, is this method good enough?

We should support any clock we need for booting the device with
just DT bindings to get timers, console and rootfs working. Then
we just need to load the complete set from /lib/firmware.

It seems that the binding can be the same for all the clocks.
For now, we can just use the standard clock binding and do the
remapping in the clock driver.

Regards,

Tony
