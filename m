Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab3EFPRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:17:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:27830 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab3EFPQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:16:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,622,1363158000"; 
   d="scan'208";a="298322440"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 4/4] f2fs: optimize build_free_nids()
Date: Mon,  6 May 2013 23:15:44 +0800
Message-Id: <1367853344-28938-5-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
References: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When nm_i->fcnt > 2 * MAX_FREE_NIDS, stop scanning other NAT pages.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/node.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 1fe3fe2..3136224 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1342,6 +1342,8 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 		if (nid >= nm_i->max_nid)
 			nid = 0;
 
+		if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
+			break;
 		if (i++ == FREE_NID_PAGES)
 			break;
 	}
-- 
1.7.9.5

