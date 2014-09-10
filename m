Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158AbaIJNS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:18:28 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:61561 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaIJNS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:18:26 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 10 Sep 2014 15:16:25 +0200
From: Johan Hovold <johan@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Johan Hovold <johan@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] rtc: at91sam9: add DT bindings documentation
Message-ID: <20140910131625.GJ2974@localhost>
References: <1409733934-14465-1-git-send-email-boris.brezillon@free-electrons.com>
 <1409733934-14465-6-git-send-email-boris.brezillon@free-electrons.com>
 <20140910121424.GG2974@localhost>
 <20140910144315.240621e6@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910144315.240621e6@bbrezillon>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 02:43:15PM +0200, Boris BREZILLON wrote:
> Hi Johan,
> 
> On Wed, 10 Sep 2014 14:14:24 +0200
> Johan Hovold <johan@kernel.org> wrote:
> 
> > On Wed, Sep 03, 2014 at 10:45:34AM +0200, Boris BREZILLON wrote:
> > > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > ---
> > >  .../devicetree/bindings/rtc/atmel,at91sam9-rtc.txt   | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt b/Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt
> > > new file mode 100644
> > > index 0000000..9ca455f
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/rtc/atmel,at91sam9-rtc.txt
> > > @@ -0,0 +1,20 @@
> > > +Atmel AT91SAM9260 Real Time Timer
> > > +
> > > +Required properties:
> > > +- compatible: should be: "atmel,at91sam9260-rtt"
> > > +- reg: should contain 2 memory regions
> > > +  * the first one encodes the memory region of the RTT controller
> > > +  * the second one encodes the GPBR (General Purpose Backup Resgisters)
> > > +    memory region used to store the current time
> > > +- interrupts: rtc alarm/event interrupt
> > > +- clocks: should contain one clock pointing the the slow clk
> > > +
> > > +Example:
> > > +
> > > +rtc@fffffe00 {
> > > +	compatible = "atmel,at91sam9260-rtt";
> > > +	reg = <0xfffffd20 0x10
> > > +	       0xfffffd50 0x4>;
> > > +	interrupts = <1 4 7>;
> > > +	clocks = <&clk32k>;
> > > +};
> > 
> > This does not describe the hardware, but rather a specific software
> > configuration.
> > 
> > The RTT is first of all not an RTC (although it can be used as one in a
> > specific software configuration). And the second register resource above
> > is not an RTT register, but a general-purpose backup register could be
> > used for other purposes (which register to use is currently configurable
> > for legacy booting using CONFIG_RTC_DRV_AT91SAM9_GPBR).
> > 
> > This was discussed in the thread where I posted an RFC for this last
> > year (which you linked to in your original submission thread), but no
> > conclusion was reached:
> > 
> > 	http://www.spinics.net/lists/arm-kernel/msg236292.html
> 
> Yes, I read this thread.

I'm sure you did. I just tried to summarise the main points of it above.

> Please, lets just find a solution, even if it's not a perfect one,
> because the situation is unacceptable.
> We're missing this features since the move to DT because we were not
> able to agree on a DT binding...

Agreed. My suggestion in the thread above was along the lines of generic
use-neutral rtt and gmbr nodes, and then an additional attribute to the
rtt node (which can be set in a specific board dts, when enabling the
rtt) providing a gmbr handle (and register number) for the rtc-at91sam9
driver to use.

This in itself does not resolve which rtt-driver would get bound if
there is ever another one (and the gmbr attribute is present), though.

> I know DT bindings are supposed to represent HW parts and not what
> they're used for or how they're configured, but do you see any other
> real usage of the RTT block ?

It's at least not hard to imagine other uses for the battery-backed up
gmbr registers.

I'll look into how that could be implemented.

> BTW, I don't care which binding/implementation is chosen but we need to
> sort this out!

Ok, let's do that. :)

Johan
