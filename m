Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab3GPXca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:32:30 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42721 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933764Ab3GPXc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:32:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAOULuOZgAFv29LTZ5Zy7ZqQs+-L9OVgsB-i5vFoqiTHjC+wwQg@mail.gmail.com>
References: <CAOULuOb3-gA36S=xhA_pwLT0vf9Bb973d3Qq40KfsnS15R_qWA@mail.gmail.com>
 <CALCETrUs9Udhv7KqL+Dy8UNnHd6Amyb1mYjkC8zniF=F-RNZgw@mail.gmail.com> <CAOULuOZgAFv29LTZ5Zy7ZqQs+-L9OVgsB-i5vFoqiTHjC+wwQg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 16 Jul 2013 16:32:06 -0700
Message-ID: <CALCETrUETkBdR_Bn1ZdHCxjjnPTbQBbOCzpuM26yoQO8tnkk3Q@mail.gmail.com>
Subject: Re: [PATCH] BGRT: Don't ioremap if image address is in System RAM
 (was: Re: BGRT Pointer in System RAM)
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 4:23 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>
> On Jul 16, 2013 6:55 PM, "Andy Lutomirski" <luto@amacapital.net> wrote:
>
>> > Ok, so I played around with it a bit and the following patch works
>> > fine on my system. (I.E. image size is reasonable, cat
>> > /sys/firmware/acpi/bgrt/image > img.bmp generates a valid,
>> > non-distorted bitmap, which it did before too, btw as despite of the
>> > ioremap WARN_ON the ioremap seems to succeed if !(is_ram &&
>> > pfn_valid(pfn) && !PageReserved.)
>> >
>>
>> How reliable is this?  That is, is there any guarantee that nothing
>> will have overwritten the image in memory before this code runs?
>>
> From the little digging I did, this code runs fairly early in the boot
> process, right after ACPI acquires all tables. If I am not mistaken it runs
> as part of efi_late_init which should be before efi_free_boot_services() is
> called.
>
> Image address on my system is  00000000B2E1B018. At boot EFI prints the
> following -
>
> [    0.000000] efi: mem23: type=4, attr=0xf,
> range=[0x00000000b2c34000-0x00000000b2e5d0
>
> Type=4, again if I am not mistaken is EFI_BOOT_SERVICES_DATA. So all put
> together I think it should be reliable to read off of that address when
> efi-bgrt-init runs, which is before the boot services code and data are
> discarded.

Fair enough.  I leave it to the experts to comment on whether there
should be some explicit check of whether this is
EFI_BOOT_SERVICES_DATA.

FWIW, if my board does indeed have a DWORD-swapped address, it's in
plain old RAM (type=7).

--Andy
