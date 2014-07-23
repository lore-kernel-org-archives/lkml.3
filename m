Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbaGWCdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:33:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:34089 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085AbaGWCdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:33:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="573974400"
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
Subject: [RFC PATCH v1 17/70] arm, vfp, vfpmodule: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:58:53 -0400
Message-Id: <1406080786-3938-18-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from arm/vfp/vfpmodule.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 arch/arm/vfp/vfpmodule.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 2f37e1d..a1a6154 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -642,9 +642,11 @@ int vfp_restore_user_hwstate(struct user_vfp __user *ufp,
 static int vfp_hotplug(struct notifier_block *b, unsigned long action,
 	void *hcpu)
 {
-	if (action == CPU_DYING || action == CPU_DYING_FROZEN)
+	action &= ~CPU_TASKS_FROZEN;
+
+	if (action == CPU_DYING)
 		vfp_current_hw_state[(long)hcpu] = NULL;
-	else if (action == CPU_STARTING || action == CPU_STARTING_FROZEN)
+	else if (action == CPU_STARTING)
 		vfp_enable(NULL);
 	return NOTIFY_OK;
 }
-- 
2.0.0.rc2

