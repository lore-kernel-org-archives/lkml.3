Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaIXRd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:33:57 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:64906 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaIXRd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:33:56 -0400
Date: Wed, 24 Sep 2014 13:33:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH block/for-3.18/core] blk-mq: start q->mq_usage_counter in
 atomic mode
Message-ID: <20140924173352.GC29067@mtj.dyndns.org>
References: <20140919113815.GA10791@lst.de>
 <20140923060812.GH11740@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923060812.GH11740@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:08:12AM -0400, Tejun Heo wrote:
> From 83b06f4fc6ca2f7f3d706a168b71c248bdada668 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 23 Sep 2014 01:58:34 -0400
> 
> blk-mq uses percpu_ref for its usage counter which tracks the number
> of in-flight commands and used to synchronously drain the queue on
> freeze.  percpu_ref shutdown takes measureable wallclock time as it
> involves a sched RCU grace period.  This means that draining a blk-mq
> takes measureable wallclock time.  One would think that this shouldn't
> matter as queue shutdown should be a rare event which takes place
> asynchronously w.r.t. userland.

Applied to percpu/for-3.18 on top of the klude, its revert and the
required percpu_ref changes.

Thanks.

-- 
tejun
