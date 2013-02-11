Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab3BKRlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:41:17 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:43652 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab3BKRlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:41:15 -0500
Date: Mon, 11 Feb 2013 18:41:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-ID: <20130211174111.GB9716@gmail.com>
References: <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
 <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
 <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
 <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
 <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
 <20130211122654.GA5802@gmail.com>
 <20130211125627.GA7583@gmail.com>
 <1360588699.7383.52.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360588699.7383.52.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2013-02-11 at 13:56 +0100, Ingo Molnar wrote:
> > To use another, perhaps more applicable analogy:
> > 
> > If one has the choice to start a new business in the U.S., it 
> > would be reasonable to do that. There's a lot of supporting 
> > infrastructure, trust, distribution, standards, enforcement 
> > agencies and available workers.
> > 
> > Could the same business succeed in Somalia as well? Possibly - 
> > if it's a bakery or something similarly fundamental. More 
> > complex businesses would likely not thrive very well there.
> > 
> > *That* is how I think the current Linux kernel tooling landscape 
> > looks like currently in a fair number of places: in many aspects 
> > it's similar to Somalia - disjunct entities with not much 
> > commonality or shared infrastructure.
> 
> That's complete nonsense. If you want to use pieces of the 
> kernel infrastructure, then just *take* them. [...]

So I can take the mailing lists and the whole contribution 
culture? Hardly...

I was not talking about code alone, I was also talking about a 
social environment - which is not a one sided relationship at 
all, it improves the kernel code, like it already did for over 
two dozen tools/kvm originated patches:

To quote from my mail to Linus:

"
 - Pekka listed new virtio drivers that were done via tools/kvm.

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
   that tools/perf/ itself uses.)

Those were all real benefits to the kernel which are upstream or
almost upstream today.

This tool alone generated a *more* versatile number of
improvements to the kernel than the majority of filesystems and
the majority of drivers in the Linux kernel tree today has ever
achieved. "

> [...] There are loads of projects which use the kernel config 
> tools, for example. There's no need to be *in* the kernel 
> repo.
> 
> And for code-reuse it's even easy enough to automatically 
> extract parts of kernel code into a separate repository. [...]

... which solution would:

 - lose all history
 - lose contributor awareness of each other
 - lose easy cross-contribution pathways

That's a severe net minus in my opinion.

I think you should try to answer the very fundamental 
observation I made and the question I asked in my mail to Tytso:

"
We have first hand experience there: tools/perf/.

None of the predicted extreme badness happened. Yes, sometimes 
we broke compatibility as ABI changes/enhancements do - but 
treated them as regressions and fixed them. I also think that 
considering the rate of changes our breakage ratio is very good.

So no badness happened, and in fact a lot of goodness happened: 
which goodness never happened while Linux profiling was a 
separate project isolated as a user-space utility!

Anyone opposing integration I think *HAS* to explain the 
mechanics behind this very example in plain sight.

Why the heck has pretty much every other out of tree profiling 
project died, while the in-tree one is thriving?

Yes, the key is that Arnaldo is good, and so are the other perf 
contributors - and they are good because they feel at home and 
they are productive. Being in the kernel repo is actually 90% 
responsible for that environment!
"

And yes, based on the evidence I think much of perf's current 
vitality would be killed off or would be severely reduced if it 
was forced into a separate, out of tree project.

Thanks,

	Ingo
