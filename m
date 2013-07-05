Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab3GEQWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:22:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab3GEQWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:22:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6/8] ARM: OMAP: omap_common_late_init may be unused
Date: Fri,  5 Jul 2013 18:23:35 +0200
Message-Id: <1373041417-217728-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373041417-217728-1-git-send-email-arnd@arndb.de>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hrrojqIGpa4pc9nHhlm8ccm2foCNK99xwU9Ysis/N/b
 09qyK4fck95WLlJTki9Oqmhf0H4yv3xXRYZT+RAeQSIqIwQE4J
 Yig4iu6FKm/T88a4Hmo7RoIB3c/1xkiMcT2QZSvZGYqvLm53by
 s+0mLDkwHNC4cZz5cteqaq8qP5QprOPRMFxuXO7rGCpIx3mrUw
 ZAPFKEfrnIis9OYNIw1VCHO1/ZnhM/JuyW5oyOsdGUG0n+UUcc
 2EhXjtvuWGMt3+PMI6hI0e8F6YJ5dZek7gjzAXSb1GIMGXfjKa
 uUq/mVYwWJWrv0e0TBwOfPjLtN044Z7sqXw4i4mVZTvYiku4v9
 pCSUCo3rhmWZotb+3CkIC8FCVu/Hjc9TPrWO83jdl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some OMAP SoCs use this function while others do not, and that
causes a warning when building multi_v7_defconfig. Marking the
function __maybe_unused silences the harmless warning without the
need to add complex #ifdef logic.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index fe3253a..4a3f06f 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -394,7 +394,7 @@ static void __init omap_hwmod_init_postsetup(void)
 	omap_pm_if_early_init();
 }
 
-static void __init omap_common_late_init(void)
+static void __init __maybe_unused omap_common_late_init(void)
 {
 	omap_mux_late_init();
 	omap2_common_pm_late_init();
-- 
1.8.3.1

