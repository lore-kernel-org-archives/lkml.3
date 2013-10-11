Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3JKAtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:49:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:11959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075Ab3JKAtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:49:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1075,1371106800"; 
   d="scan'208";a="391352661"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v10 12/12] tracing: define trace_dump_stack() if !CONFIG_STACKTRACE
Date: Thu, 10 Oct 2013 19:48:36 -0500
Message-Id: <b88c6631dc9bdd143e5fc19341954e42e59de128.1381445299.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1381445299.git.tom.zanussi@linux.intel.com>
References: <cover.1381445299.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1381445299.git.tom.zanussi@linux.intel.com>
References: <cover.1381445299.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_STACKTRACE is turned off, trace_dump_stack() isn't defined,
resulting in an 'undefined reference' error - define a stub to remedy
that.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 81d95bf..3eca804 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1879,6 +1879,8 @@ static void __trace_userstack(struct trace_array *tr, unsigned long flags)
 }
 #endif /* UNUSED */
 
+#else
+void trace_dump_stack(int skip) {}
 #endif /* CONFIG_STACKTRACE */
 
 /* created for use with alloc_percpu */
-- 
1.7.11.4

