Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaEOTQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:16:24 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:49530 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbaEOTQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:16:23 -0400
Message-ID: <1400181381.11786.18.camel@x220>
Subject: [PATCH] ARM: OMAP: remove some dead code
From: Paul Bolle <pebolle@tiscali.nl>
To: Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 21:16:21 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2014 19:16:21.0500 (UTC) FILETIME=[27E5FBC0:01CF7072]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CONFIG_CBUS_TAHVO_USB was added in v2.6.17. The related
Kconfig symbol has never been part of the tree. Remove that check.

Replace the while (...) loop with a simple if (...) statement, while
we're at it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested, as usual.

A quick search across the history of the tree suggests CBUS_TAHVO_USB
was N770 related. Not that this matters much.

 arch/arm/mach-omap1/pm.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index dbee729e3b6d..34b4c0044961 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -123,19 +123,8 @@ void omap1_pm_idle(void)
 #warning Enable 32kHz OS timer in order to allow sleep states in idle
 	use_idlect1 = use_idlect1 & ~(1 << 9);
 #else
-
-	while (enable_dyn_sleep) {
-
-#ifdef CONFIG_CBUS_TAHVO_USB
-		extern int vbus_active;
-		/* Clock requirements? */
-		if (vbus_active)
-			break;
-#endif
+	if (enable_dyn_sleep)
 		do_sleep = 1;
-		break;
-	}
-
 #endif
 
 #ifdef CONFIG_OMAP_DM_TIMER
-- 
1.9.0



