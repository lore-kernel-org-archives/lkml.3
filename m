Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab3J1JY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:24:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60022 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab3J1JY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:24:58 -0400
Date: Mon, 28 Oct 2013 20:24:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20131028202442.5033ddf42639863d5f1dcf67@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Oct_2013_20_24_42_+1100_vfWK/gyPhHXn7=c9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Oct_2013_20_24_42_+1100_vfWK/gyPhHXn7=c9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from /scratch/sfr/next/include/linux/mmzone.h:9:0,
                 from /scratch/sfr/next/include/linux/gfp.h:4,
                 from /scratch/sfr/next/include/linux/kmod.h:22,
                 from /scratch/sfr/next/include/linux/module.h:13,
                 from /scratch/sfr/next/block/blk-mq.c:2:
/scratch/sfr/next/block/blk-mq.c: In function 'blk_mq_queue_enter':
/scratch/sfr/next/include/linux/wait.h:772:2: error: expected ';' before '_=
_ret'
  __ret;        \
  ^
/scratch/sfr/next/block/blk-mq.c:108:8: note: in expansion of macro 'wait_e=
vent_interruptible_lock_irq'
  ret =3D wait_event_interruptible_lock_irq(q->mq_freeze_wq,
        ^
/scratch/sfr/next/block/blk-mq.c:108:6: error: void value not ignored as it=
 ought to be
  ret =3D wait_event_interruptible_lock_irq(q->mq_freeze_wq,
      ^

Caused by commit 35a2af94c7ce ("sched/wait: Make the __wait_event*()
interface more friendly").

Since this was also in next-20131025, I applied the following merge fix
commit for today, please fix this in the tip tree.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 28 Oct 2013 20:19:27 +1100
Subject: [PATCH] sched/wait: fix missing semicolon

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/wait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 7f8caa519128..fcc968087f05 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -768,7 +768,7 @@ do {									\
 	int __ret =3D 0;							\
 	if (!(condition))						\
 		__ret =3D __wait_event_interruptible_lock_irq(wq,		\
-						condition, lock,)	\
+						condition, lock,);	\
 	__ret;								\
 })
=20
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__28_Oct_2013_20_24_42_+1100_vfWK/gyPhHXn7=c9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbi1fAAoJEMDTa8Ir7ZwV5KIP/1pIhud1/lJlLmVOe4EgUm5M
/oFPj/w+CGWEmcuq+bMce8KLhEBzxRv7L8vkqUCKP4kdQvWTv5meAUGgsUbmsb5j
5ImFB/rMONRZm66NBAh8wP7x1Q33uxwav5ywAcfFl+QuFXwd3tHZRYzWMdoB1c+h
YVAP6mt3ZaCcUD+hCFTD99ahPzhsHyXlhbffYKkgsgc/14uvCiUz4srZv76G+Ivb
1dEpBjTN4noLm+5VEj5TbTTa7Qdj6TrceAi1RZMQDIcOZJ5o1NR6qrNG7gpFwq8O
gI1pG8+M33Yt1G2DMnrmtFrRMOuDu2hlcxwSwGQnJ1KynHwDbhpME0ei8z0PWdhe
hkrGAi8fcGJvPIWf1oNDcVApR2r+3hzoVuj0+gLmrPZ/7MnM65yUPJqf1nQiMFqw
6HeuUyWLu0oE+fuZp+1xHF2x2FhJcVr09NA89KLOD6z10KmIWIgcgvbm4ySDB7pB
QlOuWKkhGhJht0HWkPHequub6kfk4R8ugtz0N3YmegLvWiDhr0qCfFQO5oZlDR6Q
pvOJOe4TatfTi2seJa++rgqsq58Q2WUgHQaZ1SYmIeVHtf2hFwbfoY2iaWpiXUOO
fO7ZrWUmI8tL3CZ/irKwARsoN18M5zL0RiVKFUv7/WMRlZ/A7HJRdWrxR0ifaAU3
mEVu+u7sMqW+2Nu5jl0p
=LFxX
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Oct_2013_20_24_42_+1100_vfWK/gyPhHXn7=c9--
