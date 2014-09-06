Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaIFRMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 13:12:35 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51932 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaIFRMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 13:12:34 -0400
Date: Sat, 6 Sep 2014 19:12:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/9] irq_work: Force raised irq work to run on irq
 work interrupt
Message-ID: <20140906171223.GB1471@lerouge>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
 <1408632777-3348-4-git-send-email-fweisbec@gmail.com>
 <20140904061137.GB3190@worktop.ger.corp.intel.com>
 <20140906133513.GA1471@lerouge>
 <20140906154556.GO19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140906154556.GO19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 05:45:56PM +0200, Peter Zijlstra wrote:
> On Sat, Sep 06, 2014 at 03:35:15PM +0200, Frederic Weisbecker wrote:
> > You have a script that does that arch/*/include/asm/Kbuild edit for you right?
> > Is this something in scripts/ ?
> 
> See commit b119fa61d440 ("locking/mcs: Order the header files in Kbuild
> of each architecture in alphabetical order")
> 
> That script is a little buggy, but should work in the current case. So
> first do something like:
> 
> 	for i in arch/*/include/asm/Kbuild; do
> 		echo "generic-y += foo.h" >> $i;
> 	done
> 
> Then run that script.
> 
> IIRC the bug was where a single line contained multiple headers and/or a
> continuation. I should have a better version somewhere, but this one was
> easier to find.

I see. Meanwhile I've applied your suggestion as a separate patch in
the series. May I use your SOB?

Thanks!
