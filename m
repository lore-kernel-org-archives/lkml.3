Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaHGH2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 03:28:09 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36659 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbaHGH2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 03:28:07 -0400
Date: Thu, 7 Aug 2014 00:27:00 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH] powerpc/perf: Explicitly include util/debug.h
Message-ID: <20140807072700.GA17623@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080707-7182-0000-0000-000000257933
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] powerpc/perf: Explicitly include util/debug.h

Looks like util/debug.h was indirectly included before and
is no longer included now. pr_debug is left undefined and
the build of perf tool fails on Powerpc.

Explicitly include util/debug.h.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/arch/powerpc/util/skip-callchain-idx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
index a7c23a4..d73ef8b 100644
--- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -15,6 +15,7 @@
 
 #include "util/thread.h"
 #include "util/callchain.h"
+#include "util/debug.h"
 
 /*
  * When saving the callchain on Power, the kernel conservatively saves
-- 
1.8.3.1

