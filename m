Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3ENFqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 01:46:31 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:57769 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3ENFq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 01:46:29 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, ivtv-devel@ivtvdriver.org
Cc: linux-kernel@vger.kernel.org,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Andy Walls <awalls@md.metrocast.net>,
        Mike Isely <isely@pobox.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Antti Palosaari <crope@iki.fi>,
        =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexey Klimov <klimov.linux@gmail.com>,
        Martin Bugge <marbugge@cisco.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Janne Grunau <j@jannau.net>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/4] media: i2c: remove duplicate checks for EPERM in dbg_g/s_register
Date: Tue, 14 May 2013 11:15:14 +0530
Message-Id: <1368510317-4356-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch removes check for EPERM in dbg_g/s_register of subdevice
drivers as this check is already performed by core.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/ad9389b.c              |    4 ----
 drivers/media/i2c/adv7183.c              |    4 ----
 drivers/media/i2c/adv7604.c              |    4 ----
 drivers/media/i2c/cs5345.c               |    4 ----
 drivers/media/i2c/cx25840/cx25840-core.c |    4 ----
 drivers/media/i2c/m52790.c               |    4 ----
 drivers/media/i2c/mt9v011.c              |    4 ----
 drivers/media/i2c/ov7670.c               |    4 ----
 drivers/media/i2c/saa7115.c              |    4 ----
 drivers/media/i2c/saa7127.c              |    4 ----
 drivers/media/i2c/saa717x.c              |    4 ----
 drivers/media/i2c/ths7303.c              |    4 ----
 drivers/media/i2c/tvp5150.c              |    4 ----
 drivers/media/i2c/tvp7002.c              |   10 ++--------
 drivers/media/i2c/upd64031a.c            |    4 ----
 drivers/media/i2c/upd64083.c             |    4 ----
 drivers/media/i2c/vs6624.c               |    4 ----
 17 files changed, 2 insertions(+), 72 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 58344b6..bd77895 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -347,8 +347,6 @@ static int ad9389b_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->val = ad9389b_rd(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -360,8 +358,6 @@ static int ad9389b_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regi
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	ad9389b_wr(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 56a1fa4..fa7bb46 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -500,8 +500,6 @@ static int adv7183_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->val = adv7183_read(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -513,8 +511,6 @@ static int adv7183_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regi
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	adv7183_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 31a63c9..e29e7c8 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -647,8 +647,6 @@ static int adv7604_g_register(struct v4l2_subdev *sd,
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->size = 1;
 	switch (reg->reg >> 8) {
 	case 0:
@@ -705,8 +703,6 @@ static int adv7604_s_register(struct v4l2_subdev *sd,
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	switch (reg->reg >> 8) {
 	case 0:
 		io_write(sd, reg->reg & 0xff, reg->val & 0xff);
diff --git a/drivers/media/i2c/cs5345.c b/drivers/media/i2c/cs5345.c
index 1d2f7c8..d27d9b7 100644
--- a/drivers/media/i2c/cs5345.c
+++ b/drivers/media/i2c/cs5345.c
@@ -103,8 +103,6 @@ static int cs5345_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->size = 1;
 	reg->val = cs5345_read(sd, reg->reg & 0x1f);
 	return 0;
@@ -116,8 +114,6 @@ static int cs5345_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regis
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	cs5345_write(sd, reg->reg & 0x1f, reg->val & 0xff);
 	return 0;
 }
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 12fb9b2..33c4e51 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -1664,8 +1664,6 @@ static int cx25840_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->size = 1;
 	reg->val = cx25840_read(client, reg->reg & 0x0fff);
 	return 0;
@@ -1677,8 +1675,6 @@ static int cx25840_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regi
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	cx25840_write(client, reg->reg & 0x0fff, reg->val & 0xff);
 	return 0;
 }
diff --git a/drivers/media/i2c/m52790.c b/drivers/media/i2c/m52790.c
index 39f50fd..7b46a2f 100644
--- a/drivers/media/i2c/m52790.c
+++ b/drivers/media/i2c/m52790.c
@@ -87,8 +87,6 @@ static int m52790_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (reg->reg != 0)
 		return -EINVAL;
 	reg->size = 1;
@@ -103,8 +101,6 @@ static int m52790_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regis
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (reg->reg != 0)
 		return -EINVAL;
 	state->input = reg->val & 0x0303;
diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index 3f415fd..0d53f14 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -411,8 +411,6 @@ static int mt9v011_g_register(struct v4l2_subdev *sd,
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 
 	reg->val = mt9v011_read(sd, reg->reg & 0xff);
 	reg->size = 2;
@@ -427,8 +425,6 @@ static int mt9v011_s_register(struct v4l2_subdev *sd,
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 
 	mt9v011_write(sd, reg->reg & 0xff, reg->val & 0xffff);
 
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 617ad3f..eb043eb 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1479,8 +1479,6 @@ static int ov7670_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	ret = ov7670_read(sd, reg->reg & 0xff, &val);
 	reg->val = val;
 	reg->size = 1;
@@ -1493,8 +1491,6 @@ static int ov7670_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regis
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	ov7670_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index d6f589a..d36994d 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1464,8 +1464,6 @@ static int saa711x_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->val = saa711x_read(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -1477,8 +1475,6 @@ static int saa711x_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regi
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	saa711x_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
diff --git a/drivers/media/i2c/saa7127.c b/drivers/media/i2c/saa7127.c
index 8a47ac1..40ca361 100644
--- a/drivers/media/i2c/saa7127.c
+++ b/drivers/media/i2c/saa7127.c
@@ -665,8 +665,6 @@ static int saa7127_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->val = saa7127_read(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -678,8 +676,6 @@ static int saa7127_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regi
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	saa7127_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index cf3a0aa..b38c5fd 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -981,8 +981,6 @@ static int saa717x_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->val = saa717x_read(sd, reg->reg);
 	reg->size = 1;
 	return 0;
@@ -996,8 +994,6 @@ static int saa717x_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regi
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	saa717x_write(sd, addr, val);
 	return 0;
 }
diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index c433955..65853ee 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -236,8 +236,6 @@ static int ths7303_g_register(struct v4l2_subdev *sd,
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 
 	reg->size = 1;
 	reg->val = ths7303_read(sd, reg->reg);
@@ -251,8 +249,6 @@ static int ths7303_s_register(struct v4l2_subdev *sd,
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 
 	ths7303_write(sd, reg->reg, reg->val);
 	return 0;
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 485159a..f6ecd29 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1054,8 +1054,6 @@ static int tvp5150_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	res = tvp5150_read(sd, reg->reg & 0xff);
 	if (res < 0) {
 		v4l2_err(sd, "%s: failed with error = %d\n", __func__, res);
@@ -1073,8 +1071,6 @@ static int tvp5150_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regi
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	tvp5150_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 270e699..f2d908f 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -739,8 +739,7 @@ static int tvp7002_query_dv_timings(struct v4l2_subdev *sd,
  *
  * Get the value of a TVP7002 decoder device register.
  * Returns zero when successful, -EINVAL if register read fails or
- * access to I2C client fails, -EPERM if the call is not allowed
- * by disabled CAP_SYS_ADMIN.
+ * access to I2C client fails.
  */
 static int tvp7002_g_register(struct v4l2_subdev *sd,
 						struct v4l2_dbg_register *reg)
@@ -751,8 +750,6 @@ static int tvp7002_g_register(struct v4l2_subdev *sd,
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 
 	ret = tvp7002_read(sd, reg->reg & 0xff, &val);
 	reg->val = val;
@@ -765,8 +762,7 @@ static int tvp7002_g_register(struct v4l2_subdev *sd,
  * @reg: ptr to v4l2_dbg_register struct
  *
  * Get the value of a TVP7002 decoder device register.
- * Returns zero when successful, -EINVAL if register read fails or
- * -EPERM if call not allowed.
+ * Returns zero when successful, -EINVAL if register read fails.
  */
 static int tvp7002_s_register(struct v4l2_subdev *sd,
 						const struct v4l2_dbg_register *reg)
@@ -775,8 +771,6 @@ static int tvp7002_s_register(struct v4l2_subdev *sd,
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 
 	return tvp7002_write(sd, reg->reg & 0xff, reg->val & 0xff);
 }
diff --git a/drivers/media/i2c/upd64031a.c b/drivers/media/i2c/upd64031a.c
index f0a0921..2055128 100644
--- a/drivers/media/i2c/upd64031a.c
+++ b/drivers/media/i2c/upd64031a.c
@@ -168,8 +168,6 @@ static int upd64031a_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->val = upd64031a_read(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -181,8 +179,6 @@ static int upd64031a_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_re
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	upd64031a_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
diff --git a/drivers/media/i2c/upd64083.c b/drivers/media/i2c/upd64083.c
index 343e021..2b802c1 100644
--- a/drivers/media/i2c/upd64083.c
+++ b/drivers/media/i2c/upd64083.c
@@ -126,8 +126,6 @@ static int upd64083_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->val = upd64083_read(sd, reg->reg & 0xff);
 	reg->size = 1;
 	return 0;
@@ -139,8 +137,6 @@ static int upd64083_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_reg
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	upd64083_write(sd, reg->reg & 0xff, reg->val & 0xff);
 	return 0;
 }
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index f366fad..c154697 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -741,8 +741,6 @@ static int vs6624_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *r
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->val = vs6624_read(sd, reg->reg & 0xffff);
 	reg->size = 1;
 	return 0;
@@ -754,8 +752,6 @@ static int vs6624_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regis
 
 	if (!v4l2_chip_match_i2c_client(client, &reg->match))
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	vs6624_write(sd, reg->reg & 0xffff, reg->val & 0xff);
 	return 0;
 }
-- 
1.7.4.1

