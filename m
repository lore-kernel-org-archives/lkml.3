Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936112Ab3DKDm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:42:26 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:51146 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758624Ab3DKDmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:42:25 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <haojian.zhuang@gmail.com>, <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>, Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 2/4] ARM: mmp: move function declaration to head file
Date: Thu, 11 Apr 2013 11:37:41 +0800
Message-ID: <1365651463-11502-3-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1365651463-11502-1-git-send-email-zhangwm@marvell.com>
References: <1365651463-11502-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move some of the function declaration to head file.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 arch/arm/mach-mmp/common.h  |    3 +++
 arch/arm/mach-mmp/mmp-dt.c  |    3 ---
 arch/arm/mach-mmp/mmp2-dt.c |    3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-mmp/common.h b/arch/arm/mach-mmp/common.h
index 0bdc50b..8c9b510 100644
--- a/arch/arm/mach-mmp/common.h
+++ b/arch/arm/mach-mmp/common.h
@@ -8,3 +8,6 @@ extern void mmp_restart(char, const char *);
 extern void __init pxa168_clk_init(void);
 extern void __init pxa910_clk_init(void);
 extern void __init mmp2_clk_init(void);
+
+extern void __init mmp_dt_irq_init(void);
+extern void __init mmp_dt_init_timer(void);
diff --git a/arch/arm/mach-mmp/mmp-dt.c b/arch/arm/mach-mmp/mmp-dt.c
index d063efa..af0bb5b 100644
--- a/arch/arm/mach-mmp/mmp-dt.c
+++ b/arch/arm/mach-mmp/mmp-dt.c
@@ -19,9 +19,6 @@
 
 #include "common.h"
 
-extern void __init mmp_dt_irq_init(void);
-extern void __init mmp_dt_init_timer(void);
-
 static const struct of_dev_auxdata pxa168_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
 	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
diff --git a/arch/arm/mach-mmp/mmp2-dt.c b/arch/arm/mach-mmp/mmp2-dt.c
index fad431a..4ba1fbe 100644
--- a/arch/arm/mach-mmp/mmp2-dt.c
+++ b/arch/arm/mach-mmp/mmp2-dt.c
@@ -21,9 +21,6 @@
 
 #include "common.h"
 
-extern void __init mmp_dt_irq_init(void);
-extern void __init mmp_dt_init_timer(void);
-
 static const struct of_dev_auxdata mmp2_auxdata_lookup[] __initconst = {
 	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4030000, "pxa2xx-uart.0", NULL),
 	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.1", NULL),
-- 
1.7.4.1

