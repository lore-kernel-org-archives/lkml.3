Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab3BASqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:46:12 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54829 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422636Ab3BASqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:46:06 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 5/6] cpufreq: balance out cpufreq_cpu_{get,put} for scaling drivers using setpolicy
Date: Fri,  1 Feb 2013 10:45:42 -0800
Message-Id: <1359744343-18690-9-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
References: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

There is an additional reference added to the driver in
cpufreq_add_dev_policy() that is removed in__cpufreq_governor() if the
driver implements target().  Remove the last reference when the driver
implements setpolicy()

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/cpufreq/cpufreq.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a4fd51e..ec103bf 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1119,6 +1119,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	if (cpufreq_driver->target)
 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
 
+	if (cpufreq_driver->setpolicy)
+		cpufreq_cpu_put(data);
+
 	kobj = &data->kobj;
 	cmp = &data->kobj_unregister;
 	unlock_policy_rwsem_write(cpu);
-- 
1.7.7.6

