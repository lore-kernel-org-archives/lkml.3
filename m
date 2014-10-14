Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaJNLlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:41:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:10874 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbaJNLlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:41:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,716,1406617200"; 
   d="scan'208";a="614192086"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: akpm@linux-foundation.org, mingo@kernel.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] kernel/sysctl: Resolve missing-field-initializers warnings
Date: Tue, 14 Oct 2014 04:41:08 -0700
Message-Id: <1413286868-21870-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve missing-field-initializers warnings in W=2 builds by
using designated initialization.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 kernel/sysctl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4aada6d..5623845 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -257,7 +257,7 @@ static struct ctl_table sysctl_base_table[] = {
 		.mode		= 0555,
 		.child		= dev_table,
 	},
-	{ }
+	{ .procname = NULL }
 };
 
 #ifdef CONFIG_SCHED_DEBUG
@@ -1103,7 +1103,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-	{ }
+	{ .procname = NULL }
 };
 
 static struct ctl_table vm_table[] = {
@@ -1485,12 +1485,12 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
 	},
-	{ }
+	{ .procname = NULL }
 };
 
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 static struct ctl_table binfmt_misc_table[] = {
-	{ }
+	{ .procname = NULL }
 };
 #endif
 
@@ -1658,7 +1658,7 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
-	{ }
+	{ .procname = NULL }
 };
 
 static struct ctl_table debug_table[] = {
@@ -1682,11 +1682,11 @@ static struct ctl_table debug_table[] = {
 		.extra2		= &one,
 	},
 #endif
-	{ }
+	{ .procname = NULL }
 };
 
 static struct ctl_table dev_table[] = {
-	{ }
+	{ .procname = NULL }
 };
 
 int __init sysctl_init(void)
-- 
1.9.3

