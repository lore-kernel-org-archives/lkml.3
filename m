Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab3HNHxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:53:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36176 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab3HNHxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:53:53 -0400
Date: Wed, 14 Aug 2013 17:53:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (slab tree
 related)
Message-Id: <20130814175342.111954e36f405607af3e8eec@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Aug_2013_17_53_42_+1000_M2OzE3okoiuXlw1G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Aug_2013_17_53_42_+1000_M2OzE3okoiuXlw1G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

In file included from include/linux/xattr.h:14:0,
                 from include/linux/cgroup.h:21,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from arch/powerpc/kernel/asm-offsets.c:24:
include/linux/slab.h:587:21: error: redefinition of 'kmalloc_node'
 static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
                     ^
include/linux/slab.h:429:30: note: previous definition of 'kmalloc_node' wa=
s here
 static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int no=
de)
                              ^
include/linux/slab.h:592:21: error: redefinition of '__kmalloc_node'
 static inline void *__kmalloc_node(size_t size, gfp_t flags, int node)
                     ^
In file included from include/linux/xattr.h:14:0,
                 from include/linux/cgroup.h:21,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from arch/powerpc/kernel/asm-offsets.c:24:
include/linux/slab.h:302:30: note: previous definition of '__kmalloc_node' =
was here
 static __always_inline void *__kmalloc_node(size_t size, gfp_t flags, int =
node)
                              ^
In file included from include/linux/xattr.h:14:0,
                 from include/linux/cgroup.h:21,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from arch/powerpc/kernel/asm-offsets.c:24:
include/linux/slab.h:599:21: error: redefinition of 'kmem_cache_alloc_node'
 static inline void *kmem_cache_alloc_node(struct kmem_cache *cachep,
                     ^
In file included from include/linux/xattr.h:14:0,
                 from include/linux/cgroup.h:21,
                 from include/linux/memcontrol.h:22,
                 from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from arch/powerpc/kernel/asm-offsets.c:24:
include/linux/slab.h:307:30: note: previous definition of 'kmem_cache_alloc=
_node' was here
 static __always_inline void *kmem_cache_alloc_node(struct kmem_cache *s, g=
fp_t flags, int node)
                              ^

Probably caused by commit 1a1d0328975f ("mm/sl[aou]b: Move kmalloc_node
functions to common code") from the slab tree.

This build has CONFIG_NUMA and CONFIG_SLOB undefined.

I have reverted that commit and commits eab6f38ab23c ("mm/sl[aou]b: Move
kmalloc definitions to slab.h"), c8f12ea82f92 ("sl[aou]b: Remove
unnecessary #includes") and 8876832d0466 ("slub: remove
verify_mem_not_deleted()") that followed it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Aug_2013_17_53_42_+1000_M2OzE3okoiuXlw1G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCzeLAAoJEECxmPOUX5FEWXkP/RWoY8djJ2YUiTZBdsWWasGH
szlZNQnrWhy75IVVvJA58MUtugvxSzAMy109+UZKonUAgDXY1Z5nG4oqN+VBT2XD
FE1rDIEa0gkGVqO/hLjXpfKow+Qtqn8fy8YZuAHVqeabplnUMUjR4YJEMwdvYWxK
qBoxhZVdCPHaLiypRSJETXtR5Ud2IK7+ivVWIlHdwsCVGOlRH4F2SRQ0cw6EwCTf
64BG4X/XgrmdUI5qaDQHOU5bIZCtM2U/OtMhRLxU6+EwGlPQ8kyV3BbS3kSTOMXt
EVngiYweQ1ZKOMmaTiNU8g8DxNTNaSS3klBnJBDHhw3yXky/PDdGgMul2zmH9mSR
t9HA4iAxaJ+EJ4gY1vMOhrcgX8BpVmeyOgsUM6bl/cLuThxYQY1/Rhh+XvsnCmZU
M5c58f9qgSJ6CNcEDK0MRlOfi2/ZzTalEtZ5b/btYRQIHazsWA6sew6HkdBo4pTp
LVRre2lO/3h/Osk3R2zsJPWt5iiR/27Yw+NuDPoKNS719bUcMK52AIYGgmP/158i
dOy6ouc8MPm4mEn/jiBBclTgHepNMCs3vPjfQM18sti5RbKHzpcd3EQA4jVYaHpd
nisJxMce6CBEeJxXj48MX/1sIpwq9mFd1s+TIWyJZKpJZVFBvpJ08uoXaF8+SzaB
GMxE7knb3BgAp4kmkusP
=nEqg
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Aug_2013_17_53_42_+1000_M2OzE3okoiuXlw1G--
