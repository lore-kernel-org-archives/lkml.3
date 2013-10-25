Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3JYKcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:32:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52421 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3JYKcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:32:52 -0400
Date: Fri, 25 Oct 2013 03:32:32 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-89c97d936e76b064a52ee056602b2a62b3f1ef70@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382427258-17495-6-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-6-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf inject:
  Do not repipe attributes to a perf.data file
Git-Commit-ID: 89c97d936e76b064a52ee056602b2a62b3f1ef70
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 03:32:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89c97d936e76b064a52ee056602b2a62b3f1ef70
Gitweb:     http://git.kernel.org/tip/89c97d936e76b064a52ee056602b2a62b3f1ef70
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Oct 2013 10:34:09 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Oct 2013 10:58:03 -0300

perf inject: Do not repipe attributes to a perf.data file

perf.data files contain the attributes separately, do not put them in
the event stream as well.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382427258-17495-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index eb1a594..409ceaf 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -72,12 +72,17 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
 				   union perf_event *event,
 				   struct perf_evlist **pevlist)
 {
+	struct perf_inject *inject = container_of(tool, struct perf_inject,
+						  tool);
 	int ret;
 
 	ret = perf_event__process_attr(tool, event, pevlist);
 	if (ret)
 		return ret;
 
+	if (!inject->pipe_output)
+		return 0;
+
 	return perf_event__repipe_synth(tool, event);
 }
 
