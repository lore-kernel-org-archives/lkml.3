Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbaEDQRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:17:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbaEDPmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.ocm>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 3.10 07/86] ARM: OMAP4: Fix definition of IS_PM44XX_ERRATUM
Date: Sun,  4 May 2014 11:40:42 -0400
Message-Id: <20140504154141.419052009@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/pm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/pm.h
+++ b/arch/arm/mach-omap2/pm.h
@@ -103,7 +103,7 @@ static inline void enable_omap3630_toggl
 
 #define PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD	(1 << 0)
 
-#if defined(CONFIG_ARCH_OMAP4)
+#if defined(CONFIG_PM) && defined(CONFIG_ARCH_OMAP4)
 extern u16 pm44xx_errata;
 #define IS_PM44XX_ERRATUM(id)		(pm44xx_errata & (id))
 #else


