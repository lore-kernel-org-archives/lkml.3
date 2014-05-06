Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaEFQi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:38:27 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:44859 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaEFQiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:38:25 -0400
Date: Tue, 6 May 2014 12:38:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] workqueue: convert worker_idr to worker_ida
Message-ID: <20140506163822.GG27738@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-7-git-send-email-laijs@cn.fujitsu.com>
 <20140505145912.GG11231@htj.dyndns.org>
 <CACvQF50=qe2p06iR1kLv6jU2K2VJQR4Tux0nXM1=MArZabWs4A@mail.gmail.com>
 <20140506163524.GF27738@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506163524.GF27738@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 06, 2014 at 12:35:24PM -0400, Tejun Heo wrote:
> On Wed, May 07, 2014 at 12:33:34AM +0800, Lai Jiangshan wrote:
> > On Mon, May 5, 2014 at 10:59 PM, Tejun Heo <tj@kernel.org> wrote:
> > > On Sun, Apr 27, 2014 at 12:09:01PM +0800, Lai Jiangshan wrote:
> > >> @@ -2224,6 +2220,9 @@ woke_up:
> > >>               spin_unlock_irq(&pool->lock);
> > >>               WARN_ON_ONCE(!list_empty(&worker->entry));
> > >>               worker->task->flags &= ~PF_WQ_WORKER;
> > >> +
> > >> +             set_task_comm(worker->task, "kworker_die");
> > >> +             ida_simple_remove(&pool->worker_ida, worker->id);
> > >>               worker_unbind_pool(worker);
> > >>               kfree(worker);
> > >>               return 0;
> > >
> > > Does this chunk belong to this patch?  Why no description about this
> > > change?
> > 
> > "set_task_comm()" doesn't belong to this patch. it avoids two workers
> > have the same name.(one is dying, the other one is newly created"
> 
> Separate out this to a separate patch?  A better name would be
> "kworker_dying".  Does this matter tho?

On the second thought, before these patches, we only freed ID after
the task exited, right?  Hmm... yeah, it can be confusing for
debugging.  Can you please do the above in the patch which moves IDR
freeing to the worker itself and explain accordingly?

Thanks.

-- 
tejun
