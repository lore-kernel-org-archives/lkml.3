Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaAYWOx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 17:14:53 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58776 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752426AbaAYWOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 17:14:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [kernel 3.13.0-06058-g2d08cd0] Strange ACPI error messages
Date: Sat, 25 Jan 2014 23:29:04 +0100
Message-ID: <1691151.Vu0Ye8lgsC@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0-rc8+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <CADDKRnBFvfHcuEY8TA=nfyP-WSotkj9wkXxE2QS8h+22cyk_0w@mail.gmail.com>
References: <CADDKRnDZt9Q4XKyJcO1htMrCJYj6_5yECURBHsJ7O==hup7ZRw@mail.gmail.com> <9739501.rBu7tJQIYj@vostro.rjw.lan> <CADDKRnBFvfHcuEY8TA=nfyP-WSotkj9wkXxE2QS8h+22cyk_0w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 25, 2014 05:32:19 PM Jörg Otte wrote:
> 2014-01-25 Rafael J. Wysocki <rjw@rjwysocki.net>:
> > On Saturday, January 25, 2014 11:03:09 AM Jörg Otte wrote:
> >> Kernel 3.13.0-06058-g2d08cd0 displays following errors on the console:
> >>
> >> ACPI: \_PR_.CPU4: failed to get CPU APIC ID.
> >> ACPI: \_PR_.CPU5: failed to get CPU APIC ID.
> >> ACPI: \_PR_.CPU6: failed to get CPU APIC ID.
> >> ACPI: \_PR_.CPU7: failed to get CPU APIC ID.
> >>
> >> I don't have CPUs 4..7! Error messages regarding not existing
> >> CPUs should not be displayed.
> >> kernel 3.13.0-05617-g3aacd62 and before did'nt show this messages.
> >>
> >> This is a regression. I never saw this messages before.
> >
> > Does your system show any other suspicious symptoms or are you worried about
> > those messages only?
> >
> > Rafael
> >
> 
> what's looking badly is this:
> 
> ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_]
> (20131218/hwxface-580)
> ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_]
> (20131218/hwxface-580)

That means your BIOS doesn't support system sleep states S1 and S2, but we
should be able to suppress those messages I think.

> and this:
> 
> acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
>  \_SB_.PCI0:_OSC invalid UUID
>  _OSC request data:1 1e 0
> acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM

That means the BIOS doesn't want to grant the kernel control of extended
PCIe features on your system.

> but these messages are not new.

They indicate things that are not supported by the BIOS, but I agree that the
messages are a bit cryptic.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
