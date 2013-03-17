Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3CQGSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 02:18:49 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:47396 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3CQGSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 02:18:48 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, dwmw2@infradead.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] power: 88pm860x: fix invalid free of devm_* allocated data
Date: Sun, 17 Mar 2013 08:18:43 +0200
Message-Id: <1363501123-14350-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The objects allocated by devm_* APIs are managed by devres and are freed
when the device is detached. There is no need to use kfree() explicitly.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/power/88pm860x_charger.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/power/88pm860x_charger.c b/drivers/power/88pm860x_charger.c
index 4b37a5a..d7ceeac 100644
--- a/drivers/power/88pm860x_charger.c
+++ b/drivers/power/88pm860x_charger.c
@@ -714,7 +714,6 @@ out_irq:
 	while (--i >= 0)
 		free_irq(info->irq[i], info);
 out:
-	kfree(info);
 	return ret;
 }
 
-- 
1.7.9.5

