Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaKRQT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:19:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39294 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbaKRQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:19:58 -0500
Date: Tue, 18 Nov 2014 17:19:50 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [RFC] pinctrl: Provide a generic device tree binding for per-pin
 pin controllers
Message-ID: <20141118161950.GG30369@pengutronix.de>
References: <20141023132305.GG14443@pengutronix.de>
 <5451B914.6020300@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5451B914.6020300@wwwdotorg.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:10:42 up 34 days,  3:24, 83 users,  load average: 0.01, 0.06,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Oct 29, 2014 at 10:05:40PM -0600, Stephen Warren wrote:
> On 10/23/2014 07:23 AM, Sascha Hauer wrote:
> > Most iomux controllers allow a configuration per pin. These currently
> > have no common device tree binding. There are many different SoC
> > specific bindings for this class of iomux controllers. Some controllers
> > artificially group pins together where in hardware no groups exist (for
> > example lantiq). Other controllers just put each pin into a separate
> > group which explodes to many many strings to parse (Tegra30).
> > 
> > 
> > A pin controller has n pins, each muxable to m different positions.
> 
> I assume that sentence is meant to say something more specific:
> 
> This binding is intended to apply to pin controllers where each pin has
> an independently selectable mux function.

Yes.

> 
> "A pin controller ..." sounds like a general statement that is intended
> to apply to any pin controller. If that were intended, the statement you
> made certainly wouldn't be true.

Right.

> 
> > There exists a logical numbering for all pins, for most SoCs this will
> > be defined by the register ordering so that the pin number can directly
> > be translated to a register offset without the need of tables in the
> > driver. The register usually takes m different numbers to specify the
> > function the pin should have. Both the pin and its function can be
> > described as a single 32bit number:
> > 
> > #define PINMUX_PIN(no, fn) (((no) & 0xffffff) << 8) | (fn) & 0xff)
> > 
> > This allows to put multiple pins into a single device tree property
> > which is very efficiently parsable by the driver (or the pinmux core).
> > We suggest to name this property 'pins' and to put it next to the
> > generic pinconf binding.  This allows to describe multiple pins with the
> > same pinconf settings in a single device tree node. Multiple of these
> > nodes can be grouped under a pinctrl state node. This allows to put pins
> > with different pinconf settings to a single state.
> > 
> > Example:
> > 
> > 	uart2 {
> > 		uart2_default_mode: uart2_default {
> > 			pins1 {
> > 				pins = <PINMUX_PIN(127, 3), PINMUX_PIN(128, 3)>;
> 
> Within each of the nodes, the binding for pinmux is defined
> independently by each pin controller. I don't have any /strong/
> objection to any particular pin controller using this binding, or even
> it being re-used across many similar pin controllers, or even being
> the/a default binding style for new pin controllers.
> 
> I'm not totally sure whether blending the pin ID and mux function ID
> into the same value is a good idea. That said, it does have advantages
> as you state, and shouldn't cause any significant issues. In any case
> where it would be a bad idea, the binding for the pin controller in
> question can still choose to use some more appropriate binding, so
> allowing this binding for some controllers won't force issues onto other
> controllers. So, it seems fine.
> 
> Note however that we can't change existing bindings. Well, I suppose
> certain bindings could be enhanced to support either a string-based or
> an integer-base binding, but I don't think that'd be a good idea.

I'm only talking about new bindings, no need to change existing
bindings. For new bindings it surely has benefits when we can just point
to a well established binding. Right now the existing bindings for the
pin controllers which independently control each pin differ a lot.

The next step should be to integrate the above into the pinctrl
documentation.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
