Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaBROh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:37:29 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63510 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbaBROhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:37:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6cnT6JDh0rj_3TCjw8vkLbM0ztzES0Qh1R=wUCp0PfTw@mail.gmail.com>
References: <1390773698.3450.12.camel@artifact> <CAE9FiQVD=oVHM5WJgSJ5cNpXZ1NYy9E_pcGWfjKnmD9OZoHHsw@mail.gmail.com>
 <1391643656.1067.1.camel@artifact> <CAE9FiQV8jutRhaBicL4kjqVYd07FzHmNoSN3NxdA2TYvOc_KUg@mail.gmail.com>
 <z9zi9m.n0zpxd.1hgeaud-qmf@mail.snewbury.org.uk> <i9nn22.n0zs79.1hgeaud-qmf@mail.snewbury.org.uk>
 <1392392764.3520.11.camel@devel-n900> <CAE9FiQV3H_nxH0gxcM0kW4uLm6b_qmHT9hRQUVY_4xPqjpvMtA@mail.gmail.com>
 <1392718107.15829.12.camel@artifact> <CAErSpo6cnT6JDh0rj_3TCjw8vkLbM0ztzES0Qh1R=wUCp0PfTw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Feb 2014 07:37:04 -0700
Message-ID: <CAErSpo4CLB7G5DHpdr69t+wZjywuOXKXsvS6W3eTMJgU5Xpycg@mail.gmail.com>
Subject: Re: pci-3.14 resource alloc
To: Steven Newbury <steve@snewbury.org.uk>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 6:59 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Feb 18, 2014 at 3:08 AM, Steven Newbury <steve@snewbury.org.uk> wrote:

>> No, the only unusual option is I use pci=nocrs since the bios is
>> completely ignorant of support for 64bit BARs.
>
> Hi Steven, this is a tangent, but can you collect the complete dmesg
> log with "pci=nocrs" and let me know what happens when you *don't* use
> "pci=nocrs" (a complete dmesg log there would be useful too, but I
> don't know if you can boot without it)?  I think Linux *should* be
> able to handle 64bit BARs even if the BIOS doesn't.
>
> Please post these as a separate thread so we don't muddle this
> conversation with Yinghai.

Oh, never mind.  I think I remember now.  I think the problem is not
so much that the BIOS doesn't handle 64bit *BARs*, but that your BIOS
doesn't report 64bit host bridge *apertures*, and you want to use
space above 4G for a graphics card or something.

That's not really anything we can fix in PCI because PCI doesn't
discover those apertures.  Host bridge drivers like the generic ACPI
pci_root.c or the native amd_bus.c discover them.  If those drivers
don't discover them, PCI can't just make them up.

It might be nice if we had cleaner kernel options to say "assume a
host bridge window here" and "put this device here," so you didn't
have to use the big hammer of "pci=nocrs".  It's sort of a pain to
figure out how to attach info like that to the correct device (there
might be several host bridges, so how do you specify which one you
care about?), but maybe it could be done.

Bjorn
