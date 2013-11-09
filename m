Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3KIPKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:10:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab3KIPKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:10:37 -0500
Date: Sat, 9 Nov 2013 16:11:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: suravee.suthikulpanit@amd.com, mingo@kernel.org, mingo@redhat.com,
        jacob.w.shin@gmail.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hpa@zytor.com, tgl@domain.invalid,
        linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
	HW_BREAKPOINT_LEN_8
Message-ID: <20131109151156.GA14249@redhat.com>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com> <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com> <20131108194122.GA14606@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108194122.GA14606@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Frederic Weisbecker wrote:
>
> On Wed, Oct 02, 2013 at 11:11:06AM -0500, suravee.suthikulpanit@amd.com wrote:
> >
> > diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> > index d3f5c63..26609bb 100644
> > --- a/arch/x86/include/asm/cpufeature.h
> > +++ b/arch/x86/include/asm/cpufeature.h
> > @@ -170,6 +170,7 @@
> >  #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
> >  #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
> >  #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
> > +#define X86_FEATURE_BPEXT	(6*32+26) /* data breakpoint extension */
>
> Does this feature only work on data breakpoint or is instruction breakpoint
> address range supported as well?

IIRC, execute range is supported as well.

But. I can't look at the code now, but iirc this can't really work until
we fix the (already discussed) problems with bp_len && X86_BREAKPOINT_LEN_X.
IOW, we should not blame these patches if it doesn't work.

Oleg.

