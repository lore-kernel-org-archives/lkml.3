Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3CLD0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:26:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50500 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab3CLDZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:25:59 -0400
Date: Tue, 12 Mar 2013 14:25:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: linux-next: manual merge of the signal tree with Linus' tree
Message-Id: <20130312142557.98fea7e3a6c51922e52f4d3c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_14_25_57_+1100_d7owp_VuiL8ZsqYg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_14_25_57_+1100_d7owp_VuiL8ZsqYg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/tile/kernel/compat.c between commit 87c319a2c3c2 ("tile: properly
use COMPAT_SYSCALL_DEFINEx") from Linus' tree and commit d5dc77bfeeab
("consolidate compat lookup_dcookie()") from the signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/tile/kernel/compat.c
index 6ea4cdb,c262a02..0000000
--- a/arch/tile/kernel/compat.c
+++ b/arch/tile/kernel/compat.c
@@@ -56,15 -54,9 +56,9 @@@ COMPAT_SYSCALL_DEFINE6(pwrite64, unsign
  	return sys_pwrite64(fd, ubuf, count, ((loff_t)high << 32) | low);
  }
 =20
- COMPAT_SYSCALL_DEFINE4(lookup_dcookie, u32, low, u32, high,
-                        char __user *, buf, size_t, len)
- {
- 	return sys_lookup_dcookie(((loff_t)high << 32) | low, buf, len);
- }
-=20
 -long compat_sys_sync_file_range2(int fd, unsigned int flags,
 -				 u32 offset_lo, u32 offset_hi,
 -				 u32 nbytes_lo, u32 nbytes_hi)
 +COMPAT_SYSCALL_DEFINE6(sync_file_range2, int, fd, unsigned int, flags,
 +                       u32, offset_lo, u32, offset_hi,
 +                       u32, nbytes_lo, u32, nbytes_hi)
  {
  	return sys_sync_file_range(fd, ((loff_t)offset_hi << 32) | offset_lo,
  				   ((loff_t)nbytes_hi << 32) | nbytes_lo,

--Signature=_Tue__12_Mar_2013_14_25_57_+1100_d7owp_VuiL8ZsqYg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPqBFAAoJEECxmPOUX5FE20wP+wYbSseh4ePg6f0RIJsuoCkT
xQNtl/rgV28nZyDuOsG4tGkOqDYuJAINydxBvffs2A2jYrPh5I2v5MplEzqWjbau
g1b4xqgIU5mGBZY56Jjw0R2USd9g6rPikM3OnJl+LlkuYwPdKZ+7k9oyM6Isob2J
2JUNu9Yz3vVrn0K/Eeq+bFwoNS54py4R5Yfyx5QSioOZo2+XEm0gMfNKUcK8YiIm
kbZZwIAKoBNIZFnx6vaFVt4GdLc2F7xgJUAXTKNcpVGFei4FknJvrVlHArP1rWRB
rWUQ/LEUZTPCLNaJpk6W9eU4koXXsbrq0cyIzYjJTscsMCGkQENqmoOTtKniSC+/
Ekq9NzEglyBXlWiNrvm1YAEIluRw4+ONGMkLgIAz09Ff81ae1JPurglWKyrGCjmr
pLtEa2nUM98xjT1lvTGzoxnZKaKqi1Ew7VW+dBWEilF8QO2j3kg+oVweSMtuHNzj
576UIAZ4oXk362wVPr+TnnK4s72xzqG6MzWEzAjBeaoYZQnzvZ3sRyTVS85dwgGE
dnQvG13OuAgJgvpAlzDHjixjBdQqqdgPpLwkou2Q+zdAzEnYOFEYvKYqIxwXUgRx
xcsbhXiH6NVuyBS6HaGiYMXW3fRsKZl8ooqRXqB4CCdPtPifRuXXtJqcFpSm3KMj
wunawU7GXqn49brfz455
=uzkn
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_14_25_57_+1100_d7owp_VuiL8ZsqYg--
