Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaJQJBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:01:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51897 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaJQJBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:01:15 -0400
From: Kumar Gala <galak@codeaurora.org>
To: gregkh@linuxfoundation.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] tty/serial: earlycon: Fix print for implied MMIO case
Date: Fri, 17 Oct 2014 04:01:11 -0500
Message-Id: <1413536471-3454-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the case in which we just provide an address as an argument to the
earlycon console type like:

earlycon=msm_serial_dm,0xf991e000

We would report this as an IO port based mapping and not as MMIO.  Simple
fix to use the port->iotype to decide which message to print.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 drivers/tty/serial/earlycon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
index a514ee6..64fe25a 100644
--- a/drivers/tty/serial/earlycon.c
+++ b/drivers/tty/serial/earlycon.c
@@ -98,7 +98,7 @@ static int __init parse_options(struct earlycon_device *device,
 		strlcpy(device->options, options, length);
 	}
 
-	if (mmio || mmio32)
+	if (port->iotype == UPIO_MEM || port->iotype == UPIO_MEM32)
 		pr_info("Early serial console at MMIO%s 0x%llx (options '%s')\n",
 			mmio32 ? "32" : "",
 			(unsigned long long)port->mapbase,
-- 
Qualcomm Innovation Center, Inc.
 The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
 a Linux Foundation Collaborative Project

