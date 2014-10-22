Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbaJVL0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:26:47 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3324 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbaJVL0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:26:45 -0400
Message-ID: <5447946B.9020007@xs4all.nl>
Date: Wed, 22 Oct 2014 13:26:35 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH 10/15] media: davinci: vpbe: add support for VIDIOC_CREATE_BUFS
References: <1413146445-7304-1-git-send-email-prabhakar.csengg@gmail.com> <1413146445-7304-11-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1413146445-7304-11-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

This patch series looks good, except for this one.

If you add create_bufs support, then you should also update queue_setup.

If the fmt argument to queue_setup is non-NULL, then check that the
fmt.pix.sizeimage field is >= the current format's sizeimage. If not,
return -EINVAL.

This prevents userspace from creating additional buffers that are smaller than
the minimum required size.

I'm just skipping this patch and queuing all the others for 3.19. Just post an
updated version for this one and I'll pick it up later.

Regards,

	Hans

On 10/12/2014 10:40 PM, Lad, Prabhakar wrote:
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>   drivers/media/platform/davinci/vpbe_display.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index c33b77e..fd8d4f0 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -1260,6 +1260,7 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
>   	.vidioc_dqbuf		 = vb2_ioctl_dqbuf,
>   	.vidioc_streamon	 = vb2_ioctl_streamon,
>   	.vidioc_streamoff	 = vb2_ioctl_streamoff,
> +	.vidioc_create_bufs	 = vb2_ioctl_create_bufs,
>
>   	.vidioc_cropcap		 = vpbe_display_cropcap,
>   	.vidioc_g_crop		 = vpbe_display_g_crop,
>
