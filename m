Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaJWK7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:59:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:35967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaJWK7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:59:50 -0400
Message-Id: <20141023105658.293319363@infradead.org>
User-Agent: quilt/0.61-1
Date: Thu, 23 Oct 2014 12:51:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>
Subject: [PATCH 4/4] perf,x86: Introduce HSW cache numa events
References: <20141023105119.173457103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-hsw-offcore-node.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing how HSW-EP is now available and the SDM states the supplier and
snoop info is identical to SNB/IVB, provide the cache numa events.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-@git.kernel.org
---
 arch/x86/kernel/cpu/perf_event_intel.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -563,6 +563,20 @@ static __initconst const u64 hsw_hw_cach
 		[ C(RESULT_MISS)   ] = HSW_DMND_PREFETCH|SNB_L3_MISS,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = HSW_DMND_READ|SNB_DRAM_ANY,
+		[ C(RESULT_MISS)   ] = HSW_DMND_READ|SNB_DRAM_REMOTE,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = HSW_DMND_WRITE|SNB_DRAM_ANY,
+		[ C(RESULT_MISS)   ] = HSW_DMND_WRITE|SNB_DRAM_REMOTE,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = HSW_DMND_PREFETCH|SNB_DRAM_ANY,
+		[ C(RESULT_MISS)   ] = HSW_DMND_PREFETCH|SNB_DRAM_REMOTE,
+	},
+ },
 };
 
 static __initconst const u64 westmere_hw_cache_event_ids


