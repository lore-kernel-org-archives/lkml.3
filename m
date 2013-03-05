Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3CEPNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:13:42 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:48953 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3CEPNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:13:41 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mxs: cfa10049: Fix fb initialisation function
Date: Tue,  5 Mar 2013 16:13:35 +0100
Message-Id: <1362496415-6986-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1fe42740 ("ARM: dts: mxs: Add the LCD to the 10049 board") seem
to have been applied with some fuzzyness, and the framebuffer
initialisation code for the CFA-10049 ended up in the CFA-10037
initialisation function.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-mxs/mach-mxs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 0521867..3218f1f 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -402,17 +402,17 @@ static void __init cfa10049_init(void)
 {
 	enable_clk_enet_out();
 	update_fec_mac_prop(OUI_CRYSTALFONTZ);
+
+	mxsfb_pdata.mode_list = cfa10049_video_modes;
+	mxsfb_pdata.mode_count = ARRAY_SIZE(cfa10049_video_modes);
+	mxsfb_pdata.default_bpp = 32;
+	mxsfb_pdata.ld_intf_width = STMLCDIF_18BIT;
 }
 
 static void __init cfa10037_init(void)
 {
 	enable_clk_enet_out();
 	update_fec_mac_prop(OUI_CRYSTALFONTZ);
-
-	mxsfb_pdata.mode_list = cfa10049_video_modes;
-	mxsfb_pdata.mode_count = ARRAY_SIZE(cfa10049_video_modes);
-	mxsfb_pdata.default_bpp = 32;
-	mxsfb_pdata.ld_intf_width = STMLCDIF_18BIT;
 }
 
 static void __init apf28_init(void)
-- 
1.7.10.4

