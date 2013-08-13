Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3HMV0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:26:55 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54880 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759272Ab3HMV0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:26:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18BHhRqbw286Hy2G4vIsSBxvDeQBJMxI9w=
Date: Tue, 13 Aug 2013 17:26:40 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 4/5] PCI: mvebu: add support for reset on GPIO
Message-ID: <20130813212640.GK25111@titan.lakedaemon.net>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376396724-32048-5-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130813222943.46fdacff@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813222943.46fdacff@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:29:43PM +0200, Thomas Petazzoni wrote:
> Dear Sebastian Hesselbarth,
> 
> On Tue, 13 Aug 2013 14:25:23 +0200, Sebastian Hesselbarth wrote:
> 
> > +		port->reset_gpio = of_get_named_gpio_flags(child,
> > +						   "reset-gpios", 0, &flags);
> > +		if (gpio_is_valid(port->reset_gpio)) {
> > +			u32 reset_udelay = 20000;
> > +
> > +			port->reset_active_low = flags & OF_GPIO_ACTIVE_LOW;
> > +			port->reset_name = kasprintf(GFP_KERNEL,
> > +				     "pcie%d.%d-reset", port->port, port->lane);
> > +			of_property_read_u32(child, "reset-delay-us",
> > +					     &reset_udelay);
> > +
> > +			ret = devm_gpio_request_one(&pdev->dev,
> > +			    port->reset_gpio, GPIOF_DIR_OUT, port->reset_name);
> > +			if (ret) {
> > +				if (ret == -EPROBE_DEFER)
> > +					return ret;
> > +				continue;
> > +			}
> > +
> > +			gpio_set_value(port->reset_gpio,
> > +				       (port->reset_active_low) ? 1 : 0);
> > +			udelay(reset_udelay);
> > +		}
> 
> Sorry for raising this only now, but I think I would have preferred to
> see this reset-gpios handling be moved into a separate sub-function.
> The loop initializing each PCIe interface is already quite large, and I
> believe moving this reset-gpios thing to a sub-function would have made
> sense.
> 
> But well, the patches have been applied, and we can always adjust this
> with a followup patch.

The branch this is in will be the last PR, so if the patch is reworked
by tomorrow, I'll just replace it.

> Jason, have you re-created your for-next branch with all those patches?
> I'd like to give them a test if possible.

Yep.  Give it a go.

thx,

Jason.
