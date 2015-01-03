Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbbACOxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 09:53:35 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:50634 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbbACOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 09:53:33 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] next: microblaze: Fix build failure
Date: Sat,  3 Jan 2015 06:53:20 -0800
Message-Id: <1420296800-17045-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54A80276.0082,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

Microblaze build in linux-next fails with

arch/microblaze/kernel/timer.c:224:2: error:
	implicit declaration of function 'timecounter_init'

Caused by missing include file in microblaze timer code.

Fixes: 74d23cc704d1 ("time: move the timecounter/cyclecounter code into its own file")
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/microblaze/kernel/timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index dd96f0e..c897745 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -17,6 +17,7 @@
 #include <linux/clockchips.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/timecounter.h>
 #include <asm/cpuinfo.h>
 
 static void __iomem *timer_baseaddr;
-- 
2.1.0

