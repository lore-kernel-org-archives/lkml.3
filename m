Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaG1JSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:18:13 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:51153 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaG1JSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:18:12 -0400
Message-ID: <53D6154D.3060107@monstr.eu>
Date: Mon, 28 Jul 2014 11:18:05 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: linux-arm-kernel@lists.infradead.org,
        Appana Durga Kedareswara Rao <appanad@xilinx.com>, monstr@monstr.eu,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: zynq: DT: Add CAN node
References: <56bf20294d106e0fc9c23a70cd991a50b441d0aa.1406271138.git.michal.simek@xilinx.com> <20140725150017.GE16049@xsjandreislx>
In-Reply-To: <20140725150017.GE16049@xsjandreislx>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="huVTxpfoiL588CpDP2Kr4j20BO6l4vfQM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--huVTxpfoiL588CpDP2Kr4j20BO6l4vfQM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/25/2014 05:00 PM, S=C3=B6ren Brinkmann wrote:
> On Fri, 2014-07-25 at 08:52AM +0200, Michal Simek wrote:
>> Add node describing Zynq's CAN controller.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>> Changes in v2:
>> - Add can1
>> - Enable can0 for zc702
>> - Use status property
>>
>>  arch/arm/boot/dts/zynq-7000.dtsi | 26 +++++++++++++++++++++++++-
>>  arch/arm/boot/dts/zynq-zc702.dts |  4 ++++
>>  2 files changed, 29 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq=
-7000.dtsi
>> index 366ca6434f54..983148111e3a 100644
>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
>> @@ -71,7 +71,31 @@
>>  			interrupts =3D <0 7 4>;
>>  			interrupt-parent =3D <&intc>;
>>  			clocks =3D <&clkc 12>;
>> -		};
>> +		};
>> +
>> +		can0: can@e0008000 {
>> +			compatible =3D "xlnx,zynq-can-1.0";
>> +			status =3D "disabled";
>> +			clocks =3D <&clkc 19>, <&clkc 36>;
>> +			clock-names =3D "can_clk", "pclk";
>> +			reg =3D <0xe0008000 0x1000>;
>> +			interrupts =3D <0 28 4>;
>> +			interrupt-parent =3D <&intc>;
>> +			tx-fifo-depth =3D <0x40>;
>> +			rx-fifo-depth =3D <0x40>;
>> +		};
>> +
>> +		can1: can@e0009000 {
>> +			compatible =3D "xlnx,zynq-can-1.0";
>> +			status =3D "disabled";
>> +			clocks =3D <&clkc 19>, <&clkc 36>;
> The clocks for CAN1 must be outputs 20 and 37 of the clkc.

Fixed in v3.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--huVTxpfoiL588CpDP2Kr4j20BO6l4vfQM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPWFU0ACgkQykllyylKDCEoEQCfdKTpPsRBtasvFXr/Q6+JTkHt
kpQAnRCKDqobBbVt2k9cHcvbYcVJPue6
=Ziyw
-----END PGP SIGNATURE-----

--huVTxpfoiL588CpDP2Kr4j20BO6l4vfQM--
