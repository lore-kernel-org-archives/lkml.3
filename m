Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaBJLy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:54:57 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:46345 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBJLyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:54:55 -0500
Message-ID: <52F8BE06.9040103@monstr.eu>
Date: Mon, 10 Feb 2014 12:54:46 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] regmap: Check readable regs in _regmap_read
References: <73e82a7cf77a1a68c5303def3071418b7d0ea382.1392029156.git.michal.simek@xilinx.com> <52F8AFB2.4000307@metafoo.de> <20140210114927.GR1757@sirena.org.uk>
In-Reply-To: <20140210114927.GR1757@sirena.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="vvRM33DBDr10cU4OCj8BN4sNnIUN9NujP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vvRM33DBDr10cU4OCj8BN4sNnIUN9NujP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On 02/10/2014 12:49 PM, Mark Brown wrote:
> On Mon, Feb 10, 2014 at 11:53:38AM +0100, Lars-Peter Clausen wrote:
>> On 02/10/2014 11:46 AM, Michal Simek wrote:
>>> Check if regs are readable.
>=20
>>> +	if (!regmap_readable(map, reg))
>>> +		return -EIO;
>=20
>> This will cause issues with devices where registers are writable,
>> but not readable, but we keep the register value in the cache.
>=20
> Yes, exactly - this is deliberately not done so we can fake up
> readability using the cache.  All the 7x9 devices are like this for
> example, there's just no read support in the hardware (or if there is
> it's not related to the register map).  If we were going to check it
> should be at the point where we are about to interact with the hardware=
=2E

ok. Then let me send v2 and more this checking below cache
because missing this checking is also wrong.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--vvRM33DBDr10cU4OCj8BN4sNnIUN9NujP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlL4vgYACgkQykllyylKDCHp5ACfcHHgcGmFPprF64Tc5VJO0qyj
O6wAn1BG9H7L2tM7CLHcaCoS7Evol7Ji
=+pJy
-----END PGP SIGNATURE-----

--vvRM33DBDr10cU4OCj8BN4sNnIUN9NujP--
