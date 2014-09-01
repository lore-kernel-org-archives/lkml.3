Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaIAQRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:17:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:57904 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaIAQRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:17:42 -0400
Date: Mon, 1 Sep 2014 18:17:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com, <""@rjwysocki.net>,
        tianyu.lan@intel.com
Subject: Re: [PATCH RFC tip/core/rcu] Eliminate deadlock between CPU hotplug
 and expedited grace periods
Message-ID: <20140901161735.GA5806@worktop.ger.corp.intel.com>
References: <20140828194745.GA3761@linux.vnet.ibm.com>
 <20140901112059.GG27892@worktop.ger.corp.intel.com>
 <20140901160550.GL5001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901160550.GL5001@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 09:05:50AM -0700, Paul E. McKenney wrote:
> > URGH.. I really hate that. The hotplug interface is already too
> > horrible, we should not add such hacks to it.
> 
> We do have try_ interfaces to a number of other subsystems, so I don't
> believe that it qualifies as such a hack.

We do indeed, but I'm not sure about adding this to the hotplug stuff.

Also; not really understanding the problem doesn't help. 

> > How about ripping that rcu_expedited stuff out instead? That's all
> > conditional anyhow, so might as well not do it.
> 
> In what way is the expedited stuff conditional?

synchronize_sched() conditionally calls synchronize_sched_expedited()
and its condition: rcu_expedited, gets set/cleared on pm notifiers and
nr_cpu_ids.


