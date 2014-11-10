Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaKJLJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:09:30 -0500
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48390 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbaKJLJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:09:28 -0500
Message-ID: <54609CDF.8030303@xs4all.nl>
Date: Mon, 10 Nov 2014 12:09:19 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v5 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT definitions
 inside the kernel
References: <1415369269-5064-1-git-send-email-boris.brezillon@free-electrons.com> <1415461632-31236-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1415461632-31236-1-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2014 04:47 PM, Boris Brezillon wrote:
> Place v4l2_mbus_pixelcode in a #ifndef __KERNEL__ section so that kernel
> users don't have access to these definitions.
> 
> We have to keep this definition for user-space users even though they're
> encouraged to move to the new media_bus_format enum.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/uapi/linux/v4l2-mediabus.h | 45 ++++++++++++++++++++++++--------------
>  1 file changed, 28 insertions(+), 17 deletions(-)
> 
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index d712df8..5c9410d 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -15,6 +15,33 @@
>  #include <linux/types.h>
>  #include <linux/videodev2.h>
>  
> +/**
> + * struct v4l2_mbus_framefmt - frame format on the media bus
> + * @width:	frame width
> + * @height:	frame height
> + * @code:	data format code (from enum v4l2_mbus_pixelcode)
> + * @field:	used interlacing type (from enum v4l2_field)
> + * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> + */
> +struct v4l2_mbus_framefmt {
> +	__u32			width;
> +	__u32			height;
> +	__u32			code;
> +	__u32			field;
> +	__u32			colorspace;
> +	__u32			reserved[7];
> +};
> +
> +#ifndef __KERNEL__
> +/*
> + * enum v4l2_mbus_pixelcode and its definitions are now deprecated, and
> + * MEDIA_BUS_FMT_ definitions (defined in media-bus-format.h) should be
> + * used instead.
> + *
> + * New defines should only be added to media-bus-format.h. The
> + * v4l2_mbus_pixelcode enum is frozen.
> + */
> +
>  #define V4L2_MBUS_FROM_MEDIA_BUS_FMT(name)	\
>  	MEDIA_BUS_FMT_ ## name = V4L2_MBUS_FMT_ ## name

Shouldn't this be the other way around?

  	V4L2_MBUS_FMT_ ## name = MEDIA_BUS_FMT_ ## name

Regards,

	Hans

>  
> @@ -102,22 +129,6 @@ enum v4l2_mbus_pixelcode {
>  
>  	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
>  };
> -
> -/**
> - * struct v4l2_mbus_framefmt - frame format on the media bus
> - * @width:	frame width
> - * @height:	frame height
> - * @code:	data format code (from enum v4l2_mbus_pixelcode)
> - * @field:	used interlacing type (from enum v4l2_field)
> - * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> - */
> -struct v4l2_mbus_framefmt {
> -	__u32			width;
> -	__u32			height;
> -	__u32			code;
> -	__u32			field;
> -	__u32			colorspace;
> -	__u32			reserved[7];
> -};
> +#endif /* __KERNEL__ */
>  
>  #endif
> 

