Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaC2PER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:04:17 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:50519 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaC2PEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:04:16 -0400
X-Greylist: delayed 47355 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Mar 2014 11:04:16 EDT
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWpprkp_dzviD8wRpqosJq5Oe+8UTwhL87fbzFm3OknUw@mail.gmail.com>
References: <CAOULuOY5eryuH1KgaqiuGXyYiQd2h=TZoPe2M2+juts9XuzW6Q@mail.gmail.com>
	<CAE9FiQXmO_sSCnd-0NvXKmyeLP0m4XGRRkAgqSiMkfeTcvXs+A@mail.gmail.com>
	<CAOULuOaeBPpuiYc_Aru+awBDf=Ahbok-UjgY9o7gfO4VMctoqg@mail.gmail.com>
	<CAE9FiQWpprkp_dzviD8wRpqosJq5Oe+8UTwhL87fbzFm3OknUw@mail.gmail.com>
Date: Sat, 29 Mar 2014 11:04:15 -0400
Message-ID: <CAOULuOaDmevirqCcanpYhLsboVW8x=pQEU6HiKiv=FDgfNaV0w@mail.gmail.com>
Subject: Re: BAR 14: can't assign mem (size 0x200000)
From: Parag Warudkar <parag.lkml@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 3:11 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> For the boot path, kernel is right.
> BIOS does not assign resource for
> 00:1c.0, (io, mmio, mmio pref), 00:1c.3(io, mmio, mmio pref), 00:1c.4 (io).
>
> but 00:1c.0 00:1c.4 support hotplug either in acpiphp or pcie slot cap.
>
> [    0.263398] acpiphp: Slot [1] registered
> [    0.263405] pci 0000:00:1c.0: PCI bridge to [bus 01]
> [    0.263884] acpiphp: Slot [1-1] registered
> [    0.263891] pci 0000:00:1c.4: PCI bridge to [bus 04-3c]
>
> so kernel assign new resource to them.
>
> [    0.281764] pci 0000:00:1c.0: BAR 14: assigned [mem 0x9f200000-0x9f3fffff]
> [    0.281768] pci 0000:00:1c.0: BAR 15: assigned [mem
> 0x9f400000-0x9f5fffff 64bit pref]
> [    0.281770] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
> [    0.281771] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]

OK. I got that part.

> but 00:1c.3 ==> 02:00.0 (bus 03) does not support hotplug.
> so kernel does not assign resource 00:1c.3.
>
> Later during resuming, kernel try to assign resource 02:00.0 but it will fail
> as parent bridge 00:1c.3 has no resource.
> (Not sure how pci_configure_slot get called with this resume path).
>
Why are things different at resume time though? Is there a fix here -
to detect at resume time that parent bridge for 02:00.0 has no
resources and to skip trying to assign resources to it?
Or is it that pci_configure_slot should not be called at resume time
and that's what is causing this message?

Thanks for taking a look at this.

Parag
