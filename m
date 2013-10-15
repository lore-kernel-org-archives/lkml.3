Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab3JOFP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:15:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3JOFPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:15:55 -0400
Date: Mon, 14 Oct 2013 22:15:39 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-c7a79e96dc166a1bdadca1367a39c84887e73de3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/build: Split out feature check: '
 gtk2-infobar'
Git-Commit-ID: c7a79e96dc166a1bdadca1367a39c84887e73de3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:15:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7a79e96dc166a1bdadca1367a39c84887e73de3
Gitweb:     http://git.kernel.org/tip/c7a79e96dc166a1bdadca1367a39c84887e73de3
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 30 Sep 2013 15:08:30 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 08:48:42 +0200

tools/perf/build: Split out feature check: 'gtk2-infobar'

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/n/tip-oumjyVjonjvgH8ts4mftagel@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/config/Makefile                                          | 3 ++-
 tools/perf/config/feature-checks/Makefile                           | 4 ++++
 .../perf/config/feature-checks/{test-gtk2.c => test-gtk2-infobar.c} | 6 +++---
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index b3bf931..3d3d435 100644
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
diff --git a/tools/perf/config/feature-checks/test-gtk2.c b/tools/perf/config/feature-checks/test-gtk2-infobar.c
similarity index 61%
copy from tools/perf/config/feature-checks/test-gtk2.c
copy to tools/perf/config/feature-checks/test-gtk2-infobar.c
index 1ac6d8a..eebcfbc 100644
--- a/tools/perf/config/feature-checks/test-gtk2.c
+++ b/tools/perf/config/feature-checks/test-gtk2-infobar.c
@@ -2,9 +2,9 @@
 #include <gtk/gtk.h>
 #pragma GCC diagnostic error "-Wstrict-prototypes"
 
-int main(int argc, char *argv[])
+int main(void)
 {
-        gtk_init(&argc, &argv);
+	gtk_info_bar_new();
 
-        return 0;
+	return 0;
 }
