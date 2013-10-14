Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab3JNUQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:16:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39077 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab3JNUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 149/161] tools/perf/build: Fix DPACKAGE definitions for the libbfd et al testcases
Date: Mon, 14 Oct 2013 17:02:18 -0300
Message-Id: <1381780950-25642-150-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Namhyung Kim reported these duplicate DPACKAGE definitions:

  test-libbfd:
       $(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl

Fix all affected places and use Namhyung's suggestion that the
definition should look like a normal C string: -DPACKAGE='"perf"'.

Reported-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/feature-checks/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 8ecac1908d5e..cf33596c7300 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -37,7 +37,7 @@ BUILD = $(CC) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
 ###############################
 
 test-all:
-	$(BUILD) -Werror -fstack-protector -fstack-protector-all -Wvolatile-register-var -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
+	$(BUILD) -Werror -fstack-protector -fstack-protector-all -Wvolatile-register-var -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
 
 test-hello:
 	$(BUILD)
@@ -123,13 +123,13 @@ test-libpython-version:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
 test-libbfd:
-	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
+	$(BUILD) -DPACKAGE='"perf"' -lbfd -ldl
 
 test-liberty:
-	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl -liberty
+	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty
 
 test-liberty-z:
-	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl -liberty -lz
+	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty -lz
 
 test-cplus-demangle:
 	$(BUILD) -liberty
-- 
1.8.1.4

