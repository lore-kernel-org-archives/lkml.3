Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756AbaHVQao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:30:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:33869 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbaHVQaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:30:39 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/16] perf top: Use set_term_quiet() instead of open coded equivalent
Date: Fri, 22 Aug 2014 13:29:26 -0300
Message-Id: <1408724968-3441-15-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408724968-3441-1-git-send-email-acme@kernel.org>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-h7n9te70flmaqfnj6l06ay6r@git.kernel.org
[ Yanked this out of a patch containing this and some other change ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a77ff6ca5fbd..9848e270b92c 100644
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
-- 
1.9.3

