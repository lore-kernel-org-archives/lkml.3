Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaJOKDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:03:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54241 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaJOKDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:03:15 -0400
Date: Wed, 15 Oct 2014 03:02:28 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-zzmoo39yalrl9hzu9nc2xqml@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        namhyung@kernel.org, dsahern@gmail.com, peterz@infradead.org,
        dzickus@redhat.com, fweisbec@gmail.com, bp@suse.de, efault@gmx.de,
        jean.pihet@linaro.org, tglx@linutronix.de, mingo@kernel.org,
        jolsa@redhat.com, paulus@samba.org, adrian.hunter@intel.com,
        hpa@zytor.com
Reply-To: namhyung@kernel.org, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, bp@suse.de,
        fweisbec@gmail.com, peterz@infradead.org, dsahern@gmail.com,
        dzickus@redhat.com, mingo@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de, jean.pihet@linaro.org, efault@gmx.de,
        hpa@zytor.com, adrian.hunter@intel.com, paulus@samba.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf script: Stop updating hists stats,
  not used
Git-Commit-ID: 49c23f2d541ebf7ae5e9fff03301f4e7145cc979
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

Commit-ID:  49c23f2d541ebf7ae5e9fff03301f4e7145cc979
Gitweb:     http://git.kernel.org/tip/49c23f2d541ebf7ae5e9fff03301f4e7145cc979
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 9 Oct 2014 11:45:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Oct 2014 11:46:41 -0300

perf script: Stop updating hists stats, not used

Not used here, remove to reduce perf_evsel/hists structs interaction.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zzmoo39yalrl9hzu9nc2xqml@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b9b9e58..6b4925f 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -572,7 +572,6 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 
 	scripting_ops->process_event(event, sample, evsel, thread, &al);
 
-	evsel->hists.stats.total_period += sample->period;
 	return 0;
 }
 
