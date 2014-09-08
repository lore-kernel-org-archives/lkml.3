Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaIHP3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:29:44 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47961 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaIHP3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:29:03 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v3 4/5] arm64: Introduce dummy version of asm/fiq.h
Date: Mon,  8 Sep 2014 16:28:34 +0100
Message-Id: <1410190115-32604-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410190115-32604-1-git-send-email-daniel.thompson@linaro.org>
References: <1409931198-22600-1-git-send-email-daniel.thompson@linaro.org>
 <1410190115-32604-1-git-send-email-daniel.thompson@linaro.org>
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
 arch/arm64/include/asm/fiq.h | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 arch/arm64/include/asm/fiq.h

diff --git a/arch/arm64/include/asm/fiq.h b/arch/arm64/include/asm/fiq.h
new file mode 100644
index 0000000..d3776b8
--- /dev/null
+++ b/arch/arm64/include/asm/fiq.h
@@ -0,0 +1,8 @@
+/*
+ * Placeholder to reduce #ifdef'ing in shared arm/arm64 drivers. It
+ * allows code of the following form to be made unconditional.
+ *
+ * #ifdef CONFIG_FIQ
+ * #include <asm/fiq.h>
+ * #endif
+ */
-- 
1.9.3

