Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaBLKwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:52:13 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:49167 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaBLKwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:52:11 -0500
Message-ID: <52FB521F.5040006@monstr.eu>
Date: Wed, 12 Feb 2014 11:51:11 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [RFC PATCH 2/3] mfd: syscon: Support early initialization
References: <cover.1392045742.git.michal.simek@xilinx.com> <1785585d090175da81b561b17eeef95d991ff0de.1392045742.git.michal.simek@xilinx.com> <20140212095424.GV15081@lee--X1>
In-Reply-To: <20140212095424.GV15081@lee--X1>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="J044i5m73dlNOJThpq1W4516OdwH4rLVT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J044i5m73dlNOJThpq1W4516OdwH4rLVT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/12/2014 10:54 AM, Lee Jones wrote:
> On Mon, 10 Feb 2014, Michal Simek wrote:
>=20
>> Some platforms need to get system controller
>> ready as soon as possible.
>> The patch provides early_syscon_initialization
>> which create early mapping for all syscon compatible
>> devices in early_syscon_probe.
>> Regmap is get via syscon_early_regmap_lookup_by_phandle()
>>
>> Regular device probes attach device to regmap
>> via regmap_attach_dev().
>>
>> For early syscon initialization is necessary to extend
>> struct syscon and provide remove function
>> which unmap all early init structures.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>>  drivers/mfd/syscon.c       | 126 ++++++++++++++++++++++++++++++++++++=
+++------
>>  include/linux/mfd/syscon.h |  11 ++++
>>  2 files changed, 120 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
>=20
> <snip>
>=20
>>  struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np=
,
>>  					const char *property)
>>  {
>> @@ -128,40 +149,110 @@ static int syscon_probe(struct platform_device =
*pdev)
>>  	struct device *dev =3D &pdev->dev;
>>  	struct syscon *syscon;
>>  	struct resource *res;
>> -	void __iomem *base;
>>
>> -	syscon =3D devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
>> +	/* Early syscon init */
>> +	if (pdev->dev.of_node && pdev->dev.of_node->data) {
>> +		syscon =3D pdev->dev.of_node->data;
>> +		res =3D &syscon->res;
>> +		regmap_attach_dev(dev, syscon->regmap, &syscon_regmap_config);
>=20
> Instead of duplicating all of the init code with early and late
> versions of each, is there any reason why we can't always do the early
> stuff early and then connect it to the dev infrastructure when it
> becomes available?

I am waiting for Arnd and Mark opinions regarding this.
That's why it was just RFC.
There the next question is if this should still stay
in mfd or moved to base.

I wanted to keep this to be driver compatible
that's why I have done it in this way.

We will see.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--J044i5m73dlNOJThpq1W4516OdwH4rLVT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlL7Uh8ACgkQykllyylKDCG8zQCbBV3p2R8qFz4vatj++7m3ehNr
QBoAnRx2tVewQreoaZrzjYB3nRNrqX7a
=PDbw
-----END PGP SIGNATURE-----

--J044i5m73dlNOJThpq1W4516OdwH4rLVT--
