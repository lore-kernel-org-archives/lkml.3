Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3FFLch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:32:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:4917 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab3FFLcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:32:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,814,1363158000"; 
   d="scan'208";a="313181017"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hitoshi Mitake <h.mitake@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] perf bench: fix memory allocation fail check in mem{set,cpy} workloads
Date: Thu,  6 Jun 2013 14:35:03 +0300
Message-Id: <1370518503-4230-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Addresses of allocated memory areas saved to '*src' and '*dst', so we
need to check them for NULL, not 'src' and 'dst'.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 tools/perf/bench/mem-memcpy.c |    4 ++--
 tools/perf/bench/mem-memset.c |    2 +-
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
1.7.10.4

