Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaFJSUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:20:15 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:50482 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbaFJSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:20:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQNAOZLl1NbskA7/2dsb2JhbABZgw2sFAEBBpkSgQgXdYRgI4EaN4hGAcx2F4VWiHMdhCsEj12KR4soiB2DPjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] BLOCK/BLK-CGROUP: add __init to blkcg_policy_register
Date: Tue, 10 Jun 2014 20:18:36 +0200
Message-Id: <1402424316-8933-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkcg_policy_register is only called by
__init functions:

__init cfq_init
__init throtl_init

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/blk-cgroup.c | 2 +-
 block/blk-cgroup.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9f5bce3..069bc20 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1093,7 +1093,7 @@ EXPORT_SYMBOL_GPL(blkcg_deactivate_policy);
  * Register @pol with blkcg core.  Might sleep and @pol may be modified on
  * successful registration.  Returns 0 on success and -errno on failure.
  */
-int blkcg_policy_register(struct blkcg_policy *pol)
+int __init blkcg_policy_register(struct blkcg_policy *pol)
 {
 	int i, ret;
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index d692b29..cbb7f94 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -145,7 +145,7 @@ void blkcg_drain_queue(struct request_queue *q);
 void blkcg_exit_queue(struct request_queue *q);
 
 /* Blkio controller policy registration */
-int blkcg_policy_register(struct blkcg_policy *pol);
+int __init blkcg_policy_register(struct blkcg_policy *pol);
 void blkcg_policy_unregister(struct blkcg_policy *pol);
 int blkcg_activate_policy(struct request_queue *q,
 			  const struct blkcg_policy *pol);
@@ -580,7 +580,7 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { ret
 static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
 static inline void blkcg_drain_queue(struct request_queue *q) { }
 static inline void blkcg_exit_queue(struct request_queue *q) { }
-static inline int blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
+static inline int __init blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
 static inline void blkcg_policy_unregister(struct blkcg_policy *pol) { }
 static inline int blkcg_activate_policy(struct request_queue *q,
 					const struct blkcg_policy *pol) { return 0; }
-- 
1.8.4.5

