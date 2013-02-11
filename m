Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3BKM4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:56:33 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:63423 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab3BKM4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:56:31 -0500
Date: Mon, 11 Feb 2013 13:56:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-ID: <20130211125627.GA7583@gmail.com>
References: <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
 <20130208145539.GC30334@gmail.com>
 <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
 <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
 <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
 <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
 <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
 <20130211122654.GA5802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211122654.GA5802@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> [...]
>
>  - he ended up gradually validating whether lockdep could be 
>    ported to user-space. He first used 'messy' integration: 
>    kernel/lockdep.c hacked up badly and linked directly into 
>    user-space app. Then he did 'clean' integration: some 
>    modifications to kernel/lockdep.c enabled it to be 
>    librarified, and then the remaining work was done in 
>    user-space - here too in successive steps.
> 
>  - tools/kvm/ happened to be hosted in the same kernel repo
>    that the locking tree is hosted in.
> 
> The end result is something good that I never saw happen to 
> kernel code before, in the last 20 years of the Linux kernel. 
> Maybe it could have happened with an outside tools/kvm repo, 
> but I very strongly suspect that it would not.
> 
> In theory this could have been done in the cold, fragmented, 
> isolated and desolate landscape of Linux user-space utilities, 
> by copying kernel/lockdep.c and a handful of kernel headers to 
> user-space, and making it work there somehow.
> 
> Just like a blue rose could in theory grow on Antarctica as 
> well, given the right set of circumstances. It just so happens 
> that blue roses best grow in Holland, where there's good 
> support infrastructure for growing green stuff, while you'd 
> have to look hard to find any green stuff at all on 
> Antarctica.

To use another, perhaps more applicable analogy:

If one has the choice to start a new business in the U.S., it 
would be reasonable to do that. There's a lot of supporting 
infrastructure, trust, distribution, standards, enforcement 
agencies and available workers.

Could the same business succeed in Somalia as well? Possibly - 
if it's a bakery or something similarly fundamental. More 
complex businesses would likely not thrive very well there.

*That* is how I think the current Linux kernel tooling landscape 
looks like currently in a fair number of places: in many aspects 
it's similar to Somalia - disjunct entities with not much 
commonality or shared infrastructure.

Why people question the desire for a kernel related project 
(that only runs on a Linux host) to actually be part of an 
already well working, civilized society (the kernel repo) - for 
mutual, well documented benefits - instead of having to grow it 
all itself, is rather perplexing to me...

Thanks,

	Ingo
