Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbbAVKcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:32:22 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46914 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbbAVKcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:32:11 -0500
MIME-Version: 1.0
In-Reply-To: <54b748fa5cb6883d6ce348c38328161409c1f1be.1418918402.git.shuahkh@osg.samsung.com>
References: <cover.1418918401.git.shuahkh@osg.samsung.com> <54b748fa5cb6883d6ce348c38328161409c1f1be.1418918402.git.shuahkh@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 22 Jan 2015 10:31:39 +0000
Message-ID: <CA+V-a8tHsdZo3J3uNbubKjgfpL6AOpCOotpVRkzHjqfjxpUogg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] media: au0828 change to not zero out fmt.pix.priv
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        laurent pinchart <laurent.pinchart@ideasonboard.com>,
        ttmesterr@gmail.com, linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

Thanks for the patch.

On Thu, Dec 18, 2014 at 4:20 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> There is no need to zero out fmt.pix.priv in vidioc_g_fmt_vid_cap()
> vidioc_try_fmt_vid_cap(), and vidioc_s_fmt_vid_cap(). Remove it.
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/media/usb/au0828/au0828-video.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 3011ca8..ef49b2e 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1104,7 +1104,6 @@ static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
>         format->fmt.pix.sizeimage = width * height * 2;
>         format->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>         format->fmt.pix.field = V4L2_FIELD_INTERLACED;
> -       format->fmt.pix.priv = 0;
>
>         if (cmd == VIDIOC_TRY_FMT)
>                 return 0;
> @@ -1189,7 +1188,6 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>         f->fmt.pix.sizeimage = dev->frame_size;
>         f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M; /* NTSC/PAL */
>         f->fmt.pix.field = V4L2_FIELD_INTERLACED;
> -       f->fmt.pix.priv = 0;
>         return 0;
>  }
>
> --
> 2.1.0
>
