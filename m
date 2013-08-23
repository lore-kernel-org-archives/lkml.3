Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab3HWWD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 18:03:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32912 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab3HWWD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 18:03:57 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <linux-pm@vger.kernel.org>, <rui.zhang@intel.com>
CC: <linux-kernel@vger.kernel.org>, Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 5/5] drivers: thermal: add check when unregistering cpu cooling
Date: Fri, 23 Aug 2013 18:03:16 -0400
Message-ID: <1377295396-17289-6-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1377295396-17289-1-git-send-email-eduardo.valentin@ti.com>
References: <1377295396-17289-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch avoids NULL pointer accesses while unregistering
cpu cooling devices, in case a NULL pointer is received.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 82e15db..429a98c 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -496,8 +496,12 @@ EXPORT_SYMBOL_GPL(cpufreq_cooling_register);
  */
 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 {
-	struct cpufreq_cooling_device *cpufreq_dev = cdev->devdata;
+	struct cpufreq_cooling_device *cpufreq_dev;
 
+	if (!cdev)
+		return;
+
+	cpufreq_dev = cdev->devdata;
 	mutex_lock(&cooling_cpufreq_lock);
 	cpufreq_dev_count--;
 
-- 
1.8.2.1.342.gfa7285d

