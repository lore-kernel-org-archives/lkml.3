Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750966AbaJPE5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 00:57:14 -0400
Received: from ozlabs.org ([103.22.144.67]:46632 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaJPE5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 00:57:12 -0400
Date: Thu, 16 Oct 2014 15:56:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20141016155657.1b4ea40d@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/d=WGpqgi.UegLCM+3Z/0gGU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/d=WGpqgi.UegLCM+3Z/0gGU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from mm/memcontrol.c:28:0:
include/linux/page_counter.h: In function 'page_counter_init':
include/linux/page_counter.h:19:27: error: 'LONG_MAX' undeclared (first use=
 in this function)
 #define PAGE_COUNTER_MAX (LONG_MAX / PAGE_SIZE)
                           ^
include/linux/page_counter.h:26:19: note: in expansion of macro 'PAGE_COUNT=
ER_MAX'
  counter->limit =3D PAGE_COUNTER_MAX;
                   ^
include/linux/page_counter.h:19:27: note: each undeclared identifier is rep=
orted only once for each function it appears in
 #define PAGE_COUNTER_MAX (LONG_MAX / PAGE_SIZE)
                           ^
include/linux/page_counter.h:26:19: note: in expansion of macro 'PAGE_COUNT=
ER_MAX'
  counter->limit =3D PAGE_COUNTER_MAX;
                   ^
include/linux/page_counter.h:19:38: error: 'PAGE_SIZE' undeclared (first us=
e in this function)
 #define PAGE_COUNTER_MAX (LONG_MAX / PAGE_SIZE)
                                      ^
include/linux/page_counter.h:26:19: note: in expansion of macro 'PAGE_COUNT=
ER_MAX'
  counter->limit =3D PAGE_COUNTER_MAX;
                   ^
In file included from mm/page_counter.c:7:0:
include/linux/page_counter.h: In function 'page_counter_init':
include/linux/page_counter.h:19:27: error: 'LONG_MAX' undeclared (first use=
 in this function)
 #define PAGE_COUNTER_MAX (LONG_MAX / PAGE_SIZE)
                           ^
include/linux/page_counter.h:26:19: note: in expansion of macro 'PAGE_COUNT=
ER_MAX'
  counter->limit =3D PAGE_COUNTER_MAX;
                   ^
include/linux/page_counter.h:19:27: note: each undeclared identifier is rep=
orted only once for each function it appears in
 #define PAGE_COUNTER_MAX (LONG_MAX / PAGE_SIZE)
                           ^
include/linux/page_counter.h:26:19: note: in expansion of macro 'PAGE_COUNT=
ER_MAX'
  counter->limit =3D PAGE_COUNTER_MAX;
                   ^
include/linux/page_counter.h:19:38: error: 'PAGE_SIZE' undeclared (first us=
e in this function)
 #define PAGE_COUNTER_MAX (LONG_MAX / PAGE_SIZE)
                                      ^
include/linux/page_counter.h:26:19: note: in expansion of macro 'PAGE_COUNT=
ER_MAX'
  counter->limit =3D PAGE_COUNTER_MAX;
                   ^

Caused by commit 36a1bfb2a772 ("mm: memcontrol: lockless page
counters").  See Rule 1 in Documentation/SubmitChecklist.

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 16 Oct 2014 15:49:08 +1100
Subject: [PATCH] mm: memcontrol: add includes for page_counter.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/page_counter.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index a878ef61d073..785640e4efec 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -2,6 +2,9 @@
 #define _LINUX_PAGE_COUNTER_H
=20
 #include <linux/atomic.h>
+#include <linux/kernel.h>
+
+#include <asm/page.h>
=20
 struct page_counter {
 	atomic_long_t count;
--=20
2.1.1


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/d=WGpqgi.UegLCM+3Z/0gGU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUP1AhAAoJEMDTa8Ir7ZwVl3oP/ibT2AWF8hk0fVOW1z7sWpsb
xeHw9+2Oa4480bFL4AFd77W+fjB6QkSbWUnqVjvHjv32IDMh28rKK6OObyBZZHRT
RpTjHhT145IKZQRjLbr4JkDodqJieDQKR13ieqIot8GZ6LCxs/UOWepi0aj8zgdR
aYm/rP6F2fqluIbllJMGZdoAw3rBBliOSSdEZRvINbkv4uVB+q39QkDvoi3bUawR
ROKu1jkis26UehoRocY8TPV/BE2I20klU3WLOa2w4DhAGA3DPuDKfvWGXTus2LDT
LglNH86ij65KZ9M6KWn+bKuaONa3YAB9Z+Nnki6nIktrF5unir8I1eIBe29FpSve
fldLmCMd2MvsxUD9KfAfzK457A0vBkFl/nMCxVSI8aQlYOfTatJF4tuKRwr8ixvd
+jgj6uQYenVdDqyDdnJ3h0M+QqOLnbNGK922h72zGuxHOny0QwVhjzSrGt2Bmr1d
EwzmdIIG1bmch52zeoM0PVUCOlLdSwZWSxmlnTRRDfoilCdcHFh8w/rX8gnqxu76
XJdOnB5YE3hZwUlouVrLxFSfcvGGaBNDND0CQvq9WFHOiieIRG58BDr4GrGIjzv/
7MA7slLzJgni5RRzO/mwRCiWjJ22qMXg90ePopZOHvns663kY1f1entkRsy7+eN4
EAKEbqZ9fC9hj/+D2mnS
=Jz03
-----END PGP SIGNATURE-----

--Sig_/d=WGpqgi.UegLCM+3Z/0gGU--
