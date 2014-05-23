Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaEWHOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:14:25 -0400
Received: from ozlabs.org ([103.22.144.67]:35271 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbaEWHOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:14:23 -0400
Date: Fri, 23 May 2014 17:14:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the tip tree
Message-ID: <20140523171412.125adaa6@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/iP4qN7/ye5fu4ZKUxRFHMdk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iP4qN7/ye5fu4ZKUxRFHMdk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

In file included from arch/arm/include/asm/outercache.h:24:0,
                 from arch/arm/include/asm/barrier.h:5,
                 from arch/arm/include/asm/bitops.h:28,
                 from include/linux/bitops.h:33,
                 from include/linux/kernel.h:10,
                 from include/asm-generic/bug.h:13,
                 from arch/arm/include/asm/bug.h:61,
                 from arch/arm/include/asm/div64.h:63,
                 from include/linux/math64.h:5,
                 from include/linux/jiffies.h:4,
                 from init/calibrate.c:7:
include/linux/bug.h:91:47: warning: 'struct bug_entry' declared inside para=
meter list [enabled by default]
include/linux/bug.h:91:47: warning: its scope is only this definition or de=
claration, which is probably not what you want [enabled by default]
include/linux/bug.h: In function 'is_warning_bug':
include/linux/bug.h:93:12: error: dereferencing pointer to incomplete type

 ... and many, many more ...

Probably caused by commit 030d0178bdbd ("arch,arm: Convert
smp_mb__*()") which added an include of asm/barrier.h to
arch/arm/include/asm/bitops.h.  This has interacted with commit
59a3bc6d3343 ("ARM: outer cache: add WARN_ON() to outer_disable()")
from the arm tree, which adds an include of linux/bug.h to
arch/arm/include/asm/outercache.h.

I added the below merge fix patch.  Russell, this should be applied to
your tree directly.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 23 May 2014 17:10:12 +1000
Subject: [PATCH] ARM: outer cache: no need for bug.h in outercache.h

This fixes a cricular include dependency when combined with commits from
the tip tree.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/include/asm/outercache.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outer=
cache.h
index eaa8a28c6871..891a56b35bcf 100644
--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -21,7 +21,6 @@
 #ifndef __ASM_OUTERCACHE_H
 #define __ASM_OUTERCACHE_H
=20
-#include <linux/bug.h>
 #include <linux/types.h>
=20
 struct outer_cache_fns {
--=20
2.0.0.rc4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/iP4qN7/ye5fu4ZKUxRFHMdk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfvVNAAoJEMDTa8Ir7ZwVLlYP/jxHoUQMc8WqenfuYvJt4Mwn
lagkZ1lhFSAMI77TpiBILsj+srJZnTBAvtcdRA/WdS20AboM3sD6x+2B84o8PgOX
vbjx7aSsESqKkhYIKqom6A8JmjXaIAzazvhsvCZUOxhLmAA5S7thkN9Ijjje19yR
8wzyEWcZORn8PYtBN41iweQPUg5IjfkZMiMuieQSKeJOfqNz0IoEtB7+7w7T+Uqe
g9Iso7JU16WQqlObfg6nLiUDN76VeYq8YjxQHkJxwLYf4iwFGwoWzxXgEFIGH45t
JsBg1VXvp4q6GR4M0Y7ZHif3DgBg6LQMFlLHoyeUdUHNn53/Ig2exl0eCHoP7W4s
2Qp/i/qJyNWsEw12eq/QmBDbCWY0wv+htaxPavuFd3D/mqT7qIY1RLhq4uWD7NdX
IRwCyKjFzsOws8QS7gLP55kUTsb2x9uE9/IH2JTPqhhKeKMAO3cFYEeUhjrzZMeG
3+I8WSKUXa8anipm+VN5YyxGKMcN2B95zkYx86BBcI4SFdHpR6Eu/yeRWDO2qGYr
EixYUy/cyowm5Q3FjupB2yzWjUsaJEuDXafBmnJNN59NOt9+6PCNpenw7hccRO1d
HfG9OTfwHKFM2avo7GTuj8Oc/treG6j7gXM7Z0EeUUyJ9fE6W7qxkSod4X3Kv+ab
UNWHgvGbNNVLyp80JeGi
=XDpg
-----END PGP SIGNATURE-----

--Sig_/iP4qN7/ye5fu4ZKUxRFHMdk--
