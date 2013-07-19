Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935085Ab3GSHp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:45:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934572Ab3GSHp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:45:56 -0400
Date: Fri, 19 Jul 2013 00:45:32 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-9f1efa82640b4f06c8f6c847f088c53e4100395c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        rostedt@goodmig.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, rostedt@goodmig.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1370323231-14022-2-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Remove unused install targets
Git-Commit-ID: 9f1efa82640b4f06c8f6c847f088c53e4100395c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:45:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f1efa82640b4f06c8f6c847f088c53e4100395c
Gitweb:     http://git.kernel.org/tip/9f1efa82640b4f06c8f6c847f088c53e4100395c
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:20:16 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:07 -0300

tools lib traceevent: Remove unused install targets

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
