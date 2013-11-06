Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab3KFOk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:40:26 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:39852 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3KFOkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:40:24 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...),
        linux-kernel@vger.kernel.org (open list)
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2] ths7303: Declare as static a private function
Date: Wed,  6 Nov 2013 15:40:18 +0100
Message-Id: <1383748818-22487-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git grep shows that the function is only called from ths7303.c

Fix this build warning:

CC      drivers/media/i2c/ths7303.o
drivers/media/i2c/ths7303.c:86:5: warning: no previous prototype for  ‘ths7303_setval’ [-Wmissing-prototypes]
   int ths7303_setval(struct v4l2_subdev *sd, enum ths7303_filter_mode mode)
        ^

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v2: Comment by Laurent Pinchart
Align parameters

 drivers/media/i2c/ths7303.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 42276d9..ed9ae88 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -83,7 +83,8 @@ static int ths7303_write(struct v4l2_subdev *sd, u8 reg, u8 val)
 }
 
 /* following function is used to set ths7303 */
-int ths7303_setval(struct v4l2_subdev *sd, enum ths7303_filter_mode mode)
+static int ths7303_setval(struct v4l2_subdev *sd,
+			  enum ths7303_filter_mode mode)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ths7303_state *state = to_state(sd);
-- 
1.8.4.rc3

