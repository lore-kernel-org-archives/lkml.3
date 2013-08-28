Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3H1SdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:33:22 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:43431 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3H1SdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:33:19 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH] ARC: Add read*_relaxed to asm/io.h
Date: Wed, 28 Aug 2013 20:32:50 +0200
Message-Id: <1377714770-2251-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers require these, and ARC didn't had them yet.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 arch/arc/include/asm/io.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arc/include/asm/io.h b/arch/arc/include/asm/io.h
index 473424d..334ce70 100644
--- a/arch/arc/include/asm/io.h
+++ b/arch/arc/include/asm/io.h
@@ -100,6 +100,10 @@ static inline void __raw_writel(u32 w, volatile void __iomem *addr)
 
 }
 
+#define readb_relaxed readb
+#define readw_relaxed readw
+#define readl_relaxed readl
+
 #include <asm-generic/io.h>
 
 #endif /* _ASM_ARC_IO_H */
-- 
1.7.9.5

