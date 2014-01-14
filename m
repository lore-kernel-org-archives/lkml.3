Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaANQjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:39:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52609 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaANQi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:38:56 -0500
Date: Tue, 14 Jan 2014 08:38:29 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-9bb8e5edcf37182d0c97e98131cc3c5c03014b0e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1388595050-23005-2-git-send-email-jolsa@redhat.com>
References: <1388595050-23005-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Shut up plugins make message
Git-Commit-ID: 9bb8e5edcf37182d0c97e98131cc3c5c03014b0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:38:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9bb8e5edcf37182d0c97e98131cc3c5c03014b0e
Gitweb:     http://git.kernel.org/tip/9bb8e5edcf37182d0c97e98131cc3c5c03014b0e
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 1 Jan 2014 17:50:50 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:23 -0300

tools lib traceevent: Shut up plugins make message

Getting rid of following build output:

  $ make O=/tmp/build/perf -C tools/perf/ install-bin
  ...
  make[3]: Nothing to be done for `plugins'.
  make[2]: Nothing to be done for `plugins'.
  ...

which triggers when traceevent library needs to be rebuilt, but we have
plugins built already.

Adding extra 'plugins' target with nop which is visible and triggers in
both Makefile parts (for detached output directory (O=...) the
traceevent Makefile spawns sub make for the build itself).

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1388595050-23005-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
