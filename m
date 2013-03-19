Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379Ab3CSQwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:52:22 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:64855 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287Ab3CSQwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:52:17 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Jongpill Lee <boyko.lee@samsung.com>, Jaecheol Lee <jc.lee@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Jonathan Kliegman <kliegs@chromium.org>,
        Michael Spang <spang@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] arm: exynos: Clear ENABLE_WAKEUP_SW bit when entering suspend
Date: Tue, 19 Mar 2013 09:51:40 -0700
Message-Id: <1363711900-25560-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363711900-25560-1-git-send-email-dianders@chromium.org>
References: <1363711900-25560-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Kliegman <kliegs@chromium.org>

Setting this bit to 0 causes the system to wait until suspended
to use the wakeup masks.  With it being set high previously,
masked interrupts were being received and processed before the
EINT_WAKEUP_MASK was configured.

Signed-off-by: Jonathan Kliegman <kliegs@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/mach-exynos/include/mach/pm-core.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/mach-exynos/include/mach/pm-core.h b/arch/arm/mach-exynos/include/mach/pm-core.h
index 9d8da51e3..7dbbfec 100644
--- a/arch/arm/mach-exynos/include/mach/pm-core.h
+++ b/arch/arm/mach-exynos/include/mach/pm-core.h
@@ -27,13 +27,8 @@ static inline void s3c_pm_debug_init_uart(void)
 
 static inline void s3c_pm_arch_prepare_irqs(void)
 {
-	unsigned int tmp;
-	tmp = __raw_readl(S5P_WAKEUP_MASK);
-	tmp &= ~(1 << 31);
-	__raw_writel(tmp, S5P_WAKEUP_MASK);
-
-	__raw_writel(s3c_irqwake_intmask, S5P_WAKEUP_MASK);
 	__raw_writel(s3c_irqwake_eintmask, S5P_EINT_WAKEUP_MASK);
+	__raw_writel(s3c_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
 }
 
 static inline void s3c_pm_arch_stop_clocks(void)
-- 
1.8.1.3

