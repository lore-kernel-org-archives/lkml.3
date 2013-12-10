Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3LJRc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:32:28 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50464 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752710Ab3LJRc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:32:26 -0500
Date: Tue, 10 Dec 2013 17:31:46 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Anurag Aggarwal <a.anurag@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Naveen Kumar <naveen.sel@samsung.com>,
        Narendra Meher <narendra.m1@samsung.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ashish Kalra <ashish.kalra@samsung.com>, "cpgs ." <cpgs@samsung.com>,
        "anurag19aggarwal@gmail.com" <anurag19aggarwal@gmail.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        Rajat Suri <rajat.suri@samsung.com>,
        Poorva Srivastava <poorva.s@samsung.com>,
        Mohammad Irfan Ansari <mohammad.a2@samsung.com>
Subject: Re: [PATCH V6] ARM : unwinder : Prevent data abort due to stack
 overflow
Message-ID: <20131210173137.GA23639@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 03:54:42AM +0000, Anurag Aggarwal wrote:
> >Reviewed-by: Dave Martin <Dave.Martin@arm.com>
> >
> >I can confirm that the kernel "doesn't crash" with this applied, and
> >that backtracing at least partially works.  But this is not really
> >sufficient to demontrate that the now code works better than the old
> >code in corner cases (which is the point of the patch).
> >
> >Can you give details of what additional testing you have, or plan to
> >do?
> 
> We saw a data abort in unwinder for one of Samsung Project, during a
> Samsung Automation test case. 
> After that I created the initial the patch, and the data abort has not been
> seen till now.
> 
> Is it possible for you to give an idea on what other kind of additional testing 
> do you have in mind.

To be sure how the stack checking code is behaving, it would be good to
see the overflow check being hit.  With just a single test case, it's
possible that the bug is now hidden, rather than fixed.

You could try adding some debug printks to see how the backtrace fails.
You could also try adding a few hand-crafted assembler functions
with appropriate code and unwind directives to trigger different kinds
of backtrace failure.  You might have to add a way to artificially limit
sp_high to check the cases where you run out of stack in the middle of
popping multiple registers.

When thinking about this, I could not think of a good way to integrate
tests upstream without it being very invasive -- it may be best to keep
debug code separate unless you can see a clean way to merge it.


Cheers
---Dave
