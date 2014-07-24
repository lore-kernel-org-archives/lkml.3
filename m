Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbaGXP4C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:56:02 -0400
Received: from kanga.kvack.org ([205.233.56.17]:37797 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759499AbaGXPz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:55:59 -0400
Date: Thu, 24 Jul 2014 11:55:59 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, jmoyer@redhat.com,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 2/4] aio: use the macro rather than the inline magic number
Message-ID: <20140724155559.GC22390@kvack.org>
References: <1406109834-4414-1-git-send-email-guz.fnst@cn.fujitsu.com> <1406109834-4414-2-git-send-email-guz.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406109834-4414-2-git-send-email-guz.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 06:03:52PM +0800, Gu Zheng wrote:
> Replace the inline magic number with the ready-made macro(AIO_RING_MAGIC),
> just clean up.

Thanks Gu -- applied to my aio-next tree at   
git://git.kvack.org/~bcrl/aio-next.git .

		-ben

> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/aio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 94546ab..e0f838d 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -201,7 +201,7 @@ static struct dentry *aio_mount(struct file_system_type *fs_type,
>  	static const struct dentry_operations ops = {
>  		.d_dname	= simple_dname,
>  	};
> -	return mount_pseudo(fs_type, "aio:", NULL, &ops, 0xa10a10a1);
> +	return mount_pseudo(fs_type, "aio:", NULL, &ops, AIO_RING_MAGIC);
>  }
>  
>  /* aio_setup
> -- 
> 1.7.7

-- 
"Thought is the essence of where you are now."
