Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037AbaDIQ0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:26:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31979 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933889AbaDIQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:23:35 -0400
Message-ID: <53457404.5070800@fb.com>
Date: Wed, 9 Apr 2014 10:23:32 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Matias Bjorling <m@bjorling.me>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3/4] blk-mq: move request structures into struct blk_mq_tags
References: <1396277175-21382-1-git-send-email-hch@lst.de> <1396277175-21382-4-git-send-email-hch@lst.de>
In-Reply-To: <1396277175-21382-4-git-send-email-hch@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-09_03:2014-04-09,2014-04-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=2 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404090118
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 08:46 AM, Christoph Hellwig wrote:
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index 238379a..eca3a47 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -1,6 +1,24 @@
>   #ifndef INT_BLK_MQ_H
>   #define INT_BLK_MQ_H
>
> +#include <linux/percpu_ida.h>
> +
> +/*
> + * Tag address space map.
> + */
> +struct blk_mq_tags {
> +	unsigned int nr_tags;
> +	unsigned int nr_reserved_tags;
> +	unsigned int nr_batch_move;
> +	unsigned int nr_max_cache;
> +
> +	struct percpu_ida free_tags;
> +	struct percpu_ida reserved_tags;
> +
> +	struct request **rqs;
> +	struct list_head page_list;
> +};
> +

This should go into block/blk-mq-tag.h.


> -static inline struct request *blk_mq_tag_to_rq(struct blk_mq_hw_ctx *hctx,
> -					       unsigned int tag)
> -{
> -	return hctx->rqs[tag];
> -}

We might as well leave this, the mtip32xx conversion ends up using it. 
So if we pull it now, it'll just be reintroduced shortly.

-- 
Jens Axboe

