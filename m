Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3HRUyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:54:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3HRUdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 15/34] frv: Use core allocator for task_struct
Date: Sun, 18 Aug 2013 13:34:28 -0700
Message-Id: <20130818203300.730889337@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit c6ae063aaf3786b9db7f19a90bf4ed8aaebb7f90 upstream.

There is no point having a copy of the core allocator.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20120503085033.967140188@linutronix.de
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/frv/include/asm/thread_info.h |    2 --
 arch/frv/kernel/process.c          |   10 ----------
 2 files changed, 12 deletions(-)

--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -21,8 +21,6 @@
 
 #define THREAD_SIZE		8192
 
-#define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
-
 /*
  * low level task data that entry.S needs immediate access to
  * - this struct should fit entirely inside of one cache line
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -44,16 +44,6 @@ asmlinkage void ret_from_fork(void);
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-struct task_struct *alloc_task_struct_node(int node)
-{
-	return kmalloc_node(sizeof(task_struct), GFP_KERNEL, node);
-}
-
-void free_task_struct(struct task_struct *p)
-{
-	kfree(p);
-}
-
 static void core_sleep_idle(void)
 {
 #ifdef LED_DEBUG_SLEEP


