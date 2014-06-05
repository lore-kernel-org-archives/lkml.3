Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaFEOba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:31:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaFEOb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:31:28 -0400
Date: Thu, 5 Jun 2014 07:31:12 -0700
From: tip-bot for Sebastian Andrzej Siewior <tipbot@zytor.com>
Message-ID: <tip-16a6433615c14097fd8d406b10ce6393aebb7017@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, bigeasy@linutronix.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <20140528081918.GA28567@linutronix.de>
References: <20140528081918.GA28567@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Consider header files outside perf directory in tags target
Git-Commit-ID: 16a6433615c14097fd8d406b10ce6393aebb7017
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16a6433615c14097fd8d406b10ce6393aebb7017
Gitweb:     http://git.kernel.org/tip/16a6433615c14097fd8d406b10ce6393aebb7017
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Wed, 28 May 2014 10:19:18 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 3 Jun 2014 21:34:23 +0200

perf tools: Consider header files outside perf directory in tags target

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
