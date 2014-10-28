Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaJ1RXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:23:06 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:58436 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaJ1RWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:22:47 -0400
Date: Tue, 28 Oct 2014 22:52:34 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] block: wrong return value
Message-ID: <20141028172234.GA12775@sudip-PC>
References: <1414082808-7484-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414082808-7484-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:16:48PM +0530, Sudip Mukherjee wrote:
> while compiling integer err was showing as a set but unused variable.
> elevator_init_fn can be either cfq_init_queue or deadline_init_queue
> or noop_init_queue.
> all three of these functions are returning -ENOMEM if they fail to
> allocate the queue.
> so we should actually be returning the error code rather than
> returning 0 always.
i have one doubt. shouldn't this patch be marked for stable also?

thanks
sudip
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> 
> change in v2: added elevator_put
> change in v3: remove unneeded initialization of err
> 
>  block/elevator.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/block/elevator.c b/block/elevator.c
> index 24c28b6..afa3b03 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -229,7 +229,9 @@ int elevator_init(struct request_queue *q, char *name)
>  	}
>  
>  	err = e->ops.elevator_init_fn(q, e);
> -	return 0;
> +	if (err)
> +		elevator_put(e);
> +	return err;
>  }
>  EXPORT_SYMBOL(elevator_init);
>  
> -- 
> 1.8.1.2
> 
