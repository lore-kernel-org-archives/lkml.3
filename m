Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbaEMKoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:44:05 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60739 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759883AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nishanth Menon <nm@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 012/182] ARM: OMAP4: Fix definition of IS_PM44XX_ERRATUM
Date: Tue, 13 May 2014 11:26:04 +0200
Message-Id: <18f72bc83cb1776f5fc482873ce027c56a814d97.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-omap2/pm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
index 7bdd22afce69..d4d0fce325c7 100644
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
1.9.3

