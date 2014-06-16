Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaFPNWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:22:11 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53088 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbaFPNWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:22:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 16/22] tty: mxser: Use tty->closing for ASYNC_CLOSING
Date: Mon, 16 Jun 2014 09:17:13 -0400
Message-Id: <1402924639-5164-17-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASYNC_CLOSING is no longer used in the tty core; use tty->closing
as substitute.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/mxser.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 4c4a236..573bc00 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2255,10 +2255,8 @@ static irqreturn_t mxser_interrupt(int irq, void *dev_id)
 					break;
 				iir &= MOXA_MUST_IIR_MASK;
 				tty = tty_port_tty_get(&port->port);
-				if (!tty ||
-						(port->port.flags & ASYNC_CLOSING) ||
-						!(port->port.flags &
-							ASYNC_INITIALIZED)) {
+				if (!tty || tty->closing ||
+				    !(port->port.flags & ASYNC_INITIALIZED)) {
 					status = inb(port->ioaddr + UART_LSR);
 					outb(0x27, port->ioaddr + UART_FCR);
 					inb(port->ioaddr + UART_MSR);
-- 
2.0.0

