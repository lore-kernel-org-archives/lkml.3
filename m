Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaJGFql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:46:41 -0400
Received: from ozlabs.org ([103.22.144.67]:55879 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbaJGFqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:46:38 -0400
Date: Tue, 7 Oct 2014 16:46:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the percpu tree with the s390 tree
Message-ID: <20141007164629.38d68eff@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/yrw6Ds2DSR5SE_2lyQWmxG4"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/yrw6Ds2DSR5SE_2lyQWmxG4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
arch/s390/kernel/vtime.c between commit 4dc0f1e9c0a9 ("s390/idle:
consolidate idle functions and definitions") from the s390 tree and
commit eb7e7d766326 ("s390: Replace __get_cpu_var uses") from the
percpu tree.

I fixed it up (the former moved the code modified by the latter into a
new file, so I just removed the code and added the patch below) and can
carry the fix as necessary (no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 7 Oct 2014 16:44:38 +1100
Subject: [PATCH] s390: fixup for Replace __get_cpu_var uses

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/s390/kernel/idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/idle.c b/arch/s390/kernel/idle.c
index c75fbae1e37e..9d19a91dc6a6 100644
--- a/arch/s390/kernel/idle.c
+++ b/arch/s390/kernel/idle.c
@@ -20,7 +20,7 @@ static DEFINE_PER_CPU(struct s390_idle_data, s390_idle);
=20
 void __kprobes enabled_wait(void)
 {
-	struct s390_idle_data *idle =3D &__get_cpu_var(s390_idle);
+	struct s390_idle_data *idle =3D this_cpu_ptr(&s390_idle);
 	unsigned long long idle_time;
 	unsigned long psw_mask;
=20
--=20
2.1.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/yrw6Ds2DSR5SE_2lyQWmxG4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUM346AAoJEMDTa8Ir7ZwV6IEP/2RXzm44HJyNdwYdNXKM7g4g
esAM6UoezO9xLGGf3Gy7oeiCJn3po0S0D1ULoo+1+ipa20MldVKBkQBQBQoQpjfQ
3XNV/nqwZ5877hX3ZxUA+p3ROvXrzYWx+ilC2xIh0P4U3B7aHvqMGWqNhfJKPO5Y
iNtbu0uXg7ayqFoAWH24GaKirhKYqlHGP0xucop/dLTWcFLSKz6M8A902It0iaF5
SW3QrEgEBXEO4SO9lG5xCn5nW+R4xtKLuY+/66GaWFNGhLuIgveKfpvlA4BKQUXV
/y6vO/tm2IoFNZ9l3X5koefg7upt7XPXCHJdbWSn/LevnbNXkJo5KBeEf+A7JUPW
0P0/GK4fgagXZQS3bzwnF3mKlR2eJTBxAc0G2CLe2s8CXusDQA9GFetjD2c1qumk
GrIL1ipDZjRa+jE9fQLbnN49pHvPf5tAw6yWMl+DVzI9djxcyW2PA0/BrHzSdn3r
b/2/y3V4oZX4R/FvctR3LkOJ2cPGRfXwGR++4PVBWcUHzm/YWBfxyUBew0Pvkx55
tqKPyedTjpVjSuaXnPYPS9tyeLKd4cNEOXH0UVJlwplOW4Vfe9GIE5jJtp59V5Qq
/RbQZnufkKotOvNE2dGIvFc/TamrINarTTq4+WMhV1dQ/4aVMKqYkEnoVkgWtmIb
gb6K1bFivOIe/BnLjDtG
=CAo0
-----END PGP SIGNATURE-----

--Sig_/yrw6Ds2DSR5SE_2lyQWmxG4--
