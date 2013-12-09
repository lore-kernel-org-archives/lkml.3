Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317Ab3LIKN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:13:26 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34430 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752166Ab3LIKNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:13:25 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: zaga@fly.cc.fer.hr, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] [SCSI] wd7000: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 11:13:21 +0100
Message-Id: <1386584001-5341-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381040337-12620-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381040337-12620-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/wd7000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index f9a6e4b0affe..32674236fec7 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1252,7 +1252,7 @@ static int wd7000_init(Adapter * host)
 		return 0;
 
 
-	if (request_irq(host->irq, wd7000_intr, IRQF_DISABLED, "wd7000", host)) {
+	if (request_irq(host->irq, wd7000_intr, 0, "wd7000", host)) {
 		printk("wd7000_init: can't get IRQ %d.\n", host->irq);
 		return (0);
 	}
-- 
1.8.3.2

