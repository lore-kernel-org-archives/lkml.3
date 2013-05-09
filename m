Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3EIJlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:41:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33381 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab3EIJlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:41:31 -0400
Date: Thu, 9 May 2013 10:41:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130509094103.GA7478@sirena.org.uk>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
 <20130508105124.GA7478@sirena.org.uk>
 <20130508114216.GB29130@balto.lan>
 <20130508123225.GK7478@sirena.org.uk>
 <20130508131020.GA30503@balto.lan>
 <20130508135413.GR7478@sirena.org.uk>
 <20130508141723.GA12155@balto.lan>
 <20130508142938.GS7478@sirena.org.uk>
 <20130508154805.GA12970@balto.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dfOvyYudzT1RPUKx"
Content-Disposition: inline
In-Reply-To: <20130508154805.GA12970@balto.lan>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dfOvyYudzT1RPUKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 08, 2013 at 05:48:05PM +0200, Fabio Baltieri wrote:
> On Wed, May 08, 2013 at 03:29:38PM +0100, Mark Brown wrote:

> > So if these pins are being shared between the instances then surely
> > there are other interdependencies that need to be taken care of Is that
> > happening?  For example if the clocks are shared then is the code
> > currently stopping the interfaces being configured with incompatible
> > sample rates or word sizes?

> That's an interesting point.  Mixed format, rate and channel counts
> seems to work just fine, but that's probably because the supported rate
> and format is locked by the codec to 48k + S16_LE.  This is in line with
> what is specified on the ab8500 datasheet:
>=20
> ---
> The AB8500 audio module exchanges audio data through the two digital
> interfaces at a fixed 48 kHz rate in different formats with up to 8
> channels per interface.
> ---

That sounds like there's still some potential problems with the channel
count, though?

> On the other side, I don't think anybody is using the ux500 with
> anything else than the ab8500, so I don't even know how would I test and
> fix this.

The fix should simply be a case of setting constraints when opening
additional interfaces based on the configuration of the primary
interface.  You can test this sort of thing by simply verifying that it
doesn't break the existing cases.

> > Well, most things would probably be able to get some small benefit from
> > doing this, it's just that we've not had any real support for managing
> > pin muxing - one of the goals of adding pinctrl is to make it easier to
> > deploy this sort of thing.

> Pin muxing is handled transparently.  The real problem is sleep mode
> switching, but that's really not needed if the codec has a proper low
> power mode.

I'm not following that at all I'm afraid - I don't understand the
relevance of the CODEC?

--dfOvyYudzT1RPUKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRi28sAAoJELSic+t+oim9gvUP/inixk4erdMjp90Jyj6Lglw0
AZBUQle1CayxIQJ2YHtoAJ9XJVtWiF/Qa/GG5B1tm7/YKSsfjQ8rXrCmA1oRv15l
0JAxRqx4AEMyvgpjkyQ54XJObYtKMotUIxrNooy55DQdknpPz6rCaQscTOaBQNID
bZN1/eDXJBaPbCrIC6C51Q3j6s0fwnm2DpET9t58uRhxt5uoo8g63G+TWNzi0QC6
/PenTsU/KFie3bZE1jtlVgCY4pqVEWWAdNsCVrcGA2ZXQkjtgy1xD4Mfk1mNv6eT
sbEENG4GV+jdXHqb7AvXGiZsRxPU4DouJLWsy3pC9JVySyrsDNxgUrkJ5uavpoex
bcMJEMHS9oQ3zZZz4my11AgJwQG/W12KmxrL5aVJkqdrda0nLJAEVVTLDXoMP5Al
sriOI06LOEIxIMRCi+XoebGsEnDuGn1xAftu+QqPOXHWP0UxfHf0jE18e4qMGBnW
XYDMIvL0h7rlRPiJOYPhikIfiTDrevetqRk3YXFE0fbqx5+6EK+Tegx/JEuVkL9k
hr1nx7aQO1O1UEo06/dFXhwZpCsbzrQpU5ePJ7rEBYZY/gPKPJs0JtHpcbbZepQC
ldnht9LQmpvC84DibG6r0DBYSZnzeZiVa0sIlyO/qMfQLgu8vmAWvd0ZAvuIUBKb
b/abcDnFbJdgtvZ1w6fs
=dipO
-----END PGP SIGNATURE-----

--dfOvyYudzT1RPUKx--
