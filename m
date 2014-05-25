Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbaEYEvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 00:51:38 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50968 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaEYEvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 00:51:37 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org
Cc: linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] perf: fix 'make help' message error
Date: Sun, 25 May 2014 12:50:49 +0800
Message-Id: <1400993449-24094-1-git-send-email-nasa4836@gmail.com>
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

