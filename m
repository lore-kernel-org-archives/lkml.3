Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaAUKKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:10:52 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7029 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbaAUKKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:10:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 21 Jan 2014 02:10:05 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 5/5] ARM: tegra: cpuidle: use firmware call for power down
Date: Tue, 21 Jan 2014 19:10:16 +0900
Message-ID: <1390299016-14105-6-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invoke the do_idle() firmware call before suspending a CPU so that the
underlying firmware (if any) can take necessary action.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/mach-tegra/cpuidle-tegra114.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c
index e0b87300243d..c42fd41065d2 100644
--- a/arch/arm/mach-tegra/cpuidle-tegra114.c
+++ b/arch/arm/mach-tegra/cpuidle-tegra114.c
@@ -19,6 +19,7 @@
 #include <linux/cpuidle.h>
 #include <linux/cpu_pm.h>
 #include <linux/clockchips.h>
+#include <asm/firmware.h>
 
 #include <asm/cpuidle.h>
 #include <asm/suspend.h>
@@ -45,6 +46,8 @@ static int tegra114_idle_power_down(struct cpuidle_device *dev,
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
 
+	call_firmware_op(do_idle);
+
 	cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
-- 
1.8.5.3

