Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3FKUUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:20:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab3FKUDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 27/79] USB: mos7720: fix hardware flow control
Date: Tue, 11 Jun 2013 13:02:53 -0700
Message-Id: <20130611195316.056332497@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a26f009a070e840fadacb91013b2391ba7ab6cc2 upstream.

The register access to enable hardware flow control depends on the
device port number and not the port minor number.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7720.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1644,7 +1644,7 @@ static void change_port_settings(struct
 		mos7720_port->shadowMCR |= (UART_MCR_XONANY);
 		/* To set hardware flow control to the specified *
 		 * serial port, in SP1/2_CONTROL_REG             */
-		if (port->number)
+		if (port_number)
 			write_mos_reg(serial, dummy, SP_CONTROL_REG, 0x01);
 		else
 			write_mos_reg(serial, dummy, SP_CONTROL_REG, 0x02);


