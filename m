Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaDPFjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:39:04 -0400
Received: from ozlabs.org ([103.22.144.67]:56478 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbaDPFjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:39:03 -0400
Date: Wed, 16 Apr 2014 15:38:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140416153856.222b665abb0a66d2470a7c81@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Apr_2014_15_38_56_+1000_o8tuMnJEZv_DMKUA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Apr_2014_15_38_56_+1000_o8tuMnJEZv_DMKUA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

ERROR: "kmalloc_order" [drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko=
] undefined!

Caused by commit a3ed1ed24850 ("mm: get rid of __GFP_KMEMCG").

I added the following patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 16 Apr 2014 15:32:54 +1000
Subject: [PATCH] mm: get rid of __GFP_KMEMCG fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/slab_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index cab4c49b3e8c..edd10a8af69e 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -584,6 +584,7 @@ void *kmalloc_order(size_t size, gfp_t flags, unsigned =
int order)
 	kmemleak_alloc(ret, size, 1, flags);
 	return ret;
 }
+EXPORT_SYMBOL(kmalloc_order);
=20
 #ifdef CONFIG_TRACING
 void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
--=20
1.9.2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__16_Apr_2014_15_38_56_+1000_o8tuMnJEZv_DMKUA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTThd0AAoJEMDTa8Ir7ZwVB2IQAIUVQnKOtUZDt36kAfTH3rKO
vkQCLn+RkpNqf2rtBpf/Igl1ktBGpvvwo7DCHQypoA1dadf5NXI+fGc2KZmjDQti
oemmLq+zhl4itgJwXZ2L36/ZtNJemDoi5hhQYFghcriEBnf4iTx4ohNHmWxMJzrO
4UZDYF1CI0w5BuN97LPGN6TlJHkAMpr9fMV06TRGFwWTJ7lwG25bLFX1C8Bdt2LF
ObMB3A8RWTgp/ELDv/Hgi7RrdaVrH0K+wNGVhVirUS6bZhvw3RS27+KPmJBvKNKe
z1Z+YWizDaKERU/0Usa9D3a0pSxN6zMYQUIsCbTbZEpm5NSVsshrLmHVT+ijQijQ
NJP/z+27i7HmsqLZX1BMYCXeyqLFGxxcRo5HpBzOurjM1l0BPRJy55koVpK4q1yw
AH2B7dwcwXv5aJQOVip7GERr9TxuIcUST9wNDcPm2baFOq3fVaz7sXYr9rlwWoUr
Lnyt7OA8wDMZUEk8Y2lI7quXpMdJf0saEkfQaZhNWszQebUxPnTYax/YoiCFA8ol
AEKpzfE1rbrwfX00tUxwecxSFECLsv034tzhBJcW4h8nRwJCAZ0dUdFKynhe6/BQ
e1SklzCTWfNVwOARgUeidNBqCMP0Y4IfoMNyV23FPgw12GuNJhR1LMYQAqcYo2Hl
WE3fy10Ta59NIUEI6qhn
=YB0A
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Apr_2014_15_38_56_+1000_o8tuMnJEZv_DMKUA--
