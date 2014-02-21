Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaBUVOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:14:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59022 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbaBUVOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:14:30 -0500
Date: Fri, 21 Feb 2014 13:13:57 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-e9d9768824a18212712ae3afbebd5bfef05176f4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1392132015-14521-9-git-send-email-eranian@google.com>
References: <1392132015-14521-9-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore: use MiB unit for events for SNB/
 IVB/HSW IMC
Git-Commit-ID: e9d9768824a18212712ae3afbebd5bfef05176f4
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

Commit-ID:  e9d9768824a18212712ae3afbebd5bfef05176f4
Gitweb:     http://git.kernel.org/tip/e9d9768824a18212712ae3afbebd5bfef05176f4
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 11 Feb 2014 16:20:14 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:49:08 +0100

perf/x86/uncore: use MiB unit for events for SNB/IVB/HSW IMC

This patch makes perf use Mebibytes to display the counts
of uncore_imc/data_reads/ and uncore_imc/data_writes.

1MiB = 1024*1024 bytes.

Cc: mingo@elte.hu
Cc: acme@redhat.com
Cc: ak@linux.intel.com
Cc: zheng.z.yan@intel.com
Cc: peterz@infradead.org
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392132015-14521-9-git-send-email-eranian@google.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 7760aee..de5c568 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1679,12 +1679,12 @@ enum {
 
 static struct uncore_event_desc snb_uncore_imc_events[] = {
 	INTEL_UNCORE_EVENT_DESC(data_reads,  "event=0x01"),
-	INTEL_UNCORE_EVENT_DESC(data_reads.scale, "64"),
-	INTEL_UNCORE_EVENT_DESC(data_reads.unit, "bytes"),
+	INTEL_UNCORE_EVENT_DESC(data_reads.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(data_reads.unit, "MiB"),
 
 	INTEL_UNCORE_EVENT_DESC(data_writes, "event=0x02"),
-	INTEL_UNCORE_EVENT_DESC(data_writes.scale, "64"),
-	INTEL_UNCORE_EVENT_DESC(data_writes.unit, "bytes"),
+	INTEL_UNCORE_EVENT_DESC(data_writes.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(data_writes.unit, "MiB"),
 
 	{ /* end: all zeroes */ },
 };
