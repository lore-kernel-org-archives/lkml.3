Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab3GaLNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:13:47 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab3GaLNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:13:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: How to create IRQ mappings in a GPIO driver that doesn't control its IRQ domain ?
Date: Wed, 31 Jul 2013 13:14:47 +0200
Message-ID: <26968517.tbY84mICFD@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130728050021.4370E3E0A24@localhost>
References: <1624911.6TtmtVmU1T@avalon> <1681089.qGWOhLKTTo@avalon> <20130728050021.4370E3E0A24@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Saturday 27 July 2013 23:00:21 Grant Likely wrote:
> On Thu, 25 Jul 2013 15:22:29 +0200, Laurent Pinchart wrote:
> > On Thursday 25 July 2013 14:15:56 Mark Brown wrote:
> > > On Thu, Jul 25, 2013 at 11:45:33AM +0200, Laurent Pinchart wrote:
> > > > The two devices are independent, so there's no real parent/child
> > > > relationship. However, as Grant proposed, I could list all the
> > > > interrupts associated with GPIOs in the GPIO controller DT node. I
> > > > would then just call irq_of_parse_and_map() in the .to_irq() handler
> > > > to magically translate the GPIO number to a mapped IRQ number.
> > > > 
> > > > The number of interrupts can be pretty high (up to 58 in the worst
> > > > case so far), so an alternative would be to specify the interrupt-
> > > > parent only, and call irq_create_of_mapping() directly. What solution
> > > > would you prefer ?
> > > 
> > > Are the interrupts in a contiguous block in the controller so you can
> > > just pass around the controller and a base number?
> > 
> > In two of the three SoCs I need to fix they are. I've just realized that
> > in the last one the interrupts are in two contiguous blocks in two
> > different parents. I will thus need at least a list of <parent-phandle
> > base count>.
> >
> > Our standard interrupt bindings don't seem to support multiple parents,
>
> You can actually do it by using a dummy node with interrupt-map and
> interrupt-map-mask properties, but it is a pretty ugly solution in my
> opinion.
> 
> > is that something that we want to fix or should I go for custom bindings ?
> 
> Yes, I think it is something that we want to fix. Jean-Christophe was going
> to propose an alternative to the interrupts property which allows an array
> of <phandle interrupt-specifier> tuples, but I've not seen anything yet. Go
> ahead and make a proposal.

More work, great :-)

A bit of bikeshedding here, as the "interrupts" property is already used, how 
should I name the new property ?

> You could try to encode a base+count variant, but honestly I don't think it
> would be a good idea because it only would work with a very narrow set of
> use cases. Consider if #interrupt-cells was set to 2. Which cell gets
> incremented in the range of interrupts specified? Better I think to merely
> have an array of fully specified irqs. Support for that property could be
> transparently baked into the core interrupt parsing functions.

I agree, I'll try that.

-- 
Regards,

Laurent Pinchart

