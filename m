Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3BOWC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:02:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47889 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab3BOWC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:02:27 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pwm: tegra: assume CONFIG_OF
Date: Fri, 15 Feb 2013 15:02:22 -0700
Message-Id: <1360965742-19744-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Tegra only supports, and always enables, device tree. Remove all ifdefs
for DT support from the driver.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pwm/pwm-tegra.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pwm/pwm-tegra.c b/drivers/pwm/pwm-tegra.c
index 71900e8..af3ab48 100644
--- a/drivers/pwm/pwm-tegra.c
+++ b/drivers/pwm/pwm-tegra.c
@@ -233,7 +233,6 @@ static int tegra_pwm_remove(struct platform_device *pdev)
 	return pwmchip_remove(&pc->chip);
 }
 
-#ifdef CONFIG_OF
 static struct of_device_id tegra_pwm_of_match[] = {
 	{ .compatible = "nvidia,tegra20-pwm" },
 	{ .compatible = "nvidia,tegra30-pwm" },
@@ -241,12 +240,11 @@ static struct of_device_id tegra_pwm_of_match[] = {
 };
 
 MODULE_DEVICE_TABLE(of, tegra_pwm_of_match);
-#endif
 
 static struct platform_driver tegra_pwm_driver = {
 	.driver = {
 		.name = "tegra-pwm",
-		.of_match_table = of_match_ptr(tegra_pwm_of_match),
+		.of_match_table = tegra_pwm_of_match,
 	},
 	.probe = tegra_pwm_probe,
 	.remove = tegra_pwm_remove,
-- 
1.7.10.4

