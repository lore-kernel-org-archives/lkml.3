Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaKJQRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:17:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:59387 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaKJQQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:16:58 -0500
Date: Mon, 10 Nov 2014 17:16:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH v4] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
Message-ID: <20141110161656.GC10501@worktop.programming.kicks-ass.net>
References: <1413962231.19914.130.camel@tkhai>
 <545D928B.2070508@oracle.com>
 <20141110160320.GA10501@worktop.programming.kicks-ass.net>
 <5460E339.5020308@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5460E339.5020308@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:09:29AM -0500, Sasha Levin wrote:
> On 11/10/2014 11:03 AM, Peter Zijlstra wrote:
> > On Fri, Nov 07, 2014 at 10:48:27PM -0500, Sasha Levin wrote:
> >> [  829.539183] BUG: spinlock recursion on CPU#10, trinity-c594/11067
> >> [  829.539203]  lock: 0xffff880631dd6b80, .magic: dead4ead, .owner: trinity-c594/11067, .owner_cpu: 13
> > 
> > Ooh, look at that. CPU#10 vs .owner_cpu: 13 on the _same_ task.
> > 
> > One of those again :/
> 
> Hum. I missed that one.
> 
> Hold on, but the magic here is fine and the owner pointer is fine, why would just the owner cpu
> be wrong?

I've no clue, but I've seen them before. Complete mystery that.
