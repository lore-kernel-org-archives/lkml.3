Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbbAYSOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:14:35 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:52372 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917AbbAYSO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:14:26 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] power/reset: restart-poweroff: Remove arm dependencies
Date: Sun, 25 Jan 2015 10:13:42 -0800
Message-Id: <1422209622-31994-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
References: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54C53281.00F7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 30
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

This driver is now arm specific anymore, so there is no need to include
an arm specific include file. Also drop unnecessary depencency on ARM
from Kconfig.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/Kconfig            | 1 -
 drivers/power/reset/restart-poweroff.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 4b4b910..a4fd2cb 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -104,7 +104,6 @@ config POWER_RESET_QNAP
 
 config POWER_RESET_RESTART
 	bool "Restart power-off driver"
-	depends on ARM
 	help
 	  Some boards don't actually have the ability to power off.
 	  Instead they restart, and u-boot holds the SoC until the
diff --git a/drivers/power/reset/restart-poweroff.c b/drivers/power/reset/restart-poweroff.c
index f46f2c2..41b22c4 100644
--- a/drivers/power/reset/restart-poweroff.c
+++ b/drivers/power/reset/restart-poweroff.c
@@ -16,7 +16,6 @@
 #include <linux/of_platform.h>
 #include <linux/module.h>
 #include <linux/reboot.h>
-#include <asm/system_misc.h>
 
 static void restart_poweroff_do_poweroff(void)
 {
-- 
2.1.0

