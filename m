Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934797Ab3FSMoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:44:19 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57589 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566Ab3FSMoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:44:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/jX0yW7Yicv3LnvCdxkLeo
Date: Wed, 19 Jun 2013 05:44:13 -0700
From: Tony Lindgren <tony@atomide.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] ARM: dts: omap4-panda: Add USB Host support
Message-ID: <20130619124412.GC5523@atomide.com>
References: <1371571487-14389-1-git-send-email-rogerq@ti.com>
 <1371571487-14389-2-git-send-email-rogerq@ti.com>
 <51C106A1.9030001@ti.com>
 <51C15F7E.5020305@ti.com>
 <20130619074605.GW5523@atomide.com>
 <51C183AC.8040801@ti.com>
 <20130619122715.GA5523@atomide.com>
 <51C1A55E.9040500@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C1A55E.9040500@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benoit Cousson <b-cousson@ti.com> [130619 05:41]:
> Hi Tony,
> 
> On 06/19/2013 07:27 AM, Tony Lindgren wrote:
> >* Benoit Cousson <b-cousson@ti.com> [130619 03:17]:
> >>On 06/19/2013 02:46 AM, Tony Lindgren wrote:
> >>>
> >>>We have a similar issue with the MMC1 PBIAS. I think in the long run we
> >>>should expand regulator (and possibly pinctrl) framework(s) to handle
> >>>comparators. We could just assume that a comparatator is a regulator,
> >>>and have a comparator binding that just uses the regulator code.
> >>
> >>In the case of pbias, the pinctrl seems to be a much better fit for
> >>my point of view. pinctrl can handle pin configuration and this is
> >>what the pbias is in the case of MMC pins.
> >
> >Well just recently Linus W specifically wanted us to use regulator
> >framework for the MMC1 PBIAS rather than pinctrl. That's because
> >from consumer driver point of view, it changes voltage and there's
> >a delay involved. So I guess no conclusion yet, and it's best to
> >do stand alone drivers to deal with those that use pinctrl for the
> >pinctrl specific parts and export it as a regulator for the consumer
> >devices.
> 
> In the case of pbias, the boundary is not that clear, and it is true
> that writing a complete pinctrl driver is really overkill.
> I've tried in the past, and gave up due to the complexity of fmwk
> and the lack of time. I still think, it is a much better fmwk to
> handle pin configuration than the regulator fmwk.

For omaps, these kind of registers can already be handled by
pinctrl-single,bits. What's missing is the capability to create
a regulator out of the voltage mux + comparator bits.
 
> >That's pretty much along the lines what Roger has done,
> >except the transceiver could use the pinctrl-single,bits for the
> >muxing and pinconf.
> 
> Well, in that case, this is a reset line, so it does not have
> anything to do with voltage :-)
> 
> Anyway, thanks to Florian, we know that there is a real solution to
> that problem. It is just not merged now :-(

Right. Meanwhile, sounds like the transceiver driver needs to
deal with the GPIO directly.

Regards,

Tony
