Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbaHHAQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 20:16:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:16729 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbaHHAPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 20:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,821,1400050800"; 
   d="scan'208";a="466291108"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: eranian@google.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] perf: Fix the default data source
Date: Thu,  7 Aug 2014 17:15:41 -0700
Message-Id: <1407456941-16232-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407456941-16232-1-git-send-email-andi@firstfloor.org>
References: <1407456941-16232-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

- the default of 0 for the data source in perf_sample_data_init() was
  wrong. 0 is not a valid value. So defined PERF_MEM_NA (not available)

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/perf_event.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a..8b206aa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -604,6 +604,13 @@ struct perf_sample_data {
 	u64				txn;
 };
 
+/* default value for data source */
+#define PERF_MEM_NA (PERF_MEM_S(OP, NA)   |\
+		    PERF_MEM_S(LVL, NA)   |\
+		    PERF_MEM_S(SNOOP, NA) |\
+		    PERF_MEM_S(LOCK, NA)  |\
+		    PERF_MEM_S(TLB, NA))
+
 static inline void perf_sample_data_init(struct perf_sample_data *data,
 					 u64 addr, u64 period)
 {
@@ -616,7 +623,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->regs_user.regs = NULL;
 	data->stack_user_size = 0;
 	data->weight = 0;
-	data->data_src.val = 0;
+	data->data_src.val = PERF_MEM_NA;
 	data->txn = 0;
 }
 
-- 
1.9.3

