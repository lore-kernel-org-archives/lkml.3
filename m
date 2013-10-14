Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab3JNUOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:14:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39108 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 113/161] perf tools: Add missing -ldl for gtk build
Date: Mon, 14 Oct 2013 17:01:42 -0300
Message-Id: <1381780950-25642-114-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

If we build perf with NO_LIBPYTHON=1 NO_LIBPERL=1 the '-ldl' is not
added to libs build fails if we have gtk2 code in, because it depends on
it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1380221754-29865-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index cf6ad5db19dc..29ad7d6c5311 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -382,6 +382,7 @@ ifndef NO_GTK2
     CFLAGS += -DHAVE_GTK2_SUPPORT
     GTK_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
     GTK_LIBS := $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
+    EXTLIBS += -ldl
   endif
 endif
 
-- 
1.8.1.4

