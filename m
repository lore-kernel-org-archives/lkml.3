Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab3L3Kl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:41:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10140 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3L3Kl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:41:26 -0500
X-AuditID: cbfee68e-b7f566d000002344-4a-52c14dd47860
From: Amit Grover <amit.grover@samsung.com>
To: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, rob@landley.net,
        kyungmin.park@samsung.com, k.debski@samsung.com, jtp.park@samsung.com
Cc: hans.verkuil@cisco.com, andrew.smirnov@gmail.com, s.nawrocki@samsung.com,
        arun.kk@samsung.com, anatol.pomozov@gmail.com, jmccrohan@gmail.com,
        austin.lobo@samsung.com, Swami Nathan <swaminath.p@samsung.com>
Subject: [PATCH] [media] s5p-mfc: Add Horizontal and Vertical search range for
 Video Macro Blocks
Date: Mon, 30 Dec 2013 16:13:06 +0530
Message-id: <1388400186-22045-1-git-send-email-amit.grover@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWyRsSkTveK78Egg8kXtSxe9hZaNHfYWnw8
	dZvVYv6nmywWS37uYrLof7Se0eLI2qtMFj9eX2CzONv0ht1i0+NrrBYL25awWFzeNYfNomfD
	VlaLGef3MVlcXCdvse7ldBaLw2/aWS3auqYyOgh5TPm9kdVj56y77B6vVs9k9di8pN6jb8sq
	Ro/Pm+QC2KK4bFJSczLLUov07RK4Mnac3MVasNK44saiSUwNjKu1uxg5OSQETCSOT5nMBGGL
	SVy4t56ti5GDQ0hgKaPESQmYki0ru9lAbCGB6YwSn5ZrQdg9TBLfphSA2GwC2hLbZywHquHi
	EBGYziRx8PUKMIdZ4CqjxIsjl5lBqoQFkiU2HfkEtoxFQFWiqfEkK4jNK+AuMf/NFhaQxRIC
	ChJzJtmA9EoIXGOXeHP1DwtEvYDEt8mHoGpkJTYdYIY4TlLi4IobLBMYBRcwMqxiFE0tSC4o
	TkovMtIrTswtLs1L10vOz93ECIyR0/+e9e1gvHnA+hBjMtC4icxSosn5wBjLK4k3NDYzsjA1
	MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MnryqEtkfg75xGEat
	qNt0WJPjk0H7rbZ47zvXu8SnLLfW06picwloFjvWMu9Mtgj/tS3vlxVvT07pW6JpuGb38Xfq
	XX+T729sFJDmKuX4fdo6JupO5O1Y85YDj475dKo9r05LrDuyYfFURdaqpdI3L7l+EjjK3q68
	y8Nj1g63OvcFD5JmNf9QYinOSDTUYi4qTgQAht/Wc6cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd0rvgeDDO5eVLB42Vto0dxha/Hx
	1G1Wi/mfbrJYLPm5i8mi/9F6Rosja68yWfx4fYHN4mzTG3aLTY+vsVosbFvCYnF51xw2i54N
	W1ktZpzfx2RxcZ28xbqX01ksDr9pZ7Vo65rK6CDkMeX3RlaPnbPusnu8Wj2T1WPzknqPvi2r
	GD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMAbpfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ix4+Qu1oKVxhU3
	Fk1iamBcrd3FyMkhIWAisWVlNxuELSZx4d56MFtIYDqjxKflWhB2D5PEtykFIDabgLbE9hnL
	gWq4OEQEpjNJHHy9AsxhFrjKKPHiyGVmkCphgWSJTUc+MYHYLAKqEk2NJ1lBbF4Bd4n5b7aw
	dDFyAG1TkJgzyWYCI/cCRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFR+ExqB+PKBotD
	jAIcjEo8vAE3DgQJsSaWFVfmHmKU4GBWEuHlcT8YJMSbklhZlVqUH19UmpNafIgxGWj5RGYp
	0eR8YILIK4k3NDYxNzU2tTSxMDGzJE1YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbG3pXP
	7y+xsuZgVl/r064ladIauiXzYWtg0sOJbr5MfnOid9zhqHZXr/ry/UXI3kMLbuz4/vFAQVbx
	/T811jlTdU5PlyhY72Arc/W2U5iioUDw1OfPvPL6PP+tctTjWcuidu3N5662/CLZIIf5CRnh
	6vdWOaiJL9QzWSqVzffIfHJDxgLruq1KLMUZiYZazEXFiQBsQ2jMBgMAAA==
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
 Documentation/DocBook/media/v4l/controls.xml    |   14 +++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   24 +++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 ++------
 drivers/media/v4l2-core/v4l2-ctrls.c            |   14 +++++++++++++
 include/uapi/linux/v4l2-controls.h              |    2 ++
 6 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 7a3b49b..70a0f6f 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2258,6 +2258,20 @@ Applicable to the MPEG1, MPEG2, MPEG4 encoders.</entry>
 VBV buffer control.</entry>
 	      </row>
 
