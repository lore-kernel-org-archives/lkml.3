Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3EGGxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:53:05 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:47975 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab3EGGxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:53:01 -0400
Date: Tue, 7 May 2013 08:52:05 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux-ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Lance Ortiz <lance.ortiz@hp.com>,
        Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: WARNING at drivers/pci/search.c:214 for 3.9
Message-ID: <20130507085205.5a41b5ca@pluto.restena.lu>
In-Reply-To: <20130506150757.GC22041@pd.tnic>
References: <20130506162112.6b79b7b1@pluto.restena.lu>
	<20130506150757.GC22041@pd.tnic>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.16; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 May 2013 17:07:57 +0200 Borislav Petkov wrote:
> On Mon, May 06, 2013 at 04:21:12PM +0200, Bruno Prémont wrote:
> > Booting 3.9 on a Fujitsu Primergy RX200 S7 server I get lots of
> > occurrences of the following WARNING (probably one per PCI device
> > listed by lspci -- overflowing my kernel log):
> > 
> > [   69.965933] ------------[ cut here ]------------
> > [   69.965938] WARNING: at /data/kernel/linux-git/drivers/pci/search.c:214 pci_get_dev_by_id+0x8a/0x90()
> > [   69.965941] Hardware name: PRIMERGY RX200 S7
> > [   69.965946] Modules linked in:
> > [   69.965950] Pid: 0, comm: swapper/11 Tainted: G        W    3.9.0-x86_64-fj #1
> > [   69.965953] Call Trace:
> > [   69.965956]  <IRQ>  [<ffffffff8106689a>] warn_slowpath_common+0x7a/0xc0
> > [   69.965967]  [<ffffffff810668f5>] warn_slowpath_null+0x15/0x20
> > [   69.965975]  [<ffffffff8125b98a>] pci_get_dev_by_id+0x8a/0x90
> > [   69.965981]  [<ffffffff8125baa0>] pci_get_subsys+0x30/0x40
> > [   69.965987]  [<ffffffff8125bac3>] pci_get_device+0x13/0x20
> > [   69.965993]  [<ffffffff8125baff>] pci_get_domain_bus_and_slot+0x2f/0x70
> > [   69.966001]  [<ffffffff812bf3ed>] cper_print_pcie.isra.1+0x5d/0x200
> > [   69.966007]  [<ffffffff812bf8c5>] apei_estatus_print_section+0x1e5/0x2c0
> > [   69.966013]  [<ffffffff812bfa27>] apei_estatus_print+0x87/0xb0
> > [   69.966019]  [<ffffffff812c2015>] __ghes_print_estatus.isra.8+0x75/0xc0
> > [   69.966027]  [<ffffffff81239d50>] ? ___ratelimit.part.0+0x80/0xe0
> > [   69.966033]  [<ffffffff812c20b9>] ghes_print_estatus.constprop.10+0x59/0x70
> > [   69.966039]  [<ffffffff812c24f0>] ? ghes_irq_func+0x20/0x20
> > [   69.966044]  [<ffffffff812c244c>] ghes_proc+0x5c/0x70
> > [   69.966050]  [<ffffffff812c2501>] ghes_poll_func+0x11/0x30
> > [   69.966057]  [<ffffffff8107332d>] call_timer_fn.isra.30+0x2d/0x90
> > [   69.966065]  [<ffffffff81073536>] run_timer_softirq+0x1a6/0x1e0
> > [   69.966071]  [<ffffffff8106dcc8>] __do_softirq+0xc8/0x180
> > [   69.966077]  [<ffffffff8106dec6>] irq_exit+0x86/0xa0
> > [   69.966084]  [<ffffffff810248d9>] smp_apic_timer_interrupt+0x69/0xa0
> > [   69.966090]  [<ffffffff815f4b4a>] apic_timer_interrupt+0x6a/0x70
> > [   69.966093]  <EOI>  [<ffffffff814c8408>] ? cpuidle_wrap_enter+0x48/0x90
> > [   69.966101]  [<ffffffff814c8404>] ? cpuidle_wrap_enter+0x44/0x90
> > [   69.966107]  [<ffffffff814c8460>] cpuidle_enter_tk+0x10/0x20
> > [   69.966116]  [<ffffffff814c81c5>] cpuidle_idle_call+0x85/0x100
> > [   69.966122]  [<ffffffff8100b97f>] cpu_idle+0xbf/0x110
> > [   69.966129]  [<ffffffff815db2ed>] start_secondary+0xbd/0xbf
> > [   69.966134] ---[ end trace 9ea0454133ddf8a3 ]---
> 
> Apparently you're not supposed to do pci_get* in IRQ context. But this
> code is older than 3.9 so why does it trigger now?
> 
> > After the last occurrence I have:
> > [   69.977775] PCI AER Cannot get PCI device 0000:00:00.3
> > (no idea if there is anything useful just prior to the WARNING as there
> > are just too many warnings for kernel log to hold them all and userspace
> > gets no opportunity to process incoming messages)
> 
> You can always increase log buf size by booting with "log_buf_len=10M"
> to see whether it can catch all of them. Alternatively, serial console,
> netconsole or blockconsole (this one not upstream yet).

