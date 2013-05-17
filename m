Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3EQJhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:37:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55896 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425Ab3EQJhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:37:01 -0400
Date: Fri, 17 May 2013 10:36:16 +0100
From: Will Deacon <will.deacon@arm.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Bug] ARM 'perf' regression by commit a43cb95d5
Message-ID: <20130517093616.GC23112@mudshark.cambridge.arm.com>
References: <CACVXFVPjo2dQpYPpqZS8GC8UPNzB5HLURpYm6-g1FOBbSUjDyA@mail.gmail.com>
 <20130517085530.GB22992@mudshark.cambridge.arm.com>
 <CACVXFVPEBXat3bPPuHzV535=xLoRMFd03Kjzp=NUF5E3KCq2=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPEBXat3bPPuHzV535=xLoRMFd03Kjzp=NUF5E3KCq2=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:27:05AM +0100, Ming Lei wrote:
> On Fri, May 17, 2013 at 4:55 PM, Will Deacon <will.deacon@arm.com> wrote:
> >
> > So it's still the morning and I haven't had my coffee yet, but I'm really
> > struggling to see what you're getting at. Why does this have anything to do
> > with perf?
> 
> I don't know, and I just report it out, :-)
> 
> I found the problem days ago, and until yesterday I had one more hours to
> git-bisect it, but the result is very frustrated.
> 
> >
> >> [1], 'perf top' mistaken output
> >> Samples: 17K of event 'cpu-clock', Event count (approx.): 3516532661
> >>  97.51%  [smsc95xx]            [k] 0x013645b8
> >>   0.21%  libc-2.15.so          [.] strstr
> >>   0.14%  libc-2.15.so          [.] strchr
> >>   0.12%  libc-2.15.so          [.] strcmp
> >
> > [...]
> >
> >> [2], 'perf top' correct output
> >> Samples: 46K of event 'cpu-clock', Event count (approx.): 937128704
> >>  96.44%  [kernel]            [k] cpuidle_enter_state
> >>   0.19%  libc-2.15.so        [.] strstr
> >>   0.16%  [kernel]            [k] kallsyms_expand_symbol.clone.0
> >>   0.13%  [kernel]            [k] _raw_spin_unlock_irq
> >
> > [...]
> >
> > Are you saying that the profile you're seeing is radically different,
> > rather than there being some formatting error that I can't spot? If so, that
> 
> Yes.
> 
> > sounds really strange and I can't see how the patch you mention is to
> > blame...
> >
> > If we want to persue this, I guess other obvious questions are: which kernel
> > are you running? Does this affect multiple architectures (your diff only
> 
> Either 3.10-rc1 or today's -next tree(3.10.0-rc1-next-20130516).
> 
> > changes ARM)? What's the workload which you are profiling?
> 
> I only tested it on Pandaboard, and no real workload, so you can see
> cpuidle_enter_state is the top frequent symbol.

It's probably easier if you choose a workload, otherwise it's difficult to
see what is `correct' and what is broken. For example, your broken output
seems to be in the smsc95xx driver, so assumedly there's a bunch of
networking going on whereas your other output is in cpuidle_enter_state.

We need an apples-for-apples comparison if you think there's a bug in the
kernel. Can you try profiling hackbench or something?

> Or could anyone else try to verify the problem on their own environment?

How are you running perf top?

Will
