Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab3AMRqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:46:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35180 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755706Ab3AMRpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:50 -0500
Message-Id: <20130113174300.852671306@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:19 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Juergen Beisert <jbe@pengutronix.de>,
        Lauri Hintsala <lauri.hintsala@bluegiga.net>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [ 24/49] video: mxsfb: fix crash when unblanking the display
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lothar Waßmann <LW@KARO-electronics.de>

commit 6c1ecba8d84841277d68140ef485335d5be28485 upstream.

The VDCTRL4 register does not provide the MXS SET/CLR/TOGGLE feature.
The write in mxsfb_disable_controller() sets the data_cnt for the LCD
DMA to 0 which obviously means the max. count for the LCD DMA and
leads to overwriting arbitrary memory when the display is unblanked.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
Acked-by: Juergen Beisert <jbe@pengutronix.de>
Tested-by: Lauri Hintsala <lauri.hintsala@bluegiga.net>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/mxsfb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -366,7 +366,8 @@ static void mxsfb_disable_controller(str
 		loop--;
 	}
 
-	writel(VDCTRL4_SYNC_SIGNALS_ON, host->base + LCDC_VDCTRL4 + REG_CLR);
+	reg = readl(host->base + LCDC_VDCTRL4);
+	writel(reg & ~VDCTRL4_SYNC_SIGNALS_ON, host->base + LCDC_VDCTRL4);
 
 	clk_disable(host->clk);
 


