Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3LSPE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:04:26 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:60298 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3LSPEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:04:24 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 10/38] arm: exynos: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:21 +0100
Message-Id: <1387465429-3568-11-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 arch/arm/mach-exynos/common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 61d2906..8b58829 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -407,7 +407,13 @@ early_initcall(exynos4_l2x0_cache_init);
 
 static int __init exynos_init(void)
 {
+	int rc = 0;
+
 	printk(KERN_INFO "EXYNOS: Initializing architecture\n");
 
-	return device_register(&exynos4_dev);
+	rc = device_register(&exynos4_dev);
+	if (rc)
+		put_device(&exynos4_dev);
+	
+	return rc;
 }
-- 
1.8.3.1

