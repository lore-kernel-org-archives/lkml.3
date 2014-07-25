Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbaGYGrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:47:14 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52636 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbaGYGrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:47:12 -0400
Message-ID: <53D1FD69.4020109@monstr.eu>
Date: Fri, 25 Jul 2014 08:47:05 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: linux-arm-kernel@lists.infradead.org,
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
Subject: Re: [PATCH] ARM: zynq: DT: Add CAN node
References: <52d799e17cd3539713625c6f6a6666620f52d692.1406120732.git.michal.simek@xilinx.com> <20140723160702.GA14564@xsjandreislx> <2fe3a869-d17c-4521-a5c1-7c347ae34726@BN1BFFO11FD060.protection.gbl> <d973d7c8-30e7-458e-9d57-15da917cde04@BL2FFO11FD030.protection.gbl>
In-Reply-To: <d973d7c8-30e7-458e-9d57-15da917cde04@BL2FFO11FD030.protection.gbl>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WXnXmPW2X6Nq76pbWQfkukS3wHp8qVaF7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WXnXmPW2X6Nq76pbWQfkukS3wHp8qVaF7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/24/2014 05:55 PM, S=C3=B6ren Brinkmann wrote:
> On Thu, 2014-07-24 at 08:44AM +0200, Michal Simek wrote:
>> On 07/23/2014 06:07 PM, S=C3=B6ren Brinkmann wrote:
>>> On Wed, 2014-07-23 at 03:05PM +0200, Michal Simek wrote:
>>>> Add node describing Zynq's CAN controller.
>>>>
>>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>>> ---
>>>>
>>>>  arch/arm/boot/dts/zynq-7000.dtsi | 13 ++++++++++++-
>>>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zy=
nq-7000.dtsi
>>>> index 366ca6434f54..2287d9b4ed1a 100644
>>>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
>>>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
>>>> @@ -71,7 +71,18 @@
>>>>  			interrupts =3D <0 7 4>;
>>>>  			interrupt-parent =3D <&intc>;
>>>>  			clocks =3D <&clkc 12>;
>>>> -		};
>>>> +		};
>>>> +
>>>> +		can0: can@e0008000 {
>>>> +			compatible =3D "xlnx,zynq-can-1.0";
>>>> +			clocks =3D <&clkc 19>, <&clkc 36>;
>>>> +			clock-names =3D "can_clk", "pclk";
>>>> +			reg =3D <0xe0008000 0x1000>;
>>>> +			interrupts =3D <0 28 4>;
>>>> +			interrupt-parent =3D <&intc>;
>>>> +			tx-fifo-depth =3D <0x40>;
>>>> +			rx-fifo-depth =3D <0x40>;
>>>> +		};
>>>
>>> What about the second CAN core? You also probably want to add
>>> 'status =3D "disabled"' in the dtsi.
>>
>> Second can core - yes.
>>
>> I can add status =3D "disabled" but then question is if make
>> sense to change status for any zynq dts file. Or just
>> keep enable both.
>>
>> In our repo is enabled can0 on zc702.
>>
>> What do you think?
>=20
> Well, it should be enabled on boards that have CAN pinned out. Does any=

> of our boards have that?

I have checked and only can0 for zc702 should be enabled.

Let me send v2.

Thanks,
Michal



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--WXnXmPW2X6Nq76pbWQfkukS3wHp8qVaF7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPR/WkACgkQykllyylKDCGX/gCcCjJARrrn/xJCXlPGj13j+4Yi
wTYAn1KUNeiNGW+Itpu8VOtdxNL/zsPI
=AwwV
-----END PGP SIGNATURE-----

--WXnXmPW2X6Nq76pbWQfkukS3wHp8qVaF7--
