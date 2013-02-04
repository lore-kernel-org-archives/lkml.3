Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3BDWSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:18:09 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:60981 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab3BDWSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:18:07 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] infiniband: hw/cxgb3/iwch_provider.c: fix uninitialized variable issue
Date: Mon,  4 Feb 2013 23:18:06 +0100
Message-Id: <1360016286-15343-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable npages might be used uninitialized in line 594.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 145d82a..90ce483 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -559,7 +559,7 @@ static int iwch_reregister_phys_mem(struct ib_mr *mr,
 	__be64 *page_list = NULL;
 	int shift = 0;
 	u64 total_size;
-	int npages;
+	int npages = 0;
 	int ret;
 
 	PDBG("%s ib_mr %p ib_pd %p\n", __func__, mr, pd);
-- 
1.7.9.5

