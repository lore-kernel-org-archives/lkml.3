Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaAMIVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:21:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46498 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaAMIVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:21:32 -0500
Message-ID: <52D3A1FC.4090706@ti.com>
Date: Mon, 13 Jan 2014 10:21:16 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v5] video: add OpenCores VGA/LCD framebuffer driver
References: <1389384793-4710-1-git-send-email-stefan.kristiansson@saunalahti.fi>
In-Reply-To: <1389384793-4710-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="khsultjNQ0J5j9ecxHcDlF1bvVGcwj7sA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--khsultjNQ0J5j9ecxHcDlF1bvVGcwj7sA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-10 22:13, Stefan Kristiansson wrote:
> This adds support for the VGA/LCD core available from OpenCores:
> http://opencores.org/project,vga_lcd
>=20
> The driver have been tested together with both OpenRISC and
> ARM (socfpga) processors.
>=20
> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

> +/*
> + * Init and exit routines
> + */
> +static int __init ocfb_init(void)
> +{
> +#ifndef MODULE
> +	char *option =3D NULL;
> +
> +	if (fb_get_options("ocfb", &option))
> +		return -ENODEV;
> +	ocfb_setup(option);
> +#endif
> +	return platform_driver_register(&ocfb_driver);
> +}

I see this is how fb_get_options is used elsewhere also, but shouldn't
fb_get_options be called with a name that's somehow device specific? I
haven't used it in omapfb, so maybe I'm missing how it is supposed to
work, but if I'm not mistaken, if you have two ocfb devices on your
board, there's no way to specify individual modes for them. Even the
Documentation/fb/modedb.txt gives an example of a "VGA-1" which sounds
to me that it has been designed to be used with some kind of device id.

Although even if the above code handled the different devices, when
loading this as a module would still not work right as that code is not
called at all in the module case. Ah, well. I guess this is legacy
stuff, and it's just the way it works.

The subject says this is a VGA/LCD driver. Usually with LCD, the LCD
video timings are passed via device tree or platform data, as there's
just one possible set of timings for a board. Is that something that
you've thought about, or is the user always supposed to give the timings
explicitly via kernel cmdline?

 Tomi



--khsultjNQ0J5j9ecxHcDlF1bvVGcwj7sA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS06H/AAoJEPo9qoy8lh71bbAP/A9eM99/TGuHRRCUJ+kIyLXl
nfzswI/PyjQz1WGfY+q8cZbUagHg7g5JYYs/LyoljLZdkHEpWew/RL9MR+2XCnY1
0zzZmM8DnaEcPW8xgmsCICv2wnETo59J/ZoY2zLuHrDepzj97GUJIGXBa6xmU0Jc
am/ztVOdwU/Ivjo8aqmmnlvkenogqTHTQBSxHsIgCcadsaxlZWErjOggg1/j8cxs
UTUo+7btzvM3LY8YVyPmyPP99qFFee5Ern/0ME0vaia7d29SVi3asnM/ujKWkHOw
UNbidmgGO0c0p6e2EhEp6ZE3BhjtyJvHWdazXsx1hzF9FTKp8LECmcL6g+D4kUC5
i7PXX5Qzj8EtbiKmvzL8T/frFi5mvwuKsuVkcdhB+Jy9L9DB/A1OJdGpUb05IFHA
RwUsJK0F4qx0QD2dGk6KjhXuXyDVMRVQnoS/uqKifea7L/sdQL1O/xIS4AjbLbDG
mp+siQ1AEQrUWGCSkud90/DS/i7t7GSViBbD4Lg2KFiCOL4wIMQbzHVGMj+JWMLr
jLveuD5W9Lzv6vXOpRQmA5vCrSYn9d35iT4twwdPdpxsSqVO6j5zRN7GBM1M2/Hv
Dj1wQx5yvgE8GsW6yb3BYFtBdUF+AY/29LcIMc5pXpOB2POssuGw7OsDGfTqYZdO
f8hsF0+ClQ/fRCl8Gmh2
=5/HB
-----END PGP SIGNATURE-----

--khsultjNQ0J5j9ecxHcDlF1bvVGcwj7sA--
