Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3CKIrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:47:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14492 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3CKIrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:47:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 11 Mar 2013 01:46:39 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <swarren@wwwdotorg.org>, <rtc-linux@googlegroups.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <thierry.reding@avionic-design.de>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/5] rtc: tegra: protect suspend/resume callbacks with CONFIG_PM_SLEEP
Date: Mon, 11 Mar 2013 14:14:24 +0530
Message-ID: <1362991468-30226-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1362991468-30226-1-git-send-email-ldewangan@nvidia.com>
References: <1362991468-30226-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_PM doesn't actually enable any of the PM callbacks, it
only allows to enable CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.
This means if CONFIG_PM is used to protect system sleep callbacks
then it may end up unreferenced if only runtime PM is enabled.
Hence protecting sleep callbacks with CONFIG_PM_SLEEP.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes from V1:
- Add Thierry's reviewed by.
- No Change in code.

 drivers/rtc/rtc-tegra.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 0020bab..d64cde6 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -390,7 +390,7 @@ static int __exit tegra_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int tegra_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct device *dev = &pdev->dev;
@@ -446,7 +446,7 @@ static struct platform_driver tegra_rtc_driver = {
 		.owner	= THIS_MODULE,
 		.of_match_table = tegra_rtc_dt_match,
 	},
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.suspend	= tegra_rtc_suspend,
 	.resume		= tegra_rtc_resume,
 #endif
-- 
1.7.1.1

