Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3JJGYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:24:30 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:49677 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3JJGY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:24:28 -0400
Message-ID: <52564813.5090006@monstr.eu>
Date: Thu, 10 Oct 2013 08:24:19 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 2/3] video: xilinxfb: Use devm_kzalloc instead of kzalloc
References: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381315928.git.michal.simek@xilinx.com>  <748c16093663172918a90a53dc472cb8beb584ca.1381315928.git.michal.simek@xilinx.com> <1381331583.2050.11.camel@joe-AO722>
In-Reply-To: <1381331583.2050.11.camel@joe-AO722>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="M8J1c9Ghn74g0s55oH0lbPguiVA6OtrBW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--M8J1c9Ghn74g0s55oH0lbPguiVA6OtrBW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/09/2013 05:13 PM, Joe Perches wrote:
> On Wed, 2013-10-09 at 12:52 +0200, Michal Simek wrote:
>> Simplify driver probe and release function.
> []
>> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
> []
>> @@ -423,7 +419,7 @@ static int xilinxfb_of_probe(struct platform_devic=
e *pdev)
>>  	pdata =3D xilinx_fb_default_pdata;
>>
>>  	/* Allocate the driver data region */
>> -	drvdata =3D kzalloc(sizeof(*drvdata), GFP_KERNEL);
>> +	drvdata =3D devm_kzalloc(&pdev->dev, sizeof(*drvdata), GFP_KERNEL);
>>  	if (!drvdata) {
>>  		dev_err(&pdev->dev, "Couldn't allocate device private record\n");
>=20
> Be nice to remove the unnecessary OOM message.
> There's already a generic dump_stack on OOM.

Ah yeah - this series was made before I knew this.
Will send v3.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--M8J1c9Ghn74g0s55oH0lbPguiVA6OtrBW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJWSBMACgkQykllyylKDCGDxgCfevQKsS/86rhtCZg5Qqu6UJDj
AO0AoIsKND1XLd22cwSh+03gS6HTD70T
=BjuX
-----END PGP SIGNATURE-----

--M8J1c9Ghn74g0s55oH0lbPguiVA6OtrBW--
