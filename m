Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab3KMNkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:40:46 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:48404 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab3KMNkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:40:43 -0500
Message-ID: <5283814C.6040904@monstr.eu>
Date: Wed, 13 Nov 2013 14:40:28 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        microblaze-uclinux@itee.uq.edu.au, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 15/17] microblaze: Convert from _fdt_start to __dtb_start
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-16-git-send-email-geert@linux-m68k.org> <5283524F.8030902@monstr.eu>
In-Reply-To: <5283524F.8030902@monstr.eu>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4IiqVjTX2HIoOtKcUO1NaDwNEIuJkA7CP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4IiqVjTX2HIoOtKcUO1NaDwNEIuJkA7CP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/13/2013 11:19 AM, Michal Simek wrote:
> On 11/12/2013 08:42 PM, Geert Uytterhoeven wrote:
>> Kill the microblaze-specific __fdt_blob section, and start using
>> .dtb.init.rodata from <asm-generic/sections.h> for built-in DTBs, like=

>> most other DT enabled architectures.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Cc: Michal Simek <monstr@monstr.eu>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: microblaze-uclinux@itee.uq.edu.au
>> Cc: devicetree@vger.kernel.org
>> ---
>> Untested, but the resulting vmlinux after "make simpleImage.system" lo=
oks
>> sane.
>>
>> QUESTION: The padding of the DTB is gone, is this OK?
>=20
> Removing this kernel padding should be fine. I can't remember
> why it was there from the beginning.

I know why is this here. The reason is process how dtb is passed
to the kernel via command line. head.S code just copy that dtb to
the same location where compiled-in dts is expected and kernel
doesn't need to care about position of dtb because this copy is
done without MMU. And the full kernel is covered by 2 tlbs and
we don't need to use another TLB for dtb mapping.

It means pad matters a lot. Because u-boot ITS format doesn't use
simpleImage target but the kernel need to have a space for copying
dtb to this kernel location.

Let me think about if there is an easy way to handle dtbs
which are passed from bootloader.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--4IiqVjTX2HIoOtKcUO1NaDwNEIuJkA7CP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKDgU0ACgkQykllyylKDCFfmQCgmiporcUeFQV4wtSrDYnXPPJv
mUEAnjIcvATuJeWyBzrT/IIH/3dLq4iw
=QGBC
-----END PGP SIGNATURE-----

--4IiqVjTX2HIoOtKcUO1NaDwNEIuJkA7CP--
