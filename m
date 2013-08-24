Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3HXJfF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 05:35:05 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54989 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3HXJfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 05:35:02 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130823083428.GB21757@nuc-i3427.alporthouse.com>
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
	<20130823083428.GB21757@nuc-i3427.alporthouse.com>
Date: Sat, 24 Aug 2013 11:35:00 +0200
Message-ID: <CA+icZUUbgso-HpAJeY6NRf4ZdKY=AxaNgUGQsMpQ0Z2U0pQvXA@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 21 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 10:34 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Fri, Aug 23, 2013 at 10:04:37AM +0200, Sedat Dilek wrote:
>> On Fri, Aug 23, 2013 at 9:55 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> > On Thu, Aug 22, 2013 at 1:32 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>> >> On Thu, Aug 22, 2013 at 1:30 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>> >>> On Thu, Aug 22, 2013 at 1:13 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> >>>> dmesg (a lot of traces) and kernel-config attached.
>> >>>>
>> >>>> UXA causes still screen corruption.
>> >>>
>> >>> Hm, was only a slim chance that this patch would fix anything - I
>> >>> think you'd always see an oops when you'd hit this bug instead of just
>> >>> a bit of corruption.
>> >>
>> >> Ok, I think it's time to throw in the towel a bit. I've dropped
>> >>
>> >>
>> >> commit d46f1c3f1372e3a72fab97c60480aa4a1084387f
>> >> Author: Chris Wilson <chris@chris-wilson.co.uk>
>> >> Date:   Thu Aug 8 14:41:06 2013 +0100
>> >>
>> >>     drm/i915: Allow the GPU to cache stolen memory
>
> Hmm, wrong patch. Unless you have a good reason, you just want to drop
> the ringbuffers in stolen.
>
>> >> from my queue. I guess we can retry for 3.13 again.

Just to clarify...

I pulled in today's d-i-n (e1a7374a9920cbbb085ca310e50c903d182d1ca9)
on top of Linus-git HEAD (v3.11-rc6-139-g89b53e5).

This is the list of drm/i915 patches containing "stolen":

      drm/i915: Free stolen node on failed preallocation
      drm/i915: Verify that our stolen memory doesn't conflict
      drm/i915: Use Graphics Base of Stolen Memory on all gen3+
      drm/i915: List objects allocated from stolen memory in debugfs
      drm/i915: Allow the GPU to cache stolen memory <--- *** NOT DROPPED ***
      drm/i915: less magic for stolen preallocated objects w/o gtt offset
      drm/i915: WARN if the bios reserved range is bigger than stolen size
      drm/i915: disable stolen mem for OVERLAY_NEEDS_PHYSICAL
      drm/i915: clarify error paths in create_stolen_for_preallocated

So the culprit patch "drm/i915: Allocate LLC ringbuffers from stolen"
seems to be gone.
I have not compared against my other cumulated patches.
As far as I understood Daniel he dropped a patchset, but I might have
understood him wrong.

- Sedat -
