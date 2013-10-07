Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3JGL6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:58:11 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:37034 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3JGL6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:58:07 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 21/50] tools/perf/build: Split out feature check: 'gtk2'
Date: Mon,  7 Oct 2013 13:56:14 +0200
Message-Id: <1381147003-2574-22-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-gfwzurn7wywiviLp7Swyyqsy@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                   |  1 +
 tools/perf/config/feature-checks/Makefile    |  4 ++++
 tools/perf/config/feature-checks/test-gtk2.c | 10 ++++++++++
 3 files changed, 15 insertions(+)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5bd4b87..e657c64 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -116,6 +116,7 @@ FEATURE_TESTS =				\
 	libunwind			\
 	libaudit			\
 	libslang			\
+	gtk2				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index c9b15b0..920958c 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -14,6 +14,7 @@ FILES=					\
 	test-libunwind			\
 	test-libaudit			\
 	test-libslang			\
+	test-gtk2			\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -69,6 +70,9 @@ test-libaudit:
 test-libslang:
 	$(BUILD) -I/usr/include/slang -lslang
 
+test-gtk2:
+	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-gtk2.c b/tools/perf/config/feature-checks/test-gtk2.c
new file mode 100644
index 0000000..1ac6d8a
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-gtk2.c
@@ -0,0 +1,10 @@
+#pragma GCC diagnostic ignored "-Wstrict-prototypes"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error "-Wstrict-prototypes"
+
+int main(int argc, char *argv[])
+{
+        gtk_init(&argc, &argv);
+
+        return 0;
+}
-- 
1.7.11.7

