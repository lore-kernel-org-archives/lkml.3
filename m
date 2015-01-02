Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbbABPhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:37:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbbABPhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:37:17 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/30] perf build: Add subdir framework support
Date: Fri,  2 Jan 2015 16:35:45 +0100
Message-Id: <1420212972-21595-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
References: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to make directory any time we build objects
out of the tree (O=/tmp/krava) and the output directory
does not exist.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile.build | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/Makefile.build b/tools/perf/Makefile.build
index 68556874ea86..cbd4d416a237 100644
--- a/tools/perf/Makefile.build
+++ b/tools/perf/Makefile.build
@@ -30,6 +30,10 @@ subdir-obj-y :=
 build-file := $(dir)/Build
 include $(build-file)
 
+# Create directory unless it exists
+quiet_cmd_mkdir = MKDIR    $(dir $@)
+      cmd_mkdir = $(if $(wildcard $(dir $@)),,@$(call echo-cmd,mkdir) mkdir -p $(dir $@))
+
 # Compile command
 quiet_cmd_cc_o_c = CC       $@
       cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $<
@@ -40,9 +44,11 @@ quiet_cmd_ld_multi = LD       $@
 
 # Build rules
 $(OUTPUT)%.o: %.c FORCE
+	$(call cmd_mkdir)
 	$(call if_changed_dep,cc_o_c)
 
 $(OUTPUT)%.o: %.S FORCE
+	$(call cmd_mkdir)
 	$(call if_changed_dep,cc_o_c)
 
 # Gather build data:
-- 
1.9.3

