Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaKUQIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:08:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35377 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554AbaKUQII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:08:08 -0500
Date: Fri, 21 Nov 2014 10:08:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 4/4] i2c: omap: add notes related to i2c multimaster mode
Message-ID: <20141121160822.GO7508@saruman>
Reply-To: <balbi@ti.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416518925-20679-5-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96dIhm/ZjrNld+BP"
Content-Disposition: inline
In-Reply-To: <1416518925-20679-5-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--96dIhm/ZjrNld+BP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 01:28:45AM +0400, Alexander Kochetkov wrote:
> No functional changes.
>=20
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>

heh:

Tested on BBB and AM437x Starter Kit

Tested-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/i2c/busses/i2c-omap.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 47103e7..4e3642c 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -304,6 +304,12 @@ static void __omap_i2c_init(struct omap_i2c_dev *dev)
>  	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, OMAP_I2C_CON_EN);
> =20
>  	/*
> +	 * NOTE: right after setting CON_EN, STAT_BB could be 0 while the
> +	 * bus is busy. It will be changed to 1 on the next IP FCLK clock.
> +	 * udelay(1) will be enough to fix that.
> +	 */
> +
> +	/*
>  	 * Don't write to this register if the IE state is 0 as it can
>  	 * cause deadlock.
>  	 */
> @@ -664,7 +670,11 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *ada=
p,
> =20
>  	if (!dev->b_hw && stop)
>  		w |=3D OMAP_I2C_CON_STP;
> -
> +	/*
> +	 * NOTE: STAT_BB bit could became 1 here if another master occupy
> +	 * the bus. IP successfully complete transfer when the bus will be
> +	 * free again (BB reset to 0).
> +	 */
>  	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
> =20
>  	/*
> --=20
> 1.7.9.5
>=20

--=20
balbi

--96dIhm/ZjrNld+BP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUb2N1AAoJEIaOsuA1yqRExFQP/3/XzvAXco9nz8/eYzgBO+Xf
wcMXb5iWgbVWOLxGo4+YT8Bnj+2b/L74zDier7471GbPJ6Dvvq2EGdAPjDWlHXRg
Miqnjzb9mdl7sjNK9jRyb1i2N/e7Awl2P6Fg1yYwsweVvoz8a5RRDNYaBdUupmm6
khFtc3smooqPoP3Xi09Lc1NnLnN+crl6Pf/BXregeIzU25fHh9x8R34R6YbOrwBm
2uLbrSc+QhDm/I6EnrFmt5RbxCx7mR71i8QK1uMyb0KqqVQW6xtBYgMmP9arG3IU
yoJpLGomBYncukoF8ahxQ5n9uYZAWFyFp6ABSjoA+KuwOT+4s3gZyYRgzx7TYL3I
PVHG2HabT5kKW4vIHz9Xk5Jx/ZSIZZ/yxcGZQe9gCeDbr4lbHUcu8ySLv32vW1y2
rmlwdQA/Uv/5P8Gvxv0TzqHxYkqUVDQUrLjnbcS9UFvi49Pz6Rcf6mUSHrHoisWD
K+7muRjh9wo0sLPQnAh4OSFbgUgkGHCYibivd/iSEP+tRquqpQt6E8SM61u5D7iV
CBoVHGBVhlbEoNepo0hrblsr1MdR94XHrKPJqibY3Y4mH8LpgTpAJNPa4XnQ1cZV
6JGOZQRFhM1HWm2gKsfZty+mENVnjbRYkYgue/gyj1iAmUSfEXIwM785X9U3iZf3
QRJakcNOFDtbffYvx4u6
=NQxI
-----END PGP SIGNATURE-----

--96dIhm/ZjrNld+BP--
