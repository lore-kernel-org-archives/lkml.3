Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3JVWaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:30:35 -0400
Received: from smtprelay0035.hostedemail.com ([216.40.44.35]:49136 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750861Ab3JVWac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:30:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:1801:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3354:3866:3868:3870:3871:4321:4605:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12294:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hand54_449f00b1e90c
X-Filterd-Recvd-Size: 4324
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 03/24] s390: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:29:46 -0700
Message-Id: <deafe94275c9ebec32ef09eb6f583b2c5a014dae.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/s390/appldata/appldata_base.c | 10 +++++-----
 arch/s390/kernel/debug.c           |  2 +-
 arch/s390/mm/cmm.c                 |  8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index 87a2209..baff85e 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -48,9 +48,9 @@ static struct platform_device *appldata_pdev;
  * /proc entries (sysctl)
  */
 static const char appldata_proc_name[APPLDATA_PROC_NAME_LENGTH] = "appldata";
-static int appldata_timer_handler(ctl_table *ctl, int write,
+static int appldata_timer_handler(struct ctl_table *ctl, int write,
 				  void __user *buffer, size_t *lenp, loff_t *ppos);
-static int appldata_interval_handler(ctl_table *ctl, int write,
+static int appldata_interval_handler(struct ctl_table *ctl, int write,
 					 void __user *buffer,
 					 size_t *lenp, loff_t *ppos);
 
@@ -201,7 +201,7 @@ static void __appldata_vtimer_setup(int cmd)
  * Start/Stop timer, show status of timer (0 = not active, 1 = active)
  */
 static int
-appldata_timer_handler(ctl_table *ctl, int write,
+appldata_timer_handler(struct ctl_table *ctl, int write,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int len;
@@ -243,7 +243,7 @@ out:
  * current timer interval.
  */
 static int
-appldata_interval_handler(ctl_table *ctl, int write,
+appldata_interval_handler(struct ctl_table *ctl, int write,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int len, interval;
@@ -286,7 +286,7 @@ out:
  * monitoring (0 = not in process, 1 = in process)
  */
 static int
-appldata_generic_handler(ctl_table *ctl, int write,
+appldata_generic_handler(struct ctl_table *ctl, int write,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct appldata_ops *ops = NULL, *tmp_ops;
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index f1279dc..d98b888 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -889,7 +889,7 @@ static int debug_active=1;
  * if debug_active is already off
  */
 static int
-s390dbf_procactive(ctl_table *table, int write,
+s390dbf_procactive(struct ctl_table *table, int write,
                      void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	if (!write || debug_stoppable || !debug_active)
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index 9d84a1f..61172c4 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -253,8 +253,8 @@ static int cmm_skip_blanks(char *cp, char **endp)
 
 static struct ctl_table cmm_table[];
 
-static int cmm_pages_handler(ctl_table *ctl, int write, void __user *buffer,
-			     size_t *lenp, loff_t *ppos)
+static int cmm_pages_handler(struct ctl_table *ctl, int write,
+			     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	char buf[16], *p;
 	long nr;
@@ -293,8 +293,8 @@ static int cmm_pages_handler(ctl_table *ctl, int write, void __user *buffer,
 	return 0;
 }
 
-static int cmm_timeout_handler(ctl_table *ctl, int write,  void __user *buffer,
-			       size_t *lenp, loff_t *ppos)
+static int cmm_timeout_handler(struct ctl_table *ctl, int write,
+			       void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	char buf[64], *p;
 	long nr, seconds;
-- 
1.8.1.2.459.gbcd45b4.dirty

