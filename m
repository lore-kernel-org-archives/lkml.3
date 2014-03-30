Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaC3X3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:29:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbaC3XZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.265916470@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 019/200] USB: cypress_m8: fix ring-indicator detection
 and reporting
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 440ebadeae9298d7de3d4d105342691841ec88d0 upstream.

Fix ring-indicator (RI) status-bit definition, which was defined as CTS,
effectively preventing RI-changes from being detected while reporting
false RI status.

This bug predates git.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/cypress_m8.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/cypress_m8.h
+++ b/drivers/usb/serial/cypress_m8.h
@@ -63,7 +63,7 @@
 #define UART_DSR	0x20	/* data set ready - flow control - device to host */
 #define CONTROL_RTS	0x10	/* request to send - flow control - host to device */
 #define UART_CTS	0x10	/* clear to send - flow control - device to host */
-#define UART_RI		0x10	/* ring indicator - modem - device to host */
+#define UART_RI		0x80	/* ring indicator - modem - device to host */
 #define UART_CD		0x40	/* carrier detect - modem - device to host */
 #define CYP_ERROR	0x08	/* received from input report - device to host */
 /* Note - the below has nothing to do with the "feature report" reset */

