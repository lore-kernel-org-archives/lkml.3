Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaHNIwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:52:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbaHNIwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:52:51 -0400
Date: Thu, 14 Aug 2014 01:51:59 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-bf4939027decde7aaaf8b5dbeee70126d2822eb6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406786474-9306-22-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-22-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add flags and insn_len to struct sample
Git-Commit-ID: bf4939027decde7aaaf8b5dbeee70126d2822eb6
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

Commit-ID:  bf4939027decde7aaaf8b5dbeee70126d2822eb6
Gitweb:     http://git.kernel.org/tip/bf4939027decde7aaaf8b5dbeee70126d2822eb6
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 31 Jul 2014 09:01:04 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 19:23:32 -0300

perf tools: Add flags and insn_len to struct sample

The flags will be used to export branch type and transaction status.

insn_len is preparation for pairing calls and returns because the return
address equals the call address plus the instruction length (insn_len).

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-22-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 94d6976..7eb7107 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -156,6 +156,8 @@ struct perf_sample {
 	u32 cpu;
 	u32 raw_size;
 	u64 data_src;
+	u32 flags;
+	u16 insn_len;
 	void *raw_data;
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
