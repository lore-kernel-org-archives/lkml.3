Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaASMYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:24:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55869 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaASMYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:24:37 -0500
Date: Sun, 19 Jan 2014 04:24:18 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-bf6b3a95ff439b1dcd6151b3f38810f3cec1e319@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1389839478-5887-13-git-send-email-namhyung@kernel.org>
References: <1389839478-5887-13-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Unregister handler when xen plugin is unloaded
Git-Commit-ID: bf6b3a95ff439b1dcd6151b3f38810f3cec1e319
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 19 Jan 2014 04:24:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf6b3a95ff439b1dcd6151b3f38810f3cec1e319
Gitweb:     http://git.kernel.org/tip/bf6b3a95ff439b1dcd6151b3f38810f3cec1e319
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 16 Jan 2014 11:31:18 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Jan 2014 16:26:25 -0300

tools lib traceevent: Unregister handler when xen plugin is unloaded

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
Link: http://lkml.kernel.org/r/1389839478-5887-13-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/plugin_xen.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/traceevent/plugin_xen.c b/tools/lib/traceevent/plugin_xen.c
index e779429..3a413ea 100644
--- a/tools/lib/traceevent/plugin_xen.c
+++ b/tools/lib/traceevent/plugin_xen.c
@@ -128,3 +128,9 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 				       PEVENT_FUNC_ARG_VOID);
 	return 0;
 }
+
+void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+{
+	pevent_unregister_print_function(pevent, process_xen_hypercall_name,
+					 "xen_hypercall_name");
+}
