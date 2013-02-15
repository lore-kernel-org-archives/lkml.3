Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3BOUU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:20:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51195 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3BOUUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:20:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: dan.magenheimer@oracle.com, sjenning@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        ngupta@vflare.org, rcj@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        minchan@kernel.org
Cc: ric.masonn@gmail.com, lliubbo@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 08/11] cleancache: Remove the check for cleancache_enabled.
Date: Fri, 15 Feb 2013 15:20:32 -0500
Message-Id: <1360959635-18922-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360959635-18922-1-git-send-email-konrad.wilk@oracle.com>
References: <1360959635-18922-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the support for loading of backends as modules, the
cleancache_enabled is always set to true. The next subsequent patches
are going to convert the cleancache_enabled to be a bit more selective
and be on/off depending on whether the backend has registered - and not
whether the cleancache API is enabled.

The three functions: cleancache_init_[shared|]fs and
cleancache_invalidate_fs can be called anytime - they queue up which
of the filesystems are active and can use the cleancache API - and when
the backend is registered they will know which filesystem to
process.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/cleancache.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/cleancache.h b/include/linux/cleancache.h
index 3af5ea8..dfa1ccb 100644
--- a/include/linux/cleancache.h
+++ b/include/linux/cleancache.h
@@ -74,14 +74,12 @@ static inline bool cleancache_fs_enabled_mapping(struct address_space *mapping)
 
 static inline void cleancache_init_fs(struct super_block *sb)
 {
-	if (cleancache_enabled)
-		__cleancache_init_fs(sb);
+	__cleancache_init_fs(sb);
 }
 
 static inline void cleancache_init_shared_fs(char *uuid, struct super_block *sb)
 {
-	if (cleancache_enabled)
-		__cleancache_init_shared_fs(uuid, sb);
+	__cleancache_init_shared_fs(uuid, sb);
 }
 
 static inline int cleancache_get_page(struct page *page)
@@ -115,8 +113,7 @@ static inline void cleancache_invalidate_inode(struct address_space *mapping)
 
 static inline void cleancache_invalidate_fs(struct super_block *sb)
 {
-	if (cleancache_enabled)
-		__cleancache_invalidate_fs(sb);
+	__cleancache_invalidate_fs(sb);
 }
 
 #endif /* _LINUX_CLEANCACHE_H */
-- 
1.8.0.2

