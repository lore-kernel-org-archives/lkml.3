Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaIGDif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 23:38:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:45580 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaIGDie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 23:38:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,480,1406617200"; 
   d="scan'208";a="595721530"
From: Huang Ying <ying.huang@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2] f2fs: Remove lock from check_valid_map
Date: Sun,  7 Sep 2014 11:38:30 +0800
Message-Id: <1410061110-31081-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1410059104-9060-1-git-send-email-ying.huang@intel.com>
References: <1410059104-9060-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one bit is read in check_valid_map, holding a lock to do that
doesn't help anything except decreasing performance.

Signed-off-by: Huang, Ying <ying.huang@intel.com>
---

v2: Fixed a build warning.

---
 fs/f2fs/gc.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -378,14 +378,11 @@ static void put_gc_inode(struct list_hea
 static int check_valid_map(struct f2fs_sb_info *sbi,
 				unsigned int segno, int offset)
 {
-	struct sit_info *sit_i = SIT_I(sbi);
 	struct seg_entry *sentry;
 	int ret;
 
-	mutex_lock(&sit_i->sentry_lock);
 	sentry = get_seg_entry(sbi, segno);
 	ret = f2fs_test_bit(offset, sentry->cur_valid_map);
-	mutex_unlock(&sit_i->sentry_lock);
 	return ret;
 }
 
