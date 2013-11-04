Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3KDUV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:21:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3KDUVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:21:25 -0500
Date: Mon, 4 Nov 2013 12:21:01 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-1e7ed5ec54e3998bda6ea625599a0644404cb421@git.kernel.org>
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
In-Reply-To: <1383313899-15987-8-git-send-email-adrian.hunter@intel.com>
References: <1383313899-15987-8-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Always use perf_evsel__set_sample_bit
 ()
Git-Commit-ID: 1e7ed5ec54e3998bda6ea625599a0644404cb421
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:21:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e7ed5ec54e3998bda6ea625599a0644404cb421
Gitweb:     http://git.kernel.org/tip/1e7ed5ec54e3998bda6ea625599a0644404cb421
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 1 Nov 2013 15:51:35 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:42:28 -0300

perf evsel: Always use perf_evsel__set_sample_bit()

Always use perf_evsel__set_sample_bit() rather than just setting the
bit.

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
Link: http://lkml.kernel.org/r/1383313899-15987-8-git-send-email-adrian.hunter@intel.com
[ Cope with 3090ffb "perf: Disable PERF_RECORD_MMAP2 support" ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f0e65de..47bbf03 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -663,7 +663,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	}
 
 	if (opts->sample_address)
-		attr->sample_type	|= PERF_SAMPLE_DATA_SRC;
+		perf_evsel__set_sample_bit(evsel, DATA_SRC);
 
 	if (opts->no_delay) {
 		attr->watermark = 0;
@@ -675,13 +675,13 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	}
 
 	if (opts->sample_weight)
-		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
+		perf_evsel__set_sample_bit(evsel, WEIGHT);
 
 	attr->mmap  = track;
 	attr->comm  = track;
 
 	if (opts->sample_transaction)
-		attr->sample_type	|= PERF_SAMPLE_TRANSACTION;
+		perf_evsel__set_sample_bit(evsel, TRANSACTION);
 
 	/*
 	 * XXX see the function comment above
