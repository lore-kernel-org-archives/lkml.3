Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030855AbaGRNzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:55:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60325 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030336AbaGRNy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:54:59 -0400
Date: Fri, 18 Jul 2014 08:54:20 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 7/9] usb: phy: am335x: setup the gen_phy function
 pointers _before_ adding the phy
Message-ID: <20140718135419.GG24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-8-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B8ONY/mu/bqBak9m"
Content-Disposition: inline
In-Reply-To: <1405675890-8802-8-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--B8ONY/mu/bqBak9m
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 11:31:28AM +0200, Lothar Wa=DFmann wrote:
> Make sure all parameters are correctly set up before registering the
> PHY with the USB framework.
>=20
> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> ---
>  drivers/usb/phy/phy-am335x.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
> index 91c71ab..6522fa7 100644
> --- a/drivers/usb/phy/phy-am335x.c
> +++ b/drivers/usb/phy/phy-am335x.c
> @@ -56,11 +56,12 @@ static int am335x_phy_probe(struct platform_device *p=
dev)
>  	if (ret)
>  		return ret;
> =20
> +	am_phy->usb_phy_gen.phy.init =3D am335x_init;
> +	am_phy->usb_phy_gen.phy.shutdown =3D am335x_shutdown;
> +
>  	ret =3D usb_add_phy_dev(&am_phy->usb_phy_gen.phy);
>  	if (ret)
>  		return ret;
> -	am_phy->usb_phy_gen.phy.init =3D am335x_init;
> -	am_phy->usb_phy_gen.phy.shutdown =3D am335x_shutdown;
> =20
>  	platform_set_drvdata(pdev, am_phy);
>  	device_init_wakeup(dev, true);

both of these need to be done before registering the PHY too.

--=20
balbi

--B8ONY/mu/bqBak9m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTyScLAAoJEIaOsuA1yqREZqQQAKgSvQw8TMe5swcW8WyTF7R0
4CDG4vSrNX3Mq6V9XWO/xSodgNN6UvudgfKeDLRFvWcBNL9mNdi9brDwvLDQJJAt
DWf77APCDk2Y2sg+4i9i8b+O7AWMCzF61ewRdNuKMSiH3KVEnmRJlk0oZh33xmZf
X9KrNHJ7gOKoHMxiLlX8e9RZjg5CTCV1cg44qb9WMB5PiD3O/iZZyDpOnBXIVC3i
yR8B2iWPkXS08DrXAI1k6wejWoQhEfGjPJS1VM78T+kw4ZfwMDOjLBUbWwNo0KVH
Q7E3KNKlduHsXQ3rbZRcEhfakmqBfPR+ESzW8sdmI3PzdZXbTmm9hWdUf0Z0V8kj
eZaQ7uJ+jeDWv0+pKCJzzYCUeY5eCZZrZZLwdT1us4/AdPWN1AaAjIl4/If+Jl6w
ipTdpgsHluzbo7fji/84Psb2XzaFe8hOJM+amqInbdoS2OQa0AblAbnjTrvyj7+m
dPhihDh7fJBhRVlvWHp8eZfn0TNVkkbn8wUPMMTWHXju9iOP948iqcuHdjRYFjfN
yRWU9P6nbugyljCbCFwztBB70jsaZ8EckkDuTL9VSb2anUYAbAZxpC2kmNfumM7M
u5l0B7Vcy1nAjrW3rhKIlstupgryS5J2iWQEqisq956/UKra5eoxK9Kae7O7ZK6P
hBgCqPAECeqr2gnd5eU+
=a/qr
-----END PGP SIGNATURE-----

--B8ONY/mu/bqBak9m--
