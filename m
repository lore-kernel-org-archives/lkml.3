Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaCAEei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 23:34:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:53576 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaCAEeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 23:34:37 -0500
Message-ID: <1393648386.11031.6.camel@marge.simpson.net>
Subject: Re: [PATCH] lockdep: increase static allocations
From: Mike Galbraith <bitbucket@online.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Sat, 01 Mar 2014 05:33:06 +0100
In-Reply-To: <5310E449.1050609@oracle.com>
References: <1389208906-24338-1-git-send-email-sasha.levin@oracle.com>
	 <5310E449.1050609@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:DIW7uM3Exku8NJIqH9DG35flvUmBYMlzDKQKWNrBGDz
 K6FYNXJHDTuPn0ppMPCWaqFUtsH6BSkhwUVQak4Z56Y+pvjeZ+
 9UKfChudIDUCoHhfAYVxnaiUbIK7l4m6JsonP/9k7LFdmHk+hK
 ImkxSQDlrhH99JA9qwWIRZEEVXYTBfbRbfk3+MA5Bh0nyRSF4l
 h8LLGal/j7X2NHqVbP0z98k6YNx9ZH40OrW9ef0uc3yid8tco5
 061J3hgwO9LeR+aL90pJmXO5rcOp6eYHLjv8qu6jpbggmprl32
 Q22d6naLQZP6GEFFxsr5A4kNPUmp4ZE8UFRyzON9vCSi07j8Ko
 JngOJSa3B0fZJlK7Ssh1bqT0efuhF4v+pl87ktpRF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 14:32 -0500, Sasha Levin wrote: 
> On 01/08/2014 02:21 PM, Sasha Levin wrote:
> > Fuzzing a recent kernel with a large configuration hits the static
> > allocation limits and disables lockdep.
> >
> > This patch doubles the limits.
> >
> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> > ---
> >   kernel/locking/lockdep_internals.h | 6 +++---
> >   1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/locking/lockdep_internals.h b/kernel/locking/lockdep_internals.h
> > index 4f560cf..51c4b24 100644
> > --- a/kernel/locking/lockdep_internals.h
> > +++ b/kernel/locking/lockdep_internals.h
> > @@ -54,9 +54,9 @@ enum {
> >    * table (if it's not there yet), and we check it for lock order
> >    * conflicts and deadlocks.
> >    */
> > -#define MAX_LOCKDEP_ENTRIES	16384UL
> > +#define MAX_LOCKDEP_ENTRIES	32768UL
> >
> > -#define MAX_LOCKDEP_CHAINS_BITS	15
> > +#define MAX_LOCKDEP_CHAINS_BITS	16
> >   #define MAX_LOCKDEP_CHAINS	(1UL << MAX_LOCKDEP_CHAINS_BITS)
> >
> >   #define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
> > @@ -65,7 +65,7 @@ enum {
> >    * Stack-trace: tightly packed array of stack backtrace
> >    * addresses. Protected by the hash_lock.
> >    */
> > -#define MAX_STACK_TRACE_ENTRIES	262144UL
> > +#define MAX_STACK_TRACE_ENTRIES	524288UL
> >
> >   extern struct list_head all_lock_classes;
> >   extern struct lock_chain lock_chains[];
> >
> 
> 
> Can someone pick the patch up please? PeterZ even (seemed to) acked it.

I have to do the (exact) same to rt trees, else lockdep routinely gets
in a snit, takes it's cool toys and goes home.

-Mike

