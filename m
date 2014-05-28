Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaE1BSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 21:18:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36743 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaE1BSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 21:18:12 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: peterz@infradead.org, paulus@samba.org, mingo@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] perf: fix 'make help' message error
Date: Wed, 28 May 2014 09:18:00 +0800
Message-Id: <1401239880-12838-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently 'make help' message has such hint:

   use "make prefix=<path> <install target>" to install to a particular
       path like make prefix=/usr/local install install-doc

But this is misleading, when I specify "prefix=/usr/local", it has got no
respect at all. Instead, what takes effect is the "DESTDIR" variable.
In this case, "DESTDIR" has a empty value, so the actual install
directory falls back $HOME, not '/usr/local'.

Specifying "DESTDIR=/usr/local" will work as desired.

This patch fixes the help message.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 tools/perf/Makefile.perf | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 895edd3..37c5f90 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -784,8 +784,8 @@ help:
 	@echo ''
 	@echo 'Perf install targets:'
 	@echo '  NOTE: documentation build requires asciidoc, xmlto packages to be installed'
-	@echo '  HINT: use "make prefix=<path> <install target>" to install to a particular'
-	@echo '        path like make prefix=/usr/local install install-doc'
+	@echo '  HINT: use "make DESTDIR=<path> <install target>" to install to a particular'
+	@echo '        path like "make DESTDIR=/usr/local install install-doc"'
 	@echo '  install	- install compiled binaries'
 	@echo '  install-doc	- install *all* documentation'
 	@echo '  install-man	- install manpage documentation'
-- 
2.0.0-rc3

