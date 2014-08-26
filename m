Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaHZPyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:54:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45199 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbaHZPyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:54:15 -0400
Date: Tue, 26 Aug 2014 10:54:03 -0500
From: Felipe Balbi <balbi@ti.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: net2280: Fix invalid handling of Reset irq
Message-ID: <20140826155403.GE13949@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409068212-11044-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VUDLurXRWRKrGuMn"
Content-Disposition: inline
In-Reply-To: <1409068212-11044-1-git-send-email-ricardo.ribalda@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VUDLurXRWRKrGuMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 05:50:12PM +0200, Ricardo Ribalda Delgado wrote:
> Without this patch, some hosts keeps restarting indefinitely the target.
>=20
> Bug added on ae8e530a7e5d87592cb23996bee7fd6f1eb202ed usb: gadget:
> net2280: Code Cleanup

this should be just above you Signed-off-by on the form:

Fixes: ae8e530 (usb: gadget: net2280: Code Cleanup)

>=20
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/usb/gadget/udc/net2280.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/ne=
t2280.c
> index f4eac11..2e95715 100644
> --- a/drivers/usb/gadget/udc/net2280.c
> +++ b/drivers/usb/gadget/udc/net2280.c
> @@ -3320,7 +3320,7 @@ static void handle_stat1_irqs(struct net2280 *dev, =
u32 stat)
>  	if (stat & tmp) {
>  		writel(tmp, &dev->regs->irqstat1);
>  		if ((((stat & BIT(ROOT_PORT_RESET_INTERRUPT)) &&
> -				(readl(&dev->usb->usbstat) & mask)) ||
> +				((readl(&dev->usb->usbstat) & mask) =3D=3D 0)) ||
>  				((readl(&dev->usb->usbctl) &
>  					BIT(VBUS_PIN)) =3D=3D 0)) &&
>  				(dev->gadget.speed !=3D USB_SPEED_UNKNOWN)) {
> --=20
> 2.1.0
>=20

--=20
balbi

--VUDLurXRWRKrGuMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/K2bAAoJEIaOsuA1yqREL+wQAK3WfgC8pNRQZpDklElvp9cS
2+1SKWW5S9SJ9xg5pPFCj2w8w8qAr+heZ4TL/8ZLy6dVtH5KqQvReh44AVGGeL5K
Eqrw71ZDbqUP2000ZO5dpZMAdtekxdJFCRMyG3LS2mv23E/R3AWxqaxPwN4apSPG
5SiRVNCReNKyS7Lvb78mJmklB2nFDA82cfU4hb1BaN/lwwIcib8jmBhHVMK2AOXA
AsIVykvLaDLsOdpQGuaaZ6BPncnDKuTepOTWk5xttvYu6E8+uEGzb/x8YU2Kml/+
OOkr3Elq81ls3HHPPtirqz5sbLaoC+lj0I+K6m/DneqBM3M2FJrZuDQqwTgBLF16
9fzsE/GZxTKCUPfrVvGnx3oxw0W+gswqkplPAld3z/zqbQqtt9AO4gBDx+lfHkWj
hnee4F80JGP+fPBdCnfXZrNmJ0KY0lsoOiH7zwnqvgFh5QBj7F1wq8BcBclUS8iJ
gpiKi2G2t75UulvxYu9QQ2l1wAWd8XvZfUKMcdkhbU+z568jzHU7EICWL98J5N5m
iJfhcbd5CMfH92EjZ/ppuIkkpozf1tmHLQ7USMRKk/MbLkq6lrVAokJrZ/V/yrG3
rci5SN8aic9+4KySnkvDLMaNmL+G0HpyIb3X/NeQogvouoxLyffnVyBLyVAjcHeh
kqeHxKFlceZ6WvSRB3hF
=Mzzx
-----END PGP SIGNATURE-----

--VUDLurXRWRKrGuMn--
