Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3BEJUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:20:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50958 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3BEJUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:20:18 -0500
Date: Tue, 5 Feb 2013 11:20:01 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 04/30] usb: phy: nop: Handle power supply regulator
 for the PHY
Message-ID: <20130205092001.GM32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-5-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B9BE8dkJ1pIKavwa"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-5-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--B9BE8dkJ1pIKavwa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:05PM +0200, Roger Quadros wrote:
> We use "vcc" as the supply name for the PHY's power supply.
> The power supply will be enabled during .init() and disabled
> during .shutdown()
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/otg/nop-usb-xceiv.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xc=
eiv.c
> index 849eb9d..0a9628c 100644
> --- a/drivers/usb/otg/nop-usb-xceiv.c
> +++ b/drivers/usb/otg/nop-usb-xceiv.c
> @@ -33,11 +33,13 @@
>  #include <linux/usb/nop-usb-xceiv.h>
>  #include <linux/slab.h>
>  #include <linux/clk.h>
> +#include <linux/regulator/consumer.h>
> =20
>  struct nop_usb_xceiv {
>  	struct usb_phy		phy;
>  	struct device		*dev;
>  	struct clk		*clk;
> +	struct regulator	*vcc;
>  };
> =20
>  static struct platform_device *pd;
> @@ -70,6 +72,11 @@ static int nop_init(struct usb_phy *phy)
>  {
>  	struct nop_usb_xceiv *nop =3D dev_get_drvdata(phy->dev);
> =20
> +	if (!IS_ERR(nop->vcc)) {
> +		if (regulator_enable(nop->vcc))
> +			dev_err(phy->dev, "Failed to enable power\n");
> +	}
> +
>  	if (!IS_ERR(nop->clk))
>  		clk_enable(nop->clk);
> =20
> @@ -82,6 +89,11 @@ static void nop_shutdown(struct usb_phy *phy)
> =20
>  	if (!IS_ERR(nop->clk))
>  		clk_disable(nop->clk);
> +
> +	if (!IS_ERR(nop->vcc)) {
> +		if (regulator_disable(nop->vcc))
> +			dev_err(phy->dev, "Failed to disable power\n");
> +	}
>  }
> =20
>  static int nop_set_peripheral(struct usb_otg *otg, struct usb_gadget *ga=
dget)
> @@ -153,6 +165,12 @@ static int nop_usb_xceiv_probe(struct platform_devic=
e *pdev)
>  		}
>  	}
> =20
> +	nop->vcc =3D devm_regulator_get(&pdev->dev, "vcc");
> +	if (IS_ERR(nop->vcc)) {
> +		dev_dbg(&pdev->dev, "Error getting vcc regulator: %ld\n",
> +					PTR_ERR(nop->vcc));
> +	}
> +
>  	nop->dev		=3D &pdev->dev;
>  	nop->phy.dev		=3D nop->dev;
>  	nop->phy.label		=3D "nop-xceiv";
> --=20
> 1.7.4.1
>=20

--=20
balbi

--B9BE8dkJ1pIKavwa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREM7BAAoJEIaOsuA1yqRELcIP/jbJmTLOYRYPrJUmbL69CDm7
FIb7D0tu0oZ85mrMnYwb+6cCvDisUtzFLZqaqFaRfst6eM4Cd4I6zGwLdvwIsyff
9gZCY4g6IC4rAt9cn3shNdJyBpPPxaC/fEPIpVOh7LV4PztbeKlz3nxB7MxZxOeV
IyNJ9NrsJaSrxOrqo0AQYQjGManlU/0NAaigpFzw6Jc/9284bzKZpGkLwPiYpuo5
quEKoOh7iXfv15jNuq2JpUHRNCJ1uFk6D5ZeEeRRu8+GFu8dRXfKCt8Y6XatyXrw
95qCIc1PR8uUVpcQF5XjAzzdbsvnmSBarEWJfqpLSrAmYJb3NZiWdzAscNs2y/5b
9wH0BSQ7MRZ08wU88QQu4TlWkKqQb7HFrPmtVvZJ4ViacDUPPFZbHh2zTVS0AFGX
4gay/IMwiPQFLm7JY9E5KUohooH4094bjHPOb7WGSDz9tbwBpdWbDNwFmUgbDxnA
7y5JNrX/MnP1sgNPYgzxrFBGr22FpQ6ZJGBFe8KHHjsSP4EcjWoZ61Lb7PwDjf74
k4rwi73bxmqzoJj860ovtkKTywftfHm/l1o4Na5Pb8um8f5Y6tdCEcX7W1fLo5wS
a1oabmNK4lpgq0IgUZ+HeCEERqMJ2wMwB0dkjROfvbnYi042r7PQTbuVd5QW+LwO
uKI/7O/wRTXmPrK8tS8b
=eNk6
-----END PGP SIGNATURE-----

--B9BE8dkJ1pIKavwa--
