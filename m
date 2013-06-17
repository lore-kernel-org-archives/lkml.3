Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab3FQGVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:21:47 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:48995 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab3FQGVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:21:44 -0400
Message-ID: <51BEAAF5.6070003@monstr.eu>
Date: Mon, 17 Jun 2013 08:21:41 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] DT: Add documentation for gpio-xilinx
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com> <af7595252de09373f5591f21262e5ffa7c9e0dc2.1370262666.git.michal.simek@xilinx.com> <CACRpkdaaZKyqBeJHnL4Q5vc3ZVa_psF61McJ2wsFQJMTGvn-NA@mail.gmail.com>
In-Reply-To: <CACRpkdaaZKyqBeJHnL4Q5vc3ZVa_psF61McJ2wsFQJMTGvn-NA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2PCWIGJANAVCVGJLACRJP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2PCWIGJANAVCVGJLACRJP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/17/2013 07:50 AM, Linus Walleij wrote:
> On Mon, Jun 3, 2013 at 2:31 PM, Michal Simek <michal.simek@xilinx.com> =
wrote:
>=20
>> Describe gpio-xilinx binding.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>> Changes in v2:
>> - Extend description
>=20
> Thanks, patch applied but look into this:
>=20
>> +Optional properties:
>> +- interrupts : Interrupt mapping for GPIO IRQ.
>> +- interrupt-parent : Phandle for the interrupt controller that
>> +  services interrupts for this device.
>> +- xlnx,all-inputs : if n-th bit is setup, GPIO-n is input
>> +- xlnx,dout-default : if n-th bit is 1, GPIO-n default value is 1
>> +- xlnx,gpio-width : gpio width
>> +- xlnx,tri-default : if n-th bit is 1, GPIO-n is in tristate mode
>> +- xlnx,is-dual : if 1, controller also uses the second channel
>=20
> If is present, xlnx,is-dual;
>=20
>> +Example:
>> +gpio: gpio@40000000 {
>> +       #gpio-cells =3D <2>;
>> +       compatible =3D "xlnx,xps-gpio-1.00.a";
>> +       gpio-controller ;
>> +       interrupt-parent =3D <&microblaze_0_intc>;
>> +       interrupts =3D < 6 2 >;
>> +       reg =3D < 0x40000000 0x10000 >;
>> +       xlnx,all-inputs =3D <0x0>;
>> +       xlnx,all-inputs-2 =3D <0x0>;
>> +       xlnx,dout-default =3D <0x0>;
>> +       xlnx,dout-default-2 =3D <0x0>;
>> +       xlnx,gpio-width =3D <0x2>;
>> +       xlnx,gpio2-width =3D <0x2>;
>> +       xlnx,interrupt-present =3D <0x1>;
>> +       xlnx,is-dual =3D <0x1>;
>=20
> xlnx,is-dual;
>=20
> I'm not giving up on this suggestion.

I have commented this in the v1. The point is that all dtses for the last=

3-4 years are using this binding and this value is present there for a lo=
ng
time. That's why I think it is better to keep this binding and do not bre=
ak
backward compatibility which there is.
Also it reflects how design tool describe hardware.
IP is designed that can be easily extended to more channels which means
that it won't be simple yes/no option.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2PCWIGJANAVCVGJLACRJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlG+qvUACgkQykllyylKDCHkPACdEcoHTEqhdgwg8mFEdr7Nby4l
rkgAoIbbodkQh1JyFCSsrPo4AkdcnwGE
=yTP5
-----END PGP SIGNATURE-----

------enig2PCWIGJANAVCVGJLACRJP--
