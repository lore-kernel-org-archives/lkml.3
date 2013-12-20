Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3LTTKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38549 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3LTTJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 26/35] tools lib traceevent: Use global 'O' processing code
Date: Fri, 20 Dec 2013 16:09:01 -0300
Message-Id: <1387566550-3524-27-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Using global 'O' processing code because it's already setup due to the
scripts/Makefile.include include.

Using global variable OUTPUT instead of the local BUILD_OUTPUT.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1387460527-15030-10-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3496c9ce84d4..ca4ab78425d1 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -83,18 +83,13 @@ ifeq ("$(origin O)", "command line")
 endif
 
 ifeq ($(BUILD_SRC),)
-ifneq ($(BUILD_OUTPUT),)
+ifneq ($(OUTPUT),)
 
 define build_output
-	$(if $(VERBOSE:1=),@)+$(MAKE) -C $(BUILD_OUTPUT) 	\
-	BUILD_SRC=$(CURDIR) -f $(CURDIR)/Makefile $1
+	$(if $(VERBOSE:1=),@)+$(MAKE) -C $(OUTPUT) \
+	BUILD_SRC=$(CURDIR)/ -f $(CURDIR)/Makefile $1
 endef
 
-saved-output := $(BUILD_OUTPUT)
-BUILD_OUTPUT := $(shell cd $(BUILD_OUTPUT) && /bin/pwd)
-$(if $(BUILD_OUTPUT),, \
-     $(error output directory "$(saved-output)" does not exist))
-
 all: sub-make
 
 $(MAKECMDGOALS): sub-make
@@ -106,7 +101,7 @@ sub-make: force
 # Leave processing to above invocation of make
 skip-makefile := 1
 
-endif # BUILD_OUTPUT
+endif # OUTPUT
 endif # BUILD_SRC
 
 # We process the rest of the Makefile if this is the final invocation of make
-- 
1.8.1.4

