Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaIHIGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:06:36 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2844 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbaIHIGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:06:34 -0400
Message-ID: <540D636F.1030702@xs4all.nl>
Date: Mon, 08 Sep 2014 10:06:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 3/5] media: videobuf2-core.h: add a helper to get status
 of start_streaming()
References: <1410017211-15438-1-git-send-email-prabhakar.csengg@gmail.com> <1410017211-15438-4-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1410017211-15438-4-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2014 05:26 PM, Lad, Prabhakar wrote:
> this patch adds a helper to get the status if start_streaming()
> was called successfully.

Nice! I've had the same idea for quite some time now, but for some reason
I never got around to actually adding it.

	Hans

> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/media/videobuf2-core.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 5a10d8d..b3c9973 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -590,6 +590,15 @@ vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
>  	return 0;
>  }
>  
> +/**
> + * vb2_start_streaming_called() - return streaming status of driver
> + * @q:		videobuf queue
> + */
> +static inline bool vb2_start_streaming_called(struct vb2_queue *q)
> +{
> +	return q->start_streaming_called;
> +}
> +
>  /*
>   * The following functions are not part of the vb2 core API, but are simple
>   * helper functions that you can use in your struct v4l2_file_operations,
> 

