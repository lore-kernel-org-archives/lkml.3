Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3ARH4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:56:42 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:62953 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3ARH4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:56:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUDAJtkv1BbdWObgWdsb2JhbABEg0eCJrNZhGUWDgEBFiYngkxSgT4TiBTCKZB4A5YDiU2JbQ
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH] ipack/devices/ipoctal: add missing rx_enable = 1
Date: Fri, 18 Jan 2013 08:57:21 +0100
Message-Id: <1358495841-5559-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a bug in the code when managing a GE IP-OCTAL-485 board. The RX would
be enabled but we have a wrong state in the rx_enable flag.

Then, if the user changes the terminal settings, RX would not be enabled again.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 0b3c4b8..93cbf9d 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -207,6 +207,7 @@ static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 		if (channel->board_id == IPACK1_DEVICE_ID_SBS_OCTAL_485) {
 			iowrite8(CR_CMD_NEGATE_RTSN, &channel->regs->w.cr);
 			iowrite8(CR_ENABLE_RX, &channel->regs->w.cr);
+			channel->rx_enable = 1;
 		}
 	}
 
-- 
1.7.10.4

