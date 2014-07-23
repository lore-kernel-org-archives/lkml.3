Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaGWCiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:38:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:55115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383AbaGWCiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:38:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="573976639"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RFC PATCH v1 53/70] cpuidle, cpuidle-pseries: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:29 -0400
Message-Id: <1406080786-3938-54-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from cpuidle/cpuidle-pseries.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/cpuidle/cpuidle-pseries.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
index 6f7b019..11902eb 100644
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -176,16 +176,14 @@ static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
 				per_cpu(cpuidle_devices, hotcpu);
 
 	if (dev && cpuidle_get_driver()) {
-		switch (action) {
+		switch (action & ~CPU_TASKS_FROZEN) {
 		case CPU_ONLINE:
-		case CPU_ONLINE_FROZEN:
 			cpuidle_pause_and_lock();
 			cpuidle_enable_device(dev);
 			cpuidle_resume_and_unlock();
 			break;
 
 		case CPU_DEAD:
-		case CPU_DEAD_FROZEN:
 			cpuidle_pause_and_lock();
 			cpuidle_disable_device(dev);
 			cpuidle_resume_and_unlock();
-- 
2.0.0.rc2

