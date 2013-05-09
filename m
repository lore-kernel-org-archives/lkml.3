Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3EIMvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:51:08 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42527 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3EIMvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:51:06 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH] serial: pl011: protect attribute read from NULL platform data struct
Date: Thu,  9 May 2013 13:50:55 +0100
Message-Id: <1368103855-28363-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's completely feasible that platform data will be empty i.e. when
booting with Device Tree with no device AUXDATA. So we must protect
it's use in these use-cases, or risk a kernel Oops.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
*******                                                        *******
If this issue has not already been fixed, this patch should be applied
during the v3.10 -rc:s, as it fixes a serious bug which was introduced
in the merge-window.
*******                                                        *******

 drivers/tty/serial/amba-pl011.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 8ab70a6..e2774f9 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -332,7 +332,7 @@ static void pl011_dma_probe_initcall(struct device *dev, struct uart_amba_port *
 		dmaengine_slave_config(chan, &rx_conf);
 		uap->dmarx.chan = chan;
 
-		if (plat->dma_rx_poll_enable) {
+		if (plat && plat->dma_rx_poll_enable) {
 			/* Set poll rate if specified. */
 			if (plat->dma_rx_poll_rate) {
 				uap->dmarx.auto_poll_rate = false;
-- 
1.7.10.4

