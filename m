Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbaEGNXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:23:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45573 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235AbaEGNOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 46/70] ARM: OMAP4: Fix definition of IS_PM44XX_ERRATUM
Date: Wed,  7 May 2014 14:12:49 +0100
Message-Id: <1399468393-10140-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit 07484ca33ef83900f5cfbde075c1a19e5a237aa1 upstream.

Just like IS_PM34XX_ERRATUM, IS_PM44XX_ERRATUM is valid only if
CONFIG_PM is enabled, else, disabling CONFIG_PM results in build
failure complaining about the following:
arch/arm/mach-omap2/built-in.o: In function `omap4_boot_secondary':
:(.text+0x8a70): undefined reference to `pm44xx_errata'

Fixes: c962184 (ARM: OMAP4: PM: add errata support)
Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.ocm>
Acked-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/pm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
index 7bdd22a..d4d0fce 100644
--- a/arch/arm/mach-omap2/pm.h
+++ b/arch/arm/mach-omap2/pm.h
@@ -103,7 +103,7 @@ static inline void enable_omap3630_toggle_l2_on_restore(void) { }
 
 #define PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD	(1 << 0)
 
-#if defined(CONFIG_ARCH_OMAP4)
+#if defined(CONFIG_PM) && defined(CONFIG_ARCH_OMAP4)
 extern u16 pm44xx_errata;
 #define IS_PM44XX_ERRATUM(id)		(pm44xx_errata & (id))
 #else
-- 
1.9.1

