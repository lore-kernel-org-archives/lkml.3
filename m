Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3DLRyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:54:37 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55141 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab3DLRyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:54:36 -0400
Date: Fri, 12 Apr 2013 10:54:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
Message-ID: <20130412175419.GG29861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130411160524.GA30384@linux.vnet.ibm.com>
 <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130411182502.GA31684@pd.tnic>
 <20130411191355.GO29861@linux.vnet.ibm.com>
 <1365753904.17140.22.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365753904.17140.22.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041217-2398-0000-0000-0000133C4580
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 10:05:04AM +0200, Peter Zijlstra wrote:
> On Thu, 2013-04-11 at 12:13 -0700, Paul E. McKenney wrote:
> > > > +2. Many architectures will place dyntick-idle CPUs into deep sleep
> > > > +   states, which further degrades from-idle transition latencies.
> > > 
> > > Above you say "to and from the idle loop", now it is from-idle. Simply say:
> > > 
> > > "... which further degrades idle transision latencies" which means both :).
> > 
> > If people speak for this item, I will update it.  Arjan suggested removing
> > it entirely.
> 
> So I haven't yet read the entire document, but:
> 
> +2.     Many architectures will place dyntick-idle CPUs into deep sleep
> +       states, which further degrades from-idle transition latencies.
> +
> +Therefore, systems with aggressive real-time response constraints
> +often run CONFIG_NO_HZ=n kernels in order to avoid degrading from-idle
> +transition latencies.
> 
> I'm not sure that's the reason.. We can (and do) limit C states to curb
> the idle-exit times. The reason we often turn off NOHZ all together is
> to further reduce the cost of the idle paths.
> 
> All the mucking about with clock states and such is a rather expensive
> thing
> to do all the time.

Ah, thank you!  This might help me address Arjan's concerns as well.
How about the following for the disadvantages of CONFIG_NO_HZ=y?

							Thanx, Paul

------------------------------------------------------------------------

1.	It increases the number of instructions executed on the path
	to and from the idle loop.

2.	On many architectures, dyntick-idle mode also increases the
	number of times that clocks must be reprogrammed, and this
	reprogramming can be quite expensive.

