Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbbAZNwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:52:53 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58772 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbbAZNwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:52:50 -0500
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hans.verkuil@cisco.com, m.chehab@samsung.com,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH] media: adv7604: CP CSC uses a different register on adv7604 and adv7611
Date: Mon, 26 Jan 2015 14:52:40 +0100
Message-Id: <1422280360-20461-1-git-send-email-jean-michel.hautbois@vodalys.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bits are the same, but register is 0xf4 on ADV7611 instead of 0xfc.
When reading back the value in log_status, differentiate both.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/media/i2c/adv7604.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index e43dd2e..32e53e0 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2310,8 +2310,12 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 			(reg_io_0x02 & 0x04) ? "(16-235)" : "(0-255)",
 			((reg_io_0x02 & 0x04) ^ (reg_io_0x02 & 0x01)) ?
 				"enabled" : "disabled");
-	v4l2_info(sd, "Color space conversion: %s\n",
+	if (state->info->type == ADV7604)
+		v4l2_info(sd, "Color space conversion: %s\n",
 			csc_coeff_sel_rb[cp_read(sd, 0xfc) >> 4]);
+	else
+		v4l2_info(sd, "Color space conversion: %s\n",
+			csc_coeff_sel_rb[cp_read(sd, 0xf4) >> 4]);
 
 	if (!is_digital_input(sd))
 		return 0;
-- 
2.2.2

