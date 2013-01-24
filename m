Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab3AXUbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:31:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34754 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3AXUbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:31:12 -0500
Date: Thu, 24 Jan 2013 12:30:51 -0800
From: tip-bot for Youquan Song <youquan.song@intel.com>
Message-ID: <tip-923d8697e24847000490c187de1aeaca622611a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, youquan.song@intel.com,
        ak@linux.intel.com, tglx@linutronix.de, youquan.song@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, ak@linux.intel.com,
        tglx@linutronix.de, youquan.song@intel.com,
        youquan.song@linux.intel.com
In-Reply-To: <1355851223-27705-1-git-send-email-youquan.song@intel.com>
References: <1355851223-27705-1-git-send-email-youquan.song@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86/perf: Add IvyBridge EP support
Git-Commit-ID: 923d8697e24847000490c187de1aeaca622611a3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:30:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  923d8697e24847000490c187de1aeaca622611a3
Gitweb:     http://git.kernel.org/tip/923d8697e24847000490c187de1aeaca622611a3
Author:     Youquan Song <youquan.song@intel.com>
AuthorDate: Tue, 18 Dec 2012 12:20:23 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 16:14:04 +0100

x86/perf: Add IvyBridge EP support

Running the perf utility on a Ivybridge EP server we encounter
"not supported" events:

   <not supported> L1-dcache-loads
   <not supported> L1-dcache-load-misses
   <not supported> L1-dcache-stores
   <not supported> L1-dcache-store-misses
   <not supported> L1-dcache-prefetches
   <not supported> L1-dcache-prefetch-misses

This patch adds support for this processor.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Youquan Song <youquan.song@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1355851223-27705-1-git-send-email-youquan.song@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index cb313a5..4914e94 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2087,6 +2087,7 @@ __init int intel_pmu_init(void)
 		pr_cont("SandyBridge events, ");
 		break;
 	case 58: /* IvyBridge */
+	case 62: /* IvyBridge EP */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
