Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab3CSQwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:52:46 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56056 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933288Ab3CSQwR (ORCPT
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
Subject: [PATCH 1/2] arm: exynos: Remove hardcode wakeup unmask for EINT_0
Date: Tue, 19 Mar 2013 09:51:39 -0700
Message-Id: <1363711900-25560-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363711900-25560-1-git-send-email-dianders@chromium.org>
References: <1363711900-25560-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Kliegman <kliegs@chromium.org>

For legacy reasons EINT_0 was being forced on for all
exynos systems as a wake interrupt.  For boards that need
EINT_0 they should probably enable it with enable_irq_wake

Signed-off-by: Jonathan Kliegman <kliegs@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Thomas Abraham <thomas.ab@samsung.com>
---
 arch/arm/mach-exynos/include/mach/pm-core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/include/mach/pm-core.h b/arch/arm/mach-exynos/include/mach/pm-core.h
index a67ecfa..9d8da51e3 100644
--- a/arch/arm/mach-exynos/include/mach/pm-core.h
+++ b/arch/arm/mach-exynos/include/mach/pm-core.h
@@ -33,7 +33,7 @@ static inline void s3c_pm_arch_prepare_irqs(void)
 	__raw_writel(tmp, S5P_WAKEUP_MASK);
 
 	__raw_writel(s3c_irqwake_intmask, S5P_WAKEUP_MASK);
-	__raw_writel(s3c_irqwake_eintmask & 0xFFFFFFFE, S5P_EINT_WAKEUP_MASK);
+	__raw_writel(s3c_irqwake_eintmask, S5P_EINT_WAKEUP_MASK);
 }
 
 static inline void s3c_pm_arch_stop_clocks(void)
-- 
1.8.1.3

