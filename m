Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbaJVK2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbaJVK2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:28:22 -0400
Date: Wed, 22 Oct 2014 18:27:40 +0800
From: Baoquan He <bhe@redhat.com>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "ddutile@redhat.com" <ddutile@redhat.com>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Hatch, Douglas B (HPS Linux PM)" <doug.hatch@hp.com>,
        "Hoemann, Jerry" <jerry.hoemann@hp.com>,
        "Vaden, Tom L (HP Server OS Architecture)" <tom.vaden@hp.com>,
        "Zhang, Li (Zoe@HPservers-Core-OE-PSC)" <li.zhang6@hp.com>,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>
Subject: Re: [PATCH 0/5] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
Message-ID: <20141022102740.GE9060@dhcp-16-116.nay.redhat.com>
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
 <20141022100525.GD9060@dhcp-16-116.nay.redhat.com>
 <57A76219-50C6-4594-91BE-87A6A18FFF43@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57A76219-50C6-4594-91BE-87A6A18FFF43@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/14 at 10:22am, Li, Zhen-Hua wrote:
> 
> Hi Baoquan,
> I tested it on 3.17, it does not have these faults. There are little differences between this version and Bill's last version.
> 
> I will test it on 3.18.0-rc1+ on my system and let you know the result.
> 
> And could you send me the result of "lspci -vvv " on your system?

I have pasted them here.

[~]$ lspci -vvv
00:00.0 Host bridge: Intel Corporation Xeon E5/Core i7 DMI2 (rev 07)
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 0
	Capabilities: <access denied>

00:01.0 PCI bridge: Intel Corporation Xeon E5/Core i7 IIO PCI Express
Root Port 1a (rev 07) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:02.0 PCI bridge: Intel Corporation Xeon E5/Core i7 IIO PCI Express
Root Port 2a (rev 07) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: d6000000-d70fffff
	Prefetchable memory behind bridge:
00000000d8000000-00000000ddffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:03.0 PCI bridge: Intel Corporation Xeon E5/Core i7 IIO PCI Express
Root Port 3a in PCI Express Mode (rev 07) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:05.0 System peripheral: Intel Corporation Xeon E5/Core i7 Address
Map, VTd_Misc, System Management (rev 07)
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

00:05.2 System peripheral: Intel Corporation Xeon E5/Core i7 Control
Status and Global Errors (rev 07)
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

00:05.4 PIC: Intel Corporation Xeon E5/Core i7 I/O APIC (rev 07)
(prog-if 20 [IO(X)-APIC])
	Subsystem: Intel Corporation Xeon E5/Core i7 I/O APIC
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Region 0: Memory at d7346000 (32-bit, non-prefetchable)
[size=4K]
	Capabilities: <access denied>

00:11.0 PCI bridge: Intel Corporation C600/X79 series chipset PCI
Express Virtual Root Port (rev 05) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge:
00000000de400000-00000000de8fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:16.0 Communication controller: Intel Corporation C600/X79 series
chipset MEI Controller #1 (rev 05)
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 36
	Region 0: Memory at d7345000 (64-bit, non-prefetchable)
[size=16]
	Capabilities: <access denied>
	Kernel driver in use: mei_me

00:16.2 IDE interface: Intel Corporation C600/X79 series chipset IDE-r
Controller (rev 05) (prog-if 85 [Master SecO PriO])
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: I/O ports at f0b0 [size=8]
	Region 1: I/O ports at f0a0 [size=4]
	Region 2: I/O ports at f090 [size=8]
	Region 3: I/O ports at f080 [size=4]
	Region 4: I/O ports at f070 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: ata_generic

00:16.3 Serial controller: Intel Corporation C600/X79 series chipset KT
Controller (rev 05) (prog-if 02 [16550])
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at f060 [size=8]
	Region 1: Memory at d7344000 (32-bit, non-prefetchable)
[size=4K]
	Capabilities: <access denied>
	Kernel driver in use: serial

00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network
Connection (rev 05)
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 35
	Region 0: Memory at d7300000 (32-bit, non-prefetchable)
[size=128K]
	Region 1: Memory at d7349000 (32-bit, non-prefetchable)
[size=4K]
	Region 2: I/O ports at f040 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: e1000e

