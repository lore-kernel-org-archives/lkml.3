Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3DVNoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:44:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47209 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab3DVNoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:44:19 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCHv2 3/5] arm: omap2+: serial: remove no_console_suspend support
Date: Mon, 22 Apr 2013 19:13:55 +0530
Message-ID: <1366638237-6880-4-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>
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
---
 arch/arm/mach-omap2/serial.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index f660156..58d5b56 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -63,7 +63,6 @@ struct omap_uart_state {
 static LIST_HEAD(uart_list);
 static u8 num_uarts;
 static u8 console_uart_id = -1;
-static u8 no_console_suspend;
 static u8 uart_debug;
 
 #define DEFAULT_RXDMA_POLLRATE		1	/* RX DMA polling rate (us) */
@@ -207,9 +206,6 @@ static int __init omap_serial_early_init(void)
 					uart_name, uart->num);
 			}
 
-			if (cmdline_find_option("no_console_suspend"))
-				no_console_suspend = true;
-
 			/*
 			 * omap-uart can be used for earlyprintk logs
 			 * So if omap-uart is used as console then prevent
@@ -292,9 +288,6 @@ void __init omap_serial_init_port(struct omap_board_data *bdata,
 		return;
 	}
 
-	if ((console_uart_id == bdata->id) && no_console_suspend)
-		omap_device_disable_idle_on_suspend(pdev);
-
 	oh->mux = omap_hwmod_mux_init(bdata->pads, bdata->pads_cnt);
 
 	if (console_uart_id == bdata->id) {
-- 
1.7.1

