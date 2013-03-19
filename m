Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784Ab3CSTbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:31:44 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41178 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952Ab3CSTbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:31:41 -0400
Message-ID: <5148BD16.6040600@gmail.com>
Date: Tue, 19 Mar 2013 21:31:34 +0200
From: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Regression: Screen turns off when booting in EFI mode
References: <kg69ef$vdb$1@ger.gmane.org> <CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com> <5126C3E1.80801@gmail.com> <513BACAC.9050800@gmail.com> <CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
In-Reply-To: <CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-19 19:09, Linus Torvalds wrote:
> This is apparently still outstanding, and Mantas hadn't cc'd the
> people involved with the commit itself.

I completely forgot about that – sorry.

> Mantas, mind changing that "pcibios_add_device()" function so that
> instead of setting dev->rom/romlen, it just prints out the values
> (including the device address)? Plase also make it print out the
> "data->len" field in addition to the rom->xyz fields..

Which variable is the device address stored in? I'm mostly clueless
about the kernel beyond adding printk's, unfortunately.

But I tried printing out the other values, and this is what I have so far:

For 01:00.0 VGA compatible controller [0300]: Advanced Micro Devices
[AMD] nee ATI Robson CE [AMD Radeon HD 6300 Series] [1002:68e4]

pci 0000:01:00.0: [1002:68e4] type 00 class 0x030000
pci 0000:01:00.0: reg 10: [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:01:00.0: reg 18: [mem 0xd0020000-0xd003ffff 64bit]
pci 0000:01:00.0: reg 20: [io  0xd000-0xd0ff]
pci 0000:01:00.0: reg 30: [mem 0xd0000000-0xd001ffff pref]
pci 0000:01:00.0: supports D1 D2
(dbg) -------------------------------------
(dbg) old dev->rom: 0x0000000000000000, dev->romlen: 0
(dbg) new dev->rom: 0x00000000029ad058, dev->romlen: 61952
(dbg)      pa_data: 0x00000000029ad018 + offset: 64
(dbg) data->type: 3, data->len: 62000
(dbg) rom->segment: 0, rom->bus: 1
(dbg) rom->device: 0, rom->function: 0
(dbg) rom->vendor: 1002, rom->devid: 68e4 <-- radeon
(dbg) -------------------------------------

And for 05:00.5 Ethernet controller [0200]: JMicron Technology Corp.
JMC250 PCI Express Gigabit Ethernet Controller [197b:0250] (rev 03) –
haven't checked if it's affected too, but including anyway.

pci 0000:05:00.5: [197b:0250] type 00 class 0x020000
pci 0000:05:00.5: reg 10: [mem 0xd0200000-0xd0203fff]
pci 0000:05:00.5: reg 18: [io  0x9100-0x917f]
pci 0000:05:00.5: reg 1c: [io  0x9000-0x90ff]
pci 0000:05:00.5: PME# supported from D0 D3hot D3cold
(dbg) -------------------------------------
(dbg) old dev->rom: 0x0000000000000000, dev->romlen: 0
(dbg) new dev->rom: 0x00000000029bd058, dev->romlen: 40960
(dbg)      pa_data: 0x00000000029bd018 + offset: 64
(dbg) data->type: 3, data->len: 41008
(dbg) rom->segment: 0, rom->bus: 5
(dbg) rom->device: 0, rom->function: 5
(dbg) rom->vendor: 197b, rom->devid: 250
(dbg) -------------------------------------
pci 0000:05:00.5: System wakeup disabled by ACPI


-- 
Mantas Mikulėnas <grawity@gmail.com>
