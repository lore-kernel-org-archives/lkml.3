Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaEWA0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 20:26:37 -0400
Received: from gnurou.org ([207.192.72.5]:57595 "EHLO mail.gnurou.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751430AbaEWA0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 20:26:35 -0400
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH RESEND] ARM: trusted_foundations: fix compile error on non-SMP
Date: Fri, 23 May 2014 09:23:32 +0900
Message-Id: <1400804612-11876-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The setup_max_cpus variable is only defined if CONFIG_SMP is set. Add
a preprocessor condition to avoid the following compilation error if
CONFIG_SMP is not set:

    arch/arm/include/asm/trusted_foundations.h: In function 'register_trusted_foundations':
    arch/arm/include/asm/trusted_foundations.h:57:2: error: 'setup_max_cpus' undeclared (first use in this function)

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
Hi Stephen,

This patch has been originally submitted through Russell's patch tracker,
where it has stayed untouched for ~3 weeks now. Considering that this
fixes a compilation error and should thus be made available quickly, and
that Tegra is the only user of Trusted Foundations, would you agree to take
it into your tree?

 arch/arm/include/asm/trusted_foundations.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h
index b5f7705..624e1d4 100644
--- a/arch/arm/include/asm/trusted_foundations.h
+++ b/arch/arm/include/asm/trusted_foundations.h
@@ -54,7 +54,9 @@ static inline void register_trusted_foundations(
 	 */
 	pr_err("No support for Trusted Foundations, continuing in degraded mode.\n");
 	pr_err("Secondary processors as well as CPU PM will be disabled.\n");
+#if IS_ENABLED(CONFIG_SMP)
 	setup_max_cpus = 0;
+#endif
 	cpu_idle_poll_ctrl(true);
 }
 
-- 
1.9.2

