Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbaEGNQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:16:55 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:37035 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933450AbaEGNP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:15:27 -0400
Date: Wed, 7 May 2014 09:15:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/10] workqueue: async worker destruction
Message-ID: <20140507131523.GC16702@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-4-git-send-email-laijs@cn.fujitsu.com>
 <5369E11F.5010909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5369E11F.5010909@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 03:30:39PM +0800, Lai Jiangshan wrote:
> On 04/27/2014 12:08 PM, Lai Jiangshan wrote:
> 
> >  
> >  	spin_unlock_irq(&pool->lock);
> > +
> > +	wait_event_cmd(pool->workers_unbound,
> > +		       idr_is_empty(&pool->worker_idr),
> > +		       mutex_unlock(&pool->manager_mutex),
> > +		       mutex_lock(&pool->manager_mutex));
> > +
> 
> 
> How about I wrap it as wait_event_mutex()?
> (like wait_event_lock_irq() in kernel and pthread_cond_wait() in userspace)

waitq tends to be trickier to get right.  Can you please give
completion a shot?  completion is pretty convenient for (its only
purpose after all) this sort of one-shot synchronizations.

-- 
tejun
