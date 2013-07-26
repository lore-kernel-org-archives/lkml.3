Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507Ab3GZKez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:34:55 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:40820 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3GZKew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:34:52 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUX2JWH=WtOM_BkJp1O91wHxA3oq_4c93iSDg599D++Xsg@mail.gmail.com>
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
	<CA+icZUUZa=_nW1V6s_CVXNxCMPnxj-6vF+VafbPev3VpsCjfEg@mail.gmail.com>
	<CA+icZUWQdmoPoR0GC8Nn63WtD2sdNpmGV9+5bmWv29eCTm8htw@mail.gmail.com>
	<CAKMK7uH7DeAzkFttkShxY=fSORKBGj2hnmP9Y_qXw_cWE_pkjA@mail.gmail.com>
	<CA+icZUX2JWH=WtOM_BkJp1O91wHxA3oq_4c93iSDg599D++Xsg@mail.gmail.com>
Date: Fri, 26 Jul 2013 12:34:51 +0200
Message-ID: <CA+icZUXSiFs6P=H3d69=+tr4fMw4s_dUcQ1wFavoqVW0uYrAkw@mail.gmail.com>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
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

On Fri, Jul 26, 2013 at 11:32 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Jul 26, 2013 at 11:16 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>> On Fri, Jul 26, 2013 at 11:11 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>>> I have compared next-20130725 VS. next-20130726:
>>>
>>> $ head -2313 next-20130725-VS-next-20130726.diff | grep ^+ | grep i915
>>> +      drm/i915: Colocate all GT access routines in the same file
>>> +      drm/i915: Use a private interface for register access within GT
>>> +      drm/i915: Use the common register access functions for NOTRACE variants
>>> +      drm/i915: Squash gen lookup through multiple indirections
>>> inside GT access
>>> +      drm/i915: Convert the register access tracepoint to be conditional
>>> +      drm/i915: fix the racy object accounting
>>> +      drm/i915: dvo_ch7xxx: fix vsync polarity setting
>>> +      drm/i915: initialize gt_lock early with other spin locks
>>> +      Revert "ACPI / video / i915: No ACPI backlight if firmware
>>> expects Windows 8"
>>> + drivers/gpu/drm/i915/Makefile                      |    2 +
>>> + drivers/gpu/drm/i915/dvo_ch7xxx.c                  |    2 +-
>>> + drivers/gpu/drm/i915/i915_debugfs.c                |  836 +--
>>> + drivers/gpu/drm/i915/i915_dma.c                    |   91 +-
>>> + drivers/gpu/drm/i915/i915_drv.c                    |  292 +-
>>> + drivers/gpu/drm/i915/i915_drv.h                    |  413 +-
>>> + drivers/gpu/drm/i915/i915_gem.c                    |  411 +-
>>> + drivers/gpu/drm/i915/i915_irq.c                    | 1347 ++---
>>> + drivers/gpu/drm/i915/i915_trace.h                  |   16 +-
>>> + drivers/gpu/drm/i915/intel_display.c               | 1065 ++--
>>> + drivers/gpu/drm/i915/intel_drv.h                   |   36 +-
>>> + drivers/gpu/drm/i915/intel_pm.c                    |  431 +-
>>> + drivers/gpu/drm/i915/intel_uncore.c                |  595 +++
>>>
>>> Any hints which of the commits could be culprit?
>>
>> None, it's the vma offset manager stuff in drm-next.
>>
>> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
>> index 3613b50..1f76572 100644
>> --- a/drivers/gpu/drm/drm_gem.c
>> +++ b/drivers/gpu/drm/drm_gem.c
>> @@ -666,7 +666,7 @@ int drm_gem_mmap(struct file *filp, struct
>> vm_area_struct *vma)
>>         }
>>
>>         obj = container_of(node, struct drm_gem_object, vma_node);
>> -       ret = drm_gem_mmap_obj(obj, drm_vma_node_size(node), vma);
>> +       ret = drm_gem_mmap_obj(obj, drm_vma_node_size(node) << PAGE_SHIFT, vma);
>>
>>         mutex_unlock(&dev->struct_mutex);
>>
>>
>> That should fix stuff up again, David Herrmann is working on a real
>> patch already.
>>
>
> The fix can be found at [1].
>

v2: https://patchwork.kernel.org/patch/2833959/

- Sedat -

> - Sedat -
>
> [1] https://patchwork.kernel.org/patch/2833932/
>
>> Cheers, Daniel
>> --
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
