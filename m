Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaB1Vv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:51:56 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:57555 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaB1Vvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:51:55 -0500
Date: Fri, 28 Feb 2014 13:51:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228215150.GM11910@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140227173150.4e5ed747@gandalf.local.home>
 <530FC1C6.5040209@zytor.com>
 <20140227183008.6be081b7@gandalf.local.home>
 <530FCE6C.4080808@zytor.com>
 <alpine.DEB.2.10.1402271957380.6210@vincent-weaver-1.um.maine.edu>
 <20140228203405.GH11910@linux.vnet.ibm.com>
 <20140228154716.0198d7cb@gandalf.local.home>
 <20140228205409.GB14089@laptop.programming.kicks-ass.net>
 <20140228211733.GK11910@linux.vnet.ibm.com>
 <20140228212700.GH14089@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228212700.GH14089@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022821-1344-0000-0000-00000628A90C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 10:27:00PM +0100, Peter Zijlstra wrote:
> On Fri, Feb 28, 2014 at 01:17:33PM -0800, Paul E. McKenney wrote:
> > This code isn't running in idle context is it?  If so, RCU will happily
> > free out from under it.  CONFIG_PROVE_RCU should detect this sort of thing,
> > though.
> 
> Well, interrupts/NMIs can happen when idle, but the interrupt/NMI
> entry code deals with the idle state AFAIK.

Yep, rcu_irq_enter() and rcu_nmi_enter() deal with that.  More worried
about this being code invoked from some energy-efficiency driver or
another within the idle loop.

							Thanx, Paul

