Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbbALN7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:59:07 -0500
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:36705 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbbALN7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:59:04 -0500
Message-ID: <54B3D319.2090506@xs4all.nl>
Date: Mon, 12 Jan 2015 14:58:49 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, m.chehab@samsung.com,
        hans.verkuil@cisco.com, dheitmueller@kernellabs.com,
        prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, ttmesterr@gmail.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] media: au0828 change to not zero out fmt.pix.priv
References: <cover.1418918401.git.shuahkh@osg.samsung.com> <54b748fa5cb6883d6ce348c38328161409c1f1be.1418918402.git.shuahkh@osg.samsung.com>
In-Reply-To: <54b748fa5cb6883d6ce348c38328161409c1f1be.1418918402.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My first code review of the new year, so let's start with a simple one to avoid
taxing my brain cells (that are still in vacation mode) too much...

On 12/18/2014 05:20 PM, Shuah Khan wrote:
> There is no need to zero out fmt.pix.priv in vidioc_g_fmt_vid_cap()
> vidioc_try_fmt_vid_cap(), and vidioc_s_fmt_vid_cap(). Remove it.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Happy New Year!

	Hans

> ---
>  drivers/media/usb/au0828/au0828-video.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 3011ca8..ef49b2e 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1104,7 +1104,6 @@ static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
>  	format->fmt.pix.sizeimage = width * height * 2;
>  	format->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>  	format->fmt.pix.field = V4L2_FIELD_INTERLACED;
> -	format->fmt.pix.priv = 0;
>  
>  	if (cmd == VIDIOC_TRY_FMT)
>  		return 0;
> @@ -1189,7 +1188,6 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>  	f->fmt.pix.sizeimage = dev->frame_size;
>  	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M; /* NTSC/PAL */
>  	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> -	f->fmt.pix.priv = 0;
>  	return 0;
>  }
>  
> 

