Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728Ab3DIRnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:43:25 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30492 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763999Ab3DIRnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:43:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+UbSiHRHecfsrEdqPJvDuA
Date: Tue, 9 Apr 2013 10:43:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: "Menon, Nishanth" <nm@ti.com>, linux-usb@vger.kernel.org,
        linux@arm.linux.org.uk, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, grygorii.strashko@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support
 for AUXCLKs
Message-ID: <20130409174319.GP10155@atomide.com>
References: <1363703220-4777-1-git-send-email-rogerq@ti.com>
 <1363703220-4777-2-git-send-email-rogerq@ti.com>
 <20130403234242.GE10155@atomide.com>
 <515D2D30.3000306@ti.com>
 <20130404164137.GH10155@atomide.com>
 <515EA9E3.1010409@ti.com>
 <20130405155851.GA10155@atomide.com>
 <5163E589.1040809@ti.com>
 <20130409164928.GL10155@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409164928.GL10155@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [130409 09:54]:
> * Roger Quadros <rogerq@ti.com> [130409 03:00]:
> > On 04/05/2013 06:58 PM, Tony Lindgren wrote:
> > > 
> > > Can't you just use the clock name there to get it?
> > 
> > In device tree we don't pass around clock names. You can either get
> > a phandle or an index to the clock.
> > 
> > e.g. Documentation/devicetree/bindings/clock/imx31-clock.txt
> 
> Yes I understand that. But the driver/clock/omap driver can just
> remap the DT device initially so the board specific clock is
> found from the clock alias table. Basically initially a passthrough
> driver that can be enhanced to parse DT clock bindings and load
> data from /lib/firmware.

Actually probably the driver/clock/omap can even do even less
initially. There probably even no need to remap clocks there.

As long as the DT clock driver understands that a board specific
auxclk is specified in the DT it can just call clk_add_alias() so
the driver will get the right auxclk from cclock44xx_data.c.

Then other features can be added later on like to allocate a
clock entirely based on the binding etc.

Regards,

Tony 
