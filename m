Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab3FNCmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:42:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47921 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932452Ab3FNCmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:42:42 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 30/33] ipc: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:55 -0700
Message-Id: <e00af740492d68401a8a5424d52d162fdb039f74.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 ipc/ipc_sysctl.c | 14 +++++++-------
 ipc/mq_sysctl.c  | 10 +++++-----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 130dfec..27fab60 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -18,7 +18,7 @@
 #include <linux/msg.h>
 #include "util.h"
 
-static void *get_ipc(ctl_table *table)
+static void *get_ipc(struct ctl_table *table)
 {
 	char *which = table->data;
 	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
@@ -27,7 +27,7 @@ static void *get_ipc(ctl_table *table)
 }
 
 #ifdef CONFIG_PROC_SYSCTL
-static int proc_ipc_dointvec(ctl_table *table, int write,
+static int proc_ipc_dointvec(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -38,7 +38,7 @@ static int proc_ipc_dointvec(ctl_table *table, int write,
 	return proc_dointvec(&ipc_table, write, buffer, lenp, ppos);
 }
 
-static int proc_ipc_dointvec_minmax(ctl_table *table, int write,
+static int proc_ipc_dointvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -49,7 +49,7 @@ static int proc_ipc_dointvec_minmax(ctl_table *table, int write,
 	return proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
 }
 
-static int proc_ipc_dointvec_minmax_orphans(ctl_table *table, int write,
+static int proc_ipc_dointvec_minmax_orphans(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ipc_namespace *ns = current->nsproxy->ipc_ns;
@@ -62,7 +62,7 @@ static int proc_ipc_dointvec_minmax_orphans(ctl_table *table, int write,
 	return err;
 }
 
-static int proc_ipc_callback_dointvec(ctl_table *table, int write,
+static int proc_ipc_callback_dointvec(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -85,7 +85,7 @@ static int proc_ipc_callback_dointvec(ctl_table *table, int write,
 	return rc;
 }
 
-static int proc_ipc_doulongvec_minmax(ctl_table *table, int write,
+static int proc_ipc_doulongvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -119,7 +119,7 @@ static void ipc_auto_callback(int val)
 	}
 }
 
-static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
+static int proc_ipcauto_dointvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index 383d638..ee514bb 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -14,7 +14,7 @@
 #include <linux/sysctl.h>
 
 #ifdef CONFIG_PROC_SYSCTL
-static void *get_mq(ctl_table *table)
+static void *get_mq(struct ctl_table *table)
 {
 	char *which = table->data;
 	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
@@ -22,7 +22,7 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
-static int proc_mq_dointvec_minmax(ctl_table *table, int write,
+static int proc_mq_dointvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table mq_table;
@@ -45,7 +45,7 @@ static int msg_max_limit_max = HARD_MSGMAX;
 static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
 static int msg_maxsize_limit_max = HARD_MSGSIZEMAX;
 
-static ctl_table mq_sysctls[] = {
+static struct ctl_table mq_sysctls[] = {
 	{
 		.procname	= "queues_max",
 		.data		= &init_ipc_ns.mq_queues_max,
@@ -94,7 +94,7 @@ static ctl_table mq_sysctls[] = {
 	{}
 };
 
-static ctl_table mq_sysctl_dir[] = {
+static struct ctl_table mq_sysctl_dir[] = {
 	{
 		.procname	= "mqueue",
 		.mode		= 0555,
@@ -103,7 +103,7 @@ static ctl_table mq_sysctl_dir[] = {
 	{}
 };
 
-static ctl_table mq_sysctl_root[] = {
+static struct ctl_table mq_sysctl_root[] = {
 	{
 		.procname	= "fs",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

