Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaDQTDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:03:44 -0400
Received: from plane.gmane.org ([80.91.229.3]:33145 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaDQTDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:03:38 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [PATCH next 3/4] blk-mq: user (1 << order) to implement order_to_size()
Date: Thu, 17 Apr 2014 21:03:22 +0200
Message-ID: <5350257A.30107@web.de>
References: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com> <1397749778-14485-4-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Christoph Hellwig <hch@lst.de>
X-Gmane-NNTP-Posting-Host: p5b3799cc.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
In-Reply-To: <1397749778-14485-4-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei wrote, on 04/17/2014 17:49:
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  block/blk-mq.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index baff2d0..1eff3d9 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1130,12 +1130,7 @@ static void blk_mq_free_rq_map(struct blk_mq_tag_set *set,
>  
>  static size_t order_to_size(unsigned int order)
>  {
> -	size_t ret = PAGE_SIZE;
> -
> -	while (order--)
> -		ret *= 2;
> -
> -	return ret;
> +	return (1 << order) * PAGE_SIZE;

Shouldn't this be

        return ((size_t)1 << order) * PAGE_SIZE;

?
>  }
>  
>  static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
> 

Regards,
jvp.


