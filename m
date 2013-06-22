Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3FVRou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 13:44:50 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53813 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3FVRot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 13:44:49 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 1/2] media: i2c: tvp7002: add support for asynchronous probing
Date: Sat, 22 Jun 2013 23:14:14 +0530
Message-Id: <1371923055-29623-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371923055-29623-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371923055-29623-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Both synchronous and asynchronous tvp7002 subdevice probing
is supported by this patch.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
---
 drivers/media/i2c/tvp7002.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 36ad565..b577548 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/tvp7002.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
@@ -1040,6 +1041,10 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 	}
 	v4l2_ctrl_handler_setup(&device->hdl);
 
+	error = v4l2_async_register_subdev(&device->sd);
+	if (error)
+		goto error;
+
 	return 0;
 
 error:
@@ -1064,6 +1069,7 @@ static int tvp7002_remove(struct i2c_client *c)
 
 	v4l2_dbg(1, debug, sd, "Removing tvp7002 adapter"
 				"on address 0x%x\n", c->addr);
+	v4l2_async_unregister_subdev(&device->sd);
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&device->sd.entity);
 #endif
-- 
1.7.9.5

