Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3ENFsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 01:48:46 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52044 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3ENFso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 01:48:44 -0400
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
Subject: [PATCH 4/4] media: pci: remove duplicate checks for EPERM
Date: Tue, 14 May 2013 11:15:17 +0530
Message-Id: <1368510317-4356-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368510317-4356-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch removes check for EPERM in dbg_g/s_register and
vidioc_g/s_register as this check is already performed by core.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c       |    6 ------
 drivers/media/pci/cx18/cx18-av-core.c       |    4 ----
 drivers/media/pci/cx23885/cx23885-ioctl.c   |    6 ------
 drivers/media/pci/cx23885/cx23888-ir.c      |    4 ----
 drivers/media/pci/ivtv/ivtv-ioctl.c         |    2 --
 drivers/media/pci/saa7146/mxb.c             |    4 ----
 drivers/media/pci/saa7164/saa7164-encoder.c |    6 ------
 7 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index e7d0884..a334c94 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1936,9 +1936,6 @@ static int bttv_g_register(struct file *file, void *f,
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	if (!v4l2_chip_match_host(&reg->match)) {
 		/* TODO: subdev errors should not be ignored, this should become a
 		   subdev helper function. */
@@ -1960,9 +1957,6 @@ static int bttv_s_register(struct file *file, void *f,
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	if (!v4l2_chip_match_host(&reg->match)) {
 		/* TODO: subdev errors should not be ignored, this should become a
 		   subdev helper function. */
diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
index 38b1d64..ba8caf0 100644
--- a/drivers/media/pci/cx18/cx18-av-core.c
+++ b/drivers/media/pci/cx18/cx18-av-core.c
@@ -1258,8 +1258,6 @@ static int cx18_av_g_register(struct v4l2_subdev *sd,
 		return -EINVAL;
 	if ((reg->reg & 0x3) != 0)
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->size = 4;
 	reg->val = cx18_av_read4(cx, reg->reg & 0x00000ffc);
 	return 0;
@@ -1274,8 +1272,6 @@ static int cx18_av_s_register(struct v4l2_subdev *sd,
 		return -EINVAL;
 	if ((reg->reg & 0x3) != 0)
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	cx18_av_write4(cx, reg->reg & 0x00000ffc, reg->val);
 	return 0;
 }
diff --git a/drivers/media/pci/cx23885/cx23885-ioctl.c b/drivers/media/pci/cx23885/cx23885-ioctl.c
index acdb6d5..00f5125 100644
--- a/drivers/media/pci/cx23885/cx23885-ioctl.c
+++ b/drivers/media/pci/cx23885/cx23885-ioctl.c
@@ -138,9 +138,6 @@ int cx23885_g_register(struct file *file, void *fh,
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)fh)->dev;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	if (reg->match.type == V4L2_CHIP_MATCH_HOST) {
 		switch (reg->match.addr) {
 		case 0:
@@ -186,9 +183,6 @@ int cx23885_s_register(struct file *file, void *fh,
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)fh)->dev;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	if (reg->match.type == V4L2_CHIP_MATCH_HOST) {
 		switch (reg->match.addr) {
 		case 0:
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index fa672fe..cd98651 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -1116,8 +1116,6 @@ static int cx23888_ir_g_register(struct v4l2_subdev *sd,
 		return -EINVAL;
 	if (addr < CX23888_IR_CNTRL_REG || addr > CX23888_IR_LEARN_REG)
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	reg->size = 4;
 	reg->val = cx23888_ir_read4(state->dev, addr);
 	return 0;
@@ -1135,8 +1133,6 @@ static int cx23888_ir_s_register(struct v4l2_subdev *sd,
 		return -EINVAL;
 	if (addr < CX23888_IR_CNTRL_REG || addr > CX23888_IR_LEARN_REG)
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	cx23888_ir_write4(state->dev, addr, reg->val);
 	return 0;
 }
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 9cbbce0..3e281ec 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -715,8 +715,6 @@ static int ivtv_itvc(struct ivtv *itv, bool get, u64 reg, u64 *val)
 {
 	volatile u8 __iomem *reg_start;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (reg >= IVTV_REG_OFFSET && reg < IVTV_REG_OFFSET + IVTV_REG_SIZE)
 		reg_start = itv->reg_mem - IVTV_REG_OFFSET;
 	else if (itv->has_cx23415 && reg >= IVTV_DECODER_OFFSET &&
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 71e8bea..52cbe7a0 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -669,8 +669,6 @@ static int vidioc_g_register(struct file *file, void *fh, struct v4l2_dbg_regist
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (v4l2_chip_match_host(&reg->match)) {
 		reg->val = saa7146_read(dev, reg->reg);
 		reg->size = 4;
@@ -684,8 +682,6 @@ static int vidioc_s_register(struct file *file, void *fh, const struct v4l2_dbg_
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (v4l2_chip_match_host(&reg->match)) {
 		saa7146_write(dev, reg->reg, reg->val);
 		return 0;
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 0b74fb2..63a72fb 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -1306,9 +1306,6 @@ static int saa7164_g_register(struct file *file, void *fh,
 	struct saa7164_dev *dev = port->dev;
 	dprintk(DBGLVL_ENC, "%s()\n", __func__);
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	return 0;
 }
 
@@ -1319,9 +1316,6 @@ static int saa7164_s_register(struct file *file, void *fh,
 	struct saa7164_dev *dev = port->dev;
 	dprintk(DBGLVL_ENC, "%s()\n", __func__);
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	return 0;
 }
 #endif
-- 
1.7.4.1

