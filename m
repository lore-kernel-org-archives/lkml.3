Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbaD3Pdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:33:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759243AbaD3PdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:33:24 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 7/7] perf tests x86: Fix stack map lookup in dwarf unwind test
Date: Wed, 30 Apr 2014 17:32:51 +0200
Message-Id: <1398871971-381-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398871971-381-1-git-send-email-jolsa@kernel.org>
References: <1398871971-381-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous commit 'perf x86: Fix perf to use non-executable stack, again'
moved stack map into MAP__VARIABLE map type again. Fixing the dwarf
unwind test stack map lookup appropriately.

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Link: http://lkml.kernel.org/n/tip-ttzyhbe4zls24z7ednkmhvxl@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/arch/x86/tests/dwarf-unwind.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
index b8c0102..83bc238 100644
--- a/tools/perf/arch/x86/tests/dwarf-unwind.c
+++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
@@ -23,7 +23,7 @@ static int sample_ustack(struct perf_sample *sample,
 
 	sp = (unsigned long) regs[PERF_REG_X86_SP];
 
-	map = map_groups__find(&thread->mg, MAP__FUNCTION, (u64) sp);
+	map = map_groups__find(&thread->mg, MAP__VARIABLE, (u64) sp);
 	if (!map) {
 		pr_debug("failed to get stack map\n");
 		free(buf);
-- 
1.8.3.1

