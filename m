Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbaGWCed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:34:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:44238 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbaGWCe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:34:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577335445"
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
Subject: [RFC PATCH v1 27/70] kernel, padata: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:03 -0400
Message-Id: <1406080786-3938-28-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from padata.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 kernel/padata.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 161402f..3a6bc6e 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -842,11 +842,9 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 
 	pinst = container_of(nfb, struct padata_instance, cpu_notifier);
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 		if (!pinst_has_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
@@ -857,9 +855,7 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 		break;
 
 	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 		if (!pinst_has_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
-- 
2.0.0.rc2

