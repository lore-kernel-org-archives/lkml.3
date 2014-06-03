Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbaFCUgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:36:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933835AbaFCUgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:36:44 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jianyu Zhan <nasa4836@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 9/9] perf tools: Fix 'make help' message error
Date: Tue,  3 Jun 2014 22:36:16 +0200
Message-Id: <1401827776-4443-10-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
References: <1401827776-4443-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianyu Zhan <nasa4836@gmail.com>

Currently 'make help' message has such hint:

   use "make prefix=<path> <install target>" to install to a particular
       path like make prefix=/usr/local install install-doc

But this is misleading, when I specify "prefix=/usr/local", it has got no
respect at all.

This is because that, "DESTDIR" is considered first. In this case, "DESTDIR"
has an empty value, so "prefix" is honored. However, "prefix" is unconditionally
assigned to $HOME, regardless of what it is set to from command line. So our
"prefix" setting got no respect and the actual destination falls back to $HOME.

This patch fixes this issue and corrects the help message.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1401727474-19370-1-git-send-email-nasa4836@gmail.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf   | 4 ++--
 tools/perf/config/Makefile | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 6286e13..ae20edf 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -789,8 +789,8 @@ help:
 	@echo ''
 	@echo 'Perf install targets:'
 	@echo '  NOTE: documentation build requires asciidoc, xmlto packages to be installed'
-	@echo '  HINT: use "make prefix=<path> <install target>" to install to a particular'
-	@echo '        path like make prefix=/usr/local install install-doc'
+	@echo '  HINT: use "prefix" or "DESTDIR" to install to a particular'
+	@echo '        path like "make prefix=/usr/local install install-doc"'
 	@echo '  install	- install compiled binaries'
 	@echo '  install-doc	- install *all* documentation'
 	@echo '  install-man	- install manpage documentation'
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 319426f..4f100b5 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -600,7 +600,7 @@ endif
 
 # Make the path relative to DESTDIR, not to prefix
 ifndef DESTDIR
-prefix = $(HOME)
+prefix ?= $(HOME)
 endif
 bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
-- 
1.8.3.1

