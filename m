Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab3LIJRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:17:52 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33962 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932191Ab3LIJRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:17:48 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] block: hd: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 10:17:42 +0100
Message-Id: <1386580662-4265-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381552181-6310-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381552181-6310-1-git-send-email-michael.opdenacker@free-electrons.com>
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
index bf397bf108b7..e16985fc5639 100644
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
1.8.3.2

