Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaBGNDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:03:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41764 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbaBGLtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 077/233] USB: cypress_m8: fix ring-indicator detection and reporting
Date: Fri,  7 Feb 2014 11:44:56 +0000
Message-Id: <1391773652-25214-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 440ebadeae9298d7de3d4d105342691841ec88d0 upstream.

Fix ring-indicator (RI) status-bit definition, which was defined as CTS,
effectively preventing RI-changes from being detected while reporting
false RI status.

This bug predates git.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/cypress_m8.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/cypress_m8.h b/drivers/usb/serial/cypress_m8.h
index b461311..ce13e61 100644
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
-- 
1.8.3.2

