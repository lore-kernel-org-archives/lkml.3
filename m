Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbaCaSOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:14:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39198 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbaCaSO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:14:28 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] Input: pmic8xxx-pwrkey - Set sane default for debounce time
Date: Mon, 31 Mar 2014 11:14:24 -0700
Message-Id: <1396289664-31893-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the debounce time is 0 our usage of ilog2() later on in this
driver will cause undefined behavior. If CONFIG_OF=n this fact is
evident to the compiler, and it emits a call to ____ilog2_NaN()
which doesn't exist. Fix this by setting a sane default for
debounce.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/input/misc/pmic8xxx-pwrkey.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
index 1cb8fda7a166..27add04676e1 100644
--- a/drivers/input/misc/pmic8xxx-pwrkey.c
+++ b/drivers/input/misc/pmic8xxx-pwrkey.c
@@ -92,7 +92,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
 	bool pull_up;
 
 	if (of_property_read_u32(pdev->dev.of_node, "debounce", &kpd_delay))
-		kpd_delay = 0;
+		kpd_delay = 15625;
 
 	pull_up = of_property_read_bool(pdev->dev.of_node, "pull-up");
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

