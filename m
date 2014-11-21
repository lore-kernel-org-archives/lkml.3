Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaKUQI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:08:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47861 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442AbaKUQIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:08:25 -0500
Date: Fri, 21 Nov 2014 10:08:28 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        "Tony Lindgren" <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] i2c: omap: fix i207 errata handling
Message-ID: <20141121160828.GP7508@saruman>
Reply-To: <balbi@ti.com>
References: <1416529011-21803-1-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8G1nIWD3RY794FAy"
Content-Disposition: inline
In-Reply-To: <1416529011-21803-1-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8G1nIWD3RY794FAy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 04:16:51AM +0400, Alexander Kochetkov wrote:
> commit 6d9939f651419a63e091105663821f9c7d3fec37 (i2c: omap: split out [XR=
]DR
> and [XR]RDY) changed the way how errata i207 (I2C: RDR Flag May Be Incorr=
ectly
> Set) get handled. 6d9939f6514 code doesn't correspond to workaround provi=
ded by
> errata.
>=20
> According to errata ISR must filter out spurious RDR before data read not=
 after.
> ISR must read RXSTAT to get number of bytes available to read. Because RDR
> could be set while there could no data in the receive FIFO.
>=20
> Restored pre 6d9939f6514 way of handling errata.
>=20
> Found by code review. Real impact haven't seen.
> Tested on Beagleboard XM C.
>=20
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> Fixes: 6d9939f651419a63e09110 i2c: omap: split out [XR]DR and [XR]RDY

Tested on BBB and AM437x Starter Kit

Tested-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/i2c/busses/i2c-omap.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 90dcc2e..e7cbcb0 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -958,11 +958,13 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
>  			if (dev->fifo_size)
>  				num_bytes =3D dev->buf_len;
> =20
> -			omap_i2c_receive_data(dev, num_bytes, true);
> -
> -			if (dev->errata & I2C_OMAP_ERRATA_I207)
> +			if (dev->errata & I2C_OMAP_ERRATA_I207) {
>  				i2c_omap_errata_i207(dev, stat);
> +				num_bytes =3D (omap_i2c_read_reg(dev,
> +					OMAP_I2C_BUFSTAT_REG) >> 8) & 0x3F;
> +			}
> =20
> +			omap_i2c_receive_data(dev, num_bytes, true);
>  			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_RDR);
>  			continue;
>  		}
> --=20
> 1.7.9.5
>=20

--=20
balbi

--8G1nIWD3RY794FAy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUb2N8AAoJEIaOsuA1yqREDw0P/jVAXOEa7gB6gyCWSCO26Muu
gY15MoL2pXp1dtMrk4fgWgYjiYKpGAgEpLGhAPWZuni/PF5KnCo8qhN+szme3IxZ
teEaWyIZxhd8y8ORGNlP7bLHvY7r6G9JdnzPlYodvpKZIR+jgWTv2+huIy/j8AGR
oV3HhyptBx7z8IFcfz7IGV+i5i0obiVnYKb0fyxqY0a8ctJa4nuAe7mHvB+bboHM
yAm40a2Ew1o+uwFfXxgiwC4xExq42PF5aJ+vPV1776HtTvhQUTrRUKaedNrVLm1P
eFEFKcApTuIswLJemXmlOybc3PRFZ5Pi4fYW7303DUVadkST5I8xkfgs08mks+Ox
wvw3n7AmQSTH8anHEuqhjjmY9Gbw9IOGfAQZrjEIoHorOi/hDT5y+FSXlBRgl0Gf
YbOaILwBUuTDbCrCuxfmFBJ+V3Wn+P23ioSxexOGA+3LondDI3dmx8WTOVbr2QwF
3ohWUdVNykIg0hXxiS4QoIa+TmzGNiSkFYZoXd6/yxx4geOiuGHxIH3d3Bq5xSn8
6GH9s7YQvAUhBL9igXkIUEhElnDZQkmpWnHIBFxt2Yvo9jMaBxpl118zH8xoApwq
w6zpbKHBuJ5spp+OPF8quuZY1vFmhjQwV9KG27HK4+W4Ws9yXWPov4ubLgIsgSaA
QkKXS3zS3s044H4h347+
=kGUT
-----END PGP SIGNATURE-----

--8G1nIWD3RY794FAy--
