Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3CEPWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:22:01 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:57104 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab3CEPWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:22:00 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5ApepOTJGJR0zXF5C_p7cFjShr3_shynAHX_M=ya5o7Q@mail.gmail.com>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
	<CA+5PVA5wtZipQRTPfvbh1U8gjDMaW0095EsNz==Co+iww3YN1g@mail.gmail.com>
	<CA+5PVA5vvw-JyODTtRwVhQSEiGrt=3wzDoCmeButEMTZxWAhbA@mail.gmail.com>
	<CA+5PVA5za2stXYxQ_Tu3D6Lbif94cqK_5wvPXFhUpvsh_DOXVg@mail.gmail.com>
	<CA+5PVA6CQ0YrSGkXPGtmzB9BgabXyiRnMSMKYDCJM+OuF5t6gQ@mail.gmail.com>
	<CADnq5_PqAAhQZ-4Fd0UNoT5aEhUDdtu4n+1qXYucXsnyi0sQwQ@mail.gmail.com>
	<CA+5PVA7Yzrx_=k9HB-D5v=7gsmn1ZyNb7YpzwDW-1j35Bbrs4Q@mail.gmail.com>
	<CADnq5_OadSJ1thVEvfQVfTZ3De0vivVjnCKwepVxabs6i6ivLQ@mail.gmail.com>
	<CA+5PVA6P2igBMmOeVwhoA5cy0NQHzd-MM6jw5ySUBfZUsMK=ag@mail.gmail.com>
	<CA+5PVA5ApepOTJGJR0zXF5C_p7cFjShr3_shynAHX_M=ya5o7Q@mail.gmail.com>
Date: Tue, 5 Mar 2013 10:21:59 -0500
Message-ID: <CA+5PVA40SFq1EprA9Y1U-eUdmYTzqDbxbTaC1Y1WSh7EwEEqfw@mail.gmail.com>
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

On Thu, Feb 28, 2013 at 1:59 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Thu, Feb 28, 2013 at 10:15 AM, Josh Boyer <jwboyer@gmail.com> wrote:
>> On Thu, Feb 28, 2013 at 10:09 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>>> On Thu, Feb 28, 2013 at 8:44 AM, Josh Boyer <jwboyer@gmail.com> wrote:
>>>> On Thu, Feb 28, 2013 at 8:38 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>>>>>>>>> ca57802e521de54341efc8a56f70571f79ffac72 is the first bad commit
>>>>>>>>
>>>>>>>> So I don't think that's actually the cause of the problem.  Or at least
>>>>>>>> not that alone.  I reverted it on top of Linus' latest tree and I still
>>>>>>>> get the lockups.
>>>>>>>
>>>>>>> Actually, git bisect does seem to have gotten it correct.  Once I
>>>>>>> actually tested the revert of just that on top of Linus' tree (commit
>>>>>>> d895cb1af1), things seem to be working much better.  I've rebooted a
>>>>>>> dozen times without a lockup.  The most I've seen it take on a kernel
>>>>>>> with that commit included is 3 reboots, so that's definitely at least an
>>>>>>> improvement.
>>>>>>
>>>>>> I give up.  GPU issues are not my thing.  2 reboots after I sent that it
>>>>>> gave me pretty rainbow static again.  So it might have been an
>>>>>> improvement, but revert it is not a solution.
>>>>>>
>>>>>> Looking at there rest of the commits, the whole GPU rework might be
>>>>>> suspect, but I clearly have no clue.
>>>>>
>>>>> GPUs are tricky beasts :)
>>>>
>>>> Understatement ;).
>>>>
>>>>> ca57802e521de54341efc8a56f70571f79ffac72 mostly likely wasn't the
>>>>> problem anyway since it only affects 6xx/7xx and your card is handled
>>>>> by the evergreen code.  I'll put together some patches to help narrow
>>>>> down the problem.
>>>>
>>>> Yeah, that's the biggest problem I have, not knowing which functions are
>>>> actually being executed for this card.  It looks like a combination of
>>>> stuff in evergreen.c and ni.c, but I have no idea.
>>>>
>>>> Patches would be great.  If nothing else, I'm really good at building
>>>> kernels and rebooting by now.
>>>
>>> Two possible fixes attached.  The first attempts a full reset of all
>>> blocks if the MC (memory controller) is hung.  That may work better
>>> than just resetting the MC.  The second just disables MC reset.  I'm
>>> not sure we can reliably tell if it's busy due to display requests
>>> hitting the MC periodically which would lead to needlessly resetting
>>> it possibly leading to failures like you are seeing.
>>
>> OK.  I'll test them individually.  It will probably take a bit because
>> I'll want to do numerous reboots if things seem "fixed" with one or the
>> other.
>>
>> I'll let you know how things go.
>
> I applied each individually on top of Linus' tree as of this morning
> (commit 2a7d2b96d5) built, installed, and tested.
>
> 0001-drm-radeon-XXX-try-a-full-reset-if-the-MC-is-busy.patch failed in
> two reboots.
>
> 0001-drm-radeon-XXX-skip-MC-reset-as-it-s-probably-not-hu.patch has gone
> 21 reboots without a hang/rainbow static.  You'll understand if I'm
> hesitant to declare success, but resetting the MC does indeed appear to
> be the issue.  I'll keep rebooting for a while to make sure.

OK, I'm still running on the kernel with that patch and things still
work.  The only other "issue" I'm seeing at the moment is my dmesg is
full of:

[349316.595749] radeon 0000:01:00.0: MC busy: 0x00000409, clearing.
[349436.654946] radeon 0000:01:00.0: MC busy: 0x00000409, clearing.
[349436.655997] radeon 0000:01:00.0: MC busy: 0x00000409, clearing.
[349496.698441] radeon 0000:01:00.0: MC busy: 0x00000409, clearing.
[349556.726767] radeon 0000:01:00.0: MC busy: 0x00000409, clearing.
[349556.727797] radeon 0000:01:00.0: MC busy: 0x00000409, clearing.

So hopefully your patch is on the way into Linus' tree at some point
soon.

josh
