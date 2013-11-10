Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3KJSiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 13:38:18 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:56402 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3KJShz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 13:37:55 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: fix potentially uninitialised variable
Date: Sun, 10 Nov 2013 19:37:49 +0100
Message-Id: <1384108669-23392-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

If none of the if conditions take a true path, the ret variable will
never be assigned a value.
---
 drivers/staging/comedi/drivers/vmk80xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 933b01a..0adf3cf 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -465,7 +465,7 @@ static int vmk80xx_do_insn_bits(struct comedi_device *dev,
 	unsigned char *rx_buf = devpriv->usb_rx_buf;
 	unsigned char *tx_buf = devpriv->usb_tx_buf;
 	int reg, cmd;
-	int ret;
+	int ret = 0;

 	if (devpriv->model == VMK8061_MODEL) {
 		reg = VMK8061_DO_REG;
--
1.8.3.2
