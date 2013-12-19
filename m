Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3LSNm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:42:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906Ab3LSNmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:42:47 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 9/9] tools lib traceevent: Use global 'O' processing code
Date: Thu, 19 Dec 2013 14:42:07 +0100
Message-Id: <1387460527-15030-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using global 'O' processing code because it's already
setup due to the scripts/Makefile.include include.

Using global variable OUTPUT instead of the local
BUILD_OUTPUT.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/Makefile | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3496c9c..ca4ab78 100644
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
1.8.3.1

