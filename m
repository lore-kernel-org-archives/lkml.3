Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaEZRBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:01:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:39338 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbaEZQ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122323"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 05/15] x86/xsaves: Define macros for xsave instructions
Date: Mon, 26 May 2014 10:01:12 -0700
Message-Id: <1401123682-5384-6-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Define macros for xsave, xsaveopt, xsaves, xrstor, xrstors inline
instructions. The instructions will be used for saving and rstoring xstate.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/xsave.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index d949ef2..71bdde4 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -52,6 +52,12 @@ extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
 
+#define XSAVE		".byte " REX_PREFIX "0x0f,0xae,0x27"
+#define XSAVEOPT	".byte " REX_PREFIX "0x0f,0xae,0x37"
+#define XSAVES		".byte " REX_PREFIX "0x0f,0xc7,0x2f"
+#define XRSTOR		".byte " REX_PREFIX "0x0f,0xae,0x2f"
+#define XRSTORS		".byte " REX_PREFIX "0x0f,0xc7,0x1f"
+
 static inline int fpu_xrstor_checking(struct xsave_struct *fx)
 {
 	int err;
-- 
1.8.1.2

