Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab3ICHVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:21:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3ICHVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:21:16 -0400
Date: Tue, 3 Sep 2013 00:15:16 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-fa0097ee690693006ab1aea6c01ad3c851b65c77@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, peterz@infradead.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1377975053-3811-2-git-send-email-adrian.hunter@intel.com>
References: <1377975053-3811-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add a dummy software event to keep tracking
Git-Commit-ID: fa0097ee690693006ab1aea6c01ad3c851b65c77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 03 Sep 2013 00:15:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa0097ee690693006ab1aea6c01ad3c851b65c77
Gitweb:     http://git.kernel.org/tip/fa0097ee690693006ab1aea6c01ad3c851b65c77
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Sat, 31 Aug 2013 21:50:51 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Sep 2013 14:58:19 -0300

perf: Add a dummy software event to keep tracking

When an event is disabled the "tracking" events selected by the 'mmap',
'comm' and 'task' bits of struct perf_event_attr, are also disabled.
However, the information those events provide is necessary to resolve
symbols for when the main event is re-enabled.

The "tracking" events can be kept enabled by putting them on another
event, but that requires an event that otherwise does nothing.  A new
software event PERF_COUNT_SW_DUMMY is added for that purpose.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377975053-3811-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/uapi/linux/perf_event.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 408b8c7..ca1d90b 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -109,6 +109,7 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
 	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
+	PERF_COUNT_SW_DUMMY			= 9,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
