Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3ELSCX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 14:02:23 -0400
Received: from smtp-out-236.synserver.de ([212.40.185.236]:1028 "EHLO
	smtp-out-236.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3ELSCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 14:02:22 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 8617
From: Lars-Peter Clausen <lars@metafoo.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] pwm: jz4740: Pass device to clk_get
Date: Sun, 12 May 2013 20:04:49 +0200
Message-Id: <1368381889-3948-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to switching the jz4740 clk driver to the common clk framework
make sure to pass the device to clk_get().

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/pwm/pwm-jz4740.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
index 0a2ede3..a44d890 100644
--- a/drivers/pwm/pwm-jz4740.c
+++ b/drivers/pwm/pwm-jz4740.c
@@ -171,7 +171,7 @@ static int jz4740_pwm_probe(struct platform_device *pdev)
 	if (!jz4740)
 		return -ENOMEM;
 
-	jz4740->clk = clk_get(NULL, "ext");
+	jz4740->clk = clk_get(&pdev->dev, "ext");
 	if (IS_ERR(jz4740->clk))
 		return PTR_ERR(jz4740->clk);
 
-- 
1.8.2.1

