Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaFDCeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 22:34:02 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48093 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaFDCeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 22:34:01 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH v2 1/5] staging: comedi: addi_apci_1564: remove use of devpriv->b_OutputMemoryStatus
Date: Tue,  3 Jun 2014 21:33:37 -0500
Message-Id: <1401849217-21562-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401849124-21347-1-git-send-email-chase.southwood@gmail.com>
References: <1401849124-21347-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This member of the private data struct is only set at one location in the
entire driver, and then never even used for anything.  Let's just remove
its use.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 0ba5385..19de400 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -149,11 +149,6 @@ static int apci1564_do_config(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
-	if (data[0])
-		devpriv->b_OutputMemoryStatus = ADDIDATA_ENABLE;
-	else
-		devpriv->b_OutputMemoryStatus = ADDIDATA_DISABLE;
-
 	if (data[1] == ADDIDATA_ENABLE)
 		ul_Command = ul_Command | 0x1;
 	else
-- 
1.9.3

