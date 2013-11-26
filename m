Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab3KZLWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:22:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500Ab3KZLWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:22:08 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf tools: Fix tags target rebuilding
Date: Tue, 26 Nov 2013 12:21:30 +0100
Message-Id: <1385464890-19876-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once the tags file is generated it's never rebuilt
until it's removed by hand.

The reason is that the Makefile does not treat tags
as a target but as a file to be rebuilt.

Adding tags as PHONY target into the Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4835618..95f5792 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -61,7 +61,7 @@ endef
 #
 # Needed if no target specified:
 #
-all:
+all tags:
 	$(print_msg)
 	$(make)
 
@@ -77,3 +77,5 @@ clean:
 %:
 	$(print_msg)
 	$(make)
+
+.PHONY: tags
-- 
1.8.3.1

