Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaH3BlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 21:41:11 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:36224 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaH3BlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 21:41:05 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: usbduxsigma: fix sparse endianness warnings
Date: Fri, 29 Aug 2014 20:40:55 -0500
Message-Id: <1409362855-1490-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse has many warnings like:

drivers/staging/comedi/drivers/usbduxsigma.c:293:21: warning: cast to
restricted __be32

on lines on which devpriv->in_buf is passed to be32_to_cpu().  This
suggests that this variable should actually be of type __be32.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
This is, as usual, compile tested only.  I tried to verify as best as I
could that this is a sane change, but I am unable to test on the hardware.

 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 94a09c1..e9b11e8 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -157,7 +157,7 @@ struct usbduxsigma_private {
 	/* size of the PWM buffer which holds the bit pattern */
 	int pwm_buf_sz;
 	/* input buffer for the ISO-transfer */
-	uint32_t *in_buf;
+	__be32 *in_buf;
 	/* input buffer for single insn */
 	uint8_t *insn_buf;
 
-- 
2.1.0

