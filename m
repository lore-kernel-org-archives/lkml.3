Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab3K0UZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:25:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33286 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440Ab3K0UZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:25:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 32/34] perf tools: Fix tags/TAGS targets rebuilding
Date: Wed, 27 Nov 2013 17:16:32 -0300
Message-Id: <1385583394-3703-33-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Once the tags/TAGS file is generated it's never rebuilt until it's
removed by hand.

The reason is that the Makefile does not treat tags/TAGS as targets but
as files and thus won't rebuilt them once they are in place.

Adding PHONY tags/TAGS targets into Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20131126125412.GJ1267@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4835618a5608..eefb9fb0c02f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -60,8 +60,11 @@ endef
 
 #
 # Needed if no target specified:
+# (Except for tags and TAGS targets. The reason is that the
+# Makefile does not treat tags/TAGS as targets but as files
+# and thus won't rebuilt them once they are in place.)
 #
-all:
+all tags TAGS:
 	$(print_msg)
 	$(make)
 
@@ -77,3 +80,5 @@ clean:
 %:
 	$(print_msg)
 	$(make)
+
+.PHONY: tags TAGS
-- 
1.8.1.4

