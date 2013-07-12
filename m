Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab3GLItq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:49:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54681 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292Ab3GLItm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:49:42 -0400
Date: Fri, 12 Jul 2013 01:49:21 -0700
From: tip-bot for Robert Richter <tipbot@zytor.com>
Message-ID: <tip-5125bc22e7871b46e71312d6cc4455e9eea1619d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, robert.richter@calxeda.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, robert.richter@calxeda.com
In-Reply-To: <20130503134953.GU8356@rric.localhost>
References: <20130503134953.GU8356@rric.localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools: Get only verbose output with V=1
Git-Commit-ID: 5125bc22e7871b46e71312d6cc4455e9eea1619d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:49:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5125bc22e7871b46e71312d6cc4455e9eea1619d
Gitweb:     http://git.kernel.org/tip/5125bc22e7871b46e71312d6cc4455e9eea1619d
Author:     Robert Richter <robert.richter@calxeda.com>
AuthorDate: Fri, 3 May 2013 15:49:53 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 17:31:34 -0300

tools: Get only verbose output with V=1

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
