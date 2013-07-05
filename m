Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3GEG1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:27:13 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:52852 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3GEG1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:27:12 -0400
Date: Fri, 5 Jul 2013 08:27:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.11
Message-ID: <20130705062708.GB29487@gmail.com>
References: <20130701090356.GA14912@gmail.com>
 <CA+55aFwJwYRbPBBN1ma8TBHuomo_AJjajxT6YDmdGXJdE4EgrQ@mail.gmail.com>
 <20130703075542.GF23916@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703075542.GF23916@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Jul 02, 2013 at 05:50:29PM -0700, Linus Torvalds wrote:
> > On Mon, Jul 1, 2013 at 2:03 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus
> > >
> > > Kernel improvements:
> > >
> > >  * AMD IOMMU uncore PMU support by Suravee Suthikulpanit001a
> > 
> > This one prints a really annoying error message if you're not on an
> > AMD platform:
> > 
> > +       if (!amd_iommu_pc_supported()) {
> > +               pr_err("perf: amd_iommu PMU not installed. No support!\n");
> > +               return -ENODEV;
> > +       }
> > 
> > and you know what? That's not acceptable. It damn well is *not* an
> > error to not have an AMD IOMMU.
> > 
> > It should - at most - be a pr_info(). Maybe nothing at all. "pr_err()"
> > is just totally out of line.
> 
> Quite; it prints enough stuff when it does find one so I'm all for 
> scrapping that one print when it doesn't find it.
> 
> Sorry for not seeing that; when I initially read that code I thought it 
> was for the case where the hardware was expected to have the device but 
> we couldn't find it for some weird reason.
> 
> ---
> Subject: perf, amd: Do not print an error when the device is not present
> 
> As Linus said its not an error to not have an AMD IOMMU; esp. when you're not
> even running on an AMD platform.
> 
> Requested-by: Linus Torvalds <torvalds@linux-foundation.org>

Applied to perf/urgent, thanks!

( The pedantic in me changed that tag to Reported-by as we treat console 
  spam as bugs. )

Thanks,

	Ingo
