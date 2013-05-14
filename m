Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab3ENRuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:50:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53231 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab3ENRuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:50:24 -0400
Date: Tue, 14 May 2013 10:49:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time
 as with v3.9
Message-ID: <20130514174933.GF4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87r4hdjsu5.fsf@nemi.mork.no>
 <20130512113157.GG3648@linux.vnet.ibm.com>
 <20130512182935.GD24440@8bytes.org>
 <20130512205747.GK3648@linux.vnet.ibm.com>
 <20130512213430.GE24440@8bytes.org>
 <20130513013518.GM3648@linux.vnet.ibm.com>
 <20130513140005.GA9165@linux.vnet.ibm.com>
 <20130514173739.GH24440@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130514173739.GH24440@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051417-5406-0000-0000-0000087663CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 07:37:39PM +0200, Joerg Roedel wrote:
> Hi Paul,
> 
> On Mon, May 13, 2013 at 07:00:05AM -0700, Paul E. McKenney wrote:
> > rcu: Fix comparison sense in rcu_needs_cpu()
> > 
> > Commit c0f4dfd4f (rcu: Make RCU_FAST_NO_HZ take advantage of numbered
> > callbacks) introduced a bug that can result in excessively long grace
> > periods.  This bug reverse the senes of the "if" statement checking
> > for lazy callbacks, so that RCU takes a lazy approach when there are
> > in fact non-lazy callbacks.  This can result in excessive boot, suspend,
> > and resume times.
> > 
> > This commit therefore fixes the sense of this "if" statement.
> > 
> > Reported-by: Borislav Petkov <bp@alien8.de>
> > Reported-by: Bjørn Mork <bjorn@mork.no>
> > Reported-by: Joerg Roedel <joro@8bytes.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Just tested the patch, it fixes the long boot delay for me. Thanks for
> fixing this.

Thank you Joerg!!!

							Thanx, Paul

> Tested-by: Joerg Roedel <joro@8bytes.org>
> 
> > 
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index 641991d..63098a5 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -1692,7 +1692,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
> >  	rdtp->last_accelerate = jiffies;
> >  
> >  	/* Request timer delay depending on laziness, and round. */
> > -	if (rdtp->all_lazy) {
> > +	if (!rdtp->all_lazy) {
> >  		*dj = round_up(rcu_idle_gp_delay + jiffies,
> >  			       rcu_idle_gp_delay) - jiffies;
> >  	} else {
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

