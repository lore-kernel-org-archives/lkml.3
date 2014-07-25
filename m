Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbaGYH7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:59:42 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56520 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759796AbaGYH7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:59:39 -0400
Message-ID: <53D20E5B.9070501@monstr.eu>
Date: Fri, 25 Jul 2014 09:59:23 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Harini Katakam <harinik@xilinx.com>
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
Subject: Re: [PATCH v2 05/11] ARM: dts: zynq: Add QSPI for Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-6-git-send-email-afaerber@suse.de> <ddb38ce5-9e31-4c94-967c-7784c7fba75c@BN1BFFO11FD028.protection.gbl>
In-Reply-To: <ddb38ce5-9e31-4c94-967c-7784c7fba75c@BN1BFFO11FD028.protection.gbl>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="62IjmugcpLSFa0WUUCoDlp5ueHdjeO3qO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--62IjmugcpLSFa0WUUCoDlp5ueHdjeO3qO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/25/2014 01:18 AM, S=C3=B6ren Brinkmann wrote:
> On Fri, 2014-07-25 at 01:00AM +0200, Andreas F=C3=A4rber wrote:
>> Prepare SPI0 and SPI1 while at it.

Patch subject is incorrect. You are adding SPI and QSPI.

>>
>> Signed-off-by: Andreas F=C3=A4rber <afaerber@suse.de>
>> ---
>>  v2: New
>> =20
>>  arch/arm/boot/dts/zynq-7000.dtsi      | 37 ++++++++++++++++++++++++++=
+++++++++
>>  arch/arm/boot/dts/zynq-parallella.dts |  4 ++++
>>  2 files changed, 41 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq=
-7000.dtsi
>> index 8fd826a..eed3df0 100644
>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
>> @@ -122,6 +122,30 @@
>>  			interrupts =3D <0 50 4>;
>>  		};
>> =20
>> +		spi0: spi@e0006000 {
>> +			compatible =3D "xlnx,zynq-spi-r1p6";
>> +			reg =3D <0xe0006000 0x1000>;
>> +			status =3D "disabled";
>> +			interrupt-parent =3D <&intc>;
>> +			interrupts =3D <0 26 4>;
>> +			clocks =3D <&clkc 25>, <&clkc 34>;
>> +			clock-names =3D "ref_clk", "pclk";
>> +			#address-cells =3D <1>;
>> +			#size-cells =3D <0>;
>> +		};
>> +
>> +		spi1: spi@e0007000 {
>> +			compatible =3D "xlnx,zynq-spi-r1p6";
>> +			reg =3D <0xe0007000 0x1000>;
>> +			status =3D "disabled";
>> +			interrupt-parent =3D <&intc>;
>> +			interrupts =3D <0 49 4>;
>> +			clocks =3D <&clkc 26>, <&clkc 35>;
>> +			clock-names =3D "ref_clk", "pclk";
>> +			#address-cells =3D <1>;
>> +			#size-cells =3D <0>;
>> +		};
>> +
> Until here things look good.
>=20
>>  		gem0: ethernet@e000b000 {
>>  			compatible =3D "cdns,gem";
>>  			reg =3D <0xe000b000 0x4000>;
>> @@ -140,6 +164,19 @@
>>  			clock-names =3D "pclk", "hclk", "tx_clk";
>>  		};
>> =20
>> +		qspi: qspi@e000d000 {
>> +			compatible =3D "xlnx,zynq-spi-r1p6";
>> +			reg =3D <0xe000d000 0x1000>;
>> +			status =3D "disabled";
>> +			interrupt-parent =3D <&intc>;
>> +			interrupts =3D <0 19 4>;
>> +			clocks =3D <&clkc 10>, <&clkc 43>;
>> +			clock-names =3D "ref_clk", "pclk";
>> +			num-cs =3D <1>;
>> +			#address-cells =3D <1>;
>> +			#size-cells =3D <0>;
>> +		};
>> +
> I'm not sure what the status of this driver is. I think QSPI is still
> under review on the mailing lists and I don't think we should add this
> yet.

Driver for qspi is not in the mainline yet but it doesn't mean
that this fragment won't work.
Harini: Can you please correct me if I am wrong?

I would prefer to send two separate patches.

1. just add SPI to zynq
2. if Harini confirms that it is working I think that make sense to enabl=
e
at least simple mode for qspi. That's why not a problem to add it too.
It means qspi patch with enabling for your board as second patch.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--62IjmugcpLSFa0WUUCoDlp5ueHdjeO3qO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPSDlsACgkQykllyylKDCEgoACgkcsPE8fDliCVFTLRmD1XhFXD
A+0An1N1irkJY/4BGIlsw61O9x8XJVBM
=K5+N
-----END PGP SIGNATURE-----

--62IjmugcpLSFa0WUUCoDlp5ueHdjeO3qO--
