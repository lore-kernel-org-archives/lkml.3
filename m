Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaIJTHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:07:06 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:56908 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753353AbaIJTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:07:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH v2 06/14] serial: bfin-uart: Fix auto CTS
Date: Wed, 10 Sep 2014 15:06:28 -0400
Message-Id: <1410375996-4693-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1410375996-4693-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 64851636d568ae9f167cd5d1dcdbfe17e6eef73c,
serial: bfin-uart: Remove ASYNC_CTS_FLOW flag for hardware automatic CTS,
open-codes uart_handle_cts_change() when CONFIG_SERIAL_BFIN_HARD_CTSRTS
to skip start and stop tx.

But the CTS interrupt handler _still_ calls uart_handle_cts_change();
only call uart_handle_cts_change() if !CONFIG_SERIAL_BFIN_HARD_CTSRTS.

cc: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/bfin_uart.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index fc9fbf3..7da9911 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -122,8 +122,9 @@ static irqreturn_t bfin_serial_mctrl_cts_int(int irq, void *dev_id)
 		if (!status)
 			uport->hw_stopped = 1;
 	}
-#endif
+#else
 	uart_handle_cts_change(uport, status & TIOCM_CTS);
+#endif
 
 	return IRQ_HANDLED;
 }
-- 
2.1.0

