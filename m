Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbaCKKN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:13:58 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:58996 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaCKKLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:33 -0400
Date: Tue, 11 Mar 2014 11:11:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at
 d34bd000
Message-ID: <20140311101129.GA10383@gmail.com>
References: <531D044C.2090303@linux.intel.com>
 <CALCETrXJobOnVB-ne9s57o3Z1KwK4fRtaYi8W=L4+UT065fKJw@mail.gmail.com>
 <CALCETrUyJWQnQsX22+wrvPbXkj67nhZ0SMP1_hCo2yZ+Z5tMyA@mail.gmail.com>
 <531DD35A.5060202@linux.intel.com>
 <CA+55aFwKpBybz9S9A=+tcr1BbdzAbagL30Br2cak2GrdPH=hhA@mail.gmail.com>
 <CALCETrW6CT2ceHiHzMaZUGkwEBFWQEemFS5Fj=V7Wg-cNArMLg@mail.gmail.com>
 <1394481804.980.9.camel@wall-e.seibold.net>
 <531E1B53.5090205@linux.intel.com>
 <CA+55aFyxbuhPKgB=U8R5C5T_iKVvju-oQDS4kHz6McW45B+1bA@mail.gmail.com>
 <CA+55aFwuVYds=ssv755WKBvux1ru6fcDLGi+ORSFyU8xYP7+=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwuVYds=ssv755WKBvux1ru6fcDLGi+ORSFyU8xYP7+=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Mar 10, 2014 at 1:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > If the only immediate problem is the code generation size, then Andy
> > already had a (simpler) hack-around:
> >
> >   #undef CONFIG_OPTIMIZE_INLINING
> >   #undef CONFIG_X86_PPRO_FENCE
> >
> > in vclock_gettime.c
> 
> Btw, we should seriously consider getting rid of CONFIG_X86_PPRO_FENCE.
> 
> It was of questionable value to begin with, and I think that the
> actual PPro bug is about one of
> 
>  - Errata 66, "Delayed line invalidation".
>  - Errata 92, "Potential loss of data coherency"
> 
> both of which affect all PPro versions afaik (there is also a UP 
> errata 51 wrt ordering of cached and uncached accesses that was 
> fixed in the sB1 stepping).
>
> And as far as I know, we have never actually seen the bug in real 
> life, EVEN WHEN PPRO WAS COMMON. The workaround was always based on 
> knowledge of the errata afaik.

I'm not aware of any active PPro testers either. Even P4 feedback has 
become very rare. New systems have become so cheap and so fast, and 
energy use an issue, that there's very little upside left to using old 
CPUs, other than the vintage thrill factor.

But ... when PPro was common our parallelization sucked, so I'd not be 
surprised if it triggered more frequently with a modern kernel.

Still I agree that it most likely does not matter:

> So I do think we might want to consider retiring that config option 
> entirely as a "historical oddity".

Ack.

> And very much so for the vdso case. Do we even do the asm 
> alternative fixups for the vdso?
> 
> I also suspect we should get rid of CONFIG_X86_OOSTORE, or at least 
> limit it to !SMP - I don't think anybody ever made SMP systems with 
> those IDT/Centaur Winchip chips in them.

Yeah.

Thanks,

	Ingo
