Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab3JNUYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:24:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38969 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3JNUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 132/161] perf tools: Fix redirection printouts
Date: Mon, 14 Oct 2013 17:02:01 -0300
Message-Id: <1381780950-25642-133-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Fix the duplicate util/util printout Arnaldo reported:

       $ make V=1 O=/tmp/build/perf -C tools/perf/ util/srcline.o
   ...
       # Redirected target util/srcline.o =>     /tmp/build/perf/util/util/srcline.o

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20131010054256.GA23716@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 2badb08a0037..8bc6d0c4e776 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -600,11 +600,11 @@ ifneq ($(OUTPUT),)
 %.o: $(OUTPUT)%.o
 	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 util/%.o: $(OUTPUT)util/%.o
-	@echo "    # Redirected target $@ => $(OUTPUT)util/$@"
+	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 bench/%.o: $(OUTPUT)bench/%.o
-	@echo "    # Redirected target $@ => $(OUTPUT)bench/$@"
+	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 tests/%.o: $(OUTPUT)tests/%.o
-	@echo "    # Redirected target $@ => $(OUTPUT)tests/$@"
+	@echo "    # Redirected target $@ => $(OUTPUT)$@"
 endif
 
 # These two need to be here so that when O= is not used they take precedence
-- 
1.8.1.4

