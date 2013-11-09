Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab3KIPcm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:32:42 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:40175 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab3KIPcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:32:41 -0500
Date: Sat, 9 Nov 2013 16:32:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: suravee.suthikulpanit@amd.com, mingo@kernel.org, mingo@redhat.com,
        jacob.w.shin@gmail.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hpa@zytor.com, tgl@domain.invalid,
        linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20131109153236.GE26079@localhost.localdomain>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20131108194122.GA14606@localhost.localdomain>
 <20131109151156.GA14249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109151156.GA14249@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 04:11:56PM +0100, Oleg Nesterov wrote:
> On 11/08, Frederic Weisbecker wrote:
> >
> > On Wed, Oct 02, 2013 at 11:11:06AM -0500, suravee.suthikulpanit@amd.com wrote:
> > >
> > > diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> > > index d3f5c63..26609bb 100644
> > > --- a/arch/x86/include/asm/cpufeature.h
> > > +++ b/arch/x86/include/asm/cpufeature.h
> > > @@ -170,6 +170,7 @@
> > >  #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
> > >  #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
> > >  #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
> > > +#define X86_FEATURE_BPEXT	(6*32+26) /* data breakpoint extension */
> >
> > Does this feature only work on data breakpoint or is instruction breakpoint
> > address range supported as well?
> 
> IIRC, execute range is supported as well.
> 
> But. I can't look at the code now, but iirc this can't really work until
> we fix the (already discussed) problems with bp_len && X86_BREAKPOINT_LEN_X.
> IOW, we should not blame these patches if it doesn't work.

Yeah, don't worry I don't plan to push back these patches for the sake of that bug,
that would be definetly unfair, especially as I introduced that issue :)

And the patchset looks good overall, except for a few details but it's mostly ok,
I just would like to fix that issue along the way. It would be really nice if we can
avoid having a mask _and_ a len for breakpoints. I mean, that doesn't look right to me,
it's two units basically measuring the same thing, so that's asking for conflicting troubles.

I'm just not sure how to reuse the len to express breakpoint ranges (that was in fact the
initial purpose of it) without breaking the tools.

Any idea?
