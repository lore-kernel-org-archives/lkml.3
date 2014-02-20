Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaBTPuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:50:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37441 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbaBTPuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:50:54 -0500
Date: Thu, 20 Feb 2014 16:50:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
Message-ID: <20140220155041.GG9987@twins.programming.kicks-ass.net>
References: <52FCFA23.4060701@canonical.com>
 <20140213173852.GH6835@laptop.programming.kicks-ass.net>
 <52FD090C.7010408@canonical.com>
 <20140213182605.GC14089@laptop.programming.kicks-ass.net>
 <20140214133428.GB26356@pd.tnic>
 <52FE2709.3050505@canonical.com>
 <20140214144700.GC26356@pd.tnic>
 <52FE4C28.1080500@canonical.com>
 <20140214172157.GJ6835@laptop.programming.kicks-ass.net>
 <53062165.3040202@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53062165.3040202@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 04:38:13PM +0100, Stefan Bader wrote:
> On 14.02.2014 18:21, Peter Zijlstra wrote:
> > On Fri, Feb 14, 2014 at 06:02:32PM +0100, Stefan Bader wrote:
> >> One thing I likely should do is to reinstall the exact same laptop with 64bit
> >> kernel and userspace... maybe only 64bit kernel first... and make sure on my
> >> side that this does not show up on 64bit, too. I took the word of reporters for
> >> that (and the impression that otherwise many more people would have complained).
> > 
> > Yeha, I'm going to try and install some 32bit userspace on a usb
> > harddisk I've got and see if I can boot my Core2 laptop from that to try
> > and reproduce.
> > 
> > But all that is probably going to be Monday :/
> > 
> *sigh* Already Thursday...
> 
> Peter, did you get to reproduce this locally? Unfortunately I had some
> interruption and have not more Information than on last Friday (which is that
> the same hw but 64bit kernel does not show it).

I got side-tracked as well, someone reported crashes, which come above
weird behaviour :/

> Meanwhile I wonder whether it would make sense to push the following (or more?)
> to stable for 3.13.y:
> 
> 1) 16824255394f55adf31b9a96a9965d8c15bdac4c
>    x86, acpi, idle: Restructure the mwait idle routines
> 2) 7e98b71920464b8d15fa95c74366416cd3c88861
>    x86, idle: Use static_cpu_has() for CLFLUSH workaround, add barriers
> 3) 8cb75e0c4ec9786b81439761eac1d18d4a931af3
>    sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
> 4) 215393bc1fab3d61a5a296838bdffce22f27ffda
>    sched/preempt/x86: Fix voluntary preempt for x86
> 
> 1+2 would be to avoid touching 3 too much and looked to be improvements on their
> own. 3+4 would be cherry-picks if not for some fuzz 2.

I'll not object; but if someone wants a smaller set you could do with
just the idle.c hunk from 3.

> I saw a few more things labelled preempt between 3.13 and current HEAD but am
> not sure whether or which of those are strictly required. Namely some fixing to
> preempt_enable_no_resched() mis-usage and maybe one fixing an issue of ftrace
> locking up.

Yeah, that's all fresh breakage and doesn't go back to 3.13 I think.
