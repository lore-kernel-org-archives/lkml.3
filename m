Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaEOTy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:54:57 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:65350 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbaEOTyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:54:55 -0400
Message-ID: <1400183692.11786.23.camel@x220>
Subject: [PATCH] ARM: OMAP: AM3517EVM: remove check for
 CONFIG_PANEL_SHARP_LQ043T1DG01
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 21:54:52 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2014 19:54:53.0265 (UTC) FILETIME=[89D15410:01CF7077]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol PANEL_SHARP_LQ043T1DG01 was removed in v2.6.38. The
check for CONFIG_PANEL_SHARP_LQ043T1DG01 and its MODULE variant has
evaluated to false ever since. Remove that check.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested, again.

 arch/arm/mach-omap2/board-am3517evm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index 543d9a882de3..4f9383cecf76 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -262,12 +262,7 @@ static struct usbhs_phy_data phy_data[] __initdata = {
 
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
-#if defined(CONFIG_PANEL_SHARP_LQ043T1DG01) || \
-		defined(CONFIG_PANEL_SHARP_LQ043T1DG01_MODULE)
-	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
-#else
 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
-#endif
 };
 
 #ifdef CONFIG_OMAP_MUX
-- 
1.9.0

