Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaKCSPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:15:20 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:17998 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaKCSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:15:12 -0500
X-AuditID: cbfec373-b7f236d000000948-e9-5457c62eddb4
Date: Mon, 03 Nov 2014 16:15:04 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>, linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] video: add RGB444_1X12 and RGB565_1X16 bus formats
Message-id: <20141103161504.582921ac.m.chehab@samsung.com>
In-reply-to: <1411999363-28770-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
 <1411999363-28770-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/hEF29Y+EhBqu2a1r0njvJZHHgxUIW
	iytf37NZvN84j8ni8q45bBY9G7ayWvzcNY/Fgd3jyaaLjB47Z91l9/jwMc5j+7cHrB73u48z
	eXzeJBfAFsVlk5Kak1mWWqRvl8CV8ef4a9aCJoGKS6+3MDcwbuXtYuTgkBAwkbj2IqaLkRPI
	FJO4cG89WxcjF4eQwBJGiYXrzjKCJIQEGpkkvjS5g9gsAqoSSw/1gsXZBIwkXjW2sILYIgIW
	Eh0Pj7KB2MwCdxkl/u5IAbGFBfwkmia8ZgPZxStgJfF7Qh1ImFMgVGLStJvMELvmMkosnreM
	DeIeZ4n5n7NBangFBCV+TL7HAjFSS2LztiZWCFteYvOat8wTGAVmISmbhaRsFpKyBYzMqxhF
	S4uTC4qT0nON9IoTc4tL89L1kvNzNzFCAr14B+OLDVaHGAU4GJV4eAu2h4UIsSaWFVfmHmKU
	4GBWEuGdvzo8RIg3JbGyKrUoP76oNCe1+BAjEwenVANjdkxWlOtSgR2T+xb/tf+lcXBhoa2d
	h2BNbIl9X7LrkrgpAinc7Hf6ZAUeyCjmPVsyYbL73PrzVs3xRXef/1nulql9XKB8gvuBGl6b
	PW+ilNY+UnxwevrKB3EBT32kt34rdXl5VkDw+jTbzl1r10SUb6/086wzc/7N4udxRPLKrItf
	K1dG965UYinOSDTUYi4qTgQAdE7twlICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 29 Sep 2014 16:02:40 +0200
Boris Brezillon <boris.brezillon@free-electrons.com> escreveu:

> Add RGB444 format using a 12 bits bus and RGB565 using a 16 bits bus.
> 
> These formats will later be used by atmel-hlcdc driver.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Not sure if it is too late, but this patch were hidden somewere on my
queue... so:

Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

> ---
>  include/uapi/linux/v4l2-mediabus.h    | 2 ++
>  include/uapi/linux/video-bus-format.h | 4 +++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index 7b0a06c..05336d6 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -33,6 +33,8 @@ enum v4l2_mbus_pixelcode {
>  	VIDEO_BUS_TO_V4L2_MBUS(RGB888_2X12_BE),
>  	VIDEO_BUS_TO_V4L2_MBUS(RGB888_2X12_LE),
>  	VIDEO_BUS_TO_V4L2_MBUS(ARGB8888_1X32),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB444_1X12),
> +	VIDEO_BUS_TO_V4L2_MBUS(RGB565_1X16),
>  
>  	VIDEO_BUS_TO_V4L2_MBUS(Y8_1X8),
>  	VIDEO_BUS_TO_V4L2_MBUS(UV8_1X8),
> diff --git a/include/uapi/linux/video-bus-format.h b/include/uapi/linux/video-bus-format.h
> index 4abbd5d..f85f7ee 100644
> --- a/include/uapi/linux/video-bus-format.h
> +++ b/include/uapi/linux/video-bus-format.h
> @@ -34,7 +34,7 @@
>  enum video_bus_format {
>  	VIDEO_BUS_FMT_FIXED = 0x0001,
>  
> -	/* RGB - next is 0x100e */
> +	/* RGB - next is 0x1010 */
>  	VIDEO_BUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
>  	VIDEO_BUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
>  	VIDEO_BUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
> @@ -48,6 +48,8 @@ enum video_bus_format {
>  	VIDEO_BUS_FMT_RGB888_2X12_BE = 0x100b,
>  	VIDEO_BUS_FMT_RGB888_2X12_LE = 0x100c,
>  	VIDEO_BUS_FMT_ARGB8888_1X32 = 0x100d,
> +	VIDEO_BUS_FMT_RGB444_1X12 = 0x100e,
> +	VIDEO_BUS_FMT_RGB565_1X16 = 0x100f,
>  
>  	/* YUV (including grey) - next is 0x2024 */
>  	VIDEO_BUS_FMT_Y8_1X8 = 0x2001,
