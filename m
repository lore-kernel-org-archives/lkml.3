Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3FCMrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:47:43 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:43161 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3FCMrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:47:41 -0400
Message-ID: <51AC9068.7050203@monstr.eu>
Date: Mon, 03 Jun 2013 14:47:36 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org,
        Graeme Smecher <gsmecher@threespeedlogic.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] xilinx systemace: Fix device name assignment for
 SystemACE (from "xs`" to "xsa").
References: <4b5d6615a1338145a461a6d4e1c7d3e42d4f4522.1369312303.git.michal.simek@xilinx.com>
In-Reply-To: <4b5d6615a1338145a461a6d4e1c7d3e42d4f4522.1369312303.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2XSDVEXBSKSGFIGXCIBIH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2XSDVEXBSKSGFIGXCIBIH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Greg,

do you want to take these two patches through your tree?
Or should I take them through my microblaze tree?

Thanks,
Michal


On 05/23/2013 02:31 PM, Michal Simek wrote:
> From: Graeme Smecher <gsmecher@threespeedlogic.com>
>=20
> This fixes a bug introduced in 5d10302f46d, where device trees that don=
't
> provide the "port-number" attribute are mistakenly assigned the device =
"xs`".
> The error check that's supposed to assign a default letter can't succee=
d,
> since it tests an unsigned type against a negative return code.
>=20
> Signed-off-by: Graeme Smecher <gsmecher@threespeedlogic.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/block/xsysace.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
> index f8ef15f..3fd130f 100644
> --- a/drivers/block/xsysace.c
> +++ b/drivers/block/xsysace.c
> @@ -1160,8 +1160,7 @@ static int ace_probe(struct platform_device *dev)=

>  	dev_dbg(&dev->dev, "ace_probe(%p)\n", dev);
>=20
>  	/* device id and bus width */
> -	of_property_read_u32(dev->dev.of_node, "port-number", &id);
> -	if (id < 0)
> +	if (of_property_read_u32(dev->dev.of_node, "port-number", &id))
>  		id =3D 0;
>  	if (of_find_property(dev->dev.of_node, "8-bit", NULL))
>  		bus_width =3D ACE_BUS_WIDTH_8;
> --
> 1.8.2.3
>=20


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2XSDVEXBSKSGFIGXCIBIH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGskGgACgkQykllyylKDCGwoACgg8zRuyY/241HmMlAHk76kweo
8/YAnAh5IuiYN2n4DMOwzyB+MjUpEjd1
=l0Eq
-----END PGP SIGNATURE-----

------enig2XSDVEXBSKSGFIGXCIBIH--
