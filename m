Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162611AbaDCIIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:08:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59822 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1162553AbaDCIIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:08:20 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ARM: berlin: use CPU_METHOD_OF_DECLARE for smp
Date: Thu,  3 Apr 2014 10:08:14 +0200
Message-Id: <1396512496-8030-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396512496-8030-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1396512496-8030-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the smp ops in the machine descriptor and select the cpu
enable method in the device tree.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/mach-berlin/berlin.c  | 1 -
 arch/arm/mach-berlin/common.h  | 2 --
 arch/arm/mach-berlin/platsmp.c | 3 ++-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-berlin/berlin.c b/arch/arm/mach-berlin/berlin.c
index 1bbca793174d..3cc3e706719e 100644
--- a/arch/arm/mach-berlin/berlin.c
+++ b/arch/arm/mach-berlin/berlin.c
@@ -38,5 +38,4 @@ static const char * const berlin_dt_compat[] = {
 DT_MACHINE_START(BERLIN_DT, "Marvell Berlin")
 	.dt_compat	= berlin_dt_compat,
 	.init_machine	= berlin_init_machine,
-	.smp		= smp_ops(berlin_smp_ops),
 MACHINE_END
diff --git a/arch/arm/mach-berlin/common.h b/arch/arm/mach-berlin/common.h
index 57c97669af0a..8d585e2481f9 100644
--- a/arch/arm/mach-berlin/common.h
+++ b/arch/arm/mach-berlin/common.h
@@ -13,6 +13,4 @@
 
 extern void berlin_secondary_startup(void);
 
-extern struct smp_operations berlin_smp_ops;
-
 #endif
diff --git a/arch/arm/mach-berlin/platsmp.c b/arch/arm/mach-berlin/platsmp.c
index 5c83941b0918..86fe697577fd 100644
--- a/arch/arm/mach-berlin/platsmp.c
+++ b/arch/arm/mach-berlin/platsmp.c
@@ -132,8 +132,9 @@ static void __init berlin_smp_prepare_cpus(unsigned int max_cpus)
 	iounmap(gpr_base);
 }
 
-struct smp_operations berlin_smp_ops __initdata = {
+static struct smp_operations berlin_smp_ops __initdata = {
 	.smp_prepare_cpus	= berlin_smp_prepare_cpus,
 	.smp_secondary_init	= berlin_secondary_init,
 	.smp_boot_secondary	= berlin_boot_secondary,
 };
+CPU_METHOD_OF_DECLARE(berlin_smp, "marvell,88de31-smp", &berlin_smp_ops);
-- 
1.8.3.2

