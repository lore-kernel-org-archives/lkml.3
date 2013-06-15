Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3FOQee (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 12:34:34 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34819 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3FOQed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 12:34:33 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: ths7303: remove unused member driver_data
Date: Sat, 15 Jun 2013 22:04:10 +0530
Message-Id: <1371314050-25866-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch removes the driver_data member from ths7303_state structure.
The driver_data member was intended to differentiate between ths7303 and
ths7353 chip and get the g_chip_ident, But as of now g_chip_ident is
obsolete, so there is no need of driver_data.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/ths7303.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 2e17abc..0a2dacb 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -38,7 +38,6 @@ struct ths7303_state {
 	struct v4l2_bt_timings		bt;
 	int std_id;
 	int stream_on;
-	int driver_data;
 };
 
 enum ths7303_filter_mode {
@@ -355,9 +354,6 @@ static int ths7303_probe(struct i2c_client *client,
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &ths7303_ops);
 
-	/* store the driver data to differntiate the chip */
-	state->driver_data = (int)id->driver_data;
-
 	/* set to default 480I_576I filter mode */
 	if (ths7303_setval(sd, THS7303_FILTER_MODE_480I_576I) < 0) {
 		v4l_err(client, "Setting to 480I_576I filter mode failed!\n");
-- 
1.7.9.5

