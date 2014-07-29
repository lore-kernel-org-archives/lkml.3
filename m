Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaG2CQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:16:49 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:52114 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaG2CQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:16:47 -0400
Date: Mon, 28 Jul 2014 22:16:43 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueue: use dedicated creater kthread for all
 pools
Message-ID: <20140729021643.GA22241@mtj.dyndns.org>
References: <1406343900-32423-1-git-send-email-laijs@cn.fujitsu.com>
 <1406343900-32423-3-git-send-email-laijs@cn.fujitsu.com>
 <20140728185536.GG7462@htj.dyndns.org>
 <53D6F84B.6000000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D6F84B.6000000@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 29, 2014 at 09:26:35AM +0800, Lai Jiangshan wrote:
> > It's a bit difficult to get excited about this patchset given that
> > this is mostly churn without many actual benefits.  Sure, it
> > consolidates one-per-pool managers into one kthread_worker but it was
> > one-per-pool already.  That said, I don't hate it and it may be
> > considered an improvement.  I don't know.
> 
> It prefers to processing works rather than creating worker without any
> loss of the guarantee.
> 
> processing works makes directly progress for the system.
> creating worker makes delay and indirectly progress.

That's misleading, isn't it?  Both process work items the same.  The
only difference is per-pool manager ends up using more tasks, thus a
bit more memory, doing it.  There really is no signficant behavior
difference between the two schemes except for how many tasks end up
serving as the manager.

> > This is kinda silly when the duty of worker creation is served by an
> > external entity.  Why would a pool need any idle worker?
> 
> The idle worker must be ready or being prepared for wq_worker_sleeping()
> or chained-wake-up.
> 
> percpu-kthreadd can serve for wq_worker_sleeping() in this case, but it is
> not a good idle to introduce percpu-kthreadd now since no other user.

Hmmm... I'm not really sure what we're getting with this.  It doesn't
look much simpler to me.  :(

Lai, I don't know.  If this ends up simplifying things significantly,
sure, but as it currently stands, I can't see why we'd need to do
this.  If you wanna pursue this, please try to make it more
beneficial.

Thanks.

-- 
tejun
