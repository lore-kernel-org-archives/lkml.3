Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaFDSwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:52:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:13188 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaFDSwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:52:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,974,1392192000"; 
   d="scan'208";a="440919132"
Date: Wed, 4 Jun 2014 12:52:20 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Jens Axboe <axboe@kernel.dk>
cc: Keith Busch <keith.busch@intel.com>,
        =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        willy@linux.intel.com, sbradshaw@micron.com,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        hch@infradead.org
Subject: Re: [PATCH v5] conversion to blk-mq
In-Reply-To: <538F68A9.50608@kernel.dk>
Message-ID: <alpine.LRH.2.03.1406041246300.11244@AMR>
References: <1401742510-10827-1-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406021642480.11244@AMR> <alpine.LRH.2.03.1406021702530.11244@AMR> <538E2C2E.1010500@bjorling.me> <alpine.LRH.2.03.1406031553280.11244@AMR> <alpine.LRH.2.03.1406031625120.11244@AMR>
 <538EE3E6.60408@bjorling.me> <alpine.LRH.2.03.1406041146280.11244@AMR> <538F68A9.50608@kernel.dk>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Jens Axboe wrote:
> On 06/04/2014 12:28 PM, Keith Busch wrote:
> Are you testing against 3.13? You really need the current tree for this,
> otherwise I'm sure you'll run into issues (as you appear to be :-)

I'm using Matias' current tree:

git://github.com/MatiasBjorling/linux-collab nvmeq_wip_6

Is this the right one to use? Looks like a 3.15rc1+.

Also ... obviously that's the wrong diff from before. I didn't save my
file before creating the diff. Should have looked like this:

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d10013b..d1b986c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -105,7 +105,8 @@ static int blk_mq_queue_enter(struct request_queue *q)
  	__percpu_counter_add(&q->mq_usage_counter, 1, 1000000);
  	smp_wmb();
  	/* we have problems to freeze the queue if it's initializing */
-	if (!blk_queue_bypass(q) || !blk_queue_init_done(q))
+	if (!blk_queue_dying(q) && (!blk_queue_bypass(q) ||
+					!blk_queue_init_done(q)))
  		return 0;

  	__percpu_counter_add(&q->mq_usage_counter, -1, 1000000);
