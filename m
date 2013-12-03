Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab3LCTo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:44:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56058 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887Ab3LCToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:44:24 -0500
Date: Tue, 3 Dec 2013 19:44:12 +0000
From: Will Deacon <will.deacon@arm.com>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>
Subject: Re: [PATCH RFC v4 1/6] arm64: support single-step and breakpoint
 handler hooks
Message-ID: <20131203194412.GC22668@mudshark.cambridge.arm.com>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
 <1382008671-4515-2-git-send-email-sandeepa.prabhu@linaro.org>
 <20131025152236.GC10673@mudshark.cambridge.arm.com>
 <CA+b37P0xNDqKWm-Vdpmwrvqxr01C+bOhas+-nEUxLFe7pzEB7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+b37P0xNDqKWm-Vdpmwrvqxr01C+bOhas+-nEUxLFe7pzEB7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 02:33:17PM +0000, Sandeepa Prabhu wrote:
> Hi Will,
> 
> Sorry for responding to this after long-time, I missed this review
> during Linaro connect travels.

No problem.

> >> @@ -215,7 +257,10 @@ static int single_step_handler(unsigned long addr, unsigned int esr,
> >>                */
> >>               user_rewind_single_step(current);
> >>       } else {
> >> -             /* TODO: route to KGDB */
> >> +             /* call registered single step handlers */
> >
> > Don't bother with this comment (it's crystal clear from the code).
> OK, I will remove this unnecessary print.

Thanks.

> >> +static LIST_HEAD(break_hook);
> >> +DEFINE_RWLOCK(break_hook_lock);
> >
> > This guy can be a plain old spinlock. That way, the readers have less
> > overhead but things still work because we only call a single hook function.
> well, kprobes need to support recursive breakpoints (i.e. breakpoint
> handler executing BRK once again)
> so I converted this lock to rw_lock.  I should put this info in commit
> description to be more clearer.

Actually, this is one place where a comment in the code *would* be useful!

> Let me know if you find any issue with re-cursing in breakpoint exception?

Sounds ok to me. With those changes:

  Acked-by: Will Deacon <will.deacon@arm.com>

Cheers,

Will
