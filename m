Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaHDFD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 01:03:27 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3803 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaHDFDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 01:03:25 -0400
Message-ID: <53DF1412.9010506@xs4all.nl>
Date: Mon, 04 Aug 2014 07:03:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, udovdh@xs4all.nl
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v4l2: Change call of function in videobuf2-core.c
References: <1407122751-30689-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1407122751-30689-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 05:25 AM, Nicholas Krause wrote:
> This patch changes the call of vb2_buffer_core to use VB2_BUFFER_STATE_ACTIVE
> inside the for instead of not setting in correctly to VB2_BUFFER_STATE_ERROR.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Dunno what's going on here after reading Dave Airlie's reply, but:

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

It's clearly wrong and if you get here at all you have a driver bug anyway. That
WARN_ON is there for a reason. Your driver isn't returning buffers correctly in
stop_streaming or in start_streaming if start_streaming fails with an error.

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7c4489c..08e478b 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2115,7 +2115,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
>  		for (i = 0; i < q->num_buffers; ++i)
>  			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
> -				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
> +				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ACTIVE);
>  		/* Must be zero now */
>  		WARN_ON(atomic_read(&q->owned_by_drv_count));
>  	}
> 

