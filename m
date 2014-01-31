Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaAaV3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:29:33 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16796 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaAaV3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:29:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 31 Jan 2014 13:27:57 -0800
From: Andrew Chew <achew@nvidia.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <abrestic@chromium.org>,
        <dgreid@chromium.org>, <katierh@chromium.org>
CC: <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Andrew Chew <achew@nvidia.com>
Subject: [PATCH v1] clocksource: tegra: Add nvidia,tegra30-timer compat
Date: Fri, 31 Jan 2014 13:29:39 -0800
Message-ID: <1391203779-5676-1-git-send-email-achew@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some differences between tegra20's timer registers and tegra30's
(and later).  For one thing, the watchdogs don't seem to be present in
tegra20.  Add this compatibility string in order to be able to distinguish
whether the watchdogs are there or not.

Signed-off-by: Andrew Chew <achew@nvidia.com>
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

