Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbaFCUho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:37:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934016AbaFCUg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:36:59 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 2/9] perf tools: Add warning when disabling perl scripting support due to missing devel files
Date: Tue,  3 Jun 2014 22:36:09 +0200
Message-Id: <1401827776-4443-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
References: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were just showing "libperl: OFF", unlike other features where we
present the user with a message helping have a feature built in.

Fix it by adding the following message:

config/Makefile:450: Missing perl devel files. Disabling perl scripting support, consider installing perl-ExtUtils-Embed

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-t7yeud34ehimlfi6pklb29p7@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/config/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 729bbdf..319426f 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -447,6 +447,7 @@ else
   ifneq ($(feature-libperl), 1)
     CFLAGS += -DNO_LIBPERL
     NO_LIBPERL := 1
+    msg := $(warning Missing perl devel files. Disabling perl scripting support, consider installing perl-ExtUtils-Embed);
   else
     LDFLAGS += $(PERL_EMBED_LDFLAGS)
     EXTLIBS += $(PERL_EMBED_LIBADD)
-- 
1.8.3.1

