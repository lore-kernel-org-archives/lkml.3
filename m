Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab3CISMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:12:05 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5024 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab3CISMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:12:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 09 Mar 2013 10:05:34 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <swarren@wwwdotorg.org>, <rtc-linux@googlegroups.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/5] rtc: tegra: set irq name as device name
Date: Sat, 9 Mar 2013 23:39:48 +0530
Message-ID: <1362852588-13362-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com>
References: <1362852588-13362-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When watching the irq name of tegra rtc, it shows as "rtc alarm"
which actually does not reflect the name related to driver.

Passing the device name to have the irq names with driver name.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/rtc/rtc-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 4cba10d..8186405 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -361,7 +361,7 @@ static int __init tegra_rtc_probe(struct platform_device *pdev)
 
 	ret = devm_request_irq(&pdev->dev, info->tegra_rtc_irq,
 			tegra_rtc_irq_handler, IRQF_TRIGGER_HIGH,
-			"rtc alarm", &pdev->dev);
+			dev_name(&pdev->dev), &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev,
 			"Unable to request interrupt for device (err=%d).\n",
-- 
1.7.1.1

