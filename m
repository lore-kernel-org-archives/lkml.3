Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaKRKSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:18:46 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:46180 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKRKSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:18:44 -0500
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH] serial: tegra: clean up tty-flag assignments
Date: Tue, 18 Nov 2014 11:18:02 +0100
Message-Id: <1416305882-8713-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty break and error flags are not bit masks so do not to use bitwise
OR when assigning them.

Note that there is no functional change due to the if-else construct and
flag having been initialised to zero (TTY_NORMAL).

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/serial/serial-tegra.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 53d7c31ce098..0b615d8b968a 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -319,16 +319,16 @@ static char tegra_uart_decode_rx_error(struct tegra_uart_port *tup,
 	if (unlikely(lsr & TEGRA_UART_LSR_ANY)) {
 		if (lsr & UART_LSR_OE) {
 			/* Overrrun error */
-			flag |= TTY_OVERRUN;
+			flag = TTY_OVERRUN;
 			tup->uport.icount.overrun++;
 			dev_err(tup->uport.dev, "Got overrun errors\n");
 		} else if (lsr & UART_LSR_PE) {
 			/* Parity error */
-			flag |= TTY_PARITY;
+			flag = TTY_PARITY;
 			tup->uport.icount.parity++;
 			dev_err(tup->uport.dev, "Got Parity errors\n");
 		} else if (lsr & UART_LSR_FE) {
-			flag |= TTY_FRAME;
+			flag = TTY_FRAME;
 			tup->uport.icount.frame++;
 			dev_err(tup->uport.dev, "Got frame errors\n");
 		} else if (lsr & UART_LSR_BI) {
-- 
2.0.4

