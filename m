Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579AbaFUMFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:05:20 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:24240 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934335AbaFUMFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:05:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHAEl0pVNbsl30/2dsb2JhbABZgw2rSAUBAQEBAQEFAZkqgQkXdYRgI4ECGDeILgMVAcI0DYZLF4VihnGCIx2ELQSPbYhegXmLMIIohgKDRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@kernel.dk>,
        Damien Wyart <damien.wyart@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] Revert "block: add __init to blkcg_policy_register"
Date: Sat, 21 Jun 2014 14:05:21 +0200
Message-Id: <1403352321-6353-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit a2d445d44000

Adding __init to blkcg_policy_register makes it unreliable when
loading cfq at runtime.

(Similar problem to b5097e956a4d "block: add __init to elv_register"
 reported by Damien Wyart).

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Damien Wyart <damien.wyart@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/blk-cgroup.c | 2 +-
 block/blk-cgroup.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 069bc20..9f5bce3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1093,7 +1093,7 @@ EXPORT_SYMBOL_GPL(blkcg_deactivate_policy);
  * Register @pol with blkcg core.  Might sleep and @pol may be modified on
  * successful registration.  Returns 0 on success and -errno on failure.
  */
-int __init blkcg_policy_register(struct blkcg_policy *pol)
+int blkcg_policy_register(struct blkcg_policy *pol)
 {
 	int i, ret;
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index cbb7f94..d692b29 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -145,7 +145,7 @@ void blkcg_drain_queue(struct request_queue *q);
 void blkcg_exit_queue(struct request_queue *q);
 
 /* Blkio controller policy registration */
-int __init blkcg_policy_register(struct blkcg_policy *pol);
+int blkcg_policy_register(struct blkcg_policy *pol);
 void blkcg_policy_unregister(struct blkcg_policy *pol);
 int blkcg_activate_policy(struct request_queue *q,
 			  const struct blkcg_policy *pol);
@@ -580,7 +580,7 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { ret
 static inline int blkcg_init_queue(struct request_queue *q) { return 0; }
 static inline void blkcg_drain_queue(struct request_queue *q) { }
 static inline void blkcg_exit_queue(struct request_queue *q) { }
-static inline int __init blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
+static inline int blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
 static inline void blkcg_policy_unregister(struct blkcg_policy *pol) { }
 static inline int blkcg_activate_policy(struct request_queue *q,
 					const struct blkcg_policy *pol) { return 0; }
-- 
1.8.4.5

