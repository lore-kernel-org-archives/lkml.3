Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab3BLWlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:41:39 -0500
Received: from mail.df.lth.se ([194.47.250.12]:18867 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758948Ab3BLWl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:41:27 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/9] block: xd: raise timeouts
Date: Tue, 12 Feb 2013 23:40:54 +0100
Message-Id: <1360708860-23466-5-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1360708860-23466-4-git-send-email-linus.walleij@linaro.org>
References: <1360708860-23466-1-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-2-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-3-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-4-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timeouts for the XD driver were set pretty low, probably
tested out on an error-free disk. When there are bad sectors
on the disk, the controller card will autonomously perform a
bump of the drive head, a quite slow mechanical operation
which takes way more than one second, or even the 8 seconds
allowed for the IRQ to arrive. Raise both timeouts to 30
seconds.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/block/xd.c | 2 +-
 drivers/block/xd.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index ce088f8..549a7fa 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -564,7 +564,7 @@ static inline u_char xd_waitport (u_short port,u_char flags,u_char mask,u_long t
 static inline u_int xd_wait_for_IRQ (void)
 {
 	unsigned long flags;
-	xd_watchdog_int.expires = jiffies + 8 * HZ;
+	xd_watchdog_int.expires = jiffies + 30 * HZ;
 	add_timer(&xd_watchdog_int);
 	
 	flags=claim_dma_lock();
diff --git a/drivers/block/xd.h b/drivers/block/xd.h
index 37cacef..489e1ce 100644
--- a/drivers/block/xd.h
+++ b/drivers/block/xd.h
@@ -67,7 +67,7 @@
 #define DMA_MODE	0x03	/* control bits to set for DMA & interrupt */
 
 #define XD_MAXDRIVES	2	/* maximum 2 drives */
-#define XD_TIMEOUT	HZ	/* 1 second timeout */
+#define XD_TIMEOUT	(HZ * 30)	/* 30 second timeout */
 #define XD_RETRIES	4	/* maximum 4 retries */
 
 #undef DEBUG			/* define for debugging output */
-- 
1.8.1.2

