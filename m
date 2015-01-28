Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbbA2Byu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:54:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31816 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbA2Byr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:54:47 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-6a-54c8e7c42c05
From: Robert Baldyga <r.baldyga@samsung.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, akpm@linux-foundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] serial: samsung: remove redundant interrupt enabling
Date: Wed, 28 Jan 2015 14:44:23 +0100
Message-id: <1422452663-24113-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t9jAd0jz0+EGKydw2ExZ/0aNovmxevZ
	LD7/3sVqcXnXHDaLM4t72S0eHN7J7sDmcWLGbxaP/XPXsHv0bVnF6HFmwRF2j8+b5AJYo7hs
	UlJzMstSi/TtErgylp2cw1bwjr3iXPNXpgbG42xdjJwcEgImElvWPYeyxSQu3FsPZgsJLGKU
	uDyfp4uRC8huZ5I4+O4KI0iCTUBHYsv3CWC2iICcxJPbf5hBipgFJjNKdP/pZgdJCAu4Sjw5
	9xLI5uBgEVCV2H3WASTMCxTub5vHBLFMTuLkscmsExi5FzAyrGIUTS1ILihOSs810itOzC0u
	zUvXS87P3cQIDo1n0jsYVzVYHGIU4GBU4uF9YXYiRIg1say4MvcQowQHs5II7+O9QCHelMTK
	qtSi/Pii0pzU4kOM0hwsSuK8SvZtIUIC6YklqdmpqQWpRTBZJg5OqQZGmVbXFT/ipfZ5vr7F
	9OSOA8umZ7c2VyzWfav7/cSSWvM3xxj2PL9Rpd/542VAoXiPXWjwy41hnX1f1nVuLHC1T3rY
	2bWpI7r0W+6PNQdUP3JvNJ5f8O/fjkBhE6X18/urv/Q3SAZzzrmjKbw1yH/F/c0Plp9j2xhu
	f0bqGfs7HrtmjVbvr7eclFiKMxINtZiLihMBG40VOwkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function s3c24xx_serial_start_tx_pio() enables interrupts if needed,
so we don't have to (or even we shouldn't) enable them before.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/tty/serial/samsung.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 024e5ec..a07fe4f 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -358,15 +358,8 @@ void s3c24xx_serial_start_tx(struct uart_port *port)
 			s3c24xx_serial_rx_disable(port);
 
 		tx_enabled(port) = 1;
-		if (!ourport->dma || !ourport->dma->tx_chan) {
-			if (s3c24xx_serial_has_interrupt_mask(port))
-				__clear_bit(S3C64XX_UINTM_TXD,
-						portaddrl(port, S3C64XX_UINTM));
-			else
-				enable_irq(ourport->tx_irq);
-
+		if (!ourport->dma || !ourport->dma->tx_chan)
 			s3c24xx_serial_start_tx_pio(ourport);
-		}
 	}
 
 	if (ourport->dma && ourport->dma->tx_chan) {
-- 
1.9.1

