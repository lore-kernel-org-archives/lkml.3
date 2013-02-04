Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab3BDGgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 01:36:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39637 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3BDGgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 01:36:20 -0500
Date: Mon, 4 Feb 2013 17:36:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the signal tree with the mips tree
Message-Id: <20130204173607.d593102dfc20079ec9392fb4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Feb_2013_17_36_07_+1100_uzpZN0N7/q1YPkH7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Feb_2013_17_36_07_+1100_uzpZN0N7/q1YPkH7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/mips/kernel/syscall.c between commit 7034228792cc ("MIPS: Whitespace
cleanup") from the mips tree and commit 50150d2bb903 ("mips: switch to
generic sys_fork() and sys_clone()") from the signal tree.

I fixed it up (the sys_clone stuff was removed by the latter - see below)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/kernel/syscall.c
index d7feee0,b32466a..0000000
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@@ -41,25 -41,19 +41,19 @@@
 =20
  /*
   * For historic reasons the pipe(2) syscall on MIPS has an unusual calling
 - * convention.  It returns results in registers $v0 / $v1 which means the=
re
 + * convention.	It returns results in registers $v0 / $v1 which means there
   * is no need for it to do verify the validity of a userspace pointer
 - * argument.  Historically that used to be expensive in Linux.  These days
 + * argument.  Historically that used to be expensive in Linux.	These days
   * the performance advantage is negligible.
   */
- asmlinkage int sysm_pipe(nabi_no_regargs volatile struct pt_regs regs)
+ asmlinkage int sysm_pipe(void)
  {
  	int fd[2];
- 	int error, res;
-=20
- 	error =3D do_pipe_flags(fd, 0);
- 	if (error) {
- 		res =3D error;
- 		goto out;
- 	}
- 	regs.regs[3] =3D fd[1];
- 	res =3D fd[0];
- out:
- 	return res;
+ 	int error =3D do_pipe_flags(fd, 0);
+ 	if (error)
+ 		return error;
+ 	current_pt_regs()->regs[3] =3D fd[1];
+ 	return fd[0];
  }
 =20
  SYSCALL_DEFINE6(mips_mmap, unsigned long, addr, unsigned long, len,

--Signature=_Mon__4_Feb_2013_17_36_07_+1100_uzpZN0N7/q1YPkH7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRD1bXAAoJEECxmPOUX5FEF2YP/2TLG8LuKDkAEnP9e8s01eXQ
ODsDv5nT3UNbQ4ZljAAqbSDr/VnhVZfurhzvIlZofHATc4q99o9LK9K/M61gktUx
SiPbzTxaV/41InssrsznDJi3YPs5YfOwZnBb9qP7aE2c+JgORgqFHqTBLLpIfjqt
sKsan6/2tefaNxF9zRD1mN7pSWQ6jbAn+7gTR03hPdknCn/T2/cL6byqVH21YYhZ
kAlAGuXPIopZUnl9wgAf5dQZ8hpdpb8kVdrz37l64C02Gb23jV/3v6ftbyBbI7n3
3KvTp7z8qr5K4xFWEjlGtIeB2zCgZKDlqoYyfUlxUGrc28uJ3jAvyMvNSrOOi7iy
hPs+m+MPRdU5c1gYo0jbgGcKG1MN8IkS3/R2DtpHTS07csGKwYGClfp+YhynskV9
ZnOYHT4hk8gh7xICzdCwhG5G1A9u3f7M1MfZWDNOAbFX84CgGvmxYh6i/QKqiiWl
68UGAfs4xDZUg2yyrbKORZXYXtCpCGM7spK2nTKkTiiYXCuWRkSJ7LReejOcnhCy
1NUPgA64mAmCRechUloCDyt+0jiSg6D53A2XsBf29B6fyj+7EzV3+oKcWIwQW8KU
9zkmPiMsPiRfAlbj37+ePrRfQboDkhoAbX1eZ5XzRf0lZotKxALraBR5apx5LxpO
C50tRWTz5Vb0aNHi8F2u
=TTrb
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Feb_2013_17_36_07_+1100_uzpZN0N7/q1YPkH7--
