Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038Ab3JLE3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:29:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54074 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750732Ab3JLE3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:29:48 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] block: hd: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 06:29:41 +0200
Message-Id: <1381552181-6310-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

This also removes a related comment which is obsolete too.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/block/hd.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index bf397bf..e16985f 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -694,16 +694,6 @@ static const struct block_device_operations hd_fops = {
 	.getgeo =	hd_getgeo,
 };
 
-/*
- * This is the hard disk IRQ description. The IRQF_DISABLED in sa_flags
- * means we run the IRQ-handler with interrupts disabled:  this is bad for
- * interrupt latency, but anything else has led to problems on some
- * machines.
- *
- * We enable interrupts in some of the routines after making sure it's
- * safe.
- */
-
 static int __init hd_init(void)
 {
 	int drive;
@@ -761,7 +751,7 @@ static int __init hd_init(void)
 			p->cyl, p->head, p->sect);
 	}
 
-	if (request_irq(HD_IRQ, hd_interrupt, IRQF_DISABLED, "hd", NULL)) {
+	if (request_irq(HD_IRQ, hd_interrupt, 0, "hd", NULL)) {
 		printk("hd: unable to get IRQ%d for the hard disk driver\n",
 			HD_IRQ);
 		goto out1;
-- 
1.8.1.2

