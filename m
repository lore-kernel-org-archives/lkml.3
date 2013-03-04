Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab3CDOi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:38:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51357 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab3CDOiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:38:25 -0500
Date: Mon, 4 Mar 2013 16:38:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 3/5] usb: musb: ux500: add otg notifier support
Message-ID: <20130304143810.GJ3397@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362047934-22337-1-git-send-email-fabio.baltieri@linaro.org>
 <1362047934-22337-4-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9RxwyT9MtfFuvYYZ"
Content-Disposition: inline
In-Reply-To: <1362047934-22337-4-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9RxwyT9MtfFuvYYZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 28, 2013 at 11:38:52AM +0100, Fabio Baltieri wrote:
> Add transceiver notifier event handling to the ux500 driver to set vbus
> on specific transceiver events.
>=20
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  drivers/usb/musb/ux500.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>=20
> diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
> index 5b742ba..b20326bb 100644
> --- a/drivers/usb/musb/ux500.c
> +++ b/drivers/usb/musb/ux500.c
> @@ -98,6 +98,36 @@ static void ux500_musb_set_vbus(struct musb *musb, int=
 is_on)
>  		musb_readb(musb->mregs, MUSB_DEVCTL));
>  }
> =20
> +static int musb_otg_notifications(struct notifier_block *nb,
> +		unsigned long event, void *unused)
> +{
> +	struct musb *musb =3D container_of(nb, struct musb, nb);
> +
> +	dev_dbg(musb->controller, "musb_otg_notifications %ld %s\n",
> +			event, otg_state_string(musb->xceiv->state));
> +
> +	switch (event) {
> +	case USB_EVENT_ID:
> +		dev_dbg(musb->controller, "ID GND\n");
> +		ux500_musb_set_vbus(musb, 1);
> +		break;
> +	case USB_EVENT_VBUS:
> +		dev_dbg(musb->controller, "VBUS Connect\n");

are you sure this is correct ? you're not doing anything in case of
vbus event. Shouldn't you make sure your vbus is off ? What if your user
uses a non-standard cable which has id-pin grounded on both sides ?

--=20
balbi

--9RxwyT9MtfFuvYYZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNLHSAAoJEIaOsuA1yqREMDEP/jQtj04O2wV609RVG92+H2p+
pfsTMJpPiqxzVng7WHYwkNIov0oGJf5aAnaxWdb07BRN+spYKm2ghQvq8E/h2Q8t
3NSIFeQniwHWJH4BOJjLeKzQwGK3CDJMjwLp/4PmX4VmMgXT42XfrAcUChUeVGZ2
uwN6aYFITppbpJgNKTuZuJZcSfKT1bMEGlF39QjfRihRo83T00Yq6Q+dxtnsNGY5
25uZ8b21vZLD33O9nEw5e+pZqZvbZVMXKuuII/ITaxHzdnXuziy1BEqSvRgp6zCp
zUBrmakaKoxMm3FcPEZ9x5/mSOvHYDVeiYiZS69dyvmAGP65fO3mABglNUakoW5b
XHUlCxDMMgg4dRPm50Yb0mqss5ffDJZFoQiP3xXPHDQ58HwbNjKe44aWf7L3JcCF
WQ8TrbUT8Z2gBFgw5W4ytboFmdMpYKi9aQjcmtGgGdW0nvaQns4P8zsTKDgt1ngX
CKpibqV+95vPZOJ2plhg0dp62alQs+2P8m4Bald1YHbL6chBy7Ip7Cwc++WgKGpH
//f8ZmTbPNN+HMkBq9e+Sl7C3kTDyF0aGpRH7yKY8dlctySv6j0QwiV43xovwDE6
szVBaW9Py88nQHFhwrwLbh80e9ixfib8e2qntuWX7CK5g8ClbudZszq/mWWUzbkQ
Bm+WP962NwgDOFbo8+bl
=00LD
-----END PGP SIGNATURE-----

--9RxwyT9MtfFuvYYZ--
