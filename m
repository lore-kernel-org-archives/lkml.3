Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaBDJ6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:58:48 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43602 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaBDJ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:58:08 -0500
X-AuditID: cbfee690-b7f266d00000287c-1b-52f0b9afd560
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
Subject: [PATCH 2/2] [media] s5p-mfc: Add Horizontal and Vertical MV Search
 Range
Date: Tue, 04 Feb 2014 15:29:59 +0530
Message-id: <1391507999-31437-3-git-send-email-amit.grover@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391507999-31437-1-git-send-email-amit.grover@samsung.com>
References: <52E0ED10.2020901@samsung.com>
 <1391507999-31437-1-git-send-email-amit.grover@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkSnf9zg9BBk8apC2e9X1itXjZW2jR
	3GFr8fHUbVaL+Z9usli8aU+yWPJzF5PFqcnPmCz6H61ntJh9/zGLxZG1V5ksfry+wGZxtukN
	u8Wmx9dYLRa2LWGxuLxrDptFz4atQMPur2C2ePrqOZvF4TftrBZtXVMZHUQ9pvzeyOqxc9Zd
	do9Xq2eyemxeUu8x68Jmdo8vq64xe/RtWcXo8XmTnMepr5/ZAzijuGxSUnMyy1KL9O0SuDLe
	rX7PVHBJpmLZ99oGxiUSXYycHBICJhJfPr1hhbDFJC7cW8/WxcjFISSwlFHi7sK3rDBFP55N
	YQOxhQSmM0p82csBUdTDJHH4xT92kASbgLbE9hnLwbpFBDYwSTzsvsgO4jALvGKUODZ5BTNI
	lbBAsMTxt0vBRrEIqErc+bMQzOYVcJd4MKEPqIEDaJ2CxJxJNiBhTgEPiRN7LzBBbM6QeHf8
	EtgCCYGZHBLb/r9ih5gjIPFt8iEWiF5ZiU0HmCGulpQ4uOIGywRG4QWMDKsYRVMLkguKk9KL
	TPSKE3OLS/PS9ZLzczcxAmPy9L9nE3Yw3jtgfYgxGWjcRGYp0eR8YEznlcQbGpsZWZiamBob
	mVuakSasJM6r9igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjvKofxv84WW3dhEqFdrbd
	N1u+wohx2ZsVoW9S206WT7ZwPvvByNJNpDb8YKjDl4l8sxt/bjwtf3DGqSDlrzckEz6fZTU/
	0nelXiss/XCqUh8Pl4VLx4kqxV7/JxP//G9U2bf/jaNk7dUb1/a4iZ364Kv6ysl7zTmOJ0sz
	4n7eNCybfPquyvYTSizFGYmGWsxFxYkA8I5aCd8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd31Oz8EGdzeJmDxrO8Tq8XL3kKL
	5g5bi4+nbrNazP90k8XiTXuSxZKfu5gsTk1+xmTR/2g9o8Xs+49ZLI6svcpk8eP1BTaLs01v
	2C02Pb7GarGwbQmLxeVdc9gsejZsBRp2fwWzxdNXz9ksDr9pZ7Vo65rK6CDqMeX3RlaPnbPu
	snu8Wj2T1WPzknqPWRc2s3t8WXWN2aNvyypGj8+b5DxOff3MHsAZ1cBok5GamJJapJCal5yf
	kpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0nZJCWWJOKVAoILG4WEnfDtOE
	0BA3XQuYxghd35AguB4jAzSQsIYx493q90wFl2Qqln2vbWBcItHFyMkhIWAi8ePZFDYIW0zi
	wr31YLaQwHRGiS97OboYuYDsHiaJwy/+sYMk2AS0JbbPWM4GkhAR2MAk8bD7IjuIwyzwilHi
	2OQVzCBVwgLBEsffLgUbxSKgKnHnz0Iwm1fAXeLBhD6gBg6gdQoScybZgIQ5BTwkTuy9wASx
	OUPi3fFLbBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI74Z1I7GFc2WBxiFOBg
	VOLhVVD5ECTEmlhWXJl7iFGCg1lJhNd8G1CINyWxsiq1KD++qDQntfgQYzLQUROZpUST84HJ
	KK8k3tDYxNzU2NTSxMLEzJI0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGJsdFxl9dfWq
	UXrEUxIWL7LyU9vdg1OufjoX8bb65beN61SXf0vznhE38RWv8fzueyK3plpOPVaUM+thFJPs
	HaU8l7IT3R35t1l3dF39Z53O+rvolM21nGuZX4zLVurJzpY9/DluDX/uk4xcK1vx38ySOwue
	sUfYGJxeNIdhtXvxqtJWm9P7HZRYijMSDbWYi4oTAZmKWw88AwAA
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
index f723f1f..5c28cc3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -426,6 +426,8 @@ struct s5p_mfc_vp8_enc_params {
 struct s5p_mfc_enc_params {
 	u16 width;
 	u16 height;
+	u32 mv_h_range;
+	u32 mv_v_range;
 
 	u16 gop_size;
 	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 91b6e02..df83cd1 100644
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
@@ -1417,6 +1435,12 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
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
index f6ff2db..f64621a 100644
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

