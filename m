Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab3EOL6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 07:58:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab3EOL63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 07:58:29 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 1/6] media: i2c: ths7303: remove init_enable option from pdata
Date: Wed, 15 May 2013 17:27:17 +0530
Message-Id: <1368619042-28252-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch removes init_enable option from pdata, the init_enable
was intended that the device should start streaming video immediately
but ideally the bridge drivers should call s_stream explicitly for such
devices to start video.

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
 drivers/media/i2c/ths7303.c |    4 +---
 include/media/ths7303.h     |    2 --
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 65853ee..8cddcd0 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -356,9 +356,7 @@ static int ths7303_setup(struct v4l2_subdev *sd)
 	int ret;
 	u8 mask;
 
-	state->stream_on = pdata->init_enable;
-
-	mask = state->stream_on ? 0xff : 0xf8;
+	mask = 0xf8;
 
 	ret = ths7303_write(sd, THS7303_CHANNEL_1, pdata->ch_1 & mask);
 	if (ret)
diff --git a/include/media/ths7303.h b/include/media/ths7303.h
index 980ec51..a7b4929 100644
--- a/include/media/ths7303.h
+++ b/include/media/ths7303.h
@@ -30,13 +30,11 @@
  * @ch_1: Bias value for channel one.
  * @ch_2: Bias value for channel two.
  * @ch_3: Bias value for channel three.
- * @init_enable: initalize on init.
  */
 struct ths7303_platform_data {
 	u8 ch_1;
 	u8 ch_2;
 	u8 ch_3;
-	u8 init_enable;
 };
 
 #endif
-- 
1.7.4.1

