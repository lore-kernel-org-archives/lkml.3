Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbaAaWuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:50:50 -0500
Received: from top.free-electrons.com ([176.31.233.9]:45533 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932313AbaAaWuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:50:03 -0500
Date: Fri, 31 Jan 2014 23:49:18 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] spi: switch to devm_spi_alloc_master
Message-ID: <20140131224918.GJ2950@lukather>
References: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
 <1391163792-21819-4-git-send-email-maxime.ripard@free-electrons.com>
 <52EBCCCD.301@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vzUQzca511KWT6Hk"
Content-Disposition: inline
In-Reply-To: <52EBCCCD.301@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vzUQzca511KWT6Hk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2014 at 09:18:21AM -0700, Stephen Warren wrote:
> On 01/31/2014 03:23 AM, Maxime Ripard wrote:
> > Make the existing users of devm_spi_register_master use the
> > devm_spi_alloc_master function to avoid leaking memory.
>=20
> > diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
>=20
> > @@ -1087,14 +1085,13 @@ static int tegra_spi_probe(struct platform_devi=
ce *pdev)
> >  	if (ret < 0) {
> >  		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
> >  					tspi->irq);
> > -		goto exit_free_master;
> > +		return ret;
> >  	}
> > =20
> >  	tspi->clk =3D devm_clk_get(&pdev->dev, "spi");
> >  	if (IS_ERR(tspi->clk)) {
> >  		dev_err(&pdev->dev, "can not get clock\n");
> > -		ret =3D PTR_ERR(tspi->clk);
> > -		goto exit_free_irq;
> > +		return PTR_ERR(tspi->clk);
> >  	}
> > =20
> >  	tspi->max_buf_size =3D SPI_FIFO_DEPTH << 2;
> > @@ -1152,8 +1149,6 @@ exit_rx_dma_free:
> >  	tegra_spi_deinit_dma_param(tspi, true);
> >  exit_free_irq:
> >  	free_irq(spi_irq, tspi);
> > -exit_free_master:
> > -	spi_master_put(master);
> >  	return ret;
>=20
> Doesn't that s/goto exit_free_irq/return/ leak spi_irq? It's only OK to
> replace goto free_master with a direct return.
>=20
> The other two Tegra drivers don't seem to have this problem.

Ah, right. Thanks for noticing.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--vzUQzca511KWT6Hk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS7ChuAAoJEBx+YmzsjxAgvtAP/1KxEL0xQB5zvkoP1ERL30S1
89xGJ+bYNkZ1YTD/Cl9Vn7QDED/tMKCNw2f0H/naitkbwprRWrHeXqQe5Pm+YKbb
JlCg7maUKPVwkTvoUoWg6GT7dbLnpdp2bQ7Uri9fQHV71AkVDIxuvj2uy0tIQh4y
bqwRNDl5M6PJ3fscIzN2zfzM3jjXd+UBj40pKqwoRtp+83in7uGVynqxfgJhG0nQ
7r/byV/z8fLNPJwJaMEOG8RHgUOkPvcqnYkNbEIWRA9CP0FBnFeD1SNx54yNVyaN
iuQVJgi4CM3rApsxh6b30jYaiyu0E2g9mAaClBd/Vu47g2mvGwcaRMJZsfw5JJat
kGx5HJVPpCnkIkxcP19gDnsExuXkeweHDdrOp2YR7cB1Xdi+sAWM/NrJ/oxqsCGO
gpYmhqeDUktEwIfMewEu3o5AZUwh7yW1XdlibdFqAR+xJznic6uOfeWr8ijUagu0
c97jodZ8qsfgtS2DjIOeL/5hzVscIDvsiee5Zk0p97vLTduKt7G9Ylx+eIHbP/6q
wV12DtLmxxC8GX010CoMfiElfiRY97MpOje+emROxSrUZdJlJ1GK4wvtOZu54mwX
/P5kuKDkJPvB8thj4q85vEf63x4AdTFtwJDotnSRBc7dxgjocviW29hBl0ROaTEl
X8tnbK3z+PvVl4M/Juyz
=yAWA
-----END PGP SIGNATURE-----

--vzUQzca511KWT6Hk--
