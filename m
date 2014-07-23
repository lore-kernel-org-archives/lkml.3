Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbaGWCjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:39:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:45617 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464AbaGWCjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:39:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="565813218"
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
Subject: [RFC PATCH v1 66/70] lib, cpu-notifier-error-inject: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:42 -0400
Message-Id: <1406080786-3938-67-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from lib/cpu-notifier-error-inject.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 lib/cpu-notifier-error-inject.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/cpu-notifier-error-inject.c b/lib/cpu-notifier-error-inject.c
index 707ca24..78c28db 100644
--- a/lib/cpu-notifier-error-inject.c
+++ b/lib/cpu-notifier-error-inject.c
@@ -10,10 +10,10 @@ MODULE_PARM_DESC(priority, "specify cpu notifier priority");
 
 static struct notifier_err_inject cpu_notifier_err_inject = {
 	.actions = {
-		{ NOTIFIER_ERR_INJECT_ACTION(CPU_UP_PREPARE) },
-		{ NOTIFIER_ERR_INJECT_ACTION(CPU_UP_PREPARE_FROZEN) },
-		{ NOTIFIER_ERR_INJECT_ACTION(CPU_DOWN_PREPARE) },
-		{ NOTIFIER_ERR_INJECT_ACTION(CPU_DOWN_PREPARE_FROZEN) },
+		{NOTIFIER_ERR_INJECT_ACTION(CPU_UP_PREPARE)},
+		{NOTIFIER_ERR_INJECT_ACTION(CPU_UP_PREPARE|CPU_TASKS_FROZEN)},
+		{NOTIFIER_ERR_INJECT_ACTION(CPU_DOWN_PREPARE)},
+		{NOTIFIER_ERR_INJECT_ACTION(CPU_DOWN_PREPARE|CPU_TASKS_FROZEN)},
 		{}
 	}
 };
-- 
2.0.0.rc2

