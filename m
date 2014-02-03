Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaBCM4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:56:41 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:37833 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaBCM4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:56:38 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH v1 10/10] perf/x86/uncore: use MiB unit for events for SNB/IVB/HSW IMC
Date: Mon,  3 Feb 2014 13:55:42 +0100
Message-Id: <1391432142-18723-11-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391432142-18723-1-git-send-email-eranian@google.com>
References: <1391432142-18723-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes perf use Mebibytes to display the counts
of uncore_imc/data_reads/ and uncore_imc/data_writes.

1MiB = 1024*1024 bytes.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index f76937e..51dced8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1681,12 +1681,12 @@ enum {
 
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
-- 
1.7.9.5

