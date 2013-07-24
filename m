Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab3GXKYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:24:25 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:43257 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751522Ab3GXKYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:24:20 -0400
From: mail-agent-noreply@emc.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Michal Hocko <mhocko@suse.cz>, Dave Chinner <dchinner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH-v2 4/4] staging/lustre/libcfs: cleanup linux-mem.h
Date: Wed, 24 Jul 2013 18:18:55 +0800
Message-Id: <1374661135-17072-5-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374661135-17072-4-git-send-email-mail-agent-noreply@emc.com>
References: <1374661135-17072-1-git-send-email-mail-agent-noreply@emc.com>
 <1374661135-17072-2-git-send-email-mail-agent-noreply@emc.com>
 <1374661135-17072-3-git-send-email-mail-agent-noreply@emc.com>
 <1374661135-17072-4-git-send-email-mail-agent-noreply@emc.com>
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <bergwolf@gmail.com>

remove shrinker related wrappers.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 .../lustre/include/linux/libcfs/linux/linux-mem.h  |   38 --------------------
 1 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-mem.h
index 63efb7b..2af15d4 100644
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
1.7.1