+		  <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-horz-search-range">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Sets the Horizontal search range for Video Macro blocks.</entry>
+	      </row>
+
+		 <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-vert-search-range">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Sets the Vertical search range for Video Macro blocks.</entry>
+	      </row>
+
 	      <row><entry></entry></row>
 	      <row>
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&nbsp;</entry>
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 6920b54..f2c13c3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -430,6 +430,8 @@ struct s5p_mfc_vp8_enc_params {
 struct s5p_mfc_enc_params {
 	u16 width;
 	u16 height;
+	u32 horz_range;
+	u32 vert_range;
 
 	u16 gop_size;
 	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 4ff3b6c..a02e7b8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -208,6 +208,24 @@ static struct mfc_control controls[] = {
 		.default_value = 0,
 	},
 	{
+		.id = V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "horizontal search range of video macro block",
+		.minimum = 16,
+		.maximum = 128,
+		.step = 16,
+		.default_value = 32,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "vertical search range of video macro block",
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
+	case V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE:
+		p->horz_range = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE:
+		p->vert_range = ctrl->val;
+		break;
 	case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:
 		p->codec.h264.cpb_size = ctrl->val;
 		break;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 461358c..47e1807 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -727,14 +727,10 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
 
 	/* setting for MV range [16, 256] */
-	reg = 0;
-	reg &= ~(0x3FFF);
-	reg = 256;
+	reg = (p->horz_range & 0x3fff);	/* conditional check in app */
 	WRITEL(reg, S5P_FIMV_E_MV_HOR_RANGE_V6);
 
-	reg = 0;
-	reg &= ~(0x3FFF);
-	reg = 256;
+	reg = (p->vert_range & 0x3fff);	/* conditional check in app */
 	WRITEL(reg, S5P_FIMV_E_MV_VER_RANGE_V6);
 
 	WRITEL(0x0, S5P_FIMV_E_FRAME_INSERTION_V6);
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index fb46790..7cf23d5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -735,6 +735,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_DEC_PTS:			return "Video Decoder PTS";
 	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:			return "Video Decoder Frame Count";
 	case V4L2_CID_MPEG_VIDEO_VBV_DELAY:			return "Initial Delay for VBV Control";
+	case V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE:		return "hor search range of video MB";
+	case V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE:		return "vert search range of video MB";
 	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
 
 	/* VPX controls */
@@ -905,6 +907,18 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*min = 0;
 		*max = *step = 1;
 		break;
+	case V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		*min = 16;
+		*max = 128;
+		*step = 16;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		*min = 16;
+		*max = 128;
+		*step = 16;
+		break;
 	case V4L2_CID_PAN_RESET:
 	case V4L2_CID_TILT_RESET:
 	case V4L2_CID_FLASH_STROBE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 1666aab..bcce536 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -372,6 +372,8 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_DEC_FRAME			(V4L2_CID_MPEG_BASE+224)
 #define V4L2_CID_MPEG_VIDEO_VBV_DELAY			(V4L2_CID_MPEG_BASE+225)
 #define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER		(V4L2_CID_MPEG_BASE+226)
+#define V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+227)
+#define V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+228)
 
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
-- 
1.7.9.5

