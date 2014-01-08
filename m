Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbaAHJZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:25:56 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9422 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbaAHJZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:25:53 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-f7-52cd199f3a01
Message-id: <52CD199E.9010001@samsung.com>
Date: Wed, 08 Jan 2014 10:25:50 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "open list:VIDEOBUF2 FRAMEWORK" <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] vb2: Check if there are buffers before streamon
References: <1389168093-4923-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1389168093-4923-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/xa7rzJc8GGcz6KGBxavIzJouzTW/Y
	LS7vmsNm0bNhK6vFxXXyFlPe/mS36Oqex+TA7rFz1l12j8e/XrJ59G1ZxejxeZOcx6mvn9kD
	WKO4bFJSczLLUov07RK4Mi5+mcBS8J2rYlLrd/YGxqccXYwcHBICJhL7zgp3MXICmWISF+6t
	Z+ti5OIQEljKKNF87AMjhPOJUWLazb9sIFW8AloSC29cYQSxWQRUJS5cmw4WZxMwlOh62wVm
	iwqESuz5eJoRol5Q4sfkeywgg0QEjjNJfF/+kQUkISzgLnH98wawBiEBD4mVy/6xgticAp4S
	7/6cAathFjCTeNSyjhnClpfYvOYt8wRG/llI5s5CUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5
	xaV56XrJ+bmbGCHB/GUH4+JjVocYBTgYlXh4b6idCRJiTSwrrsw9xCjBwawkwishejZIiDcl
	sbIqtSg/vqg0J7X4ECMTB6dUA2PxwYRuN5vCyaU25RtMrx7NVmHtZS89vmp+7+TYSfJX3Zf3
	1Tvcn950lCOgovjdnxDDT0tNwk/eLmdavvx5+Cv7uCjBTfXv31t/qJo9Yde5FN4VRXxSjT8F
	WXvdxR+Jnrx22r2m4V37ifv3Y7rXnI9wvrl1ozvzka9eVk0Hc8Ttlkj9dGire6zEUpyRaKjF
	XFScCAATo8diRAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-01-08 09:01, Ricardo Ribalda Delgado wrote:
> This patch adds a test preventing streamon() if there is no buffer
> ready.
>
> Without this patch, a user could call streamon() before
> preparing any buffer. This leads to a situation where if he calls
> close() before calling streamoff() the device is kept streaming.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
> v2: Comment by Marek Szyprowski:
> Reword error message
>
> v3: Comment by Marek Szyprowski:
> Actualy do the reword :)
>
>   drivers/media/v4l2-core/videobuf2-core.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 098df28..6409e0a 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1776,6 +1776,11 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>   		return 0;
>   	}
>   
> +	if (!q->num_buffers) {
> +		dprintk(1, "streamon: no buffers have been allocated\n");
> +		return -EINVAL;
> +	}
> +
>   	/*
>   	 * If any buffers were queued before streamon,
>   	 * we can now pass them to driver for processing.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

