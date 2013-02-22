Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3BVH14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:27:56 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36429 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3BVH1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:27:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,713,1355126400"; 
   d="scan'208";a="26425029"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 6/8] clocksource: time-armada-370-xp: Fix sparse warning
Date: Thu, 21 Feb 2013 23:27:17 -0800
Message-Id: <1361518039-16663-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc0.16.g20a599e
In-Reply-To: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
References: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/clocksource/time-armada-370-xp.c:217:13: warning: symbol
'armada_370_xp_timer_init' was not declared. Should it be static?

Also remove the __init marking in the prototype as it's
unnecessary and drop the init.h file.

Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
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

