Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934398AbaE3Q6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:58:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:59410 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083AbaE3Q63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:58:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,942,1392192000"; 
   d="scan'208";a="520323499"
Date: Fri, 30 May 2014 12:58:27 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>
Cc: keith.busch@intel.com, sbradshaw@micron.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4] NVMe: basic conversion to blk-mq
Message-ID: <20140530165827.GE5499@linux.intel.com>
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
> +static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +			  unsigned int i)
>  {
> +	struct nvme_dev *dev = data;
> +	struct nvme_queue *nvmeq = dev->queues[(i % dev->queue_count) + 1];
> +	BUG_ON(!nvmeq);
> +	WARN_ON(nvmeq->hctx);
> +	nvmeq->hctx = hctx;
> +	hctx->driver_data = nvmeq;
> +	return 0;
> +}

You can't call this parameter 'i'.  See Documentation/CodingStyle chapter 4.
