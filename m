Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaKQKxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:53:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:19228 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaKQKxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:53:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,402,1413270000"; 
   d="scan'208";a="633114717"
Message-ID: <5469D3B3.2050408@linux.intel.com>
Date: Mon, 17 Nov 2014 12:53:39 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:33.0) Gecko/20100101 SeaMonkey/2.30
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] media: v4l2-subdev.h: drop the guard
 CONFIG_VIDEO_V4L2_SUBDEV_API for v4l2_subdev_get_try_*()
References: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

Lad, Prabhakar wrote:
> this patch removes the guard CONFIG_VIDEO_V4L2_SUBDEV_API
> for v4l2_subdev_get_try_*() functions.
> In cases where a subdev using v4l2_subdev_get_try_*() calls
> internally and the bridge using subdev pad ops which is
> not MC aware forces to select MEDIA_CONTROLLER, as
> VIDEO_V4L2_SUBDEV_API is dependent on it.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>   include/media/v4l2-subdev.h | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 5860292..076ca11 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -642,7 +642,6 @@ struct v4l2_subdev_fh {
>   #define to_v4l2_subdev_fh(fh)	\
>   	container_of(fh, struct v4l2_subdev_fh, vfh)
>
> -#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)

Wouldn't you need to drop these from struct v4l2_subdev_fh as well? The 
code won't compile if the fields aren't there.

>   #define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
>   	static inline struct rtype *					\
>   	v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,	\
> @@ -656,7 +655,6 @@ struct v4l2_subdev_fh {
>   __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
>   __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_crop)
>   __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
> -#endif
>
>   extern const struct v4l2_file_operations v4l2_subdev_fops;
>
>

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
