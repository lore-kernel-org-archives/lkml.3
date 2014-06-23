Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaFWP1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:27:06 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54703 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbaFWP1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:27:03 -0400
Date: Mon, 23 Jun 2014 08:26:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, dave.hansen@intel.com,
        ak@linux.intel.com, umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
Message-ID: <20140623152656.GA22225@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140621025958.GA7185@linux.vnet.ibm.com>
 <20140621042958.GA4515@thin>
 <20140621060625.GG4615@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406230851120.2892@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406230851120.2892@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062315-6688-0000-0000-000002C336F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 08:53:12AM -0500, Christoph Lameter wrote:
> On Fri, 20 Jun 2014, Paul E. McKenney wrote:
> 
> > > I like this approach *far* better.  This is the kind of thing I had in
> > > mind when I suggested using the fqs machinery: remove the poll entirely
> > > and just thwack a CPU if it takes too long without a quiescent state.
> > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> >
> > Glad you like it.  Not a fan of the IPI myself, but then again if you
> > are spending that must time looping in the kernel, an extra IPI is the
> > least of your problems.
> 
> Good. The IPI is only used when actually necessary. The code inserted
> was always there and always executed although rarely needed.

Interesting.  I actually proposed this approach several times in the
earlier thread, but to deafing silence: https://lkml.org/lkml/2014/6/18/836,
https://lkml.org/lkml/2014/6/17/793, and https://lkml.org/lkml/2014/6/20/479.

I guess this further validates interpreting silence as assent.

							Thanx, Paul

