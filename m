Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaJCU2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:28:18 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:60672 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbaJCU2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:28:13 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
 <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
 <20141003201409.GM10583@worktop.programming.kicks-ass.net> <CALCETrVvFP66s5XOmSKaC8Vq73=uh11819HOOLkVTu7jJZotew@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 3 Oct 2014 13:27:52 -0700
Message-ID: <CALCETrWfrWpdMCAYySMAMGCHU3XRkNGmeMTECTE=PXQUfjGPZA@mail.gmail.com>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC filtering
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 1:22 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> We could make the rule be that RDPMC is enabled if a perf event is
> mmapped or TIF_SECCOMP is clear, but I'd prefer to be convinced that
> there's an actual performance issue first.  Ideally we can get this
> all working with no API or ABI change at all.

No, we can't use that rule.  But we could say that RDPMC is enabled if
a perf event is mmapped and no thread in the mm uses seccomp.  I'll
grumble a little bit about adding yet another piece of seccomp state.

--Andy
