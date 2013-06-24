Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3FXPtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:49:00 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38710 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab3FXPsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:48:07 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/2] media: i2c: tvp514x: remove manual setting of subdev name
Date: Mon, 24 Jun 2013 21:17:26 +0530
Message-Id: <1372088846-26263-3-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/i2c/tvp514x.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 864eb14..6578976 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -1148,7 +1148,6 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	/* Register with V4L2 layer as slave device */
 	sd = &decoder->sd;
 	v4l2_i2c_subdev_init(sd, client, &tvp514x_ops);
-	strlcpy(sd->name, TVP514X_MODULE_NAME, sizeof(sd->name));
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	decoder->pad.flags = MEDIA_PAD_FL_SOURCE;
-- 
1.7.9.5

