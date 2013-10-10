Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab3JJIqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:46:14 -0400
Received: from sauhun.de ([89.238.76.85]:55872 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab3JJIqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:46:11 -0400
Date: Thu, 10 Oct 2013 10:46:05 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
Cc: Peter Korsgaard <peter.korsgaard@barco.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-mux-gpio: test if the gpio can sleep
Message-ID: <20131010084605.GD2638@katana>
References: <525667C4.3080309@nsn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F8dlzb82+Fcn6AgP"
Content-Disposition: inline
In-Reply-To: <525667C4.3080309@nsn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F8dlzb82+Fcn6AgP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2013 at 10:39:32AM +0200, Ionut Nicu wrote:
> Some gpio chips may have get/set operations that
> can sleep. For this type of chips we must use the
> _cansleep() version of gpio_set_value.
>=20
> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
> ---
>  drivers/i2c/muxes/i2c-mux-gpio.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux=
-gpio.c
> index a764da7..b5f17ef 100644
> --- a/drivers/i2c/muxes/i2c-mux-gpio.c
> +++ b/drivers/i2c/muxes/i2c-mux-gpio.c
> @@ -27,11 +27,16 @@ struct gpiomux {
> =20
>  static void i2c_mux_gpio_set(const struct gpiomux *mux, unsigned val)
>  {
> +	unsigned gpio;
>  	int i;
> =20
> -	for (i =3D 0; i < mux->data.n_gpios; i++)
> -		gpio_set_value(mux->gpio_base + mux->data.gpios[i],
> -			       val & (1 << i));
> +	for (i =3D 0; i < mux->data.n_gpios; i++) {
> +		gpio =3D mux->gpio_base + mux->data.gpios[i];
> +		if (gpio_cansleep(gpio))
> +			gpio_set_value_cansleep(gpio, val & (1 << i));
> +		else
> +			gpio_set_value(gpio, val & (1 << i));
> +	}

There should be a wrapper for that in the gpio-subsystem IMO.
Adding linux-gpio to cc.


--F8dlzb82+Fcn6AgP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSVmlNAAoJEBQN5MwUoCm2UGUP/Ah7hOwMTTue0fucsyGKr5th
BY/+ONOeHaWlcMm4f7WQz0EMjDKJN4Yqcah7lO2c4ZrbKGOas7JgcK9xChIXg5py
gzK5XHzXnMd/MdtST5x2HoOqPOETdGNseyXl9OxH/D0GjMA1FjUc7OIBSPAxPpHN
utauhvoalZR0CH9+xZvAd/Vd9Yw08Fob4wS8oduR4wWPwcpix/rcX+8/wzbIg0+3
uDazQoAa4lHQzkRclviHbG5rzfZfdvUk7HvDol1ILT/Tsb9ykH7r1sIYpkWVCGIu
Hy3k3w93ww5RAf8a92l96qTXw0+7ndUG4lwb1yRAftFVQX92FMnd7BEZSe4xlhw5
oI2Ip7Dt+4TRdwRX9fXECCjWJu34qXdQ1Lrv9lPiaRVV7Okoqdf/vMPTUZkEWj89
vj0YelR3IVZQyNdp5DkVMbbGp9pzD/VoJrlJCnS92aDc9fc2g/U3Hqq28QSU0ZUo
B9Ldoxc7vJSHiG8j8K/KX7oXILfwdcRog+/PH1SFaM7fnvXBGdJ2lJyjaDGmWMCD
PjXzDHEM/HnJEjbeKjYKP/I3pKXfwXLFBQeIi4GRshvsGd+YEy8K1CYkQulRmLkt
dBd3ZMgjb1wSb74Ip7g+gZgbyHi62jSZYwu/EFZii/zNqVz7RfYOZHwZ2QuKcnHy
2RH+vIpc9gjsNsTWnM5C
=x1l7
-----END PGP SIGNATURE-----

--F8dlzb82+Fcn6AgP--
