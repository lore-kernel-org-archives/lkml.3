Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634Ab3ECLj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:39:58 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50993 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3ECLj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:39:56 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH RESEND] media: davinci: vpbe: fix checkpatch warning for CamelCase
Date: Fri,  3 May 2013 17:09:25 +0530
Message-Id: <1367581165-20805-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch fixes checkpatch warning to avoid CamelCase.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 The initial version of this patch was a part of series, which
 is intended to be dropped so sending this patch individually.

 drivers/media/platform/davinci/vpbe_display.c |    2 +-
 drivers/media/platform/davinci/vpbe_osd.c     |   24 ++++++++++++------------
 include/media/davinci/vpbe_osd.h              |    4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 1802f11..1c4ba89 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -929,7 +929,7 @@ static int vpbe_display_s_fmt(struct file *file, void *priv,
 	cfg->interlaced = vpbe_dev->current_timings.interlaced;
 
 	if (V4L2_PIX_FMT_UYVY == pixfmt->pixelformat)
-		cfg->pixfmt = PIXFMT_YCbCrI;
+		cfg->pixfmt = PIXFMT_YCBCRI;
 
 	/* Change of the default pixel format for both video windows */
 	if (V4L2_PIX_FMT_NV12 == pixfmt->pixelformat) {
diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
index 396a51c..6ed82e8 100644
--- a/drivers/media/platform/davinci/vpbe_osd.c
+++ b/drivers/media/platform/davinci/vpbe_osd.c
@@ -119,7 +119,7 @@ static inline u32 osd_modify(struct osd_state *sd, u32 mask, u32 val,
 #define is_rgb_pixfmt(pixfmt) \
 	(((pixfmt) == PIXFMT_RGB565) || ((pixfmt) == PIXFMT_RGB888))
 #define is_yc_pixfmt(pixfmt) \
-	(((pixfmt) == PIXFMT_YCbCrI) || ((pixfmt) == PIXFMT_YCrCbI) || \
+	(((pixfmt) == PIXFMT_YCBCRI) || ((pixfmt) == PIXFMT_YCRCBI) || \
 	((pixfmt) == PIXFMT_NV12))
 #define MAX_WIN_SIZE OSD_VIDWIN0XP_V0X
 #define MAX_LINE_LENGTH (OSD_VIDWIN0OFST_V0LO << 5)
@@ -360,8 +360,8 @@ static void _osd_enable_color_key(struct osd_state *sd,
 			osd_write(sd, colorkey & OSD_TRANSPVALL_RGBL,
 				  OSD_TRANSPVALL);
 		break;
-	case PIXFMT_YCbCrI:
-	case PIXFMT_YCrCbI:
+	case PIXFMT_YCBCRI:
+	case PIXFMT_YCRCBI:
 		if (sd->vpbe_type == VPBE_VERSION_3)
 			osd_modify(sd, OSD_TRANSPVALU_Y, colorkey,
 				   OSD_TRANSPVALU);
@@ -813,8 +813,8 @@ static int try_layer_config(struct osd_state *sd, enum osd_layer layer,
 		if (osd->vpbe_type == VPBE_VERSION_1)
 			bad_config = !is_vid_win(layer);
 		break;
-	case PIXFMT_YCbCrI:
-	case PIXFMT_YCrCbI:
+	case PIXFMT_YCBCRI:
+	case PIXFMT_YCRCBI:
 		bad_config = !is_vid_win(layer);
 		break;
 	case PIXFMT_RGB888:
@@ -950,9 +950,9 @@ static void _osd_set_cbcr_order(struct osd_state *sd,
 	 * The caller must ensure that all windows using YC pixfmt use the same
 	 * Cb/Cr order.
 	 */
-	if (pixfmt == PIXFMT_YCbCrI)
+	if (pixfmt == PIXFMT_YCBCRI)
 		osd_clear(sd, OSD_MODE_CS, OSD_MODE);
-	else if (pixfmt == PIXFMT_YCrCbI)
+	else if (pixfmt == PIXFMT_YCRCBI)
 		osd_set(sd, OSD_MODE_CS, OSD_MODE);
 }
 
@@ -981,8 +981,8 @@ static void _osd_set_layer_config(struct osd_state *sd, enum osd_layer layer,
 				winmd |= (2 << OSD_OSDWIN0MD_BMP0MD_SHIFT);
 				_osd_enable_rgb888_pixblend(sd, OSDWIN_OSD0);
 				break;
-			case PIXFMT_YCbCrI:
-			case PIXFMT_YCrCbI:
+			case PIXFMT_YCBCRI:
+			case PIXFMT_YCRCBI:
 				winmd |= (3 << OSD_OSDWIN0MD_BMP0MD_SHIFT);
 				break;
 			default:
@@ -1128,8 +1128,8 @@ static void _osd_set_layer_config(struct osd_state *sd, enum osd_layer layer,
 					_osd_enable_rgb888_pixblend(sd,
 							OSDWIN_OSD1);
 					break;
-				case PIXFMT_YCbCrI:
-				case PIXFMT_YCrCbI:
+				case PIXFMT_YCBCRI:
+				case PIXFMT_YCRCBI:
 					winmd |=
 					    (3 << OSD_OSDWIN1MD_BMP1MD_SHIFT);
 					break;
@@ -1508,7 +1508,7 @@ static int osd_initialize(struct osd_state *osd)
 	_osd_init(osd);
 
 	/* set default Cb/Cr order */
-	osd->yc_pixfmt = PIXFMT_YCbCrI;
+	osd->yc_pixfmt = PIXFMT_YCBCRI;
 
 	if (osd->vpbe_type == VPBE_VERSION_3) {
 		/*
diff --git a/include/media/davinci/vpbe_osd.h b/include/media/davinci/vpbe_osd.h
index 42628fc..de59364 100644
--- a/include/media/davinci/vpbe_osd.h
+++ b/include/media/davinci/vpbe_osd.h
@@ -82,9 +82,9 @@ enum osd_pix_format {
 	PIXFMT_4BPP,
 	PIXFMT_8BPP,
 	PIXFMT_RGB565,
-	PIXFMT_YCbCrI,
+	PIXFMT_YCBCRI,
 	PIXFMT_RGB888,
-	PIXFMT_YCrCbI,
+	PIXFMT_YCRCBI,
 	PIXFMT_NV12,
 	PIXFMT_OSD_ATTR,
 };
-- 
1.7.4.1

