Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977AbaD3QGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:06:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36478 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964885AbaD3QGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:06:35 -0400
Date: Wed, 30 Apr 2014 11:06:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Fertser <fercerpav@gmail.com>
CC: Li Yang <leoli@freescale.com>, Felipe Balbi <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: fsl: check vbus presence on probe
Message-ID: <20140430160625.GF23679@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398329653-29968-1-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ni93GHxFvA+th69W"
Content-Disposition: inline
In-Reply-To: <1398329653-29968-1-git-send-email-fercerpav@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ni93GHxFvA+th69W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 12:54:13PM +0400, Paul Fertser wrote:
> If VBUS is already present during the driver initialisation, the

s/initialisation/initialization

> corresponding IRQ never fires, so there is no way the gadget can get
> enumerated.
>=20
> This patch is real-life tested on an i.MX25 board with VBUS constantly
> hooked up.
>=20
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> ---
>  drivers/usb/gadget/fsl_udc_core.c |    5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_u=
dc_core.c
> index a2f26cd..b4b1516 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -2501,6 +2501,11 @@ static int __init fsl_udc_probe(struct platform_de=
vice *pdev)
>  	if (ret)
>  		goto err_del_udc;
> =20
> +	/* Now let it settle a bit and sense VBUS */
> +	msleep_interruptible(1);
> +	if (fsl_readl(&dr_regs->otgsc) & OTGSC_STS_B_SESSION_VALID)
> +		udc_controller->vbus_active =3D 1;

good fix, should this go to stable ?

--=20
balbi

--ni93GHxFvA+th69W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYR+BAAoJEIaOsuA1yqREYyIP/0sSrYnUCDJ7PZZfdVEgz+n2
B0/Tk6PGPmIrqk40r+xTiI9hn8RxbPQXxTl1akIbqkfZ5GKySnZLfOQWOEXbkrPV
QeprNIpdz5CcdRMG8IYVZfo/e2RLMDwhemnmQ9n7FUGm6RErNrw2FOxuMYEesb0g
1M0xnkfPp+1CtSnNnISV0WPWNMna6SrE3K+orp5HXAnWp9vHNk8Z7s50OY56Hk+A
suc2pCAZ5mKcU5hy6Bs5TsWtVdBwgQFP5lJTRXmISF+kehNo518tly/NQjNE8gXD
uAzWQ6/mOjCiXCZE4jLu8SnZYa2ddNBM01SwovgG5KY0GeZMyCohRr5uDdgWz6ND
4EU4e20Fe5P68huW4c9JgxnkfJ50pgNLTL3Nqq5SMd9iJNqHT7q86plmJgcMmcPT
r7gNzQ9OqovxrAwurRKR+xyRVE35XSUyzNMsnSL8O0vYCMU4bv3BU+l7OY1QX0Yq
uw7C6mJ3tWAwlCYB7CD6skeuThj38RwtcikuGjTRZEuvePZEda1mqxhCAKHo/XhV
v9Y/Ofu0ZeT0E34C4YRwzBdwH/ei3PJR91bho5uyESWJ9QnuZJxjO2t62q9MW5C1
CRJlZ/5QmJqsvpKZZINvXn7s/FjBsNOoXHh0qefkh0cJXyo5Jj4Rg+1y5wYii5Eo
s8vcRpmFlo1T3+BM3iQo
=+ydx
-----END PGP SIGNATURE-----

--ni93GHxFvA+th69W--
