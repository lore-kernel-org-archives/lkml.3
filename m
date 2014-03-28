Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaC1Ivv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:51:51 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4429 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaC1Ivq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:51:46 -0400
Message-ID: <5335380F.9070809@xs4all.nl>
Date: Fri, 28 Mar 2014 09:51:27 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: Re: [PATCH 2/2] usb: gadget: uvc: Set the vb2 queue timestamp flags
References: <20140323001018.GA11963@localhost> <1395588754-20587-1-git-send-email-laurent.pinchart@ideasonboard.com> <1395588754-20587-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1395588754-20587-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2014 04:32 PM, Laurent Pinchart wrote:
> The vb2 queue timestamp_flags field must be set by drivers, as enforced
> by a WARN_ON in vb2_queue_init. The UVC gadget driver failed to do so.
> This resulted in the following warning.
> 
> [    2.104371] g_webcam gadget: uvc_function_bind
> [    2.105567] ------------[ cut here ]------------
> [    2.105567] ------------[ cut here ]------------
> [    2.106779] WARNING: CPU: 0 PID: 1 at drivers/media/v4l2-core/videobuf2-core.c:2207 vb2_queue_init+0xa3/0x113()
> 
> Fix it.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/usb/gadget/uvc_queue.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
> index d4561ba..4611e9c 100644
> --- a/drivers/usb/gadget/uvc_queue.c
> +++ b/drivers/usb/gadget/uvc_queue.c
> @@ -136,6 +136,8 @@ static int uvc_queue_init(struct uvc_video_queue *queue,
>  	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
>  	queue->queue.ops = &uvc_queue_qops;
>  	queue->queue.mem_ops = &vb2_vmalloc_memops;
> +	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> +				     | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
>  	ret = vb2_queue_init(&queue->queue);
>  	if (ret)
>  		return ret;
> 

