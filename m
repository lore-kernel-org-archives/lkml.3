Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbaEMKLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933651AbaEMKLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:52 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Welling <mwelling@ieee.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 124/182] tty: serial: 8250_core.c Bug fix for Exar chips.
Date: Tue, 13 May 2014 11:27:56 +0200
Message-Id: <1236463ffc89ed97f34966526217f1c8adfdfbb4.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Welling <mwelling@ieee.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b790f210fe8423eff881b2a8a93ba5dbc45534d0 upstream.

The sleep function was updated to put the serial port to sleep only when necessary.
This appears to resolve the errant behavior of the driver as described in
Kernel Bug 61961 – "My Exar Corp. XR17C/D152 Dual PCI UART modem does not
work with 3.8.0".

Signed-off-by: Michael Welling <mwelling@ieee.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/8250/8250_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 4f6e01cf67f7..aa6db8f4ee18 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -555,7 +555,7 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 	 */
 	if ((p->port.type == PORT_XR17V35X) ||
 	   (p->port.type == PORT_XR17D15X)) {
-		serial_out(p, UART_EXAR_SLEEP, 0xff);
+		serial_out(p, UART_EXAR_SLEEP, sleep ? 0xff : 0);
 		return;
 	}
 
-- 
1.9.3

