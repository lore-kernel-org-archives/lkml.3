Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaG1QyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:54:01 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:5065 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaG1QyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:54:00 -0400
Message-ID: <1406566438.25428.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH -tip/master 3/7] locking/mcs: Remove obsolete comment
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Jul 2014 09:53:58 -0700
In-Reply-To: <1406566175.2411.13.camel@j-VirtualBox>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-3-git-send-email-davidlohr@hp.com>
	 <1406566175.2411.13.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 09:49 -0700, Jason Low wrote:
> On Sun, 2014-07-27 at 22:18 -0700, Davidlohr Bueso wrote:
> > ... as we clearly inline mcs_spin_lock() now.
> > 
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > ---
> >  kernel/locking/mcs_spinlock.h | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
> > index 23e89c5..4d60986 100644
> > --- a/kernel/locking/mcs_spinlock.h
> > +++ b/kernel/locking/mcs_spinlock.h
> > @@ -56,9 +56,6 @@ do {									\
> >   * If the lock has already been acquired, then this will proceed to spin
> >   * on this node->locked until the previous lock holder sets the node->locked
> >   * in mcs_spin_unlock().
> > - *
> > - * We don't inline mcs_spin_lock() so that perf can correctly account for the
> > - * time spent in this lock function.
> >   */
> >  static inline
> >  void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
> 
> Likewise, I'm wondering if we should make this function noinline so that
> "perf can correctly account for the time spent in this lock function".

Well, it's not hard to see where the contention is when working on
locking issues with perf. With mutexes there are only two sources,
either the task is just spinning trying to get the lock, or its gone to
the slowpath, and you can see a lot of contention on the wait_lock. 

So unless I'm missing something, I don't think we'd need to make this
noinline again -- although I forget why it was changed in the first
place.

