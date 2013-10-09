Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3JILSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:18:55 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:51581 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3JILSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:18:53 -0400
Message-ID: <52553B9A.6090901@monstr.eu>
Date: Wed, 09 Oct 2013 13:18:50 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] video: xilinxfb: Use standard variable name convention
References: <631df9a44b366af4129d00f1d4e1d3baad7d4903.1381315928.git.michal.simek@xilinx.com> <20131009110651.GH4981@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131009110651.GH4981@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="rHVM98jJUei5I1WoM7B7f6V9mWmbi38s1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rHVM98jJUei5I1WoM7B7f6V9mWmbi38s1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/09/2013 01:06 PM, Mark Rutland wrote:
> On Wed, Oct 09, 2013 at 11:52:12AM +0100, Michal Simek wrote:
>> s/op/pdev/ in xilinxfb_of_probe().
>> No functional chagnes.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>> Changes in v2: None
>>
>>  drivers/video/xilinxfb.c | 18 +++++++++---------
>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
>> index 0e1dd33..d12345f 100644
>> --- a/drivers/video/xilinxfb.c
>> +++ b/drivers/video/xilinxfb.c
>> @@ -411,7 +411,7 @@ static int xilinxfb_release(struct device *dev)
>>   * OF bus binding
>>   */
>>
>> -static int xilinxfb_of_probe(struct platform_device *op)
>> +static int xilinxfb_of_probe(struct platform_device *pdev)
>>  {
>>  	const u32 *prop;
>>  	u32 tft_access =3D 0;
>> @@ -425,7 +425,7 @@ static int xilinxfb_of_probe(struct platform_devic=
e *op)
>>  	/* Allocate the driver data region */
>>  	drvdata =3D kzalloc(sizeof(*drvdata), GFP_KERNEL);
>>  	if (!drvdata) {
>> -		dev_err(&op->dev, "Couldn't allocate device private record\n");
>> +		dev_err(&pdev->dev, "Couldn't allocate device private record\n");
>>  		return -ENOMEM;
>>  	}
>>
>> @@ -433,7 +433,7 @@ static int xilinxfb_of_probe(struct platform_devic=
e *op)
>>  	 * To check whether the core is connected directly to DCR or BUS
>>  	 * interface and initialize the tft_access accordingly.
>>  	 */
>> -	of_property_read_u32(op->dev.of_node, "xlnx,dcr-splb-slave-if",
>> +	of_property_read_u32(pdev->dev.of_node, "xlnx,dcr-splb-slave-if",
>>  			     &tft_access);
>>
>>  	/*
>> @@ -457,29 +457,29 @@ static int xilinxfb_of_probe(struct platform_dev=
ice *op)
>>  	}
>>  #endif
>>
>> -	prop =3D of_get_property(op->dev.of_node, "phys-size", &size);
>> +	prop =3D of_get_property(pdev->dev.of_node, "phys-size", &size);
>>  	if ((prop) && (size >=3D sizeof(u32)*2)) {
>>  		pdata.screen_width_mm =3D prop[0];
>>  		pdata.screen_height_mm =3D prop[1];
>>  	}
>=20
> While you're changing these lines, it would be nice to change this
> pattern (here and elsewhere) to use of_property_read_u32_array, so that=

> it's endian-safe and consistent with other devicetree parsing code:
>=20
>   of_property_read_u32_array(pdev->dev.of_node, "phys-size", prop, 2);
>=20
> It won't read the values if the property data's too short, so that
> should be consistent with the existing code.
>=20
> It would also make the diffstat negative :)

The intention of this patch is simple rename which is exactly how
patch should look like. It means one change per patch.

It means these changes you have describe should be in separate patch
and I definitely agree with them.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--rHVM98jJUei5I1WoM7B7f6V9mWmbi38s1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJVO5oACgkQykllyylKDCHAhACghAAMQdQ5kp067E6Cd0L4LdbI
PrgAnisV7CG7ukAzjIc5p/2dxbDG8hv6
=oZ5p
-----END PGP SIGNATURE-----

--rHVM98jJUei5I1WoM7B7f6V9mWmbi38s1--
