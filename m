Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaASMXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:23:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55705 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaASMXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:23:11 -0500
Date: Sun, 19 Jan 2014 04:22:52 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ac668c7b7d87c1895faf196a337b5ddfd32a0e21@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1389839478-5887-4-git-send-email-namhyung@kernel.org>
References: <1389839478-5887-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Unregister handler when function plugin is unloaded
Git-Commit-ID: ac668c7b7d87c1895faf196a337b5ddfd32a0e21
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 19 Jan 2014 04:22:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac668c7b7d87c1895faf196a337b5ddfd32a0e21
Gitweb:     http://git.kernel.org/tip/ac668c7b7d87c1895faf196a337b5ddfd32a0e21
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 16 Jan 2014 11:31:09 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Jan 2014 16:26:24 -0300

tools lib traceevent: Unregister handler when function plugin is unloaded

The function handler should be unregistered when the plugin is unloaded
otherwise it'll try to access invalid memory.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389839478-5887-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/plugin_function.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 3946148..80ba4ff 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -148,6 +148,9 @@ void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
 {
 	int i, x;
 
+	pevent_unregister_event_handler(pevent, -1, "ftrace", "function",
+					function_handler, NULL);
+
 	for (i = 0; i <= cpus; i++) {
 		for (x = 0; x < fstack[i].size && fstack[i].stack[x]; x++)
 			free(fstack[i].stack[x]);
