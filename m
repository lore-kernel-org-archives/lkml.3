Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab3FAJo4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:44:56 -0400
Received: from www17.your-server.de ([213.133.104.17]:59303 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab3FAJov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:44:51 -0400
Message-ID: <1370079884.29224.16.camel@localhost.localdomain>
Subject: [PATCH] ARM: OMAP: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: khilman@deeprootsystems.com, tony@atomide.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:44:44 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
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
 
diff -u -p a/arch/arm/mach-omap2/fb.c b/arch/arm/mach-omap2/fb.c
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
diff -u -p a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1678,7 +1678,7 @@ static int __init omap_gpmc_init(void)
 	pdev = omap_device_build(DEVICE_NAME, -1, oh, NULL, 0);
 	WARN(IS_ERR(pdev), "could not build omap_device for %s\n", oh_name);
 
-	return IS_ERR(pdev) ? PTR_ERR(pdev) : 0;
+	return PTR_RET(pdev);
 }
 omap_postcore_initcall(omap_gpmc_init);
 
diff -u -p a/arch/arm/mach-omap2/pmu.c b/arch/arm/mach-omap2/pmu.c
--- a/arch/arm/mach-omap2/pmu.c
+++ b/arch/arm/mach-omap2/pmu.c
@@ -54,10 +54,7 @@ static int __init omap2_init_pmu(unsigne
 	WARN(IS_ERR(omap_pmu_dev), "Can't build omap_device for %s.\n",
 	     dev_name);
 
-	if (IS_ERR(omap_pmu_dev))
-		return PTR_ERR(omap_pmu_dev);
-
-	return 0;
+	return PTR_RET(omap_pmu_dev);
 }
 
 static int __init omap_init_pmu(void)


