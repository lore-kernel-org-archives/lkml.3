Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3JVIJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:09:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36860 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3JVIJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:09:49 -0400
Message-ID: <5265037D.2080908@pengutronix.de>
Date: Mon, 21 Oct 2013 12:35:41 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
Subject: Re: [PATCH 3.2 094/149] can: flexcan: fix flexcan_chip_start() on
 imx6
References: <lsq.1382345188.205668698@decadent.org.uk>
In-Reply-To: <lsq.1382345188.205668698@decadent.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="U1cJU6tttdKKGTStTd5n79hGMO3CeSupE"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--U1cJU6tttdKKGTStTd5n79hGMO3CeSupE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/21/2013 10:46 AM, Ben Hutchings wrote:
> 3.2.52-rc1 review patch.  If anyone has any objections, please let me k=
now.

Please postpone until:

d5a7b40 can: flexcan: flexcan_chip_start: fix regression, mark one MB
        for TX and abort pending TX

hits mainline as this patch (fix flexcan_chip_start() on imx6) causes
another problem.

As soon as both are mainline, please apply them:

d5a7b40 can: flexcan: flexcan_chip_start: fix regression, mark one MB
        for TX and abort pending TX
0d1862e can: flexcan: fix flexcan_chip_start() on imx6

Marc

>=20
> ------------------
>=20
> From: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> commit 0d1862ea1a5bb876cf05555a7307080cb75bf379 upstream.
>=20
> In the flexcan_chip_start() function first the flexcan core is going th=
rough
> the soft reset sequence, then the RX FIFO is enabled.
>=20
> With the hardware is put into FIFO mode, message buffers 1...7 are rese=
rved by
> the FIFO engine. The remaining message buffers are in reset default val=
ues.
> This patch removes the bogus initialization of the message buffers, as =
it
> causes an imprecise external abort on imx6.
>=20
> Reported-by: Lothar Wa=C3=9Fmann <LW@KARO-electronics.de>
> Tested-by: Lothar Wa=C3=9Fmann <LW@KARO-electronics.de>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/can/flexcan.c | 12 ------------
>  1 file changed, 12 deletions(-)
>=20
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -666,7 +666,6 @@ static int flexcan_chip_start(struct net
>  {
>  	struct flexcan_priv *priv =3D netdev_priv(dev);
>  	struct flexcan_regs __iomem *regs =3D priv->base;
> -	unsigned int i;
>  	int err;
>  	u32 reg_mcr, reg_ctrl;
> =20
> @@ -732,17 +731,6 @@ static int flexcan_chip_start(struct net
>  	dev_dbg(dev->dev.parent, "%s: writing ctrl=3D0x%08x", __func__, reg_c=
trl);
>  	flexcan_write(reg_ctrl, &regs->ctrl);
> =20
> -	for (i =3D 0; i < ARRAY_SIZE(regs->cantxfg); i++) {
> -		flexcan_write(0, &regs->cantxfg[i].can_ctrl);
> -		flexcan_write(0, &regs->cantxfg[i].can_id);
> -		flexcan_write(0, &regs->cantxfg[i].data[0]);
> -		flexcan_write(0, &regs->cantxfg[i].data[1]);
> -
> -		/* put MB into rx queue */
> -		flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
> -			&regs->cantxfg[i].can_ctrl);
> -	}
> -
>  	/* acceptance mask/acceptance code (accept everything) */
>  	flexcan_write(0x0, &regs->rxgmask);
>  	flexcan_write(0x0, &regs->rx14mask);
>=20
>=20


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--U1cJU6tttdKKGTStTd5n79hGMO3CeSupE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlJlA4AACgkQjTAFq1RaXHNARACgltJsFtDYbz522OawGQC09XSk
GZEAnAxONI5dmKqEHFLfyluq0mk6itqU
=EtVY
-----END PGP SIGNATURE-----

--U1cJU6tttdKKGTStTd5n79hGMO3CeSupE--
