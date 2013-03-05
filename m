Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3CER7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:59:14 -0500
Received: from smtp.citrix.com ([66.165.176.89]:6527 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab3CER7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:59:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,788,1355097600"; 
   d="scan'208";a="11276817"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH 1/1] xen-blkback: Change statistics counter types to unsigned
Date: Tue, 5 Mar 2013 17:59:32 +0000
Message-ID: <1362506372-19079-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These values shouldn't be negative, but after an overflow their value
can turn into negative, if they are signed. xentop can show bogus
values in this case.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Reported-by: Ichiro Ogino <ichiro.ogino@citrix.co.jp>
---
 drivers/block/xen-blkback/common.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 6072390..72d09ac 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -208,13 +208,13 @@ struct xen_blkif {
 
 	/* statistics */
 	unsigned long		st_print;
-	int			st_rd_req;
-	int			st_wr_req;
-	int			st_oo_req;
-	int			st_f_req;
-	int			st_ds_req;
-	int			st_rd_sect;
-	int			st_wr_sect;
+	unsigned long long			st_rd_req;
+	unsigned long long			st_wr_req;
+	unsigned long long			st_oo_req;
+	unsigned long long			st_f_req;
+	unsigned long long			st_ds_req;
+	unsigned long long			st_rd_sect;
+	unsigned long long			st_wr_sect;
 
 	wait_queue_head_t	waiting_to_free;
 };
-- 
1.7.0.4

