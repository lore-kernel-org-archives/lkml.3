Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaJRVWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 17:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaJRVWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 17:22:09 -0400
Date: Sat, 18 Oct 2014 23:18:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in
	task_numa_assign()
Message-ID: <20141018211840.GA16931@redhat.com>
References: <1413376300.24793.55.camel@tkhai> <20141017213641.GB32576@redhat.com> <4323181413620101@web21o.yandex.ru> <1011271413621207@web30j.yandex.ru> <20141018193612.GC23531@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141018193612.GC23531@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18, Peter Zijlstra wrote:
>
> So you worry about the refcount doing 0->1 ? In which case the above is
> still wrong and we should be using atomic_inc_not_zero() in order to
> acquire the reference count.

It is actually worse, please see my reply to Kirill. We simply can't
dereference foreign_rq->curr lockless.

Again, task_struct is only protected by RCU if it was found on a RCU
protected list. rq->curr is not protected by rcu. Perhaps we have to
change this... but this will be a bit unfortunate.

Oleg.

