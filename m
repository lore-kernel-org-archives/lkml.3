Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3LSNmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:42:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab3LSNmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:42:45 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 8/9] tools lib traceevent: Use global QUIET_CLEAN build output
Date: Thu, 19 Dec 2013 14:42:06 +0100
Message-Id: <1387460527-15030-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using global QUIET_CLEAN build output variable and
so we could have only single clean message:
  CLEAN libtraceevent

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
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
 
-- 
1.8.3.1

