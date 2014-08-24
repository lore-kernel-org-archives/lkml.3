Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaHXPAW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 11:00:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34210 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaHXPAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 11:00:16 -0400
Date: Sun, 24 Aug 2014 07:59:56 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-h7n9te70flmaqfnj6l06ay6r@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Use set_term_quiet()
  instead of open coded equivalent
Git-Commit-ID: 3969cc094a9dbb40e624b259caa73c7a2056b249
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3969cc094a9dbb40e624b259caa73c7a2056b249
Gitweb:     http://git.kernel.org/tip/3969cc094a9dbb40e624b259caa73c7a2056b249
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 15 Aug 2014 16:24:45 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 24 Aug 2014 08:11:18 -0300

perf top: Use set_term_quiet() instead of open coded equivalent

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-h7n9te70flmaqfnj6l06ay6r@git.kernel.org
[ Yanked this out of a patch containing this and some other change ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a77ff6c..9848e27 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -433,18 +433,13 @@ static bool perf_top__handle_keypress(struct perf_top *top, int c)
 
 	if (!perf_top__key_mapped(top, c)) {
 		struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
-		struct termios tc, save;
+		struct termios save;
 
 		perf_top__print_mapped_keys(top);
 		fprintf(stdout, "\nEnter selection, or unmapped key to continue: ");
 		fflush(stdout);
 
-		tcgetattr(0, &save);
-		tc = save;
-		tc.c_lflag &= ~(ICANON | ECHO);
-		tc.c_cc[VMIN] = 0;
-		tc.c_cc[VTIME] = 0;
-		tcsetattr(0, TCSANOW, &tc);
+		set_term_quiet_input(&save);
 
 		poll(&stdin_poll, 1, -1);
 		c = getc(stdin);
