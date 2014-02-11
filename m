Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaBKTHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:07:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbaBKTHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 04/79] arch/sh/kernel/kgdb.c: add missing #include <linux/sched.h>
Date: Tue, 11 Feb 2014 11:05:08 -0800
Message-Id: <20140211184721.062591786@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sh/kernel/kgdb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sh/kernel/kgdb.c
+++ b/arch/sh/kernel/kgdb.c
@@ -13,6 +13,7 @@
 #include <linux/kdebug.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 #include <asm/cacheflush.h>
 #include <asm/traps.h>
 


