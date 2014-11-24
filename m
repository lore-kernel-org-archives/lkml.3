Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaKXQpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:45:43 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61304 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaKXQpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:45:41 -0500
From: Jianyu Zhan <nasa4836@gmail.com>
To: akpm@linux-foundation.org, mgorman@suse.de, riel@redhat.com,
        sasha.levin@oracle.com, n-horiguchi@ah.jp.nec.com,
        andriy.shevchenko@linux.intel.com, rientjes@google.com,
        hannes@cmpxchg.org, nasa4836@gmail.com, vdavydov@parallels.com,
        fabf@skynet.be
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jianyu Zhan <jianyu.zhan@emc.com>
Subject: [PATCH] mm, gfp: escalatedly define GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE
Date: Tue, 25 Nov 2014 00:43:47 +0800
Message-Id: <1416847427-2550-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFP_USER, GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE are escalatedly
confined defined, also implied by their names:

GFP_USER                                  = GFP_USER
GFP_USER + __GFP_HIGHMEM                  = GFP_HIGHUSER
GFP_USER + __GFP_HIGHMEM + __GFP_MOVABLE  = GFP_HIGHUSER_MOVABLE

So just make GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE escalatedly defined
to reflect this fact. It also makes the definition clear and texturally
warn on any furture break-up of this escalated relastionship.

Signed-off-by: Jianyu Zhan <jianyu.zhan@emc.com>
---
 include/linux/gfp.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 41b30fd..f7c74c8 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -110,11 +110,8 @@ struct vm_area_struct;
 #define GFP_TEMPORARY	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
 			 __GFP_RECLAIMABLE)
 #define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
-#define GFP_HIGHUSER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | \
-			 __GFP_HIGHMEM)
-#define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
-				 __GFP_HARDWALL | __GFP_HIGHMEM | \
-				 __GFP_MOVABLE)
+#define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
+#define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE)
 #define GFP_IOFS	(__GFP_IO | __GFP_FS)
 #define GFP_TRANSHUGE	(GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | \
-- 
2.0.0

