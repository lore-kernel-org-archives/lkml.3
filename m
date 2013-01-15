Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3AOOQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:16:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab3AOOQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:16:40 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>
Subject: [PATCH 4/4] perf tool: Adding formula.conf file for testing
Date: Tue, 15 Jan 2013 14:39:54 +0100
Message-Id: <1358257194-8204-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
---
 tools/perf/formula.conf | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 tools/perf/formula.conf

diff --git a/tools/perf/formula.conf b/tools/perf/formula.conf
new file mode 100644
index 0000000..852cb9a
--- /dev/null
+++ b/tools/perf/formula.conf
@@ -0,0 +1,28 @@
+
+cpi {
+	events = {cycles,instructions}:u
+
+	CPI {
+		formula = cycles / instructions
+		desc = cycles per instruction
+	}
+}
+
+branch {
+	events = {instructions,branch-instructions,branch-misses}:u
+
+	branch-rate {
+		formula = branch-instructions / instructions
+		desc = branch rate
+	}
+
+	branch-miss-rate {
+		formula = branch-misses / instructions
+		desc = branch misprediction rate
+	}
+
+	branch-miss-ratio{
+		formula = branch-misses / branch-instructions
+		desc = branch misprediction ratio
+	}
+}
-- 
1.7.11.7

