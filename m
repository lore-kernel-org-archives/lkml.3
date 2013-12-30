Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3L3LCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:02:30 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44710 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab3L3LC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:02:28 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: andre.przywara@linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM/cpuidle: remove __init tag from Calxeda cpuidle probe function
Date: Mon, 30 Dec 2013 12:02:24 +0100
Message-Id: <1388401344-14110-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <52C15268.4050403@linaro.org>
References: <52C15268.4050403@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@linaro.org>

Commit 60a66e370007e8535b7a561353b07b37deaf35ba changed the Calxeda
cpuidle driver to a platform driver, copying the __init tag from the
_init() to the newly used _probe() function. However, "probe should
not be __init." (Rob said ;-)
Remove the __init tag to fix a section mismatch in the Calxeda
cpuidle driver.

Signed-off-by: Andre Przywara <andre.przywara@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle-calxeda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-calxeda.c b/drivers/cpuidle/cpuidle-calxeda.c
index 3679563..6e51114 100644
--- a/drivers/cpuidle/cpuidle-calxeda.c
+++ b/drivers/cpuidle/cpuidle-calxeda.c
@@ -65,7 +65,7 @@ static struct cpuidle_driver calxeda_idle_driver = {
 	.state_count = 2,
 };
 
-static int __init calxeda_cpuidle_probe(struct platform_device *pdev)
+static int calxeda_cpuidle_probe(struct platform_device *pdev)
 {
 	return cpuidle_register(&calxeda_idle_driver, NULL);
 }
-- 
1.7.9.5

