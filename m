Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaCRIDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:03:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34272 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753543AbaCRIDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:03:46 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] block: hd: remove deprecated IRQF_DISABLED
Date: Tue, 18 Mar 2014 09:03:35 +0100
Message-Id: <1395129815-17661-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393968037-18042-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1393968037-18042-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the use of the IRQF_DISABLED flag
from drivers/block/hd.c

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

