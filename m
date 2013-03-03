Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3CCFxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 00:53:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3CCFxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 00:53:34 -0500
Message-ID: <1362289990.4481.36.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 1/2] ipc: introduce obtaining a lockless ipc object
From: Mike Galbraith <bitbucket@online.de>
To: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 03 Mar 2013 06:53:10 +0100
In-Reply-To: <5132B2FB.4020004@redhat.com>
References: <1362183400.3420.24.camel@buesod1.americas.hpqcorp.net>
	 <CANN689EqgPZVw=Sy_WAkB+=MJJCZeRMq_CmF1gec+cRVCS2xtA@mail.gmail.com>
	 <5132B2FB.4020004@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:ghvd2laIiQOTGFMRkMdeBsX/eQ0Rb+7I2aF7b89z3yI
 n1Giaiw396Mc7Bml3sgudH/jFeJHuh9eXnGueSCRs8O0qsNc8R
 FRsvLhgdGPzpXFlGBmzXJegEPKX6wghECA1xnxWyUezREOKY4K
 xyjInHTeKJ64LjBKzXEmY9CtDXJsPc3jbxvcWsaW+AuNhWH/Tb
 JUlIhyK3yBgDmIj/WY0CMZMadaZdSh4A4hpmZbz0h3aXuVkTLB
 nEyjL03z1GwQb1UDWSxotLkrMM9an1iMYBN6OOs1KKD5fWw8lc
 bQfr9ZTWkkgZNiB5yFfnVzdjXo4txN87CApKfgOP+/tSOIGNwu
 4yP1+K9BVRlNmxxm36+q4X3U89qgFBD3yqHiyfBHIKOoSlWyh/
 aHDJbfDqPbQyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 21:18 -0500, Rik van Riel wrote: 
> On 03/01/2013 11:32 PM, Michel Lespinasse wrote:
> 
> > I think it may be nicer to take the rcu read lock at the call site
> > rather than in ipc_obtain_object(), to make the rcu read lock/unlock
> > sites pair up more nicely. Either that or make an inline
> > ipc_release_object function that pairs up with ipc_obtain_object() and
> > just does an rcu_read_unlock().
> 
> I started on a patch series to untangle the IPC locking, so
> it will be a little more readable, and easier to maintain.
> 
> It is a slower approach than Davidlohr's, as in, it will take
> a little longer to put a patch series together, but I hope it
> will be easier to debug...
> 
> I hope to post a first iteration of the series by the middle
> of next week.

Goody, I'll be watching out for it.  I have a big box rt user who uses
semaphores in their very tight constraint application.  While they're
using them carefully, I saw a trace where contention cost vs jitter
budget was a bit too high for comfort, and semctl/semop collision.

-Mike

