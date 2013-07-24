Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab3GXMi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:38:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47763 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab3GXMi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:38:26 -0400
Date: Wed, 24 Jul 2013 15:38:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] usb: phy: msm: Migrate to Managed Device Resource
 allocation
Message-ID: <20130724123822.GH17962@radagast>
Reply-To: <balbi@ti.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
 <1373384833-18077-3-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WHz+neNWvhIGAO8A"
Content-Disposition: inline
In-Reply-To: <1373384833-18077-3-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WHz+neNWvhIGAO8A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 09, 2013 at 06:47:08PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> Use managed device resources to clean up the probe/remove
> and get DT support for free.
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  drivers/usb/phy/phy-msm-usb.c |   78 +++++++++++------------------------=
------
>  1 file changed, 20 insertions(+), 58 deletions(-)
>=20
> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index ab1b880..cc37f5e 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -1458,30 +1455,27 @@ static int __init msm_otg_probe(struct platform_d=
evice *pdev)
>  	 * clock is introduced to remove the dependency on AXI
>  	 * bus frequency.
>  	 */
> -	motg->core_clk =3D clk_get(&pdev->dev, "usb_hs_core_clk");
> +	motg->core_clk =3D devm_clk_get(&pdev->dev, "usb_hs_core_clk");
>  	if (IS_ERR(motg->core_clk))
>  		motg->core_clk =3D NULL;
> =20
>  	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {

no need to check for the resource when using devm_ioremap_resource()

>  		dev_err(&pdev->dev, "failed to get platform resource mem\n");
> -		ret =3D -ENODEV;
> -		goto put_core_clk;
> +		return -ENODEV;
>  	}
> =20
> -	motg->regs =3D ioremap(res->start, resource_size(res));
> +	motg->regs =3D devm_ioremap_resource(&pdev->dev, res);
>  	if (!motg->regs) {
>  		dev_err(&pdev->dev, "ioremap failed\n");

don't print error messages when using devm_ioremap_resource()

--=20
balbi

--WHz+neNWvhIGAO8A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR78q+AAoJEIaOsuA1yqREhk4P/0F3a9SXNxpLg/VNusaKI21R
KxZeZZHUQ8zwbBS6OiW6x1LzQuBUOZdM7kd1E73WKbdWs3rc3WVwf1kuAb5qCpvs
BivXgwaoICL70v5mQ2FooEyYQ7Fk9UzU+6JzTmFSo8yWy5P0cMv08GkRijEQh7E/
kbtQKcQe/v0bOwwGyuzKqqjFKq4BSozEneshzaD4tcgDrLDbUdPhLqNb4TuUsHux
cMTmSx2N8DHV+S6Rk6KFn+B09lg1DvuP2oETpCMqRmdo620H8MUBqkuWPvslgod6
zFhSKB7ojuXCbouhXCOlSbrNCfu1wb3KRB0N03hDtQLa/W42nFkdIUPCiByX7cgZ
CF9OokVxWToy5nmK0iH8y7GFytldOny23vyxLvCfxmHSvrU0j1dbhdJR1P6yJL47
gHBq99Nb/86/rGFE12huLA8qd9nwINkFe2GArk49bB6qV2C6NE8kuWd472wr7s3L
oVt+C+nAgQGdiQOewyvTZvBTXod9oRrlny/HZVcbYYxbh8Z3knrzarv7iBOq6brs
ZY60VIbtcfjFVSXA6zAtnYmqVEdButdBwj40ExxSq+Ub9GDW44rrp5sQ6cOn0L66
czC49roCwhqyCrOxVSsv9lO9P9UFhMx6oPhHrB3nEhm+CFVdv5Klsv6NJ4xXXFB2
KREYYGi7E7kJPwDwl3F1
=diUu
-----END PGP SIGNATURE-----

--WHz+neNWvhIGAO8A--
