Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaIFPqM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 11:46:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaIFPqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 11:46:09 -0400
Date: Sat, 6 Sep 2014 17:45:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/9] irq_work: Force raised irq work to run on irq
 work interrupt
Message-ID: <20140906154556.GO19379@twins.programming.kicks-ass.net>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
 <1408632777-3348-4-git-send-email-fweisbec@gmail.com>
 <20140904061137.GB3190@worktop.ger.corp.intel.com>
 <20140906133513.GA1471@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140906133513.GA1471@lerouge>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 03:35:15PM +0200, Frederic Weisbecker wrote:
> You have a script that does that arch/*/include/asm/Kbuild edit for you right?
> Is this something in scripts/ ?

See commit b119fa61d440 ("locking/mcs: Order the header files in Kbuild
of each architecture in alphabetical order")

That script is a little buggy, but should work in the current case. So
first do something like:

	for i in arch/*/include/asm/Kbuild; do
		echo "generic-y += foo.h" >> $i;
	done

Then run that script.

IIRC the bug was where a single line contained multiple headers and/or a
continuation. I should have a better version somewhere, but this one was
easier to find.
