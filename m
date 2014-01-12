Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaALSfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:35:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaALSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:35:25 -0500
Date: Sun, 12 Jan 2014 10:35:04 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-4c7aafc950178cd78f8cbda916ee8208afe039b5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1387460527-15030-10-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-10-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Use global 'O'
  processing code
Git-Commit-ID: 4c7aafc950178cd78f8cbda916ee8208afe039b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:35:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c7aafc950178cd78f8cbda916ee8208afe039b5
Gitweb:     http://git.kernel.org/tip/4c7aafc950178cd78f8cbda916ee8208afe039b5
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 19 Dec 2013 14:42:07 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 16:18:12 -0300

tools lib traceevent: Use global 'O' processing code

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
