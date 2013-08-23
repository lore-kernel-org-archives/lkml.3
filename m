Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab3HWIe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:34:57 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:55210 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754926Ab3HWIex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:34:53 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Fri, 23 Aug 2013 09:34:28 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for Aug 21 [ screen corruption in graphical
 mode ]
Message-ID: <20130823083428.GB21757@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	linux-next <linux-next@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>
References: <20130821134441.GE26909@phenom.ffwll.local>
 <CA+icZUVLau7AgZvcnWKjx=tc4WeuJ3qEH7qQta+YLKDmxk6QvA@mail.gmail.com>
 <20130821212012.GH26909@phenom.ffwll.local>
 <CA+icZUUoZ3WRNChLJ8vfP_MxJhTu2annkWCmB8jnqOxNKSEtOg@mail.gmail.com>
 <20130822072417.GM26909@phenom.ffwll.local>
 <CA+icZUXoebf4p1pp6wkaOMFbfVjjL1+wDbYF+SvLUjkm991Rcg@mail.gmail.com>
 <CAKMK7uG5AntN=nQ6TWUwNgXJh7tATu5TacccYah36sXnLAmAiQ@mail.gmail.com>
 <CAKMK7uHfPb67Mshczxv6aPwwjQMb-tFwmdg8aH0VVSHnSyLiwA@mail.gmail.com>
 <CA+icZUWy4V_6YSa_wMeZRZ=1w08YihumWXPikJdkiuPgkOb_mw@mail.gmail.com>
 <CA+icZUUm=k9-G2M8+V-QkL3Tkv=5LXy_pyRKFnVSFjzF_vsX=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUUm=k9-G2M8+V-QkL3Tkv=5LXy_pyRKFnVSFjzF_vsX=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 10:04:37AM +0200, Sedat Dilek wrote:
> On Fri, Aug 23, 2013 at 9:55 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> > On Thu, Aug 22, 2013 at 1:32 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >> On Thu, Aug 22, 2013 at 1:30 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> >>> On Thu, Aug 22, 2013 at 1:13 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >>>> dmesg (a lot of traces) and kernel-config attached.
> >>>>
> >>>> UXA causes still screen corruption.
> >>>
> >>> Hm, was only a slim chance that this patch would fix anything - I
> >>> think you'd always see an oops when you'd hit this bug instead of just
> >>> a bit of corruption.
> >>
> >> Ok, I think it's time to throw in the towel a bit. I've dropped
> >>
> >>
> >> commit d46f1c3f1372e3a72fab97c60480aa4a1084387f
> >> Author: Chris Wilson <chris@chris-wilson.co.uk>
> >> Date:   Thu Aug 8 14:41:06 2013 +0100
> >>
> >>     drm/i915: Allow the GPU to cache stolen memory

Hmm, wrong patch. Unless you have a good reason, you just want to drop
the ringbuffers in stolen.

> >> from my queue. I guess we can retry for 3.13 again.
> >
> > I am sorry to keep someone's work to be delayed, really.
> > I would have liked to see this fixed (and I have spent some time on it).

It's just a minor memory optimization (reclaiming less than a megabyte
of system memory).

> > Which patches did you exactly drop?
> >
> 
> Sorry for bombing you with question...
> 
> I am trying latest Linus-tree HEAD with the drm-intel-nightly I made
> my last testings.
> 
> Are any of these TLB / x86-get_unmapped_area fixes of interested...
> has any effects on the reported issue?

It should not. Of concern is how the GPU views the world which has its
own independent set of TLBs and mapping tables - and access to those
should always be uncached from the CPU's perspective.
 
> I still wonder what is the root-cause...
> I mean if SNA is OK but UXA not and Linux graphics stack is that complex.
> ( Can't say if user-space like unity isn't involved... ).

All that userspace can affect here is the timing and inital contents of
the framebuffer, everything else is controlled by the kernel. All the
testing we have done so far imply that the kernel's view of the machine
state is consistent with our expectations, but the display is doing
something inexplicable.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
