Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaIGDFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 23:05:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:7079 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaIGDFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 23:05:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="382482329"
From: Huang Ying <ying.huang@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH] f2fs: Remove lock from check_valid_map
Date: Sun,  7 Sep 2014 11:05:04 +0800
Message-Id: <1410059104-9060-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one bit is read in check_valid_map, holding a lock to do that
doesn't help anything except decreasing performance.

Signed-off-by: Huang, Ying <ying.huang@intel.com>
---
 fs/f2fs/gc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -382,10 +382,8 @@ static int check_valid_map(struct f2fs_s
 	struct seg_entry *sentry;
 	int ret;
 
-	mutex_lock(&sit_i->sentry_lock);
 	sentry = get_seg_entry(sbi, segno);
 	ret = f2fs_test_bit(offset, sentry->cur_valid_map);
-	mutex_unlock(&sit_i->sentry_lock);
 	return ret;
 }
 
