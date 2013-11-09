Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3KIPxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:53:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab3KIPxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:53:09 -0500
Date: Sat, 9 Nov 2013 16:54:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: suravee.suthikulpanit@amd.com, mingo@kernel.org, mingo@redhat.com,
        jacob.w.shin@gmail.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hpa@zytor.com, tgl@domain.invalid,
        linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
	HW_BREAKPOINT_LEN_8
Message-ID: <20131109155428.GA15649@redhat.com>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com> <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com> <20131108194122.GA14606@localhost.localdomain> <20131109151156.GA14249@redhat.com> <20131109153236.GE26079@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109153236.GE26079@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just in case let me repeat, I can be easily wrong because I forgot
how this series actually look and I don't have the patches now ;)

On 11/09, Frederic Weisbecker wrote:
>
> On Sat, Nov 09, 2013 at 04:11:56PM +0100, Oleg Nesterov wrote:
> > On 11/08, Frederic Weisbecker wrote:
> > >
> > >
> > > Does this feature only work on data breakpoint or is instruction breakpoint
> > > address range supported as well?
> >
> > IIRC, execute range is supported as well.
> >
> > But. I can't look at the code now, but iirc this can't really work until
> > we fix the (already discussed) problems with bp_len && X86_BREAKPOINT_LEN_X.
> > IOW, we should not blame these patches if it doesn't work.
>
> Yeah, don't worry I don't plan to push back these patches for the sake of that bug,
> that would be definetly unfair, especially as I introduced that issue :)
>
> And the patchset looks good overall, except for a few details but it's mostly ok,

OK,

> I just would like to fix that issue along the way. It would be really nice if we can
> avoid having a mask _and_ a len for breakpoints.

Up to you and Suravee, but can't we cleanup this later?

This series was updated many times to address a lot of (sometimes
contradictory) complaints.

> I mean, that doesn't look right to me,
> it's two units basically measuring the same thing, so that's asking for conflicting troubles.

Yes. And we can kill either _len or _mask, not sure what would be more
clean.

At least with the current implementation (again, iirc) mask == len -1.
Although amd supports the more generic masks (but I can't recall the
details).

> I'm just not sure how to reuse the len to express breakpoint ranges (that was in fact the
> initial purpose of it) without breaking the tools.

Confused... user-space still uses len to express the range? Just
the kernel "switches" to mask if len > 8 ?

Oleg.

