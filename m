Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3HSA3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 20:29:22 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34417 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604Ab3HSA3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 20:29:21 -0400
Date: Sun, 18 Aug 2013 17:29:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH tip/core/rcu 01/11] rcu: Expedite grace periods during
 suspend/resume
Message-ID: <20130819002910.GR29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818013735.GA27234@linux.vnet.ibm.com>
 <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818031717.GL28923@leaf>
 <20130818093444.GA26728@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818093444.GA26728@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081900-7182-0000-0000-00000820DD91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 11:34:44AM +0200, Borislav Petkov wrote:
> On Sat, Aug 17, 2013 at 08:17:17PM -0700, Josh Triplett wrote:
> > On Sat, Aug 17, 2013 at 06:37:46PM -0700, Paul E. McKenney wrote:
> > > From: Borislav Petkov <bp@alien8.de>
> > > 
> > > CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by up to
> > > a factor of four, which can result in long suspend and resume times.
> > > Thus, this commit temporarily switches to expedited grace periods when
> > > suspending the box and return to normal settings when resuming.
> > > 
> > > [ paulmck: This also papers over an audio/irq bug, but hopefully that will
> > >   be fixed soon. ]
> > > 
> > > Signed-off-by: Borislav Petkov <bp@suse.de>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > This patch still seems like a hack, and there *ought* to be a better
> > general solution to avoid excessive grace-period latency.  Nonetheless,
> > in the absence of such a solution,
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> Yeah, I'm not happy about it either but from quickly skimming over what
> context we're using rcu_expedited in, the basic requirement for a fix is
> for the pm core to be able to tell rcu not to stretch grace periods.
> 
> So simply setting a variable is much simpler than switching to calling
> all those *_expedited() rcu flavors from the pm notifier when going
> down.
> 
> Unless Paul has a better idea, of course.
> 
> The basic problem here is, however, that you need to temporarily
> reconfigure the inner workings of a subsystem because hardware is
> performing a power state transition. Unless someone teaches rcu about
> power state transitions... :-)

I would guess that once we have a few more subsystems that want RCU to
temporarily expedite its grace periods, we will have enough information
and experience to do something a bit more general.  In the meantime,
I am opting for something simple.  ;-)

							Thanx, Paul

