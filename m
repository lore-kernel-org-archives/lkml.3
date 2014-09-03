Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbaICUkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:40:13 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34210 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaICUkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:40:11 -0400
Message-ID: <54077CAE.203@kernel.dk>
Date: Wed, 03 Sep 2014 14:40:14 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] blk-mq: Eliminate superfluous check of BLK_MQ_S_TAG_ACTIVE
 flag
References: <cover.1409775956.git.agordeev@redhat.com> <871ad1488e7050fa53412b891bf3d0a46dea8bcd.1409775956.git.agordeev@redhat.com>
In-Reply-To: <871ad1488e7050fa53412b891bf3d0a46dea8bcd.1409775956.git.agordeev@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 02:33 PM, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-mq-tag.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 4953b64..d1eb579 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -60,8 +60,7 @@ static inline void bt_index_atomic_inc(atomic_t *index)
>   */
>  void __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>  {
> -	if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
> -	    !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> +	if (!test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
>  		atomic_inc(&hctx->tags->active_queues);

That's done on purpose as well, it's a lot faster to do the (non-atomic)
check first and only do the expensive test and set if needed.

See 7fcbbaf18392 for similar construct and actual numbers on a real case.

-- 
Jens Axboe

