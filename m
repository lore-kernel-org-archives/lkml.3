Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaJCVMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:12:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:36464 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJCVMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:12:09 -0400
Date: Fri, 3 Oct 2014 23:12:04 +0200
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
Message-ID: <20141003211204.GQ10583@worktop.programming.kicks-ass.net>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
 <20141003201409.GM10583@worktop.programming.kicks-ass.net>
 <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
 <CALCETrWfrWpdMCAYySMAMGCHU3XRkNGmeMTECTE=PXQUfjGPZA@mail.gmail.com>
 <20141003204443.GP10583@worktop.programming.kicks-ass.net>
 <20141003210213.GG6324@worktop.programming.kicks-ass.net>
 <CALCETrW7OCuAiK31iRvXgXJfcf3FE4GKjpKQ0doWFyUpETzT9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW7OCuAiK31iRvXgXJfcf3FE4GKjpKQ0doWFyUpETzT9A@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 02:04:53PM -0700, Andy Lutomirski wrote:
> On Fri, Oct 3, 2014 at 2:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:

> > Something like so.. slightly less ugly and possibly with more
> > complicated conditions setting the cr4 if you want to fix tsc vs seccomp
> > as well.
> 
> This will crash anything that tries rdpmc in an allow-everything
> seccomp sandbox.  It's also not very compatible with my grand scheme
> of allowing rdtsc to be turned off without breaking clock_gettime. :)

Well, we clear cap_user_rdpmc, so everybody who still tries it gets what
he deserves, no problem there.
