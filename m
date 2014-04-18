Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaDRXYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 19:24:19 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34865 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752254AbaDRXYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 19:24:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18fpVPWOe/WBp+6+DmUk98L
Date: Fri, 18 Apr 2014 16:24:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/2] dt: platform driver: Fill the resources before
 probe and defer if needed
Message-ID: <20140418232407.GQ21823@atomide.com>
References: <20140320161118.B7075C4067A@trevor.secretlab.ca>
 <1395413185-29763-1-git-send-email-jjhiblot@traphandler.com>
 <1395413185-29763-3-git-send-email-jjhiblot@traphandler.com>
 <CAL_Jsq+aU+rs28gV=Gesb_-Dy6Ht7zuKrRA6_hmqp94Uun23Yg@mail.gmail.com>
 <20140418205213.GA21823@atomide.com>
 <CAL_JsqJvVvo6R-qNXxur7wiZERKbi52xyKoWnmzJTfKS2iKK7A@mail.gmail.com>
 <20140418215848.GD21823@atomide.com>
 <20140418230335.GI24070@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418230335.GI24070@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [140418 16:04]:
> On Fri, Apr 18, 2014 at 02:58:48PM -0700, Tony Lindgren wrote:
> > Oh come on, let's stop pretending it's not broken. And it's way worse with
> > device tree as there's nothing making sure the resources for a driver
> > are set up before the driver probes. And we've been unable to fix just
> > this issue alone for about six months now. It's also broken beyond that.
> > It's called of_platform_bus yet it won't even pass the platform_data
> > as auxdata to the devices on a sub-bus instantatiated like I2C.
> 
> Isn't there a much simpler solution to the platform device IRQ problem?
> 
> Rather than trying to fix it at the point where the resources are
> created, why not just *not* have DT create the IRQ resources in the
> first place, and instead have platform_get_irq() (which is the function
> which should be used to get an IRQ) be the actor to do whatever is
> necessary to return the IRQ(s) ?

Yeah why not. I don't see why we would need to do all this of_* special
trickery for much anything beyond parsing the binding.
 
> Yes, I know we have some drivers which use platform_get_resources() with
> IORESOURCE_IRQ, but they should really use the right accessor.  And those
> who just dereference the resource array directly... get what's coming
> (though of course they have to be fixed.)

$ git grep IORESOURCE_IRQ drivers/ | grep platform_get_resource | wc -l
179

But might be scriptable to some extent..
 
> It has the benefit that you're in a path where you /can/ return
> -EPROBE_DEFER too and not have to mess around with notifiers or other
> silly stuff like that.

And then maybe we can make of_platform_probe() or some bus function
do the most of the -EPROBE_DEFER ping pong before the driver even
probes?

Regards,

Tony
