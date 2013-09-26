Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab3IZS4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:56:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab3IZS4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:56:32 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf tools: Add missing -ldl for gtk build
Date: Thu, 26 Sep 2013 20:55:54 +0200
Message-Id: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we build perf with NO_LIBPYTHON=1 NO_LIBPERL=1 the '-ldl'
is not added to libs build fails if we have gtk2 code in,
because it depends on it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 6850529..8b49a00 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -272,6 +272,7 @@ ifndef NO_GTK2
     CFLAGS += -DGTK2_SUPPORT
     GTK_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
     GTK_LIBS := $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
+    EXTLIBS += -ldl
   endif
 endif
 
-- 
1.7.11.7

