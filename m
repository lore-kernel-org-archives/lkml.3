Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3H2KLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:11:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35239 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab3H2KL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:11:26 -0400
Date: Thu, 29 Aug 2013 03:10:35 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-pvr7uppe329gw9onchgdu0m6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, rostedt@goodmis.org,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        bp@suse.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Fixup jobserver setup
Git-Commit-ID: 456da532a5fb04f8a79622df7dd49e84e04f31a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:10:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  456da532a5fb04f8a79622df7dd49e84e04f31a8
Gitweb:     http://git.kernel.org/tip/456da532a5fb04f8a79622df7dd49e84e04f31a8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 26 Aug 2013 13:04:04 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 27 Aug 2013 11:05:55 -0300

tools lib traceevent: Fixup jobserver setup

Getting rid of:

make[1]: Entering directory `/home/git/linux/tools/lib/traceevent'
make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent
make rule.
make[1]: Entering directory `/home/git/linux/tools/lib/lk

When running:

 make -j4 O=/tmp/build/perf -C tools/perf install-bin

Acked-by: Borislav Petkov <bp@suse.de>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-pvr7uppe329gw9onchgdu0m6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 0794acc..ca6cb77 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -60,7 +60,7 @@ ifeq ($(BUILD_SRC),)
 ifneq ($(BUILD_OUTPUT),)
 
 define build_output
-	$(if $(VERBOSE:1=),@)$(MAKE) -C $(BUILD_OUTPUT) 	\
+	$(if $(VERBOSE:1=),@)+$(MAKE) -C $(BUILD_OUTPUT) 	\
 	BUILD_SRC=$(CURDIR) -f $(CURDIR)/Makefile $1
 endef
 
