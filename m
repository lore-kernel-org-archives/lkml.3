Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaE0QX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:23:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:56206 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaE0QX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:23:57 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] perf tools: consider header files outside perf directory in tags target
Date: Tue, 27 May 2014 18:23:42 +0200
Message-Id: <1401207822-8695-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.0.rc4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes lookups like "vi -t event_format"

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 tools/perf/Makefile.perf | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 895edd3..8148992 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -812,15 +812,15 @@ INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
 
 TAGS:
 	$(RM) TAGS
-	$(FIND) . -name '*.[hcS]' -print | xargs etags -a
+	$(FIND) . ../lib/traceevent -name '*.[hcS]' -print | xargs etags -a ../../include/uapi/linux/perf_event.h
 
 tags:
 	$(RM) tags
-	$(FIND) . -name '*.[hcS]' -print | xargs ctags -a
+	$(FIND) . ../lib/traceevent -name '*.[hcS]' -print | xargs ctags -a ../../include/uapi/linux/perf_event.h
 
 cscope:
 	$(RM) cscope*
-	$(FIND) . -name '*.[hcS]' -print | xargs cscope -b
+	$(FIND) . ../lib/traceevent -name '*.[hcS]' -print | xargs cscope -b ../../include/uapi/linux/perf_event.h
 
 ### Detect prefix changes
 TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
-- 
2.0.0.rc4

