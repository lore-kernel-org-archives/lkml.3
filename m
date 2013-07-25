Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab3GYXPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:15:09 -0400
Received: from www.sr71.net ([198.145.64.142]:38364 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969Ab3GYXPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:15:06 -0400
Message-ID: <51F1B179.4070309@sr71.net>
Date: Thu, 25 Jul 2013 16:15:05 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lu@intel.com>
Subject: SATA hotplug not detecting new disks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a relatively new system that doesn't seem to be able to hotplug
SATA disks.  I see the same behavior on 3.10, 3.11-rc2, and Ubuntu's
3.8.0-25-generic.  The disks are detected right away on reboots, but
even after poking the /sys/class/scsi_host/host*/scan files, new disks
are never detected.  I've disabled link power management.

Am I doing something stupid here?  I thought this "just worked" on my
previous hardware.

The motherboard is an Intel DH87RL. The SATA controller is:

> 00:1f.2 SATA controller: Intel Corporation Lynx Point 6-port SATA Controller 1 [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
> 	Subsystem: Intel Corporation Device 204a
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 41
> 	Region 0: I/O ports at f0d0 [size=8]
> 	Region 1: I/O ports at f0c0 [size=4]
> 	Region 2: I/O ports at f0b0 [size=8]
> 	Region 3: I/O ports at f0a0 [size=4]
> 	Region 4: I/O ports at f060 [size=32]
> 	Region 5: Memory at f7d3a000 (32-bit, non-prefetchable) [size=2K]
> 	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
> 		Address: fee2200c  Data: 4191
> 	Capabilities: [70] Power Management version 3
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
> 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
> 	Kernel driver in use: ahci

Relevant dmesg from boot:

ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 5 ports 6 Gbps 0x1e impl SATA
mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
ata1: DUMMY
ata2: SATA max UDMA/133 abar m2048@0xf7d3a000 port 0xf7d3a180 irq 41
ata3: SATA max UDMA/133 abar m2048@0xf7d3a000 port 0xf7d3a200 irq 41
ata4: SATA max UDMA/133 abar m2048@0xf7d3a000 port 0xf7d3a280 irq 41
ata5: SATA max UDMA/133 abar m2048@0xf7d3a000 port 0xf7d3a300 irq 41

