Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab3AOWuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:50:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:45981 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933178Ab3AOWuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Juergen Beisert <jbe@pengutronix.de>,
        Lauri Hintsala <lauri.hintsala@bluegiga.net>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [ 055/171] video: mxsfb: fix crash when unblanking the display
Date: Tue, 15 Jan 2013 14:43:40 -0800
Message-Id: <20130115224317.392114395@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 
 	clk_disable_unprepare(host->clk);
 


