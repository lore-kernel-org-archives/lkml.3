Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3KGU37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:29:59 -0500
Received: from mail-pb0-f73.google.com ([209.85.160.73]:52439 "EHLO
	mail-pb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3KGU3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:29:52 -0500
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        handai.szj@taobao.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] percpu: add test module for various percpu operations
References: <1382895017-19067-1-git-send-email-gthelen@google.com>
	<1382895017-19067-2-git-send-email-gthelen@google.com>
	<20131104160918.0c571b410cf165e9c4b4a502@linux-foundation.org>
Date: Thu, 07 Nov 2013 12:29:49 -0800
Message-ID: <xr93li10vttu.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.130007 (Ma Gnus v0.7) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04 2013, Andrew Morton wrote:

> On Sun, 27 Oct 2013 10:30:15 -0700 Greg Thelen <gthelen@google.com> wrote:
>
>> Tests various percpu operations.
>
> Could you please take a look at the 32-bit build (this is i386):
>
> lib/percpu_test.c: In function 'percpu_test_init':
> lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:61: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:70: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:89: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:97: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:112: warning: integer constant is too large for 'long' type
> lib/percpu_test.c:112: warning: integer constant is too large for 'long' type

I was using gcc 4.6 which apparently adds LL suffix as needed.  Though
there were some other code problems with 32 bit beyond missing suffixes.
Fixed version below tested with both gcc 4.4 and gcc 4.6 on 32 and 64
bit x86.

---8<---

>From a95bb1ce42b4492644fa10c7c80fd9bbd7bf23b9 Mon Sep 17 00:00:00 2001
In-Reply-To: <20131104160918.0c571b410cf165e9c4b4a502@linux-foundation.org>
References: <20131104160918.0c571b410cf165e9c4b4a502@linux-foundation.org>
From: Greg Thelen <gthelen@google.com>
Date: Sun, 27 Oct 2013 10:30:15 -0700
Subject: [PATCH v2] percpu: add test module for various percpu operations

Tests various percpu operations.

Enable with CONFIG_PERCPU_TEST=m.

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
Changelog since v1:
- use %lld/x which allows for less casting
- fix 32 bit build by casting large constants

 lib/Kconfig.debug |   9 ++++
 lib/Makefile      |   2 +
 lib/percpu_test.c | 138 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 149 insertions(+)
 create mode 100644 lib/percpu_test.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 094f3152ec2b..1891eb271adf 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1472,6 +1472,15 @@ config INTERVAL_TREE_TEST
 	help
 	  A benchmark measuring the performance of the interval tree library
 
+config PERCPU_TEST
+	tristate "Per cpu operations test"
+	depends on m && DEBUG_KERNEL
+	help
+	  Enable this option to build test module which validates per-cpu
+	  operations.
+
+	  If unsure, say N.
+
 config ATOMIC64_SELFTEST
 	bool "Perform an atomic64_t self-test at boot"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index f3bb2cb98adf..bb016e116ba4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -157,6 +157,8 @@ obj-$(CONFIG_INTERVAL_TREE_TEST) += interval_tree_test.o
 
 interval_tree_test-objs := interval_tree_test_main.o interval_tree.o
 
+obj-$(CONFIG_PERCPU_TEST) += percpu_test.o
+
 obj-$(CONFIG_ASN1) += asn1_decoder.o
 
 obj-$(CONFIG_FONT_SUPPORT) += fonts/
diff --git a/lib/percpu_test.c b/lib/percpu_test.c
new file mode 100644
index 000000000000..0b5d14dadd1a
--- /dev/null
+++ b/lib/percpu_test.c
@@ -0,0 +1,138 @@
+#include <linux/module.h>
+
+/* validate @native and @pcp counter values match @expected */
+#define CHECK(native, pcp, expected)                                    \
+	do {                                                            \
+		WARN((native) != (expected),                            \
+		     "raw %ld (0x%lx) != expected %lld (0x%llx)",	\
+		     (native), (native),				\
+		     (long long)(expected), (long long)(expected));	\
+		WARN(__this_cpu_read(pcp) != (expected),                \
+		     "pcp %ld (0x%lx) != expected %lld (0x%llx)",	\
+		     __this_cpu_read(pcp), __this_cpu_read(pcp),	\
+		     (long long)(expected), (long long)(expected));	\
+	} while (0)
+
+static DEFINE_PER_CPU(long, long_counter);
+static DEFINE_PER_CPU(unsigned long, ulong_counter);
+
+static int __init percpu_test_init(void)
+{
+	/*
+	 * volatile prevents compiler from optimizing it uses, otherwise the
+	 * +ul_one/-ul_one below would replace with inc/dec instructions.
+	 */
+	volatile unsigned int ui_one = 1;
+	long l = 0;
+	unsigned long ul = 0;
+
+	pr_info("percpu test start\n");
+
+	preempt_disable();
+
+	l += -1;
+	__this_cpu_add(long_counter, -1);
+	CHECK(l, long_counter, -1);
+
+	l += 1;
+	__this_cpu_add(long_counter, 1);
+	CHECK(l, long_counter, 0);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul += 1UL;
+	__this_cpu_add(ulong_counter, 1UL);
+	CHECK(ul, ulong_counter, 1);
+
+	ul += -1UL;
+	__this_cpu_add(ulong_counter, -1UL);
+	CHECK(ul, ulong_counter, 0);
+
+	ul += -(unsigned long)1;
+	__this_cpu_add(ulong_counter, -(unsigned long)1);
+	CHECK(ul, ulong_counter, -1);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul -= 1;
+	__this_cpu_dec(ulong_counter);
+	CHECK(ul, ulong_counter, -1);
+	CHECK(ul, ulong_counter, ULONG_MAX);
+
+	l += -ui_one;
+	__this_cpu_add(long_counter, -ui_one);
+	CHECK(l, long_counter, 0xffffffff);
+
+	l += ui_one;
+	__this_cpu_add(long_counter, ui_one);
+	CHECK(l, long_counter, (long)0x100000000LL);
+
+
+	l = 0;
+	__this_cpu_write(long_counter, 0);
+
+	l -= ui_one;
+	__this_cpu_sub(long_counter, ui_one);
+	CHECK(l, long_counter, -1);
+
+	l = 0;
+	__this_cpu_write(long_counter, 0);
+
+	l += ui_one;
+	__this_cpu_add(long_counter, ui_one);
+	CHECK(l, long_counter, 1);
+
+	l += -ui_one;
+	__this_cpu_add(long_counter, -ui_one);
+	CHECK(l, long_counter, (long)0x100000000LL);
+
+	l = 0;
+	__this_cpu_write(long_counter, 0);
+
+	l -= ui_one;
+	this_cpu_sub(long_counter, ui_one);
+	CHECK(l, long_counter, -1);
+	CHECK(l, long_counter, ULONG_MAX);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul += ui_one;
+	__this_cpu_add(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, 1);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul -= ui_one;
+	__this_cpu_sub(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, -1);
+	CHECK(ul, ulong_counter, ULONG_MAX);
+
+	ul = 3;
+	__this_cpu_write(ulong_counter, 3);
+
+	ul = this_cpu_sub_return(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, 2);
+
+	ul = __this_cpu_sub_return(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, 1);
+
+	preempt_enable();
+
+	pr_info("percpu test done\n");
+	return -EAGAIN;  /* Fail will directly unload the module */
+}
+
+static void __exit percpu_test_exit(void)
+{
+}
+
+module_init(percpu_test_init)
+module_exit(percpu_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Greg Thelen");
+MODULE_DESCRIPTION("percpu operations test");
-- 
1.8.4.1


