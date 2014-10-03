Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaJCVEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:04:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38031 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaJCVEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:04:33 -0400
Date: Fri, 3 Oct 2014 23:04:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC
 filtering
Message-ID: <20141003210428.GH6324@worktop.programming.kicks-ass.net>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
 <20141003201409.GM10583@worktop.programming.kicks-ass.net>
 <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
 <CALCETrWfrWpdMCAYySMAMGCHU3XRkNGmeMTECTE=PXQUfjGPZA@mail.gmail.com>
 <20141003204443.GP10583@worktop.programming.kicks-ass.net>
 <20141003210213.GG6324@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003210213.GG6324@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 11:02:13PM +0200, Peter Zijlstra wrote:
> @@ -1928,7 +1939,7 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
>  
>  	userpg->cap_user_time = 0;
>  	userpg->cap_user_time_zero = 0;
> -	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
> +	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc && test_thread_flag(TIF_SECCOMP);

&& !test_thread_flag(TIF_SECCOMP) would probably work better

>  	userpg->pmc_width = x86_pmu.cntval_bits;
>  
>  	if (!sched_clock_stable())
