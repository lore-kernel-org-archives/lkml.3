Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab3BKR2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:28:13 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:50740 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211Ab3BKR2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:28:11 -0500
Date: Mon, 11 Feb 2013 18:28:07 +0100
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
Message-ID: <20130211172807.GA9716@gmail.com>
References: <20130208145539.GC30334@gmail.com>
 <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
 <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
 <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
 <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
 <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
 <20130211122654.GA5802@gmail.com>
 <CA+55aFwq+_TvOZNEPO-eFPjYuPuMFL0bgR0x=nLq_tvfATqaTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwq+_TvOZNEPO-eFPjYuPuMFL0bgR0x=nLq_tvfATqaTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Feb 11, 2013 at 4:26 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > If you are asking whether it is critical for the kernel 
> > project to have tools/kvm/ integrated then it isn't. The 
> > kernel will live just fine without it, even if that decision 
> > is a mistake.
> 
> You go on to explain how this helps kvmtool, and quite 
> frankly, I DO NOT CARE.

Me and Pekka also listed several examples of how it already 
helped the kernel, despite it only being partially present in 
some kernel repos:

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
achieved.

How on earth can anyone, against all that evidence, still claim 
that it's a net minus?

> Everything you talk about is about helping your work, by 
> making the kernel maintenance be more. The fact that you want 
> to use kernel infrastructure in kvmtool is a great example: 
> you may think it's a great thing, but for the kernel it's just 
> extra work, and extra layers of abstraction etc etc.

At least in the case of lockdep, the kernel side change enabling 
it was a trivial:

  kernel/lockdep.c | 4 ++++
  1 file changed, 4 insertions(+)

... but we could probably make even that interaction go away and 
make it exactly zero, and push all the changes on to the 
liblockdep side.

Anyway, should I consider user space lockdep NAK-ed too in this 
form, before we put any more work into it?

> And then you make it clear that you haven't even *bothered* to 
> try to make it a separate project.

Just like back in the days you haven't even bothered to make 
Linux a proper GNU project, and for good reasons. Nor have I 
ever tried to write scheduler code for another OS.

Some expensive, disruptive things you don't "try" because you 
disagree with the model, on what you think to be valid grounds. 
You make a judgement call, you take your chances, and you see 
whether it works.

> Sorry, but with that kind of approach, I get less and less 
> interested. I think this whole tying together is a big 
> mistake. It encourages linkages that simply shouldn't be 
> there.
> 
> And no, perf is not the perfect counter-example. With perf,. 
> the linkages made sense! There's supposed to be deep linkages 
> to profiling and event counting. There is ABSOLUTELY NOT 
> supposed to be deep linkages with virtualization. Quite the 
> reverse.

I'm *really* surprised that you say that.

perf interfaces to the Linux kernel in a very similar way to how 
tools/kvm interfaces to the Linux kernel: both use (very) Linux 
specific system calls to run on a host system running the Linux 
kernel.

Neither tool will in the foreseeable future execute on any 
other, non-Linux host kernel.

( Running non-Linux guest OS's is an entirely different matter
  and there's no fundamental restriction there. )

tools/perf/ is not in the kernel because it interfaces with the 
kernel in nasty, incestous ways.

It is in the kernel mainly because that's the contribution model 
that turned out to work well for both the kernel and the tooling 
side:

I initially made the user-space bits of perf a separate project. 
I didn't run it in that form for a long time, but I got 
essentially zero contributions. The moment it went into a silly 
directory in Documentation/perf_counters/, contributions started 
trickling in. Today it's fully embraced by the kernel side 
subsystem and allows very efficient interface enhancements on 
the kernel and tooling side, in lock-step - benefiting both 
sides significantly.

> And no, I don't want to maintain the mess that is both. 
> There's just no gain, and lots of potential pain.

I disagree, and I don't see the validity of most of your 
arguments, but it's obviously your call.

Thanks,

	Ingo
