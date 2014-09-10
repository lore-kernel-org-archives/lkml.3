Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaIJGEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:04:38 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:51175 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaIJGEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:04:37 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 3/4] staging: comedi: hwdrv_apci3120: else is not useful after return
Date: Wed, 10 Sep 2014 01:04:28 -0500
Message-Id: <c6d8e417a99b39f54b1405c32d38fa04b736b598.1409983606.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1409983606.git.chase.southwood@gmail.com>
References: <cover.1409983606.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The statement nested in an else after a return may be brought out one
indent level, the else is useless.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index d776a0c..470c866 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -1217,8 +1217,8 @@ static int apci3120_ai_cmd(struct comedi_device *dev,
 
 	if (cmd->scan_begin_src == TRIG_FOLLOW)
 		return apci3120_cyclic_ai(1, dev, s);
-	else	/* TRIG_TIMER */
-		return apci3120_cyclic_ai(2, dev, s);
+	/* TRIG_TIMER */
+	return apci3120_cyclic_ai(2, dev, s);
 }
 
 /*
-- 
2.1.0

