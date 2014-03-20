Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaCTHY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 03:24:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56225 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaCTHYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 03:24:25 -0400
Date: Thu, 20 Mar 2014 08:23:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: davidlohr@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        paulus@samba.org, Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
Message-ID: <20140320072359.GF27965@twins.programming.kicks-ass.net>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
 <20140319154705.GB8557@laptop.programming.kicks-ass.net>
 <20140319170829.GD8557@laptop.programming.kicks-ass.net>
 <20140320053350.GB30295@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320053350.GB30295@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 11:03:50AM +0530, Srikar Dronamraju wrote:
> > > Joy,.. let me look at that with ppc in mind.
> > 
> > OK; so while pretty much all the comments from that patch are utter
> > nonsense (what was I thinking), I cannot actually find a real bug.
> > 
> > But could you try the below which replaces a control dependency with a
> > full barrier. The control flow is plenty convoluted that I think the
> > control barrier isn't actually valid anymore and that might indeed
> > explain the fail.
> > 
> 
> Unfortunately the patch didnt help. Still seeing tasks stuck

Aww bugger. I'll be traveling tomorrow and today is wasted getting
ready. So unless Davidlohr has anything we'll need to scrap this change.
