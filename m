Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499Ab3DKMFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:05:42 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48784 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935332Ab3DKMFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:05:39 -0400
X-AuditID: 9c93016f-b7b3fae0000004d3-cf-5166a711ea9e
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] tools lib traceevent: Get rid of unused gui target
Date: Thu, 11 Apr 2013 21:04:54 +0900
Message-Id: <1365681898-19897-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
References: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's came from trace-cmd's kernelshark which is not a part of
libtraceevent.

Cc: Steven Rostedt <rostedt@goodmis.org>
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

