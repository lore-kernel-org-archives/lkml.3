Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695Ab3ECNuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:50:00 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:60325 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762337Ab3ECNt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:49:59 -0400
Date: Fri, 3 May 2013 15:49:53 +0200
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH v2] tools: Get only verbose output with V=1
Message-ID: <20130503134953.GU8356@rric.localhost>
References: <1367582851-11944-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367582851-11944-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.05.13 08:07:31, Robert Richter wrote:
> Fix having verbose build with V=0, e.g:
> 
>  make V=0 -C tools/ perf

Arnaldo, there are some more issues with this. Updated patch below.

-Robert



>From 84b1d3c99dc591adfbfab54cf04e1dbeca8f6608 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@calxeda.com>
Date: Thu, 2 May 2013 18:19:09 +0200
Subject: [PATCH] tools: Get only verbose output with V=1

Fix having verbose build with V=0, e.g:

 make V=0 -C tools/ perf

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
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
index 2964b96..14b349f 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -57,7 +57,7 @@ QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifndef V
+ifneq ($(V),1)
 	QUIET_CC       = @echo '   ' CC $@;
 	QUIET_AR       = @echo '   ' AR $@;
 	QUIET_LINK     = @echo '   ' LINK $@;
-- 
1.8.1.1

