Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071Ab3ECMoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:44:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:40268 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761757Ab3ECMoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:44:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,604,1363158000"; 
   d="scan'208";a="331878136"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 2/2] f2fs: optimize build_free_nids()
Date: Fri,  3 May 2013 20:43:23 +0800
Message-Id: <1367585003-24241-2-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367585003-24241-1-git-send-email-haicheng.li@linux.intel.com>
References: <1367585003-24241-1-git-send-email-haicheng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When nm_i->fcnt > 2 * MAX_FREE_NIDS, stop scanning other NAT pages.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 6276467..31d038f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1307,7 +1307,7 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 			nid = 0;
 			is_cycled = true;
 		}
-		if (fcnt > MAX_FREE_NIDS)
+		if (fcnt > MAX_FREE_NIDS || nm_i->fcnt > 2 * MAX_FREE_NIDS)
 			break;
 		if (is_cycled && nm_i->init_scan_nid <= nid)
 			break;
-- 
1.7.9.5

