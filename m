Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaAGNyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:54:14 -0500
Received: from [217.140.96.21] ([217.140.96.21]:50499 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751264AbaAGNyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:54:09 -0500
Date: Tue, 7 Jan 2014 13:53:14 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Anurag Aggarwal <anurag19aggarwal@gmail.com>
Cc: Anurag Aggarwal <a.anurag@samsung.com>,
        Naveen Kumar <naveen.sel@samsung.com>,
        Narendra Meher <narendra.m1@samsung.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Ashish Kalra <ashish.kalra@samsung.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpgs ." <cpgs@samsung.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        Rajat Suri <rajat.suri@samsung.com>,
        Poorva Srivastava <poorva.s@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mohammad Irfan Ansari <mohammad.a2@samsung.com>
Subject: Re: [PATCH V6] ARM : unwinder : Prevent data abort due to stack
 overflow
Message-ID: <20140107135254.GA3241@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 03:47:49PM +0530, Anurag Aggarwal wrote:
> >You could try adding some debug printks to see how the backtrace fails.
> >You could also try adding a few hand-crafted assembler functions
> >with appropriate code and unwind directives to trigger different kinds
> >of backtrace failure.  You might have to add a way to artificially limit
> >sp_high to check the cases where you run out of stack in the middle of
> >popping multiple registers.
> 
> I added a a printk statement
> +               if (*vsp >= (unsigned long *)ctrl->sp_high) {
> +                       printk(KERN_ERR "Stack Overflow Detected, vsp = %lx",
> +                               (unsigned long)*vsp);
> +                       return -URC_FAILURE;
> +               }
> 
> I ran a many test cases to try and get the above print in the dmesg log.
> 
> I tried the following things :
> 
> 1) Calling unwind_backtrace from diffrenet locations in the kernel, I
> added the unwind call
> in some irq, fork, exit and some sysfs entries call.
> 2) I limited the value of sp_high in unwind_frame() itself, I tried
> many values of sp_high,
> varrying from (low + sizeof(ctrl.vrs)/4) to (low + 4*sizeof(ctrl.vrs)).
> 
> When running the above cases I was able to see the above printk quiet
> a few times in dmesg log.
> 
> So, the error condition is being handled.
> 
> If you have some test cases for verifying the unwinder, please share
> the same. They might help
> in thorough testing of unwinder.

I think that sounds OK to give us reasonable confidence that the code is
working correctly.

Go ahead and add my Reviewed-by on the patch, if you're still waiting
for it.

Cheers
---Dave
