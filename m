Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaEOSht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:37:49 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:60632 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbaEOShs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:37:48 -0400
Message-ID: <1400179065.11786.14.camel@x220>
Subject: [PATCH] ARM: OMAP: omap3stalker: remove two Kconfig macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 20:37:45 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2014 18:37:46.0307 (UTC) FILETIME=[C3EF9130:01CF706C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checks for CONFIG_OMAP2_VENC_OUT_TYPE_SVIDEO and
CONFIG_OMAP2_VENC_OUT_TYPE_COMPOSITE were added in v2.6.35. But the
related Kconfig symbols have never been added to the tree. Remove these
checks.

Initialize connector_type to OMAP_DSS_VENC_TYPE_COMPOSITE explicitly.
That's what's happening currently: OMAP_DSS_VENC_TYPE_COMPOSITE equals
zero and connector_type remains zero since both checks currently fail.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/mach-omap2/board-omap3stalker.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index 119efaf5808a..a2e035e0792a 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -121,11 +121,7 @@ static struct platform_device omap3stalker_tfp410_device = {
 static struct connector_atv_platform_data omap3stalker_tv_pdata = {
 	.name = "tv",
 	.source = "venc.0",
-#if defined(CONFIG_OMAP2_VENC_OUT_TYPE_SVIDEO)
-	.connector_type = OMAP_DSS_VENC_TYPE_SVIDEO,
-#elif defined(CONFIG_OMAP2_VENC_OUT_TYPE_COMPOSITE)
 	.connector_type = OMAP_DSS_VENC_TYPE_COMPOSITE,
-#endif
 	.invert_polarity = false,
 };
 
-- 
1.9.0

