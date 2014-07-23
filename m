Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbaGWChg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:37:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:44783 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209AbaGWCh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:37:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577336591"
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
Subject: [RFC PATCH v1 51/70] powercap, intel_rapl: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:27 -0400
Message-Id: <1406080786-3938-52-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from powercap/intel_rapl.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/powercap/intel_rapl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index b1cda6f..c55de1a 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -1328,11 +1328,9 @@ static int rapl_cpu_callback(struct notifier_block *nfb,
 	struct rapl_package *rp;
 
 	phy_package_id = topology_physical_package_id(cpu);
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 		rp = find_package_by_id(phy_package_id);
 		if (rp)
 			++rp->nr_cpus;
@@ -1340,7 +1338,6 @@ static int rapl_cpu_callback(struct notifier_block *nfb,
 			rapl_add_package(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 		rp = find_package_by_id(phy_package_id);
 		if (!rp)
 			break;
-- 
2.0.0.rc2

