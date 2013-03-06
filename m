Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3CFVTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 16:19:13 -0500
Received: from st11p00mm-asmtpout003.mac.com ([17.172.81.2]:49274 "EHLO
	st11p00mm-asmtp003.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551Ab3CFVTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 16:19:12 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Mar 2013 16:19:11 EST
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-03-06_05:2013-03-06,2013-03-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=4 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1212290000
 definitions=main-1303060181
From: Martin Knoll <martinknoll@me.com>
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Knoll <martinknoll@me.com>
Subject: [PATCH] ARM: LPC32xx: changed lpc23xx_restart to lpc32xx_restart
Date: Wed, 06 Mar 2013 21:18:58 +0100
Message-id: <1362601138-16550-1-git-send-email-martinknoll@me.com>
X-Mailer: git-send-email 1.7.12.4 (Apple Git-37)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function has an odd name. This is probably a typo.
---
 arch/arm/mach-lpc32xx/common.c  | 2 +-
 arch/arm/mach-lpc32xx/common.h  | 2 +-
 arch/arm/mach-lpc32xx/phy3250.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-lpc32xx/common.c b/arch/arm/mach-lpc32xx/common.c
index 0d4db8c..20c0ed7 100644
--- a/arch/arm/mach-lpc32xx/common.c
+++ b/arch/arm/mach-lpc32xx/common.c
@@ -207,7 +207,7 @@ void __init lpc32xx_map_io(void)
 	iotable_init(lpc32xx_io_desc, ARRAY_SIZE(lpc32xx_io_desc));
 }
 
-void lpc23xx_restart(char mode, const char *cmd)
+void lpc32xx_restart(char mode, const char *cmd)
 {
 	switch (mode) {
 	case 's':
diff --git a/arch/arm/mach-lpc32xx/common.h b/arch/arm/mach-lpc32xx/common.h
index e0b2606..5d90469 100644
--- a/arch/arm/mach-lpc32xx/common.h
+++ b/arch/arm/mach-lpc32xx/common.h
@@ -29,7 +29,7 @@ extern void lpc32xx_timer_init(void);
 extern void __init lpc32xx_init_irq(void);
 extern void __init lpc32xx_map_io(void);
 extern void __init lpc32xx_serial_init(void);
-extern void lpc23xx_restart(char, const char *);
+extern void lpc32xx_restart(char, const char *);
 
 
 /*
diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index c1cd5a9..16e5b58 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -266,5 +266,5 @@ DT_MACHINE_START(LPC32XX_DT, "LPC32XX SoC (Flattened Device Tree)")
 	.init_time	= lpc32xx_timer_init,
 	.init_machine	= lpc3250_machine_init,
 	.dt_compat	= lpc32xx_dt_compat,
-	.restart	= lpc23xx_restart,
+	.restart	= lpc32xx_restart,
 MACHINE_END
-- 
1.7.12.4 (Apple Git-37)

