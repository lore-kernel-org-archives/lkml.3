Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbaH3Bkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 21:40:51 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:59605 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaH3Bku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 21:40:50 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: usbdux: fix sparse endianness warnings
Date: Fri, 29 Aug 2014 20:40:32 -0500
Message-Id: <1409362832-1312-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse has many warnings like:

drivers/staging/comedi/drivers/usbdux.c:366:32: warning: cast to
restricted __le16

on lines on which devpriv->in_buf or devpriv->insn_buf are passed to
le16_to_cpu().  This suggests that both of these variables should actually
be of type __le16.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
This is, as usual, compile tested only.  I tried to verify as best as I
could that this is a sane change, but I am unable to test on the hardware.

 drivers/staging/comedi/drivers/usbdux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 053bc50..e1a19222 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -198,9 +198,9 @@ struct usbdux_private {
 	/* size of the PWM buffer which holds the bit pattern */
 	int pwm_buf_sz;
 	/* input buffer for the ISO-transfer */
-	uint16_t *in_buf;
+	__le16 *in_buf;
 	/* input buffer for single insn */
-	uint16_t *insn_buf;
+	__le16 *insn_buf;
 
 	unsigned int ao_readback[USBDUX_NUM_AO_CHAN];
 
-- 
2.1.0

