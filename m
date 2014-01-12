Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaALSfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:35:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45649 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaALSfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:35:13 -0500
Date: Sun, 12 Jan 2014 10:34:54 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-4a953c716af285c94432e2d303ca5ee8f66129c0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1387460527-15030-9-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-9-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Use global QUIET_CLEAN build output
Git-Commit-ID: 4a953c716af285c94432e2d303ca5ee8f66129c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:35:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a953c716af285c94432e2d303ca5ee8f66129c0
Gitweb:     http://git.kernel.org/tip/4a953c716af285c94432e2d303ca5ee8f66129c0
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 19 Dec 2013 14:42:06 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 16:18:11 -0300

tools lib traceevent: Use global QUIET_CLEAN build output

Using global QUIET_CLEAN build output variable and so we could have only
single clean message:

  CLEAN libtraceevent

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1387460527-15030-9-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 8ea4368..3496c9c 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -328,8 +328,9 @@ install_plugins: $(PLUGINS)
 install: install_lib
 
 clean:
-	$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d
-	$(RM) TRACEEVENT-CFLAGS tags TAGS
+	$(call QUIET_CLEAN, libtraceevent) \
+		$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d \
+		$(RM) TRACEEVENT-CFLAGS tags TAGS
 
 endif # skip-makefile
 
