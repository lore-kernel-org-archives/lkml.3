Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbaGWCgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:36:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:44527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648AbaGWCgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:36:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577336202"
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
Subject: [RFC PATCH v1 41/70] fs, buffer: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:17 -0400
Message-Id: <1406080786-3938-42-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from fs/buffer.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index eba6e4f..47960b7 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3373,7 +3373,7 @@ static void buffer_exit_cpu(int cpu)
 static int buffer_cpu_notify(struct notifier_block *self,
 			      unsigned long action, void *hcpu)
 {
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN)
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_DEAD)
 		buffer_exit_cpu((unsigned long)hcpu);
 	return NOTIFY_OK;
 }
-- 
2.0.0.rc2

