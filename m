Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaBJLBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:01:07 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:54657 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaBJLBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:01:01 -0500
Message-ID: <52F8B167.6070901@monstr.eu>
Date: Mon, 10 Feb 2014 12:00:55 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] regmap: Check readable regs in _regmap_read
References: <73e82a7cf77a1a68c5303def3071418b7d0ea382.1392029156.git.michal.simek@xilinx.com> <52F8AFB2.4000307@metafoo.de>
In-Reply-To: <52F8AFB2.4000307@metafoo.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DjFwCqU5rSkhCRcrdcu7PH5NL7G2quacH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DjFwCqU5rSkhCRcrdcu7PH5NL7G2quacH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Lars,

On 02/10/2014 11:53 AM, Lars-Peter Clausen wrote:
> On 02/10/2014 11:46 AM, Michal Simek wrote:
>> Check if regs are readable.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>>   drivers/base/regmap/regmap.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap=
=2Ec
>> index 6a19515..7569dfc 100644
>> --- a/drivers/base/regmap/regmap.c
>> +++ b/drivers/base/regmap/regmap.c
>> @@ -1725,6 +1725,9 @@ static int _regmap_read(struct regmap *map, unsi=
gned int reg,
>>       int ret;
>>       void *context =3D _regmap_map_get_context(map);
>>
>> +    if (!regmap_readable(map, reg))
>> +        return -EIO;
>> +
>=20
> This will cause issues with devices where registers are writable, but n=
ot readable, but we keep the register value in the cache.

And can you read from registers if they are not readable?
Even read from cache.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--DjFwCqU5rSkhCRcrdcu7PH5NL7G2quacH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlL4sWcACgkQykllyylKDCHhPQCdF3OhWwUj6PyKgaEDYk80mw87
hNMAoJk8C6OkRU7PlS5UA7JeKgczY6zA
=cz2f
-----END PGP SIGNATURE-----

--DjFwCqU5rSkhCRcrdcu7PH5NL7G2quacH--
