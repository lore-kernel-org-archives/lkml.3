Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3GEGwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:52:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58802 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3GEGwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:52:06 -0400
Date: Thu, 4 Jul 2013 23:51:31 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-100ac5331519866afa9b000b10642b00cb6d03dd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        suravee.suthikulpanit@amd.com, acme@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        suravee.suthikulpanit@amd.com, acme@infradead.org, tglx@linutronix.de
In-Reply-To: <20130703075542.GF23916@twins.programming.kicks-ass.net>
References: <20130703075542.GF23916@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/amd:
  Do not print an error when the device is not present
Git-Commit-ID: 100ac5331519866afa9b000b10642b00cb6d03dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 04 Jul 2013 23:51:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  100ac5331519866afa9b000b10642b00cb6d03dd
Gitweb:     http://git.kernel.org/tip/100ac5331519866afa9b000b10642b00cb6d03dd
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 3 Jul 2013 09:55:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 5 Jul 2013 08:27:15 +0200

perf/x86/amd: Do not print an error when the device is not present

As Linus said its not an error to not have an AMD IOMMU; esp.
when you're not even running on an AMD platform.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Link: http://lkml.kernel.org/r/20130703075542.GF23916@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_iommu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommu.c b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
index 0db655e..639d128 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_iommu.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
@@ -491,10 +491,8 @@ static struct perf_amd_iommu __perf_iommu = {
 static __init int amd_iommu_pc_init(void)
 {
 	/* Make sure the IOMMU PC resource is available */
-	if (!amd_iommu_pc_supported()) {
-		pr_err("perf: amd_iommu PMU not installed. No support!\n");
+	if (!amd_iommu_pc_supported())
 		return -ENODEV;
-	}
 
 	_init_perf_amd_iommu(&__perf_iommu, "amd_iommu");
 
