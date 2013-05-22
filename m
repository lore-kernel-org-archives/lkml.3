Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3EVGXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:23:19 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:47477 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3EVGXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:23:14 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, peterz@infradead.org,
        eranian@google.com, ak@linux.intel.com, mingo@kernel.org
Subject: [PATCH 1/5] perf: New conditional branch filter criteria in branch stack sampling
Date: Wed, 22 May 2013 11:52:37 +0530
Message-Id: <1369203761-12649-2-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369203761-12649-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1369203761-12649-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052206-8256-0000-0000-0000079951D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POWER8 PMU based BHRB supports filtering for conditional branches.
This patch introduces new branch filter PERF_SAMPLE_BRANCH_COND which
will extend the existing perf ABI. Other architectures can provide
this functionality with either HW filtering support (if present) or
with SW filtering of instructions.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 include/uapi/linux/perf_event.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index fb104e5..cb0de86 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -157,8 +157,9 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << 4, /* any call branch */
 	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << 5, /* any return branch */
 	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << 6, /* indirect calls */
+	PERF_SAMPLE_BRANCH_COND		= 1U << 7, /* conditional branches */
 
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 7, /* non-ABI */
+	PERF_SAMPLE_BRANCH_MAX		= 1U << 8, /* non-ABI */
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
-- 
1.7.11.7

