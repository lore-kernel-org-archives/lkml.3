Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbbAOM5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:57:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbbAOM51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:57:27 -0500
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
Subject: [PATCH 05/36] perf build: Disable make's built-in rules and variables
Date: Thu, 15 Jan 2015 13:55:01 +0100
Message-Id: <1421326532-25660-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't use any built-in rules and variables so we can
disable make's checks for that and build faster.

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
 tools/perf/Makefile.perf | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1f71a32aea78..dd49b40e203b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -84,6 +84,10 @@ ifneq ($(OUTPUT),)
 #$(info Determined 'OUTPUT' to be $(OUTPUT))
 endif
 
+# Do not use make's built-in rules and variables
+# (this increases performance and avoids hard-to-debug behaviour);
+MAKEFLAGS += -rR
+
 $(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
 	@touch $(OUTPUT)PERF-VERSION-FILE
-- 
1.9.3

