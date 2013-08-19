Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3HSBuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:50:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36214 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3HSBuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:50:54 -0400
Date: Sun, 18 Aug 2013 18:50:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 7/9] nohz_full: Add full-system-idle
 arguments to API
Message-ID: <20130819015046.GB29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818014918.GA27827@linux.vnet.ibm.com>
 <1376790584-28120-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376790584-28120-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818031120.GJ28923@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818031120.GJ28923@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081901-1542-0000-0000-0000009FB331
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 08:11:20PM -0700, Josh Triplett wrote:
> On Sat, Aug 17, 2013 at 06:49:42PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > This commit adds an isidle and jiffies argument to force_qs_rnp(),
> > dyntick_save_progress_counter(), and rcu_implicit_dynticks_qs() to enable
> > RCU's force-quiescent-state process to check for full-system idle.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > [ paulmck: Use true and false for boolean constants per Lai Jiangshan. ]
> 
> One optional comment below; with or without that,
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> >  kernel/rcutree.c | 23 ++++++++++++++++-------
> >  1 file changed, 16 insertions(+), 7 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index b0d2cc3..f1a0b05 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -246,7 +246,9 @@ module_param(jiffies_till_next_fqs, ulong, 0644);
> >  
> >  static void rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
> >  				  struct rcu_data *rdp);
> > -static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
> > +static void force_qs_rnp(struct rcu_state *rsp,
> > +			 int (*f)(struct rcu_data *, bool *, unsigned long *),
> > +			 bool *isidle, unsigned long *maxj);
> 
> You might consider giving the parameters of the function pointer names
> (both here and in the definition), to make it more self-documenting.

Forces a line break, but given that I couldn't immediately recall all
of the parameter names myself, I made the change.  ;-)

							Thanx, Paul

