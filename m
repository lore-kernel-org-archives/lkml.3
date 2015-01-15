Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbbAOIX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:23:27 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:49502 "HELO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751277AbbAOIX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:23:26 -0500
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jan 2015 03:23:25 EST
MIME-Version: 1.0
Date: Thu, 15 Jan 2015 10:15:34 +0200
Message-ID: <CAOm-9aqxsiC15Q+VGTB9k37-+VcSTaSZZL3xov7zexf4Pqr8NQ@mail.gmail.com>
Subject: [PATCH] perf bench: fix order of arguments to memcpy_alloc_mem
From: Bruce Merry <bmerry@ska.ac.za>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was causing the destination instead of the source to be filled.
As a result, the source was typically all mapped to one zero page,
and hence very cacheable
---
 tools/perf/bench/mem-memcpy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 6c14afe..db1d3a2 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -289,7 +289,7 @@ static u64 do_memcpy_cycle(const struct routine
*r, size_t len, bool prefault)
     memcpy_t fn = r->fn.memcpy;
     int i;

-    memcpy_alloc_mem(&src, &dst, len);
+    memcpy_alloc_mem(&dst, &src, len);

     if (prefault)
         fn(dst, src, len);
@@ -312,7 +312,7 @@ static double do_memcpy_gettimeofday(const struct
routine *r, size_t len,
     void *src = NULL, *dst = NULL;
     int i;

-    memcpy_alloc_mem(&src, &dst, len);
+    memcpy_alloc_mem(&dst, &src, len);

     if (prefault)
         fn(dst, src, len);
-- 
1.9.1


-- 
Bruce Merry
Senior Science Processing Developer
SKA South Africa
