Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab3IETmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:42:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59262 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab3IETmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:42:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/6] perf trace: Check if MAP_32BIT is defined
Date: Thu,  5 Sep 2013 16:42:42 -0300
Message-Id: <1378410163-2606-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378410163-2606-1-git-send-email-acme@infradead.org>
References: <1378410163-2606-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

MAP_32BIT is defined only on x86... this means perf fails to build on
all other platforms.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130905142947.GA25882@merlin.infradead.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6016112..f5aa637 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -100,7 +100,9 @@ static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size,
 
 	P_MMAP_FLAG(SHARED);
 	P_MMAP_FLAG(PRIVATE);
+#ifdef MAP_32BIT
 	P_MMAP_FLAG(32BIT);
+#endif
 	P_MMAP_FLAG(ANONYMOUS);
 	P_MMAP_FLAG(DENYWRITE);
 	P_MMAP_FLAG(EXECUTABLE);
-- 
1.8.1.4

