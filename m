Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab3JIJtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:49:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49892 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab3JIJtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:49:40 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/4] tools/perf/build: Align perf version output to other build messages
Date: Wed,  9 Oct 2013 11:49:28 +0200
Message-Id: <1381312169-17354-4-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381312169-17354-1-git-send-email-mingo@kernel.org>
References: <1381312169-17354-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:

  CC util/pmu.o
  CC util/parse-events.o
PERF_VERSION = 3.12.rc4.g1b30c
  CC util/parse-events-flex.o
  GEN perf-archive

After:

  CC util/pmu.o
  CC util/parse-events.o
  PERF_VERSION = 3.12.rc4.g1b30c
  CC util/parse-events-flex.o
  GEN perf-archive

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/util/PERF-VERSION-GEN | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 15a77b7..ce7a804 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -40,7 +40,7 @@ else
 	VC=unset
 fi
 test "$VN" = "$VC" || {
-	echo >&2 "PERF_VERSION = $VN"
+	echo >&2 "  PERF_VERSION = $VN"
 	echo "#define PERF_VERSION \"$VN\"" >$GVF
 }
 
-- 
1.8.3.1

