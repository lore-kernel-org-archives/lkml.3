Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaIVOI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:08:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47422 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaIVOIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:08:24 -0400
Message-ID: <54202D53.4090202@kernel.dk>
Date: Mon, 22 Sep 2014 08:08:19 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] block: fix blk_abort_request on blk-mq
References: <1411394371-16254-1-git-send-email-hch@lst.de> <1411394371-16254-2-git-send-email-hch@lst.de>
In-Reply-To: <1411394371-16254-2-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-22 07:59, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-mq.c      | 2 +-
>   block/blk-timeout.c | 5 ++++-
>   block/blk.h         | 2 ++
>   3 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk.h b/block/blk.h
> index e515a28..159e973 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -250,4 +250,6 @@ static inline int blk_throtl_init(struct request_queue *q) { return 0; }
>   static inline void blk_throtl_exit(struct request_queue *q) { }
>   #endif /* CONFIG_BLK_DEV_THROTTLING */
>
> +extern void blk_mq_rq_timed_out(struct request *req, bool reserved);

Moving this to blk-mq.h.

Applied.

-- 
Jens Axboe

