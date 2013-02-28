Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab3B1NoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 08:44:11 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:60571 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3B1NoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 08:44:07 -0500
MIME-Version: 1.0
In-Reply-To: <CADnq5_PqAAhQZ-4Fd0UNoT5aEhUDdtu4n+1qXYucXsnyi0sQwQ@mail.gmail.com>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
	<CA+5PVA5wtZipQRTPfvbh1U8gjDMaW0095EsNz==Co+iww3YN1g@mail.gmail.com>
	<CA+5PVA5vvw-JyODTtRwVhQSEiGrt=3wzDoCmeButEMTZxWAhbA@mail.gmail.com>
	<CA+5PVA5za2stXYxQ_Tu3D6Lbif94cqK_5wvPXFhUpvsh_DOXVg@mail.gmail.com>
	<CA+5PVA6CQ0YrSGkXPGtmzB9BgabXyiRnMSMKYDCJM+OuF5t6gQ@mail.gmail.com>
	<CADnq5_PqAAhQZ-4Fd0UNoT5aEhUDdtu4n+1qXYucXsnyi0sQwQ@mail.gmail.com>
Date: Thu, 28 Feb 2013 08:44:07 -0500
Message-ID: <CA+5PVA7Yzrx_=k9HB-D5v=7gsmn1ZyNb7YpzwDW-1j35Bbrs4Q@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Josh Boyer <jwboyer@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 8:38 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Wed, Feb 27, 2013 at 8:14 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>> On Wed, Feb 27, 2013 at 7:01 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>> On Wed, Feb 27, 2013 at 3:20 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>>> On Wed, Feb 27, 2013 at 11:34 AM, Josh Boyer <jwboyer@gmail.com> wrote:
>>>>> On Mon, Feb 25, 2013 at 7:05 PM, Dave Airlie <airlied@linux.ie> wrote:
>>>>>> Alex Deucher (29):
>>>>>>       drm/radeon: halt engines before disabling MC (6xx/7xx)
>>>>>>       drm/radeon: halt engines before disabling MC (evergreen)
>>>>>>       drm/radeon: halt engines before disabling MC (cayman/TN)
>>>>>>       drm/radeon: halt engines before disabling MC (si)
>>>>>>       drm/radeon: use the reset mask to determine if rings are hung
>>>>>
>>>>> Something in this series of commits is causing the GPU to hang on reboot
>>>>> on my Dell XPS 8300 machine.  That has a:
>>>>>
>>>>> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
>>>>> ATI Caicos [Radeon HD 6450]
>>>>>
>>>>> card in it.  After reboots, I get a screen that looks like this:
>>>>>
>>>>> http://t.co/tPnT6xQZUK
>>>>>
>>>>> I can hit it fairly consistently after a few reboots, so I tried doing a
>>>>> git bisect on the radeon driver and it came down to:
>>>>>
>>>>> ca57802e521de54341efc8a56f70571f79ffac72 is the first bad commit
>>>>
>>>> So I don't think that's actually the cause of the problem.  Or at least
>>>> not that alone.  I reverted it on top of Linus' latest tree and I still
>>>> get the lockups.
>>>
>>> Actually, git bisect does seem to have gotten it correct.  Once I
>>> actually tested the revert of just that on top of Linus' tree (commit
>>> d895cb1af1), things seem to be working much better.  I've rebooted a
>>> dozen times without a lockup.  The most I've seen it take on a kernel
>>> with that commit included is 3 reboots, so that's definitely at least an
>>> improvement.
>>
>> I give up.  GPU issues are not my thing.  2 reboots after I sent that it
>> gave me pretty rainbow static again.  So it might have been an
>> improvement, but revert it is not a solution.
>>
>> Looking at there rest of the commits, the whole GPU rework might be
>> suspect, but I clearly have no clue.
>
> GPUs are tricky beasts :)

Understatement ;).

> ca57802e521de54341efc8a56f70571f79ffac72 mostly likely wasn't the
> problem anyway since it only affects 6xx/7xx and your card is handled
> by the evergreen code.  I'll put together some patches to help narrow
> down the problem.

Yeah, that's the biggest problem I have, not knowing which functions are
actually being executed for this card.  It looks like a combination of
stuff in evergreen.c and ni.c, but I have no idea.

Patches would be great.  If nothing else, I'm really good at building
kernels and rebooting by now.

josh
