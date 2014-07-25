Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbaGYIDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:03:00 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40212 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbaGYIC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:02:56 -0400
Message-ID: <53D20F2A.5020209@monstr.eu>
Date: Fri, 25 Jul 2014 10:02:50 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 06/11] ARM: dts: zynq: Add DMAC for Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-7-git-send-email-afaerber@suse.de> <bc390439-9a5b-43a1-a70c-a4c6517a6cb6@BN1AFFO11FD005.protection.gbl>
In-Reply-To: <bc390439-9a5b-43a1-a70c-a4c6517a6cb6@BN1AFFO11FD005.protection.gbl>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="k9JQxe2j7S2x6jUeOcPD30TNlojb0SH0N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k9JQxe2j7S2x6jUeOcPD30TNlojb0SH0N
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/25/2014 01:28 AM, S=C3=B6ren Brinkmann wrote:
> On Fri, 2014-07-25 at 01:00AM +0200, Andreas F=C3=A4rber wrote:
>> Signed-off-by: Andreas F=C3=A4rber <afaerber@suse.de>
>> ---
>>  v2: New
>> =20
>>  arch/arm/boot/dts/zynq-7000.dtsi      | 17 +++++++++++++++++
>>  arch/arm/boot/dts/zynq-parallella.dts |  4 ++++
>>  2 files changed, 21 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq=
-7000.dtsi
>> index eed3df0..1a70277 100644
>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
>> @@ -223,6 +223,23 @@
>>  			};
>>  		};
>> =20
>> +		dmac_s: dmac@f8003000 {
>> +			compatible =3D "arm,pl330", "arm,primecell";
>> +			reg =3D <0xf8003000 0x1000>;
>> +			status =3D "disabled";
> I think for this IP we can omit the 'status' property since it is alway=
s
> enabled. I don't see a reason to override it in each board DT.

Done this change myself

>=20
>> +			interrupt-parent =3D <&intc>;
>> +			interrupts =3D <0 13 4>,
>> +			             <0 14 4>, <0 15 4>,
>> +			             <0 16 4>, <0 17 4>,
>> +			             <0 40 4>, <0 41 4>,
>> +			             <0 42 4>, <0 43 4>;
>> +			#dma-cells =3D <1>;
>> +			#dma-channels =3D <8>;
>> +			#dma-requests =3D <4>;
>> +			clocks =3D <&clkc 27>;
>> +			clock-names =3D "apb_pclk";
>> +		};
>> +
>=20
> Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>


Applied to zynq/dt branch.
https://github.com/Xilinx/linux-xlnx/commits/zynq/dt

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--k9JQxe2j7S2x6jUeOcPD30TNlojb0SH0N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPSDyoACgkQykllyylKDCFvoACeNvYOj1oEElQG/9lELpAeNXbi
s0cAn15kYHL6gZdZoGB0donCXXsApX/x
=AJVQ
-----END PGP SIGNATURE-----

--k9JQxe2j7S2x6jUeOcPD30TNlojb0SH0N--
