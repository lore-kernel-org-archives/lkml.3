Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965728AbaFCWRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:17:54 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:47915 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965068AbaFCWIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:08:44 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 06/32] perf kbuild: store in config-detected missing variables (libdir, ...)
Date: Wed,  4 Jun 2014 00:05:59 +0200
Message-Id: <1401833185-10347-7-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/Makefile.kbuild | 5 ++++-
 tools/perf/config/Makefile | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
index b2d0d08..e82615f 100644
--- a/tools/perf/Makefile.kbuild
+++ b/tools/perf/Makefile.kbuild
@@ -212,8 +212,11 @@ export prefix_SQ
 export PARSER_DEBUG_BISON
 export PARSER_DEBUG_FLEX
 export ETC_PERFCONFIG_SQ
+export libdir_SQ
 export PYTHON_EMBED_CCOPTS
 export PERL_EMBED_CCOPTS
+export GTK_CFLAGS
+
 endif
 
 # let sources know it's kbuild
@@ -262,7 +265,7 @@ $(obj-perf)/built-in.o: $(obj-perf)/common-cmds.h FORCE
 LIBS = -Wl,--whole-archive $^ -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
 tools/perf/perf: $(obj-perf)/built-in.o $(LIBS_A)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(LIBS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $(LIBS) $(GTK_LIBS)
 
 $(LIBTRACEEVENT): FORCE
 	@mkdir -p $(obj-kernel)/tools/lib/traceevent
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1760f57..e10e8bf 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -774,7 +774,10 @@ all:
 	$(call store,ETC_PERFCONFIG_SQ)
 	$(call store,DESTDIR_SQ)
 	$(call store,bindir_SQ)
+	$(call store,libdir_SQ)
 	$(call store,perfexec_instdir_SQ)
 	$(call store,sysconfdir_SQ)
+	$(call store,GTK_CFLAGS)
+	$(call store,GTK_LIBS)
 
 endif # CONFIG_DETECTED
-- 
1.9.3

