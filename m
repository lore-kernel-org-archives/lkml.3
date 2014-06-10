Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbaFJTvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:51:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35321 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193AbaFJTvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Welling <mwelling@ieee.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 147/160] tty: serial: 8250_core.c Bug fix for Exar chips.
Date: Tue, 10 Jun 2014 12:46:27 -0700
Message-Id: <1402429600-20477-148-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Welling <mwelling@ieee.org>

commit b790f210fe8423eff881b2a8a93ba5dbc45534d0 upstream.

The sleep function was updated to put the serial port to sleep only when necessary.
This appears to resolve the errant behavior of the driver as described in
Kernel Bug 61961 – "My Exar Corp. XR17C/D152 Dual PCI UART modem does not
work with 3.8.0".

Signed-off-by: Michael Welling <mwelling@ieee.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/8250/8250_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 922d5bc..78abb19 100644
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
1.9.1

