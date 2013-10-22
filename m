Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3JVK5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:57:14 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:36052 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659Ab3JVK5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:57:13 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] perf timechart: add support for displaying only tasks related data
Date: Tue, 22 Oct 2013 14:56:49 +0400
Message-Id: <1382439412-23713-4-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
References: <1382439412-23713-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make SVG smaller and faster to browse add possibility to
switch off power related information with -T switch.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-timechart.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index e6c041301aa4..c7b30a8c7f3b 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -41,6 +41,7 @@
 #define PWR_EVENT_EXIT -1
 
 static int proc_num = 15;
+static bool no_power;
 
 
 static unsigned int	numcpus;
@@ -967,7 +968,8 @@ static void write_svg_file(const char *filename)
 	draw_cpu_usage();
 	if (proc_num)
 		draw_process_bars();
-	draw_c_p_states();
+	if (!no_power)
+		draw_c_p_states();
 	if (proc_num)
 		draw_wakeups();
 
@@ -1076,6 +1078,15 @@ static int __cmd_record(int argc, const char **argv)
 }
 
 static int
+parse_tasks(const struct option *opt __maybe_unused,
+	    const char *arg __maybe_unused,
+	    int unset __maybe_unused)
+{
+	no_power = 1;
+	return 0;
+}
+
+static int
 parse_process(const struct option *opt __maybe_unused, const char *arg,
 	      int __maybe_unused unset)
 {
@@ -1103,6 +1114,8 @@ int cmd_timechart(int argc, const char **argv,
 	OPT_INTEGER('w', "width", &svg_page_width, "page width"),
 	OPT_CALLBACK_NOOPT('P', "power-only", NULL, NULL,
 		     "output power data only", parse_power),
+	OPT_CALLBACK_NOOPT('T', "tasks-only", NULL, NULL,
+		     "output processes data only", parse_tasks),
 	OPT_CALLBACK('p', "process", NULL, "process",
 		      "process selector. Pass a pid or process name.",
 		       parse_process),
-- 
1.8.1.2

