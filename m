Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3H3S7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:59:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45578 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3H3S7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:59:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/15] perf trace: Handle missing HUGEPAGE defines
Date: Fri, 30 Aug 2013 15:58:58 -0300
Message-Id: <1377889138-8793-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377889138-8793-1-git-send-email-acme@infradead.org>
References: <1377889138-8793-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Needed for compile on Fedora 12 which goes back to the 2.6.32 kernel.
Might be needed for RHEL6. I use F12 to compile static binaries for
Wind River Linux 4.3.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/n/tip-nd0d7rbajgm8k6tah3xv34v1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 845facc..69a065e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -71,7 +71,9 @@ static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size, unsigned
 	P_MMAP_FLAG(FILE);
 	P_MMAP_FLAG(FIXED);
 	P_MMAP_FLAG(GROWSDOWN);
+#ifdef MAP_HUGETLB
 	P_MMAP_FLAG(HUGETLB);
+#endif
 	P_MMAP_FLAG(LOCKED);
 	P_MMAP_FLAG(NONBLOCK);
 	P_MMAP_FLAG(NORESERVE);
@@ -110,8 +112,12 @@ static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size, uns
 #endif
 	P_MADV_BHV(MERGEABLE);
 	P_MADV_BHV(UNMERGEABLE);
+#ifdef MADV_HUGEPAGE
 	P_MADV_BHV(HUGEPAGE);
+#endif
+#ifdef MADV_NOHUGEPAGE
 	P_MADV_BHV(NOHUGEPAGE);
+#endif
 #ifdef MADV_DONTDUMP
 	P_MADV_BHV(DONTDUMP);
 #endif
-- 
1.8.1.4

