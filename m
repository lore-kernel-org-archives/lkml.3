Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab3GJT0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:26:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57064 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3GJT0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:26:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hitoshi Mitake <h.mitake@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/23] perf bench: Fix memory allocation fail check in mem{set,cpy} workloads
Date: Wed, 10 Jul 2013 16:19:04 -0300
Message-Id: <1373483963-19277-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Addresses of allocated memory areas saved to '*src' and '*dst', so we
need to check them for NULL, not 'src' and 'dst'.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hitoshi Mitake <mitake.hitoshi@lab.ntt.co.jp>
Cc: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1370518503-4230-1-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memcpy.c | 4 ++--
 tools/perf/bench/mem-memset.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 93c83e3..25fd3f1 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -111,11 +111,11 @@ static double timeval2double(struct timeval *ts)
 static void alloc_mem(void **dst, void **src, size_t length)
 {
 	*dst = zalloc(length);
-	if (!dst)
+	if (!*dst)
 		die("memory allocation failed - maybe length is too large?\n");
 
 	*src = zalloc(length);
-	if (!src)
+	if (!*src)
 		die("memory allocation failed - maybe length is too large?\n");
 }
 
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index c6e4bc5..4a2f120 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -111,7 +111,7 @@ static double timeval2double(struct timeval *ts)
 static void alloc_mem(void **dst, size_t length)
 {
 	*dst = zalloc(length);
-	if (!dst)
+	if (!*dst)
 		die("memory allocation failed - maybe length is too large?\n");
 }
 
-- 
1.8.1.4

