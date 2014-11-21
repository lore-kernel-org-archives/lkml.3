Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbaKUQHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:07:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35337 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554AbaKUQHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:07:49 -0500
Date: Fri, 21 Nov 2014 10:08:02 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 1/4] i2c: omap: cleanup register definitions
Message-ID: <20141121160802.GL7508@saruman>
Reply-To: <balbi@ti.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416518925-20679-2-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O8/n5iBOhiUtMkxf"
Content-Disposition: inline
In-Reply-To: <1416518925-20679-2-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--O8/n5iBOhiUtMkxf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 01:28:42AM +0400, Alexander Kochetkov wrote:
> Delete STAT_AD0 mask as unrelated to current IP (omap1?).
> Delete DEBUG conditional around SYSTEST masks group.
> Add SYSTEST functional mode masks for SCL and SDA.
> Add STAT_BF mask.
>=20
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>

Tested on BBB and AM437x Starter Kit

Tested-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/i2c/busses/i2c-omap.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 9af7095..a021733 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -102,7 +102,7 @@ enum {
>  #define OMAP_I2C_STAT_ROVR	(1 << 11)	/* Receive overrun */
>  #define OMAP_I2C_STAT_XUDF	(1 << 10)	/* Transmit underflow */
>  #define OMAP_I2C_STAT_AAS	(1 << 9)	/* Address as slave */
> -#define OMAP_I2C_STAT_AD0	(1 << 8)	/* Address zero */
> +#define OMAP_I2C_STAT_BF	(1 << 8)	/* Bus Free */
>  #define OMAP_I2C_STAT_XRDY	(1 << 4)	/* Transmit data ready */
>  #define OMAP_I2C_STAT_RRDY	(1 << 3)	/* Receive data ready */
>  #define OMAP_I2C_STAT_ARDY	(1 << 2)	/* Register access ready */
> @@ -150,16 +150,20 @@ enum {
>  #define OMAP_I2C_SCLH_HSSCLH	8
> =20
>  /* I2C System Test Register (OMAP_I2C_SYSTEST): */
> -#ifdef DEBUG
>  #define OMAP_I2C_SYSTEST_ST_EN		(1 << 15)	/* System test enable */
>  #define OMAP_I2C_SYSTEST_FREE		(1 << 14)	/* Free running mode */
>  #define OMAP_I2C_SYSTEST_TMODE_MASK	(3 << 12)	/* Test mode select */
>  #define OMAP_I2C_SYSTEST_TMODE_SHIFT	(12)		/* Test mode select */
> +/* Functional mode */
> +#define OMAP_I2C_SYSTEST_SCL_I_FUNC	(1 << 8)	/* SCL line input value */
> +#define OMAP_I2C_SYSTEST_SCL_O_FUNC	(1 << 7)	/* SCL line output value */
> +#define OMAP_I2C_SYSTEST_SDA_I_FUNC	(1 << 6)	/* SDA line input value */
> +#define OMAP_I2C_SYSTEST_SDA_O_FUNC	(1 << 5)	/* SDA line output value */
> +/* SDA/SCL IO mode */
>  #define OMAP_I2C_SYSTEST_SCL_I		(1 << 3)	/* SCL line sense in */
>  #define OMAP_I2C_SYSTEST_SCL_O		(1 << 2)	/* SCL line drive out */
>  #define OMAP_I2C_SYSTEST_SDA_I		(1 << 1)	/* SDA line sense in */
>  #define OMAP_I2C_SYSTEST_SDA_O		(1 << 0)	/* SDA line drive out */
> -#endif
> =20
>  /* OCP_SYSSTATUS bit definitions */
>  #define SYSS_RESETDONE_MASK		(1 << 0)
> --=20
> 1.7.9.5
>=20

--=20
balbi

--O8/n5iBOhiUtMkxf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUb2NiAAoJEIaOsuA1yqREBbcP/2WqHMLP5DcV2R4qU0qiLS12
WYJrwZQ6omjYBFbyPxn9yucTJVJfm64lfMuZhBQu0nxPPu/L6CYntGZtWWkKr3o9
3cw+8rrEUvLP/Qi5N5uwXQlrIWcBSh2rLvXcxwjaQjTi7wjcWD/7EiPGt5Fd4hml
3cwLpEoVD80r+LVTNASF3EgiOBBs2KGIO+xyY/6bLd33YvZHW0LdOI+Cv2UB1PRI
/c8L+4um64b1SawF4KUPBosffMigsoQoWQO7kU5pQ6j4KTOOoEW7tvu1isFORZJD
QBji5wzD93wEQknwK6tZKiRj+tltQMTrN470DpxazU6WjlfksxaMBs6KMN+dmpJX
YM5RSy6s4+wjTb1XBd5sDuBF2jhBExEiWDXk61NiWGv0zIuR2kTsqRYFTN4mVaRH
ASINFVOZ+iUEa2HgzHP64zTJ/37ojKzTSChRu1OM/9XGD4PVYumBgGYwkSOalZz/
mjaDSWhkQnqwti3VPgm+5rK91l9i8Syhj4yz0TonfUiD00okfMDEDgA3zMxicZr6
4PToiHOzPb7GjRJATkHznlufTxDxdo1peENvRjkztW3JzE+3CyiD15y5PLxHiDQk
+okNIv/a+Zw7V7J6Wv9uJ20GJMXe7bPIkPIqI6ufah4t04owQWP6KSe9BvJAWMVk
eegSjETnxL/E+En7dUGB
=jOuM
-----END PGP SIGNATURE-----

--O8/n5iBOhiUtMkxf--
