Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3KHHsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:48:22 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33899 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3KHHsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:48:19 -0500
Date: Fri, 8 Nov 2013 18:48:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: linux-next: manual merge of the akpm-current tree with the tip tree
Message-Id: <20131108184805.ec16e3b5cc08834cb5d4f812@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_18_48_05_+1100_wYGKx1wocR81itG2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_18_48_05_+1100_wYGKx1wocR81itG2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
kernel/Makefile between commits 60fc28746a7b ("locking: Move the spinlock
code to kernel/locking/") and cd4d241d57c9 ("locking: Move the lglocks
code to kernel/locking/") from the tip tree and commit f5639052d567
("lglock: map to spinlock when !CONFIG_SMP") from the akpm-current tree.

I fixed it up (dropping the kernel/Makefile section of the akpm-current
commit and adding the below patch) and can carry the fix as necessary (no
action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 8 Nov 2013 18:45:25 +1100
Subject: [PATCH] lglock: fixup for code movement

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/locking/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index baab8e5e7f66..bb3c65930a20 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -1,5 +1,5 @@
=20
-obj-y +=3D mutex.o semaphore.o rwsem.o lglock.o
+obj-y +=3D mutex.o semaphore.o rwsem.o
=20
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o =3D -pg
@@ -8,6 +8,7 @@ CFLAGS_REMOVE_mutex-debug.o =3D -pg
 CFLAGS_REMOVE_rtmutex-debug.o =3D -pg
 endif
=20
+obj-$(CONFIG_SMP) +=3D lglock.o
 obj-$(CONFIG_DEBUG_MUTEXES) +=3D mutex-debug.o
 obj-$(CONFIG_LOCKDEP) +=3D lockdep.o
 ifeq ($(CONFIG_PROC_FS),y)
--=20
1.8.4.2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Nov_2013_18_48_05_+1100_wYGKx1wocR81itG2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfJc5AAoJEMDTa8Ir7ZwV28EQAINaB/6OLPu5oZyHEF/X5rsj
pKUbnoTOZC9wrqbmqmkOEYxrBkFSniQQsIibXDIzhAz6gUQDb8sbqsJz26fbZLdz
CAxqkM5BPsSIW0FNnjyKrNFWkPR+MOc1oT7E/pfekzPRWL8/G5o26PnFjVJYHJVp
Md+kQjQi3Qr1G7i41JXEK/GMaGjFW2sIvOlXNyTuhM6ZGsXmw9hJhEurU7Hh6s4s
oHBR3Ie8Rz/zHkwCQRHSfP1LJgRE9w7AeAFfUkkiZRLisY4WZwOJ3RXmH1OawkjF
NKTbgzcuDiTF87I4KAi28GiMjaXffbpholWg0s40IQfLbcpM5T+EboWadnODHX7g
aEktg3rSc2LWgFOQf48tGopOBOTIgMp3KZoGOrKDyGqrf6CcK2LeQaqG611mfJVk
dPC7v2oM9yJn0EKpZBp2yB3DmMgznT1lLrMgAmiVzqs9GkkQO2gIJN/ml482OhfL
nU8Jzp5rL3NZJ1RjMpjBrhi5tmyWf9jZB9OC8oiDm1liG9g1cV0+51IwFxh/LGeq
NGN8psaMFcTnSJ5GIFGMCRwOyDXTIXijOvPpJWprPqYZluC099otbjt1jqU0gs4W
JSHCf5K3KL06CR07ZLl5Lo9gmHRRD3utSIoPmK0T4KksWEOHa/cGohNmWn6qs52I
S6qlBrqdoebo+pc+apPC
=OvT7
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_18_48_05_+1100_wYGKx1wocR81itG2--
