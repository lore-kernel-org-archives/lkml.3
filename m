Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027Ab3JPR6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:58:09 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36338 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762013Ab3JPR6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:58:04 -0400
From: Dhanunjaya <dhanunjaya.matrix@gmail.com>
To: eli.billauer@gmail.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dhanunjaya <dhanunjaya.matrix@gmail.com>
Subject: [PATCH 2/2] Staging: xillybus: fix for quoted string split across lines
Date: Wed, 16 Oct 2013 23:27:52 +0530
Message-Id: <1381946272-18651-1-git-send-email-dhanunjaya.matrix@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the xillybus_of.c file that fixes up a
quoted string split across lines warning found by the
checkpatch.pl tool.

Signed-off-by: Dhanunjaya <dhanunjaya.matrix@gmail.com>
---
 drivers/staging/xillybus/xillybus_of.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/xillybus/xillybus_of.c b/drivers/staging/xillybus/xillybus_of.c
index 92c2931..822ef4d 100644
--- a/drivers/staging/xillybus/xillybus_of.c
+++ b/drivers/staging/xillybus/xillybus_of.c
@@ -117,8 +117,7 @@ static int xilly_drv_probe(struct platform_device *op)
 
 	rc = of_address_to_resource(dev->of_node, 0, &endpoint->res);
 	if (rc) {
-		pr_warn("xillybus: Failed to obtain device tree "
-			"resource\n");
+		pr_warn("xillybus: Failed to obtain device tree resource\n");
 		goto failed_request_regions;
 	}
 
@@ -141,8 +140,7 @@ static int xilly_drv_probe(struct platform_device *op)
 	rc = request_irq(irq, xillybus_isr, 0, xillyname, endpoint);
 
 	if (rc) {
-		pr_err("xillybus: Failed to register IRQ handler. "
-		       "Aborting.\n");
+		pr_err("xillybus: Failed to register IRQ handler, Aborting...\n");
 		rc = -ENODEV;
 		goto failed_register_irq;
 	}
-- 
1.8.1.2

