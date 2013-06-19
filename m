Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3FSSYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:24:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48366 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab3FSSYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:24:18 -0400
Date: Wed, 19 Jun 2013 19:23:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Girish K S <girishks2000@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca
Message-ID: <20130619182354.GD1403@sirena.org.uk>
References: <1369032694-13183-1-git-send-email-ks.giri@samsung.com>
 <1369032694-13183-3-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P4O8mEax7ExP9NSJ"
Content-Disposition: inline
In-Reply-To: <1369032694-13183-3-git-send-email-ks.giri@samsung.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 2/3] spi: s3c64xx: Added provision for dedicated cs pin
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P4O8mEax7ExP9NSJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2013 at 12:21:33PM +0530, Girish K S wrote:
> From: Girish K S <girishks2000@gmail.com>
>=20
> The existing driver supports gpio based /cs signal.
> For controller's that have one device per controller,
> the slave device's /cs signal might be internally controlled
> by the chip select bit of slave select register. They are not
> externally asserted/deasserted using gpio pin.
>=20
> This patch adds support for controllers with dedicated /cs pin.
> if "cs-gpio" property doesnt exist in a spi dts node, the controller
> would treat the /cs pin as dedicated.

This breaks SPI operation on my s3c64xx based system since...

>  	if (pdev->dev.of_node) {
> +		if (of_find_property(pdev->dev.of_node, "cs-gpio", NULL))
> +			sdd->cs_gpio =3D true;
> +
>  		ret =3D of_alias_get_id(pdev->dev.of_node, "spi");
>  		if (ret < 0) {
>  			dev_err(&pdev->dev, "failed to get alias id, errno %d\n",

sdd->cs_gpio is only set to true by this code so if you're using a board
file then the GPIO will be ignored.

--P4O8mEax7ExP9NSJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwfc3AAoJELSic+t+oim9NU8P/jXrpUOXTp9aat2xMvuqie2Q
BsRY1zBZQdEllJEw529ahZoDbQhCZRU1VPyGJYFVSdHsqQ1xSSqIYiAXppIDGJWT
iy/jTUNIqzZQ1Z/K1XAJGd95zrxijBm0eTIZu4YyC64c8DgWOak2vR9blYurlPwK
R7QD7G9YYIXfe01ZPgqVsrzYnZOIdWDuI3J1QKBsFo9B3YH5Ovp56MNz1gYG8pxO
rr9aWs9utyI5j6t8GnylBNaXCNPoLTG//rIXsLvHBOX1Q+OaAY/hdFaT8Ym7cGZ8
1r39X7PbK1xemLFiRnxURurFeW1StrZNeWtcvXlhp1jnsAbI+BQHl8JJID7ATOzL
+duIE9GXDln/DuDBja/cc45t8wnYAgQAu26RdXuNLLc6nB+mw3aPLbl7u9zBg74k
ZeeHWYGd83MhQhnJ8y6jiVBLUsiHSz+5v70jpTp+GLwimUu/Fl9oGvaD8hqSWbNS
AfltlsOJyxfoSCMl/uVxNgefD8y+42GyqpY0l9hDr7+UMKuy/K3yaKZY58PpzzXp
WV7ScS6zc8TdtJqkYXQ8QKBcYmspN1R3B9pEFywguf7UZlxC7dns1eDg/zuXT9Yl
i4+ehMLbpsWDymVgrJk2HE1YFvyyQCwHF5GC5QZcNmg1qDrqxFYybPKCV/+i4EEz
Y5Jnpsndf1fRDVraLue2
=GLNV
-----END PGP SIGNATURE-----

--P4O8mEax7ExP9NSJ--
