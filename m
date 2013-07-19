Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935244Ab3GSHqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:46:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35340 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935048Ab3GSHq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:46:29 -0400
Date: Fri, 19 Jul 2013 00:46:10 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-012ac692575b1ea6ed930871850584e4c64f1382@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1370323231-14022-6-git-send-email-namhyung@kernel.org>
References: <1370323231-14022-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Add page_size field to pevent
Git-Commit-ID: 012ac692575b1ea6ed930871850584e4c64f1382
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:46:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  012ac692575b1ea6ed930871850584e4c64f1382
Gitweb:     http://git.kernel.org/tip/012ac692575b1ea6ed930871850584e4c64f1382
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 14:20:20 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:52:14 -0300

tools lib traceevent: Add page_size field to pevent

The page size of traced system can be different than current system's
because the recorded data file might be analyzed in a different machine.
In this case we should use original page size of traced system when
accessing the data file, so this information needs to be saved.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370323231-14022-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 39f0c1d..c37b202 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -400,6 +400,7 @@ struct pevent {
 
 	int cpus;
 	int long_size;
+	int page_size;
 
 	struct cmdline *cmdlines;
 	struct cmdline_list *cmdlist;
@@ -621,6 +622,16 @@ static inline void pevent_set_long_size(struct pevent *pevent, int long_size)
 	pevent->long_size = long_size;
 }
 
+static inline int pevent_get_page_size(struct pevent *pevent)
+{
+	return pevent->page_size;
+}
+
+static inline void pevent_set_page_size(struct pevent *pevent, int _page_size)
+{
+	pevent->page_size = _page_size;
+}
+
 static inline int pevent_is_file_bigendian(struct pevent *pevent)
 {
 	return pevent->file_bigendian;
