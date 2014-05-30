Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbaE3Oyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:54:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:30766 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaE3Oys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:54:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548951716"
Date: Fri, 30 May 2014 10:54:46 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>
Cc: keith.busch@intel.com, sbradshaw@micron.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4] NVMe: basic conversion to blk-mq
Message-ID: <20140530145446.GC5499@linux.intel.com>
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
> @@ -816,9 +671,7 @@ static irqreturn_t nvme_irq(int irq, void *data)
>  	irqreturn_t result;
>  	struct nvme_queue *nvmeq = data;
>  	spin_lock(&nvmeq->q_lock);
> -	nvme_process_cq(nvmeq);
> -	result = nvmeq->cqe_seen ? IRQ_HANDLED : IRQ_NONE;
> -	nvmeq->cqe_seen = 0;
> +	result = nvme_process_cq(nvmeq) ? IRQ_HANDLED : IRQ_NONE;
>  	spin_unlock(&nvmeq->q_lock);
>  	return result;
>  }

Put cqe_seen back.  I already told Sam this was wrong.
http://lists.infradead.org/pipermail/linux-nvme/2014-May/000856.html
