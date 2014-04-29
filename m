Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbaD2Idu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaD2Ids (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:33:48 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf tests: Add static build make test
Date: Tue, 29 Apr 2014 10:33:33 +0200
Message-Id: <1398760413-7574-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test for building static perf build into the automated
suite. Also available via following commands:

  $ make -f tests/make make_static
  - make_static: cd . && make -f Makefile DESTDIR=/tmp/tmp.7u5MlB4njo LDFLAGS=-static
  $ make -f tests/make make_static_O
  - make_static_O: cd . && make -f Makefile O=/tmp/tmp.Ay6r3wEmtX DESTDIR=/tmp/tmp.vK0KQwO0Vi LDFLAGS=-static

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/make | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 5daeae1..2f92d6e 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -46,6 +46,7 @@ make_install_man    := install-man
 make_install_html   := install-html
 make_install_info   := install-info
 make_install_pdf    := install-pdf
+make_static         := LDFLAGS=-static
 
 # all the NO_* variable combined
 make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
@@ -87,6 +88,7 @@ run += make_install_bin
 # run += make_install_info
 # run += make_install_pdf
 run += make_minimal
+run += make_static
 
 ifneq ($(call has,ctags),)
 run += make_tags
-- 
1.8.3.1

