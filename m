Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3F0HvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:51:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:6235 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab3F0HuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:50:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="361296486"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V2 15/15] perf tools: fix ppid in thread__fork()
Date: Thu, 27 Jun 2013 10:55:07 +0300
Message-Id: <1372319707-13892-16-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ppid should be assigned to the parents pid.  Note
'thread__fork()'s only caller 'machine__process_fork_event()'
ensures that the parents pid is set.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/thread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index e3d4a55..93f3eab 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -85,7 +85,7 @@ int thread__fork(struct thread *self, struct thread *parent)
 		if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
 			return -ENOMEM;
 
-	self->ppid = parent->tid;
+	self->ppid = parent->pid_;
 
 	return 0;
 }
-- 
1.7.11.7

