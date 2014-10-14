Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaJNPa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 11:30:26 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34867 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbaJNPaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 11:30:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAGBcZGe=HszCxQyx8bBDUEQcF4g+gcMyLfGiM4dVz4=TfxvLpg@mail.gmail.com>
References: <CAGBcZGfHX57jwCfw7CnvLgOJ58kd0KVJULOvhAsfi=3YBp5WsQ@mail.gmail.com>
	<20141013095310.GZ14343@console-pimps.org>
	<CAGBcZGe=HszCxQyx8bBDUEQcF4g+gcMyLfGiM4dVz4=TfxvLpg@mail.gmail.com>
Date: Tue, 14 Oct 2014 18:30:22 +0300
Message-ID: <CAGBcZGfSdYa2yXW68RbywzCiC7mTxjAdGjUnwnhjWAwXZ0uqiQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] efi: Capsule update support
From: Sam Protsenko <semen.protsenko@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>, hock.leong.kweh@intel.com,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

I tried to play with your code and now I have some extra notes about this patch:

1. As it was proposed earlier, I support thought that it would be nice to
   rename function names in next way:

     efi_update_capsule -> __efi_update_capsule
     efi_capsule_update -> efi_update_capsule

   because it's quite confusing to have both efi_update_capsule() and
   efi_capsule_update(). Besides, EFI function called UpdateCapsule, so it's
   good idea to stick to this name in kernel API (I mean exporting
   efi_update_capsule() instead of efi_capsule_update()).

2. UEFI's UpdateCapsule() runtime service supports passing more than one
   capsule to it (we can pass CapsuleCount argument to it for this purpose).
   But your particular kernel implementation allows us only to provide one
   capsule at a time. Is that was done for a reason? Can it be consider as
   shortcoming?

3. I noticed that you dropped efi_capsule_build() in this patch (w.r.t.
   https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/
   implementation). BTW, it should be declared in header there.
   Anyway, how do we suppose to build capsule to pass to efi_capsule_update()?
   I mean, it can take a quite large code to build a capsule (allocating pages
   etc). Wouldn't it be easier to user to use your API if it has something
   ready to use? Anyway, if it should be done like this, it would be nice
   to have a decent example code (use-case) how to use this API (maybe in
   Documentation/, idk), because it looks quite non-intuitive (for me at least).

4. Tedious stuff: I checked your patch with "checkpatch.pl" and it shows
    some warnings, please fix them if possible.

I will try to test and verify this patch further, will notify you if
notice any issues.


On 13 October 2014 18:43, Sam Protsenko <semen.protsenko@linaro.org> wrote:
>> When I originally wrote this patch in 2013 arm64 support didn't exist,
>> and ia64 isn't going to be using capsule support. I can separate that
>> out into a separate patch though, no problem.
>
> For me it's just the matter of good VCS practices. In this case I call
> this "patch atomicity" (one patch per feature). It's not about your
> patch particularly, it's just policy. In the end it boils down to next
> two things:
>  1. Separating common code from platform code makes it easier to use
> "git bisect" in case of regressions.
>  2. This way if we want to revert patch, we can revert only stuff we
> want, not touching another part (e.g. you want to revert platform
> code, you can keep common code in place).
>
>> Next time, could you please quote the part of the patch you're
>> commenting on inline? That would have saved me searching through the
>> original email.
>
> Sure, my bad. I know it's general approach in mailing lists to review
> patch, just forgot it.
>
>
> On 13 October 2014 12:53, Matt Fleming <matt@console-pimps.org> wrote:
>> On Fri, 10 Oct, at 06:55:49PM, Sam Protsenko wrote:
>>> Hi Matt,
>>>
>>> 1. Why x86 code isn't separated to another patch?
>>
>> When I originally wrote this patch in 2013 arm64 support didn't exist,
>> and ia64 isn't going to be using capsule support. I can separate that
>> out into a separate patch though, no problem.
>>
>>> 2. drivers/firmware/efi/reboot.c: efi_reboot():
>>>     One shouldn't use "printk()" with no KERN_* stuff passed into it.
>>> I'd recommend to use "pr_info()" macro or something like that.
>>
>> Oops, I missed that, good catch.
>>
>> Next time, could you please quote the part of the patch you're
>> commenting on inline? That would have saved me searching through the
>> original email.
>>
>> --
>> Matt Fleming, Intel Open Source Technology Center
