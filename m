Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaLZOka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:40:30 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60700 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaLZOk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:40:26 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ad-549d7358eea6
From: "Stefan I. Strogin" <s.strogin@partner.samsung.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: "Stefan I. Strogin" <s.strogin@partner.samsung.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        SeongJae Park <sj38.park@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: [PATCH 1/3] stacktrace: add seq_print_stack_trace()
Date: Fri, 26 Dec 2014 17:39:02 +0300
Message-id: <00bfb81bf8749f3be738d20dd263b81490693309.1419602920.git.s.strogin@partner.samsung.com>
X-Mailer: git-send-email 2.1.0
In-reply-to: <cover.1419602920.git.s.strogin@partner.samsung.com>
References: <cover.1419602920.git.s.strogin@partner.samsung.com>
In-reply-to: <cover.1419602920.git.s.strogin@partner.samsung.com>
References: <cover.1419602920.git.s.strogin@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xK7oRxXNDDN5/lraYs34Nm8Xj1/NY
	LD6tfMpmsbK7mc1ie+cMdovOiUvYLS7vmsNmcW/Nf1aLtUfuslssON7CarHs63t2i77vh9kt
	Js+Wsvh2cg6zxbUd/UwWU2f8YLc4ueEsq8WGZi4HIY/Lfb1MHjtn3WX3mN0xk9Vj06pONo9N
	nyaxe3S9vcLkcWLGbxaPB4c2s3is+/OKyePguz1MHn1bVjF6fN4k59G18RdrAG8Ul01Kak5m
	WWqRvl0CV8aK+5vZCnYLVnzumsXYwHiAr4uRk0NCwESi51EfM4QtJnHh3nq2LkYuDiGBpYwS
	v5r+M0M4vUwS2/ruMoJUsQlYShyb18QEYosAde9unssIUsQsMJtV4uKfDWwgCWEBG4k9Z5az
	g9gsAqoSfbfXgzXzCqRKPNrcyAqxTk5iw+7/YHFOAUeJJ0/WgQ0VEnCQ6Lz4hhWX+ARG/gWM
	DKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQmLo6w7GpcesDjEKcDAq8fAmrJsTIsSaWFZc
	mXuIUYKDWUmEt8psbogQb0piZVVqUX58UWlOavEhRiYOTqkGxui0x82rOT3WpbTIWjm3cVhz
	MEYd4418eKFN2PKBz5Pwojgf3ys2q0SaTqhMvG525nc+n8Am3lXLFtb4vP7nvaMqgrOvoDKy
	8qmmYWBM3Mvg2rd+kmmXJFhZL/QovW2c1OWl/1Iz9q7Q34YnLz4n23O5nOYTUqqr+qzg+agl
	8vPfRx17XsUpsRRnJBpqMRcVJwIAG3s6B38CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function seq_print_stack_trace() which prints stacktraces to seq_files.

Signed-off-by: Stefan I. Strogin <s.strogin@partner.samsung.com>
---
 include/linux/stacktrace.h |  4 ++++
 kernel/stacktrace.c        | 17 +++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 669045a..6d62484 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -2,6 +2,7 @@
 #define __LINUX_STACKTRACE_H
 
 #include <linux/types.h>
+#include <linux/seq_file.h>
 
 struct task_struct;
 struct pt_regs;
@@ -24,6 +25,8 @@ extern void save_stack_trace_tsk(struct task_struct *tsk,
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
 extern int snprint_stack_trace(char *buf, size_t size,
 			struct stack_trace *trace, int spaces);
+extern void seq_print_stack_trace(struct seq_file *m,
+			struct stack_trace *trace, int spaces);
 
 #ifdef CONFIG_USER_STACKTRACE_SUPPORT
 extern void save_stack_trace_user(struct stack_trace *trace);
@@ -37,6 +40,7 @@ extern void save_stack_trace_user(struct stack_trace *trace);
 # define save_stack_trace_user(trace)			do { } while (0)
 # define print_stack_trace(trace, spaces)		do { } while (0)
 # define snprint_stack_trace(buf, size, trace, spaces)	do { } while (0)
+# define seq_print_stack_trace(m, trace, spaces)	do { } while (0)
 #endif
 
 #endif
diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index b6e4c16..66ef6f4 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -57,6 +57,23 @@ int snprint_stack_trace(char *buf, size_t size,
 }
 EXPORT_SYMBOL_GPL(snprint_stack_trace);
 
+void seq_print_stack_trace(struct seq_file *m, struct stack_trace *trace,
+			int spaces)
+{
+	int i;
+
+	if (WARN_ON(!trace->entries))
+		return;
+
+	for (i = 0; i < trace->nr_entries; i++) {
+		unsigned long ip = trace->entries[i];
+
+		seq_printf(m, "%*c[<%p>] %pS\n", 1 + spaces, ' ',
+				(void *) ip, (void *) ip);
+	}
+}
+EXPORT_SYMBOL_GPL(seq_print_stack_trace);
+
 /*
  * Architectures that do not implement save_stack_trace_tsk or
  * save_stack_trace_regs get this weak alias and a once-per-bootup warning
-- 
2.1.0

