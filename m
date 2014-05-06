Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaEFQfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:35:31 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52962 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaEFQf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:35:27 -0400
Date: Tue, 6 May 2014 12:35:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] workqueue: convert worker_idr to worker_ida
Message-ID: <20140506163524.GF27738@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-7-git-send-email-laijs@cn.fujitsu.com>
 <20140505145912.GG11231@htj.dyndns.org>
 <CACvQF50=qe2p06iR1kLv6jU2K2VJQR4Tux0nXM1=MArZabWs4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF50=qe2p06iR1kLv6jU2K2VJQR4Tux0nXM1=MArZabWs4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 12:33:34AM +0800, Lai Jiangshan wrote:
> On Mon, May 5, 2014 at 10:59 PM, Tejun Heo <tj@kernel.org> wrote:
> > On Sun, Apr 27, 2014 at 12:09:01PM +0800, Lai Jiangshan wrote:
> >> @@ -2224,6 +2220,9 @@ woke_up:
> >>               spin_unlock_irq(&pool->lock);
> >>               WARN_ON_ONCE(!list_empty(&worker->entry));
> >>               worker->task->flags &= ~PF_WQ_WORKER;
> >> +
> >> +             set_task_comm(worker->task, "kworker_die");
> >> +             ida_simple_remove(&pool->worker_ida, worker->id);
> >>               worker_unbind_pool(worker);
> >>               kfree(worker);
> >>               return 0;
> >
> > Does this chunk belong to this patch?  Why no description about this
> > change?
> 
> "set_task_comm()" doesn't belong to this patch. it avoids two workers
> have the same name.(one is dying, the other one is newly created"

Separate out this to a separate patch?  A better name would be
"kworker_dying".  Does this matter tho?

Thanks.

-- 
tejun
