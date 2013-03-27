Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3C0Vx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:53:56 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:50367 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab3C0Vxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:53:55 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] power: resource_size() instead of computation
Date: Wed, 27 Mar 2013 23:53:47 +0200
Message-Id: <1364421227-11178-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch found using coccinelle.

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/power/goldfish_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/goldfish_battery.c b/drivers/power/goldfish_battery.c
index c10f460..29eba88 100644
--- a/drivers/power/goldfish_battery.c
+++ b/drivers/power/goldfish_battery.c
@@ -178,7 +178,7 @@ static int goldfish_battery_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	data->reg_base = devm_ioremap(&pdev->dev, r->start, r->end - r->start + 1);
+	data->reg_base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
 	if (data->reg_base == NULL) {
 		dev_err(&pdev->dev, "unable to remap MMIO\n");
 		return -ENOMEM;
-- 
1.7.9.5

