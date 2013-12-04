Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab3LDULe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:11:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59391 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289Ab3LDUHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/38] tools lib traceevent: Harmonize the install messages in lib-traceevent
Date: Wed,  4 Dec 2013 17:06:41 -0300
Message-Id: <1386187622-2928-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Removing the 'to ...' part out of the install message, because it does
not fit to the rest of the build messages we use.

Before:
  INSTALL  plugin_hrtimer.so    to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_jbd2.so       to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_kmem.so       to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_kvm.so        to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_mac80211.so   to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_sched_switch.so       to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_function.so   to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_xen.so        to      /home/jolsa/libexec/perf-core/traceevent/plugins
  INSTALL  plugin_scsi.so       to      /home/jolsa/libexec/perf-core/traceevent/plugins

Now:
  INSTALL  plugin_jbd2.so
  INSTALL  plugin_hrtimer.so
  INSTALL  plugin_kmem.so
  INSTALL  plugin_kvm.so
  INSTALL  plugin_mac80211.so
  INSTALL  plugin_sched_switch.so
  INSTALL  plugin_function.so
  INSTALL  plugin_xen.so
  INSTALL  plugin_scsi.so

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-7-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 15267988f6b6..f9468519d5f7 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -166,7 +166,7 @@ else
   print_plugin_obj_compile =	echo '  CC FPIC  '$(OBJ);
   print_plugin_build =		echo '  BUILD    PLUGIN '$(OBJ);
   print_static_lib_build =	echo '  BUILD    STATIC LIB '$(OBJ);
-  print_install =		echo '  INSTALL  '$1'	to	$(DESTDIR_SQ)$2';
+  print_install =		echo '  INSTALL  '$1;
 endif
 
 do_fpic_compile =					\
-- 
1.8.1.4

