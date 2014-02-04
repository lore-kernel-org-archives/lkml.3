Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaBDARK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 19:17:10 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2528 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbaBDARC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 19:17:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 03 Feb 2014 16:15:38 -0800
From: Andrew Chew <achew@nvidia.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <rob@landley.net>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <abrestic@chromium.org>, <dgreid@chromium.org>, <katierh@chromium.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH v2 1/3] clocksource: tegra: Add nvidia,tegra30-timer compat
Date: Mon, 3 Feb 2014 16:17:33 -0800
Message-ID: <1391473055-3158-2-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1391473055-3158-1-git-send-email-achew@nvidia.com>
References: <1391473055-3158-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some differences between tegra20's timer registers and tegra30's
(and later).  For example, tegra30 has more timers.  In addition, watchdogs
are not present in tegra20.

Add this compatibility string in order to be able to distinguish
whether the additional timers and watchdogs are there or not.

Signed-off-by: Andrew Chew <achew@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/clocksource/tegra20_timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
index d1869f0..73cfa56 100644
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -218,6 +218,7 @@ static void __init tegra20_init_timer(struct device_node *np)
 					0x1, 0x1fffffff);
 }
 CLOCKSOURCE_OF_DECLARE(tegra20_timer, "nvidia,tegra20-timer", tegra20_init_timer);
+CLOCKSOURCE_OF_DECLARE(tegra30_timer, "nvidia,tegra30-timer", tegra20_init_timer);
 
 static void __init tegra20_init_rtc(struct device_node *np)
 {
-- 
1.8.1.5

