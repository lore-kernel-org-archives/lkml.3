Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3FYCPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 22:15:32 -0400
Received: from mail1.windriver.com ([147.11.146.13]:61064 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FYCPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 22:15:31 -0400
Date: Mon, 24 Jun 2013 22:16:01 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, <x86@kernel.org>
Subject: Re: [PATCH 23/32] x86: delete __cpuinit usage from all x86 files
Message-ID: <20130625021601.GC26481@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
 <1372102237-8757-24-git-send-email-paul.gortmaker@windriver.com>
 <51C8D24A.1000202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51C8D24A.1000202@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH 23/32] x86: delete __cpuinit usage from all x86 files] On 24/06/2013 (Mon 16:12) H. Peter Anvin wrote:

> On 06/24/2013 12:30 PM, Paul Gortmaker wrote:
> > The __cpuinit type of throwaway sections might have made sense
> > some time ago when RAM was more constrained, but now the savings
> > do not offset the cost and complications.  For example, the fix in
> > commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
> > is a good example of the nasty type of bugs that can be created
> > with improper use of the various __init prefixes.
> > 
> > After a discussion on LKML[1] it was decided that cpuinit should go
> > the way of devinit and be phased out.  Once all the users are gone,
> > we can then finally remove the macros themselves from linux/init.h.
> > 
> > Note that some harmless section mismatch warnings may result, since
> > notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
> > are flagged as __cpuinit  -- so if we remove the __cpuinit from
> > arch specific callers, we will also get section mismatch warnings.
> > As an intermediate step, we intend to turn the linux/init.h cpuinit
> > content into no-ops as early as possible, since that will get rid
> > of these warnings.  In any case, they are temporary and harmless.
> > 
> > This removes all the arch/x86 uses of the __cpuinit macros from
> > all C files.  x86 only had the one __CPUINIT used in assembly files,
> > and it wasn't paired off with a .previous or a __FINIT, so we can
> > delete it directly w/o any corresponding additional change there.
> > 
> > [1] https://lkml.org/lkml/2013/5/20/589
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: x86@kernel.org
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > ---
> > 
> 
> Acked-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> Do you want me to carry this or are you planning to push the entire
> thing as a single patchset?

Short answer -- I'll carry it unless you expect massive changes
still pending to arch/x86 (which I highly doubt) and really want
to carry it.

I'm fine with carrying most/all of it as a patch queue, however
some folks expected significant churn in their tree and wanted to
handle the conflicts/refreshes themselves.  But I'm fine with keeping
things up to date with the latest linux-next and doing the trivial
refreshes on the series until the merge window closes out and the
remaining 99% of it goes in tree.

Paul.
--

> 
> 	-hpa
> 
> 
