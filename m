Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaFJSGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:06:17 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:7870 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbaFJSGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:06:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQNAChIl1NbskA7/2dsb2JhbABZgw2sFAEBBpkSgQgXdYRgI4EaN4hGAcxtF4VWiHMdhCsEj12KR4soiB2DPjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] BLOCK/ELEVATOR: add __init to elv_register
Date: Tue, 10 Jun 2014 20:04:50 +0200
Message-Id: <1402423490-7271-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

elv_register is only called by elevator init functions:

__init cfq_init
__init deadline_init
__init noop_init

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/elevator.c         | 2 +-
 include/linux/elevator.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 1e01b66..f35eddd 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -845,7 +845,7 @@ void elv_unregister_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(elv_unregister_queue);
 
-int elv_register(struct elevator_type *e)
+int __init elv_register(struct elevator_type *e)
 {
 	char *def = "";
 
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index df63bd3..4ff262e 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -144,7 +144,7 @@ extern void elv_drain_elevator(struct request_queue *);
  * io scheduler registration
  */
 extern void __init load_default_elevator_module(void);
-extern int elv_register(struct elevator_type *);
+extern int __init elv_register(struct elevator_type *);
 extern void elv_unregister(struct elevator_type *);
 
 /*
-- 
1.8.4.5

