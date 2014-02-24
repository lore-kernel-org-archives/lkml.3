Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaBXWAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:00:52 -0500
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:57101 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753163AbaBXWAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:00:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:2894:3138:3139:3140:3141:3142:3352:3866:3867:4605:5007:6119:6261:6642:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: blood50_23cde1d128a0b
X-Filterd-Recvd-Size: 2742
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 8/8] security: yama: Use a more current logging style
Date: Mon, 24 Feb 2014 14:00:01 -0800
Message-Id: <0d49520be87d34c477a494c848953adb9da78f72.1393279025.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1393279025.git.joe@perches.com>
References: <cover.1393279025.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to pr_<level>.
Add pr_fmt to prefix with "yama: "
Convert printk_ratelimited to pr_<level>_ratelimited.

Signed-off-by: Joe Perches <joe@perches.com>
---
 security/yama/yama_lsm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 13c88fbc..9de0f2b 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -12,6 +12,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/security.h>
 #include <linux/sysctl.h>
 #include <linux/ptrace.h>
@@ -319,9 +321,8 @@ int yama_ptrace_access_check(struct task_struct *child,
 	}
 
 	if (rc) {
-		printk_ratelimited(KERN_NOTICE
-			"ptrace of pid %d was attempted by: %s (pid %d)\n",
-			child->pid, current->comm, current->pid);
+		pr_notice_ratelimited("ptrace of pid %d was attempted by: %s (pid %d)\n",
+				      child->pid, current->comm, current->pid);
 	}
 
 	return rc;
@@ -356,9 +357,8 @@ int yama_ptrace_traceme(struct task_struct *parent)
 	}
 
 	if (rc) {
-		printk_ratelimited(KERN_NOTICE
-			"ptraceme of pid %d was attempted by: %s (pid %d)\n",
-			current->pid, parent->comm, parent->pid);
+		pr_notice_ratelimited("ptraceme of pid %d was attempted by: %s (pid %d)\n",
+				      current->pid, parent->comm, parent->pid);
 	}
 
 	return rc;
@@ -425,16 +425,16 @@ static __init int yama_init(void)
 		return 0;
 #endif
 
-	printk(KERN_INFO "Yama: becoming mindful.\n");
+	pr_info("becoming mindful\n");
 
 #ifndef CONFIG_SECURITY_YAMA_STACKED
 	if (register_security(&yama_ops))
-		panic("Yama: kernel registration failed.\n");
+		panic("Yama: kernel registration failed\n");
 #endif
 
 #ifdef CONFIG_SYSCTL
 	if (!register_sysctl_paths(yama_sysctl_path, yama_sysctl_table))
-		panic("Yama: sysctl registration failed.\n");
+		panic("Yama: sysctl registration failed\n");
 #endif
 
 	return 0;
-- 
1.8.1.2.459.gbcd45b4.dirty

