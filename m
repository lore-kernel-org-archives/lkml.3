Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaDWONI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:13:08 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:41533 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaDWONF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:13:05 -0400
Message-ID: <5357CA6B.1070101@monstr.eu>
Date: Wed, 23 Apr 2014 16:12:59 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Microblaze image hanging in qemu with 3.15-rc
References: <20140422172356.GA15672@roeck-us.net> <53575074.6010602@monstr.eu> <5357C246.7050604@roeck-us.net>
In-Reply-To: <5357C246.7050604@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="88nNrSpXwEX99wHaCaEN0tVujrl6sCcQK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--88nNrSpXwEX99wHaCaEN0tVujrl6sCcQK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/23/2014 03:38 PM, Guenter Roeck wrote:
> On 04/22/2014 10:32 PM, Michal Simek wrote:
>> Hi Guenter,
>>
>>
>> On 04/22/2014 07:23 PM, Guenter Roeck wrote:
>>> Hi all,
>>>
>>> when trying to run a microblaze image with 3.15-rc1 or 3.15-rc2 in qe=
mu,
>>> I get the following hangup. This used to work with earlier kernels
>>> with the same configuration.
>>>
>>> Is this a known problem, or is something wrong with my configuration
>>> or with my qemu command line ?
>>
>> Is this BE/LE version? Which qemu do you use?
>=20
> BE.
>=20
> file vmlinux:
>=20
> vmlinux: ELF 32-bit MSB  executable, version 1 (SYSV), statically linke=
d, BuildID[sha1]=3D5e1872c08df2956eddaed6fc1f6528a8540375b7, not stripped=

>=20
> qemu-system-microblaze --version:
>=20
> QEMU emulator version 1.7.0, Copyright (c) 2003-2008 Fabrice Bellard
>=20
> gcc --version:
>=20
> microblaze-linux-gcc (GCC) 4.8.0
> Copyright (C) 2013 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is=
 NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURP=
OSE.
>=20
>> There is endian autodetection in timer and intc driver
>> which can caused this problem.
>>
> Is this new code ? I didn't see the problem in 3.13 (same compile optio=
ns,
> same configuration, same compiler, same qemu version).

yes it was added to 3.15-rc1.

Try to rever this one
a66a626 microblaze: Use asm-generic/io.h

but the problem is probably here because you are not getting proper
reaction from qemu model.
a1715bb microblaze: Make timer driver endian aware
1aa1243 microblaze: Make intc driver endian aware

I have tested it on the latest petalinux qemu and there shouldn't be
any problem.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--88nNrSpXwEX99wHaCaEN0tVujrl6sCcQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXymwACgkQykllyylKDCFEPwCcCr8Ao0s+klQniTxdgkC0WFBO
71cAnjh9RlO4NwE7eqcZ8VeZEqIK7aGD
=A8nC
-----END PGP SIGNATURE-----

--88nNrSpXwEX99wHaCaEN0tVujrl6sCcQK--
