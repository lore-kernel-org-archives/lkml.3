Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaILMT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:19:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:61982 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaILMT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:19:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,512,1406617200"; 
   d="scan'208";a="477109979"
From: Huang Ying <ying.huang@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>, huang.ying.caritas@gmail.com
Subject: [PATCH] f2fs: Use nm_i->next_scan_nid as default for next_free_nid
Date: Fri, 12 Sep 2014 20:19:48 +0800
Message-Id: <1410524388-26544-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, if there is no free nid in nm_i->free_nid_list, 0 may be saved
into next_free_nid of checkpoint, this may cause useless scanning for
next mount.  nm_i->next_scan_nid should be a better default value than
0.

Signed-off-by: Huang, Ying <ying.huang@intel.com>
---
 fs/f2fs/checkpoint.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -802,7 +802,8 @@ static void do_checkpoint(struct f2fs_sb
 {
 	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
-	nid_t last_nid = 0;
+	struct f2fs_nm_info *nm_i = NM_I(sbi);
+	nid_t last_nid = nm_i->next_scan_nid;
 	block_t start_blk;
 	struct page *cp_page;
 	unsigned int data_sum_blocks, orphan_blocks;
