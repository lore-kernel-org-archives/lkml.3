Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbaGWCjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:39:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:55360 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464AbaGWCjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:39:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="573977048"
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
Subject: [RFC PATCH v1 69/70] staging, lustre, linux-cpu: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:45 -0400
Message-Id: <1406080786-3938-70-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from lustre/linux-cpu.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
index fc21210..0e061ca 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
@@ -954,16 +954,14 @@ cfs_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 	unsigned int  cpu = (unsigned long)hcpu;
 	bool	     warn;
 
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		spin_lock(&cpt_data.cpt_lock);
 		cpt_data.cpt_version++;
 		spin_unlock(&cpt_data.cpt_lock);
 	default:
-		if (action != CPU_DEAD && action != CPU_DEAD_FROZEN) {
+		if ((action & ~CPU_TASKS_FROZEN) != CPU_DEAD) {
 			CDEBUG(D_INFO, "CPU changed [cpu %u action %lx]\n",
 			       cpu, action);
 			break;
-- 
2.0.0.rc2

