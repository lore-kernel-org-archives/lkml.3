Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaEZTC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:02:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:48041 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbaEZTC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:02:57 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf tools: Add warning when disabling perl scripting support due to missing devel files
Date: Mon, 26 May 2014 16:02:30 -0300
Message-Id: <1401130950-24879-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401130950-24879-1-git-send-email-acme@kernel.org>
References: <1401130950-24879-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were just showing "libperl: OFF", unlike other features where we
present the user with a message helping have a feature built in.

Fix it by adding the following message:

config/Makefile:450: Missing perl devel files. Disabling perl scripting support, consider installing perl-ExtUtils-Embed

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-t7yeud34ehimlfi6pklb29p7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 729bbdf5cec7..319426f632fc 100644
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
1.9.3

