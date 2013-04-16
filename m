Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935997Ab3DPPzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:55:12 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34440 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935896Ab3DPPzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:55:10 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH V2 3/5] powerpc, perf: Add new BHRB related generic functions, data and flags
Date: Tue, 16 Apr 2013 21:24:08 +0530
Message-Id: <1366127650-1952-4-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366127650-1952-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1366127650-1952-1-git-send-email-khandual@linux.vnet.ibm.com>
x-cbid: 13041615-5140-0000-0000-0000030AA962
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some new BHRB related generic functions, data and flags

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 57b42da..3f0c15c 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -33,6 +33,8 @@ struct power_pmu {
 				unsigned long *valp);
 	int		(*get_alternatives)(u64 event_id, unsigned int flags,
 				u64 alt[]);
+	u64             (*bhrb_filter_map)(u64 branch_sample_type);
+	void            (*config_bhrb)(u64 pmu_bhrb_filter);
 	void		(*disable_pmc)(unsigned int pmc, unsigned long mmcr[]);
 	int		(*limited_pmc_event)(u64 event_id);
 	u32		flags;
@@ -42,6 +44,9 @@ struct power_pmu {
 	int		(*cache_events)[PERF_COUNT_HW_CACHE_MAX]
 			       [PERF_COUNT_HW_CACHE_OP_MAX]
 			       [PERF_COUNT_HW_CACHE_RESULT_MAX];
+
+	/* BHRB entries in the PMU */
+	int		bhrb_nr;
 };
 
 /*
@@ -54,6 +59,7 @@ struct power_pmu {
 #define PPMU_SIAR_VALID		0x00000010 /* Processor has SIAR Valid bit */
 #define PPMU_HAS_SSLOT		0x00000020 /* Has sampled slot in MMCRA */
 #define PPMU_HAS_SIER		0x00000040 /* Has SIER */
+#define PPMU_BHRB		0x00000080 /* has BHRB feature enabled */
 
 /*
  * Values for flags to get_alternatives()
-- 
1.7.11.7

