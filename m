Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab3GBKnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:43:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34728 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab3GBKnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:43:49 -0400
Date: Tue, 2 Jul 2013 13:43:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        <spi-devel-general@lists.sourceforge.net>, <grant.likely@linaro.org>,
        <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
Message-ID: <20130702104338.GA5107@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
 <20130702093247.GY27646@sirena.org.uk>
 <20130702094404.GL3352@arwen.pp.htv.fi>
 <20130702101718.GE27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20130702101718.GE27646@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2013 at 11:17:18AM +0100, Mark Brown wrote:
> On Tue, Jul 02, 2013 at 12:44:04PM +0300, Felipe Balbi wrote:
> > On Tue, Jul 02, 2013 at 10:32:47AM +0100, Mark Brown wrote:
>=20
> > > Does this hardware really support anything other than 8 bits per word?
> > > There is no code in the driver which pays any attention to the word
> > > size...
>=20
> > the HW has a 128-bit shift register ;-) but driver doesn't look
> > complete.
>=20
> That's not the issue - remember that SPI specifies big endian byte
> ordering for words on the bus so things will need to be reordered by the
> hardware for anything except 8 bits.

right, the driver is far from being complete. In fact this driver is
quite buggy, if you look here :

> +static int dra7xxx_qspi_start_transfer_one(struct spi_master *master,
> +		struct spi_message *m)
> +{
> +	struct dra7xxx_qspi *qspi =3D spi_master_get_devdata(master);
> +	struct spi_device *spi =3D m->spi;
> +	struct spi_transfer *t;
> +	int status =3D 0;
> +	int flags =3D 0;
> +
> +	/* setup command reg */
> +	qspi->cmd =3D 0;
> +	qspi->cmd |=3D QSPI_WLEN(8);

Sourav hardcodes wordlenght to 8-bits, and yet he enables 8, 16 and
32-bits per word.

> +	qspi->cmd |=3D QSPI_EN_CS(0);

he's also hardcoding the chipselect line which should be take from
m->spi->chip_select

> +	qspi->cmd |=3D 0xfff;

and he's hardcoding the frame length to 4096 frames!!

This is all buggy.

--=20
balbi

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0q7aAAoJEIaOsuA1yqREAR0P/RlrlVr39YQQxlNaBNcnbAg3
6GHnUv9iGuSCpoiT4P5zseMhXENXQmnQeRsNQ25VojjbUGRniAry1/3xkLzoO8cd
iZ0C8zD+86XFEtPpDjKKkGN9j26fT/+8K/db6blgk/VxdUhhV/ExWBgzM7NBFe4D
qnnbcL1j28y72Q7L+tbzdkjAKBGdLYN8H4ylwY1MVFV7bmUO0gN7j3dWia7o40Gr
3puIhpXl/8u91gxbRnSFaw01r7E+l9e3TTlNm9nCWa0p19zmCo0cRmnWzQJPfS7l
0+MCS1Atyi+sBY9UzakBLDgX96HA1NXw8INfgv3xGDpJRFDGzy/+5YqIHGisPigx
7LjdGVv7Y5k+lrGviJop3NzHfQPPfTMCmnhJUHEksP7Ba3oCYGxX2OXxx29oIaBj
EgfBQz0f+yo8FqI03K4cGlYbwXhTdx/YKybm4cbciLvMvaeoHcnGEjLrFzOaYzJn
inHSdIeHsmEBv9rpGYdI7kr5N8RwLXp3N4fPVeCiX9RfPbBfXBK/YbB4vQ37GHdc
NONKSBGycNrBkZ5Zm5dr1uS3hgyZMmEfWE78niI5ZF07g/WV/ZdJgblnphpOHGHe
88vYC7vm0eG95Po7pXOK0srpupJ4F+YpWcBWkHQzXxvoOwiBDdGVVQAeY5wNPTws
aA4yun2Ely7fh5lTsD1F
=QF1n
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
