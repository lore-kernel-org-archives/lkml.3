Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3BAL63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:58:29 -0500
Received: from multi.imgtec.com ([194.200.65.239]:31909 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344Ab3BAL6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:58:21 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 3/6] perf: Enable building perf tools for Meta
Date: Fri, 1 Feb 2013 11:49:07 +0000
Message-ID: <1359719350-24560-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
References: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_01_11_58_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define rmb(), cpu_relax(), and CPUINFO_PROC for Meta so that the perf
tools can be built for Meta.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/perf.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2c340e7..768507e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -98,6 +98,12 @@ void get_term_dimensions(struct winsize *ws);
 #define CPUINFO_PROC	"cpu model"
 #endif
 
+#ifdef __metag__
+#define rmb()		asm volatile("" ::: "memory")
+#define cpu_relax()	asm volatile("" ::: "memory")
+#define CPUINFO_PROC	"CPU"
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
-- 
1.7.7.6


