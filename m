Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaHKIxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:53:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbaHKIvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:51:02 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/20] perf top: Use set_term_quiet_input for terminal input
Date: Mon, 11 Aug 2014 10:50:06 +0200
Message-Id: <1407747014-18394-13-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using helper function instead of repeating the code.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-top.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index eca2318b68a3..f19321282436 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -582,20 +582,14 @@ static void *display_thread_tui(void *arg)
 static void *display_thread(void *arg)
 {
 	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
-	struct termios tc, save;
+	struct termios save;
 	struct perf_top *top = arg;
 	int delay_msecs, c;
 
-	tcgetattr(0, &save);
-	tc = save;
-	tc.c_lflag &= ~(ICANON | ECHO);
-	tc.c_cc[VMIN] = 0;
-	tc.c_cc[VTIME] = 0;
-
 	pthread__unblock_sigwinch();
 repeat:
 	delay_msecs = top->delay_secs * 1000;
-	tcsetattr(0, TCSANOW, &tc);
+	set_term_quiet_input(&save);
 	/* trash return*/
 	getc(stdin);
 
-- 
1.8.3.1

