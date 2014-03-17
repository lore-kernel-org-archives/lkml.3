Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbaCQJbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:31:33 -0400
Received: from ozlabs.org ([203.10.76.45]:54027 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbaCQJbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:31:31 -0400
Date: Mon, 17 Mar 2014 20:31:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: linux-next: manual merge of the akpm-current tree with the tip tree
Message-Id: <20140317203124.3b947e0799cc8142df5e4a2e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_20_31_24_+1100_PZjv5RW0hsqJUKTw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_20_31_24_+1100_PZjv5RW0hsqJUKTw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
kernel/locking/Makefile between commit fb0527bd5ea9 ("locking/mutexes:
Introduce cancelable MCS lock for adaptive spinning") from the  tree and
commit 4dc0fe493027 ("lglock: map to spinlock when !CONFIG_SMP") from the
akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/locking/Makefile
index 306a76b51e0f,727fefd00c71..000000000000
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@@ -1,5 -1,5 +1,5 @@@
 =20
- obj-y +=3D mutex.o semaphore.o rwsem.o lglock.o mcs_spinlock.o
 -obj-y +=3D mutex.o semaphore.o rwsem.o
++obj-y +=3D mutex.o semaphore.o rwsem.o mcs_spinlock.o
 =20
  ifdef CONFIG_FUNCTION_TRACER
  CFLAGS_REMOVE_lockdep.o =3D -pg

--Signature=_Mon__17_Mar_2014_20_31_24_+1100_PZjv5RW0hsqJUKTw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJsDwAAoJEMDTa8Ir7ZwVRDQQAIMLHL8wiSk4n9a8nBf/GjPW
NxnkEC2AdFtH/nzvm77SWa2gybgZTmpDQqLAXEJRzmA1dYLyiufWoiXFpV3wMVMS
VgYGCmca9mYANtDVew43m3/v0FV5uYPQGz3Ba26MSPaG2byZ4feCWjCinjKEmtKV
cr6JYD1lqK0yxniXEywHcJalJ39+3Hr9d8cIQEXvS8YJLos9Us1Si3MfRTd4Wj0z
sE7XPPeI6Tl12eABu86ON125qTgwKrea15XgwBlO0odpjlr+/Mtv3h8PvOjAVe7m
E9AuV3bPm/PQd6LQBTzlgwDa4hbVN/9485mDm62zPho/bHEg1148i9UnO5b39mce
sH2+FBp5/HRm5Kn+UXQUS+imTZMVzUhuAGieosaqiX42M4N8JKPvSa7ipStHauQa
q5xfiPe8RfWd0ny8e6f7oUGvEW9vE0PL0Bfaivi6pE0WQcO4hRfELR5N2uLSl7t/
blhqxrhterBgqPi2hI0ytIBZnGYbdEvXBTzoKQpZb0KYdQxrlRo8Oxo8pQ6sWBlo
rP6isQQuvzdIbDuypUcHVlOQF0KdLNNZl6zD0nv+nEi8x51LU4WUNXnFKRwxinjp
ytvQNNXxaSW+/gEQDqM6kieAeuA/ubISUub4YD1A0OLye2UiB1a77DvhABg64SK8
18o1ivJnKMXkNziWuRcZ
=xCtE
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_20_31_24_+1100_PZjv5RW0hsqJUKTw--
