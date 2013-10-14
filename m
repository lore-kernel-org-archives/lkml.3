Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab3JNUxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:53:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38412 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab3JNUCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 003/161] tools/perf/build: Add 'autodep' functionality, generate feature test dependencies automatically
Date: Mon, 14 Oct 2013 16:59:52 -0300
Message-Id: <1381780950-25642-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Use GCC's -MD feature to generate a dependency file for each feature test .c file,
and include that .d file in the config/feature-checks/Makefile.

This allows us to do two things:

 - speed up feature tests
 - detect removal or changes in build dependencies - including system libraries/headers

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-Jfma8pmPnnqzpxjbs3hpgmsj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/feature-checks/Makefile | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index b3f6372ad8b0..4708ccadfc54 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -1,16 +1,20 @@
 
 FILES=test-hello
 
+CC := $(CC) -MD
+
 all: $(FILES)
 
 BUILD = $(CC) -o $(OUTPUT)$@ $@.c
 
 ###############################
 
-test-hello: test-hello.c
+test-hello:
 	$(BUILD)
 
+-include *.d */*.d
+
 ###############################
 
 clean:
-	rm -f $(FILES)
+	rm -f $(FILES) *.d
-- 
1.8.1.4

