Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab3CLH6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 03:58:35 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58500 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab3CLH6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 03:58:34 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk, khilman@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] mach_omap2: use PTR_RET instead of IS_ERR + PTR_ERR
Date: Tue, 12 Mar 2013 09:58:29 +0200
Message-Id: <1363075109-27038-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses PTR_RET instead of IS_ERR and PTR_ERR in order to increase
readability.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 arch/arm/mach-omap2/devices.c |    4 ++--
 arch/arm/mach-omap2/fb.c      |    5 +----
 arch/arm/mach-omap2/gpmc.c    |    2 +-
 arch/arm/mach-omap2/pmu.c     |    5 +----
 4 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 1ec7f05..2a0816e 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -66,7 +66,7 @@ static int __init omap3_l3_init(void)
 
 	WARN(IS_ERR(pdev), "could not build omap_device for %s\n", oh_name);
 
-	return IS_ERR(pdev) ? PTR_ERR(pdev) : 0;
+	return PTR_RET(pdev);
 }
 omap_postcore_initcall(omap3_l3_init);
 
@@ -100,7 +100,7 @@ static int __init omap4_l3_init(void)
 
 	WARN(IS_ERR(pdev), "could not build omap_device for %s\n", oh_name);
 
-	return IS_ERR(pdev) ? PTR_ERR(pdev) : 0;
+	return PTR_RET(pdev);
 }
 omap_postcore_initcall(omap4_l3_init);
 
diff --git a/arch/arm/mach-omap2/fb.c b/arch/arm/mach-omap2/fb.c
index 190ae49..2ca33cc 100644
--- a/arch/arm/mach-omap2/fb.c
+++ b/arch/arm/mach-omap2/fb.c
@@ -83,10 +83,7 @@ static int __init omap_init_vrfb(void)
 	pdev = platform_device_register_resndata(NULL, "omapvrfb", -1,
 			res, num_res, NULL, 0);
 
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
-	else
-		return 0;
+	return PTR_RET(pdev);
 }
 
 omap_arch_initcall(omap_init_vrfb);
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 410e1ba..c665721 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1448,7 +1448,7 @@ static int __init omap_gpmc_init(void)
 	pdev = omap_device_build(DEVICE_NAME, -1, oh, NULL, 0);
 	WARN(IS_ERR(pdev), "could not build omap_device for %s\n", oh_name);
 
-	return IS_ERR(pdev) ? PTR_ERR(pdev) : 0;
+	return PTR_RET(pdev);
 }
 omap_postcore_initcall(omap_gpmc_init);
 
diff --git a/arch/arm/mach-omap2/pmu.c b/arch/arm/mach-omap2/pmu.c
index 9debf82..13ff2f5 100644
--- a/arch/arm/mach-omap2/pmu.c
+++ b/arch/arm/mach-omap2/pmu.c
@@ -52,10 +52,7 @@ static int __init omap2_init_pmu(unsigned oh_num, char *oh_names[])
 	WARN(IS_ERR(omap_pmu_dev), "Can't build omap_device for %s.\n",
 	     dev_name);
 
-	if (IS_ERR(omap_pmu_dev))
-		return PTR_ERR(omap_pmu_dev);
-
-	return 0;
+	return PTR_RET(omap_pmu_dev);
 }
 
 static int __init omap_init_pmu(void)
-- 
1.7.9.5

