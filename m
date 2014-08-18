Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaHRDoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 23:44:06 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:48033 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaHRDoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 23:44:04 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: s626: remove unnecessary variable initialization
Date: Sun, 17 Aug 2014 22:43:44 -0500
Message-Id: <1408333424-15763-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We initialize 'irqbit' to 0, only to properly set it immediately
afterwards.  Just remove the zero-initialization.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/s626.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 080608a..e42720c 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1399,7 +1399,6 @@ static void s626_check_dio_interrupts(struct comedi_device *dev)
 	uint8_t group;
 
 	for (group = 0; group < S626_DIO_BANKS; group++) {
-		irqbit = 0;
 		/* read interrupt type */
 		irqbit = s626_debi_read(dev, S626_LP_RDCAPFLG(group));
 
-- 
2.0.4

