Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab3FNCjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:39:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48927 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753407Ab3FNCjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:39:07 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 06/33] s390: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:31 -0700
Message-Id: <a7fb85fd601818d0cac8f76e9d9c4be6c985fbba.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/s390/appldata/appldata_base.c | 16 ++++++++--------
 arch/s390/kernel/debug.c           |  4 ++--
 arch/s390/mm/cmm.c                 |  6 ++++--
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index 87a2209..c0ef020a 100644
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
 
@@ -201,8 +201,8 @@ static void __appldata_vtimer_setup(int cmd)
  * Start/Stop timer, show status of timer (0 = not active, 1 = active)
  */
 static int
-appldata_timer_handler(ctl_table *ctl, int write,
-			   void __user *buffer, size_t *lenp, loff_t *ppos)
+appldata_timer_handler(struct ctl_table *ctl, int write,
+		       void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int len;
 	char buf[2];
@@ -243,8 +243,8 @@ out:
  * current timer interval.
  */
 static int
-appldata_interval_handler(ctl_table *ctl, int write,
-			   void __user *buffer, size_t *lenp, loff_t *ppos)
+appldata_interval_handler(struct ctl_table *ctl, int write,
+			  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int len, interval;
 	char buf[16];
@@ -286,8 +286,8 @@ out:
  * monitoring (0 = not in process, 1 = in process)
  */
 static int
-appldata_generic_handler(ctl_table *ctl, int write,
-			   void __user *buffer, size_t *lenp, loff_t *ppos)
+appldata_generic_handler(struct ctl_table *ctl, int write,
+			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct appldata_ops *ops = NULL, *tmp_ops;
 	int rc, len, found;
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index f1279dc..fc5672f 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -889,8 +889,8 @@ static int debug_active=1;
  * if debug_active is already off
  */
 static int
-s390dbf_procactive(ctl_table *table, int write,
-                     void __user *buffer, size_t *lenp, loff_t *ppos)
+s390dbf_procactive(struct ctl_table *table, int write,
+		   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	if (!write || debug_stoppable || !debug_active)
 		return proc_dointvec(table, write, buffer, lenp, ppos);
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index 9d84a1f..0caf085 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -253,7 +253,8 @@ static int cmm_skip_blanks(char *cp, char **endp)
 
 static struct ctl_table cmm_table[];
 
-static int cmm_pages_handler(ctl_table *ctl, int write, void __user *buffer,
+static int cmm_pages_handler(struct ctl_table *ctl, int write,
+			     void __user *buffer,
 			     size_t *lenp, loff_t *ppos)
 {
 	char buf[16], *p;
@@ -293,7 +294,8 @@ static int cmm_pages_handler(ctl_table *ctl, int write, void __user *buffer,
 	return 0;
 }
 
-static int cmm_timeout_handler(ctl_table *ctl, int write,  void __user *buffer,
+static int cmm_timeout_handler(struct ctl_table *ctl, int write,
+			       void __user *buffer,
 			       size_t *lenp, loff_t *ppos)
 {
 	char buf[64], *p;
-- 
1.8.1.2.459.gbcd45b4.dirty

