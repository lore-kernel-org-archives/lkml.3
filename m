Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaJCCg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 22:36:28 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49047 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaJCCg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 22:36:27 -0400
From: Amber Thrall <amber.rose.thrall@gmail.com>
To: jarod@wilsonet.com, m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Amber Thrall <amber.rose.thrall@gmail.com>
Subject: [PATCH] Staging: media: lirc: cleaned up packet dump in 2 files.
Date: Thu,  2 Oct 2014 19:33:30 -0700
Message-Id: <1412303610-18198-1-git-send-email-amber.rose.thrall@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lirc_imon.c and lirc_sasem.c contain an incoming_packet method that
is using deprecated printk's.  Removed blocks replacing with single
dev_info with a %*ph format instead.

Signed-off-by: Amber Thrall <amber.rose.thrall@gmail.com>
---
 drivers/staging/media/lirc/lirc_imon.c  | 10 ++--------
 drivers/staging/media/lirc/lirc_sasem.c | 10 ++--------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 7aca44f..232edd5 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -606,7 +606,6 @@ static void imon_incoming_packet(struct imon_context *context,
 	struct device *dev = context->driver->dev;
 	int octet, bit;
 	unsigned char mask;
-	int i;
 
 	/*
 	 * just bail out if no listening IR client
@@ -620,13 +619,8 @@ static void imon_incoming_packet(struct imon_context *context,
 		return;
 	}
 
-	if (debug) {
-		dev_info(dev, "raw packet: ");
-		for (i = 0; i < len; ++i)
-			printk("%02x ", buf[i]);
-		printk("\n");
-	}
-
+	if (debug)
+		dev_info(dev, "raw packet: %*ph\n", len, buf);
 	/*
 	 * Translate received data to pulse and space lengths.
 	 * Received data is active low, i.e. pulses are 0 and
diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index c20ef56..2f0463e 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -573,7 +573,6 @@ static void incoming_packet(struct sasem_context *context,
 	unsigned char *buf = urb->transfer_buffer;
 	long ms;
 	struct timeval tv;
-	int i;
 
 	if (len != 8) {
 		dev_warn(&context->dev->dev,
@@ -582,13 +581,8 @@ static void incoming_packet(struct sasem_context *context,
 		return;
 	}
 
-	if (debug) {
-		printk(KERN_INFO "Incoming data: ");
-		for (i = 0; i < 8; ++i)
-			printk(KERN_CONT "%02x ", buf[i]);
-		printk(KERN_CONT "\n");
-	}
-
+	if (debug)
+		dev_info(&context->dev->dev, "Incoming data: %*ph\n", len, buf);
 	/*
 	 * Lirc could deal with the repeat code, but we really need to block it
 	 * if it arrives too late.  Otherwise we could repeat the wrong code.
-- 
2.1.2

