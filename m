Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaBJToN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:44:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbaBJToK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:44:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 083/124] arch/sh/kernel/kgdb.c: add missing #include <linux/sched.h>
Date: Mon, 10 Feb 2014 11:40:23 -0800
Message-Id: <1392061264-28124-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>

commit 53a52f17d96c8d47c79a7dafa81426317e89c7c1 upstream.

  arch/sh/kernel/kgdb.c: In function 'sleeping_thread_to_gdb_regs':
  arch/sh/kernel/kgdb.c:225:32: error: implicit declaration of function 'task_stack_page' [-Werror=implicit-function-declaration]
  arch/sh/kernel/kgdb.c:242:23: error: dereferencing pointer to incomplete type
  arch/sh/kernel/kgdb.c:243:22: error: dereferencing pointer to incomplete type
  arch/sh/kernel/kgdb.c: In function 'singlestep_trap_handler':
  arch/sh/kernel/kgdb.c:310:27: error: 'SIGTRAP' undeclared (first use in this function)
  arch/sh/kernel/kgdb.c:310:27: note: each undeclared identifier is reported only once for each function it appears in

This was introduced by commit 16559ae48c76 ("kgdb: remove #include
<linux/serial_8250.h> from kgdb.h").

[geert@linux-m68k.org: reworded and reformatted]
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.3.2

