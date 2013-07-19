Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935164Ab3GSHqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:46:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935094Ab3GSHqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:46:02 -0400
Date: Fri, 19 Jul 2013 00:45:42 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-4ccdf57d46843f5c03e390bdb652c9744e30ee20@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1370323231-14022-3-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Get rid of unused gui target
Git-Commit-ID: 4ccdf57d46843f5c03e390bdb652c9744e30ee20
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:45:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ccdf57d46843f5c03e390bdb652c9744e30ee20
Gitweb:     http://git.kernel.org/tip/4ccdf57d46843f5c03e390bdb652c9744e30ee20
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:20:17 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:09 -0300

tools lib traceevent: Get rid of unused gui target

It's came from trace-cmd's kernelshark which is not a part of
libtraceevent.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index fd7510d..4505de8 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -71,10 +71,7 @@ $(if $(BUILD_OUTPUT),, \
 
 all: sub-make
 
-gui: force
-	$(call build_output, all_cmd)
-
-$(filter-out gui,$(MAKECMDGOALS)): sub-make
+$(MAKECMDGOALS): sub-make
 
 sub-make: force
 	$(call build_output, $(MAKECMDGOALS))
@@ -253,9 +250,6 @@ define check_deps
 		$(RM) $@.$$$$
 endef
 
-$(gui_deps): ks_version.h
-$(non_gui_deps): tc_version.h
-
 $(all_deps): .%.d: $(src)/%.c
 	$(Q)$(call check_deps)
 
