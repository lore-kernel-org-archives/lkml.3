Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3H1JCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:02:55 -0400
Received: from sauhun.de ([89.238.76.85]:56738 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab3H1JCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:02:53 -0400
Date: Wed, 28 Aug 2013 11:02:47 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Nguyen Viet Dung <nv-dung@jinso.co.jp>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com
Subject: Re: [PATCH v3 1/1 resend] i2c: rcar: modify I2C driver
Message-ID: <20130828090246.GC4086@katana>
References: <1377590122-9309-1-git-send-email-nv-dung@jinso.co.jp>
 <1377590122-9309-2-git-send-email-nv-dung@jinso.co.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Content-Disposition: inline
In-Reply-To: <1377590122-9309-2-git-send-email-nv-dung@jinso.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2013 at 04:55:22PM +0900, Nguyen Viet Dung wrote:
> This patch modify I2C driver of rcar-H1 to usable on both rcar-H1 and rca=
r-H2.
>=20
> Signed-off-by: Nguyen Viet Dung <nv-dung@jinso.co.jp>

Yes, this is much better. Only minor things...

> +	switch (priv->devtype) {
> +	default:
> +	case I2C_RCAR_H1:
> +		cdf_width =3D 2;
> +		break;
> +	case I2C_RCAR_H2:
> +		cdf_width =3D 3;
> +		break;
> +	}
> +

Please put the default case block at the end.

> @@ -632,6 +649,13 @@ static int rcar_i2c_probe(struct platform_device *pd=
ev)
>  	bus_speed =3D 100000; /* default 100 kHz */
>  	if (pdata && pdata->bus_speed)
>  		bus_speed =3D pdata->bus_speed;
> +
> +	if (!pdev->id_entry) {
> +		dev_err(&pdev->dev, "no entry\n");
> +		return -ENODEV;
> +	}

This cannot happen. Since you have 'i2c-rcar' in the id_table, the
driver core will always match against the id_table and there is always a
driver_data defined.


> +	priv->devtype =3D pdev->id_entry->driver_data;

Basically the same, but please use

	platform_get_device_id(pdev)->driver_data;

Otherwise good!

Thanks,

   Wolfram

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJSHby2AAoJEBQN5MwUoCm2KX8P93f1WROjUS/YNFIPT0cw+hzX
kmmGON7OfypE7IixQe6WCoTlMRPW16gWUwVuErITDYOCTdkX+CDoLrvxspPMrRaT
FMbOoDyfFF56YhHO4NhG3xSBwKDPkycVWmI0B9QtOHuES4aFiTzQ6YbHPa2uavn6
ODDc3UBdYgU0jxTsW71oi7CM0q4LoHnrTGmFn2YgXZApRpHSSyCRB7EpBaZqQXNa
AWtGPhMRwaduGdQfUMTnjY1W3P6VMrnTAn0O78ed5kjRf8QzkenFjm6hLoCOMX+d
ffq87PvdCo5yxi+xFzNe6dYcFykSyzebUUXTEueuCcdZVB1QS3yJo7JK3v9nuu86
oHyV0WG5iGY9+B+IEmDC9z+O04AYZbFm0vHN0KmkhTbXiyMGS0Q6tmGiV10FSRb9
vp630WmiSbalZ4zWaEdk/6uxt95qhYHlRgBzjdMSEu7TGmzPoJ5Cwaw+/N2HMndC
0eBQ4372ViO/tX+Y5ZuOC1JSZHW21R2BYZf4rNLlKKm8yor+tW2gIsSQfHzbnrzN
oUCmg2ID4YsE4WGiqIglq+2xEd5+CaVhxr530pan7hkM+BnX2ICdWLMKFmcsxqCw
X1aDwBySim+q6RhD8dfeP4qN6js3SfrvWvrR10Y7dks73LRGGoyYDIljuWEkfF5y
f2q8r/basaGgtAWth3k=
=n6kQ
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
