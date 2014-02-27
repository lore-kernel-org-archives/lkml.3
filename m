Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaB0Lb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:31:28 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61570 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaB0Lb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:31:27 -0500
Date: Thu, 27 Feb 2014 16:59:07 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Vincent <vincent.stehle@laposte.net>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Emese Revfy <re.emese@gmail.com>, Andrey Vagin <avagin@openvz.org>,
        Jesper Derehag <jderehag@hotmail.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        kgdb-bugreport@lists.sourceforge.net, josh@joshtriplett.org
Subject: [PATCH 05/46] kernel: Include appropriate header file in
 kernel/signal.c
Message-ID: <ffebeb9154859c6e109c825597c473dd6527f6bc.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file kernel/debug/kdb/kdb_private.h in
kernel/signal.c because it contains prototype definitions of functions
declared in kernel/signal.c.

Also, include include/linux/kdb.h in
include/linux/kdb_private.h to remove the following errors:
kernel/debug/kdb/kdb_private.h:172:2: error: unknown type name ‘kdb_func_t’
kernel/debug/kdb/kdb_private.h:178:2: error: unknown type name ‘kdb_repeat_t’
kernel/debug/kdb/kdb_private.h:196:5: error: expected ‘)’ before ‘int’
Inclusion of kdb.h is necessary because it typedefs the above keywords.

This eliminates the following warning in kernel/signal.c:
kernel/signal.c:3640:1: warning: no previous prototype for ‘kdb_send_sig_info’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/debug/kdb/kdb_private.h |    1 +
 kernel/signal.c                |    1 +
 2 files changed, 2 insertions(+)

diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 7afd3c8..e7f2c35 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -13,6 +13,7 @@
  */
 
 #include <linux/kgdb.h>
+#include <linux/kdb.h>
 #include "../debug_core.h"
 
 /* Kernel Debugger Command codes.  Must not overlap with error codes. */
diff --git a/kernel/signal.c b/kernel/signal.c
index 52f881d..aa1cc60 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -42,6 +42,7 @@
 #include <asm/siginfo.h>
 #include <asm/cacheflush.h>
 #include "audit.h"	/* audit_signal_info() */
+#include "debug/kdb/kdb_private.h"
 
 /*
  * SLAB caches for signal bits.
-- 
1.7.9.5

