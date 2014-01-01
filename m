Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaAAQvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 11:51:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbaAAQvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 11:51:17 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] tools lib traceevent: Shut up plugins make message
Date: Wed,  1 Jan 2014 17:50:50 +0100
Message-Id: <1388595050-23005-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1388595050-23005-1-git-send-email-jolsa@redhat.com>
References: <1388595050-23005-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting rid of following build output:

  $ make O=/tmp/build/perf -C tools/perf/ install-bin
  ...
  make[3]: Nothing to be done for `plugins'.
  make[2]: Nothing to be done for `plugins'.
  ...

which triggers when traceevent library needs to be rebuilt,
but we have plugins built already.

Adding extra 'plugins' target with nop which is visible and
triggers in both Makefile parts (for detached output directory
(O=...) the traceevent Makefile spawns sub make for the build
itself).

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 76fe0ae..f778d48 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -329,9 +329,12 @@ clean:
 
 endif # skip-makefile
 
-PHONY += force
+PHONY += force plugins
 force:
 
+plugins:
+	@echo > /dev/null
+
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable so we can use it in if_changed and friends.
 .PHONY: $(PHONY)
-- 
1.8.3.1

