Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaKDSFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:05:51 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:23742 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752026AbaKDSFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:05:48 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+QDMzQ54y0j9qe8QEV4vcx
Date: Tue, 4 Nov 2014 10:04:41 -0800
From: Tony Lindgren <tony@atomide.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration
 enabled
Message-ID: <20141104180441.GU31454@atomide.com>
References: <20141102180756.GH31454@atomide.com>
 <5458D29E.50908@compulab.co.il>
 <20141104154231.GP31454@atomide.com>
 <54591265.3030207@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54591265.3030207@compulab.co.il>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Igor Grinberg <grinberg@compulab.co.il> [141104 09:54]:
> On 11/04/14 17:42, Tony Lindgren wrote:
> > * Igor Grinberg <grinberg@compulab.co.il> [141104 05:22]:
> >> Hi Tony,
> >>
> >> On 11/02/14 20:07, Tony Lindgren wrote:
> >>> Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
> >>> configuration") enabled configuring the PM features for twl4030.
> >>>
> >>> This caused poweroff command to fail on devices that have the
> >>> BCI charger on twl4030 wired, or have power wired for VBUS.
> >>> Instead of powering off, the device reboots. This is because
> >>> voltage is detected on charger or VBUS with the default bits
> >>> enabled for the power transition registers.
> >>>
> >>> To fix the issue, let's just clear VBUS and CHG bits as we want
> >>> poweroff command to keep the system powered off.
> >>
> >> What about devices that really need to start once VBUS or CHG is connected?
> > 
> > More handling can be added for some cases. With this patch the
> > poweron bits will clear to defaults if power is completely removed.
> > So start-up with VBUS and CHG works in that case.
> > 
> > However, if you have a battery connected, and you poweroff, with
> > this patch the device won't power up with VBUS or CHG connected.
> > 
> > Note that most battery operated devices are not using the charger
> > on twl4030 because it has issues charging a completely empty
> > battery AFAIK. So most battery powered devices have been using an
> > external USB charger chip that's not affected by this patch.
> > 
> > We could consider exporting a function for the charger driver to
> > configure the poweron mask. And we could also consider passing a
> > mask in ti,use_poweroff = 0xff.
> 
> Ok. That sounds better to me.
> Yet, if you say there are no such devices in practice,
> IMHO, we can merge this.
> 
> >> It seems to me that forcing these bits on power off can break that kind of
> >> devices and these settings should really be board specific.
> >> What do you think?
> > 
> > There's a patch series for "[RFC,01/16] kernel: Add support for
> > poweroff handler call chain" that should help with that. For sure
> > the poweroff handling needs to be board specific as some systems
> > may need to use a GPIO to shut off a regulator powering something
> > before powering off the SoC.
> 
> Yes, I've seen this series.
> I'm not sure though that I understand how is this supposed
> to be used with DT...
> Through the regulator bindings?
> Which will tell it to hook up on the call chain?

Yes that should be doable with regulator bindings for board specifc
configuration. For the SoC specific functions those can be registered
by the platform code.

Regards,

Tony
