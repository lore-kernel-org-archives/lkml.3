Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbaGHTEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:04:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:58299 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217AbaGHTEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:04:20 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/16] perf tools: Suggest using -f to override perf.data file ownership message
Date: Tue,  8 Jul 2014 16:03:02 -0300
Message-Id: <1404846184-20075-15-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404846184-20075-1-git-send-email-acme@kernel.org>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

  # id
  uid=0(root) gid=0(root) groups=0(root)
  # ls -la perf.data
  -rw-------. 1 acme acme 20720 Jul  8 11:35 perf.data

Previously:

  # perf report
  file perf.data not owned by current user or root

Now:

  # perf report
  File perf.data not owned by current user or root (use -f to override)

Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0j2wuuegnhv3gljbil8ld6kx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 55de44ecebef..ee370a7f2444 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -65,7 +65,7 @@ static int open_file_read(struct perf_data_file *file)
 		goto out_close;
 
 	if (!file->force && st.st_uid && (st.st_uid != geteuid())) {
-		pr_err("file %s not owned by current user or root\n",
+		pr_err("File %s not owned by current user or root (use -f to override)\n",
 		       file->path);
 		goto out_close;
 	}
-- 
1.9.3

