Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab3FMJAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:00:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:44392 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932689Ab3FMJAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:00:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,857,1363158000"; 
   d="scan'208";a="349193894"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 3/3] f2fs: optimize do_write_data_page()
Date: Thu, 13 Jun 2013 16:59:29 +0800
Message-Id: <1371113969-946-4-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371113969-946-1-git-send-email-haicheng.li@linux.intel.com>
References: <1371113969-946-1-git-send-email-haicheng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since "need_inplace_update() == true" is a very rare case, using unlikely()
to give compiler a chance to optimize the code.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/data.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 5b145fc..6d4a743 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -497,8 +497,9 @@ int do_write_data_page(struct page *page)
 	 * If current allocation needs SSR,
 	 * it had better in-place writes for updated data.
 	 */
-	if (old_blk_addr != NEW_ADDR && !is_cold_data(page) &&
-				need_inplace_update(inode)) {
+	if (unlikely(old_blk_addr != NEW_ADDR &&
+			!is_cold_data(page) &&
+			need_inplace_update(inode))) {
 		rewrite_data_page(F2FS_SB(inode->i_sb), page,
 						old_blk_addr);
 	} else {
-- 
1.7.9.5

