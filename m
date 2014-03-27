Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbaC0QZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 12:25:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37963 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbaC0QY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 12:24:58 -0400
Date: Thu, 27 Mar 2014 11:23:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: omap: fix usage of IS_ERR_VALUE with
 pm_runtime_get_sync
Message-ID: <20140327162301.GE3682@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395937113-10222-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FN+gV9K+162wdwwF"
Content-Disposition: inline
In-Reply-To: <1395937113-10222-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FN+gV9K+162wdwwF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2014 at 11:18:33AM -0500, Nishanth Menon wrote:
> we use IS_ERR_VALUE to check for error values of pm_runtime_get_sync,
> when the value can only be < 0 in the case of err. Replace the
> check with a simpler < 0 check.
>=20
> This fixes the coccicheck warnings:
> linux-2.6/drivers/i2c/busses/i2c-omap.c:1157:5-24:
> pm_runtime_get_sync returns < 0 as error. Unecessary IS_ERR_VALUE at
> line 1158
> linux-2.6/drivers/i2c/busses/i2c-omap.c:1278:7-26:
> pm_runtime_get_sync returns < 0 as error. Unecessary IS_ERR_VALUE at
> line 1279
> drivers/i2c/busses/i2c-omap.c:638:5-24:
> pm_runtime_get_sync returns < 0 as error. Unecessary IS_ERR_VALUE at
> line 639
>=20
> Signed-off-by: Nishanth Menon <nm@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
> Patch based on: v3.14-rc8
> coccicheck report based on next-20140326 tag
>=20
>  drivers/i2c/busses/i2c-omap.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 90dcc2e..078a3de 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -636,7 +636,7 @@ omap_i2c_xfer(struct i2c_adapter *adap, struct i2c_ms=
g msgs[], int num)
>  	int r;
> =20
>  	r =3D pm_runtime_get_sync(dev->dev);
> -	if (IS_ERR_VALUE(r))
> +	if (r < 0)
>  		goto out;
> =20
>  	r =3D omap_i2c_wait_for_bb(dev);
> @@ -1155,7 +1155,7 @@ omap_i2c_probe(struct platform_device *pdev)
>  	pm_runtime_use_autosuspend(dev->dev);
> =20
>  	r =3D pm_runtime_get_sync(dev->dev);
> -	if (IS_ERR_VALUE(r))
> +	if (r < 0)
>  		goto err_free_mem;
> =20
>  	/*
> @@ -1276,7 +1276,7 @@ static int omap_i2c_remove(struct platform_device *=
pdev)
> =20
>  	i2c_del_adapter(&dev->adapter);
>  	ret =3D pm_runtime_get_sync(&pdev->dev);
> -	if (IS_ERR_VALUE(ret))
> +	if (ret < 0)
>  		return ret;
> =20
>  	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, 0);
> --=20
> 1.7.9.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--FN+gV9K+162wdwwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTNFBlAAoJEIaOsuA1yqRE9IIQAI5NC+AVeovV5ZROYQRFOYAH
oQXKux5WBmNrw7CGl7v6jNFQAv0zzzCSnjPGQ7ZVzJCNo173lFDc6bUjZsJK9eCP
EtFeymMaW1JoW3XeGeRyiHSXQ3oYqVGHJsmgYlRzSRUYXCSyKhGKxIQBiKZ6ZGfj
lT7D2THLgvUkWM7pLw162D8wVy5LE/hwPlOrQ/wDewwqRvY24tkfwKeRUE5V8A3i
ODKp9Tevh0FFAHyILS7J0YcFH5Le8HKqGkSZXZcOOmwxsPLZu9Paza+65tvH0zto
nmfXY19PmiUkFWtM1sSSMsy8aD61ZvjHSmPqsRFvnKKq3/S3S81jcFgTjpOsWSbl
N0/CV5E7SZ9s9XvDsx6wdZ0CxRJD63NT/5VFvZi0uRBeAq+j9UcSvoU8Mi0MvU99
+dVrST6iDDdW5UPuPhOAg/ankGAjqWoYO1O6N/G9CstA75QJIVmFdzloblmjpYmK
cD8CvVH8g3epYBmTAKYOLNQr7jBq90uoeX48nZfrdBHn/kM3OpfBoQunGQVmyBBQ
FBOceusVC86nPdj3dHuV6v0VbbKohxmAX2+TIn+hprOwmKcjHEs/UsSlr2rIAqyg
UJMSUA8C0F7K/Zj8H066vFVN5ol9bYKgR3mIGj331Ydz3w9NAOCKSR+AUTCalWEF
ixnoi6NZRcRIawT4sB6i
=53Yz
-----END PGP SIGNATURE-----

--FN+gV9K+162wdwwF--
