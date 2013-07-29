Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3G2BFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 21:05:25 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61993 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab3G2BFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 21:05:20 -0400
Message-ID: <51F5BFF6.7080506@gmail.com>
Date: Mon, 29 Jul 2013 09:05:58 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?Q3Jpc3RpYW4gUm9kcsOtZ3Vleg==?= <crrodriguez@opensuse.org>
CC: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: acpi_backlight=vendor no longer working around buggy laptop from
 hell
References: <51F40114.9060607@opensuse.org>
In-Reply-To: <51F40114.9060607@opensuse.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2013 01:19 AM, Cristian Rodríguez wrote:
> Hi:
> 
> I have a DELL XPS 15z laptop with the latest BIOS (A12).
> 
> This piece of crap have never worked properly without special boot 
> parameters. Up to kernel 3.10, passing acpi_backlight=vendor was enough 
> to allow the machine to complete boot and be usable.
> 
> Now with 3.11 rc2 (also with today's linus tree) unbootable machine 
> problem is back.
> 
> In the past I spent many hours figuring out workarounds and they go 
> _now_ as the following.
> 
> Booting with:
> 
> "nox2apic" --> machine works, flawless.

I've seen bug report with similar symptom:
https://bugzilla.kernel.org/show_bug.cgi?id=56051

It is possible the BIOS is not x2apic aware while Linux enabled x2apic,
then some ACPI control method to do things like change backlight
brightness level triggered SMI handler and freeze would occur. This
might be the reason why adding acpi_backlight=vendor fixed your problem,
since it would block ACPI video module's handling of backlight.

So does adding nox2apic still work for you with latest Linus' tree?

> 
> "x2apic_phys acpi_backlight=vendor" --> machine works, except for the 
> big problem that the laptop keyboard and touchpad are unresponsive, I 
> have to plug USB keyboard/mouse to get anything done.
> 
> With no boot parameters the machine hangs at random points in the boot 
> sequence either:
> 
> -Very early at boot and there is no way to retrieve any useful debug 
> info. [OR]

Maybe this is when video.ko is loaded.

> 
> - Somehow it looses "connection" with the ATA controller and the 
> filesystems cannot be mounted. [OR]
> 
> - In very few ocassions, the boot proceeds with no keyboard or touchpad 
> then the iwlwifi wireless card does something stupid (firmware error...)

All sounds like related to irq problem.

> 
> The only possible hint in the logs I could ever find is:
> 
> [    3.844586] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS

This is subtle, meaning the BIOS doesn't provide the required method.

-Aaron

> 
> 
> I tried in the past to obtain any debug information, with no luck.
> 
> Help is appreciated to get to the bottom of the problem. ;)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

