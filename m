Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbaGRHoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:44:25 -0400
Received: from ozlabs.org ([103.22.144.67]:45828 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaGRHoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:44:23 -0400
Date: Fri, 18 Jul 2014 17:44:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: linux-next: manual merge of the akpm-current tree with the random
 tree
Message-ID: <20140718174416.56c61be2@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TyO0asr3SGm3eMV_ld5eL=t"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TyO0asr3SGm3eMV_ld5eL=t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/x86/syscalls/syscall_64.tbl between commit 69d7b7939c24 ("random:
introduce getrandom(2) system call") from the random tree and commit
f5e74a5d7743 ("kexec: new syscall kexec_file_load() declaration") from
the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/syscalls/syscall_64.tbl
index 6705032c0520,6d3545914821..000000000000
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@@ -323,7 -323,7 +323,8 @@@
  314	common	sched_setattr		sys_sched_setattr
  315	common	sched_getattr		sys_sched_getattr
  316	common	renameat2		sys_renameat2
 -317	common	kexec_file_load		sys_kexec_file_load
 +317	common	getrandom		sys_getrandom
++318	common	kexec_file_load		sys_kexec_file_load
 =20
  #
  # x32-specific system call numbers start at 512 to avoid cache impact

--Sig_/TyO0asr3SGm3eMV_ld5eL=t
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTyNBVAAoJEMDTa8Ir7ZwVB7MP/0P9qAUpxk2UYENQkF+pRxQi
sBU4N9mcnG4J9r3yDA4Jh9mfI545wYjtlvKsV+JzUlQ8p0nI6LCptrxMiNVOknTt
HAlYbdA3BCYEdUQF/hTFakFXc6Nsj1R+HQN2cGZtR9ngHpb+M9zjgFZf9MCr+GI6
c8xQhRZQXFUxYLMl8lpqpTocSMgxAu5oOHjrCsemrWz29K9g/CqoGL7QAFXIe3y3
zU66Zo2P9UazT2CdVgURaRYe/w5ZdqO7t433LS9yuln29rqmsy50lkj4dFErdXAh
3q30CLD7ioIuhUphcoNjZ1/kTefX2aIO84hHmVi+fPN82CtzwI/ncIGgu8ucOCFA
2gGAbobN3I5KcpY45q+Mo9zc6U0hL483gqckrPf/Tp6D8IeSnjs9RaCjVOCciF2d
AOb19RVavw3ISRnKux1fdRaeHcjhrSoHwTCTs1rAmVFrzdAgQq1WJhW1NvnOx/kX
9ZUQNe2dBYRKvUJXXaZEcDxiXlk8kms5qsoaAcquRwegH46vIB5BOqMSqYF9aBqT
6Kj5kQrHZP42gJRSQ7gNYxg1nCkWc9wEZAoiJcUeZweAEkdRaBKyuamDfk1pk9Ki
X0bWPoAXivzykTycPSPgTwr1lLqRjtdgQ9Umabg/DoJQo1TtMlq9thas/lLL15dq
6Twrg4j1AA3g/vyyFkaE
=Cgff
-----END PGP SIGNATURE-----

--Sig_/TyO0asr3SGm3eMV_ld5eL=t--
