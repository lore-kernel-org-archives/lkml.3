Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab3GZNZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:25:24 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4461 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab3GZNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:25:22 -0400
Message-ID: <51F278B1.2060609@xs4all.nl>
Date: Fri, 26 Jul 2013 15:25:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Alban Browaeys <alban.browaeys@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Subject: Re: [PATCH 4/4] [media] em28xx: Fix vidioc fmt vid cap v4l2 compliance
References: <1374016006-27678-1-git-send-email-prahal@yahoo.com>
In-Reply-To: <1374016006-27678-1-git-send-email-prahal@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change to g_fmt_vid_cap isn't necessary as that's automatically cleared.
Only the s_fmt_vid_cap change is needed. I'll drop the first chunk and accept the
second.

Thanks,

	Hans

On 07/17/2013 01:06 AM, Alban Browaeys wrote:
> Set fmt.pix.priv to zero in vidioc_g_fmt_vid_cap
>  and vidioc_try_fmt_vid_cap.
> 
> Catched by v4l2-compliance.
> 
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 1a577ed..42930a4 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -943,6 +943,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>  	else
>  		f->fmt.pix.field = dev->interlaced ?
>  			   V4L2_FIELD_INTERLACED : V4L2_FIELD_TOP;
> +	f->fmt.pix.priv = 0;
> +
>  	return 0;
>  }
>  
> @@ -1008,6 +1010,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  	else
>  		f->fmt.pix.field = dev->interlaced ?
>  			   V4L2_FIELD_INTERLACED : V4L2_FIELD_TOP;
> +	f->fmt.pix.priv = 0;
>  
>  	return 0;
>  }
> 
