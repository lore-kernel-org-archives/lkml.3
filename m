Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaA3Fk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 00:40:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:18451 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbaA3Fky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 00:40:54 -0500
X-AuditID: cbfee68f-b7f156d00000276c-a2-52e9e5e5ba7d
From: Amit Grover <amit.grover@samsung.com>
To: linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kyungmin.park@samsung.com, k.debski@samsung.com,
        prabhakar.csengg@gmail.com, s.nawrocki@samsung.com,
        hans.verkuil@cisco.com, hverkuil@xs4all.nl, swaminath.p@samsung.com
Cc: jtp.park@samsung.com, Rrob@landley.net, andrew.smirnov@gmail.com,
        anatol.pomozov@gmail.com, jmccrohan@gmail.com, joe@perches.com,
        awalls@md.metrocast.net, arun.kk@samsung.com, amit.grover@samsung.com,
        austin.lobo@samsung.com
Subject: [PATCH v2 2/2] drivers/media: s5p-mfc: Add Horizontal and Vertical MV
 Search Range
Date: Thu, 30 Jan 2014 11:12:43 +0530
Message-id: <1391060563-27015-3-git-send-email-amit.grover@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391060563-27015-1-git-send-email-amit.grover@samsung.com>
References: <52E0ED10.2020901@samsung.com>
 <1391060563-27015-1-git-send-email-amit.grover@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkRvfp05dBBuvX8Fs86/vEavGyt9Ci
	ucPW4uOp26wW8z/dZLF4055kseTnLiaLU5OfMVn0P1rPaDH7/mMWiyNrrzJZ/Hh9gc3ibNMb
	dotNj6+xWixsW8JicXnXHDaLng1bgYbdX8Fs8fTVczaLw2/aWS3auqYyOoh6TPm9kdVj56y7
	7B6vVs9k9di8pN5j1oXN7B5fVl1j9ujbsorR4/MmOY9TXz+zB3BGcdmkpOZklqUW6dslcGXc
	W5ZWcFmmYu3sVcwNjEsluhg5OCQETCSe/ArrYuQEMsUkLtxbz9bFyMUhJLCUUeLWpnNsEAkT
	ic8/G1ghEosYJWbNXsEO4fQwSdyf85MRpIpNQFti+4zlYO0iAhuYJB52XwSrYhZ4xShxbPIK
	ZpAqYYFYiR277zOB2CwCqhKPtj4Di/MKuEscu3ScGeImBYk5k2xAwpwCHhJ3/78BWyAkkCHx
	rOUa2BkSAnM5JI6uOcQCMUdA4ttkEBukV1Zi0wFmiLMlJQ6uuMEygVF4ASPDKkbR1ILkguKk
	9CJjveLE3OLSvHS95PzcTYzAmDz971n/Dsa7B6wPMSYDjZvILCWanA+M6bySeENjMyMLUxNT
	YyNzSzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwFiidU9SoaRQla09U7Xh
	WXnpT7mOg2e2vlw1Ucaofbb3upNfmzZp/Wl5uGwOX720jX3Mx0UMqWzXF+TFfvAJuL/FQFzQ
	X/fuV+WDd6c7HP22p+ngHL12pSv6rbX+j64HJu6Lnqx9vKH94U2x7NsvFHQrNHOvrM7Nlk/5
	5FH4x09GovnS2iLhbCWW4oxEQy3mouJEAEI4SMPfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAd2nT18GGbQ+YbN41veJ1eJlb6FF
	c4etxcdTt1kt5n+6yWLxpj3JYsnPXUwWpyY/Y7Lof7Se0WL2/ccsFkfWXmWy+PH6ApvF2aY3
	7BabHl9jtVjYtoTF4vKuOWwWPRu2Ag27v4LZ4umr52wWh9+0s1q0dU1ldBD1mPJ7I6vHzll3
	2T1erZ7J6rF5Sb3HrAub2T2+rLrG7NG3ZRWjx+dNch6nvn5mD+CMamC0yUhNTEktUkjNS85P
	ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAH6TkmhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMOYcW9ZWsFlmYq1s1cxNzAulehi5OSQEDCR+PyzgRXCFpO4
	cG89WxcjF4eQwCJGiVmzV7BDOD1MEvfn/GQEqWIT0JbYPmM5WJWIwAYmiYfdF8GqmAVeMUoc
	m7yCGaRKWCBWYsfu+0wgNouAqsSjrc/A4rwC7hLHLh0HsjmA9ilIzJlkAxLmFPCQuPv/DdgC
	IYEMiWct11gnMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc88+kdzCuarA4xCjA
	wajEw7ti8ssgIdbEsuLK3EOMEhzMSiK8cXeBQrwpiZVVqUX58UWlOanFhxiTgY6ayCwlmpwP
	TEd5JfGGxibmpsamliYWJmaWpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cDYJ/rygvfW
	lNzA1zzMMmLfxbUKzT0eeTM8mbAvpSDmr9silstfIl5nrfWSKtxnvTozdrFRSFhBr0jj7w1r
	XnarOm6uXdfYyPyHPeXhf/05i/Y5J2vGt3Hc0kqzXcx2byZHt9bXJX9mZf7jvcB+vGaJocbi
	atnNe77KabJaBv/oyPDpFGYUs1BiKc5INNRiLipOBACHO3uBPQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Controls to set Horizontal and Vertical search range
