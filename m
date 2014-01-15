Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856AbaAOFAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:00:43 -0500
Received: from ozlabs.org ([203.10.76.45]:45567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbaAOFAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:00:40 -0500
Date: Wed, 15 Jan 2014 16:00:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>
Subject: linux-next: manual merge of the tip tree with the mips tree
Message-Id: <20140115160032.96b4d84d063ab108ae3cdb35@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_Jan_2014_16_00_32_+1100_GqHf/5IIuKgra868"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jan_2014_16_00_32_+1100_GqHf/5IIuKgra868
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/mips/Kconfig between commit 597ce1723e0f ("MIPS: Support for 64-bit
FP with O32 binaries") from the mips tree and commit 19952a92037e
("stackprotector: Unify the HAVE_CC_STACKPROTECTOR logic between
architectures") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/Kconfig
index 87dc0c3fe05f,c93d92beb3d6..000000000000
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@@ -2354,36 -2323,6 +2355,23 @@@ config SECCOM
 =20
  	  If unsure, say Y. Only embedded should say N here.
 =20
- config CC_STACKPROTECTOR
- 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
- 	help
- 	  This option turns on the -fstack-protector GCC feature. This
- 	  feature puts, at the beginning of functions, a canary value on
- 	  the stack just before the return address, and validates
- 	  the value just before actually returning.  Stack based buffer
- 	  overflows (that need to overwrite this return address) now also
- 	  overwrite the canary, which gets detected and the attack is then
- 	  neutralized via a kernel panic.
-=20
- 	  This feature requires gcc version 4.2 or above.
-=20
 +config MIPS_O32_FP64_SUPPORT
 +	bool "Support for O32 binaries using 64-bit FP"
 +	depends on 32BIT || MIPS32_O32
 +	default y
 +	help
 +	  When this is enabled, the kernel will support use of 64-bit floating
 +	  point registers with binaries using the O32 ABI along with the
 +	  EF_MIPS_FP64 ELF header flag (typically built with -mfp64). On
 +	  32-bit MIPS systems this support is at the cost of increasing the
 +	  size and complexity of the compiled FPU emulator. Thus if you are
 +	  running a MIPS32 system and know that none of your userland binaries
 +	  will require 64-bit floating point, you may wish to reduce the size
 +	  of your kernel & potentially improve FP emulation performance by
 +	  saying N here.
 +
 +	  If unsure, say Y.
 +
  config USE_OF
  	bool
  	select OF

--Signature=_Wed__15_Jan_2014_16_00_32_+1100_GqHf/5IIuKgra868
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1hX0AAoJEMDTa8Ir7ZwVpFgP/3hYeH0qXGnX/Ac3L3jtAhSf
4VO1ntxUCvFSoC0BBceDvmImeIkADA2RpSA+GRIw1OLKBLX70SdEI34HVQBXDVG/
Rskth9SgnGBg8IiA4W6HeNFx5bj7rNhdfCnQuP9XwlQLC3xfv1YGkdYoUa98oUCC
+Jp+kcT0TehzoRf7/N7+lsBE582xwp6I7Bb5qiktlLe3k9qLrXDIVkStgnIvp4ah
jbZe4zzeoyCEpMBzoCOs4b4kJmeXuQtJsJ3bPprFJAa/2r9Q/tWc4sxPo6z4Fw64
c/4gukclbaLadccT+2DJA4ssJpfJWJ3NRzds+WlO2VLwmkcvMLbFSBZnv8rGUhGn
C97kzBWJTqKPX85oTH7S/KIr7K1iiFF27KzZMsI6LXZe90JY5OJLQ5o53tUtv34A
gRYOIWixyOcRsgI4fTaKBolgIY0bPiHUbsAFtnFACTSMVY+UlhitLUVgtUE+PNEu
7CM10qeC3VmUdbdtG0f3tNluojcPcYR8AhawipXHKkioakzqbZAwxQd0p4QJCaR1
KN+LpnLgHaYTP+Zjxm0h4YjxWnJ1Sv+SrR+ffJgUgNgwyP5cNIxgxJiPOFraAUEK
+Q7aTJk4UfDLVtIwijUCrTQBz5gtKVGktJPOddrTd6locRdW9Xgae/E5w57ZWBcZ
AGUm4A5G5Wo7cRS8qA2C
=Dkrm
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jan_2014_16_00_32_+1100_GqHf/5IIuKgra868--
