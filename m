Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033AbaH0ToZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:44:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36545 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935556AbaH0ToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:44:24 -0400
Date: Wed, 27 Aug 2014 20:44:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140827194411.GU17528@sirena.org.uk>
References: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk>
 <53FE2446.3040402@gmail.com>
 <20140827183733.GN17528@sirena.org.uk>
 <53FE25EB.7060702@gmail.com>
 <20140827184705.GO17528@sirena.org.uk>
 <53FE2901.50508@gmail.com>
 <20140827191526.GS17528@sirena.org.uk>
 <53FE2F9E.80501@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6PDkkIznEI+zY3BQ"
Content-Disposition: inline
In-Reply-To: <53FE2F9E.80501@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: max77802: set opmode to normal if off is
 read from hw
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6PDkkIznEI+zY3BQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2014 at 09:21:02PM +0200, Tomasz Figa wrote:
> On 27.08.2014 21:15, Mark Brown wrote:

> > This is in the scenario where the previously running Linux changed the
> > mode to something other than normal and where the freshly booted Linux
> > can't figure out how to do that when it needs to.  I'm not sure how
> > plausible that scenario is, or that real systems would handle it
> > robustly.

> I'm not sure I'm getting your point.

> If the only thing Linux can do is read back the opmode from PMIC
> registers, it doesn't explicitly set it to something other, but rather
> reuses what was set by something before it (or, after this patch,
> defaults to NORMAL if it's OFF), i.e. the low level firmware or Linux.

> However the information about original setting is lost whenever Linux
> turns the regulator off and performs a warm reboot, which I believe
> would be a quite common scenario.

The point is that if anything was setting the mode to something other
than normal it was almost certainly a previously running copy of Linux
and one would expect that if the mode does need to be changed the new
copy will be doing that anyway.  It's rare enough to need to actively
manage modes in the first place.

--6PDkkIznEI+zY3BQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/jUIAAoJELSic+t+oim9DQgP/0Bxrl4n5C43L+j8yqeYrD4D
knra4JUSpAOwSA6HVOHJCOxK9cmzcD1qT04XZAFDXBFVFozQVWH/tpSNw+QCPB/k
L9IvWsF4KrmO4flt8lrVz+CfOICFj+3pgfBZ8UlXsEhuG1JV5wHUrKUUbruR8U0O
TxIawBRVzby6L0QnQQLLKH8WIf9/T2Z4ETjWI39Jm18qAdc5W2SeDYyDnMazZnFx
uQH2Xn/9fZfaa9pOG+3d2fXEB2i2XM/ZHnFTzW5lo/aj/9f847c1sDsYEBd8Nq2q
HCcBwQPLc2hc9kue8bpGPl7vT3zG5GL2AvHFbYbXP4DA+adCzSrkzSxRRtDSLCV0
SFF7DhYM7q+GuC5DvrC/3iFfFg0d0W3irlQl1NT9MZeZ+NWHkyHcfCBQkGYqBiOi
7nV24Vk063hOl3Q+BcLbKKEV0Wg5vTz7p1TQUkFj4Yvawn5wuIbRrY27ESHfcIAF
pbpkoslWZQlr7DakKM2RAHv0fLunC81I5SDNucQB5mzUAKxkDYB9P7bgcMAeCe9A
eUJ6Kw2N6yj0YRSA9D+9UJ87B+Uy0gtzfYzZR6663xnXVZkAazsPhnAF+S8i0sBO
sReEsD3GOsZyxfEsuAW1qY517k2iPEIb/eCRWHOkX2dI6rE7uf8pm0QqQZr1Efb9
rnX72YMGMEoRiSPASH6k
=XXLh
-----END PGP SIGNATURE-----

--6PDkkIznEI+zY3BQ--
