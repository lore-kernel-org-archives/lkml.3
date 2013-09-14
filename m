Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab3INRJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:09:34 -0400
Received: from mo5.mail-out.ovh.net ([178.32.228.5]:32965 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3INRJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:09:33 -0400
Date: Sat, 14 Sep 2013 18:31:37 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [RFC PATCH alt 4/4] pinctrl: at91: rework debounce configuration
Message-ID: <20130914163137.GA11420@ns203013.ovh.net>
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
 <1379058813-3489-1-git-send-email-b.brezillon@overkiz.com>
 <52339479.6030402@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52339479.6030402@wwwdotorg.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 10318028222897171277
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:40 Fri 13 Sep     , Stephen Warren wrote:
> On 09/13/2013 01:53 AM, Boris BREZILLON wrote:
> > AT91 SoCs do not support per pin debounce time configuration.
> > Instead you have to configure a debounce time which will be used for all
> > pins of a given bank (PIOA, PIOB, ...).
> 
> > diff --git a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
> 
> > +Optional properties for iomux controller:
> > +- atmel,default-debounce-div: array of debounce divisors (one divisor per bank)
> > +  which describes the debounce timing in use for all pins of a given bank
> > +  configured with the DEBOUNCE option (see the following description).
> > +  Debounce timing is obtained with this formula:
> > +  Tdebounce = 2 * (debouncediv + 1) / Fslowclk
> > +  with Fslowclk = 32KHz
> > +
> >  Required properties for pin configuration node:
> >  - atmel,pins: 4 integers array, represents a group of pins mux and config
> >    setting. The format is atmel,pins = <PIN_BANK PIN_BANK_NUM PERIPH CONFIG>.
> > @@ -91,7 +99,6 @@ DEGLITCH	(1 << 2): indicate this pin need deglitch.
> >  PULL_DOWN	(1 << 3): indicate this pin need a pull down.
> >  DIS_SCHMIT	(1 << 4): indicate this pin need to disable schmit trigger.
> >  DEBOUNCE	(1 << 16): indicate this pin need debounce.
> > -DEBOUNCE_VAL	(0x3fff << 17): debounce val.
> 
> This change would break the DT ABI since it removes a feature that's
> already present.
> 
> I suppose it's still up to the Atmel maintainers to decide whether this
> is appropriate, or whether the impact to out-of-tree DT files would be
> problematic.

I does ask Boris to break the DT ABI

as anyway no one use it and the current ABI is wrong

and as this is the new SoC the impact of out-of-tree board is limited if ever

Best Regards,
J.
