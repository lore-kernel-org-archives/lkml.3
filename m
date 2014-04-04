Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaDDMWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:22:40 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:40636 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaDDMWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:22:36 -0400
Message-ID: <533EA408.6030807@monstr.eu>
Date: Fri, 04 Apr 2014 14:22:32 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 09/20] of/fdt: create common debugfs
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com> <1396563423-30893-10-git-send-email-robherring2@gmail.com> <533EA2B0.7080703@monstr.eu>
In-Reply-To: <533EA2B0.7080703@monstr.eu>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="r10iaFHWe8I0MrFruuVTGa97lJwlHwBbP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r10iaFHWe8I0MrFruuVTGa97lJwlHwBbP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

>> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
>> index fa16a91..2085d47 100644
>> --- a/drivers/of/fdt.c
>> +++ b/drivers/of/fdt.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/string.h>
>>  #include <linux/errno.h>
>>  #include <linux/slab.h>
>> +#include <linux/debugfs.h>
>> =20
>>  #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
>>  #ifdef CONFIG_PPC
>> @@ -1084,4 +1085,27 @@ void __init unflatten_and_copy_device_tree(void=
)
>>  	unflatten_device_tree();
>>  }
>> =20
>> +#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
>> +static struct debugfs_blob_wrapper flat_dt_blob;
>> +
>> +static int __init of_flat_dt_debugfs_export_fdt(void)
>> +{
>> +	struct dentry *d =3D debugfs_create_dir("device-tree", NULL);
>> +
>> +	if (!d)
>> +		return -ENOENT;
>> +
>> +	flat_dt_blob.data =3D initial_boot_params;
>> +	flat_dt_blob.size =3D fdt_totalsize(initial_boot_params);
>=20
> Have you tried to compile this?
>=20
> From my tests fdt_totalsize is not available for target just for host
> from libfdt.h
>=20
> drivers/of/fdt.c: In function 'of_flat_dt_debugfs_export_fdt':
> drivers/of/fdt.c:957:2: error: implicit declaration of function 'fdt_to=
talsize' [-Werror=3Dimplicit-function-declaration]

Ignore this one - there is no compilation problem.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--r10iaFHWe8I0MrFruuVTGa97lJwlHwBbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM+pAgACgkQykllyylKDCEf6wCghsimYAczhHWXbZUjT49dX+uS
mPEAnjbZGwC+DMYWYEBlqILPbjiqfRvW
=pRcv
-----END PGP SIGNATURE-----

--r10iaFHWe8I0MrFruuVTGa97lJwlHwBbP--
