Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3LFPWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:22:35 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53336 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751347Ab3LFPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:22:33 -0500
Date: Fri, 6 Dec 2013 15:21:41 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Anurag Aggarwal <anurag19aggarwal@gmail.com>
Cc: Anurag Aggarwal <a.anurag@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "narendra.m1@samsung.com" <narendra.m1@samsung.com>,
        "poorva.s@samsung.com" <poorva.s@samsung.com>,
        "naveen.sel@samsung.com" <naveen.sel@samsung.com>,
        "ashish.kalra@samsung.com" <ashish.kalra@samsung.com>,
        "mohammad.a2@samsung.com" <mohammad.a2@samsung.com>,
        "rajat.suri@samsung.com" <rajat.suri@samsung.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH V4] ARM : unwinder : Prevent data abort due to stack
 overflow
Message-ID: <20131206152140.GB4897@e103592.cambridge.arm.com>
References: <1386242785-5146-1-git-send-email-a.anurag@samsung.com>
 <20131205135928.GA4096@e103592.cambridge.arm.com>
 <CAPoNrtuzV=eOWP44om+E6m0NSx+xfFtg-STjPLMBO4OUBF84kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPoNrtuzV=eOWP44om+E6m0NSx+xfFtg-STjPLMBO4OUBF84kQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 03:15:22PM +0000, Anurag Aggarwal wrote:
> >>if (unlikely(check) &&
> >>    *vsp >= (unsigned long *)ctrl->sp_high))
> 
> Good idea, It can help in optimizing the code and will leave code more readable
> and it will be easy to maintain also.

That was my goal -- it's not always easy to achieve both, but we should
try where possible, especially for non-performance-critical code.

> >>Does the code check anywhere that SP is word-aligned?
> >>
> >>That should probably be checked if it's not done already.
> 
> I think this should be handled in separate patch
> I would also like to hear more your ideas for the file

There are some limitations on how backtracing works with ARM_UNWIND.
The backtracer interface assumes that the compiler's register use with
ARM_UNWIND is "almost the same" as with !ARM_UNWIND.  But this is not
always true, and we've seen some problems.  

I think the best solution will involve some refactoring of the interface
between the backtracer and the unwinder backends, but I don't have it
all figured out yet...

Cheers
---Dave
