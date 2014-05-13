Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870AbaEMWM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:12:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45052 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154AbaEMWFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:22 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 07/34] perf kbuild: store in config-detected missing variables (libdir, ...)
Date: Wed, 14 May 2014 00:03:02 +0200
Message-Id: <1400018609-20486-8-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/Makefile.kbuild | 5 ++++-
 tools/perf/config/Makefile | 3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
index 8be891d..93a1a78 100644
--- a/tools/perf/Makefile.kbuild
+++ b/tools/perf/Makefile.kbuild
@@ -214,8 +214,11 @@ export prefix_SQ
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
@@ -264,7 +267,7 @@ $(obj-perf)/built-in.o: $(obj-perf)/common-cmds.h FORCE
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
1.9.2

