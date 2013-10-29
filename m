Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3J2LCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:02:00 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:54923 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3J2LB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:01:58 -0400
Subject: [PATCH V7 3/7] pseries/cpuidle: Make pseries_idle backend driver a
 non-module.
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: daniel.lezcano@linaro.org, michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com
Date: Tue, 29 Oct 2013 16:31:36 +0530
Message-ID: <20131029110134.31547.86550.stgit@deepthi.in.ibm.com>
In-Reply-To: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com>
References: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102911-5816-0000-0000-00000AA10E69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently pseries_idle cpuidle backend driver cannot be
built as a module due to dependencies. Therefore the driver has
to be built in. The dependency is around update_snooze_delay() defined
in cpuidle driver and called from kernel/sysfs.c.
This patch is removes all the module related code.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle-ibm-power.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
index faf8cc1..8c9e42c 100644
--- a/drivers/cpuidle/cpuidle-ibm-power.c
+++ b/drivers/cpuidle/cpuidle-ibm-power.c
@@ -292,17 +292,4 @@ static int __init pseries_processor_idle_init(void)
 	return 0;
 }
 
-static void __exit pseries_processor_idle_exit(void)
-{
-
-	unregister_cpu_notifier(&setup_hotplug_notifier);
-	cpuidle_unregister(&pseries_idle_driver);
-	return;
-}
-
-module_init(pseries_processor_idle_init);
-module_exit(pseries_processor_idle_exit);
-
-MODULE_AUTHOR("Deepthi Dharwar <deepthi@linux.vnet.ibm.com>");
-MODULE_DESCRIPTION("Cpuidle driver for POWER");
-MODULE_LICENSE("GPL");
+device_initcall(pseries_processor_idle_init);

