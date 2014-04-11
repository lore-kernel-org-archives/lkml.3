Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbaDKJ7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:59:23 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:4747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756791AbaDKJ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:59:19 -0400
X-IronPort-AV: E=Sophos;i="4.97,841,1389715200"; 
   d="scan'208";a="29145745"
Message-ID: <5347BABE.7060105@cn.fujitsu.com>
Date: Fri, 11 Apr 2014 17:49:50 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] f2fs: use __GFP_ZERO to avoid appending set-NULL
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/segment.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 8a6fe2a..ff8f987 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -243,9 +243,7 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi)
 	if (!test_opt(sbi, FLUSH_MERGE))
 		return blkdev_issue_flush(sbi->sb->s_bdev, GFP_KERNEL, NULL);
 
-	cmd = f2fs_kmem_cache_alloc(flush_cmd_slab, GFP_ATOMIC);
-	cmd->next = NULL;
-	cmd->ret = 0;
+	cmd = f2fs_kmem_cache_alloc(flush_cmd_slab, GFP_ATOMIC | __GFP_ZERO);
 	init_completion(&cmd->wait);
 
 	spin_lock(&sm_i->issue_lock);
-- 
1.7.7

