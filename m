Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaFFOMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:12:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:54548 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaFFOMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:12:10 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf tests: Show the inner make output when an error happens
Date: Fri,  6 Jun 2014 11:11:49 -0300
Message-Id: <1402063909-13859-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402063909-13859-1-git-send-email-acme@kernel.org>
References: <1402063909-13859-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Before:

  [acme@zoo linux]$ make -C tools/perf -f tests/make make_static
  make: Entering directory `/home/git/linux/tools/perf'
  - make_static: cd . && make -f Makefile DESTDIR=/tmp/tmp.JcWuM4Zu9f LDFLAGS=-static
  make: *** [make_static] Error 1
  make: Leaving directory `/home/git/linux/tools/perf'
  [acme@zoo linux]$

After:

  [acme@zoo linux]$ make -C tools/perf -f tests/make make_static
  make: Entering directory `/home/git/linux/tools/perf'
  - make_static: cd . && make -f Makefile DESTDIR=/tmp/tmp.X3su83i14u LDFLAGS=-static
  cd . && make -f Makefile DESTDIR=/tmp/tmp.X3su83i14u LDFLAGS=-static
    BUILD:   Doing 'make -j4' parallel build
  config/Makefile:303: *** No static glibc found, please install glibc-static.  Stop.
  make[1]: *** [all] Error 2
    test: test -x ./perf
  make: Leaving directory `/home/git/linux/tools/perf'
  [acme@zoo linux]$

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-s3ycajsl9n249n9e8gomfex5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/make | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 2f92d6e7ee00..c21db653b1f2 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -205,8 +205,7 @@ $(run):
 	( eval $$cmd ) >> $@ 2>&1; \
 	echo "  test: $(call test,$@)" >> $@ 2>&1; \
 	$(call test,$@) && \
-	rm -f $@ \
-	rm -rf $$TMP_DEST
+	rm -rf $@ $$TMP_DEST || cat $@
 
 $(run_O):
 	$(call clean)
-- 
1.9.3

