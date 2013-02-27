Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3B0UUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 15:20:33 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53188 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3B0UUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:20:32 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5wtZipQRTPfvbh1U8gjDMaW0095EsNz==Co+iww3YN1g@mail.gmail.com>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
	<CA+5PVA5wtZipQRTPfvbh1U8gjDMaW0095EsNz==Co+iww3YN1g@mail.gmail.com>
Date: Wed, 27 Feb 2013 15:20:31 -0500
Message-ID: <CA+5PVA5vvw-JyODTtRwVhQSEiGrt=3wzDoCmeButEMTZxWAhbA@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Josh Boyer <jwboyer@gmail.com>
To: Dave Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:34 AM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Mon, Feb 25, 2013 at 7:05 PM, Dave Airlie <airlied@linux.ie> wrote:
>> Alex Deucher (29):
>>       drm/radeon: halt engines before disabling MC (6xx/7xx)
>>       drm/radeon: halt engines before disabling MC (evergreen)
>>       drm/radeon: halt engines before disabling MC (cayman/TN)
>>       drm/radeon: halt engines before disabling MC (si)
>>       drm/radeon: use the reset mask to determine if rings are hung
>
> Something in this series of commits is causing the GPU to hang on reboot
> on my Dell XPS 8300 machine.  That has a:
>
> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
> ATI Caicos [Radeon HD 6450]
>
> card in it.  After reboots, I get a screen that looks like this:
>
> http://t.co/tPnT6xQZUK
>
> I can hit it fairly consistently after a few reboots, so I tried doing a
> git bisect on the radeon driver and it came down to:
>
> ca57802e521de54341efc8a56f70571f79ffac72 is the first bad commit

So I don't think that's actually the cause of the problem.  Or at least
not that alone.  I reverted it on top of Linus' latest tree and I still
get the lockups.

Thus far I've reverted:

      drm/radeon: use status regs to determine what to reset (6xx/7xx)
      drm/radeon: use status regs to determine what to reset (evergreen)
      drm/radeon: use status regs to determine what to reset (cayman)
      drm/radeon: use status regs to determine what to reset (si)
      drm/radeon: halt engines before disabling MC (6xx/7xx)
      drm/radeon: halt engines before disabling MC (evergreen)
      drm/radeon: halt engines before disabling MC (cayman/TN)
      drm/radeon: halt engines before disabling MC (si)
      drm/radeon: use the reset mask to determine if rings are hung

and can still recreate the issue.  I'm starting to think the problem is
in one of:

      drm/radeon: rework GPU reset on r6xx/r7xx
      drm/radeon: rework GPU reset on evergreen
      drm/radeon: rework GPU reset on cayman/TN
      drm/radeon: rework GPU reset on cayman/TN (which should be si)

Still trying to figure out exactly which code paths are used on this
card, but I'll keep poking at it.  Any ideas or tips for debug are more
than welcome.

josh
