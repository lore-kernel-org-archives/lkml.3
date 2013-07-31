Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab3GaBgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 21:36:25 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61656 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3GaBgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 21:36:22 -0400
Message-ID: <51F86A20.3060309@gmail.com>
Date: Wed, 31 Jul 2013 09:36:32 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime
 UX31A
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com> <3453253.oZLO1ChPbL@vostro.rjw.lan> <CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com> <37178266.QXgbv9rq0i@vostro.rjw.lan> <CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
In-Reply-To: <CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 08:11 AM, Felipe Contreras wrote:
> On Tue, Jul 30, 2013 at 6:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
>>> If 0 turns the screen off with the intel driver, 0 should turn the
>>> screen off with the ACPI driver, having inconsistent behavior
>>> depending on which driver is used is a bug.
>>
>> The ACPI driver simply exposes and interface to interact with the AML methods
>> in the BIOS directly.
> 
> No, the ACPI driver is exposing a backlight interface, which has a
> defined stable API.
> 
> Documentation/ABI/stable/sysfs-class-backlight
> 
> Yes, the interface doesn't define what should happen at 0, that is a
> bug in the interface definition.
> 
> *How* it achieves that is an implementation detail.
> 
>> Yes, this is a mistake and shouldn't be designed this way.
>>
>> However, incidentally, this makes backlight control work on your machine.
>>
>> Anyway, we need all backlight drivers to work consistently and don't tempt me
>> to rip the ACPI driver entirely from the kernel for what it's worth.
> 
> Yes, they should work consistently, and go ahead, rip the ACPI driver,
> *then* you'll see many more people complaining about the Linux kernel
> breaking user-space, which should never happen. Mistakes happen, but
> if you do this willingly and knowingly, I think there would be
> repercussions for you.
> 
>> Yes, that will break backlight on your system and *then* you can complain to
>> Linus if you wish.
> 
> It is already broken in v3.11-rc3, in fact I just booted that to try
> it out and it booted with the screen completely black (fortunately I
> knew exactly what to type to change that).

That is bad, can you please file a bug for that? I'll need to take a
look at your ACPI tables, thanks.

> 
> Apparently this commit also needs to be reverted: efaa14c (ACPI /
> video: no automatic brightness changes by win8-compatible firmware).
> In this machine it makes the backlight work again (without
> acpi_osi="!Windows 2012"), but by doing so the ACPI driver also turns
> off the screen completely at level 0. Also, each time I change the

So with rc3 and commit efaa14c reverted, when you set level 0 to ACPI
video's backlight interface, the screen will be off now? And this is not
the case in 3.10, right?

> backlight level from X, the screen blinks as if going 100%, 0%, and
> then the desired level.

Please attach acpidump output to the to be opened bugzilla page, thanks.

-Aaron

> 
> For this particular machine simply applying the attached patch would
> solve all those regressions, but who knows in other machines, I think
> it's safer to revert efaa14c.
> 

