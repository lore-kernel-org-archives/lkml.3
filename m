Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab3GYPeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:34:10 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:49424 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3GYPeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:34:07 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKMK7uG-KCF5oU2XJ5UWPJn=V3i0jBLs5a=gU9UPuJxY0v=bNw@mail.gmail.com>
References: <CA+icZUVHkYd6xcGe7v-zA8=f+vTF1eF2JszvFPfqzJwE34_2ig@mail.gmail.com>
	<87ehanx9bx.fsf@intel.com>
	<CA+icZUXX1-kz9QbY5CpU1UDU8trxgfJSS6ZnUpx9ieq5FnVNSQ@mail.gmail.com>
	<CA+icZUWOwKH+oF4Ekrkk3pUCjz4Rc361kzdsKjb04WzsEtWPYA@mail.gmail.com>
	<87bo5rx7m0.fsf@intel.com>
	<CA+icZUXhW_yAie25DPVXzhi2_pYQTjJpDqa7EzRfvtQ0gFYYHQ@mail.gmail.com>
	<20130725133651.GI5939@phenom.ffwll.local>
	<CA+icZUWxvBR6NX8JnqM1+4yVNfQ8ew5_7UCQ6yVpz8B4UibW7A@mail.gmail.com>
	<20130725142705.GM5939@phenom.ffwll.local>
	<CA+icZUU3+egkAVtSVEiOaqWK+7EFi572jGv2jUt=QDuGjbfZOw@mail.gmail.com>
	<CAKMK7uG-KCF5oU2XJ5UWPJn=V3i0jBLs5a=gU9UPuJxY0v=bNw@mail.gmail.com>
