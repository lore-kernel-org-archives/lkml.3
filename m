Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaB0LLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:11:16 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49824 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaB0LLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:11:11 -0500
Date: Thu, 27 Feb 2014 16:38:50 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@tilera.com>, Tony Lu <zlu@tilera.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Alex Elder <alex.elder@linaro.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <dborkman@redhat.com>,
        Andre Naujoks <nautsch2@gmail.com>, Jason Baron <jbaron@akamai.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@infradead.org>, Robin Holt <holt@sgi.com>,
        Tony Luck <tony.luck@intel.com>, Alex Thorlton <athorlton@sgi.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Chen Gang <gang.chen@asianux.com>, josh@joshtriplett.org
Subject: [PATCH 02/46] kernel: Add prototype definition to
 include/linux/kernel.h
Message-ID: <644cc80558c61ce1f498393a77df366ad0d7b960.1393493276.git.rashika.kheria@gmail.com>
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

Add prototype declaration to header file include/linux/kernel.h because
it is used by more than one file.

This also eliminates the following warning in kernel/panic.c:
kernel/panic.c:55:13: warning: no previous prototype for ‘panic_smp_self_stop’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/tile/kernel/smp.c |    1 +
 include/linux/kernel.h |    2 ++
 kernel/panic.c         |    1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index 01e8ab2..8b645fd 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -19,6 +19,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <asm/cacheflush.h>
 #include <asm/homecache.h>
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 196d1ea..c7cee7d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -154,6 +154,8 @@ struct completion;
 struct pt_regs;
 struct user;
 
+void __weak panic_smp_self_stop(void);
+
 #ifdef CONFIG_PREEMPT_VOLUNTARY
 extern int _cond_resched(void);
 # define might_resched() _cond_resched()
diff --git a/kernel/panic.c b/kernel/panic.c
index 6d63003..14e08c2 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/nmi.h>
+#include <linux/kernel.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
-- 
1.7.9.5

