Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbaKRTpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:45:46 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38588 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbaKRTmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:42:37 -0500
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: hch@infradead.org, axboe@fb.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: thornber@redhat.com, bvanassche@acm.org, jmad@itu.dk,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [RPC PATCH 2/5] block: extend rq_flag_bits
Date: Tue, 18 Nov 2014 20:41:56 +0100
Message-Id: <1416339719-8488-3-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416339719-8488-1-git-send-email-m@bjorling.me>
References: <1416339719-8488-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Madsen <jmad@itu.dk>

The rq_flag_bits is extended by REQ_NVM and REQ_NVM_MAPPED

REQ_NVM is used to detect request have through LightNVM on submission, and can
be detected on completion.

REQ_NVM_MAPPED is used to detect if request have mapped appropriately through
LightNVM.

The latter is added temponarily to debug LightNVM targets and will
be removed later.

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 include/linux/blk_types.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 66c2167..b1d2f4d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -191,6 +191,8 @@ enum rq_flag_bits {
 	__REQ_END,		/* last of chain of requests */
 	__REQ_HASHED,		/* on IO scheduler merge hash */
 	__REQ_MQ_INFLIGHT,	/* track inflight for MQ */
+	__REQ_NVM,		/* request is queued via lightnvm */
+	__REQ_NVM_MAPPED,	/* lightnvm mapped this request */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -245,5 +247,7 @@ enum rq_flag_bits {
 #define REQ_END			(1ULL << __REQ_END)
 #define REQ_HASHED		(1ULL << __REQ_HASHED)
 #define REQ_MQ_INFLIGHT		(1ULL << __REQ_MQ_INFLIGHT)
+#define REQ_NVM			(1ULL << __REQ_NVM)
+#define REQ_NVM_MAPPED		(1ULL << __REQ_NVM_MAPPED)
 
 #endif /* __LINUX_BLK_TYPES_H */
-- 
1.9.1

