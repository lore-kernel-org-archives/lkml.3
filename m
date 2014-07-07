Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaGGB3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 21:29:03 -0400
Received: from ozlabs.org ([103.22.144.67]:40660 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbaGGB3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 21:29:00 -0400
Date: Mon, 7 Jul 2014 11:28:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: linux-next: manual merge of the mvebu tree with the arm tree
Message-ID: <20140707112853.7f5a9323@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/YglyQG_rdpx5i/S736bT0BN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YglyQG_rdpx5i/S736bT0BN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
arch/arm/mach-mvebu/headsmp-a9.S between commit 8a3a9dd50dd9 ("ARM:
convert all "mov.* pc, reg" to "bx reg" for ARMv6+") from the arm tree
and commit 0e2be4c1121a ("ARM: mvebu: fix SMP boot for Armada 38x and
Armada 375 Z1 in big endian") from the mvebu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mvebu/headsmp-a9.S
index 7c91ddb6f1f7,da5bb292b91c..000000000000
--- a/arch/arm/mach-mvebu/headsmp-a9.S
+++ b/arch/arm/mach-mvebu/headsmp-a9.S
@@@ -14,8 -14,9 +14,10 @@@
 =20
  #include <linux/linkage.h>
  #include <linux/init.h>
 +#include <asm/assembler.h>
 =20
+ #include <asm/assembler.h>
+=20
  	__CPUINIT
  #define CPU_RESUME_ADDR_REG 0xf10182d4
 =20
@@@ -23,9 -24,13 +25,13 @@@
  .global armada_375_smp_cpu1_enable_code_end
 =20
  armada_375_smp_cpu1_enable_code_start:
- 	ldr     r0, [pc, #4]
+ ARM_BE8(setend	be)
+ 	adr     r0, 1f
+ 	ldr	r0, [r0]
  	ldr     r1, [r0]
+ ARM_BE8(rev	r1, r1)
 -	mov     pc, r1
 +	ret     r1
+ 1:
  	.word   CPU_RESUME_ADDR_REG
  armada_375_smp_cpu1_enable_code_end:
 =20

--Sig_/YglyQG_rdpx5i/S736bT0BN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTuffZAAoJEMDTa8Ir7ZwVOOUQAIDu8vBNmNqB1oDrjKnGutS0
ffZbYLXpAC5Z/JuxsbuvX1U7XcKZrK26ycZLRYbbzq+GlEfYjL5n1NPfs/gQMKQE
my/GcFSkeNRSJDTvkb525kqzSC6CTYZ6sFqY3dLn2avHFpJ/yGm9spqNaDjAnK4S
9NRwOjNCm2afkMByIuo6lW+VNGqcyaIyqaEFtlh/5KhN4S7aAHqPPOSokDQsdhZb
FoxRgXGWTPYgBfQpdL8xUiJ9uYk5zB3TQPam1nyUBgSWJsWUAzF/+BiIM6reQeNY
OaI1+wX5i/BOCqJIgWJh8buRegiGYKyjdTLZ2R+eHghgkdjFINeBq4hOGSXdr9U0
QdvdJbjGJ8rWJ95XShQaIDBNTcSYkFFjvg0ksISQWtGpx6t3pnM6Bo0hDCXLiqTt
E6AP02v7S+3DM1LgCXFLpA6DN+szLlj/DFaoPsPZg4K8nE7h04KLJ2SMAo4vYzAt
UvPIvlvdlTxDTmc0Zq0vmyGvm1l4CHYyHfqfQ6itk2OLgIv71BYzEahYGQvuWbA0
qQtNBqiHRjo+daKd8+6jR0VJ5YVPqxuN81NHd1nh/avPFq8IoK9bE2Xri0CTjfRX
5AkxLyVWNzVdpCeQ6xUsb4U/MaNUHc/ZdtPhLeoSFnzO0onNmif5+v3ARjw79uNI
zla3y+0CH335npTKcXXb
=MzWO
-----END PGP SIGNATURE-----

--Sig_/YglyQG_rdpx5i/S736bT0BN--
