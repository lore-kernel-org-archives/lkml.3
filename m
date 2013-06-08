Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3FHRfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 13:35:36 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:37154 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3FHRfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 13:35:34 -0400
MIME-Version: 1.0
X-Originating-IP: [84.115.78.137]
Date: Sat, 8 Jun 2013 19:35:33 +0200
Message-ID: <CALG0vJvStT521aKTq555sAD+-CeZn_7bu4p36ATC3dSwVEPXMA@mail.gmail.com>
Subject: [BUG] PCI related panic on powerpc based board with 3.10-rcX
From: Michael Guntsche <michael.guntsche@it-loops.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good evening,


I recently tested the latest 3.10-rc release (rc4) on my powerpc based
routerboard which is currently running very stable on a 3.9 release.
During boot I immediately got a kernel panic.
I was able to get a log of the trace with the serial console.

[    0.039522] PCI: Probing PCI hardware
[    0.043159] PCI: Memory resource 0 not set for host bridge
/pci@e0008500 (domain 0)
[    0.050778] PCI: Memory resource 0 not set for host bridge
/pci@e0008500 (domain 0)
[    0.058855] PCI host bridge to bus 0000:00
[    0.062938] pci_bus 0000:00: root bus resource [io  0x0000-0xffffff]
[    0.069255] pci_bus 0000:00: root bus resource [mem 0x80000000-0x9fffffff]
[    0.076131] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.081639] Unable to handle kernel paging request for data at
address 0x00000f14
[    0.089068] Faulting instruction address: 0xc0014d40
[    0.094031] Oops: Kernel access of bad area, sig: 11 [#1]
[    0.099420] MikroTik RouterBOARD 600 series
[    0.103597] Modules linked in:
[    0.106651] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc1+ #15
[    0.112910] task: c782e000 ti: c7834000 task.ti: c7834000
[    0.118303] NIP: c0014d40 LR: c0014dd8 CTR: c0014e10
[    0.123262] REGS: c7835b40 TRAP: 0300   Not tainted  (3.10.0-rc1+)
[    0.129435] MSR: 00001032 <ME,IR,DR,RI>  CR: 22000084  XER: 20000000
[    0.135788] DAR: 00000f14, DSISR: 20000000
[    0.139875]
GPR00: c0014e40 c7835bf0 c782e000 c0417000 00000000 00000000 00000004 00000000
GPR08: 00000000 00000000 00000000 00000037 22000084 00000000 c0003e90 00000000
GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000045
GPR24: c0400000 c03f0000 c036134c c782de00 00000000 0000ea60 c782de00 c0417000
[    0.169567] NIP [c0014d40] fsl_pcie_check_link.part.4+0x8/0x2c
[    0.175380] LR [c0014dd8] fsl_pcie_check_link+0x74/0xac
[    0.180591] Call Trace:
[    0.183033] [c7835bf0] [00000025] 0x25 (unreliable)
[    0.187909] [c7835d80] [c0014e40] fsl_indirect_read_config+0x30/0x8c
[    0.194270] [c7835da0] [c019c108] pci_bus_read_config_dword+0x60/0x80
[    0.200703] [c7835dc0] [c019df3c] pci_bus_read_dev_vendor_id+0x34/0x108
[    0.207321] [c7835df0] [c022d394] pci_scan_single_device+0x58/0xc8
[    0.213488] [c7835e20] [c019f068] pci_scan_slot+0x54/0x110
[    0.218969] [c7835e40] [c019fc40] pci_scan_child_bus+0x28/0xdc
[    0.224811] [c7835e60] [c0010aa4] pcibios_scan_phb+0x19c/0x210
[    0.230640] [c7835e90] [c03b4658] pcibios_init+0x7c/0x114
[    0.236025] [c7835ec0] [c00039a4] do_one_initcall+0x150/0x1a4
[    0.241763] [c7835ef0] [c03b1888] kernel_init_freeable+0x114/0x1bc
[    0.247938] [c7835f30] [c0003ea8] kernel_init+0x18/0x110
[    0.253247] [c7835f40] [c000e098] ret_from_kernel_thread+0x64/0x6c
[    0.259417] --- Exception: 0 at   (null)
[    0.259417]     LR =   (null)
[    0.266287] Instruction dump:
[    0.269246] 3d400006 614a0400 915f0028 3d40c040 912afc88 80010024
83e1001c 38210020
[    0.276988] 7c0803a6 4e800020 812300ec 7c0004ac <80690f14> 0c030000
4c00012c 5463f6be
[    0.284945] ---[ end trace 074b946a523243d5 ]---


Compare this to booting with 3.9


[    0.039088] PCI: Probing PCI hardware
[    0.043151] PCI host bridge to bus 0000:00
[    0.047232] pci_bus 0000:00: root bus resource [io  0x0000-0xffffff]
[    0.053546] pci_bus 0000:00: root bus resource [mem 0x80000000-0x9fffffff]
[    0.060419] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.068080] pci 0000:00:0d.0: BAR 0: assigned [mem 0x80000000-0x8000ffff]
[    0.074854] pci 0000:00:0b.0: BAR 0: assigned [io  0x1000-0x10ff]
[    0.080908] pci 0000:00:0b.0: BAR 1: assigned [mem 0x80010000-0x800100ff]
[    0.103986] bio: create slab <bio-0> at 0
[    0.108589] Freescale Elo / Elo Plus DMA driver
[    0.115166] SCSI subsystem initialized

Especially I do not understand why this message shows up now

 PCI: Memory resource 0 not set for host bridge

Does someone have an idea what's happening here?
I tested this also on rc1 and got the same panic there.
Please CC me on any replies since I am not subscribed to the list.

Thank you very much in advance,

Michael Guntsche
