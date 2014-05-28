Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaE1ITY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:19:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:60764 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaE1ITW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:19:22 -0400
Date: Wed, 28 May 2014 10:19:18 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH v2] perf tools: consider header files outside perf directory
 in tags target
Message-ID: <20140528081918.GA28567@linutronix.de>
References: <1401207822-8695-1-git-send-email-bigeasy@linutronix.de>
 <20140527163325.GA26128@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140527163325.GA26128@krava.brq.redhat.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes lookups like "vi -t event_format"

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1..v2:
    - add ../lib/{api|symbol}
    - move the files  & folders into a variable which can be resued for
      the three users.

 tools/perf/Makefile.perf | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 895edd3..90e96ea 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -810,17 +810,20 @@ INSTALL_DOC_TARGETS += quick-install-doc quick-install-man quick-install-html
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
2.0.0.rc4

