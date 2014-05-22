Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaEVJXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:23:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52029 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaEVJXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:23:48 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH] intel_rapl: Correct hotplug correction
Date: Thu, 22 May 2014 11:23:44 +0200
Message-Id: <1400750624-19238-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

So 009f225ef050 ("powercap, intel-rapl: Fix CPU hotplug callback
registration") says how get_/put_online_cpus() should be replaced with
this cpu_notifier_register_begin/_done().

But they're still there so what's up?

Let me do what was supposed to be done.

Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/powercap/intel_rapl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index d9a0770b6c73..9055f3df1f64 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -1377,8 +1377,6 @@ static int __init rapl_init(void)
 
 	cpu_notifier_register_begin();
 
-	/* prevent CPU hotplug during detection */
-	get_online_cpus();
 	ret = rapl_detect_topology();
 	if (ret)
 		goto done;
@@ -1390,7 +1388,6 @@ static int __init rapl_init(void)
 	}
 	__register_hotcpu_notifier(&rapl_cpu_notifier);
 done:
-	put_online_cpus();
 	cpu_notifier_register_done();
 
 	return ret;
-- 
1.9.0

