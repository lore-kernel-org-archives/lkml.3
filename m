Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3JHVgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 17:36:50 -0400
Received: from sauhun.de ([89.238.76.85]:38066 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab3JHVgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 17:36:48 -0400
Date: Tue, 8 Oct 2013 23:36:43 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
Cc: Peter Korsgaard <peter.korsgaard@barco.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-mux-gpio: use deferred probing with the device
 tree
Message-ID: <20131008213642.GB29121@katana>
References: <52540DF6.6050407@nsn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <52540DF6.6050407@nsn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 08, 2013 at 03:51:50PM +0200, Ionut Nicu wrote:
> If the i2c-parent bus driver is not loaded, returning
> -EINVAL will force people to unload and then reload the
> module again to get it working.
>=20
> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>

Doesn't the non-DT case need fixing, too?

> ---
>  drivers/i2c/muxes/i2c-mux-gpio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux=
-gpio.c
> index 5d4a99b..eb99f04 100644
> --- a/drivers/i2c/muxes/i2c-mux-gpio.c
> +++ b/drivers/i2c/muxes/i2c-mux-gpio.c
> @@ -79,7 +79,7 @@ static int i2c_mux_gpio_probe_dt(struct gpiomux *mux,
>  	adapter =3D of_find_i2c_adapter_by_node(adapter_np);
>  	if (!adapter) {
>  		dev_err(&pdev->dev, "Cannot find parent bus\n");
> -		return -ENODEV;
> +		return -EPROBE_DEFER;
>  	}
>  	mux->data.parent =3D i2c_adapter_id(adapter);
>  	put_device(&adapter->dev);
> --=20
> 1.7.1

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSVHrqAAoJEBQN5MwUoCm2looP/1jWphyrf9kBIJBmyc95SNHl
XkqHvWpkXMBnIYMSYxej/cXoq5wgq339rkmfk9lVJajj+/c0IuRDXVfR59eIO747
WX1qRyd0gc8G4zgg2mNNJl/2xrjqg1SPJq2GlcO5vA9DegnA+kiLIBWl9uJZqfLM
zyYlmPMW/VeY9ZfJ26b8tj56iywVmNKpypdcW6TCMivR5V/DGqG52SxdshysTxAz
U9KYx0cBwCBuwKUc+1eno4jqn1S0LlOs6S8iAnV+69CXygJr9AFScgf1PdLxfkx9
dbz1Tonys80AtaiV/0mQjiS8chIaKAuc+4GREP364X1kVUkuibjKRCeG315iWHve
k3DMsq9pJSfOQbGBruQyQfCrOFp58vYyldBTDSt5OrpvT6FnZ5SumtvCEMhwNQ3m
FhSDa4ZqnAirhICyKCHysVq6KjbAbFZDOi60LFEIFBsZ+/JM7R31bBxcEX+jdJwH
PMsTsWhvOJPedj0HFWJPObxvvlyQ6UOYVwTS+OJyHVvRzNrrBwlE1a+4/nI372z4
STItz3Qn5sgQUGXUxlrdMnJu4DBGFVJ41vM1htpisTRX8Smgax7tgVFbbunnf9kn
9j9twMqdmtheXDT3fdNvoUUFu05vKzCELi1Rz45VMLci6noUtzqeHOYyYhrIDE8v
cmlf+Q6dO5kNwbPXhfoV
=mZJQ
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
