Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332Ab3GRULZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:11:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41482 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400Ab3GRTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/76] tools lib traceevent: Remove unused install targets
Date: Thu, 18 Jul 2013 16:49:05 -0300
Message-Id: <1374177003-3706-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The html_install, img_install, install_plugin and install_python are
unused in the Makefile.  Get rid of them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmig.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 0b0a907..fd7510d 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -39,13 +39,8 @@ bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
 man_dir = $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
-html_install = $(prefix)/share/kernelshark/html
-html_install_SQ = '$(subst ','\'',$(html_install))'
-img_install = $(prefix)/share/kernelshark/html/images
-img_install_SQ = '$(subst ','\'',$(img_install))'
 
-export man_dir man_dir_SQ html_install html_install_SQ INSTALL
-export img_install img_install_SQ
+export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
 
 # copy a bit from Linux kbuild
@@ -300,7 +295,7 @@ define do_install
 	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
 endef
 
-install_lib: all_cmd install_plugins install_python
+install_lib: all_cmd
 	$(Q)$(call do_install,$(LIB_FILE),$(bindir_SQ))
 
 install: install_lib
-- 
1.8.1.4

