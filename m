Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3JVWc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:32:27 -0400
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:49200 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755785Ab3JVWb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:31:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:3872:4250:4321:4605:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gold82_c3ecf5bc1151
X-Filterd-Recvd-Size: 2581
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 22/24] kernel: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:30:05 -0700
Message-Id: <7fa92e2b01e133b4e1ab9ed66c9c9d2c6465a503.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/sysctl.c         | 2 +-
 kernel/utsname_sysctl.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index bcb35ab..a083aeb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -192,7 +192,7 @@ static int proc_dostring_coredump(struct ctl_table *table, int write,
 /* Note: sysrq code uses it's own private copy */
 static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
 
-static int sysrq_sysctl_handler(ctl_table *table, int write,
+static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
 {
diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
index 4f69f9a..09af144 100644
--- a/kernel/utsname_sysctl.c
+++ b/kernel/utsname_sysctl.c
@@ -17,7 +17,7 @@
 
 #ifdef CONFIG_PROC_SYSCTL
 
-static void *get_uts(ctl_table *table, int write)
+static void *get_uts(struct ctl_table *table, int write)
 {
 	char *which = table->data;
 	struct uts_namespace *uts_ns;
@@ -32,7 +32,7 @@ static void *get_uts(ctl_table *table, int write)
 	return which;
 }
 
-static void put_uts(ctl_table *table, int write, void *which)
+static void put_uts(struct ctl_table *table, int write, void *which)
 {
 	if (!write)
 		up_read(&uts_sem);
@@ -44,7 +44,7 @@ static void put_uts(ctl_table *table, int write, void *which)
  *	Special case of dostring for the UTS structure. This has locks
  *	to observe. Should this be in kernel/sys.c ????
  */
-static int proc_do_uts_string(ctl_table *table, int write,
+static int proc_do_uts_string(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table uts_table;
-- 
1.8.1.2.459.gbcd45b4.dirty

