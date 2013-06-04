Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab3FDFUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:20:39 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62012 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3FDFUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:20:33 -0400
X-AuditID: 9c930179-b7c07ae000000e33-27-51ad792191e7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 01/16] tools lib traceevent: Remove unused install targets
Date: Tue,  4 Jun 2013 14:20:16 +0900
Message-Id: <1370323231-14022-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The html_install, img_install, install_plugin and install_python are
unused in the Makefile.  Get rid of them.

Acked-by: Steven Rostedt <rostedt@goodmig.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/Makefile | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 0b0a90787db6..fd7510d99583 100644
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
1.7.11.7

