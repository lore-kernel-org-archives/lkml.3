Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935758AbaDJUkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:40:49 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:49911 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020AbaDJUks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:40:48 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@linux.intel.com, aquini@redhat.com
Subject: [PATCH 1/2] ipc:kernel:use Linux headers
Date: Thu, 10 Apr 2014 21:40:43 +0100
Message-Id: <1397162444-9327-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
Use #include <linux/types.h> instead of <asm/types.h>

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/compat.c    | 2 +-
 ipc/compat_mq.c | 2 +-
 ipc/msg.c       | 2 +-
 ipc/sem.c       | 2 +-
 ipc/shm.c       | 2 +-
 kernel/acct.c   | 2 +-
 kernel/audit.c  | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/ipc/compat.c b/ipc/compat.c
index 45d035d..b5ef4f7 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -30,7 +30,7 @@
 #include <linux/ptrace.h>
 
 #include <linux/mutex.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "util.h"
 
diff --git a/ipc/compat_mq.c b/ipc/compat_mq.c
index 90d29f5..ef6f91c 100644
--- a/ipc/compat_mq.c
+++ b/ipc/compat_mq.c
@@ -12,7 +12,7 @@
 #include <linux/mqueue.h>
 #include <linux/syscalls.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 struct compat_mq_attr {
 	compat_long_t mq_flags;      /* message queue flags		     */
diff --git a/ipc/msg.c b/ipc/msg.c
index 6498531..a385372 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -39,7 +39,7 @@
 #include <linux/ipc_namespace.h>
 
 #include <asm/current.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "util.h"
 
 /*
diff --git a/ipc/sem.c b/ipc/sem.c
index bee5554..3bbfa6c 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -87,7 +87,7 @@
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "util.h"
 
 /* One semaphore structure for each semaphore in the system. */
diff --git a/ipc/shm.c b/ipc/shm.c
index 7645961..89ab12c 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -43,7 +43,7 @@
 #include <linux/mount.h>
 #include <linux/ipc_namespace.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "util.h"
 
diff --git a/kernel/acct.c b/kernel/acct.c
index 8d6e145..df28519 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -55,7 +55,7 @@
 #include <linux/times.h>
 #include <linux/syscalls.h>
 #include <linux/mount.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/div64.h>
 #include <linux/blkdev.h> /* sector_div */
 #include <linux/pid_namespace.h>
diff --git a/kernel/audit.c b/kernel/audit.c
index 95a20f3..1ef36a4 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -44,7 +44,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/atomic.h>
 #include <linux/mm.h>
 #include <linux/export.h>
-- 
1.8.3.2

