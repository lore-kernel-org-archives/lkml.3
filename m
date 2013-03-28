Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3C1AwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:52:14 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44301 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3C1AwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:52:13 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH 21/21] power: fix invalid free of devm_ allocated data
Date: Thu, 28 Mar 2013 02:51:59 +0200
Message-Id: <1364431919-26388-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The objects allocated by devm_* APIs are managed by devres and are freed when
the device is detached. Hence there is no need to use kfree() explicitly.
Patch found using coccinelle.

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 drivers/power/88pm860x_charger.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/power/88pm860x_charger.c b/drivers/power/88pm860x_charger.c
index 4b37a5a..36fb4b5 100644
--- a/drivers/power/88pm860x_charger.c
+++ b/drivers/power/88pm860x_charger.c
@@ -714,7 +714,6 @@ out_irq:
 	while (--i >= 0)
 		free_irq(info->irq[i], info);
 out:
-	kfree(info);
 	return ret;
 }
 
@@ -728,7 +727,6 @@ static int pm860x_charger_remove(struct platform_device *pdev)
 	free_irq(info->irq[0], info);
 	for (i = 0; i < info->irq_nums; i++)
 		free_irq(info->irq[i], info);
-	kfree(info);
 	return 0;
 }
 
-- 
1.7.9.5

