Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3CNG1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 02:27:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60487 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3CNG1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 02:27:49 -0400
Date: Thu, 14 Mar 2013 17:27:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the signal tree with the modules tree
Message-Id: <20130314172737.2856af8a9b368bc395d977be@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__14_Mar_2013_17_27_37_+1100_fkMoaHdxBLqLloNv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Mar_2013_17_27_37_+1100_fkMoaHdxBLqLloNv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
include/asm-generic/unistd.h between commit 837718bfd28b
("CONFIG_SYMBOL_PREFIX: cleanup") from the modules tree and commit
e1b5bb6d1236 ("consolidate cond_syscall and SYSCALL_ALIAS declarations")
from the signal tree.

The latter moved the cond_syscall stuff to linkage.h, so I applied the
following patch as a merge fixup and can carry the fix as necessary (no
action is required).  I am not sure if this is completely correct or all
that is needed.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 14 Mar 2013 17:14:41 +1100
Subject: [PATCH] cond_syscall and SYSCALL_ALIAS merge fixup

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/linkage.h | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 829d66c..bedcddf 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -2,7 +2,7 @@
 #define _LINUX_LINKAGE_H
=20
 #include <linux/compiler.h>
-#include <linux/stringify.h>
+#include <linux/export.h>
 #include <asm/linkage.h>
=20
 #ifdef __cplusplus
@@ -15,24 +15,16 @@
 #define asmlinkage CPP_ASMLINKAGE
 #endif
=20
-#ifndef SYMBOL_NAME
-#ifdef CONFIG_SYMBOL_PREFIX
-#define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
-#else
-#define SYMBOL_NAME(x) x
-#endif
-#endif
-#define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))
-
 #ifndef cond_syscall
-#define cond_syscall(x) asm(".weak\t" __SYMBOL_NAME(x) \
-	"\n\t.set\t" __SYMBOL_NAME(x) "," __SYMBOL_NAME(sys_ni_syscall));
+#define cond_syscall(x) asm(".weak\t" VMLINUX_SYMBOL_STR(x) "\n\t"	\
+			    ".set\t" VMLINUX_SYMBOL_STR(x) ","	\
+			    VMLINUX_SYMBOL_STR(sys_ni_syscall))
 #endif
=20
 #ifndef SYSCALL_ALIAS
 #define SYSCALL_ALIAS(alias, name)				\
-	asm ("\t.globl " __SYMBOL_NAME(alias)			\
-	"\n\t.set\t" __SYMBOL_NAME(alias) "," __SYMBOL_NAME(name))
+	asm ("\t.globl " VMLINUX_SYMBOL_STR(alias)			\
+	"\n\t.set\t" VMLINUX_SYMBOL_STR(alias) "," VMLINUX_SYMBOL_STR(name))
 #endif
=20
 #define __page_aligned_data	__section(.data..page_aligned) __aligned(PAGE_=
SIZE)
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__14_Mar_2013_17_27_37_+1100_fkMoaHdxBLqLloNv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQW3ZAAoJEECxmPOUX5FEsJQQAJd4C7iRw0zbxBLz2lINql8s
PEg2jIXOk7f7oFjUnbDNGetPv+NKZDyv+Ou9RjlyM3Zac0bLCPIcZsCRQOy33Rnx
1W79kEbhAXnkw9nLChOB7TVLMkr3h6gEOSpWfTU9JHkvxx+PoP8FBHJ7yq64ffa7
peOa9+1nKbHgz0JgPe+V0G+4kwF3n4EOQf0+e9s8ftmH6kl99jsvz/lyEW2cEN9U
vi0KbzPXXPokPaW3Y8WrBLDLREKJ/oN9TyYyta4tJw0uDv98bhRIXdMiIVUGN3n+
9XHxRKkQYtlrLrIkc6sbg3IZX/EYZEsjmCX+ZNiskrlDsEhG2/fIUOBI9vUmvHpH
q8EnHz5g/+dh0FVsTzPZ0CBR7TA7xX6T4OC/6IRTSCIEYD8PKq8L3WwS7b594e6n
8vpxLYWrt4LrhWcaW4fsWWSQy/kyGk/190HYG/GNHN4J6m/0Yt187/CsefBjKx7x
DANudg/jLlk2ZwEWB1oNlJluDGFJlAtqDQ59/NUySbfLRSEfF4hij2wUSa00fCow
DQ8dgndKh3EtIJqnY2lwxsX/r42z+qNZVzPCH6AnCuzzxq6pgqjkOZGpzbB1lfpG
vbDaUVd7L8q6ut8oERLpRFmTy/8bWGjU7ygcPlMR3GSx0s1wWeQv5P1lCscFWUq3
Ky0oe+k3XzAKC1gERzbI
=S4y5
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Mar_2013_17_27_37_+1100_fkMoaHdxBLqLloNv--
