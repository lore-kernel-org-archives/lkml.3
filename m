Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaFPNXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:23:53 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42830 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753536AbaFPNXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:23:50 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 21/22] serial: core: Remove superfluous ldisc flush from uart_close()
Date: Mon, 16 Jun 2014 09:17:18 -0400
Message-Id: <1402924639-5164-22-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty_ldisc_flush() after port hardware shutdown is unnecessary;
the ldisc flush was just performed before the hardware shutdown
in tty_port_close_start() and the ldisc will be released when
uart_close() returns (because the last port close implies the
last tty close).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 212ee07..15212d7 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1351,9 +1351,6 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	mutex_lock(&port->mutex);
 	uart_shutdown(tty, state);
-
-	tty_ldisc_flush(tty);
-
 	tty_port_tty_set(port, NULL);
 	tty->closing = 0;
 	spin_lock_irqsave(&port->lock, flags);
-- 
2.0.0

