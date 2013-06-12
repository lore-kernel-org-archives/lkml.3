Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3FLHqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:46:39 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:58909 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab3FLHqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:46:37 -0400
Message-ID: <51B82755.4080701@monstr.eu>
Date: Wed, 12 Jun 2013 09:46:29 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Dinh Nguyen <dinguyen@altera.com>, Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: dt: zynq: Add support for the zc706 platform
References: <1370884204-2297-1-git-send-email-soren.brinkmann@xilinx.com> <1370985888.7804.1.camel@linux-builds1> <785766f9-0d23-4a78-8638-fac05920049d@CO1EHSMHS013.ehs.local>
In-Reply-To: <785766f9-0d23-4a78-8638-fac05920049d@CO1EHSMHS013.ehs.local>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2VUAEIEJXDFHQKLPMVQSH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VUAEIEJXDFHQKLPMVQSH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/11/2013 11:28 PM, S=C3=B6ren Brinkmann wrote:
> On Tue, Jun 11, 2013 at 04:24:48PM -0500, Dinh Nguyen wrote:
>> Hi Soren,
>>
>> On Mon, 2013-06-10 at 10:10 -0700, Soren Brinkmann wrote:
>>> Add a DT fragment for the zc706 Zynq platform. Also, adding a
>>> corresponding target to the Makefile and adding an appropriate
>>> compatibility string in the BSP.
>>>
>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>> ---
>>>  arch/arm/boot/dts/Makefile       |  3 ++-
>>>  arch/arm/boot/dts/zynq-zc706.dts | 31 ++++++++++++++++++++++++++++++=
+
>>>  arch/arm/mach-zynq/common.c      |  1 +
>>>  3 files changed, 34 insertions(+), 1 deletion(-)
>>>  create mode 100644 arch/arm/boot/dts/zynq-zc706.dts
>>>
>>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>>> index b9f7121..2aecf7e 100644
>>> --- a/arch/arm/boot/dts/Makefile
>>> +++ b/arch/arm/boot/dts/Makefile
>>> @@ -206,7 +206,8 @@ dtb-$(CONFIG_ARCH_VT8500) +=3D vt8500-bv07.dtb \
>>>  	wm8505-ref.dtb \
>>>  	wm8650-mid.dtb \
>>>  	wm8850-w70v2.dtb
>>> -dtb-$(CONFIG_ARCH_ZYNQ) +=3D zynq-zc702.dtb
>>> +dtb-$(CONFIG_ARCH_ZYNQ) +=3D zynq-zc702.dtb \
>>> +	zynq-zc706.dtb
>>> =20
>>>  targets +=3D dtbs
>>>  targets +=3D $(dtb-y)
>>> diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zyn=
q-zc706.dts
>>> new file mode 100644
>>> index 0000000..a8a1d7d
>>> --- /dev/null
>>> +++ b/arch/arm/boot/dts/zynq-zc706.dts
>>> @@ -0,0 +1,31 @@
>>> +/*
>>> + *  Copyright (C) 2011 Xilinx
>>> + *  Copyright (C) 2012 National Instruments Corp.
>>> + *  Copyright (C) 2013 Xilinx
>>> + *
>>> + * This software is licensed under the terms of the GNU General Publ=
ic
>>> + * License version 2, as published by the Free Software Foundation, =
and
>>> + * may be copied, distributed, and modified under those terms.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +/dts-v1/;
>>> +/include/ "zynq-7000.dtsi"
>>> +
>>> +/ {
>>> +	model =3D "Zynq ZC706 Development Board";
>>> +	compatible =3D "xlnx,zynq-zc706", "xlnx,zynq-7000";
>>> +
>>> +	memory {
>>> +		device_type =3D "memory";
>>> +		reg =3D <0x0 0x40000000>;
>>> +	};
>>> +
>>> +	chosen {
>>> +		bootargs =3D "console=3DttyPS1,115200 earlyprintk";
>>> +	};
>>> +
>>> +};
>>> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.=
c
>>> index 5bfe703..221694b 100644
>>> --- a/arch/arm/mach-zynq/common.c
>>> +++ b/arch/arm/mach-zynq/common.c
>>> @@ -99,6 +99,7 @@ static void zynq_system_reset(char mode, const char=
 *cmd)
>>> =20
>>>  static const char * const zynq_dt_match[] =3D {
>>>  	"xlnx,zynq-zc702",
>>> +	"xlnx,zynq-zc706",
>>
>> You really don't need to add zc706 here if it is already compatable wi=
th
>> zynq-7000.
> I actually thought about this and decided to add it, since there alread=
y
> was an entry for the zc702. What is the best methord for this cases?
> Rather remove the specific ones and migrate all to the zynq-7000
> compatibility string?

Please remove zc702 compatibility string from common.c and
don't add zc706.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2VUAEIEJXDFHQKLPMVQSH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlG4J1UACgkQykllyylKDCFJuACaA27jUCrvW8zVse2spn/xlgdi
jLYAn11SaPxrdFd6rGrJw29LNFNBnES0
=hc8r
-----END PGP SIGNATURE-----

------enig2VUAEIEJXDFHQKLPMVQSH--
