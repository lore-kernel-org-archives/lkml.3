Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3FQQEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:04:01 -0400
Received: from mail.abilis.ch ([195.70.19.74]:17733 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3FQQEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:04:00 -0400
Date: Mon, 17 Jun 2013 18:03:25 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/2] Make non-linear GPIO ranges accesible from gpiolib
Message-ID: <20130617160324.GA15853@ab42.lan>
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
 <1371128132-18266-2-git-send-email-christian.ruppert@abilis.com>
 <51BA3BC1.3090109@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51BA3BC1.3090109@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 03:38:09PM -0600, Stephen Warren wrote:
> On 06/13/2013 06:55 AM, Christian Ruppert wrote:
> [...]
> > diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
> 
> > +In addition, named groups of pins can be mapped to pin groups of a given
> > +pin controller:
> > +
> > +	gpio_pio_g: gpio-controller@1480 {
> > +		#gpio-cells = <2>;
> > +		compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
> > +		reg = <0x1480 0x18>;
> > +		gpio-controller;
> > +		gpio-pingrps = <&pinctrl1 0>, <&pinctrl2 3>;
> > +		gpio-pingrp-names = "pctl1_gpio_g", "pctl2_gpio_g";
> 
> A few thoughts here:
> 
> "gpio-pingrps" doesn't sound very similar to the existing "gpio-ranges".
> Can we make their equivalent purpose more obvious by renaming this
> "gpio-group-ranges"?
> 
> I'm not actually even sure we need a new property for this, except for
> the string group names. We could fold the new gpio-pingrps into the
> existing gpio-ranges, whose entries have the format:
> 
> <gpio-base> <pinctrl-base> <count>
> 
> ... by saying that if count==0, it means to use a group name instead of
> a pinctrl-base value. We can insist that pinctrl-base==0 in this case
> too. If we go made, count==0 could mean "special" and pinctrl-base==0
> could mean "by pinctrl group name", and other values of pinctrl-base
> could be added later to mean other things!
> 
> gpio-ranges =
> 	<&pinctrl1 0 20 10>, /* Existing numeric style */
> 	<&pinctrl2 10 0 0>,  /* Count==0, so group name style */
> 	<&pinctrl1 0 20 10>, /* Existing numeric style */
> gpio-ranges-group-names =
> 	"",    /* No group name required for entry 0 */
> 	"gr1", /* Group name for entry 1 */
> 	"";    /* No group name required for entry 2 */
> 
> Does this seem better?
> [...]

In the follow-up a patch set based on this proposal. I have also
included our drivers (and device tree updates) with this to see how this
looks in a real (working) system. To me it does actually look quite nice
and logical but take a look at it yourselves and tell me what you think.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
