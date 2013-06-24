Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3FXPsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:48:08 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63768 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3FXPsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:48:03 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/2] media: i2c: tvp7002: remove manual setting of subdev name
Date: Mon, 24 Jun 2013 21:17:25 +0530
Message-Id: <1372088846-26263-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372088846-26263-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1372088846-26263-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch removes manual setting of subdev name in the
probe, ideally subdev names must be unique.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/i2c/tvp7002.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 4896024..ba8a7b5 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -1065,7 +1065,6 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 	error = tvp7002_s_dv_timings(sd, &timings);
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	strlcpy(sd->name, TVP7002_MODULE_NAME, sizeof(sd->name));
 	device->pad.flags = MEDIA_PAD_FL_SOURCE;
 	device->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	device->sd.entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
-- 
1.7.9.5

