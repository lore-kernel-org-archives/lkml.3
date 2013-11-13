Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab3KMOjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:39:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34968 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758394Ab3KMOjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:39:06 -0500
X-IronPort-AV: E=Sophos;i="4.93,693,1378828800"; 
   d="scan'208";a="9026005"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-sh@vger.kernel.org, lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, kbuild-all@01.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] sh: fix kernel build error
Date: Wed, 13 Nov 2013 22:38:24 +0800
Message-Id: <1384353504-21886-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.5.rc1.17.g0ecd94d
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/13 22:37:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/13 22:37:17,
	Serialize complete at 2013/11/13 22:37:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   arch/sh/kernel/kgdb.c: In function 'sleeping_thread_to_gdb_regs':
>> arch/sh/kernel/kgdb.c:225:32: error: implicit declaration of function 'task_stack_page' [-Werror=implicit-function-declaration]
>> arch/sh/kernel/kgdb.c:242:23: error: dereferencing pointer to incomplete type
>> arch/sh/kernel/kgdb.c:243:22: error: dereferencing pointer to incomplete type
   arch/sh/kernel/kgdb.c: In function 'singlestep_trap_handler':
>> arch/sh/kernel/kgdb.c:310:27: error: 'SIGTRAP' undeclared (first use in this function)
   arch/sh/kernel/kgdb.c:310:27: note: each undeclared identifier is reported only once for each function it appears in
   cc1: all warnings being treated as errors

This is introduced by commit 16559ae.

CC: kbuild-all@01.org
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 arch/sh/kernel/kgdb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/kernel/kgdb.c b/arch/sh/kernel/kgdb.c
index 38b3139..adad46e 100644
--- a/arch/sh/kernel/kgdb.c
+++ b/arch/sh/kernel/kgdb.c
@@ -13,6 +13,7 @@
 #include <linux/kdebug.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 #include <asm/cacheflush.h>
 #include <asm/traps.h>
 
-- 
1.8.5.rc1.17.g0ecd94d

