Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161039AbaGRN55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:57:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52324 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762435AbaGRN5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:57:53 -0400
Date: Fri, 18 Jul 2014 08:57:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 8/9] usb: phy: am335x: call
 usb_gen_phy_init()/usb_gen_phy_shutdown() in am335x_init()/am335x_shutdown()
Message-ID: <20140718135713.GH24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-8-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-9-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jaoouwwPWoQSJZYp"
Content-Disposition: inline
In-Reply-To: <1405675890-8802-9-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jaoouwwPWoQSJZYp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 18, 2014 at 11:31:29AM +0200, Lothar Wa=DFmann wrote:
> This patch makes it possible to use the musb driver with HW that
> requires external regulators or clocks.

can you provide an example of such HW ? Are you not using the internal
PHYs ?

> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> ---
>  drivers/usb/phy/phy-am335x.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
> index 6522fa7..de25674 100644
> --- a/drivers/usb/phy/phy-am335x.c
> +++ b/drivers/usb/phy/phy-am335x.c
> @@ -22,6 +22,7 @@ static int am335x_init(struct usb_phy *phy)
>  {
>  	struct am335x_phy *am_phy =3D dev_get_drvdata(phy->dev);
> =20
> +	usb_gen_phy_init(phy);
>  	phy_ctrl_power(am_phy->phy_ctrl, am_phy->id, true);
>  	return 0;
>  }
> @@ -31,6 +32,7 @@ static void am335x_shutdown(struct usb_phy *phy)
>  	struct am335x_phy *am_phy =3D dev_get_drvdata(phy->dev);
> =20
>  	phy_ctrl_power(am_phy->phy_ctrl, am_phy->id, false);
> +	usb_gen_phy_shutdown(phy);
>  }
> =20
>  static int am335x_phy_probe(struct platform_device *pdev)
> --=20
> 1.7.10.4
>=20

--=20
balbi

--jaoouwwPWoQSJZYp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTySe5AAoJEIaOsuA1yqRE018QAIF8Sy0QbBevXEZO6CK0zDX6
D3p7hBmatvebbtgQj8+m53O+hxZCv5cCdzzM6nuSt9CjmvPYy7j0kRPFb0nCUUf8
74bBrPiReY8gFz1JOT7J+ED2BUpob7XwC1jNGuFLdWDsCwNI3OQdnTxgaWNUmWjh
mkk0u/zh34GN0G7eOHRL3sTfRuQTaO0knQf8/7M8RInGuWXUhvrTTWOWl6SvLSlb
4pUuE/Y0XJcvaBh/8Tw2sg0yb+bHK1cVe6bnRcrv2ChVJ9oOaxs0Vr1ihozL6zC4
k8DHQtLX1aLInGbegxDNHbS/12g+mku+DyYOFONesLjAznryO5MLqDi449Zogq35
rM1hwUh7glcovaU419OOLHrUyR0lQp+H5AZGh6pZrkd3LBoq0adQuzF8jrr6Me0B
fN2L9OyQSoCH64+flBuiLltHTCrGWM73gPcM7Lml9ID1NzDaOYKjvAFDAkAqlphH
E9xsGPFjqa9hMe5Rc4IqgveJH3ZSNqpwZlynvyIUMI8HjcSp6UFXrSTSuu+JMMlu
iKbO2rwSCoDCui1EIvA4XnWpvKTdYg6ZdQBgPPDSr3XnW7kvsYpMzlHhoF97Q1/l
OWuxYpK6KGDWSqbKxPfBz8PcBN5ez0emZhdQ8170D0u7NORSIRXZAjpbhYjmBo7Y
xYyM7eveo6KLSm5fUk4D
=A3rx
-----END PGP SIGNATURE-----

--jaoouwwPWoQSJZYp--
