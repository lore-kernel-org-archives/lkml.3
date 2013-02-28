Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab3CAQm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:42:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33722 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CAQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:39:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/15] perf tools: Honor parallel jobs
Date: Thu, 28 Feb 2013 18:05:15 -0300
Message-Id: <1362085527-25326-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1362085527-25326-1-git-send-email-acme@infradead.org>
References: <1362085527-25326-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We need to hand down parallel build options like the internal make
--jobserver-fds one so that parallel builds can also happen when
building perf from the toplevel directory.

Make it so #1!

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1361374353-30385-3-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Makefile                       | 4 ++--
 tools/scripts/Makefile.include | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 2cd4c6b..f14a9c9 100644
--- a/Makefile
+++ b/Makefile
@@ -1330,11 +1330,11 @@ kernelversion:
 # Clear a bunch of variables before executing the submake
 tools/: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(filter --j% -j,$(MAKEFLAGS))" O=$(objtree) subdir=tools -C $(src)/tools/
 
 tools/%: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(objtree) subdir=tools -C $(src)/tools/ $*
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(filter --j% -j,$(MAKEFLAGS))" O=$(objtree) subdir=tools -C $(src)/tools/ $*
 
 # Single targets
 # ---------------------------------------------------------------------------
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 2964b96..00a05f4 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -70,7 +70,7 @@ ifndef V
 	QUIET_BISON    = @echo '   ' BISON $@;
 
 	descend = \
-		@echo '   ' DESCEND $(1); \
+		+@echo '   ' DESCEND $(1); \
 		mkdir -p $(OUTPUT)$(1) && \
 		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
 endif
-- 
1.8.1.1.361.gec3ae6e

