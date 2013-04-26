Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3DZMnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:43:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47546 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab3DZMnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:43:07 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCHv4 3/5] arm: omap2+: serial: remove no_console_suspend support
Date: Fri, 26 Apr 2013 18:12:46 +0530
Message-ID: <1366980168-30566-4-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366980168-30566-1-git-send-email-sourav.poddar@ti.com>
References: <1366980168-30566-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"no_console_suspend" is no longer handled in platform file,
Since the omap serial driver is now adapted to prevent
console UART idleing during suspend.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/serial.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index 8396b5b..25fb6e9 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -63,7 +63,6 @@ struct omap_uart_state {
 static LIST_HEAD(uart_list);
 static u8 num_uarts;
 static u8 console_uart_id = -1;
-static u8 no_console_suspend;
 static u8 uart_debug;
 
 #define DEFAULT_RXDMA_POLLRATE		1	/* RX DMA polling rate (us) */
@@ -236,9 +235,6 @@ static int __init omap_serial_early_init(void)
 					uart_name, uart->num);
 			}
 
-			if (cmdline_find_option("no_console_suspend"))
-				no_console_suspend = true;
-
 			/*
 			 * omap-uart can be used for earlyprintk logs
 			 * So if omap-uart is used as console then prevent
@@ -323,9 +319,6 @@ void __init omap_serial_init_port(struct omap_board_data *bdata,
 		return;
 	}
 
-	if ((console_uart_id == bdata->id) && no_console_suspend)
-		omap_device_disable_idle_on_suspend(pdev);
-
 	oh->mux = omap_hwmod_mux_init(bdata->pads, bdata->pads_cnt);
 
 	if (console_uart_id == bdata->id) {
-- 
1.7.1

