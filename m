Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787AbaAFXfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:35:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbaAFWkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.10 017/129] can: peak_usb: fix mem leak in pcan_usb_pro_init()
Date: Mon,  6 Jan 2014 14:37:26 -0800
Message-Id: <20140106223900.083761692@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -927,6 +927,9 @@ static int pcan_usb_pro_init(struct peak
 	/* set LED in default state (end of init phase) */
 	pcan_usb_pro_set_led(dev, 0, 1);
 
+	kfree(bi);
+	kfree(fi);
+
 	return 0;
 
  err_out:


