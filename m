Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbaHVQ3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:29:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:33613 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293AbaHVQ3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:29:46 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <michaele@au1.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/16] perf tools powerpc: Explicitly include util/debug.h
Date: Fri, 22 Aug 2014 13:29:14 -0300
Message-Id: <1408724968-3441-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408724968-3441-1-git-send-email-acme@kernel.org>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Looks like util/debug.h was indirectly included before and is no longer
included now. pr_debug is left undefined and the build of perf tool
fails on Powerpc.

Explicitly include util/debug.h.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Link: http://lkml.kernel.org/r/20140807072700.GA17623@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/powerpc/util/skip-callchain-idx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
index a7c23a4b3778..d73ef8bb08c7 100644
--- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -15,6 +15,7 @@
 
 #include "util/thread.h"
 #include "util/callchain.h"
+#include "util/debug.h"
 
 /*
  * When saving the callchain on Power, the kernel conservatively saves
-- 
1.9.3

