Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968370Ab3DSQUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:20:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29423 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967761Ab3DSQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:19:51 -0400
X-IronPort-AV: E=Sophos;i="4.87,510,1363158000"; 
   d="scan'208";a="39797396"
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv5 09/11] clocksource: time-armada-370-xp: Fix sparse warning
Date: Fri, 19 Apr 2013 09:19:43 -0700
Message-Id: <1366388385-30722-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.392.g85e7e81
In-Reply-To: <1366388385-30722-1-git-send-email-sboyd@codeaurora.org>
References: <1366388385-30722-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/clocksource/time-armada-370-xp.c:217:13: warning: symbol
'armada_370_xp_timer_init' was not declared. Should it be static?

Also remove the __init marking in the prototype as it's
unnecessary and drop the init.h file.

Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/time-armada-370-xp.c | 3 ++-
 include/linux/time-armada-370-xp.h       | 4 +---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 47a6730..efe4aef 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -27,10 +27,11 @@
 #include <linux/of_address.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/time-armada-370-xp.h>
 
 #include <asm/sched_clock.h>
 #include <asm/localtimer.h>
-#include <linux/percpu.h>
 /*
  * Timer block registers.
  */
diff --git a/include/linux/time-armada-370-xp.h b/include/linux/time-armada-370-xp.h
index dfdfdc0..6fb0856 100644
--- a/include/linux/time-armada-370-xp.h
+++ b/include/linux/time-armada-370-xp.h
@@ -11,8 +11,6 @@
 #ifndef __TIME_ARMADA_370_XPPRCMU_H
 #define __TIME_ARMADA_370_XPPRCMU_H
 
-#include <linux/init.h>
-
-void __init armada_370_xp_timer_init(void);
+void armada_370_xp_timer_init(void);
 
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

