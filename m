Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab3FNCmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:42:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50912 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932452Ab3FNCmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:42:51 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 31/33] sysctl: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:56 -0700
Message-Id: <c4c9c694f6135fbb822cb24e8307a851acc27387.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
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
index fb90f7c..aa357a2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -193,7 +193,7 @@ static int proc_dostring_coredump(struct ctl_table *table, int write,
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

