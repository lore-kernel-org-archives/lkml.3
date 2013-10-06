Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab3JFF2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 01:28:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51075 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751182Ab3JFF2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 01:28:17 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: fischer@norbit.de, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [SCSI] aha152x: remove deprecated IRQF_DISABLED
Date: Sun,  6 Oct 2013 07:28:13 +0200
Message-Id: <1381037293-11215-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Also taking the opportunity to fix checkpatch issues on the lines I modified

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/aha152x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 3f7b6fe..e86eb6a 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -857,7 +857,7 @@ struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 	SETPORT(SIMODE0, 0);
 	SETPORT(SIMODE1, 0);
 
-	if( request_irq(shpnt->irq, swintr, IRQF_DISABLED|IRQF_SHARED, "aha152x", shpnt) ) {
+	if (request_irq(shpnt->irq, swintr, IRQF_SHARED, "aha152x", shpnt)) {
 		printk(KERN_ERR "aha152x%d: irq %d busy.\n", shpnt->host_no, shpnt->irq);
 		goto out_host_put;
 	}
@@ -891,7 +891,7 @@ struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 	SETPORT(SSTAT0, 0x7f);
 	SETPORT(SSTAT1, 0xef);
 
-	if ( request_irq(shpnt->irq, intr, IRQF_DISABLED|IRQF_SHARED, "aha152x", shpnt) ) {
+	if (request_irq(shpnt->irq, intr, IRQF_SHARED, "aha152x", shpnt)) {
 		printk(KERN_ERR "aha152x%d: failed to reassign irq %d.\n", shpnt->host_no, shpnt->irq);
 		goto out_host_put;
 	}
-- 
1.8.1.2

