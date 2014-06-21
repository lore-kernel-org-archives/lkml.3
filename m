Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaFULrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 07:47:05 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:12901 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766AbaFULrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 07:47:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHABBwpVNbsl30/2dsb2JhbABZgw2rSAUBAQEBAQEFAZkqgQkXdYRgI4ECGDeILgMVAcI+DYZLF4VihnGCIx2ELQSYS4F5izCCKIYCg0Q7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Damien Wyart <damien.wyart@gmail.com>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 1/1] Revert "block: add __init to elv_register"
Date: Sat, 21 Jun 2014 13:47:12 +0200
Message-Id: <1403351232-5854-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit b5097e956a4d

Adding __init to elv_register makes it unreliable when updating
/sys/block/sdX/queue/scheduler at runtime

Reported-by: Damien Wyart <damien.wyart@gmail.com>
Cc: Damien Wyart <damien.wyart@gmail.com>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/elevator.c         | 2 +-
 include/linux/elevator.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 34bded1..24c28b6 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -825,7 +825,7 @@ void elv_unregister_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(elv_unregister_queue);
 
-int __init elv_register(struct elevator_type *e)
+int elv_register(struct elevator_type *e)
 {
 	char *def = "";
 
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index e2a6bd7..45a9147 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -143,7 +143,7 @@ extern void elv_drain_elevator(struct request_queue *);
  * io scheduler registration
  */
 extern void __init load_default_elevator_module(void);
-extern int __init elv_register(struct elevator_type *);
+extern int elv_register(struct elevator_type *);
 extern void elv_unregister(struct elevator_type *);
 
 /*
-- 
1.8.4.5

