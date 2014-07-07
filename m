Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaGGBcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 21:32:52 -0400
Received: from ozlabs.org ([103.22.144.67]:53511 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbaGGBcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 21:32:50 -0400
Date: Mon, 7 Jul 2014 11:32:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>, Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm+renesas@opensource.se>
Subject: linux-next: manual merge of the renesas tree with the arm tree
Message-ID: <20140707113243.3c3dfdfe@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5b2.vCKWrB9W+XfzQ1oy_b."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5b2.vCKWrB9W+XfzQ1oy_b.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
arch/arm/mach-shmobile/headsmp.S between commit 8a3a9dd50dd9 ("ARM:
convert all "mov.* pc, reg" to "bx reg" for ARMv6+") from the arm tree
and commit 8b438bcb9009 ("ARM: shmobile: Allow use of boot code for
non-SMP case") from the renesas tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/headsmp.S
index 293007579b8e,faf82144a262..000000000000
--- a/arch/arm/mach-shmobile/headsmp.S
+++ b/arch/arm/mach-shmobile/headsmp.S
@@@ -10,11 -10,12 +10,13 @@@
   * it under the terms of the GNU General Public License version 2 as
   * published by the Free Software Foundation.
   */
- #include <linux/linkage.h>
  #include <linux/init.h>
+ #include <linux/linkage.h>
+ #include <linux/threads.h>
 +#include <asm/assembler.h>
  #include <asm/memory.h>
 =20
+ #ifdef CONFIG_SMP
  ENTRY(shmobile_invalidate_start)
  	bl	v7_invalidate_l1
  	b	secondary_startup

--Sig_/5b2.vCKWrB9W+XfzQ1oy_b.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTufi/AAoJEMDTa8Ir7ZwVBNEP/1e1gpnqm5PJrShkLw/ND7ED
N/Xxnf3zLuLyUHsNmoa0icDes52YlyX8huGpKXbazUQjILBjB4DIE9RCCApVUeAy
Ii6S6cBYxeCE1J4Pgrf4C8NvDhzDmz/LmjGbvqdGLY1q4EXYldwlOAfhIk/zJwnr
S5aFiLH4nV+V/gfmcqIFJ7OG73yp2QjAtdfd8LFnc3DlsMWucsLk+pzk/y8gIfkh
XgbTt0IMzQsd3JgpeDHId11vlpb1Ywm2LIY7tkrO8MbcZDAkSGvC2MsNooI1i5cn
Shx81OPjKk+DSh021Ov9mrjhTQu+VDiKoVhGy2xdNc5XS9MPk9rZyDYCtWEIm/hK
+RHoA+xiH8v1xHt3aswMnDgYansfgx1TsWAiG5Bc3dzb4D/KIRaXnmkjJAr/ucpR
l1vvBkELW9pNgzBEds1gEQ+M7WgoK0GVQEs6WFHn0GSzqBUJsm7SPHmig/mTGvrk
vp31D5/9zmkfh2a7ylz1ap6qJ0YdpSOWRrR3vSW2BULUdmO0Y0co1MzOcytYizvg
TdoXJt1b6Ng3OoBe1TApuEBZ0C90A/fLNxKzBid/0EyHmsVCMb+oYYk7IjTcJu/e
PIVD0n8lgndXpQU1REMnOkGsEtsVErp0biPIPt4zQnVYR+Vf6hJRv1hlpmakNA9v
NwDGioGr1WHVMtTffDKD
=yRWt
-----END PGP SIGNATURE-----

--Sig_/5b2.vCKWrB9W+XfzQ1oy_b.--
