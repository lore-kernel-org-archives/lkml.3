Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3BESY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:24:29 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40590 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab3BESY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:24:27 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 4/7] cpufreq: Do not track governor name for scaling drivers with internal governors.
Date: Tue,  5 Feb 2013 10:24:03 -0800
Message-Id: <1360088646-19104-5-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Scaling drivers that implement internal governors do not have governor
structures assocaited with them.  Only track the name of the governor
associated with the CPU if the driver does not implement
cpufreq_driver.setpolicy()

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/cpufreq.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index d8daa4b..622e282 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1050,7 +1050,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
 
 #ifdef CONFIG_HOTPLUG_CPU
-	strncpy(per_cpu(cpufreq_cpu_governor, cpu), data->governor->name,
+	if (!cpufreq_driver->setpolicy)
+		strncpy(per_cpu(cpufreq_cpu_governor, cpu),
+			data->governor->name,
 			CPUFREQ_NAME_LEN);
 #endif
 
-- 
1.7.7.6

