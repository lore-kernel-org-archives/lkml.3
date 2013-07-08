Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3GHOuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:50:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41461 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3GHOuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:50:07 -0400
Date: Mon, 8 Jul 2013 15:49:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Message-ID: <20130708144930.GG27646@sirena.org.uk>
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
 <b4458c93742bd9dfe69e3553cf377a703c945f81.1373290150.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5wAPvwbAcQJrmmvx"
Content-Disposition: inline
In-Reply-To: <b4458c93742bd9dfe69e3553cf377a703c945f81.1373290150.git.michal.simek@xilinx.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 3/4] spi/xilinx: Simplify irq allocation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5wAPvwbAcQJrmmvx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 08, 2013 at 03:29:16PM +0200, Michal Simek wrote:
> Use devm_request_irq() for irq allocation which
> simplify driver code.

> @@ -495,7 +493,6 @@ static int xilinx_spi_remove(struct platform_device *=
pdev)
>  	struct xilinx_spi *xspi =3D platform_get_drvdata(pdev);
>=20
>  	spi_bitbang_stop(&xspi->bitbang);
> -	free_irq(xspi->irq, xspi);
>=20
>  	spi_master_put(xspi->bitbang.master);

Is it definitely safe to leave the IRQ hanging around after the master
has been freed - there's no possibility of a late error interrupt or
something?

--5wAPvwbAcQJrmmvx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2tF3AAoJELSic+t+oim9EKMP/1xBt9VO3AJi2/jSXyfX5+Ah
Xh/qzvSQUmW1VDr2l2oQvDDfH3uO1QZolXpBxreINVFdzrqBQ4PObsIgFWYS4MhJ
f107fxby+1Fy2D64aCAA0hZjZSqetlOq3ZPe2EJDJxIM7nkmm8RzxN+Ru13bYEM9
KsFU7fHaxMwegg80Pv/rmiisR5CqqdOdnXrbWFy3ocnk1xAN7D/DjwqOG0KqzM6N
DCJytl574Ocs6thnojlS5TL2JjBkcEvEFkxfxXNTNGDv08M6B56S2oZQm2l0tPaZ
iu1X+Xg96W49KKKUvf2YAAmrloltDW9LtD6sPR8wUmtCkjL0zmj8ItG2UWa59AVQ
T6KUnfzIJLMbTeaerJjH5WE4/Nkju6OvW1UK/LvHnrlCAQQUH/aWedXpLB3TbhMy
w/Jv5dUILu2/cNeSMwegTH29HDofAgAv6+tQnXj3oGPr1+Smn4BJwSZj8hXqofFH
EFlEYpZTcm13aMjo2SKsg608vesmy9PIC/6Xny8dlSPAS8PrTWe2nam1BrriJgBm
g+YqH8ETVUjPaHyHew8RaKIbN4eJj86UiW1+oXa8sgvSlEXUTZp51ZAs6HkrEQa9
3iRJEsU+55PF4RV54eEmkOeqCnB41XHuSyOQ1aciByvjXShXqT8DUPyi6zNISXD0
s+swoSPnzwLdo3cBi4N9
=2Q0u
-----END PGP SIGNATURE-----

--5wAPvwbAcQJrmmvx--
