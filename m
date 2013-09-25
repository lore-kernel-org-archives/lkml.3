Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab3IYPeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:34:03 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:48288 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IYPeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:34:01 -0400
X-Originating-IP: 50.43.39.152
Date: Wed, 25 Sep 2013 08:33:21 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH tip/core/rcu 3/3] rcu: Fix occurrence of "the the" in
 checklist.txt
Message-ID: <20130925153321.GA6269@leaf>
References: <20130925011657.GA29958@linux.vnet.ibm.com>
 <1380071843-30362-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1380071843-30362-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130925034739.GA2016@leaf>
 <20130925135527.GS9093@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925135527.GS9093@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 06:55:27AM -0700, Paul E. McKenney wrote:
> On Tue, Sep 24, 2013 at 08:47:39PM -0700, Josh Triplett wrote:
> > On Tue, Sep 24, 2013 at 06:17:23PM -0700, Paul E. McKenney wrote:
> > > From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> > > 
> > > Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > ---
> > 
> > See comment below.
> > 
> > >  Documentation/RCU/checklist.txt | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
> > > index 7703ec7..ad6cba4 100644
> > > --- a/Documentation/RCU/checklist.txt
> > > +++ b/Documentation/RCU/checklist.txt
> > > @@ -203,7 +203,7 @@ over a rather long period of time, but improvements are always welcome!
> > >  	the corresponding readers must disable preemption, possibly
> > >  	by calling rcu_read_lock_sched() and rcu_read_unlock_sched().
> > >  	If the updater uses synchronize_srcu() or call_srcu(),
> > > -	the the corresponding readers must use srcu_read_lock() and
> > > +	the corresponding readers must use srcu_read_lock() and
> > 
> > I think this may have actually been a typo for "then", as in "If the
> > updater uses ..., then the corresponding readers must use ...".
> 
> Good point -- that would make the sentence construction parallel with
> the surrounding sentences.  Updated patch below.
> 
> 							Thanx, Paul
> 
> rcu: Fix occurrence of "the the" in checklist.txt
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> [ paulmck: Add "then" as suggested by Josh Triplett. ]

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
> index 7703ec7..9126619 100644
> --- a/Documentation/RCU/checklist.txt
> +++ b/Documentation/RCU/checklist.txt
> @@ -202,8 +202,8 @@ over a rather long period of time, but improvements are always welcome!
>  	updater uses call_rcu_sched() or synchronize_sched(), then
>  	the corresponding readers must disable preemption, possibly
>  	by calling rcu_read_lock_sched() and rcu_read_unlock_sched().
> -	If the updater uses synchronize_srcu() or call_srcu(),
> -	the the corresponding readers must use srcu_read_lock() and
> +	If the updater uses synchronize_srcu() or call_srcu(), then
> +	the corresponding readers must use srcu_read_lock() and
>  	srcu_read_unlock(), and with the same srcu_struct.  The rules for
>  	the expedited primitives are the same as for their non-expedited
>  	counterparts.  Mixing things up will result in confusion and
> 