Date: Thu, 25 Jul 2013 17:34:04 +0200
Message-ID: <CA+icZUV-UM_9OSfGfYyb0-qZrFSuqeX-7BiPQ0NbyF7bADW-qA@mail.gmail.com>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 5:05 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Thu, Jul 25, 2013 at 5:03 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Thu, Jul 25, 2013 at 4:27 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>>> On Thu, Jul 25, 2013 at 04:23:40PM +0200, Sedat Dilek wrote:
>>>> On Thu, Jul 25, 2013 at 3:36 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>>>> > On Thu, Jul 25, 2013 at 12:37:44PM +0200, Sedat Dilek wrote:
>>>> >> On Thu, Jul 25, 2013 at 12:21 PM, Jani Nikula
>>>> >> <jani.nikula@linux.intel.com> wrote:
>>>> >> > On Thu, 25 Jul 2013, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>> >> >> On Thu, Jul 25, 2013 at 12:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>> >> >>> On Thu, Jul 25, 2013 at 11:44 AM, Jani Nikula
>>>> >> >>> <jani.nikula@linux.intel.com> wrote:
>>>> >> >>>> On Thu, 25 Jul 2013, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>> >> >>>>> On Thu, Jul 25, 2013 at 7:12 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>> >> >>>>>> Hi all,
>>>> >> >>>>>>
>>>> >> >>>>>> Changes since 20130724:
>>>> >> >>>>>>
>>>> >> >>>>>> Removed tree:
>>>> >> >>>>>>         arm-dt (at maintainer's request)
>>>> >> >>>>>>
>>>> >> >>>>>> The wireless-next tree lost its build failure and gained a conflict
>>>> >> >>>>>> against Linus' tree.
>>>> >> >>>>>>
>>>> >> >>>>>> The tty tree lost its build failure.
>>>> >> >>>>>>
>>>> >> >>>>>> The staging tree gained a build failure for which I disabled a driver.
>>>> >> >>>>>>
>>>> >> >>>>>> ----------------------------------------------------------------------------
>>>> >> >>>>>>
>>>> >> >>>>>
>>>> >> >>>>> [ CCing drm and drm-intel folks ]
>>>> >> >>>>>
>>>> >> >>>>> With today's next-20130725 I see the following:
>>>> >> >>>>
>>>> >> >>>> Use of dev_priv->gt_lock in I915_WRITE through
>>>> >> >>>> intel_disable_gt_powersave before spin lock init, caused by
>>>> >> >>>>
>>>> >> >>>> commit 181d1b9e31c668259d3798c521672afb8edd355c
>>>> >> >>>> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
>>>> >> >>>> Date:   Sun Jul 21 13:16:24 2013 +0200
>>>> >> >>>>
>>>> >> >>>>     drm/i915: fix up gt init sequence fallout
>>>> >> >>>>
>>>> >> >>>
>>>> >> >>> Ah, cool.
>>>> >> >>>
>>>> >> >>> I assumed/tested "drm/i915: fix the racy object accounting", but this
>>>> >> >>> does not fix it.
>>>> >> >>> Will try with yours.
>>>> >> >>>
>>>> >> >>
>>>> >> >> Sorry, Jani.
>>>> >> >>
>>>> >> >> next-20130725 ships the patch you pointed, too.
>>>> >> >
>>>> >> > Confused. I meant that the above mentioned commit "drm/i915: fix up gt
>>>> >> > init sequence fallout" causes the problem. The patch I included in my
>>>> >> > mail should fix it. Could you try that please?
>>>> >> >
>>>> >>
>>>> >> [ Note2myself: Do not read half of the message... ]
>>>> >>
>>>> >> The bad... Your patch needed some refresh against next-20130725 (guess
>>>> >> it's against drm-intel-nightly).
>>>> >>
>>>> >> The good... YES, your patch fixes the issue for me!
>>>> >>
>>>> >> The ugly... /me.
>>>> >>
>>>> >> Feel free to add my:
>>>> >>
>>>> >>        Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
>>>> >>
>>>> >> Thanks for the quick fix!
>>>> >
>>>> > Thanks a lot for the report, since this should be something I should have
>>>> > caught. And for added insult the offending patch is already in Linus' tree
>>>> > :( Patch merged to -fixes.
>>>>
>>>> Hmmm, don't you merge -fixes into -nightly?
>>>
>>> I do, but it seems to only blow up with spinlock debugging enabling I
>>> think. Our QA should run full debug buils in the -nightly testing, but
>>> apparently they didn't catch this. I'm looking into what went wrong here
>>> and fix up the process.
>>
>> First, I thought I made my merge wrong, but there is no
>>
>> $ grep spin_lock_init linux-next/drivers/gpu/drm/i915/i915_dma.c | grep gt_lock
>>
>> Same in [1]:
>> ...
>>         spin_lock_init(&dev_priv->irq_lock);
>>         spin_lock_init(&dev_priv->gpu_error.lock);
>>         spin_lock_init(&dev_priv->backlight.lock);
>>         spin_lock_init(&dev_priv->uncore.lock);
>
> It's hiding in plain sight here ;-) -next has it renamed to
> uncore.lock, so I've applied the patch to -fixes only. I've also
> changed the patch in -fixes to cause an explicit conflict here, makes
> merging a bit easier.

Ah, I see... "drm/i915: Colocate all GT access routines in the same file"

@@ -1493,7 +1477,7 @@ int i915_driver_load(struct drm_device *dev,
unsigned long flags)
...
- spin_lock_init(&dev_priv->gt_lock);
+ spin_lock_init(&dev_priv->uncore.lock);
...

- Sedat -

http://cgit.freedesktop.org/~danvet/drm-intel/commit/drivers/gpu/drm/i915/i915_dma.c?h=drm-intel-nightly&id=907b28c56ea40629aa6595ddfa414ec2fc7da41c

> -Daniel
>
>>         spin_lock_init(&dev_priv->mm.object_stat_lock);
>> ...
>>
>> - Sedat -
>>
>> [1] http://cgit.freedesktop.org/~danvet/drm-intel/tree/drivers/gpu/drm/i915/i915_dma.c?h=drm-intel-nightly#n1477
>>
>>
>>> -Daniel
>>> --
>>> Daniel Vetter
>>> Software Engineer, Intel Corporation
>>> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
>
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
