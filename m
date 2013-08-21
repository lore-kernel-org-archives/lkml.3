Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3HUVUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:20:05 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:36350 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3HUVUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:20:03 -0400
Date: Wed, 21 Aug 2013 23:20:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: linux-next: Tree for Aug 21 [ screen corruption in graphical
 mode ]
Message-ID: <20130821212012.GH26909@phenom.ffwll.local>
Mail-Followup-To: Sedat Dilek <sedat.dilek@gmail.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	linux-next <linux-next@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>
References: <CA+icZUUkS-UptLRM1CfcaHH=8UD-ZaHbXr8wFkA+YKyk-rPjvg@mail.gmail.com>
 <20130821134441.GE26909@phenom.ffwll.local>
 <CA+icZUVLau7AgZvcnWKjx=tc4WeuJ3qEH7qQta+YLKDmxk6QvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVLau7AgZvcnWKjx=tc4WeuJ3qEH7qQta+YLKDmxk6QvA@mail.gmail.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 08:11:27PM +0200, Sedat Dilek wrote:
> On Wed, Aug 21, 2013 at 3:44 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Wed, Aug 21, 2013 at 12:35:08PM +0200, Sedat Dilek wrote:
> >> On Wed, Aug 21, 2013 at 11:21 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >> > Hi all,
> >> >
> >> > There will be no linux-next trees on Aug 23 or 26.
> >> >
> >> > Changes since 20130820:
> >> >
> >> > New tree: aio-direct
> >> >
> >> > Removed tree: xilinx (at maintainer's request)
> >> >
> >> > The xfs tree still had its build failure for which I reverted a commit.
> >> >
> >> > The trivial tree gained conflicts against the crypto, net-next and
> >> > wireless trees.
> >> >
> >> > The aio tree gained conflicts against the aio-direct tree.
> >> >
> >> > The akpm-current tree gained conflicts against the modules and aio-direct
> >> > trees.
> >> >
> >> > ----------------------------------------------------------------------------
> >> >
> >>
> >> Hi,
> >>
> >> I still have this issue with next-20130821 and "Linux v3.11-rc6 plus
> >> drm-intel-nightly on top"
> >> Any new development on this?
> >> Patches?
> >
> > Tbh I'm at a loss what we could try above&beyond what Chris has already
> > tried out.
> >
> >> Currently, I have two workarounds:
> >>
> >> [1] Revert this commit:
> >>
> >> commit 5456fe3882812aba251886e36fe55bfefb8e8829
> >> "drm/i915: Allocate LLC ringbuffers from stolen"
> >
> > Since with a rather decent chance the next testing cycle I'll do this
> > friday will be the last chunk of features for 3.12 I'll probably drop the
> > above patch from my queue and we can try again in 3.13.
> >
> 
> Inspired by [1] I have switched from UXA to SNA...
> ...and applied "[PATCH] drm/i915: Cleaning up the relocate entry
> function" on top of next-20130821...
> ...and can NOT see the screen corruptions anymore.
> 
> Can you explain that?

If the relocate cleanup patch [1] is indeed required, then I can't explain
this at all. Can you please double-check that this is really it, and that
it's not the uxa->sna switch?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
