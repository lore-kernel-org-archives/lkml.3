Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaAWKLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:11:39 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48371 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaAWKLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:11:36 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-ab-52e0ead5bf88
From: Kamil Debski <k.debski@samsung.com>
To: "'Amit Grover'" <amit.grover@samsung.com>, m.chehab@samsung.com,
        linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, rob@landley.net,
        kyungmin.park@samsung.com, jtp.park@samsung.com
Cc: hans.verkuil@cisco.com, andrew.smirnov@gmail.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, arun.kk@samsung.com,
        anatol.pomozov@gmail.com, jmccrohan@gmail.com, austin.lobo@samsung.com,
        "'Swami Nathan'" <swaminath.p@samsung.com>
References: <1388400186-22045-1-git-send-email-amit.grover@samsung.com>
In-reply-to: <1388400186-22045-1-git-send-email-amit.grover@samsung.com>
Subject: RE: [PATCH] [media] s5p-mfc: Add Horizontal and Vertical search range
 for Video Macro Blocks
Date: Thu, 23 Jan 2014 11:11:31 +0100
Message-id: <019f01cf1823$7e020fa0$7a062ee0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8FS7CQrSKfNEhGSQ+O4Lh0tvBu5wS1iTaQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t/xa7pXXz0IMtj0V9XiWd8nVouXvYUW
	zR22Fh9P3Wa1mP/pJovFkp+7mCz6H61ntDiy9iqTxdmmN+wWmx5fY7VY2LaExeLyrjlsFj0b
	trJazDi/j8ni4jp5i3Uvp7NYHH7TzmrR1jWV0UHIY8rvjaweO2fdZfd4tXomq8fmJfUefVtW
	MXp83iQXwBbFZZOSmpNZllqkb5fAlbHy9lX2gpP2Ff2/rzM1MDabdDFyckgImEjMfHieGcIW
	k7hwbz1bFyMXh5DAUkaJo43LmCCcBiaJw/9aWboYOTjYBDQlVt3zAImLCKxikrh/ehZYB7PA
	O0aJF9cXs4KMEhJwl1i+uIMRxOYU8JBY/2YZO0izsEC6xN8FmiBhFgFViZ4ni5lBwrwCDhJX
	9vqChHkFBCV+TL7HAmIzC2hJrN95nAnClpfYvOYtWLmEgLrEo7+6IGERASOJrrO3oMpFJO42
	PGedwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQmLz6w7G
	pcesDjEKcDAq8fAmfrkfJMSaWFZcmXuIUYKDWUmE9+KLB0FCvCmJlVWpRfnxRaU5qcWHGJk4
	OKUaGJm5rK//cVFYfbeYi/nEoxDxqd+df/w7cZuL6bu62q5qyftM159YFnGmhz5PqbM5ISG+
	+fnpWUuedJ1z1NM3T8r9FNx1peqp75l9LK57mR+zzTTbztsyx83X5sf1pVamLacmdSYxZa5z
	Ngr1kWK5ePCx60Fx9+WOKc5GQrwxmRLGFbyGPMYhSizFGYmGWsxFxYkAY3DinKsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

> From: Amit Grover [mailto:amit.grover@samsung.com]
> Sent: Monday, December 30, 2013 11:43 AM
> 
> This patch adds Controls to set Horizontal and Vertical search range
> for Motion Estimation block for Samsung MFC video Encoders.
> 
> Signed-off-by: Swami Nathan <swaminath.p@samsung.com>
> Signed-off-by: Amit Grover <amit.grover@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml    |   14 +++++++++++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   24
> +++++++++++++++++++++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 ++------
>  drivers/media/v4l2-core/v4l2-ctrls.c            |   14 +++++++++++++
>  include/uapi/linux/v4l2-controls.h              |    2 ++
>  6 files changed, 58 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> b/Documentation/DocBook/media/v4l/controls.xml
> index 7a3b49b..70a0f6f 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -2258,6 +2258,20 @@ Applicable to the MPEG1, MPEG2, MPEG4
> encoders.</entry>
>  VBV buffer control.</entry>
>  	      </row>
> 
> +		  <row><entry></entry></row>
> +	      <row id="v4l2-mpeg-video-horz-search-range">
> +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE</constant

HORZ is nowhere used. HOR is more commonly used in control names.
V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE seems better.

> >&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Sets the Horizontal
> search range for Video Macro blocks.</entry>
> +	      </row>

It's expressed in pixels? If so then it should be mentioned here. Also I
think this lacks the mention that it is used for motion estimation.
Please add a more detailed description.

> +
> +		 <row><entry></entry></row>
> +	      <row id="v4l2-mpeg-video-vert-search-range">
> +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE</constant
> >&nbsp;</entry>

V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE seems better.

> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Sets the Vertical search
> range for Video Macro blocks.</entry>
> +	      </row>
> +

This description is too vague as well.

