Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3I0Oci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:32:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab3I0Ocf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:32:35 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/3] perf tools: Adding missing ifdef for cmd_trace call
Date: Fri, 27 Sep 2013 16:32:11 +0200
Message-Id: <1380292332-6518-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380292332-6518-1-git-send-email-jolsa@redhat.com>
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
 <1380292332-6518-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're missing ifdef LIBAUDIT_SUPPORT condition check
for calling cmd_trace, otherwise the NO_LIBAUDIT=1
build fails.

Introduced by commit:
  perf trace: Add 'trace' alias to 'perf trace'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/perf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 48d3be6..d8460fe 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -482,12 +482,14 @@ int main(int argc, const char **argv)
 		goto out;
 	}
 
+#ifdef LIBAUDIT_SUPPORT
 	if (!prefixcmp(cmd, "trace")) {
 		set_buildid_dir();
 		setup_path();
 		argv[0] = "trace";
 		return cmd_trace(argc, argv, NULL);
 	}
+#endif
 
 	/* Look for flags.. */
 	argv++;
-- 
1.7.11.7

