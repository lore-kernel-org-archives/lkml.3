Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3JaQsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:48:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226Ab3JaQsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:48:24 -0400
Date: Thu, 31 Oct 2013 17:49:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: suravee.suthikulpanit@amd.com, mingo@kernel.org, mingo@redhat.com,
        jacob.w.shin@gmail.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hpa@zytor.com, tgl@domain.invalid,
        linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
	HW_BREAKPOINT_LEN_8
Message-ID: <20131031164950.GA6548@redhat.com>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com> <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com> <20131031095829.GE2253@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031095829.GE2253@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31, Frederic Weisbecker wrote:
>
> On Wed, Oct 02, 2013 at 11:11:06AM -0500, suravee.suthikulpanit@amd.com wrote:
> > --- a/arch/x86/include/asm/hw_breakpoint.h
> > +++ b/arch/x86/include/asm/hw_breakpoint.h
> > @@ -12,6 +12,7 @@
> >   */
> >  struct arch_hw_breakpoint {
> >  	unsigned long	address;
> > +	unsigned long	mask;
> >  	u8		len;
>
> So it's a bit sad that we have both len and mask.

Yes, we can probably remove it later, in fact iirc it is not strictly
necessary right now. But this is minor, we can do this later and the
code looks simpler this way.

> thing that is actually buggy for instruction breakpoints and needs to
> be sizeof(long) (who knows
> what kind of fluorescent bier I drank before writing that).
>
> But Oleg had a patch to fix that.

Yes, we already discussed some draft patches. And one of the problems
was this series. I mean, the changes we discussed conflict with these
patches, I think we should fix this after this series is merged.

Oleg.

