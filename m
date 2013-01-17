Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab3AQUl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:41:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:33901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab3AQUhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:37:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,486,1355126400"; 
   d="scan'208";a="273439805"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/29] perf, x86: Disable LBR recording for unknown LBR_FMT
Date: Thu, 17 Jan 2013 12:36:31 -0800
Message-Id: <1358455012-12287-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
References: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When the LBR format is unknown disable LBR recording. This prevents
crashes when the LBR address is misdecoded and mis-sign extended.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 2af6695b..ad5af13 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -13,6 +13,7 @@ enum {
 	LBR_FORMAT_EIP		= 0x02,
 	LBR_FORMAT_EIP_FLAGS	= 0x03,
 	LBR_FORMAT_EIP_FLAGS2	= 0x04,
+	LBR_FORMAT_MAX_KNOWN	= LBR_FORMAT_EIP_FLAGS2,
 };
 
 /*
@@ -392,7 +393,7 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	/*
 	 * no LBR on this PMU
 	 */
-	if (!x86_pmu.lbr_nr)
+	if (!x86_pmu.lbr_nr || x86_pmu.intel_cap.lbr_format > LBR_FORMAT_MAX_KNOWN)
 		return -EOPNOTSUPP;
 
 	/*
-- 
1.7.7.6

