Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaEWKdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:33:52 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38592 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaEWKdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:33:01 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 68/71] clocksource: sh_tmu: Remove unnecessary OOM messages
Date: Fri, 23 May 2014 12:31:48 +0200
Message-Id: <1400841111-6683-68-git-send-email-daniel.lezcano@linaro.org>
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

[dlezcano] : refreshed against latest modifications: kmalloc -> kzalloc

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/sh_tmu.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 4ba2c0f..a38022f 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -644,10 +644,8 @@ static int sh_tmu_probe(struct platform_device *pdev)
 	}
 
 	tmu = kzalloc(sizeof(*tmu), GFP_KERNEL);
-	if (tmu == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	if (tmu == NULL)
 		return -ENOMEM;
-	}
 
 	ret = sh_tmu_setup(tmu, pdev);
 	if (ret) {
-- 
1.7.9.5

