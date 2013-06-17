Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3FQR5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:57:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50472 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab3FQRdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:33:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 28/84] USB: mos7720: fix hardware flow control
Date: Mon, 17 Jun 2013 10:30:32 -0700
Message-Id: <1371490288-23167-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a26f009a070e840fadacb91013b2391ba7ab6cc2 upstream.

The register access to enable hardware flow control depends on the
device port number and not the port minor number.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/mos7720.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index d9da2d4..d166d3a 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1647,7 +1647,7 @@ static void change_port_settings(struct tty_struct *tty,
 		mos7720_port->shadowMCR |= (UART_MCR_XONANY);
 		/* To set hardware flow control to the specified *
 		 * serial port, in SP1/2_CONTROL_REG             */
-		if (port->number)
+		if (port_number)
 			write_mos_reg(serial, dummy, SP_CONTROL_REG, 0x01);
 		else
 			write_mos_reg(serial, dummy, SP_CONTROL_REG, 0x02);
-- 
1.8.1.2

