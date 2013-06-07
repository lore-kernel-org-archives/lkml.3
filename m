Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3FGM4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:56:47 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55039 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab3FGM4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:56:45 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andreas Dilger <andreas.dilger@intel.com>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@openvz.org>, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>
Subject: [PATCH 4/5] staging/lustre/libcfs: cleanup linux-mem.h
Date: Fri,  7 Jun 2013 20:53:45 +0800
Message-Id: <1370609626-3734-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370609626-3734-1-git-send-email-bergwolf@gmail.com>
References: <1370609626-3734-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove shrinker related wrappers.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/include/linux/libcfs/linux/linux-mem.h  |   38 --------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
index 042a2bc..c572611 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
@@ -79,42 +79,4 @@
 	do { __oldfs = get_fs(); set_fs(get_ds());} while(0)
 #define MMSPACE_CLOSE	       set_fs(__oldfs)
 
-/*
- * Shrinker
- */
-
-# define SHRINKER_ARGS(sc, nr_to_scan, gfp_mask)  \
-		       struct shrinker *shrinker, \
-		       struct shrink_control *sc
-# define shrink_param(sc, var) ((sc)->var)
-
-typedef int (*shrinker_t)(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask));
-
-static inline
-struct shrinker *set_shrinker(int seek, shrinker_t func)
-{
-	struct shrinker *s;
-
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (s == NULL)
-		return (NULL);
-
-	s->shrink = func;
-	s->seeks = seek;
-
-	register_shrinker(s);
-
-	return s;
-}
-
-static inline
-void remove_shrinker(struct shrinker *shrinker)
-{
-	if (shrinker == NULL)
-		return;
-
-	unregister_shrinker(shrinker);
-	kfree(shrinker);
-}
-
 #endif /* __LINUX_CFS_MEM_H__ */
-- 
1.7.9.5

