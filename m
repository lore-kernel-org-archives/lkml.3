Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbaEKTWC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:22:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818AbaEKTV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:21:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Welling <mwelling@ieee.org>
Subject: [PATCH 3.10 02/48] tty: serial: 8250_core.c Bug fix for Exar chips.
Date: Sun, 11 May 2014 21:19:36 +0200
Message-Id: <20140511191948.425239782@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Welling <mwelling@ieee.org>

commit b790f210fe8423eff881b2a8a93ba5dbc45534d0 upstream.

The sleep function was updated to put the serial port to sleep only when necessary.
This appears to resolve the errant behavior of the driver as described in
Kernel Bug 61961 – "My Exar Corp. XR17C/D152 Dual PCI UART modem does not
work with 3.8.0".

Signed-off-by: Michael Welling <mwelling@ieee.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -555,7 +555,7 @@ static void serial8250_set_sleep(struct
 	 */
 	if ((p->port.type == PORT_XR17V35X) ||
 	   (p->port.type == PORT_XR17D15X)) {
-		serial_out(p, UART_EXAR_SLEEP, 0xff);
+		serial_out(p, UART_EXAR_SLEEP, sleep ? 0xff : 0);
 		return;
 	}
 


