Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab3CISL6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:11:58 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5016 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3CISL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:11:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 09 Mar 2013 10:05:27 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <swarren@wwwdotorg.org>, <rtc-linux@googlegroups.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/5] rtc: tegra: protect suspend/resume callbacks with CONFIG_PM_SLEEP
Date: Sat, 9 Mar 2013 23:39:45 +0530
Message-ID: <1362852588-13362-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com>
References: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com>
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
---
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

