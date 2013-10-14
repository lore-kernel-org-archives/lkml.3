Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab3JNUDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:03:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38523 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab3JNUCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 022/161] tools/perf/build: Split out feature check: 'gtk2-infobar'
Date: Mon, 14 Oct 2013 17:00:11 -0300
Message-Id: <1381780950-25642-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-oumjyVjonjvgH8ts4mftagel@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                           |  3 ++-
 tools/perf/config/feature-checks/Makefile            |  4 ++++
 tools/perf/config/feature-checks/test-gtk2-infobar.c | 10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/config/feature-checks/test-gtk2-infobar.c

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index b3bf931dd2a0..3d3d435b41fa 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -117,6 +117,7 @@ FEATURE_TESTS =				\
 	libaudit			\
 	libslang			\
 	gtk2				\
+	gtk2-infobar			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -299,7 +300,7 @@ ifndef NO_GTK2
     msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
     NO_GTK2 := 1
   else
-    ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR_SUPPORT),y)
+    ifeq ($(feature-gtk2-infobar), 1)
       CFLAGS += -DHAVE_GTK_INFO_BAR_SUPPORT
     endif
     CFLAGS += -DHAVE_GTK2_SUPPORT
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 920958c83ce8..017918f809ff 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -15,6 +15,7 @@ FILES=					\
 	test-libaudit			\
 	test-libslang			\
 	test-gtk2			\
+	test-gtk2-infobar		\
 	test-libnuma
 
 CC := $(CC) -MD
@@ -73,6 +74,9 @@ test-libslang:
 test-gtk2:
 	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
 
+test-gtk2-infobar:
+	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+
 -include *.d */*.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-gtk2-infobar.c b/tools/perf/config/feature-checks/test-gtk2-infobar.c
new file mode 100644
index 000000000000..eebcfbc45120
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-gtk2-infobar.c
@@ -0,0 +1,10 @@
+#pragma GCC diagnostic ignored "-Wstrict-prototypes"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error "-Wstrict-prototypes"
+
+int main(void)
+{
+	gtk_info_bar_new();
+
+	return 0;
+}
-- 
1.8.1.4

