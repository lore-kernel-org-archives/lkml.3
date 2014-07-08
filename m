Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaGHWfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:35:14 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41075 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaGHWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:35:12 -0400
Date: Tue, 8 Jul 2014 15:35:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: Pranith Kumar <bobby.prani@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] kernel/rcu/rcutorture.c:185 fix a sparse warning
Message-ID: <20140708223506.GG4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
 <1402519183-12752-6-git-send-email-bobby.prani@gmail.com>
 <20140611214752.GC16940@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611214752.GC16940@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070822-9332-0000-0000-000001513368
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 02:47:52PM -0700, josh@joshtriplett.org wrote:
> On Wed, Jun 11, 2014 at 04:39:43PM -0400, Pranith Kumar wrote:
> > fix the following sparse warning
> > 
> > kernel/rcu/rcutorture.c:185:1: warning: symbol 'boost_mutex' was not declared. Should it be static?
> > 
> > by marking boost_mutex as a static mutex
> > 
> > Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> 
> Please preserve the comment alignment (by deleting a tab).  With that
> fixed:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Queued for 3.18.

But Pranith, next time Josh gives you a review comment, could you please
respond with the appropriate update?

							Thanx, Paul

> >  kernel/rcu/rcutorture.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> > index 7fa34f8..1cd4b2d 100644
> > --- a/kernel/rcu/rcutorture.c
> > +++ b/kernel/rcu/rcutorture.c
> > @@ -182,7 +182,7 @@ static u64 notrace rcu_trace_clock_local(void)
> >  #endif /* #else #ifdef CONFIG_RCU_TRACE */
> >  
> >  static unsigned long boost_starttime;	/* jiffies of next boost test start. */
> > -DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
> > +static DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
> >  					/*  and boost task create/destroy. */
> >  static atomic_t barrier_cbs_count;	/* Barrier callbacks registered. */
> >  static bool barrier_phase;		/* Test phase. */
> > -- 
> > 1.9.1
> > 
> 

