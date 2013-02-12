Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3BLJw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 04:52:59 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:64013 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab3BLJw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 04:52:57 -0500
Date: Tue, 12 Feb 2013 10:52:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-ID: <20130212095249.GC20039@gmail.com>
References: <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
 <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
 <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
 <20130211122654.GA5802@gmail.com>
 <CA+55aFwq+_TvOZNEPO-eFPjYuPuMFL0bgR0x=nLq_tvfATqaTA@mail.gmail.com>
 <20130211172807.GA9716@gmail.com>
 <CA+55aFx-0-qcYMqH2wnJJ7iAPhoEvD_EQ0xqVW3VGS3G9=_1_w@mail.gmail.com>
 <20130211175856.GC9716@gmail.com>
 <CA+55aFxpH2A5pTkeAt-bapN6Erac7SSEUhS9qaZ6jUhm_0EAtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxpH2A5pTkeAt-bapN6Erac7SSEUhS9qaZ6jUhm_0EAtA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Feb 11, 2013 at 9:58 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > So basically Pekka optimistically thought it's an eventual 
> > 'tit for tat', a constant stream of benefits to the kernel, 
> > in the hope of finding a home in the upstream kernel which 
> > would further help both projects. The kernel wants to keep 
> > the 'tit' only though.
> 
> Ingo, stop this idiotic nonsense.
> 
> You seem to think that "kvmtool is useful for kernel" is 
> somehow relevant.
> 
> IT IS TOTALLY IRRELEVANT.

Please stop misrepresenting my opinion. My argument continues to 
be that it was useful to the kernel in significant part 
*BECAUSE* tools/kvm/ was integrated into a kernel repository - 
on the main developers' systems.

You seem to take it for granted that causality cannot possibly 
go the way that these kernel enhancements came mainly because 
the tool was integrated into a kernel repo and was developed 
very consciously within a kernel repo, as a (foster-)sister 
project.

Why are you making that assumption? It's totally debatable and 
we, who experienced that development process first hand, are 
fiercely debating it.

Check the list I gave (unmodified):

"- Pekka listed new virtio drivers that were done via tools/kvm. 

 - Pekka listed ARM KVM support which was written/prototyped
   using tools/kvm.

 - There's over a dozen bugfixes in your kernel which were found
   via syscall fuzzing built into tools/kvm. (I can dig them all
   out if you want.)

 - There are several fixes in the kernel side KVM subsystem
   itself that were unearthed via tools/kvm.

 - I showed how it helped the kernel by creating user-space
   lockdep: code used in more situations means more exposure,
   more bugfixes and more contributors. (It also allowed
   immediate lockdep coverage for all the user-space mutexes
   that tools/perf/ itself uses.)"

All but the fourth item (KVM fixes) were benefits that arose 
largely because the tool was integrated into a kernel repository 
and the developers found it easy to work that way.

In at least 3 cases above I could describe the actual, specific 
development process that involved a single code base, even 
adding features to *BOTH* the tool and the kernel, in one work 
flow.

The resulting patches were then rebased after the fact (mostly 
by Pekka), to merge upstream separately while waiting for the 
tool to prove itself for upstream - losing its origin, 
motivation and its history.

Could it have been attempted separately? Yes, just like perf 
could have been tried as a separate project - but that is not 
how it happened, that is not how the development flow unfolded, 
and that is not what motivated those enhancements.

Just because it _could_ have been done independently does not 
change the plain fact that tools/kvm was immensely kernel 
focused.

Yes, it was unsolicited, yes you objected early on and loud 
enough, and the kernel did not ask for this integration to begin 
with - so there's not a hint of obligation on your part 
whatsoever, but that does not change development reality as it 
happened. I refuse to accept the rewriting of history.

> "sparse" is useful for kernel development. "git" is useful for 
> kernel development. "xterm" is useful for kernel development.

That argument is silly beyond belief. Read this list:

  - tools/kvm
  - sparse
  - git
  - xterm
  - perf

Which two tools in this list:

 - Use and focus on Linux specific system calls to provide Linux
   specific functionality?

 - Are never - and will conceivably never - run on any kernel
   which is not extremely Linux compatible?

 - Provide essential features that need serious, tool specific
   kernel side support?

 - Were used directly to create integrated features that add 
   features BOTH to the kernel and the tool, at once?

I know that this discussion is not about changing your mind 
anymore - every further email probably does the opposite.
I would accept many other arguments from you:

 - you feel uneasy about growing the kernel into any sort of 
   platform. I would disagree but it's a fair argument.

 - you think kernel developers should not do user-space 
   development and there should be a 'chinese wall' of ignorance
   and a project boundary or two between them. I would disagree 
   but it's a fair argument.

 - you think Qemu is better and is the official kernel side KVM 
   tool, and even if it's not better, it's (much) more complete 
   and a schizm is bad. It's a fair argument that I'd somewhat 
   agree with.

 - you feel that if a tool cannot survive in the harsh realities 
   of the sourceforge or github ghetto, succeeding in 
   establishing itself and then hurting generations of
   users with inconsistent, uncoordinated tinkerware, no matter 
   how Linux kernel centric the tool is conceptually, then it
   does not deserve to live at all. I would disagree but it
   would be a fair argument.

 - you feel the kernel should be fundamentally tool neutral, 
   even if the lack of coherence and elongated coordination is
   hurting the kernel, tools, developers and users. I'd disagree
   with that but it would be a fair argument.

but stop the "integration did not benefit the kernel" or 
"integration did not benefit the tool" crap please, it's 
insulting. Both claims are false even if you ignore the 
tools/perf example that shows the possible.

Thanks,

	Ingo
