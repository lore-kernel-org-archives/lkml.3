Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaDKIB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:01:28 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:26025 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754647AbaDKIBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:01:23 -0400
X-IronPort-AV: E=Sophos;i="4.97,839,1389715200"; 
   d="scan'208";a="29139733"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: <axboe@kernel.dk>
CC: <linux-kernel@vger.kernel.org>, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] block: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Fri, 11 Apr 2014 15:58:56 +0800
Message-ID: <1397203136-16712-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 block/blk-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a0e3096..2cf62fc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1654,7 +1654,7 @@ static int __init fail_make_request_debugfs(void)
 	struct dentry *dir = fault_create_debugfs_attr("fail_make_request",
 						NULL, &fail_make_request);
 
-	return IS_ERR(dir) ? PTR_ERR(dir) : 0;
+	return PTR_ERR_OR_ZERO(dir);
 }
 
 late_initcall(fail_make_request_debugfs);
-- 
1.8.3.1

