Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbaEINwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:52:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39288 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbaEINwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:52:12 -0400
Date: Fri, 9 May 2014 14:51:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        sjg@chromium.org, grundler@chromium.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de, cpgs@samsung.com
Message-ID: <20140509135153.GM12304@sirena.org.uk>
References: <1398350916-885-1-git-send-email-ch.naveen@samsung.com>
 <20140424162558.GB12304@sirena.org.uk>
 <CAHfPSqB5+mLiC07jbEpeUgW63pZVk700SkYGxToO7GRAsFm_nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mpNcIJL4U0bEY9+B"
Content-Disposition: inline
In-Reply-To: <CAHfPSqB5+mLiC07jbEpeUgW63pZVk700SkYGxToO7GRAsFm_nQ@mail.gmail.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] i2c: exynos5: Initialise Samsung High Speed I2C
 controller early
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mpNcIJL4U0bEY9+B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 09, 2014 at 05:50:00PM +0530, Naveen Krishna Ch wrote:
> On 24 April 2014 21:55, Mark Brown <broonie@kernel.org> wrote:

> >> Such solution has been proposed by Mark Brown to fix the problem of
> >> the regulators not beeing available on the peripheral device probe():
> >> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-March/011971.html

> > What specifically is this needed for?  We *should* be able to use
> > deferred probe for most things, but I know that not all subsystems are
> > able to yet.

> DRM related drivers like DP, FIMD, HDMI, Mixer wants to be probed ASAP
> during the boot.
> The real problem comes when, one of these drivers do a regulator_get().

> If the physical supply  is not enabled/hookedup the regulator_get() call
> assumes that physical supply is present and returns a
> "dummy_regulator" (But, not an error).

> Because of which, Display and several other devices fails to work.

These drivers are buggy, if they geniunely expect and handle a missing
supply then they should be using regulator_get_optional() to request the
regulator and even if they don't the use of subsys_initcall() is not
going to fix anything here - if a dummy regulator is going to be
returned the time things are probed won't make a difference.

> I2C, I2C_TUNNEL, SPI and DMA drivers are required as subsys_initcall()
> for similar reason.

What makes you say this?  Typically those drivers don't use regulators
at all.

--mpNcIJL4U0bEY9+B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTbN12AAoJELSic+t+oim9tt4P/ianGaD5q8ymN951nJdeJi/J
/GR9nLcBmKEbVGjFZVNI/q+zGralwSAdMj5P8Nc7MZyuY8A9PEs+GMdqopeTQtdV
sh7oO6UhwdUDzOFxTncfRztnfpkYbeLj3O0kgLHimhi8XWgGF6nZfEHHg5/A2u85
dNYw5jRYM6A2621K0seUOURpJWugKC2bJa4nKEigV3El5coO2eZaVbpdlS7/W7y6
tQ/onjZWZYpHNVhRNFKHzSAuv5sU9qILp6rU0hOIW5MJAYEHNlVFWQW1OU8BS7vE
I3Ex/Tcx3DETRcOhhL/fCYOHUqLc8CBSRO8hHNerbSf5PmE9nALRbGolW71bZy8Q
D3KyhkcUnl3LcuL6aIcXawg4Cnkvp4s1inu77sHEj7zM1QT51VfhCqOqCvZy+OM0
HQjF8uG3q5Tt/Xv8ECIiTE27xkxgwL0RXDY6Ybeh/3wpsbogoyAa+vaEjTMJ9NRH
u7hn9BbzcDmptJj/vSZLDi0qyyqZ4BteSP06XlVWDNRNNPNrSmqqOBhE1LCMCF+N
ujKUIq+OZ0WhEvo1/Z0DHjUw+FtVlt0VL0Te3FkZtUFq/ZcBQmJfJXNEDdd6EsL2
d8WYnloP8ytNJLoBgdJ81Dn3G8LpnxTnb3PrMheOYgW59FOQ05r87IZt5ik/KKSP
uxq+rNe8xUp0cTjXU+yw
=u6Jv
-----END PGP SIGNATURE-----

--mpNcIJL4U0bEY9+B--
