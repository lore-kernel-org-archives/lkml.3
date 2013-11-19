Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3KSESy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 23:18:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:21003 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab3KSESw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 23:18:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,727,1378882800"; 
   d="scan'208";a="430005407"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kernel: remove CONFIG_USE_GENERIC_SMP_HELPERS cleanly
Date: Tue, 19 Nov 2013 12:19:12 +0800
Message-Id: <1384834752-29795-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove CONFIG_USE_GENERIC_SMP_HELPERS left by commit
0a06ff06("kernel: remove CONFIG_USE_GENERIC_SMP_HELPERS").

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/block/null_blk.c |    8 ++++----
 net/Kconfig              |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index b5d8423..ea192ec 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -223,7 +223,7 @@ static void null_softirq_done_fn(struct request *rq)
 	blk_end_request_all(rq, 0);
 }
 
-#if defined(CONFIG_SMP) && defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#ifdef CONFIG_SMP
 
 static void null_ipi_cmd_end_io(void *data)
 {
@@ -260,7 +260,7 @@ static void null_cmd_end_ipi(struct nullb_cmd *cmd)
 	put_cpu();
 }
 
-#endif /* CONFIG_SMP && CONFIG_USE_GENERIC_SMP_HELPERS */
+#endif /* CONFIG_SMP */
 
 static inline void null_handle_cmd(struct nullb_cmd *cmd)
 {
@@ -270,7 +270,7 @@ static inline void null_handle_cmd(struct nullb_cmd *cmd)
 		end_cmd(cmd);
 		break;
 	case NULL_IRQ_SOFTIRQ:
-#if defined(CONFIG_SMP) && defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#ifdef CONFIG_SMP
 		null_cmd_end_ipi(cmd);
 #else
 		end_cmd(cmd);
@@ -571,7 +571,7 @@ static int __init null_init(void)
 {
 	unsigned int i;
 
-#if !defined(CONFIG_SMP) || !defined(CONFIG_USE_GENERIC_SMP_HELPERS)
+#if !defined(CONFIG_SMP)
 	if (irqmode == NULL_IRQ_SOFTIRQ) {
 		pr_warn("null_blk: softirq completions not available.\n");
 		pr_warn("null_blk: using direct completions.\n");
diff --git a/net/Kconfig b/net/Kconfig
index 0715db6..d334678 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -224,7 +224,7 @@ source "net/hsr/Kconfig"
 
 config RPS
 	boolean
-	depends on SMP && SYSFS && USE_GENERIC_SMP_HELPERS
+	depends on SMP && SYSFS
 	default y
 
 config RFS_ACCEL
@@ -235,7 +235,7 @@ config RFS_ACCEL
 
 config XPS
 	boolean
-	depends on SMP && USE_GENERIC_SMP_HELPERS
+	depends on SMP
 	default y
 
 config NETPRIO_CGROUP
-- 
1.7.7.6