Better that way (log_buf_len=10M)!

The full boot log is available at:
  http://pastebin.com/hVVne14C
(the Hardware Error message is there right before the series of
WARNINGs)

> > For older kernels (3.8.x and older) I only have:
> > [   65.741777] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
> > [   65.763335] {1}[Hardware Error]: APEI generic hardware error status
> > [   65.782650] {1}[Hardware Error]: severity: 2, corrected
> > [   65.782652] {1}[Hardware Error]: section: 0, severity: 2, corrected
> > [   65.782653] {1}[Hardware Error]: flags: 0x01
> > [   65.782655] {1}[Hardware Error]: primary
> > [   65.782656] {1}[Hardware Error]: fru_text: CorrectedErr
> > [   65.782658] {1}[Hardware Error]: section_type: PCIe error
> > [   65.782659] {1}[Hardware Error]: port_type: 0, PCIe end point
> > [   65.782660] {1}[Hardware Error]: version: 0.0
> > [   65.782662] {1}[Hardware Error]: command: 0xffff, status: 0xffff
> > [   65.782664] {1}[Hardware Error]: device_id: 0000:00:02.3
> 
> Interesting. AFAICT, you don't have such device in lspci below.

Yes it has been that way from the start and under BIOS settings I've
found nothing that would make mentioned device visible.

> > [   65.782665] {1}[Hardware Error]: slot: 0
> > [   65.782666] {1}[Hardware Error]: secondary_bus: 0x00
> > [   65.782667] {1}[Hardware Error]: vendor_id: 0xffff, device_id: 0xffff
> > [   65.782668] {1}[Hardware Error]: class_code: ffffff
> > 
> > which was being "triggered" by
> >  commit 3c076351c4027a56d5005a39a0b518a4ba393ce2
> >  Author: Matthew Garrett <mjg@redhat.com>
> >  Date:   Thu Nov 10 16:38:33 2011 -0500
> > 
> >     PCI: Rework ASPM disable code
> 
> And if you revert it, the error above disappears? Adding Matthew.

Correct (at least on 3.0.y stable series).


Toggling the "ASPM support" BIOS option makes no difference.

I've even contacted Fujitsu but unfortunately got no useful result as
they only support SLES kernels, which have Matthew's patch reverted with
commit message:
  This reverts commit 6cac12dfab9c57a4f76821412224b226a9b08dff,
  upstream commit 3c076351c4027a56d5005a39a0b518a4ba393ce2.

  My PS/2 keyboard and touchpad are not detected with this patch.

  This turn 3.0.20 in a noop as there is no other patch. Except
  numbering is correct for further patches...


