Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaAMQDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:03:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53295 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaAMQDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 102/208] can: peak_usb: fix mem leak in pcan_usb_pro_init()
Date: Mon, 13 Jan 2014 15:59:03 +0000
Message-Id: <1389628849-1614-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 20fb4eb96fb0350d28fc4d7cbfd5506711079592 upstream.

This patch fixes a memory leak in pcan_usb_pro_init(). In patch

    f14e224 net: can: peak_usb: Do not do dma on the stack

the struct pcan_usb_pro_fwinfo *fi and struct pcan_usb_pro_blinfo *bi were
converted from stack to dynamic allocation va kmalloc(). However the
corresponding kfree() was not introduced.

This patch adds the missing kfree().

Reported-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index 8ee9d15..263dd92 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -927,6 +927,9 @@ static int pcan_usb_pro_init(struct peak_usb_device *dev)
 	/* set LED in default state (end of init phase) */
 	pcan_usb_pro_set_led(dev, 0, 1);
 
+	kfree(bi);
+	kfree(fi);
+
 	return 0;
 
  err_out:
-- 
1.8.3.2

