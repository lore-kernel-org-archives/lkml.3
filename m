Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaKIBXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 20:23:00 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42314 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaKIBWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 20:22:32 -0500
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: cascardo@linux.vnet.ibm.com
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 4/5] serial: jsm: Replace magic value with the proper define
Date: Sun,  9 Nov 2014 02:22:19 +0100
Message-Id: <1415496140-14997-5-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415496140-14997-4-git-send-email-bergo.torino@gmail.com>
References: <1415496140-14997-1-git-send-email-bergo.torino@gmail.com>
 <1415496140-14997-2-git-send-email-bergo.torino@gmail.com>
 <1415496140-14997-3-git-send-email-bergo.torino@gmail.com>
 <1415496140-14997-4-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The changed function flushes the tx UART and the '4' corresponds to the
UART_FCR_CLEAR_XMIT value. This commit replaces the magic number with
this define.

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/tty/serial/jsm/jsm_neo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/jsm/jsm_neo.c b/drivers/tty/serial/jsm/jsm_neo.c
index 5de6dffb..7291c21 100644
--- a/drivers/tty/serial/jsm/jsm_neo.c
+++ b/drivers/tty/serial/jsm/jsm_neo.c
@@ -644,7 +644,7 @@ static void neo_flush_uart_write(struct jsm_channel *ch)
 
 		/* Check to see if the UART feels it completely flushed the FIFO. */
 		tmp = readb(&ch->ch_neo_uart->isr_fcr);
-		if (tmp & 4) {
+		if (tmp & UART_FCR_CLEAR_XMIT) {
 			jsm_dbg(IOCTL, &ch->ch_bd->pci_dev,
 				"Still flushing TX UART... i: %d\n", i);
 			udelay(10);
-- 
1.9.1

