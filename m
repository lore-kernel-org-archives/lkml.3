Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab3JHKWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:22:24 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:43924 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab3JHKMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:25 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 21/52] tools/perf/build: Split out feature check: 'gtk2'
Date: Tue,  8 Oct 2013 12:10:51 +0200
Message-Id: <1381227082-22039-22-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381227082-22039-1-git-send-email-mingo@kernel.org>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
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
 tools/perf/config/Makefile                   |  3 ++-
 tools/perf/config/feature-checks/Makefile    |  4 ++++
 tools/perf/config/feature-checks/test-gtk2.c | 10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index a8f2d67..c72a6fa 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -116,6 +116,7 @@ FEATURE_TESTS =				\
 	libunwind			\
 	libaudit			\
 	libslang			\
+	gtk2				\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -284,7 +285,7 @@ endif
 
 ifndef NO_GTK2
   FLAGS_GTK2=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
-  ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2),gtk2),y)
+  ifneq ($(feature-gtk2), 1)
     msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
     NO_GTK2 := 1
   else
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
1.8.3.1

