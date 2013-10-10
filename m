Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3JJGub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:50:31 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:41638 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3JJGu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:50:28 -0400
Date: Thu, 10 Oct 2013 08:50:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tools/perf/build: Fix DPACKAGE definitions for the libbfd et
 al testcases
Message-ID: <20131010065024.GC10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-27-git-send-email-mingo@kernel.org>
 <871u3tk6ag.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u3tk6ag.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/config/feature-checks/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 8ecac19..cf33596 100644
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
