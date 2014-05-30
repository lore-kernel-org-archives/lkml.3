Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbaE3PA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:00:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:18271 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbaE3PAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:00:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="439033233"
Date: Fri, 30 May 2014 11:00:50 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>
Cc: keith.busch@intel.com, sbradshaw@micron.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4] NVMe: basic conversion to blk-mq
Message-ID: <20140530150050.GD5499@linux.intel.com>
References: <1401400285-25003-1-git-send-email-m@bjorling.me>
 <1401400285-25003-2-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401400285-25003-2-git-send-email-m@bjorling.me>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:51:25PM +0200, Matias Bjørling wrote:
> -static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
> -		struct bio *bio, enum dma_data_direction dma_dir, int psegs)
> +static int nvme_map_rq(struct nvme_queue *nvmeq, struct nvme_iod *iod,
> +		struct request *req, enum dma_data_direction dma_dir,
> +		int psegs)
>  {
> -	struct bio_vec bvec, bvprv;
> -	struct bvec_iter iter;
> -	struct scatterlist *sg = NULL;
> -	int length = 0, nsegs = 0, split_len = bio->bi_iter.bi_size;
> -	int first = 1;
> -
> -	if (nvmeq->dev->stripe_size)
> -		split_len = nvmeq->dev->stripe_size -
> -			((bio->bi_iter.bi_sector << 9) &
> -			 (nvmeq->dev->stripe_size - 1));

You take out stripe_size here, but don't appear to put it back in
anywhere else.
