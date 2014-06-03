Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288AbaFCUjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933538AbaFCUgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:36:37 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 3/9] perf tools: Consider header files outside perf directory in tags target
Date: Tue,  3 Jun 2014 22:36:10 +0200
Message-Id: <1401827776-4443-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
References: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

This fixes lookups like "vi -t event_format"

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: http://lkml.kernel.org/r/20140528081918.GA28567@linutronix.de
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 67f7c05..6286e13 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -815,17 +815,20 @@ INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
 $(DOC_TARGETS):
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) $(@:doc=all)
 
+TAG_FOLDERS= . ../lib/traceevent ../lib/api ../lib/symbol
+TAG_FILES= ../../include/uapi/linux/perf_event.h
+
 TAGS:
 	$(RM) TAGS
-	$(FIND) . -name '*.[hcS]' -print | xargs etags -a
+	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs etags -a $(TAG_FILES)
 
 tags:
 	$(RM) tags
-	$(FIND) . -name '*.[hcS]' -print | xargs ctags -a
+	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs ctags -a $(TAG_FILES)
 
 cscope:
 	$(RM) cscope*
-	$(FIND) . -name '*.[hcS]' -print | xargs cscope -b
+	$(FIND) $(TAG_FOLDERS) -name '*.[hcS]' -print | xargs cscope -b $(TAG_FILES)
 
 ### Detect prefix changes
 TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
-- 
1.8.3.1

