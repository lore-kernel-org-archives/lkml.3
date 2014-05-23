Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaEWKel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:34:41 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51967 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaEWKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:59 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 66/71] clocksource: sh_cmt: Remove unnecessary OOM messages
Date: Fri, 23 May 2014 12:31:46 +0200
Message-Id: <1400841111-6683-66-git-send-email-daniel.lezcano@linaro.org>
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
 drivers/clocksource/sh_cmt.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index bc8d025..dfa7803 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -1106,10 +1106,8 @@ static int sh_cmt_probe(struct platform_device *pdev)
 	}
 
 	cmt = kzalloc(sizeof(*cmt), GFP_KERNEL);
-	if (cmt == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	if (cmt == NULL)
 		return -ENOMEM;
-	}
 
 	ret = sh_cmt_setup(cmt, pdev);
 	if (ret) {
-- 
1.7.9.5

