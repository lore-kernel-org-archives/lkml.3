Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030201Ab3FTKIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:08:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40150 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965257Ab3FTKHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:07:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,903,1363104000"; 
   d="scan'208";a="7614621"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: bcrl@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] page_migrate: Fix wrong comment in address_space_operations->migratepage()
Date: Thu, 20 Jun 2013 18:10:20 +0800
Message-Id: <1371723023-4060-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 18:06:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 18:06:16,
	Serialize complete at 2013/06/20 18:06:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no parameter "sync" in address_space_operations->migratepage().
It should be mograte_mode. And the comment is for MIGRATE_ASYNC.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 include/linux/fs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 43db02e..c1a76ac 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -372,8 +372,8 @@ struct address_space_operations {
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
 						void **, unsigned long *);
 	/*
-	 * migrate the contents of a page to the specified target. If sync
-	 * is false, it must not block.
+	 * migrate the contents of a page to the specified target. If
+	 * migrate_mode is MIGRATE_ASYNC, it must not block.
 	 */
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
-- 
1.7.1

