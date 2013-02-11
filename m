Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab3BKTxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:53:50 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:53340 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406Ab3BKTxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:53:48 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUXiVE2b-JQ-=GCUc7=0itUEfuR-cVzhLv3ebrYkgY4_yw@mail.gmail.com>
References: <Pine.LNX.4.44L0.1302051520220.2245-100000@iolanthe.rowland.org>
	<1360466060.3703.15.camel@thor.lan>
	<1360506199.3461.5.camel@thor.lan>
	<CAE9FiQX0Jzqi=Dy=r3MoU9vK7HgAf+919LvbgLygW7VH3O4=bg@mail.gmail.com>
	<CAE9FiQX5wQ8zFzPfgmvm0BESyLVxzDRQ33XPgj+QjBZ0kxuHXg@mail.gmail.com>
	<1360587768.3454.2.camel@thor.lan>
	<CAE9FiQWUZ3BgLOtcGePppLzWBv-uR8L+7abditH2MNA7zZW-WA@mail.gmail.com>
	<CA+icZUXiVE2b-JQ-=GCUc7=0itUEfuR-cVzhLv3ebrYkgY4_yw@mail.gmail.com>
Date: Mon, 11 Feb 2013 11:53:47 -0800
X-Google-Sender-Auth: 9TT2Th94sdchjinH_AUbIYtXu0Q
Message-ID: <CAE9FiQVqazY3Zsdxv4pjgOKZ1XqtJW6O0H9coPF0qvxk6JQOEg@mail.gmail.com>
Subject: Re: [Bisected] [-next-20130204] usb/hcd: irq 18: nobody cared
From: Yinghai Lu <yinghai@kernel.org>
To: sedat.dilek@gmail.com
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 11:45 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Mon, Feb 11, 2013 at 8:19 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Mon, Feb 11, 2013 at 5:02 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
>>> On Sun, 2013-02-10 at 22:40 -0800, Yinghai Lu wrote:
>>>> On Sun, Feb 10, 2013 at 12:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>> > On Sun, Feb 10, 2013 at 6:23 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
>>>> >> On Sat, 2013-02-09 at 22:14 -0500, Peter Hurley wrote:
>>>> >>> On Tue, 2013-02-05 at 15:26 -0500, Alan Stern wrote:
>>>> >>> > On Tue, 5 Feb 2013, Peter Hurley wrote:
>>>> >>> >
>>>> >>> > > With -next-20130204:
>>>> >>> > >
>>>> >>> > > [   33.855570] irq 18: nobody cared (try booting with the "irqpoll" option)
>>>> >>> > > [   33.855580] Pid: 0, comm: swapper/4 Not tainted 3.8.0-next-20130204-xeon #20130204
>>>> >>> > > [   33.855582] Call Trace:
>>>> >>> > > [   33.855585]  <IRQ>  [<ffffffff810f1076>] __report_bad_irq+0x36/0xe0
>>>> >>> > > [   33.855600]  [<ffffffff810f152a>] note_interrupt+0x1aa/0x200
>>>> >>> > > [   33.855606]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
>>>> >>> > > [   33.855610]  [<ffffffff810eed89>] handle_irq_event_percpu+0xc9/0x260
>>>> >>> > > [   33.855614]  [<ffffffff810eef68>] handle_irq_event+0x48/0x70
>>>> >>> > > [   33.855618]  [<ffffffff810f20ba>] handle_fasteoi_irq+0x5a/0x100
>>>> >>> > > [   33.855624]  [<ffffffff810182f2>] handle_irq+0x22/0x40
>>>> >>> > > [   33.855630]  [<ffffffff816e2a9a>] do_IRQ+0x5a/0xd0
>>>> >>> > > [   33.855636]  [<ffffffff816d97ad>] common_interrupt+0x6d/0x6d
>>>> >>> > > [   33.855638]  <EOI>  [<ffffffff810f8e2a>] ? rcu_eqs_enter_common+0x4a/0x320
>>>> >>> > > [   33.855646]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
>>>> >>> > > [   33.855649]  [<ffffffff8101ed99>] ? mwait_idle+0x29/0x1b0
>>>> >>> > > [   33.855653]  [<ffffffff8101f8a6>] cpu_idle+0x116/0x130
>>>> >>> > > [   33.855658]  [<ffffffff816c0c0f>] start_secondary+0x251/0x258
>>>> >>> > > [   33.855660] handlers:
>>>> >>> > > [   33.855664] [<ffffffff814f98a0>] usb_hcd_irq
>>>> >>> > > [   33.855667] Disabling IRQ #18
>>>> >>> > >
>>>> >> https://bugzilla.kernel.org/show_bug.cgi?id=53561
>>>> >>
>>>> >> Maybe this is some interaction with all the new ACPI code and fixes
>>>> >> written in those 8 days.
>>>> >
>>>> > interrupt routing seems get changed:
>>>> > next:
>>>> >    5:          0          0          0          0          0
>>>> > 0          0          0   IO-APIC-fasteoi   snd_ctxfi
>>>> >   18:      99970         13         16         20      99940
>>>> > 13         13         16   IO-APIC-fasteoi   uhci_hcd:usb4
>>>> > v3.8-rc7:
>>>> >   18:        424         15         11        112        420
>>>> > 16         18        105   IO-APIC-fasteoi   uhci_hcd:usb4, snd_ctxfi
>>>> >
>>>> > These messages in the bad dmesg log are interesting since PCI INT A is routed
>>>> > on
>>>> > irq 18 with the kernels that work.
>>>> > [    8.983246] pci 0000:00:1e.0: can't derive routing for PCI INT A
>>>> > [    8.983600] snd_ctxfi 0000:09:02.0: PCI INT A: no GSI - using ISA IRQ 5
>>>> > ...
>>>> >
>>>> > acpi_pci_irq_add_prt() add wrong bus for that bridge, because that
>>>> > that bridge is not scanned.
>>>> >
>>>> > Will check if I can produce one patch for it.
>>>>
>>>> Hi Peter,
>>>>
>>>> Can you try attached debug patch?
>>>
>>> Fixed, thanks.
>>
>> Bjorn, Rafael,
>>
>> acpi_pci_irq_add_prt need to be called after pci bridge get scanned,
>> so we can not call it from pci_acpi_setup, after we move dev_register
>> for pci_dev early.
>>
>> The attached debug patch move down that calling into
>> pci_bus_add_devices and that will make prt works again.
>>
>> Can acpi provide another hook after bridge get scanned?
>>
>
> 23: +   /* need to after bridge is scanned */
> 24: +   pcibios_irq_setup(&dev->dev);
>
> ... need to *be called* after...
>
> Even this is a temporary workaround, can you send a separate patch for this?

again, this is debug patch.

Thanks

Yinghai
