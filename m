Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab3GZJCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:02:50 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39512 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3GZJCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:02:47 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKMK7uGb5=-Ur4hJiVAviYeGKpup0ScHzsf436jHXEsKar+bCQ@mail.gmail.com>
References: <20130725192248.GA13295@cantiga.alporthouse.com>
	<CA+icZUVE3s=6vXTLsCSmdLe_HMTOj+VD317kDeH3tF7svVW8kQ@mail.gmail.com>
	<CA+icZUU__nxcuX4RF9EBGm0nMBFaxfWpH00b2=ZsZZaxo9iscw@mail.gmail.com>
	<20130725215259.GB13295@cantiga.alporthouse.com>
	<CA+icZUXZKndg7==Y6v2Z45WZDp+tDC5FzaOC=KWTf4m=rjUKnA@mail.gmail.com>
	<20130725232556.GF13295@cantiga.alporthouse.com>
	<CA+icZUUBhW=KnAt0yn3CgEAzUhOfE=1ADUbCshFqrdZ5urEgbw@mail.gmail.com>
	<20130726072646.GH13295@cantiga.alporthouse.com>
	<CA+icZUXuj1O3oUvr_43BZDD_ikWyY9GxfOdzb3GLWJ1X1hvxyQ@mail.gmail.com>
	<CA+icZUWJynMr-OvXwN+2eRxWWOpt2s1-Q5UMrRt3rXDcCJpwkA@mail.gmail.com>
	<20130726085035.GJ13295@cantiga.alporthouse.com>
	<CAKMK7uGb5=-Ur4hJiVAviYeGKpup0ScHzsf436jHXEsKar+bCQ@mail.gmail.com>
Date: Fri, 26 Jul 2013 11:02:45 +0200
Message-ID: <CA+icZUUZa=_nW1V6s_CVXNxCMPnxj-6vF+VafbPev3VpsCjfEg@mail.gmail.com>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 10:52 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Fri, Jul 26, 2013 at 10:50 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> On Fri, Jul 26, 2013 at 10:27:03AM +0200, Sedat Dilek wrote:
>>> On Fri, Jul 26, 2013 at 10:25 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> > ...
>>> > ... but does not start as well, so it seems to be a kernel-issue as
>>> > assumed (2nd confirmation).
>>> >
>>> > X.log attached.
>>> >
>>>
>>> Now, really w/ promised attachment.
>>
>> Yes, same failure (GTT mmaps) but at a later point, and UXA has no
>> fallback plan.
>
> I'm running igt on my machines here to prep a new -next test cycle,
> and gtt mmaps seem to fail across the board :( Currently I'd wager
> that the vma offset manager is the culprit, since I've only recently
> pulled that stuff in from drm-next.

So, I resetted next-20130726 to the merge-commit of
drm-intel/for-linux-next, which is as expected bad.

First, I looked w/ a Grrr at i915_gem_stolen.c with a focus on
"drm/i915: Use Graphics Base of Stolen Memory on all gen3+", but this
commit is also in next-20130725.

Yeah, might be the stuff comes from the merge including vma stuff.

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/gpu/drm/i915/i915_gem_stolen.c?id=4867509d9269228f69273312298fea11f414ae54

- Sedat -

> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
