Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbaAJXwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 18:52:38 -0500
Received: from ring0.de ([91.143.88.219]:47764 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaAJXwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 18:52:35 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 11 Jan 2014 00:52:09 +0100
From: Sebastian Reichel <sre@debian.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "=?iso-8859-1?Q?'Beno=EEt?= Cousson'" <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [RFCv4 05/11] Documentation: DT: omap-ssi binding documentation
Message-ID: <20140110235208.GA16048@earth.universe>
Mail-Followup-To: Tony Lindgren <tony@atomide.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
	Carlos Chinea <cch.devel@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	=?iso-8859-1?Q?'Beno=EEt?= Cousson' <bcousson@baylibre.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	=?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= <freemangordon@abv.bg>,
	Joni Lapilainen <joni.lapilainen@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1387150085-23173-1-git-send-email-sre@debian.org>
 <1387150085-23173-6-git-send-email-sre@debian.org>
 <20131219190344.GW27438@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20131219190344.GW27438@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Thu, Dec 19, 2013 at 11:03:44AM -0800, Tony Lindgren wrote:
> > +Required properties:
> > +- compatible:		Should include "ti,omap3-ssi".
> > +- reg-names:		Contains the values "sys" and "gdd".
>=20
> Do you need the reg-names? The order won't change so you can just
> document the order in the binding?

The names are not needed, but I like self-documenting code/bindings.

Also the examples in Documentation/devicetree/bindings/resource-names.txt
look similar to this case.

What do you have against the -names properties?

The same statement goes for the following -names comments, so I will
skip them ;)

> [...]
> > +- ti,ssi-cawake-gpio:	Defines which GPIO pin is used to signify CAWAKE
> > +			events for the port. This is an optional board-specific
> > +			property. If it's missing the port will not be
> > +			enabled.
>=20
> Hmm this might be just a wake-up GPIO? If so, you should be able to
> just set it up as an interrupt and do a request_irq on the pinctrl-single
> entry for it.

Yes, this gpio is used as interrupt in the driver, but its also read
directly. I already considered making it an irq in the DT data
(since its mainly used as irq), but I could not find out how to read
the current status of an irq line.

> It might even be one of the already mapped interrupt lines that the code =
is
> remuxing to a GPIO for idle? If so, then you can just use the new binding
> for interrupts-extended to handle the wake-up events.
>=20
> If you post the GPIO number for ti,ssi-cawake-gpio and the interrupt
> numbers I can check if there's a need to handle it separately as a GPIO
> pin or if it already can be automatically handled for the wake-up events.

You can see it in one of the next patches, which adds the needed
nodes in omap3-n900.dts. The used GPIO on N900 is 151 (gpio5 23)
and I use the following pinmux configuration:

0x152 (PIN_INPUT | WAKEUP_EN | MUX_MODE4)

P.S.: I intend to get this into 3.15. Before I will send an updated
      series, which uses the omap clock DT bindings as requested by
      DT binding maintainers.

-- Sebastian

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJS0IeoAAoJENju1/PIO/qaho0P/jlMVmcDtQcefvXZb/gJtvOo
sXPoAqLbBYKumZrJnaGPoI5AamZA3UQurXq4Z9Ljl9W1uSYE4kqnJ+Ez2o1UUoTF
Sy4wK84FcAqD07Bzz8nuIvjpDoHr/lVplNx/BwvCnSYF9XfsH1lEVzgirXVX9T9E
Q8eMt1V23/rpLXvLkrq9B8rOGULwgEYszhbGbBt6w0hDsDZg126eytiW9DvItwWv
Uf6V6WSzTKsiLYHJUD874+tZ3msGXYmfJgywLwaDLF6Lq6l9I+FNBXJafKQEbHzU
EIO9OOQvJF1PTr4l3PNvkm8PdbDLYs1y4x43u0wXRWeAd9qPUBAS0dPK/sg7t6Ue
PApcZxwbjQiDzfZu1zEqvlc4GCiCGclGe+dvOXwBne5MjpQ40S+7MfTqkFoI5Sv+
pLAFfaAWb6mmL576avHNEKzbGtqCsEFlMr06tmq/tD6nX4sFNiVkP7/J1O2FIeBy
rFZLh+5jZEEXmAq1Xt5FgfhTLcKnYHtie9C2OtDuT37/+6HBVzjPCqpLXrrpfVez
PLLhqlluyaVjahiZOoxEKfwFOxFcQwmaIdCxXgKrj/jAVrAlRFy+GcPWFQuGVrAr
kEaiF4uoaqJ+mEZYCis+4GEAYnGATnq3I60lV040zOMdQMzKzDviCcgAGftoll5L
5OmJ4RHHHfJzg9fu+2CO
=Ni59
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
