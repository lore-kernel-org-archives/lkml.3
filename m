Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaJAKHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:07:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33286 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750981AbaJAKHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:07:11 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: axboe@fb.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] block: hd: remove deprecated IRQF_DISABLED
Date: Wed,  1 Oct 2014 12:07:07 +0200
Message-Id: <1412158027-7094-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395129815-17661-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1395129815-17661-1-git-send-email-michael.opdenacker@free-electrons.com>
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
index 8a290c08262f..3abb121825bc 100644
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
1.9.1

