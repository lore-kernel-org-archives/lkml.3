Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaIDQEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:04:06 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64901 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaIDQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:04:02 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v1 3/6] arm64: Introduce dummy version of asm/fiq.h
Date: Thu,  4 Sep 2014 17:03:37 +0100
Message-Id: <1409846620-14542-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409846620-14542-1-git-send-email-daniel.thompson@linaro.org>
References: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
 <1409846620-14542-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers that are shared between arm and arm64 and which employ
FIQ on arm cannot include asm/fiq.h without #ifdef'ing. This patch
introduces a dummy version of asm/fiq.h to arm64 to avoid this.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/fiq.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 arch/arm64/include/asm/fiq.h

diff --git a/arch/arm64/include/asm/fiq.h b/arch/arm64/include/asm/fiq.h
new file mode 100644
index 0000000..909ec54
--- /dev/null
+++ b/arch/arm64/include/asm/fiq.h
@@ -0,0 +1,18 @@
+/*
+ * arch/arm64/include/asm/fiq.h
+ *
+ * Placeholder to reduce #ifdef'ing in shared arm/arm64 drivers.
+ */
+
+#ifndef __ASM_FIQ_H
+#define __ASM_FIQ_H
+
+/*
+ * This placeholder allows code of the following form to be simplified:
+ *
+ * #ifdef CONFIG_FIQ
+ * #include <asm/fiq.h>
+ * #endif
+ */
+
+#endif
-- 
1.9.3