>  	      <row><entry></entry></row>
>  	      <row>
>  		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&nb
> sp;</entry>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index 6920b54..f2c13c3 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -430,6 +430,8 @@ struct s5p_mfc_vp8_enc_params {
>  struct s5p_mfc_enc_params {
>  	u16 width;
>  	u16 height;
> +	u32 horz_range;
> +	u32 vert_range;

mv_h_range ?
mv_v_range ?

> 
>  	u16 gop_size;
>  	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 4ff3b6c..a02e7b8 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -208,6 +208,24 @@ static struct mfc_control controls[] = {
>  		.default_value = 0,
>  	},
>  	{
> +		.id = V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE,
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.name = "horizontal search range of video macro block",

This too should be property capitalised. Please mention the motion vectors
too.

> +		.minimum = 16,
> +		.maximum = 128,
> +		.step = 16,
> +		.default_value = 32,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE,
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.name = "vertical search range of video macro block",

This too should be property capitalised. Please mention the motion vectors
too.

> +		.minimum = 16,
> +		.maximum = 128,
> +		.step = 16,
> +		.default_value = 32,
> +	},
> +	{
>  		.id = V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE,
>  		.type = V4L2_CTRL_TYPE_INTEGER,
>  		.minimum = 0,
> @@ -1377,6 +1395,12 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl
> *ctrl)
>  	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
>  		p->vbv_size = ctrl->val;
>  		break;
> +	case V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE:
> +		p->horz_range = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE:
> +		p->vert_range = ctrl->val;
> +		break;
>  	case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:
>  		p->codec.h264.cpb_size = ctrl->val;
>  		break;
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index 461358c..47e1807 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -727,14 +727,10 @@ static int s5p_mfc_set_enc_params(struct
> s5p_mfc_ctx *ctx)
>  	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
> 
>  	/* setting for MV range [16, 256] */
> -	reg = 0;
> -	reg &= ~(0x3FFF);
> -	reg = 256;
> +	reg = (p->horz_range & 0x3fff);	/* conditional check in app */
>  	WRITEL(reg, S5P_FIMV_E_MV_HOR_RANGE_V6);

Please add a S5P_FIMV_E_MV_HOR_RANGE_V6_MASK or something instead of this
magic number.
> 
> -	reg = 0;
> -	reg &= ~(0x3FFF);
> -	reg = 256;
> +	reg = (p->vert_range & 0x3fff);	/* conditional check in app */

Please add a S5P_FIMV_E_MV_VER_RANGE_V6_MASK or something instead of this
magic number.

>  	WRITEL(reg, S5P_FIMV_E_MV_VER_RANGE_V6);
> 
>  	WRITEL(0x0, S5P_FIMV_E_FRAME_INSERTION_V6);
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-
> core/v4l2-ctrls.c
> index fb46790..7cf23d5 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -735,6 +735,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_DEC_PTS:			return
"Video
> Decoder PTS";
>  	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:			return
"Video
> Decoder Frame Count";
>  	case V4L2_CID_MPEG_VIDEO_VBV_DELAY:			return
"Initial
> Delay for VBV Control";
> +	case V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE:		return "hor
> search range of video MB";

This should be property capitalised. Please mention the motion vectors too.

> +	case V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE:		return "vert
> search range of video MB";

This too should be property capitalised. Please mention the motion vectors
too.

>  	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return
> "Repeat Sequence Header";
> 
>  	/* VPX controls */
> @@ -905,6 +907,18 @@ void v4l2_ctrl_fill(u32 id, const char **name,
> enum v4l2_ctrl_type *type,
>  		*min = 0;
>  		*max = *step = 1;
>  		break;
> +	case V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE:
> +		*type = V4L2_CTRL_TYPE_INTEGER;
> +		*min = 16;
> +		*max = 128;
> +		*step = 16;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE:
> +		*type = V4L2_CTRL_TYPE_INTEGER;
> +		*min = 16;
> +		*max = 128;
> +		*step = 16;
> +		break;
>  	case V4L2_CID_PAN_RESET:
>  	case V4L2_CID_TILT_RESET:
>  	case V4L2_CID_FLASH_STROBE:
> diff --git a/include/uapi/linux/v4l2-controls.h
> b/include/uapi/linux/v4l2-controls.h
> index 1666aab..bcce536 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -372,6 +372,8 @@ enum v4l2_mpeg_video_multi_slice_mode {
>  #define V4L2_CID_MPEG_VIDEO_DEC_FRAME
> 	(V4L2_CID_MPEG_BASE+224)
>  #define V4L2_CID_MPEG_VIDEO_VBV_DELAY
> 	(V4L2_CID_MPEG_BASE+225)
>  #define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER
> 	(V4L2_CID_MPEG_BASE+226)
> +#define V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE
> 	(V4L2_CID_MPEG_BASE+227)
> +#define V4L2_CID_MPEG_VIDEO_VERT_SEARCH_RANGE
> 	(V4L2_CID_MPEG_BASE+228)
> 
>  #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP
> 	(V4L2_CID_MPEG_BASE+300)
>  #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP
> 	(V4L2_CID_MPEG_BASE+301)
> --
> 1.7.9.5

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


