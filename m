Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966157Ab3DQRVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:21:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53702 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965409Ab3DQRVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:21:15 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <amit.kachhap@linaro.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/30] thermal: cpu_cooling: use snprintf instead of sprintf
Date: Wed, 17 Apr 2013 13:12:17 -0400
Message-ID: <1366218743-20841-25-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the amount of bytes written to dev_name by
secure writing with snprintf.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index b55cfc2..b1f9a4d 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -465,7 +465,8 @@ cpufreq_cooling_register(const struct cpumask *clip_cpus)
 		return ERR_PTR(-EINVAL);
 	}
 
-	sprintf(dev_name, "thermal-cpufreq-%d", cpufreq_dev->id);
+	snprintf(dev_name, sizeof(dev_name), "thermal-cpufreq-%d",
+		 cpufreq_dev->id);
 
 	cool_dev = thermal_cooling_device_register(dev_name, cpufreq_dev,
 						   &cpufreq_cooling_ops);
-- 
1.8.2.1.342.gfa7285d

