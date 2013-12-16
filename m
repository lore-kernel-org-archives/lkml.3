Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3LPXhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:37:43 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47182 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3LPXhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:37:41 -0500
Date: Mon, 16 Dec 2013 23:37:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>
Message-ID: <20131216233737.GL3185@sirena.org.uk>
References: <1386965234-26461-1-git-send-email-tony@atomide.com>
 <20131216183615.GK3185@sirena.org.uk>
 <20131216194023.GE26293@atomide.com>
 <20131216201102.GP3185@sirena.org.uk>
 <20131216210512.GF26293@atomide.com>
 <20131216214057.GG3185@sirena.org.uk>
 <20131216230622.GH26293@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlgRIH+VC25VUu7I"
Content-Disposition: inline
In-Reply-To: <20131216230622.GH26293@atomide.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Start using standard gpios property and
 deprecate some custom properties
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlgRIH+VC25VUu7I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 16, 2013 at 03:06:22PM -0800, Tony Lindgren wrote:
> * Mark Brown <broonie@kernel.org> [131216 13:42]:
> > On Mon, Dec 16, 2013 at 01:05:13PM -0800, Tony Lindgren wrote:

> > > Personally I don't see any value for a regulator describing the names=
 of
> > > the GPIOs in the binding, it's really up to the driver to make sense =
of
> > > them. Especially if there are one or more similar GPIOs. We're not

> > Devices like PMICs frequently have a *lot* of possible pin functions
> > some of which can get mapped onto GPIOs (in either direction), many of
> > which are going to be fixed by system design and generally all muxed
> > onto a much smaller set of physical pins.  If you try to specify those

> That's why PMICs usually show up as GPIO controllers. And if a regulator
> needs to use those GPIOs, it should most likely just use the standard
> "gpios" property.

No, that's a different thing - the PMIC will typically be able to use
some pins as GPIOs so most expose a GPIO controller.  The functions that
are an issue here are things like voltage selection, voltage transition
completion status, sleep mode, enable control or whatever that may need
to be tied to the SoC for interaction (usually not just limited to the
regulator bit either).  A lot of these things get done either to bypass
register I/O or because they are used as part of power up/down
sequencing and need to be done by hardware. =20

If there's any overlap it's with pinctrl though you still need to map
the connected functions to any software controllable GPIOs they're
connected to.

> > > I don't think there should be any named GPIOs. If we want names, then
> > > the GPIO usage should be possible to group quite easily rather than c=
reate
> > > a new property for everything. Something like "enable-gpio" comes to =
mind.

> > I don't understand the difference between your suggestion and named
> > GPIOs.

> What I'm trying to say is let's not let drivers invent their random
> *-gpio[s] property as those essentially creates new kernel ABIs that
> we're stuck with.

> Instead, let's try to use standard properties where possible like
> "gpios" and "enable-gpios", "cs-gpios" and so on.

Oh, OK.  Yes, standardisation of the names has benefits though for some
of the features (especially voltage selection) the implementation gets
rather chip specific and there are also advantages in having the DT
binding correspond to the chip documentation.

Things that really are very standard probably ought to be being done by
the core anyway (like we've done with all the factoring out of standard
voltage map and regmap operations).

--UlgRIH+VC25VUu7I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSr46+AAoJELSic+t+oim9X/AP/3Kt+mbtDL8j7nyFrAaac7wM
4Q3M+Bojb3Nm4l6O6DCgho8a9b5+bsdK0ACoEQcoxChglDNzjPxPizAKnKyPSHGO
FbES8X9U6bLlCVCRg8ZosDJVHaqaiDPfYqtN2XBafRVDFPLik5UuVDYDuNyEanMC
RFxTp1DuegOqfTWR5Uw7hf7QYM1a5ktid0IMbWk6p+YglKA+z2rCoP6Y2dLZB2Fu
5XhU/r3z1osWoft99ggO0z2rtmII/h2nURWcPjYc+meQyBZvWNvFIkcgFGa9pxlE
16r1lVe03O9wmwFiOpJNALyDtqp1HPNlmHIDvVYu8ose8gq82wcG7BtN81kuuP0W
HpP++x6EDy3iOwRzsAv2OOP6IDoBfHxrQkVn64CzAP+0IP4SYI9p5mDfJwFuJ0ED
83oDZHUINYaQYdBZEIPQ3hHEj3f4KgFG4QllMChS1aAucLn4zl57PE2roBDrHqCR
r+OGvUIrP8IUKHieFb8QppETZGt5AYZc1XwMlQ7idQsEU6zsQrtiythXGYLm/iYQ
BksV7t+pSOdE4tgPzYW3viwo02zw0iOsWybLyphPH1FYD84vJW802O/Z7BAMvGdZ
xKfCDr4W3bOKYPwgIC14V7NNTUubT3InhjDUlvAjyQTcWru7EYLVTMerqC+V8yHx
Uccdg5TCVl6Jq9Hssgaz
=nnlp
-----END PGP SIGNATURE-----

--UlgRIH+VC25VUu7I--
