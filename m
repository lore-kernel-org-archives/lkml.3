Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab3LDOPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:15:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:12100 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab3LDOPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:15:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,824,1378882800"; 
   d="scan'208";a="444500820"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf tools: Fix random fd closing with no libelf
Date: Wed,  4 Dec 2013 16:23:01 +0200
Message-Id: <1386166981-30197-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When built without libelf, perf tools was failing
to initialize a file descriptor, but nevertheless
closing it.  That sometimes resulted in the output
being truncated because the stdout file descriptor
got closed.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/symbol-minimal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 2d2dd05..ac7070a 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -253,6 +253,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso __maybe_unused,
 	if (!ss->name)
 		goto out_close;
 
+	ss->fd = fd;
 	ss->type = type;
 
 	return 0;
-- 
1.7.11.7

