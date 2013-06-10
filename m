Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3FJOsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:48:06 -0400
Received: from fallback3.mail.ru ([94.100.176.58]:58979 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3FJOsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:48:05 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] Misc: sram: Remove unneeded check
Date: Mon, 10 Jun 2013 18:43:53 +0400
Message-Id: <1370875433-6386-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.1.5
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch removes unneeded check for resource since
devm_ioremap_resource do all for us.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/misc/sram.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index 4a93886..d87cc91 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -45,15 +45,11 @@ static int sram_probe(struct platform_device *pdev)
 	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -EINVAL;
-
-	size = resource_size(res);
-
 	virt_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(virt_base))
 		return PTR_ERR(virt_base);
 
+	size = resource_size(res);
 
 	sram = devm_kzalloc(&pdev->dev, sizeof(*sram), GFP_KERNEL);
 	if (!sram)
-- 
1.8.1.5

