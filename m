Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3CST63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:58:29 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:39214 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3CST62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:58:28 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Mar 2013 15:58:27 EDT
From: Philippe Langlais <philippe.langlais@st.com>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans-Peter Oeri <hp@oeri.ch>, Philippe Langlais <philippe.langlais@st.com>
Subject: [PATCH] tty: serial: 8250: remove U6715 16550A auto-detection
Date: Tue, 19 Mar 2013 20:50:09 +0100
Message-Id: <1363722609-20021-1-git-send-email-philippe.langlais@st.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The auto-detection based on 64 bytes fifo size causes troubles
for the identification of the MultiTechZPX Modems (pci 11c1:0480).
They loose the ability to do hardware flow control
(specifically CTS is never set).

Signed-off-by: Philippe Langlais <philippe.langlais@st.com>
---
 drivers/tty/serial/8250/8250.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index cf6a538..3255014 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -1026,15 +1026,6 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 
 		return;
 	}
-
-	/*
-	 * We distinguish between 16550A and U6 16550A by counting
-	 * how many bytes are in the FIFO.
-	 */
-	if (up->port.type == PORT_16550A && size_fifo(up) == 64) {
-		up->port.type = PORT_U6_16550A;
-		up->capabilities |= UART_CAP_AFE;
-	}
 }
 
 /*
-- 
1.7.9.5

