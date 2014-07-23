Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbaGWCia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:38:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:20955 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402AbaGWCiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:38:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="363779104"
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
Subject: [RFC PATCH v1 59/70] scsi, fcoe: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:35 -0400
Message-Id: <1406080786-3938-60-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from scsi/fcoe.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/scsi/fcoe/fcoe.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 00ee0ed..f1d3f6a 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1376,14 +1376,12 @@ static int fcoe_cpu_callback(struct notifier_block *nfb,
 {
 	unsigned cpu = (unsigned long)hcpu;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		FCOE_DBG("CPU %x online: Create Rx thread\n", cpu);
 		fcoe_percpu_thread_create(cpu);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		FCOE_DBG("CPU %x offline: Remove Rx thread\n", cpu);
 		fcoe_percpu_thread_destroy(cpu);
 		break;
-- 
2.0.0.rc2

