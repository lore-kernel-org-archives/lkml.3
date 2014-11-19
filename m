Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaKSKSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:18:07 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64278 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbaKSKSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:18:04 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: Lorenzo.Pieralisi@arm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] drivers: cpuidle: Remove cpuidle-arm64 duplicate error messages
Date: Wed, 19 Nov 2014 11:17:58 +0100
Message-Id: <1416392278-18397-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416392278-18397-1-git-send-email-daniel.lezcano@linaro.org>
References: <546C6DEB.8060204@linaro.org>
 <1416392278-18397-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

Current CPUidle driver for arm64 machines spits errors upon idle
state initialization and cpuidle driver registration failures.
These error messages are already printed in core code so there is
no need to print them again.

This patch removes the duplicate print messages from the cpuidle-arm64
driver.

Acked-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle-arm64.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-arm64.c b/drivers/cpuidle/cpuidle-arm64.c
index 50997ea..1b10f92e 100644
--- a/drivers/cpuidle/cpuidle-arm64.c
+++ b/drivers/cpuidle/cpuidle-arm64.c
@@ -104,11 +104,8 @@ static int __init arm64_idle_init(void)
 	 * reason to initialize the idle driver if only wfi is supported.
 	 */
 	ret = dt_init_idle_driver(drv, arm64_idle_state_match, 1);
-	if (ret <= 0) {
-		if (ret)
-			pr_err("failed to initialize idle states\n");
+	if (ret <= 0)
 		return ret ? : -ENODEV;
-	}
 
 	/*
 	 * Call arch CPU operations in order to initialize
@@ -122,12 +119,6 @@ static int __init arm64_idle_init(void)
 		}
 	}
 
-	ret = cpuidle_register(drv, NULL);
-	if (ret) {
-		pr_err("failed to register cpuidle driver\n");
-		return ret;
-	}
-
-	return 0;
+	return cpuidle_register(drv, NULL);
 }
 device_initcall(arm64_idle_init);
-- 
1.9.1

