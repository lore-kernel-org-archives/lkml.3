Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbbAOJU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:20:57 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:58891 "HELO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751155AbbAOJUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:20:33 -0500
Date: Thu, 15 Jan 2015 11:20:22 +0200
From: Bruce Merry <bmerry@ska.ac.za>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH v2] perf bench: fix order of arguments to memcpy_alloc_mem
Message-ID: <20150115092022.GA11292@kryton>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was causing the destination instead of the source to be filled.
As a result, the source was typically all mapped to one zero page,
and hence very cacheable.

Signed-off-by: Bruce Merry <bmerry@ska.ac.za>
---
 tools/perf/bench/mem-memcpy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 6c14afe..db1d3a2 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -289,7 +289,7 @@ static u64 do_memcpy_cycle(const struct routine *r, size_t len, bool prefault)
 	memcpy_t fn = r->fn.memcpy;
 	int i;
 
-	memcpy_alloc_mem(&src, &dst, len);
+	memcpy_alloc_mem(&dst, &src, len);
 
 	if (prefault)
 		fn(dst, src, len);
@@ -312,7 +312,7 @@ static double do_memcpy_gettimeofday(const struct routine *r, size_t len,
 	void *src = NULL, *dst = NULL;
 	int i;
 
-	memcpy_alloc_mem(&src, &dst, len);
+	memcpy_alloc_mem(&dst, &src, len);
 
 	if (prefault)
 		fn(dst, src, len);
-- 
1.9.1