for Motion Estimation block for Samsung MFC video Encoders.

Signed-off-by: Swami Nathan <swaminath.p@samsung.com>
Signed-off-by: Amit Grover <amit.grover@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   24 +++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 ++------
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
index 2398cdf..8d0b686 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -229,6 +229,7 @@
 #define S5P_FIMV_E_PADDING_CTRL_V6		0xf7a4
 #define S5P_FIMV_E_MV_HOR_RANGE_V6		0xf7ac
 #define S5P_FIMV_E_MV_VER_RANGE_V6		0xf7b0
+#define S5P_FIMV_E_MV_RANGE_V6_MASK		0x3fff
 
 #define S5P_FIMV_E_VBV_BUFFER_SIZE_V6		0xf84c
 #define S5P_FIMV_E_VBV_INIT_DELAY_V6		0xf850
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 6920b54..b90ee34 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -430,6 +430,8 @@ struct s5p_mfc_vp8_enc_params {
 struct s5p_mfc_enc_params {
 	u16 width;
 	u16 height;
+	u32 mv_h_range;
+	u32 mv_v_range;
 
 	u16 gop_size;
 	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 4ff3b6c..704f30c1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -208,6 +208,24 @@ static struct mfc_control controls[] = {
 		.default_value = 0,
 	},
 	{
+		.id = V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Horizontal MV Search Range",
+		.minimum = 16,
+		.maximum = 128,
+		.step = 16,
+		.default_value = 32,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Vertical MV Search Range",
+		.minimum = 16,
+		.maximum = 128,
+		.step = 16,
+		.default_value = 32,
+	},
+	{
 		.id = V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE,
 		.type = V4L2_CTRL_TYPE_INTEGER,
 		.minimum = 0,
@@ -1377,6 +1395,12 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
 		p->vbv_size = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:
+		p->mv_h_range = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:
+		p->mv_v_range = ctrl->val;
+		break;
 	case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:
 		p->codec.h264.cpb_size = ctrl->val;
 		break;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 461358c..3c10188 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -727,14 +727,10 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
 
 	/* setting for MV range [16, 256] */
-	reg = 0;
-	reg &= ~(0x3FFF);
-	reg = 256;
+	reg = (p->mv_h_range & S5P_FIMV_E_MV_RANGE_V6_MASK);
 	WRITEL(reg, S5P_FIMV_E_MV_HOR_RANGE_V6);
 
-	reg = 0;
-	reg &= ~(0x3FFF);
-	reg = 256;
+	reg = (p->mv_v_range & S5P_FIMV_E_MV_RANGE_V6_MASK);
 	WRITEL(reg, S5P_FIMV_E_MV_VER_RANGE_V6);
 
 	WRITEL(0x0, S5P_FIMV_E_FRAME_INSERTION_V6);
-- 
1.7.9.5

