Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3GJT0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:26:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57059 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3GJT0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:26:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@calxeda.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/23] tools: Get only verbose output with V=1
Date: Wed, 10 Jul 2013 16:19:01 -0300
Message-Id: <1373483963-19277-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

Fix having verbose build with V=0, e.g:

 make V=0 -C tools/ perf

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
Link: http://lkml.kernel.org/r/20130503134953.GU8356@rric.localhost
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile | 2 +-
 tools/perf/config/utilities.mak   | 2 +-
 tools/scripts/Makefile.include    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index eb30044..f751757 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -150,7 +150,7 @@ NO_SUBDIR = :
 endif
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifndef V
+ifneq ($(V),1)
 	QUIET_ASCIIDOC	= @echo '   ' ASCIIDOC $@;
 	QUIET_XMLTO	= @echo '   ' XMLTO $@;
 	QUIET_DB2TEXI	= @echo '   ' DB2TEXI $@;
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 8ef3bd3..faffb52 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -181,7 +181,7 @@ _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 
 # try-cc
 # Usage: option = $(call try-cc, source-to-build, cc-options, msg)
-ifndef V
+ifneq ($(V),1)
 TRY_CC_OUTPUT= > /dev/null 2>&1
 endif
 TRY_CC_MSG=echo "    CHK $(3)" 1>&2;
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index f03e681..0d0506d 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -59,7 +59,7 @@ QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifndef V
+ifneq ($(V),1)
 	QUIET_CC       = @echo '   ' CC $@;
 	QUIET_AR       = @echo '   ' AR $@;
 	QUIET_LINK     = @echo '   ' LINK $@;
-- 
1.8.1.4

