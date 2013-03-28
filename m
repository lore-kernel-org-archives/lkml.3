Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab3C1OQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:16:41 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:33798 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab3C1OQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:16:40 -0400
From: Sebastien Royen <sebastien.royen@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Cc: linux-kernel@vger.kernel.org, seb <sebastien.royen@armadeus.com>
Subject: [PATCH 1/1] Input: mma8450 - fix signed 12bits to 32bits conversion
Date: Thu, 28 Mar 2013 15:16:29 +0100
Message-Id: <1364480189-15062-1-git-send-email-sebastien.royen@armadeus.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: seb <sebastien.royen@armadeus.com>

Event value is wrong. Should be in range -2048 to 2047, but is in range 0 to 4095.
Use s8 to int conversion and remove 0xfff mask.

Signed-off-by: Sebastien Royen <sebastien.royen@armadeus.com>
---
 drivers/input/misc/mma8450.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/mma8450.c b/drivers/input/misc/mma8450.c
index 480557f..f330969 100644
--- a/drivers/input/misc/mma8450.c
+++ b/drivers/input/misc/mma8450.c
@@ -123,9 +123,9 @@ static void mma8450_poll(struct input_polled_dev *dev)
 	if (ret < 0)
 		return;
 
-	x = ((buf[1] << 4) & 0xff0) | (buf[0] & 0xf);
-	y = ((buf[3] << 4) & 0xff0) | (buf[2] & 0xf);
-	z = ((buf[5] << 4) & 0xff0) | (buf[4] & 0xf);
+	x = ((int)(s8)buf[1] << 4) | (buf[0] & 0xf);
+	y = ((int)(s8)buf[3] << 4) | (buf[2] & 0xf);
+	z = ((int)(s8)buf[5] << 4) | (buf[4] & 0xf);
 
 	input_report_abs(dev->input, ABS_X, x);
 	input_report_abs(dev->input, ABS_Y, y);
-- 
1.7.9.5

