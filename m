Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3CJNH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:07:29 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:42554 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3CJNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:07:25 -0400
From: Adrian-Leonard Radu <ady8radu@gmail.com>
To: benh@kernel.crashing.org
Cc: paulus@samba.org, geoff@infradead.org, anton@samba.org,
        cascardo@linux.vnet.ibm.com, akinobu.mita@gmail.com,
        ady8radu@gmail.com, fweisbec@gmail.com, john.stultz@linaro.org,
        rostedt@goodmis.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH] powerpc: Use PTR_RET instead of IS_ERR/PTR_ERR
Date: Sun, 10 Mar 2013 15:07:00 +0200
Message-Id: <1362920820-11073-1-git-send-email-ady8radu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian-Leonard Radu <ady8radu@gmail.com>
---
 arch/powerpc/kernel/iommu.c          |    2 +-
 arch/powerpc/kernel/time.c           |    4 +---
 arch/powerpc/platforms/ps3/time.c    |    4 +---
 arch/powerpc/sysdev/rtc_cmos_setup.c |    5 +----
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 31c4fdc..c0d0dbd 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -102,7 +102,7 @@ static int __init fail_iommu_debugfs(void)
 	struct dentry *dir = fault_create_debugfs_attr("fail_iommu",
 						       NULL, &fail_iommu);
 
-	return IS_ERR(dir) ? PTR_ERR(dir) : 0;
+	return PTR_RET(dir);
 }
 late_initcall(fail_iommu_debugfs);
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index f77fa22..5fc29ad 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -1049,10 +1049,8 @@ static int __init rtc_init(void)
 		return -ENODEV;
 
 	pdev = platform_device_register_simple("rtc-generic", -1, NULL, 0);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
 
-	return 0;
+	return PTR_RET(pdev);
 }
 
 module_init(rtc_init);
diff --git a/arch/powerpc/platforms/ps3/time.c b/arch/powerpc/platforms/ps3/time.c
index 40b5cb4..cba1e6b 100644
--- a/arch/powerpc/platforms/ps3/time.c
+++ b/arch/powerpc/platforms/ps3/time.c
@@ -89,10 +89,8 @@ static int __init ps3_rtc_init(void)
 		return -ENODEV;
 
 	pdev = platform_device_register_simple("rtc-ps3", -1, NULL, 0);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
 
-	return 0;
+	return PTR_RET(pdev);
 }
 
 module_init(ps3_rtc_init);
diff --git a/arch/powerpc/sysdev/rtc_cmos_setup.c b/arch/powerpc/sysdev/rtc_cmos_setup.c
index 9afba92..af79e1e 100644
--- a/arch/powerpc/sysdev/rtc_cmos_setup.c
+++ b/arch/powerpc/sysdev/rtc_cmos_setup.c
@@ -62,10 +62,7 @@ static int  __init add_rtc(void)
 	pd = platform_device_register_simple("rtc_cmos", -1,
 					     &res[0], num_res);
 
-	if (IS_ERR(pd))
-		return PTR_ERR(pd);
-
-	return 0;
+	return PTR_RET(pd);
 }
 fs_initcall(add_rtc);
 
-- 
1.7.10.4

