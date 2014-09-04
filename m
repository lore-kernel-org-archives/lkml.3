Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaIDPkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:40:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:47270 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIDPkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:40:23 -0400
Date: Thu, 4 Sep 2014 17:40:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/9] irq_work: Force raised irq work to run on irq
 work interrupt
Message-ID: <20140904154020.GF346@worktop.programming.kicks-ass.net>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
 <1408632777-3348-4-git-send-email-fweisbec@gmail.com>
 <20140904061137.GB3190@worktop.ger.corp.intel.com>
 <20140904133337.GA1771@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904133337.GA1771@lerouge>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 03:33:40PM +0200, Frederic Weisbecker wrote:
> > Why not something like the below; then it becomes a compile time matter.
> 
> Problem is that some archs only have that information at runtime.
> See x86 for example which tests cpu_has_apic.

So the other archs can still benefit, no? Also, on x86 cpu features can
be used with asm_goto/jump_labels, your approach wrecks that too by
copying it into some static variable, see static_cpu_has().
