Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbaDXNfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:35:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43914 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaDXNfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:35:04 -0400
Date: Thu, 24 Apr 2014 14:34:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Markus Pargmann <mpa@pengutronix.de>
Message-ID: <20140424133451.GZ12304@sirena.org.uk>
References: <1398294650-24821-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oEJOO7UOs/0+8V5e"
Content-Disposition: inline
In-Reply-To: <1398294650-24821-1-git-send-email-nm@ti.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESEND PATCH] regulator: core: Disable unused regulators after
 deferred probing is done
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oEJOO7UOs/0+8V5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2014 at 06:10:50PM -0500, Nishanth Menon wrote:
> From: Saravana Kannan <skannan@codeaurora.org>
>=20
> regulator_init_complete does a scan of regulators which dont have
> always-on or consumers are automatically disabled as being unused.
> However, with deferred probing, late_initcall() is too soon to
> declare a regulator as unused as the regulator itself might not
> have registered due to defferal - Example: A regulator deffered due
> to i2bus not available which in turn is deffered due to pinctrl
> availability.
>=20
> Since deferred probing is done in late_initcall(), do the cleanup of
> unused regulators by regulator_init_complete in late_initcall_sync
> instead of late_initcall.

I'll apply this however since as we discussed on IRC last night it's
going to make the issues with unconfigured regulators getting powered
off more severe before I do so I'll change things so that regulators
with no configuration at all don't get touched by the core.

--oEJOO7UOs/0+8V5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWRL4AAoJELSic+t+oim9Q5cP/3W9p38GZcjKUznTkZYWx8qx
7NFVlOfpGN/59FIBVWNTHRp2j7dmdK1/vOCXlVI7PBZuumQRXTM68q1yaeyzMRbh
RiDDSlaE9yJ5a2hGbCFp+Cs/c19i8Nx9le4UjcQvDmiPtw+THYOAp5LTVQVfWguS
C8+bShinYWxgPTEZyOZyvPR6PdBzI4gxTcselPLqinfHSRrcZQ+Yqo84J1EVTj+8
2azCctf3D7n6vSt5TzWIvy/Vqx/+kOMdpnkaWc2BJrclCOEk1U+ZLGtLccVBILGS
S1qYTH5NluRzDFsFuAQFWZIIR7TGMN05Cuu+NuN4Lk+EqIYUeXGXWdScpjl9KeWd
CgvwYZblUyTiE28EHfNwa8mSL7+KlvDIVngyTh9Nr/Z9l8m8jTFnqLvvwuhhao2m
+e8OCJA3vhlhGGIeXwf057PTDhhshL4JKa6N/hccGbIMfM9vwuN6YWL28l/5VHYA
d1gOfukovOYKlgMKqkOLaU0eEaZ4zV0mHMeursAwcQhYhL7phAhRy4P0ixQaY3Pj
NcPyvNr3nwOM9Nzrl8ei03TjpxgDta7zga+RGUmJu8K2qDtCqUOfJdT1H8MdVwLv
ILFKMupq39o1MJ66XG/3YaU0gvVB+8WIf3th20lN81kl8Y37nUK0Oofl+paDh7eT
tPGZZtWb3CxbIroTRKqJ
=fV9r
-----END PGP SIGNATURE-----

--oEJOO7UOs/0+8V5e--
