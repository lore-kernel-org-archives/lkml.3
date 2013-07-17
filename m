Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222Ab3GQR2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:28:46 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:42102 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab3GQR1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:23 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 16/21] IIO: ti_adc: Fix allocation count of FIFO buffer.
Date: Wed, 17 Jul 2013 18:26:45 +0100
Message-Id: <1374082010-28095-17-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocating an extra byte is not necessary here. The driver will check

that the allocation is large enough to satisfy the IIO subsystem.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index c257169..21294f2 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -219,7 +219,7 @@ static void tiadc_poll_handler(struct work_struct *work_s)
                 goto out;
         }
 
-        iBuf = kmalloc((fifo1count + 1) * sizeof(u32), GFP_KERNEL);
+        iBuf = kmalloc((fifo1count) * sizeof(u32), GFP_KERNEL);
         if (iBuf == NULL)
                 goto out;
         /*
-- 
1.7.9.5

