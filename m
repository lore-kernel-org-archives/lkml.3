Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaBVR5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:57:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaBVR5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:57:13 -0500
Date: Sat, 22 Feb 2014 09:56:28 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-bc5290869d0a7f7abbde76ac95a7f7b6f5d7bb7b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1391427883-13443-1-git-send-email-jolsa@redhat.com>
References: <1391427883-13443-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Put proper period for for samples without PERIOD sample_type
Git-Commit-ID: bc5290869d0a7f7abbde76ac95a7f7b6f5d7bb7b
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

Commit-ID:  bc5290869d0a7f7abbde76ac95a7f7b6f5d7bb7b
Gitweb:     http://git.kernel.org/tip/bc5290869d0a7f7abbde76ac95a7f7b6f5d7bb7b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 3 Feb 2014 12:44:41 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:46 -0300

perf tools: Put proper period for for samples without PERIOD sample_type

We use PERF_SAMPLE_PERIOD sample type only for frequency
setup -F (default) option. The -c does not need store period,
because it's always the same.

In -c case the report code uses '1' as  period. Fixing
it to perf_event_attr::sample_period.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1391427883-13443-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 55407c5..c6f8ce9 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1220,7 +1220,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	memset(data, 0, sizeof(*data));
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
-	data->period = 1;
+	data->period = evsel->attr.sample_period;
 	data->weight = 0;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
