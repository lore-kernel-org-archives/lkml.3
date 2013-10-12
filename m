Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab3JLEeC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:34:02 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54080 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750705Ab3JLEeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:34:01 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: jg1.han@samsung.com, akpm@linux-foundation.org, axboe@kernel.dk,
        yongjun_wei@trendmicro.com.cn
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] mg_disk: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 06:33:47 +0200
Message-Id: <1381552427-6381-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/block/mg_disk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 77a60be..7bc363f 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -936,7 +936,7 @@ static int mg_probe(struct platform_device *plat_dev)
 			goto probe_err_3b;
 		}
 		err = request_irq(host->irq, mg_irq,
-				IRQF_DISABLED | IRQF_TRIGGER_RISING,
+				IRQF_TRIGGER_RISING,
 				MG_DEV_NAME, host);
 		if (err) {
 			printk(KERN_ERR "%s:%d fail (request_irq err=%d)\n",
-- 
1.8.1.2

