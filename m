Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaKKSpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:45:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:15367 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaKKSn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:43:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414941158"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Subject: [PATCH 2/6] x86/alternative: Add alternative_io_2
Date: Tue, 11 Nov 2014 11:43:12 -0700
Message-Id: <1415731396-19364-3-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add alternative_io_2 in the spirit of alternative_input_2 and
alternative_io.  This will allow us to have instructions with an output
parameter that vary based on two CPU features.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: x86@kernel.org
---
 arch/x86/include/asm/alternative.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 473bdbe..7d9ead9 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -180,6 +180,20 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
 		: output : "i" (0), ## input)
 
+/*
+ * This is similar to alternative_io. But it has two features and
+ * respective instructions.
+ *
+ * If CPU has feature2, newinstr2 is used.
+ * Otherwise, if CPU has feature1, newinstr1 is used.
+ * Otherwise, oldinstr is used.
+ */
+#define alternative_io_2(oldinstr, newinstr1, feature1, newinstr2,	     \
+			   feature2, output, input...)			     \
+	asm volatile(ALTERNATIVE_2(oldinstr, newinstr1, feature1,	     \
+		newinstr2, feature2)					     \
+		: output : "i" (0), ## input)
+
 /* Like alternative_io, but for replacing a direct call with another one. */
 #define alternative_call(oldfunc, newfunc, feature, output, input...)	\
 	asm volatile (ALTERNATIVE("call %P[old]", "call %P[new]", feature) \
-- 
1.9.3