> >     Right now we forcibly clear ASPM state on all devices if the BIOS indicates
> >     that the feature isn't supported. Based on the Microsoft presentation
> >     "PCI Express In Depth for Windows Vista and Beyond", I'm starting to think
> >     that this may be an error. The implication is that unless the platform
> >     grants full control via _OSC, Windows will not touch any PCIe features -
> >     including ASPM. In that case clearing ASPM state would be an error unless
> >     the platform has granted us that control.
> >     
> >     This patch reworks the ASPM disabling code such that the actual clearing
> >     of state is triggered by a successful handoff of PCIe control to the OS.
> >     The general ASPM code undergoes some changes in order to ensure that the
> >     ability to clear the bits isn't overridden by ASPM having already been
> >     disabled. Further, this theoretically now allows for situations where
> >     only a subset of PCIe roots hand over control, leaving the others in the
> >     BIOS state.
> >     
> >     It's difficult to know for sure that this is the right thing to do -
> >     there's zero public documentation on the interaction between all of these
> >     components. But enough vendors enable ASPM on platforms and then set this
> >     bit that it seems likely that they're expecting the OS to leave them alone.
> >     
> >     Measured to save around 5W on an idle Thinkpad X220.
> >     
> >     Signed-off-by: Matthew Garrett <mjg@redhat.com>
> >     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > 
> > 
> > lspci does not show any corresponding PCI device (which I assume to be some
> > BIOS-disabled CPU device).
> > 
> > lspci:
> > 00:00.0 Host bridge [0600]: Intel Corporation Xeon E5/Core i7 DMI2 [8086:3c00] (rev 07)
> > 00:01.0 PCI bridge [0604]: Intel Corporation Xeon E5/Core i7 IIO PCI Express Root Port 1a [8086:3c02] (rev 07)
> > 00:02.0 PCI bridge [0604]: Intel Corporation Xeon E5/Core i7 IIO PCI Express Root Port 2a [8086:3c04] (rev 07)
> > 00:02.2 PCI bridge [0604]: Intel Corporation Xeon E5/Core i7 IIO PCI Express Root Port 2c [8086:3c06] (rev 07)
> > 00:03.0 PCI bridge [0604]: Intel Corporation Xeon E5/Core i7 IIO PCI Express Root Port 3a in PCI Express Mode [8086:3c08] (rev 07)
> > 00:05.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Address Map, VTd_Misc, System Management [8086:3c28] (rev 07)
> > 00:05.2 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Control Status and Global Errors [8086:3c2a] (rev 07)
> > 00:05.4 PIC [0800]: Intel Corporation Xeon E5/Core i7 I/O APIC [8086:3c2c] (rev 07)
> > 00:11.0 PCI bridge [0604]: Intel Corporation C600/X79 series chipset PCI Express Virtual Root Port [8086:1d3e] (rev 05)
> > 00:1a.0 USB controller [0c03]: Intel Corporation C600/X79 series chipset USB2 Enhanced Host Controller #2 [8086:1d2d] (rev 05)
> > 00:1c.0 PCI bridge [0604]: Intel Corporation C600/X79 series chipset PCI Express Root Port 1 [8086:1d10] (rev b5)
> > 00:1c.7 PCI bridge [0604]: Intel Corporation C600/X79 series chipset PCI Express Root Port 8 [8086:1d1e] (rev b5)
> > 00:1d.0 USB controller [0c03]: Intel Corporation C600/X79 series chipset USB2 Enhanced Host Controller #1 [8086:1d26] (rev 05)
> > 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev a5)
> > 00:1f.0 ISA bridge [0601]: Intel Corporation C600/X79 series chipset LPC Controller [8086:1d41] (rev 05)
> > 00:1f.3 SMBus [0c05]: Intel Corporation C600/X79 series chipset SMBus Host Controller [8086:1d22] (rev 05)
> > 01:00.0 RAID bus controller [0104]: LSI Logic / Symbios Logic MegaRAID SAS 2108 [Liberator] [1000:0079] (rev 05)
> > 06:00.0 Ethernet controller [0200]: Intel Corporation I350 Gigabit Network Connection [8086:1521] (rev 01)
> > 06:00.1 Ethernet controller [0200]: Intel Corporation I350 Gigabit Network Connection [8086:1521] (rev 01)
> > 08:00.0 VGA compatible controller [0300]: Matrox Electronics Systems Ltd. MGA G200e [Pilot] ServerEngines (SEP1) [102b:0522] (rev 05)
> > ff:08.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 QPI Link 0 [8086:3c80] (rev 07)
> > ff:08.3 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 QPI Link Reut 0 [8086:3c83] (rev 07)
> > ff:08.4 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 QPI Link Reut 0 [8086:3c84] (rev 07)
> > ff:09.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 QPI Link 1 [8086:3c90] (rev 07)
> > ff:09.3 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 QPI Link Reut 1 [8086:3c93] (rev 07)
> > ff:09.4 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 QPI Link Reut 1 [8086:3c94] (rev 07)
> > ff:0a.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Power Control Unit 0 [8086:3cc0] (rev 07)
> > ff:0a.1 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Power Control Unit 1 [8086:3cc1] (rev 07)
> > ff:0a.2 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Power Control Unit 2 [8086:3cc2] (rev 07)
> > ff:0a.3 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Power Control Unit 3 [8086:3cd0] (rev 07)
> > ff:0b.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Interrupt Control Registers [8086:3ce0] (rev 07)
> > ff:0b.3 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Semaphore and Scratchpad Configuration Registers [8086:3ce3] (rev 07)
> > ff:0c.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Unicast Register 0 [8086:3ce8] (rev 07)
> > ff:0c.1 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Unicast Register 0 [8086:3ce8] (rev 07)
> > ff:0c.2 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Unicast Register 0 [8086:3ce8] (rev 07)
> > ff:0c.6 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller System Address Decoder 0 [8086:3cf4] (rev 07)
> > ff:0c.7 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 System Address Decoder [8086:3cf6] (rev 07)
> > ff:0d.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Unicast Register 0 [8086:3ce8] (rev 07)
> > ff:0d.1 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Unicast Register 0 [8086:3ce8] (rev 07)
> > ff:0d.2 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Unicast Register 0 [8086:3ce8] (rev 07)
> > ff:0d.6 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller System Address Decoder 1 [8086:3cf5] (rev 07)
> > ff:0e.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Processor Home Agent [8086:3ca0] (rev 07)
> > ff:0e.1 Performance counters [1101]: Intel Corporation Xeon E5/Core i7 Processor Home Agent Performance Monitoring [8086:3c46] (rev 07)
> > ff:0f.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller Registers [8086:3ca8] (rev 07)
> > ff:0f.1 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller RAS Registers [8086:3c71] (rev 07)
> > ff:0f.2 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller Target Address Decoder 0 [8086:3caa] (rev 07)
> > ff:0f.3 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller Target Address Decoder 1 [8086:3cab] (rev 07)
> > ff:0f.4 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller Target Address Decoder 2 [8086:3cac] (rev 07)
> > ff:0f.5 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller Target Address Decoder 3 [8086:3cad] (rev 07)
> > ff:0f.6 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller Target Address Decoder 4 [8086:3cae] (rev 07)
> > ff:10.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller Channel 0-3 Thermal Control 0 [8086:3cb0] (rev 07)
> > ff:10.1 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller Channel 0-3 Thermal Control 1 [8086:3cb1] (rev 07)
> > ff:10.2 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller ERROR Registers 0 [8086:3cb2] (rev 07)
> > ff:10.3 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller ERROR Registers 1 [8086:3cb3] (rev 07)
> > ff:10.4 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller Channel 0-3 Thermal Control 2 [8086:3cb4] (rev 07)
> > ff:10.5 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller Channel 0-3 Thermal Control 3 [8086:3cb5] (rev 07)
> > ff:10.6 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller ERROR Registers 2 [8086:3cb6] (rev 07)
> > ff:10.7 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Integrated Memory Controller ERROR Registers 3 [8086:3cb7] (rev 07)
> > ff:11.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 DDRIO [8086:3cb8] (rev 07)
> > ff:13.0 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 R2PCIe [8086:3ce4] (rev 07)
> > ff:13.1 Performance counters [1101]: Intel Corporation Xeon E5/Core i7 Ring to PCI Express Performance Monitor [8086:3c43] (rev 07)
> > ff:13.4 Performance counters [1101]: Intel Corporation Xeon E5/Core i7 QuickPath Interconnect Agent Ring Registers [8086:3ce6] (rev 07)
> > ff:13.5 Performance counters [1101]: Intel Corporation Xeon E5/Core i7 Ring to QuickPath Interconnect Link 0 Performance Monitor [8086:3c44] (rev 07)
> > ff:13.6 System peripheral [0880]: Intel Corporation Xeon E5/Core i7 Ring to QuickPath Interconnect Link 1 Performance Monitor [8086:3c45] (rev 07)
> > 
> > 
> > Bruno

