Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3GBP6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:58:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46208 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab3GBP6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:58:39 -0400
Date: Tue, 2 Jul 2013 18:58:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <broonie@kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <balbi@ti.com>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
Message-ID: <20130702155827.GA7626@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Alright, so I spent some time looking at the SPI framework and :

On Tue, Jul 02, 2013 at 02:26:39PM +0530, Sourav Poddar wrote:
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

this m->spi->bits_per_word;

> +	qspi->cmd |=3D QSPI_EN_CS(0);

this should be m->spi->chip_select;

> +	qspi->cmd |=3D 0xfff;

this will be a little tricky to count... because, I believe it should be
something like:

	int count =3D 0;

	list_for_each_entry(t, &m->transfers, transfer_list)
		count +=3D t->len;

	frame_length =3D DIV_ROUND_UP(count, m->spi->bits_per_word);

	/* up to 4096 words */
	frame_length =3D clamp(frame_length, 4096);

	qspi->cmd |=3D QSPI_FRAME_LENGTH(DIV_ROUND_UP(count,
			frame_length));

Now, it would've been better if SPI framework would already give us
some sort of total_length field in struct spi_message which would be the
sum of all spi_transfers.

> +	/* setup device control reg */
> +	qspi->dc =3D 0;
> +
> +	if (spi->mode & SPI_CPHA)
> +		qspi->dc |=3D QSPI_CKPHA(0);
> +	if (spi->mode & SPI_CPOL)
> +		qspi->dc |=3D QSPI_CKPOL(0);
> +	if (spi->mode & SPI_CS_HIGH)
> +		qspi->dc |=3D QSPI_CSPOL(0);

all of these zeroes being passed to these macros should be
m->spi->chip_select

--=20
balbi

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0vijAAoJEIaOsuA1yqREp2kP/32rbawdCtptwh5qLxCUeHsq
t8dX+o2jD60H1YxzC7ezstOAKwoJTSlk/oKELw4TFZP6rWjTwkM1FiYXoeP/s0Qu
pmH9XsF7Pmswj4pTq9DPOv/BseOF3ZSezYr3kGFE6DS2KNWGY2gpmoGgV8l76nyE
zwvspPhmQITrpSyJ9WDZ+1bI6iMwRPGLL1/k6c4h6+65q6ml9kD5Xv/ZY2D9lyHJ
KR9BbDETRF6lkNr4/elBE4zFCcUFsdDvQar45QWCwhHInk0BtkCKoareKdKQ3nAL
xFWj8V5Hr9ARbWhk1tEUIjYBr8Y8l4ttd+iUGWvNM3cRKfYxRWu8VZpNEUERNiVp
RtJE+dtnBsvbQo5C2q1HAU6AQlsfhJDSYS3/ZyLji1Ox+i/Sxo5KzznBuL3hqqU9
gofPP9PQ2xSbEn9q4orCM2x14bqhRuTCeweMskYs6UK82Vr2hEzYGL1EPg+vmdpn
wpWiSZz0syunxSMrp2X2olWcbveE4+eUyLqCwDhnUPnFe8y63CgvMZwG8Y2Kqo7i
B2j18wjtuFs3C/lSMb/r9EMWVIcBuTp6h1flzQAtD7v1i71a2RYCgaONem/9xdUs
KYkFgoT5yPU5xgaRcSN2vuMI7u5+KG7Vq9mwrvVlkCkPbyip4F8h7xKlcSffs4gM
isRaXBE/C/pY/8JTTQGB
=mXSm
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
