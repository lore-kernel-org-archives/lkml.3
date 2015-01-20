Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbbATQkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:40:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbbATQko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:40:44 -0500
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
Subject: [PATCH 05/36] perf build: Disable make's built-in rules
Date: Tue, 20 Jan 2015 17:39:02 +0100
Message-Id: <1421771973-6022-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't use any built-in rules, so we can disable
make's checks for that and build faster.

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
index aa6a50447c32..8087f97ee4e8 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -84,6 +84,10 @@ ifneq ($(OUTPUT),)
 #$(info Determined 'OUTPUT' to be $(OUTPUT))
 endif
 
+# Do not use make's built-in rules
+# (this increases performance and avoids hard-to-debug behaviour);
+MAKEFLAGS += -r
+
 $(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
 	@touch $(OUTPUT)PERF-VERSION-FILE
-- 
1.9.3

