Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3LFUZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:25:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37162 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3LFUZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:25:46 -0500
Date: Fri, 6 Dec 2013 14:24:53 -0600
From: Felipe Balbi <balbi@ti.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: phy-generic: Add GPIO based ChipSelect
Message-ID: <20131206202453.GF21086@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <1385967919-13258-2-git-send-email-chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NGIwU0kFl1Z1A3An"
Content-Disposition: inline
In-Reply-To: <1385967919-13258-2-git-send-email-chris.ruehl@gtsys.com.hk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NGIwU0kFl1Z1A3An
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 02, 2013 at 03:05:17PM +0800, Chris Ruehl wrote:
> @@ -231,27 +249,40 @@ static int usb_phy_gen_xceiv_probe(struct platform_=
device *pdev)
>  		return -ENOMEM;
> =20
>  	nop->reset_active_low =3D true;	/* default behaviour */
> +	nop->cs_active_low =3D true;
> =20
>  	if (dev->of_node) {
>  		struct device_node *node =3D dev->of_node;
>  		enum of_gpio_flags flags;
> +		enum of_gpio_flags csflags;
> =20
>  		if (of_property_read_u32(node, "clock-frequency", &clk_rate))
>  			clk_rate =3D 0;
> =20
>  		needs_vcc =3D of_property_read_bool(node, "vcc-supply");
> +
>  		nop->gpio_reset =3D of_get_named_gpio_flags(node, "reset-gpios",
>  								0, &flags);
> +

two unrelated changes

>  		if (nop->gpio_reset =3D=3D -EPROBE_DEFER)
>  			return -EPROBE_DEFER;
> =20
>  		nop->reset_active_low =3D flags & OF_GPIO_ACTIVE_LOW;
> =20
> +		nop->gpio_chipselect =3D of_get_named_gpio_flags(node, "cs-gpios",
> +								0, &csflags);
> +		if (gpio_is_valid(nop->gpio_chipselect))
> +			nop->cs_active_low =3D csflags & OF_GPIO_ACTIVE_LOW;
> +
>  	} else if (pdata) {
>  		type =3D pdata->type;
>  		clk_rate =3D pdata->clk_rate;
>  		needs_vcc =3D pdata->needs_vcc;
>  		nop->gpio_reset =3D pdata->gpio_reset;
> +		nop->gpio_chipselect =3D pdata->gpio_chipselect;
> +	} else {
> +		nop->gpio_reset =3D -1;

This line is already going upstream, please remove it, i'll handle the
conflict later.

--=20
balbi

--NGIwU0kFl1Z1A3An
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSojKVAAoJEIaOsuA1yqREfOEP/1XnxdD5lyvk6aPYcpre2SC7
HK6x5Eau3xyhTBi9LMMEXKsYBynBjr0X0vDFf5NZ5Pb9x9cT2WIMuSoLD2CQGfFL
DtWIOUofB3DStRTjMGpIo7DdlGAVgwKT8ryb1Wa0c6IwcnORzi+5cQFTNfxQVgJl
D17ag2mzBKQ7O27RU/D/E3tY9JMpFh3h3gKq9zX3ikyDLophZDrVnnHBA53uzhw+
NC1+wNsFKEMXxLm66r2eSA9ZwOw6idObaCkkgbxcGr+JO/PIRzUbvFRLoYavaaeU
tU1lKVUlvENZg8gZizZl628Jj39Cniu/HBzdgx8Zikj8OtHQebPCxS0gDZFbqA6A
mHf/VyV1JXmkLTtEFQZbNxgrQetsjrSmm8K8j5wL++qvrSBPSfC9sf2ZH+VHYWBI
QXvheaxDFaewMuZ/hn6uT1ChlH3rPdXAu3h3TI1qY7FQp25JW4lEpxM5GHlIEkp6
cIxQ8RnrBhkP1xS4lw/aKS2fDKdOz0CvwbzT6z2Gqyg+kN5t83U1GN1C3G/5bMaA
ft8qN7lSUIWxqkADWDBk7Qtngwze7gh85IpboB77RT+oE0tXYqk4mhcZM/fTFWTH
F41heRxFOrR8caA1pqmCpXNUs6SusVq1bvcyNbLeM1E156m79/QN2ICnQS+Z5G79
PLEIFnwynx+V1nlaRHqP
=fKYj
-----END PGP SIGNATURE-----

--NGIwU0kFl1Z1A3An--
