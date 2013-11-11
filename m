Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab3KKRu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:50:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab3KKRuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:50:22 -0500
Date: Mon, 11 Nov 2013 18:51:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: suravee.suthikulpanit@amd.com, mingo@kernel.org, mingo@redhat.com,
        jacob.w.shin@gmail.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hpa@zytor.com, tgl@domain.invalid,
        linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
	HW_BREAKPOINT_LEN_8
Message-ID: <20131111175131.GA14906@redhat.com>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com> <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com> <20131108194122.GA14606@localhost.localdomain> <20131109151156.GA14249@redhat.com> <20131109153236.GE26079@localhost.localdomain> <20131109155428.GA15649@redhat.com> <20131111154417.GD26853@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111154417.GD26853@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Frederic Weisbecker wrote:
>
> On Sat, Nov 09, 2013 at 04:54:28PM +0100, Oleg Nesterov wrote:
> >
> > Up to you and Suravee, but can't we cleanup this later?
> >
> > This series was updated many times to address a lot of (sometimes
> > contradictory) complaints.
>
> Sure. But I'm confident that we can solve the conflicting mask / len issue easily beside.
> I mean, I don't feel confident with merging things as is, otoh it should be easy to fix up.

I do not really understand where do you see the conflict...

I can be easily wrong, but afaics currently mask / len issue is simply
the implementation detail.

> > > I mean, that doesn't look right to me,
> > > it's two units basically measuring the same thing, so that's asking for conflicting troubles.
> >
> > Yes. And we can kill either _len or _mask, not sure what would be more
> > clean.
> >
> > At least with the current implementation (again, iirc) mask == len -1.
> > Although amd supports the more generic masks (but I can't recall the
> > details).
>
> Right. I think len is probably more powerful. Unless the mask could be used to define
> multiple ranges of breakpoints, not sure it's ever going to be used that way though.

Actually, mask is more powerfull. And initial versions of this patches
(iirc) tried to use mask as an argument which comes from the userspace
(tools/perf, perf_event_attr, etc). But one of reviewers nacked this
interfacer, so we still use len.

> But we
> can still extend the interface if we need a mask later.

Yes, agreed.

> > > I'm just not sure how to reuse the len to express breakpoint ranges (that was in fact the
> > > initial purpose of it) without breaking the tools.
> >
> > Confused... user-space still uses len to express the range? Just
> > the kernel "switches" to mask if len > 8 ?
>
> Right but what if we want breakpoints having a size below 8? Like break on instructions
> from 0x1000 to 0x1008 ?
>
> Or should we ignore range instruction breakpoints when len < 8?

In this case the new code has no effect (iirc), we simply use
X86_BREAKPOINT_LEN_* and "tell the hardware about extended range/mask"
code is never called. IIRC, currently we simply check bp_mask != 0
to distinguish.

Oleg.

