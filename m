Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab3GDNor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:44:47 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38574 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3GDNon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:44:43 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michael Witten <mfwitten@gmail.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/2] perf/Makefile: do not open-code shell-sq
Date: Thu,  4 Jul 2013 19:10:45 +0530
Message-Id: <1372945246-21605-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372945246-21605-1-git-send-email-artagnon@gmail.com>
References: <1372945246-21605-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d24e473e (perf_counter: copy in Git's top Makefile, 2009-04-20) started
by determining *_SQ variables (shell-quoted equivalents) by calling
subst by hand, with the rationale that $(call) must be avoided to
accommodate ancient setups.  That reasoning does not hold true anymore,
as our Makefiles are filled with $(call) invocations now.  So, use the
shell-sq function introduced in ced465c4 (perf tools: Makefile:
PYTHON{,_CONFIG} to bandage Python 3 incompatibility, 2011-04-02) in
place of open-coding.

Cc: Michael Witten <mfwitten@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/Makefile        |  2 +-
 tools/perf/config/Makefile | 23 +++++++++++------------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 203cb0e..ace1784 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -731,7 +731,7 @@ cscope:
 	$(FIND) . -name '*.[hcS]' -print | xargs cscope -b
 
 ### Detect prefix changes
-TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
+TRACK_CFLAGS = $(call escape-for-shell-sq,$(CFLAGS)):\
              $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)
 
 $(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f139dcd..3025d87 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -457,21 +457,20 @@ ETC_PERFCONFIG = etc/perfconfig
 endif
 lib = lib
 
-# Shell quote (do not use $(call) to accommodate ancient setups);
-ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
-DESTDIR_SQ = $(subst ','\'',$(DESTDIR))
-bindir_SQ = $(subst ','\'',$(bindir))
-mandir_SQ = $(subst ','\'',$(mandir))
-infodir_SQ = $(subst ','\'',$(infodir))
-perfexecdir_SQ = $(subst ','\'',$(perfexecdir))
-template_dir_SQ = $(subst ','\'',$(template_dir))
-htmldir_SQ = $(subst ','\'',$(htmldir))
-prefix_SQ = $(subst ','\'',$(prefix))
-sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
+ETC_PERFCONFIG_SQ = $(call shell-sq,$(ETC_PERFCONFIG))
+DESTDIR_SQ = $(call shell-sq,$(DESTDIR))
+bindir_SQ = $(call shell-sq,$(bindir))
+mandir_SQ = $(call shell-sq,$(mandir))
+infodir_SQ = $(call shell-sq,$(infodir))
+perfexecdir_SQ = $(call shell-sq,$(perfexecdir))
+template_dir_SQ = $(call shell-sq,$(template_dir))
+htmldir_SQ = $(call shell-sq,$(htmldir))
+prefix_SQ = $(call shell-sq,$(prefix))
+sysconfdir_SQ = $(call shell-sq,$(sysconfdir))
 
 ifneq ($(filter /%,$(firstword $(perfexecdir))),)
 perfexec_instdir = $(perfexecdir)
 else
 perfexec_instdir = $(prefix)/$(perfexecdir)
 endif
-perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
+perfexec_instdir_SQ = $(call shell-sq,$(perfexec_instdir))
-- 
1.8.3.1.643.gebeea52.dirty

