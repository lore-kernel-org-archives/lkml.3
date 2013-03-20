Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab3CTMaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:30:04 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10354 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab3CTMaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:30:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Mar 2013 05:22:17 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>
CC: <swarren@nvidia.com>, <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] drivers/rtc/rtc-tegra.c: fix build warning
Date: Wed, 20 Mar 2013 17:57:02 +0530
Message-ID: <1363782422-32128-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the below build warning:

drivers/rtc/rtc-tegra.c: In function 'tegra_rtc_probe':
drivers/rtc/rtc-tegra.c:353:33: warning: passing argument 1 of 'devm_rtc_device_register' from incompatible pointer type [enabled by default]
include/linux/rtc.h:136:27: note: expected 'struct device *' but argument is of type 'const char *'
drivers/rtc/rtc-tegra.c:353:33: warning: passing argument 2 of 'devm_rtc_device_register' from incompatible pointer type [enabled by default]
include/linux/rtc.h:136:27: note: expected 'const char *' but argument is of type 'struct device *'

This warning was introduced with patch
	commit 8a96d445e921b0d881421767fb6f7c5b6fb91b3a
	drivers/rtc/rtc-tegra.c: use managed rtc_device_register()

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/rtc/rtc-tegra.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 7cb3da0..a34315d 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -349,8 +349,9 @@ static int __init tegra_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = devm_rtc_device_register(dev_name(&pdev->dev),
-				&pdev->dev, &tegra_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register(&pdev->dev,
+				dev_name(&pdev->dev), &tegra_rtc_ops,
+				THIS_MODULE);
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
 		dev_err(&pdev->dev, "Unable to register device (err=%d).\n",
-- 
1.7.1.1

