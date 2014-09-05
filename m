Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbaIENyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:54:44 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45480 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbaIENyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:54:43 -0400
Date: Fri, 5 Sep 2014 15:54:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/9] irq_work: Force raised irq work to run on irq
 work interrupt
Message-ID: <20140905135436.GA1715@lerouge>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
 <1408632777-3348-4-git-send-email-fweisbec@gmail.com>
 <20140904061137.GB3190@worktop.ger.corp.intel.com>
 <20140904133337.GA1771@lerouge>
 <20140904154020.GF346@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904154020.GF346@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 05:40:20PM +0200, Peter Zijlstra wrote:
> On Thu, Sep 04, 2014 at 03:33:40PM +0200, Frederic Weisbecker wrote:
> > > Why not something like the below; then it becomes a compile time matter.
> > 
> > Problem is that some archs only have that information at runtime.
> > See x86 for example which tests cpu_has_apic.
> 
> So the other archs can still benefit, no? Also, on x86 cpu features can
> be used with asm_goto/jump_labels, your approach wrecks that too by
> copying it into some static variable, see static_cpu_has().

Ah I didn't know about that static_cpu_has().
I'm going to try the way you suggest then.

Thanks.
