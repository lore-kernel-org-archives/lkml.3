Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaDPQl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:41:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37938 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaDPQlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:41:23 -0400
Message-ID: <534EB2BA.7020705@kernel.dk>
Date: Wed, 16 Apr 2014 10:41:30 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/8] blk-mq: bidi support
References: <1397634299-7466-1-git-send-email-hch@lst.de> <1397634299-7466-3-git-send-email-hch@lst.de>
In-Reply-To: <1397634299-7466-3-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 01:44 AM, Christoph Hellwig wrote:
> diff --git a/block/bsg.c b/block/bsg.c
> index 420a5a9..2956086 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -1008,7 +1008,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
>  	/*
>  	 * we need a proper transport to send commands, not a stacked device
>  	 */
> -	if (!q->request_fn)
> +	if (!q->request_fn && !q->mq_ops)
>  		return 0;
>  
>  	bcd = &q->bsg_dev;

This looks misplaced. But I dropped the one I generated last week, I'll
queue it up separately in the drivers branch.

-- 
Jens Axboe

