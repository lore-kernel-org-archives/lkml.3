Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaKGAWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 19:22:01 -0500
Received: from mail-pd0-f201.google.com ([209.85.192.201]:59065 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaKGAV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 19:21:59 -0500
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: pdeschrijver@nvidia.com, swarren@nvidia.com
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
        Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH] clocksource: tegra: Port tegra20 clocksource to arm64
Date: Thu,  6 Nov 2014 16:21:54 -0800
Message-Id: <1415319715-21757-1-git-send-email-anatol.pomozov@gmail.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register_persistent_clock() are in different headers in arm/arm64

Tested: Compiled the driver on 64bit platform and make sure that
it works

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 drivers/clocksource/tegra20_timer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
index d2616ef..e0123c7 100644
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -29,8 +29,12 @@
 #include <linux/sched_clock.h>
 #include <linux/delay.h>
 
+#ifdef CONFIG_ARM64
+#include <asm/time.h>
+#else
 #include <asm/mach/time.h>
 #include <asm/smp_twd.h>
+#endif
 
 #define RTC_SECONDS            0x08
 #define RTC_SHADOW_SECONDS     0x0c
-- 
2.1.0.rc2.206.gedb03e5

