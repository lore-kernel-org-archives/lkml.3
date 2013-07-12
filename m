Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3GLItr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:49:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54683 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab3GLItn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:49:43 -0400
Date: Fri, 12 Jul 2013 01:49:30 -0700
From: tip-bot for Robert Richter <tipbot@zytor.com>
Message-ID: <tip-761a0f395d5d8b7aafe563ecefbc8cf71a214a91@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, robert.richter@calxeda.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, robert.richter@calxeda.com
In-Reply-To: <1367865614-30876-1-git-send-email-rric@kernel.org>
References: <1367865614-30876-1-git-send-email-rric@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix output directory of Documentation/
Git-Commit-ID: 761a0f395d5d8b7aafe563ecefbc8cf71a214a91
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:49:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  761a0f395d5d8b7aafe563ecefbc8cf71a214a91
Gitweb:     http://git.kernel.org/tip/761a0f395d5d8b7aafe563ecefbc8cf71a214a91
Author:     Robert Richter <robert.richter@calxeda.com>
AuthorDate: Mon, 6 May 2013 20:40:14 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 17:31:49 -0300

perf tools: Fix output directory of Documentation/

The OUTPUT directory is wrongly determind leading to:

 make[3]: *** No rule to make target `.../.build/perf/PERF-VERSION-FILE'.  Stop.

Fixing this by using the generic approach in script/Makefile.include.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
Link: http://lkml.kernel.org/r/1367865614-30876-1-git-send-email-rric@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index f751757..5a37a7c 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -1,12 +1,6 @@
+include ../../scripts/Makefile.include
 include ../config/utilities.mak
 
-OUTPUT := ./
-ifeq ("$(origin O)", "command line")
-  ifneq ($(O),)
-	OUTPUT := $(O)/
-  endif
-endif
-
 MAN1_TXT= \
 	$(filter-out $(addsuffix .txt, $(ARTICLES) $(SP_ARTICLES)), \
 		$(wildcard perf-*.txt)) \
@@ -277,7 +271,7 @@ $(MAN_HTML): $(OUTPUT)%.html : %.txt
 
 $(OUTPUT)%.1 $(OUTPUT)%.5 $(OUTPUT)%.7 : $(OUTPUT)%.xml
 	$(QUIET_XMLTO)$(RM) $@ && \
-	$(XMLTO) -o $(OUTPUT) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
 
 $(OUTPUT)%.xml : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
