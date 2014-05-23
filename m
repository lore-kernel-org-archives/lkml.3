Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaEWKe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:34:26 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:43827 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbaEWKdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:33:00 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 67/71] clocksource: sh_mtu2: Remove unnecessary OOM messages
Date: Fri, 23 May 2014 12:31:47 +0200
Message-Id: <1400841111-6683-67-git-send-email-daniel.lezcano@linaro.org>
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
 drivers/clocksource/sh_mtu2.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index f2c1c36..188d4e0 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -533,10 +533,8 @@ static int sh_mtu2_probe(struct platform_device *pdev)
 	}
 
 	mtu = kzalloc(sizeof(*mtu), GFP_KERNEL);
-	if (mtu == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	if (mtu == NULL)
 		return -ENOMEM;
-	}
 
 	ret = sh_mtu2_setup(mtu, pdev);
 	if (ret) {
-- 
1.7.9.5

