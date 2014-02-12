Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaBMKxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:53:21 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:65064 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaBMKxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:53:18 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 2/3] staging/lustre/libcfs: remove cfs_hash_long
Date: Wed, 12 Feb 2014 19:21:39 +0800
Message-Id: <1392204100-968-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1392204100-968-1-git-send-email-bergwolf@gmail.com>
References: <1392204100-968-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_hash.h      |    2 --
 .../staging/lustre/include/linux/lnet/lib-lnet.h   |    2 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |    2 +-
 drivers/staging/lustre/lnet/lnet/lib-ptl.c         |    2 +-
 drivers/staging/lustre/lustre/include/lustre_fid.h |    2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |    4 ++--
 drivers/staging/lustre/lustre/obdclass/lu_object.c |    4 ++--
 .../lustre/lustre/ptlrpc/gss/gss_svc_upcall.c      |    2 +-
 8 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_hash.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_hash.h
index 9d5ee1a..e5d5db2 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_hash.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_hash.h
@@ -65,8 +65,6 @@
 
 #include <linux/hash.h>
 
-#define cfs_hash_long(val, bits)    hash_long(val, bits)
-
 /** disable debug */
 #define CFS_HASH_DEBUG_NONE	 0
 /** record hash depth and output to console when it's too deep,
diff --git a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
index 3ac2bb5..856fcfa 100644
--- a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
+++ b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
@@ -628,7 +628,7 @@ void lnet_ni_free(lnet_ni_t *ni);
 static inline int
 lnet_nid2peerhash(lnet_nid_t nid)
 {
-	return cfs_hash_long(nid, LNET_PEER_HASH_BITS);
+	return hash_long(nid, LNET_PEER_HASH_BITS);
 }
 
 static inline struct list_head *
diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index c562ff3..a18fee5 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -770,7 +770,7 @@ lnet_nid_cpt_hash(lnet_nid_t nid, unsigned int number)
 	if (number == 1)
 		return 0;
 
-	val = cfs_hash_long(key, LNET_CPT_BITS);
+	val = hash_long(key, LNET_CPT_BITS);
 	/* NB: LNET_CP_NUMBER doesn't have to be PO2 */
 	if (val < number)
 		return val;
diff --git a/drivers/staging/lustre/lnet/lnet/lib-ptl.c b/drivers/staging/lustre/lnet/lnet/lib-ptl.c
index 6fffd5e..920df69 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-ptl.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-ptl.c
@@ -366,7 +366,7 @@ lnet_mt_match_head(struct lnet_match_table *mtable,
 		unsigned long hash = mbits + id.nid + id.pid;
 
 		LASSERT(lnet_ptl_is_unique(ptl));
-		hash = cfs_hash_long(hash, LNET_MT_HASH_BITS);
+		hash = hash_long(hash, LNET_MT_HASH_BITS);
 		return &mtable->mt_mhash[hash];
 	}
 }
diff --git a/drivers/staging/lustre/lustre/include/lustre_fid.h b/drivers/staging/lustre/lustre/include/lustre_fid.h
index 84a897e..cf78761 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fid.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fid.h
@@ -685,7 +685,7 @@ static inline __u32 fid_hash(const struct lu_fid *f, int bits)
 {
 	/* all objects with same id and different versions will belong to same
 	 * collisions list. */
-	return cfs_hash_long(fid_flatten(f), bits);
+	return hash_long(fid_flatten(f), bits);
 }
 
 /**
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 5f89864..2824d4a 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -421,9 +421,9 @@ static unsigned ldlm_res_hop_fid_hash(struct cfs_hash *hs,
 	} else {
 		val = fid_oid(&fid);
 	}
-	hash = cfs_hash_long(hash, hs->hs_bkt_bits);
+	hash = hash_long(hash, hs->hs_bkt_bits);
 	/* give me another random factor */
-	hash -= cfs_hash_long((unsigned long)hs, val % 11 + 3);
+	hash -= hash_long((unsigned long)hs, val % 11 + 3);
 
 	hash <<= hs->hs_cur_bits - hs->hs_bkt_bits;
 	hash |= ldlm_res_hop_hash(hs, key, CFS_HASH_NBKT(hs) - 1);
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index 9887d8f..1fd6fa1 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -890,10 +890,10 @@ static unsigned lu_obj_hop_hash(struct cfs_hash *hs,
 
 	hash = fid_flatten32(fid);
 	hash += (hash >> 4) + (hash << 12); /* mixing oid and seq */
-	hash = cfs_hash_long(hash, hs->hs_bkt_bits);
+	hash = hash_long(hash, hs->hs_bkt_bits);
 
 	/* give me another random factor */
-	hash -= cfs_hash_long((unsigned long)hs, fid_oid(fid) % 11 + 3);
+	hash -= hash_long((unsigned long)hs, fid_oid(fid) % 11 + 3);
 
 	hash <<= hs->hs_cur_bits - hs->hs_bkt_bits;
 	hash |= (fid_seq(fid) + fid_oid(fid)) & (CFS_HASH_NBKT(hs) - 1);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_svc_upcall.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_svc_upcall.c
index 8d25a70..f0aba50 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_svc_upcall.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_svc_upcall.c
@@ -102,7 +102,7 @@ static inline unsigned long hash_mem(char *buf, int length, int bits)
 		len++;
 
 		if ((len & (BITS_PER_LONG/8-1)) == 0)
-			hash = cfs_hash_long(hash^l, BITS_PER_LONG);
+			hash = hash_long(hash^l, BITS_PER_LONG);
 	} while (len);
 
 	return hash >> (BITS_PER_LONG - bits);
-- 
1.7.7.6

