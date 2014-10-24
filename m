Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaJXHwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:52:07 -0400
Received: from relay.parallels.com ([195.214.232.42]:52266 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaJXHwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:52:05 -0400
Message-ID: <1414137118.19914.163.camel@tkhai>
Subject: Re: introduce task_rcu_dereference?
From: Kirill Tkhai <ktkhai@parallels.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Fri, 24 Oct 2014 11:51:58 +0400
In-Reply-To: <20141023181818.GB2740@redhat.com>
References: <1413962231.19914.130.camel@tkhai>
	 <20141022213041.GA25467@redhat.com> <1414051845.19914.144.camel@tkhai>
	 <20141023181818.GB2740@redhat.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Чт, 23/10/2014 в 20:18 +0200, Oleg Nesterov пишет:
> On 10/23, Kirill Tkhai wrote:
> >
> > I'm agree generic helper is better. But probe_slab_address() has a sence
> > if we know that SDBR is worse in our subject area.
> 
> And I still think it is worse.
> 
> > Less of code is
> > easier to support :)
> 
> Sure, but ignoring the comments, SDBR needs the same code in
> task_rcu_dereference() ? Except, of course
> 
> 	-	probe_slab_address(&task->sighand, sighand);
> 	+	sighand = task->sighand;
> 
> or how do you think we can simplify it?

Ok, really, not big simplification there. Your variant is good.

> > probe_slab_address() it's not a trivial logic.
> 
> But it already has a user. And probably it can have more.
> 
> To me the usage of SDBR is not trivial (and confusing) in this case.
> Once again, ignoring the CONFIG_DEBUG_PAGEALLOC problems it does not
> help at all.
> 
> With or without SDBR rq->curr can be reused and we need to avoid this
> race. The fact that with SDBR it can be reused only as another instance
> of task_struct is absolutely immaterial imo.
> 
> Not to mention that SDBR still adds some overhead while probe_slab()
> is free unless CONFIG_DEBUG_PAGEALLOC, but this option adds a large
> slowdown anyway.
> 
> 
> But again, I can't really work today, perhaps I missed something.
> Perhaps you can show a better code which relies on SDBR?

No, it would be the same except probe_slab_address(). So, let's stay
on probe_slab_address() variant and fix the bug this way.

Kirill

