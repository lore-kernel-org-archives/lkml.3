Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab3FDFYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:24:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56528 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab3FDFUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:20:34 -0400
X-AuditID: 9c930179-b7c07ae000000e33-29-51ad79215bc2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/16] tools lib traceevent: Get rid of unused gui target
Date: Tue,  4 Jun 2013 14:20:17 +0900
Message-Id: <1370323231-14022-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's came from trace-cmd's kernelshark which is not a part of
libtraceevent.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/Makefile | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index fd7510d99583..4505de874929 100644
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
 
-- 
1.7.11.7

