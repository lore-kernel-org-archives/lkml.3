Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187Ab3EBMca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:32:30 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35665 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676Ab3EBMc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:32:29 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: misc: use devm_ioremap_resource()
Date: Thu,  2 May 2013 14:39:34 +0200
Message-Id: <1367498374-27426-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_request_and_ioremap.cocci.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/misc/sram.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index 437192e..4a93886 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -50,9 +50,10 @@ static int sram_probe(struct platform_device *pdev)
 
 	size = resource_size(res);
 
-	virt_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!virt_base)
-		return -EADDRNOTAVAIL;
+	virt_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(virt_base))
+		return PTR_ERR(virt_base);
+
 
 	sram = devm_kzalloc(&pdev->dev, sizeof(*sram), GFP_KERNEL);
 	if (!sram)
-- 
1.7.10.4

