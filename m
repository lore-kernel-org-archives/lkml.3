Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3EaDPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:15:13 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:43817 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab3EaDPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:15:10 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] ARM: scu: empty scu_enable for !CONFIG_HAVE_ARM_SCU
Date: Fri, 31 May 2013 11:13:37 +0800
Message-ID: <1369970017-4588-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the right config to empty scu_enable.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 arch/arm/include/asm/smp_scu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/smp_scu.h b/arch/arm/include/asm/smp_scu.h
index 18d1693..ac93189 100644
--- a/arch/arm/include/asm/smp_scu.h
+++ b/arch/arm/include/asm/smp_scu.h
@@ -26,7 +26,7 @@ static inline unsigned long scu_a9_get_base(void)
 unsigned int scu_get_core_count(void __iomem *);
 int scu_power_mode(void __iomem *, unsigned int);
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_HAVE_ARM_SCU
 void scu_enable(void __iomem *scu_base);
 #else
 static inline void scu_enable(void __iomem *scu_base) {}
-- 
1.7.4.1

