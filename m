Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaKFQsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:48:22 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56594 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaKFQp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:45:26 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        linux-sh@vger.kernel.org
Subject: [PATCH v5 42/48] sh: Register with kernel power-off handler
Date: Thu,  6 Nov 2014 08:43:26 -0800
Message-Id: <1415292213-28652-43-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.545BA5A6.01D4,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 240
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel power-off handler instead of setting pm_power_off
directly.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v5:
- Rebase to v3.18-rc3
v4:
- No change
v3:
- Replace poweroff in all newly introduced variables and in text
  with power_off or power-off as appropriate
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
v2:
- Use defines to specify poweroff handler priorities

 arch/sh/boards/board-sh7785lcr.c       | 3 ++-
 arch/sh/boards/board-urquell.c         | 3 ++-
 arch/sh/boards/mach-highlander/setup.c | 3 ++-
 arch/sh/boards/mach-landisk/setup.c    | 3 ++-
 arch/sh/boards/mach-r2d/setup.c        | 3 ++-
 arch/sh/boards/mach-sdk7786/setup.c    | 3 ++-
 6 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/sh/boards/board-sh7785lcr.c b/arch/sh/boards/board-sh7785lcr.c
index 2c4771e..f7d2ffb 100644
--- a/arch/sh/boards/board-sh7785lcr.c
+++ b/arch/sh/boards/board-sh7785lcr.c
@@ -332,7 +332,8 @@ static void __init sh7785lcr_setup(char **cmdline_p)
 
 	printk(KERN_INFO "Renesas Technology Corp. R0P7785LC0011RL support.\n");
 
-	pm_power_off = sh7785lcr_power_off;
+	register_power_off_handler_simple(sh7785lcr_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	/* sm501 DRAM configuration */
 	sm501_reg = ioremap_nocache(SM107_REG_ADDR, SM501_DRAM_CONTROL);
diff --git a/arch/sh/boards/board-urquell.c b/arch/sh/boards/board-urquell.c
index b52abcc..8f44256 100644
--- a/arch/sh/boards/board-urquell.c
+++ b/arch/sh/boards/board-urquell.c
@@ -204,7 +204,8 @@ static void __init urquell_setup(char **cmdline_p)
 {
 	printk(KERN_INFO "Renesas Technology Corp. Urquell support.\n");
 
-	pm_power_off = urquell_power_off;
+	register_power_off_handler_simple(urquell_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	register_smp_ops(&shx3_smp_ops);
 }
diff --git a/arch/sh/boards/mach-highlander/setup.c b/arch/sh/boards/mach-highlander/setup.c
index 4a52590..fc9110a 100644
--- a/arch/sh/boards/mach-highlander/setup.c
+++ b/arch/sh/boards/mach-highlander/setup.c
@@ -385,7 +385,8 @@ static void __init highlander_setup(char **cmdline_p)
 
 	__raw_writew(__raw_readw(PA_IVDRCTL) | 0x01, PA_IVDRCTL);	/* Si13112 */
 
-	pm_power_off = r7780rp_power_off;
+	register_power_off_handler_simple(r7780rp_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 }
 
 static unsigned char irl2irq[HL_NR_IRL];
diff --git a/arch/sh/boards/mach-landisk/setup.c b/arch/sh/boards/mach-landisk/setup.c
index f1147ca..56adabc 100644
--- a/arch/sh/boards/mach-landisk/setup.c
+++ b/arch/sh/boards/mach-landisk/setup.c
@@ -89,7 +89,8 @@ static void __init landisk_setup(char **cmdline_p)
 	__raw_writeb(__raw_readb(PA_LED) | 0x03, PA_LED);
 
 	printk(KERN_INFO "I-O DATA DEVICE, INC. \"LANDISK Series\" support.\n");
-	pm_power_off = landisk_power_off;
+	register_power_off_handler_simple(landisk_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 }
 
 /*
diff --git a/arch/sh/boards/mach-r2d/setup.c b/arch/sh/boards/mach-r2d/setup.c
index 4b98a52..4a23bce 100644
--- a/arch/sh/boards/mach-r2d/setup.c
+++ b/arch/sh/boards/mach-r2d/setup.c
@@ -279,7 +279,8 @@ static void __init rts7751r2d_setup(char **cmdline_p)
 					(ver >> 4) & 0xf, ver & 0xf);
 
 	__raw_writew(0x0000, PA_OUTPORT);
-	pm_power_off = rts7751r2d_power_off;
+	register_power_off_handler_simple(rts7751r2d_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	/* sm501 dram configuration:
 	 * ColSizeX = 11 - External Memory Column Size: 256 words.
diff --git a/arch/sh/boards/mach-sdk7786/setup.c b/arch/sh/boards/mach-sdk7786/setup.c
index c29268b..2d77760 100644
--- a/arch/sh/boards/mach-sdk7786/setup.c
+++ b/arch/sh/boards/mach-sdk7786/setup.c
@@ -252,7 +252,8 @@ static void __init sdk7786_setup(char **cmdline_p)
 	pr_info("\tPCB revision:\t%d\n", fpga_read_reg(PCBRR) & 0xf);
 
 	machine_ops.restart = sdk7786_restart;
-	pm_power_off = sdk7786_power_off;
+	register_power_off_handler_simple(sdk7786_power_off,
+					  POWER_OFF_PRIORITY_DEFAULT);
 
 	register_smp_ops(&shx3_smp_ops);
 }
-- 
1.9.1

