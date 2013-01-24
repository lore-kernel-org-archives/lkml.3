Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3AXLP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:15:58 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:51423 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab3AXLM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:12:59 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH v3 54/71] perf, ARC: Enable building perf tools for ARC
Date: Thu, 24 Jan 2013 16:36:18 +0530
Message-ID: <1359025589-22277-35-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although with uClibc there's more we need to do

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/perf.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2c340e7..8a68ad3 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -98,6 +98,12 @@ void get_term_dimensions(struct winsize *ws);
 #define CPUINFO_PROC	"cpu model"
 #endif
 
+#ifdef __arc__
+#define rmb()		asm volatile("" ::: "memory")
+#define cpu_relax()	rmb()
+#define CPUINFO_PROC	"Processor"
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
-- 
1.7.4.1

