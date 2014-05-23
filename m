Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaEWKdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:33:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34185 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaEWKc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:58 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 65/71] clocksource: em_sti: Remove unnecessary OOM messages
Date: Fri, 23 May 2014 12:31:45 +0200
Message-Id: <1400841111-6683-65-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jingoo Han <jg1.han@samsung.com>

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/em_sti.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
index 9d17083..d0a7bd6 100644
--- a/drivers/clocksource/em_sti.c
+++ b/drivers/clocksource/em_sti.c
@@ -318,10 +318,8 @@ static int em_sti_probe(struct platform_device *pdev)
 	int irq;
 
 	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
-	if (p == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	if (p == NULL)
 		return -ENOMEM;
-	}
 
 	p->pdev = pdev;
 	platform_set_drvdata(pdev, p);
-- 
1.7.9.5

