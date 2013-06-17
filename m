Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3FQFZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:25:13 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59420 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3FQFZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:25:12 -0400
Message-ID: <51BE9DB4.1090400@monstr.eu>
Date: Mon, 17 Jun 2013 07:25:08 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 1/6] GPIO: xilinx: Simplify driver probe function
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2ANGUJJVNGULOBRSUXEJC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2ANGUJJVNGULOBRSUXEJC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

can you please look at this?

Thanks,
Michal


On 06/03/2013 02:31 PM, Michal Simek wrote:
> Simplification is done by using OF helper function
> which increase readability of code and remove
> (if (var) var =3D be32_to_cpup;) assignment.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> Changes in v2:
> - New patch in this series
>=20
>  drivers/gpio/gpio-xilinx.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
> index 9ae7aa8..2aad534 100644
> --- a/drivers/gpio/gpio-xilinx.c
> +++ b/drivers/gpio/gpio-xilinx.c
> @@ -170,24 +170,20 @@ static int xgpio_of_probe(struct device_node *np)=

>  		return -ENOMEM;
>=20
>  	/* Update GPIO state shadow register with default value */
> -	tree_info =3D of_get_property(np, "xlnx,dout-default", NULL);
> -	if (tree_info)
> -		chip->gpio_state =3D be32_to_cpup(tree_info);
> +	of_property_read_u32(np, "xlnx,dout-default", &chip->gpio_state);
> +
> +	/* By default, all pins are inputs */
> +	chip->gpio_dir =3D 0xFFFFFFFF;
>=20
>  	/* Update GPIO direction shadow register with default value */
> -	chip->gpio_dir =3D 0xFFFFFFFF; /* By default, all pins are inputs */
> -	tree_info =3D of_get_property(np, "xlnx,tri-default", NULL);
> -	if (tree_info)
> -		chip->gpio_dir =3D be32_to_cpup(tree_info);
> +	of_property_read_u32(np, "xlnx,tri-default", &chip->gpio_dir);
> +
> +	/* By default assume full GPIO controller */
> +	chip->mmchip.gc.ngpio =3D 32;
>=20
>  	/* Check device node and parent device node for device width */
> -	chip->mmchip.gc.ngpio =3D 32; /* By default assume full GPIO controll=
er */
> -	tree_info =3D of_get_property(np, "xlnx,gpio-width", NULL);
> -	if (!tree_info)
> -		tree_info =3D of_get_property(np->parent,
> -					    "xlnx,gpio-width", NULL);
> -	if (tree_info)
> -		chip->mmchip.gc.ngpio =3D be32_to_cpup(tree_info);
> +	of_property_read_u32(np, "xlnx,gpio-width",
> +			      (u32 *)&chip->mmchip.gc.ngpio);
>=20
>  	spin_lock_init(&chip->gpio_lock);
>=20
> --
> 1.8.2.3
>=20


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2ANGUJJVNGULOBRSUXEJC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlG+nbQACgkQykllyylKDCHaIQCfSF7uZ/Uy3gP6J383I+w+I2RX
PawAn36ckKZ3JdNJ3MsHrFA1dqZgWFlb
=RSbJ
-----END PGP SIGNATURE-----

------enig2ANGUJJVNGULOBRSUXEJC--
