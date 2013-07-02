Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab3GBLEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:04:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58233 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3GBLEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:04:38 -0400
Date: Tue, 2 Jul 2013 12:04:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>,
        spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130702110432.GJ27646@sirena.org.uk>
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
 <20130702093247.GY27646@sirena.org.uk>
 <20130702094404.GL3352@arwen.pp.htv.fi>
 <20130702101718.GE27646@sirena.org.uk>
 <20130702104338.GA5107@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0uEakrcbPVGl0QO8"
Content-Disposition: inline
In-Reply-To: <20130702104338.GA5107@arwen.pp.htv.fi>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0uEakrcbPVGl0QO8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2013 at 01:43:38PM +0300, Felipe Balbi wrote:
> On Tue, Jul 02, 2013 at 11:17:18AM +0100, Mark Brown wrote:

> > +	/* setup command reg */
> > +	qspi->cmd =3D 0;
> > +	qspi->cmd |=3D QSPI_WLEN(8);

> Sourav hardcodes wordlenght to 8-bits, and yet he enables 8, 16 and
> 32-bits per word.

Yeah, that's what I noticed (well first off I noticed that there were no
constraints on bits per word at all).

> > +	qspi->cmd |=3D QSPI_EN_CS(0);

> he's also hardcoding the chipselect line which should be take from
> m->spi->chip_select

This one *can* be OK if the driver only accepts one chip select (though
obviously supporting more is better).  I'd really only done a fairly
high level review for framework stuff so hadn't got that far yet.

One thing I really want to get round to doing with the SPI core is
providing an easy to pick up GPIO chip select as standard=20

--0uEakrcbPVGl0QO8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0rO9AAoJELSic+t+oim9/icP/04F45yCdn1B7anQgFZwmjYe
XuvyHwMbJRHboM43B5ZuVtDeiFBR64VbM9av0JmiCcdGxbIGUwc61Pzj8YcGNGbC
+pKLGiUHahuIDJrCOQz6HfkA1pt6GqRcEHmCry/v8GFQodwIrfYyu+Jy/+SSkrd6
r1vh8k+5ecjII20YCgkn4X5fMut004PeIydTo6+lyaCJQBBhpOK7nN9XaQ7uR1Sp
5P+ZI+WGsJuFHj3sYkAbe77B84sq4UP6M8UpAPQwEQZx/VZp60vp/yyCixed3ntr
HymFJk21mjbm8sJ8MYl32F3yG3pr2XGdpIiNyYs83PnGg3BoOzO2A3h9CjpgZt0f
c5c7Pg/C+26V5hGxqdxJAztITMOHt9vxCSWjdYPOM0BG2T+pPXsTzSFLz7Mc8GTl
5MofPJhkSe7o7DnjzQhMoCRo32/NZluqE2uwe9cFufqNFApMzJo9vEhd68ttD+jd
TS6FQh6IQj0IwwF8jx+luIWWJ2dX3JMy/UKEoN/mS4UZNyRbC3o6CKM4F0xUlxsX
2e2yYicCso5qHaQmHZSbKwqf5lVJeQkcrVBgTBJtQREQLevvAC0RGcZ78G291b7W
sGyjU2C0lJWk+6VwVstogQfvfUgnApqFvBamkXAMAtaMB+sDqrYPPOfJzZSdu0/J
lprgbktWiCSbmzDvZtox
=ZiK7
-----END PGP SIGNATURE-----

--0uEakrcbPVGl0QO8--
