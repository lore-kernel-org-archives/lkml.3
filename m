Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaBEPad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:30:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45793 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752727AbaBEPaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:30:30 -0500
Date: Wed, 5 Feb 2014 10:30:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matt Porter <mporter@linaro.org>
cc: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/6] i2c: bcm-kona: register with subsys_initcall
In-Reply-To: <20140205151826.GC22153@beef>
Message-ID: <Pine.LNX.4.44L0.1402051028350.1312-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Matt Porter wrote:

> On Wed, Feb 05, 2014 at 10:08:18AM +0100, Wolfram Sang wrote:
> > On Tue, Feb 04, 2014 at 07:19:07AM -0500, Matt Porter wrote:
> > 
> > > Voltage regulators are needed very early due to deferred probe
> > > being incompatible with built-in USB gadget drivers.
> > 
> > What does it need to fix those instead?
> 
> [added Alan/Felipe for more insight]
> 
> Discussion on that topic came about from this submission:
> http://www.spinics.net/lists/linux-usb/msg94217.html
> 
> End of it is:
> http://www.spinics.net/lists/linux-usb/msg94731.html
> 
> We can either add to the many drivers that already do subsys_initcall()
> for similar reasons...or I can drop this from the series and add gadget
> probe ordering to my TODO list.
> 
> In short, it can't be a late_initcall() hack like the original post and
> really could be solved by converting to a real bus (and letting
> deferred probe do its job)..but Alan voiced concerns about that.

Don't worry too much about what I said.  If adding a "gadget" bus will 
solve the problem in an appropriate way, and if nobody else objects 
(particularly Felipe, who is on vacation now), then go for it.

Alan Stern

