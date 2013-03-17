Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3CQIBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:01:43 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:61611 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3CQIBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:01:42 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, dwmw2@infradead.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] drivers: power: goldfish: use resource_size()
Date: Sun, 17 Mar 2013 10:01:34 +0200
Message-Id: <1363507294-19958-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses the resource_size() function instead of explicit computation.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
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

