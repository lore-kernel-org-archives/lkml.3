Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3G0RTW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 13:19:22 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48489 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab3G0RTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 13:19:21 -0400
Message-ID: <51F40114.9060607@opensuse.org>
Date: Sat, 27 Jul 2013 13:19:16 -0400
From: =?ISO-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: acpi_backlight=vendor no longer working around buggy laptop from
 hell
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

I have a DELL XPS 15z laptop with the latest BIOS (A12).

This piece of crap have never worked properly without special boot 
parameters. Up to kernel 3.10, passing acpi_backlight=vendor was enough 
to allow the machine to complete boot and be usable.

Now with 3.11 rc2 (also with today's linus tree) unbootable machine 
problem is back.

In the past I spent many hours figuring out workarounds and they go 
_now_ as the following.

Booting with:

"nox2apic" --> machine works, flawless.

"x2apic_phys acpi_backlight=vendor" --> machine works, except for the 
big problem that the laptop keyboard and touchpad are unresponsive, I 
have to plug USB keyboard/mouse to get anything done.

With no boot parameters the machine hangs at random points in the boot 
sequence either:

-Very early at boot and there is no way to retrieve any useful debug 
info. [OR]

- Somehow it looses "connection" with the ATA controller and the 
filesystems cannot be mounted. [OR]

- In very few ocassions, the boot proceeds with no keyboard or touchpad 
then the iwlwifi wireless card does something stupid (firmware error...)

The only possible hint in the logs I could ever find is:

[    3.844586] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS


I tried in the past to obtain any debug information, with no luck.

Help is appreciated to get to the bottom of the problem. ;)


