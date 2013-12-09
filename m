Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167Ab3LIOW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:22:58 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54390 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755764Ab3LIOWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:22:55 -0500
Date: Mon, 9 Dec 2013 14:22:17 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Anurag Aggarwal <anurag19aggarwal@gmail.com>
Cc: "naveen.sel@samsung.com" <naveen.sel@samsung.com>,
        "narendra.m1@samsung.com" <narendra.m1@samsung.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Anurag Aggarwal <a.anurag@samsung.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ashish.kalra@samsung.com" <ashish.kalra@samsung.com>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "rajat.suri@samsung.com" <rajat.suri@samsung.com>,
        "poorva.s@samsung.com" <poorva.s@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "mohammad.a2@samsung.com" <mohammad.a2@samsung.com>
Subject: Re: [PATCH] ARM : unwinder : Prevent data abort due to stack overflow
Message-ID: <20131209142212.GA4281@e103592.cambridge.arm.com>
References: <1386310193-6434-1-git-send-email-a.anurag@samsung.com>
 <20131206121149.GA4897@e103592.cambridge.arm.com>
 <CAPoNrtsHOXJMUsgUE_MET298n_H2sC2P+RbfUoG=kqK9chTTHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPoNrtsHOXJMUsgUE_MET298n_H2sC2P+RbfUoG=kqK9chTTHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 01:43:21PM +0530, Anurag Aggarwal wrote:
> >>
> >> +     /* we are just starting, initialize last register set as 0 */
> >> +     ctrl.last_register_set = 0;
> >> +
> >>       while (ctrl.entries > 0) {
> >> -             int urc = unwind_exec_insn(&ctrl);
> >> +             int urc;
> >> +             if ((ctrl.sp_high - ctrl.vrs[SP]) < TOTAL_REGISTERS)
> >> +                     ctrl.last_register_set = 1;
> >
> >If this is done once per unwind_exec_insn(), I think it would be better
> >to put the check at the start of unwind_exec_insn() instead of outside.
> 
> I think it is better to do the above check here only because this check
> is strictly not a part of decoder and execution cycle.
> 
> I think uniwnd_exec_insn(), should only be used for decoding and
> execution of instruction, as you have suggested earlier. So, it makes
> sense to keep it in unwind_frame only().

It's debatable, since the stack checking is an intrinsic part of insn
execution.  But since there is only one call site for unwind_exec_insn
and it is unlikely than another will appear in the future, I am happy
for it to remain in your current form.

Cheers
---Dave
