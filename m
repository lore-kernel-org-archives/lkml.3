Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaEAPRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:17:35 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44469 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaEAPRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:17:33 -0400
Message-ID: <53626583.5030604@kernel.dk>
Date: Thu, 01 May 2014 09:17:23 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
CC: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block: null_blk: fix use after free
References: <1398928356-24390-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1398928356-24390-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 01:12 AM, Ming Lei wrote:
> entry(cmd->ll_list) may belong to new request once end_cmd()
> returns, so fix the bug with the patch.
> 
> Without the change, it is easy to observe oops when
> doing null_blk(timer) test.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/block/null_blk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
> index 8e7e3a0..e932398 100644
> --- a/drivers/block/null_blk.c
> +++ b/drivers/block/null_blk.c
> @@ -203,8 +203,8 @@ static enum hrtimer_restart null_cmd_timer_expired(struct hrtimer *timer)
>  		entry = llist_reverse_order(entry);
>  		do {
>  			cmd = container_of(entry, struct nullb_cmd, ll_list);
> -			end_cmd(cmd);
>  			entry = entry->next;
> +			end_cmd(cmd);
>  		} while (entry);
>  	}

Good catch, applied.

-- 
Jens Axboe

