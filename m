Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122Ab3DHV1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:27:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41245 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936265Ab3DHV1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:27:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,433,1363158000"; 
   d="scan'208";a="36848521"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCHv4 09/11] clocksource: time-armada-370-xp: Fix sparse warning
Date: Mon,  8 Apr 2013 14:27:31 -0700
Message-Id: <1365456453-16297-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365456453-16297-1-git-send-email-sboyd@codeaurora.org>
References: <1365456453-16297-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/clocksource/time-armada-370-xp.c:217:13: warning: symbol
'armada_370_xp_timer_init' was not declared. Should it be static?

Also remove the __init marking in the prototype as it's
unnecessary along with the init.h include.

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

