Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaFEOc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:32:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFEOcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:32:51 -0400
Date: Thu, 5 Jun 2014 07:32:32 -0700
From: tip-bot for Jianyu Zhan <tipbot@zytor.com>
Message-ID: <tip-fc9cabeabf42d76854059e7bce81a02645e7e5ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, nasa4836@gmail.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        nasa4836@gmail.com, jolsa@kernel.org, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1401727474-19370-1-git-send-email-nasa4836@gmail.com>
References: <1401727474-19370-1-git-send-email-nasa4836@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix 'make help' message error
Git-Commit-ID: fc9cabeabf42d76854059e7bce81a02645e7e5ca
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

Commit-ID:  fc9cabeabf42d76854059e7bce81a02645e7e5ca
Gitweb:     http://git.kernel.org/tip/fc9cabeabf42d76854059e7bce81a02645e7e5ca
Author:     Jianyu Zhan <nasa4836@gmail.com>
AuthorDate: Tue, 3 Jun 2014 00:44:34 +0800
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 3 Jun 2014 21:35:12 +0200

perf tools: Fix 'make help' message error

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
