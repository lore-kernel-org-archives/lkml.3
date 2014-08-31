Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaHaTpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 15:45:21 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:48742 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaHaTpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 15:45:10 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: usbduxsigma: fix more sparse endianness warnings
Date: Sun, 31 Aug 2014 14:45:00 -0500
Message-Id: <1409514300-15493-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse shows a couple of warnings like:

drivers/staging/comedi/drivers/usbduxsigma.c:787:23: warning: cast to restricted __be32

Looking at the indicated lines shows that the issue is caused by an
incorrect cast to uint32_t instead of __be32.  Fix this cast.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/usbduxsigma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index 5dbab04..5bad118 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -784,7 +784,7 @@ static int usbduxsigma_ai_insn_read(struct comedi_device *dev,
 		}
 
 		/* 32 bits big endian from the A/D converter */
-		val = be32_to_cpu(get_unaligned((uint32_t
+		val = be32_to_cpu(get_unaligned((__be32
 						 *)(devpriv->insn_buf + 1)));
 		val &= 0x00ffffff;	/* strip status byte */
 		val ^= 0x00800000;	/* convert to unsigned */
@@ -1343,7 +1343,7 @@ static int usbduxsigma_getstatusinfo(struct comedi_device *dev, int chan)
 		return ret;
 
 	/* 32 bits big endian from the A/D converter */
-	val = be32_to_cpu(get_unaligned((uint32_t *)(devpriv->insn_buf + 1)));
+	val = be32_to_cpu(get_unaligned((__be32 *)(devpriv->insn_buf + 1)));
 	val &= 0x00ffffff;	/* strip status byte */
 	val ^= 0x00800000;	/* convert to unsigned */
 
-- 
2.1.0

