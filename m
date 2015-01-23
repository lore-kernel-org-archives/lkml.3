Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbbAWFgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:36:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:12153 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbbAWFgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:36:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444042485"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Roman Gushchin <klamm@yandex-team.ru>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [Resend Patch v4 15/16] smp: Cleanup unsued generic_smp_call_function_single_interrupt()
Date: Fri, 23 Jan 2015 13:36:54 +0800
Message-Id: <1421991416-20297-16-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have killed all usage of generic_smp_call_function_single_interrupt()
from arch code, so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/smp.h |    4 +---
 kernel/smp.c        |    4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 93dff5fff524..cd78b3aa2cf8 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -106,9 +106,7 @@ void wake_up_all_idle_cpus(void);
  * Generic and arch helpers
  */
 void __init call_function_init(void);
-void generic_smp_call_function_single_interrupt(void);
-#define generic_smp_call_function_interrupt \
-	generic_smp_call_function_single_interrupt
+void generic_smp_call_function_interrupt(void);
 
 /*
  * Mark the boot cpu "online" so that it can call console drivers in
diff --git a/kernel/smp.c b/kernel/smp.c
index f38a1e692259..e39712cbe92d 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -197,12 +197,12 @@ static int generic_exec_single(int cpu, struct call_single_data *csd,
 }
 
 /**
- * generic_smp_call_function_single_interrupt - Execute SMP IPI callbacks
+ * generic_smp_call_function_interrupt - Execute SMP IPI callbacks
  *
  * Invoked by arch to handle an IPI for call function single.
  * Must be called with interrupts disabled.
  */
-void generic_smp_call_function_single_interrupt(void)
+void generic_smp_call_function_interrupt(void)
 {
 	flush_smp_call_function_queue(true);
 }
-- 
1.7.10.4

