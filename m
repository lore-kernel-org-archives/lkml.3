Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbaKTHjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:39:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43865 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaKTHjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:39:41 -0500
Date: Wed, 19 Nov 2014 23:39:30 -0800
From: tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-68ca9d65b88420c2c97948a0640bad13405129e7@git.kernel.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        ak@linux.intel.com, kan.liang@intel.com, jolsa@redhat.com,
        mingo@kernel.org, namhyung@kernel.org, acme@redhat.com
Reply-To: tglx@linutronix.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        kan.liang@intel.com, ak@linux.intel.com, jolsa@redhat.com,
        mingo@kernel.org, namhyung@kernel.org, acme@redhat.com
In-Reply-To: <1416328700-1836-2-git-send-email-kan.liang@intel.com>
References: <1416328700-1836-2-git-send-email-kan.liang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Add missing handler for PERF_RECORD_MMAP2 events
Git-Commit-ID: 68ca9d65b88420c2c97948a0640bad13405129e7
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

Commit-ID:  68ca9d65b88420c2c97948a0640bad13405129e7
Gitweb:     http://git.kernel.org/tip/68ca9d65b88420c2c97948a0640bad13405129e7
Author:     Kan Liang <kan.liang@intel.com>
AuthorDate: Tue, 18 Nov 2014 11:38:18 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:48 -0300

perf diff: Add missing handler for PERF_RECORD_MMAP2 events

Without mmap2, perf diff fails to find the symbol name. The default
symbol sort key doesn't work well.

Signed-off-by: Kan Liang <kan.liang@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1416328700-1836-2-git-send-email-kan.liang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 25114c9..1ce425d 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -357,6 +357,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 static struct perf_tool tool = {
 	.sample	= diff__process_sample_event,
 	.mmap	= perf_event__process_mmap,
+	.mmap2	= perf_event__process_mmap2,
 	.comm	= perf_event__process_comm,
 	.exit	= perf_event__process_exit,
 	.fork	= perf_event__process_fork,
