Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaFKBYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 21:24:36 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53493 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaFKBYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 21:24:34 -0400
Message-ID: <5397AFCA.8030906@monstr.eu>
Date: Wed, 11 Jun 2014 03:24:26 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, devicetree@vger.kernel.org
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] of/platform: Fix microblaze build failure
References: <1402426754-7328-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1402426754-7328-1-git-send-email-linux@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2HrTdjDTg60UKq4ECdDMmv3s1ekRQTvlm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2HrTdjDTg60UKq4ECdDMmv3s1ekRQTvlm
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/10/2014 08:59 PM, Guenter Roeck wrote:
> Commit bf5db2f (microblaze: Use generic device.h) removes the
> microblaze specific pdev_archdata and dma_mask.
>=20
> At the same time, commit 591c1ee (of: configure the platform
> device dma parameters) initializes the just removed field.
> This causes all microblaze builds to fail.
>=20
> Drop the unnecessary initialization.
>=20
> Cc: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/of/platform.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 6c48d73..500436f 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -166,10 +166,6 @@ static void of_dma_configure(struct platform_devic=
e *pdev)
>  	int ret;
>  	struct device *dev =3D &pdev->dev;
> =20
> -#if defined(CONFIG_MICROBLAZE)
> -	pdev->archdata.dma_mask =3D 0xffffffffUL;
> -#endif
> -
>  	/*
>  	 * Set default dma-mask to 32 bit. Drivers are expected to setup
>  	 * the correct supported dma_mask.
>=20

Acked-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--2HrTdjDTg60UKq4ECdDMmv3s1ekRQTvlm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOXr8oACgkQykllyylKDCGqJACfZaFqBpVivmJoPHRylgQF+vda
wm8AnilL1Zm/vBguYBn/SCZA91HTFeiF
=rzd9
-----END PGP SIGNATURE-----

--2HrTdjDTg60UKq4ECdDMmv3s1ekRQTvlm--
