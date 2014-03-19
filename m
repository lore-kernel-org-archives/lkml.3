Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaCSFWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 01:22:10 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:55666 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaCSFWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 01:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140317131941.477238509@bombadil.infradead.org>
References: <20140317131827.793657833@bombadil.infradead.org>
	<20140317131941.477238509@bombadil.infradead.org>
Date: Wed, 19 Mar 2014 13:22:07 +0800
Message-ID: <CACVXFVNx=s1na1o7cPgjqL2rMcT73gVjmUOYyZdzE3KQ+MZH9Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] blk-mq: add a exit_request method
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 9:18 PM, Christoph Hellwig <hch@infradead.org> wrote:
> This gives drivers an easy way to free any resources allocated in
> ->init_request.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index c2ce99b..c7e723e 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1000,6 +1000,16 @@ static void blk_mq_free_rq_map(struct blk_mq_hw_ctx *hctx)
>  {
>         struct page *page;
>
> +       if (hctx->rqs && hctx->queue->mq_ops->exit_request) {

exit_request definition is missed.


Thanks,
-- 
Ming Lei
