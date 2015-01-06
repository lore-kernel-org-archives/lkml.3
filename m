Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbbAFMAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:00:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38014 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbbAFMAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:00:34 -0500
Date: Tue, 6 Jan 2015 12:00:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, linux-ide@vger.kernel.org
Message-ID: <20150106120012.GW2634@sirena.org.uk>
References: <1419614799-5770-1-git-send-email-gregory.clement@free-electrons.com>
 <1419614799-5770-2-git-send-email-gregory.clement@free-electrons.com>
 <20141229154030.GJ17800@sirena.org.uk>
 <54ABC8A2.7090905@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4dbYIUm7Fhfg+fSv"
Content-Disposition: inline
In-Reply-To: <54ABC8A2.7090905@free-electrons.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: core: Add a sanity check on the
 regulator_ enable/disable functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4dbYIUm7Fhfg+fSv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 12:36:02PM +0100, Gregory CLEMENT wrote:
> Hi Mark,
>=20
> On 29/12/2014 16:40, Mark Brown wrote:
> > On Fri, Dec 26, 2014 at 06:26:38PM +0100, Gregory CLEMENT wrote:

> > No, especially in the case of regulator_enable() this is deliberate -
> > we're trying to ensure that if people are using regulators they're being
> > careful about it, checking error codes and so on.  I'd really want to

> OK so at least we should check that the pointer is not NULL before using =
it
> and inform the user of it by using a WARNING() or even a BUG() instead of
> just let the kernel crash latter.

Just crashing on the NULL is just about as good in terms of
discoverabilty and any consumer that is assuming NULL is not a valid
regulator is buggy in any case, any non-error pointer could be a valid
regulator as far as users are concerned. =20

> > see some persuasive use case for this.  What you're saying here sounds
> > like the consumer shouldn't be treating the regulator as optional at
> > all but should instead be using a normal regulator.

> Being able to deal with NULL pointer in the disable function is convenient
> and is done in other similar subsystems such as phy or clk for example. I=
nstead
> of having a check on the NULL pointer in each driver, it seems more logic=
al to
> do it directly in the disable function.

This really only applies if it's likely that some thing that always gets
used if it's there might be missing which isn't the case for regulators,
it's not at all common to have power supplies that might be missing and
if they are missing NULL isn't a good way to track them.

If you're having problems with this and need workarounds in the core to
make your driver code look OK that sounds like things are working since
it sounds like the driver code is probably abusing the API here.

--4dbYIUm7Fhfg+fSv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUq85LAAoJECTWi3JdVIfQKSIH/A2d6R/AVXY8G1pTOSV/ME6T
5X1RmfNFO9B5CLRM/IXbXEd1gvKK6Dep6p5hX877p5M3oirfCIKecBhueoUycUs9
N/2q2HQQbUmtOBjLFv6yzowcmXmn38+iaqiwjakNaFHlg1BTn5nmnjcWO4rovuDG
GAzRc1MMDwZGt0oC57lUsqbCIZ7J80wKQQYLaV556KRVQxvM83iE4EwNvzzWYzIe
rVnqKdkp8lMe92fUp1tK++s1Xh91Vr60DT65wXrKTnmWaHb93IbfWlJ6F+zPccG+
Gwdw6FqgLREN4Re/fpLNF2NCEH6jCIrae6iD52p6nvBMFIMpBMUYyjqVUcuQTH0=
=1jYK
-----END PGP SIGNATURE-----

--4dbYIUm7Fhfg+fSv--