00:1a.0 USB controller: Intel Corporation C600/X79 series chipset USB2
Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d734b000 (32-bit, non-prefetchable)
[size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation C600/X79 series chipset High
Definition Audio Controller (rev 05)
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 37
	Region 0: Memory at d7340000 (64-bit, non-prefetchable)
[size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation C600/X79 series chipset PCI
Express Root Port 2 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation C600/X79 series chipset PCI
Express Root Port 5 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.6 PCI bridge: Intel Corporation C600/X79 series chipset PCI
Express Root Port 3 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.7 PCI bridge: Intel Corporation C600/X79 series chipset PCI
Express Root Port 4 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: d7200000-d72fffff
	Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation C600/X79 series chipset USB2
Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at d734a000 (32-bit, non-prefetchable)
[size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci-pci

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a5) (prog-if
01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=09, subordinate=09, sec-latency=128
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: d7100000-d71fffff
	Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation C600/X79 series chipset LPC
Controller (rev 05)
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel driver in use: lpc_ich

00:1f.2 RAID bus controller: Intel Corporation C600/X79 series chipset
SATA RAID Controller (rev 05)
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 27
	Region 0: I/O ports at f0f0 [size=8]
	Region 1: I/O ports at f0e0 [size=4]
	Region 2: I/O ports at f0d0 [size=8]
	Region 3: I/O ports at f0c0 [size=4]
	Region 4: I/O ports at f020 [size=32]
	Region 5: Memory at d7348000 (32-bit, non-prefetchable)
[size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation C600/X79 series chipset SMBus Host
Controller (rev 05)
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at d7347000 (64-bit, non-prefetchable)
[size=256]
	Region 4: I/O ports at f000 [size=32]
	Kernel driver in use: i801_smbus

02:00.0 Serial Attached SCSI controller: Intel Corporation C602 chipset
4-Port SATA Storage Control Unit (rev 05)
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at de87c000 (64-bit, prefetchable) [size=16K]
	Region 2: Memory at de400000 (64-bit, prefetchable) [size=4M]
	Region 4: I/O ports at e000 [size=256]
	Capabilities: <access denied>
	Kernel driver in use: isci

05:00.0 VGA compatible controller: NVIDIA Corporation GT218 [NVS 300]
(rev a2) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device 0862
	Physical Slot: 2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at d6000000 (32-bit, non-prefetchable)
[size=16M]
	Region 1: Memory at d8000000 (64-bit, prefetchable) [size=64M]
	Region 3: Memory at dc000000 (64-bit, prefetchable) [size=32M]
	Region 5: I/O ports at d000 [size=128]
	Expansion ROM at d7000000 [disabled] [size=512K]
	Capabilities: <access denied>

05:00.1 Audio device: NVIDIA Corporation High Definition Audio
Controller (rev a1)
	Subsystem: Hewlett-Packard Company Device 0862
	Physical Slot: 2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 38
	Region 0: Memory at d7080000 (32-bit, non-prefetchable)
[size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel

08:00.0 USB controller: Texas Instruments TUSB73x0 SuperSpeed USB 3.0
xHCI Host Controller (rev 02) (prog-if 30 [XHCI])
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at d7200000 (64-bit, non-prefetchable)
[size=64K]
	Region 2: Memory at d7210000 (64-bit, non-prefetchable)
[size=8K]
	Capabilities: <access denied>
	Kernel driver in use: xhci_hcd

09:04.0 Ethernet controller: ADMtek NC100 Network Everywhere Fast
Ethernet 10/100 (rev 11)
	Subsystem: Accton Technology Corporation Device 1216
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (16000ns min, 32000ns max), Cache Line Size: 64
bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at c000 [size=256]
	Region 1: Memory at d7121000 (32-bit, non-prefetchable)
[size=1K]
	Expansion ROM at d7100000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: tulip

09:05.0 FireWire (IEEE 1394): LSI Corporation FW322/323 [TrueFire] 1394a
Controller (rev 70) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 1589
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128 (3000ns min, 6000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at d7120000 (32-bit, non-prefetchable)
[size=4K]
	Capabilities: <access denied>
	Kernel driver in use: firewire_ohci

ff:08.0 System peripheral: Intel Corporation Xeon E5/Core i7 QPI Link 0
(rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:08.3 System peripheral: Intel Corporation Xeon E5/Core i7 QPI Link
Reut 0 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:08.4 System peripheral: Intel Corporation Xeon E5/Core i7 QPI Link
Reut 0 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:09.0 System peripheral: Intel Corporation Xeon E5/Core i7 QPI Link 1
(rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:09.3 System peripheral: Intel Corporation Xeon E5/Core i7 QPI Link
Reut 1 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:09.4 System peripheral: Intel Corporation Xeon E5/Core i7 QPI Link
Reut 1 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:0a.0 System peripheral: Intel Corporation Xeon E5/Core i7 Power
Control Unit 0 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0a.1 System peripheral: Intel Corporation Xeon E5/Core i7 Power
Control Unit 1 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0a.2 System peripheral: Intel Corporation Xeon E5/Core i7 Power
Control Unit 2 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0a.3 System peripheral: Intel Corporation Xeon E5/Core i7 Power
Control Unit 3 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0b.0 System peripheral: Intel Corporation Xeon E5/Core i7 Interrupt
Control Registers (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0b.3 System peripheral: Intel Corporation Xeon E5/Core i7 Semaphore
and Scratchpad Configuration Registers (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0c.0 System peripheral: Intel Corporation Xeon E5/Core i7 Unicast
Register 0 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0c.1 System peripheral: Intel Corporation Xeon E5/Core i7 Unicast
Register 0 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0c.6 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller System Address Decoder 0 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0c.7 System peripheral: Intel Corporation Xeon E5/Core i7 System
Address Decoder (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0d.0 System peripheral: Intel Corporation Xeon E5/Core i7 Unicast
Register 0 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0d.1 System peripheral: Intel Corporation Xeon E5/Core i7 Unicast
Register 0 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0d.6 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller System Address Decoder 1 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0e.0 System peripheral: Intel Corporation Xeon E5/Core i7 Processor
Home Agent (rev 07)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:0e.1 Performance counters: Intel Corporation Xeon E5/Core i7
Processor Home Agent Performance Monitoring (rev 07)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: snbep_uncore

ff:0f.0 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller Registers (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:0f.1 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller RAS Registers (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:0f.2 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller Target Address Decoder 0 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:0f.3 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller Target Address Decoder 1 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:0f.4 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller Target Address Decoder 2 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:0f.5 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller Target Address Decoder 3 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:0f.6 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller Target Address Decoder 4 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:10.0 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller Channel 0-3 Thermal Control 0 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>
	Kernel driver in use: snbep_uncore

ff:10.1 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller Channel 0-3 Thermal Control 1 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>
	Kernel driver in use: snbep_uncore

ff:10.2 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller ERROR Registers 0 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:10.3 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller ERROR Registers 1 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:10.4 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller Channel 0-3 Thermal Control 2 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>
	Kernel driver in use: snbep_uncore

ff:10.5 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller Channel 0-3 Thermal Control 3 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>
	Kernel driver in use: snbep_uncore

ff:10.6 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller ERROR Registers 2 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:10.7 System peripheral: Intel Corporation Xeon E5/Core i7 Integrated
Memory Controller ERROR Registers 3 (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: <access denied>

ff:11.0 System peripheral: Intel Corporation Xeon E5/Core i7 DDRIO (rev
07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:13.0 System peripheral: Intel Corporation Xeon E5/Core i7 R2PCIe (rev
07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:13.1 Performance counters: Intel Corporation Xeon E5/Core i7 Ring to
PCI Express Performance Monitor (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: snbep_uncore

ff:13.4 Performance counters: Intel Corporation Xeon E5/Core i7
QuickPath Interconnect Agent Ring Registers (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

ff:13.5 Performance counters: Intel Corporation Xeon E5/Core i7 Ring to
QuickPath Interconnect Link 0 Performance Monitor (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: snbep_uncore

ff:13.6 System peripheral: Intel Corporation Xeon E5/Core i7 Ring to
QuickPath Interconnect Link 1 Performance Monitor (rev 07)
	Subsystem: Intel Corporation Device 0000
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: snbep_uncore
> 
