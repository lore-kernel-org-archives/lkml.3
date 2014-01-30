Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaA3Hh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 02:37:27 -0500
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3180 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaA3HhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 02:37:25 -0500
Message-ID: <52EA00E5.10303@xs4all.nl>
Date: Thu, 30 Jan 2014 08:36:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Amit Grover <amit.grover@samsung.com>
CC: linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kyungmin.park@samsung.com, k.debski@samsung.com,
        prabhakar.csengg@gmail.com, s.nawrocki@samsung.com,
        hans.verkuil@cisco.com, swaminath.p@samsung.com, jtp.park@samsung.com,
        Rrob@landley.net, andrew.smirnov@gmail.com, anatol.pomozov@gmail.com,
        jmccrohan@gmail.com, joe@perches.com, awalls@md.metrocast.net,
        arun.kk@samsung.com, austin.lobo@samsung.com
Subject: Re: [PATCH v2 1/2] drivers/media: v4l2: Add settings for Horizontal
 and Vertical MV Search Range
References: <52E0ED10.2020901@samsung.com> <1391060563-27015-1-git-send-email-amit.grover@samsung.com> <1391060563-27015-2-git-send-email-amit.grover@samsung.com>
In-Reply-To: <1391060563-27015-2-git-send-email-amit.grover@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 06:42 AM, Amit Grover wrote:
> Adding V4L2 controls for horizontal and vertical search range in pixels
> for motion estimation module in video encoder.
> 
> Signed-off-by: Swami Nathan <swaminath.p@samsung.com>
> Signed-off-by: Amit Grover <amit.grover@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml |   20 ++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c         |   14 ++++++++++++++
>  include/uapi/linux/v4l2-controls.h           |    2 ++
>  3 files changed, 36 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 7a3b49b..be04d18 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -2258,6 +2258,26 @@ Applicable to the MPEG1, MPEG2, MPEG4 encoders.</entry>
>  VBV buffer control.</entry>
>  	      </row>
>  
> +		  <row><entry></entry></row>
> +	      <row id=""v4l2-mpeg-video-hor-search-range">
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +		<row><entry spanname="descr">Horizontal search range defines maximum horizontal search area in pixels
> +to search and match for the present Macroblock (MB) in the reference picture. This V4L2 control macro is used to set
> +horizontal search range for motion estimation module in video encoder.</entry>
> +	      </row>
> +
> +		 <row><entry></entry></row>
> +	      <row id="v4l2-mpeg-video-vert-search-range">
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE</constant>&nbsp;</entry>
> +		<entry>integer</entry>

These two controls sound very mfc specific as opposed to being part of the standard.
If so, then they should be named V4L2_CID_MPEG_MFC51_*. Also, for which codecs are
these controls applicable?

> +	      </row>
> +		<row><entry spanname="descr">Vertical search range defines maximum vertical search area in pixels
> +to search and match for the present Macroblock (MB) in the reference picture. This V4L2 control macro is used to set
> +vertical search range for motion estimation module in video encoder.</entry>
> +	      </row>
> +
>  	      <row><entry></entry></row>
>  	      <row>
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&nbsp;</entry>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index fb46790..e775388 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -735,6 +735,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_DEC_PTS:			return "Video Decoder PTS";
>  	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:			return "Video Decoder Frame Count";
>  	case V4L2_CID_MPEG_VIDEO_VBV_DELAY:			return "Initial Delay for VBV Control";
> +	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:		return "Horizontal MV Search Range";
> +	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		return "Vertical MV Search Range";
>  	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
>  
>  	/* VPX controls */
> @@ -905,6 +907,18 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  		*min = 0;
>  		*max = *step = 1;
>  		break;
> +	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:
> +		*type = V4L2_CTRL_TYPE_INTEGER;
> +		*min = 16;
> +		*max = 128;
> +		*step = 16;

Weird range, why not use range 1-8?

> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:
> +		*type = V4L2_CTRL_TYPE_INTEGER;
> +		*min = 16;
> +		*max = 128;
> +		*step = 16;
> +		break;
>  	case V4L2_CID_PAN_RESET:
>  	case V4L2_CID_TILT_RESET:
>  	case V4L2_CID_FLASH_STROBE:
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 1666aab..80e1def 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -372,6 +372,8 @@ enum v4l2_mpeg_video_multi_slice_mode {
>  #define V4L2_CID_MPEG_VIDEO_DEC_FRAME			(V4L2_CID_MPEG_BASE+224)
>  #define V4L2_CID_MPEG_VIDEO_VBV_DELAY			(V4L2_CID_MPEG_BASE+225)
>  #define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER		(V4L2_CID_MPEG_BASE+226)
> +#define V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+227)
> +#define V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE		(V4L2_CID_MPEG_BASE+228)
>  
>  #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
>  #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
> 

Regards,

	Hans
