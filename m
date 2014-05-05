Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbaEEV3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:29:25 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:53403 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbaEEV3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:29:23 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH] pwm: spear: fix check on pwmchip_add() return value
Date: Mon,  5 May 2014 23:29:00 +0200
Message-Id: <1399325340-20416-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pwmchip_add() returns zero on success and a negative value on error,
so the condition of the check must be inverted.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 drivers/pwm/pwm-spear.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index cb2d4f0..945556d 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -222,7 +222,7 @@ static int spear_pwm_probe(struct platform_device *pdev)
 	}
 
 	ret = pwmchip_add(&pc->chip);
-	if (!ret) {
+	if (ret < 0) {
 		clk_unprepare(pc->clk);
 		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
 	}
-- 
1.7.10.4

