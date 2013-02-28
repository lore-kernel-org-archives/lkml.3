Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3B1ABm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:01:42 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62906 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3B1ABl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:01:41 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5vvw-JyODTtRwVhQSEiGrt=3wzDoCmeButEMTZxWAhbA@mail.gmail.com>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
	<CA+5PVA5wtZipQRTPfvbh1U8gjDMaW0095EsNz==Co+iww3YN1g@mail.gmail.com>
	<CA+5PVA5vvw-JyODTtRwVhQSEiGrt=3wzDoCmeButEMTZxWAhbA@mail.gmail.com>
Date: Wed, 27 Feb 2013 19:01:38 -0500
Message-ID: <CA+5PVA5za2stXYxQ_Tu3D6Lbif94cqK_5wvPXFhUpvsh_DOXVg@mail.gmail.com>
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

On Wed, Feb 27, 2013 at 3:20 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Wed, Feb 27, 2013 at 11:34 AM, Josh Boyer <jwboyer@gmail.com> wrote:
>> On Mon, Feb 25, 2013 at 7:05 PM, Dave Airlie <airlied@linux.ie> wrote:
>>> Alex Deucher (29):
>>>       drm/radeon: halt engines before disabling MC (6xx/7xx)
>>>       drm/radeon: halt engines before disabling MC (evergreen)
>>>       drm/radeon: halt engines before disabling MC (cayman/TN)
>>>       drm/radeon: halt engines before disabling MC (si)
>>>       drm/radeon: use the reset mask to determine if rings are hung
>>
>> Something in this series of commits is causing the GPU to hang on reboot
>> on my Dell XPS 8300 machine.  That has a:
>>
>> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
>> ATI Caicos [Radeon HD 6450]
>>
>> card in it.  After reboots, I get a screen that looks like this:
>>
>> http://t.co/tPnT6xQZUK
>>
>> I can hit it fairly consistently after a few reboots, so I tried doing a
>> git bisect on the radeon driver and it came down to:
>>
>> ca57802e521de54341efc8a56f70571f79ffac72 is the first bad commit
>
> So I don't think that's actually the cause of the problem.  Or at least
> not that alone.  I reverted it on top of Linus' latest tree and I still
> get the lockups.

Actually, git bisect does seem to have gotten it correct.  Once I
actually tested the revert of just that on top of Linus' tree (commit
d895cb1af1), things seem to be working much better.  I've rebooted a
dozen times without a lockup.  The most I've seen it take on a kernel
with that commit included is 3 reboots, so that's definitely at least an
improvement.

Now that I seem to have narrowed down which commit is broken, I'd be
happy to test fixes, etc.  Sorry for the noise from earlier today.


josh
