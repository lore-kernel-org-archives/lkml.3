Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbaKUQIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:08:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47837 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554AbaKUQIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:08:01 -0500
Date: Fri, 21 Nov 2014 10:08:13 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 3/4] i2c: omap: don't reset controller if Arbitration
 Lost detected
Message-ID: <20141121160813.GN7508@saruman>
Reply-To: <balbi@ti.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416518925-20679-4-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1HuzLmPZrG5RH6bG"
Content-Disposition: inline
In-Reply-To: <1416518925-20679-4-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1HuzLmPZrG5RH6bG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 01:28:44AM +0400, Alexander Kochetkov wrote:
> Arbitration Lost is a expected situation in a multimaster environment.
> IP correctly detect it.
>=20
> The only reason for reseting IP in the AL case is to be sure to
> avoid advisory 1.94 (omap3) and errata i595 (omap4):
> "I2C: After an Arbitration is Lost the Module Incorrectly Starts
> the Next Transfer" with workaround: "The MST and STT bits inside
> I2C_CON should be set to 1 at the same moment (avoid setting the
> MST bit to 1 while STT =3D 0)."
>=20
> The driver never writes MST and STT bits separately and doesn't
> create condition for errata. So the reset is not necessary.
>=20
> Tested on Beagleboard XM C.
>=20
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>

Tested on BBB and AM437x Starter Kit

Tested-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/i2c/busses/i2c-omap.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 3ffb9c0..47103e7 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -707,13 +707,17 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *ad=
ap,
>  		return 0;
> =20
>  	/* We have an error */
> -	if (dev->cmd_err & (OMAP_I2C_STAT_AL | OMAP_I2C_STAT_ROVR |
> +	if (dev->cmd_err & (OMAP_I2C_STAT_ROVR |
>  			    OMAP_I2C_STAT_XUDF)) {
>  		omap_i2c_reset(dev);
>  		__omap_i2c_init(dev);
>  		return -EIO;
>  	}
> =20
> +	if (dev->cmd_err & OMAP_I2C_STAT_AL) {
> +		return -EIO;
> +	}
> +
>  	if (dev->cmd_err & OMAP_I2C_STAT_NACK) {
>  		if (msg->flags & I2C_M_IGNORE_NAK)
>  			return 0;
> --=20
> 1.7.9.5
>=20

--=20
balbi

--1HuzLmPZrG5RH6bG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUb2NtAAoJEIaOsuA1yqREuOwP/iiO+N9z80lY1B7X+XxZKy5U
Zk5ggsNSnGaCtwQfoRPEIkMqzvGa8tfGdxsYnRvFSvif3/4QtXnFVAJxzI4DTrXG
GNCaC6w9rrUr1nzGeRPFFNDj3bQYsVVzmx7AjSt9QcErB9bwQKYQ+JdMbxTkew/l
u6vpTOl1fGO3qOLjCB6Gi9wuItjK+MRFr8McZBgIgunX2aUh7TY1BhfVKFYyuoc1
YX2l/EV0HAuCB8rT37G+IjBlHuBYdcnmNFH++Q3yu+KryBLIJcK0AHREn+jhVpZR
NC15anI3ne23AQAnNsiGZ9PAzB/6DSuNwsd0VDe8FGFBFl7rc0q4iR1qeV8jTozy
PqvG/loq7soMQuK9aFLRK2ikcPv1grc31HEhNZLxHbi9hHpbCgde23FOOQMB0XUU
Rx4rwInRL4eysEsg0qFl9iV9cVWRhmU9xUi4gwy0oPOOfyenqpy/cYxiTztQnidZ
WtNQ7LXs7rTih+L1XxX/rjZqwAox3tSdBAif/cdKIcstDwJboASjI1ukc795s0EV
11WHj8HRjpfg6cCEdSNJBixcgFA00uPVuWBuFFm2Q0drNxZ8debr/MQ04OlRKLOg
5tWEWhxQ6rQJu+48/JD13F9Z4+n3tKTNGpvbfJEpS7wR7af6CdiTxJoJUVi++nHY
RhRJHYYDxImnFSxq76Nw
=ETdP
-----END PGP SIGNATURE-----

--1HuzLmPZrG5RH6bG--
