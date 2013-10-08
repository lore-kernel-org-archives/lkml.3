Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3JHKVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:21:43 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41849 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3JHKM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:12:26 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 22/52] tools/perf/build: Split out feature check: 'gtk2-infobar'
Date: Tue,  8 Oct 2013 12:10:52 +0200
Message-Id: <1381227082-22039-23-git-send-email-mingo@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-oumjyVjonjvgH8ts4mftagel@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                           |  3 ++-
 tools/perf/config/feature-checks/Makefile            |  4 ++++
 tools/perf/config/feature-checks/test-gtk2-infobar.c | 10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c72a6fa..ca59b56 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -117,6 +117,7 @@ FEATURE_TESTS =				\
 	libaudit			\
 	libslang			\
 	gtk2				\
+	gtk2-infobar			\
 	libnuma
 
 $(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
@@ -289,7 +290,7 @@ ifndef NO_GTK2
     msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
     NO_GTK2 := 1
   else
-    ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR_SUPPORT),y)
+    ifeq ($(feature-gtk2-infobar), 1)
       CFLAGS += -DHAVE_GTK_INFO_BAR_SUPPORT
     endif
     CFLAGS += -DHAVE_GTK2_SUPPORT
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 920958c..017918f 100644
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
index 0000000..eebcfbc
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
1.8.3.1

