Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaEZRDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:03:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:39338 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbaEZQ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122315"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 03/15] x86/alternative: Add alternative_input_2
Date: Mon, 26 May 2014 10:01:10 -0700
Message-Id: <1401123682-5384-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Add alternative_input_2 to take two features and respective instructions.

If CPU has feature2, newinstr2 is used.

Otherwise, if CPU has feature1, newinstr1 is used.

Otherwise, oldinstr is used.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/alternative.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 0a3f9c9..eb8d80b 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -161,6 +161,19 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
 		: : "i" (0), ## input)
 
+/*
+ * Like alternative_input, but there are two features and respective
+ * instructions.
+ * If CPU has feature2, newinstr2 is used.
+ * Otherwise, if CPU has feature1, newinstr1 is used.
+ * Otherwise, oldinstr is used.
+ */
+#define alternative_input_2(oldinstr, newinstr1, feature1, newinstr2,	     \
+			   feature2, input...)				     \
+	asm volatile(ALTERNATIVE_2(oldinstr, newinstr1, feature1,	     \
+		newinstr2, feature2)					     \
+		: : "i" (0), ## input)
+
 /* Like alternative_input, but with a single output argument */
 #define alternative_io(oldinstr, newinstr, feature, output, input...)	\
 	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
-- 
1.8.1.2

