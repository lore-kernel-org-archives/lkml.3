Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934795Ab3GRWWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:22:52 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:57431 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934677Ab3GRWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:52 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 12/15] iio: ti_am335x_adc: Fix allocation count of FIFO buffer.
Date: Thu, 18 Jul 2013 23:21:23 +0100
Message-Id: <1374186086-5015-13-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

Allocating an extra byte is not necessary here. The driver will check
that the allocation is large enough to satisfy the IIO subsystem.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 1b0af2a..44b7181 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -210,7 +210,7 @@ static void tiadc_poll_handler(struct work_struct *work_s)
 		goto out;
 	}
 
-	inputbuffer = kmalloc((fifo1count + 1) * sizeof(u32), GFP_KERNEL);
+	inputbuffer = kmalloc((fifo1count) * sizeof(u32), GFP_KERNEL);
 	if (inputbuffer == NULL)
 		return;
 
-- 
1.7.9.5

