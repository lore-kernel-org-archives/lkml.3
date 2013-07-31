Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab3GaALJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:11:09 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:38230 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3GaALI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:11:08 -0400
MIME-Version: 1.0
In-Reply-To: <37178266.QXgbv9rq0i@vostro.rjw.lan>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
	<3453253.oZLO1ChPbL@vostro.rjw.lan>
	<CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com>
	<37178266.QXgbv9rq0i@vostro.rjw.lan>
Date: Tue, 30 Jul 2013 19:11:06 -0500
Message-ID: <CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 6:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

>> If 0 turns the screen off with the intel driver, 0 should turn the
>> screen off with the ACPI driver, having inconsistent behavior
>> depending on which driver is used is a bug.
>
> The ACPI driver simply exposes and interface to interact with the AML methods
> in the BIOS directly.

No, the ACPI driver is exposing a backlight interface, which has a
defined stable API.

Documentation/ABI/stable/sysfs-class-backlight

Yes, the interface doesn't define what should happen at 0, that is a
bug in the interface definition.

*How* it achieves that is an implementation detail.

> Yes, this is a mistake and shouldn't be designed this way.
>
> However, incidentally, this makes backlight control work on your machine.
>
> Anyway, we need all backlight drivers to work consistently and don't tempt me
> to rip the ACPI driver entirely from the kernel for what it's worth.

Yes, they should work consistently, and go ahead, rip the ACPI driver,
*then* you'll see many more people complaining about the Linux kernel
breaking user-space, which should never happen. Mistakes happen, but
if you do this willingly and knowingly, I think there would be
repercussions for you.

> Yes, that will break backlight on your system and *then* you can complain to
> Linus if you wish.

It is already broken in v3.11-rc3, in fact I just booted that to try
it out and it booted with the screen completely black (fortunately I
knew exactly what to type to change that).

Apparently this commit also needs to be reverted: efaa14c (ACPI /
video: no automatic brightness changes by win8-compatible firmware).
In this machine it makes the backlight work again (without
acpi_osi="!Windows 2012"), but by doing so the ACPI driver also turns
off the screen completely at level 0. Also, each time I change the
backlight level from X, the screen blinks as if going 100%, 0%, and
then the desired level.

For this particular machine simply applying the attached patch would
solve all those regressions, but who knows in other machines, I think
it's safer to revert efaa14c.

-- 
Felipe Contreras
