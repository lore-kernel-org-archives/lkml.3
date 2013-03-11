Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3CKIrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:47:15 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4359 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3CKIrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:47:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 11 Mar 2013 01:46:44 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <swarren@wwwdotorg.org>, <rtc-linux@googlegroups.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <thierry.reding@avionic-design.de>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 3/5] rtc: tegra: use module_platform_driver_probe for module init/exit
Date: Mon, 11 Mar 2013 14:14:26 +0530
Message-ID: <1362991468-30226-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1362991468-30226-1-git-send-email-ldewangan@nvidia.com>
References: <1362991468-30226-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macro module_platform_driver_probe() to reduce some of the
boilerplate code in the driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes from V1:
- Add Thierry's reviewed by.
- No change in code.

 drivers/rtc/rtc-tegra.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 6373eb7..c382542 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -450,17 +450,7 @@ static struct platform_driver tegra_rtc_driver = {
 	},
 };
 
-static int __init tegra_rtc_init(void)
-{
-	return platform_driver_probe(&tegra_rtc_driver, tegra_rtc_probe);
-}
-module_init(tegra_rtc_init);
-
-static void __exit tegra_rtc_exit(void)
-{
-	platform_driver_unregister(&tegra_rtc_driver);
-}
-module_exit(tegra_rtc_exit);
+module_platform_driver_probe(tegra_rtc_driver, tegra_rtc_probe);
 
 MODULE_AUTHOR("Jon Mayo <jmayo@nvidia.com>");
 MODULE_DESCRIPTION("driver for Tegra internal RTC");
-- 
1.7.1.1

