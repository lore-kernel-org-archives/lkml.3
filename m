Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbaE3PLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:11:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44100 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaE3PLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:11:20 -0400
Date: Fri, 30 May 2014 08:11:07 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-5b3e83f46a2a7e8625258dbf84a26e7f4032bfa8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-5-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-5-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/alternative:
  Add alternative_input_2 to support alternative with two features and input
Git-Commit-ID: 5b3e83f46a2a7e8625258dbf84a26e7f4032bfa8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b3e83f46a2a7e8625258dbf84a26e7f4032bfa8
Gitweb:     http://git.kernel.org/tip/5b3e83f46a2a7e8625258dbf84a26e7f4032bfa8
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:32 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:24:53 -0700

x86/alternative: Add alternative_input_2 to support alternative with two features and input

alternative_input_2() replaces old instruction with new instructions with
input based on two features.

In alternative_input_2(oldinstr, newinstr1, feature1, newinstr2, feature2,
		input...),

feature2 has higher priority to replace oldinstr than feature1.

If CPU has feature2, newinstr2 replaces oldinstr and newinstr2 is
executed during run time.

If CPU doesn't have feature2, but it has feature1, newinstr1 replaces oldinstr
and newinstr1 is executed during run time.

If CPU doesn't have feature2 and feature1, oldinstr is executed during run
time.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-5-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/alternative.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 0a3f9c9..473bdbe 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -161,6 +161,20 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
 		: : "i" (0), ## input)
 
+/*
+ * This is similar to alternative_input. But it has two features and
+ * respective instructions.
+ *
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
