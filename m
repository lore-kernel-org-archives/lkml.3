Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965926AbaGPTSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:18:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965906AbaGPTR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:17:56 -0400
Date: Wed, 16 Jul 2014 12:17:16 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-0j2wuuegnhv3gljbil8ld6kx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Suggest using -f to override perf.data file ownership message
Git-Commit-ID: 071266bf5b6a4f41250d2b26b000f1d2f9620afe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  071266bf5b6a4f41250d2b26b000f1d2f9620afe
Gitweb:     http://git.kernel.org/tip/071266bf5b6a4f41250d2b26b000f1d2f9620afe
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 8 Jul 2014 12:40:11 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 8 Jul 2014 12:40:11 -0300

perf tools: Suggest using -f to override perf.data file ownership message

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
index 55de44e..ee370a7f 100644
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
