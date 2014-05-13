Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbaEMOOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:14:23 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:58701 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbaEMOOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:14:22 -0400
Date: Tue, 13 May 2014 10:14:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10 V2] workqueue: async worker destruction
Message-ID: <20140513141418.GA23710@htj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1399877792-13046-4-git-send-email-laijs@cn.fujitsu.com>
 <20140512212022.GC18959@mtj.dyndns.org>
 <5371BC94.5080507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5371BC94.5080507@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 13, 2014 at 02:32:52PM +0800, Lai Jiangshan wrote:
> >> +	if (detach_completion)
> >> +		complete(detach_completion);
> >> +}
> > 
> > Are we gonna use this function from somewhere else too?
> 
> it is called from worker_thread().
> 
> I don't want to unfold it into worker_thread(), it is better
> readability when it is wrapped and it will be called in patch10
> for rescuer.

Yeah, it's shared by rescuer later, so it's fine but, again, it
probably helps to mention that it's planned to do so; otherwise, the
rationale is kinda weak and what belongs to that function is rather
arbitrary.

> >>  	/*
> >>  	 * Become the manager and destroy all workers.  Grabbing
> >> -	 * manager_arb prevents @pool's workers from blocking on
> >> -	 * manager_mutex.
> >> +	 * manager_arb ensures manage_workers() finish and enter idle.
> > 
> > I don't follow what the above comment update is trying to say.
> 
> If a pool is destroying, the worker will not call manage_workers().
> but the existing manage_workers() may be still running.
> 
> mutex_lock(&manager_arb) in put_unbound_pool() should wait this manage_workers()
> finished due to the manager-worker (non-idle-worker) can't be destroyed.

Hmmm... I think it'd be better to spell it out then.  The single
sentence is kinda cryptic especially because the two verbs in the
sentence don't have the same subject (managee_workers() can't enter
idle).

Thanks.

-- 
tejun
