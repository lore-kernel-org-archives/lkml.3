Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3KDUWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:22:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50059 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab3KDUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:22:04 -0500
Date: Mon, 4 Nov 2013 12:21:29 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-42d88910c717ba21089251d0ca559abfef0df22d@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, namhyung@gmail.com, adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1383313899-15987-11-git-send-email-adrian.hunter@intel.com>
References: <1383313899-15987-11-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Synthesize PERF_SAMPLE_TRANSACTION
Git-Commit-ID: 42d88910c717ba21089251d0ca559abfef0df22d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:21:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42d88910c717ba21089251d0ca559abfef0df22d
Gitweb:     http://git.kernel.org/tip/42d88910c717ba21089251d0ca559abfef0df22d
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 1 Nov 2013 15:51:38 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:49:36 -0300

perf evsel: Synthesize PERF_SAMPLE_TRANSACTION

Add missing PERF_SAMPLE_TRANSACTION to perf_event__synthesize_sample()
and perf_event__sample_event_size().

This makes the "sample parsing" test pass.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383313899-15987-11-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b121717..5280820 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1578,6 +1578,9 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 	if (type & PERF_SAMPLE_DATA_SRC)
 		result += sizeof(u64);
 
+	if (type & PERF_SAMPLE_TRANSACTION)
+		result += sizeof(u64);
+
 	return result;
 }
 
@@ -1751,6 +1754,11 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_TRANSACTION) {
+		*array = sample->transaction;
+		array++;
+	}
+
 	return 0;
 }
 
