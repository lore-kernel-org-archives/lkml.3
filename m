Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3CFTLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:11:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:45064 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3CFTLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:11:32 -0500
Date: Wed, 6 Mar 2013 20:11:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Threaded irqs + 100% CPU RT task = RCU stall
In-Reply-To: <20130306171648.GO3268@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1303062010060.22263@ionos>
References: <20130306154917.GA15249@windriver.com> <alpine.LFD.2.02.1303061651360.22263@ionos> <20130306171648.GO3268@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013, Paul E. McKenney wrote:

> On Wed, Mar 06, 2013 at 04:58:54PM +0100, Thomas Gleixner wrote:
> > On Wed, 6 Mar 2013, Paul Gortmaker wrote:
> > > So, I guess the question is, whether we want to try and make the system
> > > fail in a more meaningful way -- kind of like the rt throttling message
> > > does - as it lets users know they've hit the wall?  Something watching
> > 
> > That Joe Doe should have noticed the throttler message, which came
> > before the stall, shouldn't he?
> > 
> > > for kstat_incr_softirqs traffic perhaps?  Or other options?
> > 
> > The rcu stall detector could use the softirq counter and if it did not
> > change in the stall period print: "Caused by softirq starvation" or
> > something like that.
> 
> The idea is to (at grace-period start) take a snapshot of the CPU's
> value of kstat.softirqs[RCU_SOFTIRQ], then check it at stall time, right?

Yep.
 
> Or do I have the wrong softirq counter?

kstat_softirqs_cpu(RCU_SOFTIRQ, cpu) is the function you want to use.

Thanks,

	tglx
