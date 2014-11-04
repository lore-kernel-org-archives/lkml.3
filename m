Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaKDSie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:38:34 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:64441 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaKDSia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:38:30 -0500
MIME-Version: 1.0
In-Reply-To: <20141104162251.GF10744@8bytes.org>
References: <20141104162251.GF10744@8bytes.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 4 Nov 2014 11:38:09 -0700
Message-ID: <CAErSpo4Zx8hNjJdHvJeLzj_wAJSa6WCDuJ0XYymK-QU_i+MECg@mail.gmail.com>
Subject: Re: Kernel NULL pointer deref in pci_get_hp_params with v3.18-rc3
To: Joerg Roedel <joro@8bytes.org>
Cc: Jon Mason <jdmason@kudzu.us>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Yinghai]

On Tue, Nov 4, 2014 at 9:22 AM, Joerg Roedel <joro@8bytes.org> wrote:
> Hi,
>
> booting v3.18-rc3 (havn't tested earlier -rcs on this box) on a Xeon box
> with a Neterion 10GBit card (vxge driver) I see the following NULL
> pointer deref in dmesg:
>
> [    7.221747] vxge: Copyright(c) 2002-2010 Exar Corp.
> [    7.221749] vxge: Driver version: 2.5.3.22640-k
> [    7.324070] pci 0000:07:00.1: [17d5:5833] type 00 class 0x020000
> [    7.324144] BUG: unable to handle kernel NULL pointer dereference at 00000000000002d8
> [    7.324162] IP: [<ffffffff8136733b>] pci_get_hp_params+0x2b/0x620

I think this is the same problem Yinghai posted a patch for:
http://lkml.kernel.org/r/1414621570-20777-1-git-send-email-yinghai@kernel.org

I broke things with 6cd33649fa83, and I'd like to try a different fix
than Yinghai's, so I guess I should get busy :)  Thanks for the
reminder.

Bjorn

> [    7.324171] PGD 452334067 PUD 452335067 PMD 0
> [    7.324179] Oops: 0000 [#1] PREEMPT SMP
> [    7.324185] Modules linked in: vxge(+) dcdbas ptp sr_mod shpchp pps_core lrw snd iTCO_wdt iTCO_vendor_support cdrom i2c_i801 pcspkr mei_me mei serio_raw lpc_ich gf128mul ata_generic glue_helper soundcore aes_x86_64 mfd_core sg d
> m_mod autofs4 nouveau ttm drm_kms_helper drm i2c_algo_bit mxm_wmi video wmi processor thermal_sys button scsi_dh_emc scsi_dh_rdac scsi_dh_alua scsi_dh_hp_sw scsi_dh
> [    7.324254] CPU: 6 PID: 389 Comm: systemd-udevd Not tainted 3.18.0-rc3 #14
> [    7.324260] Hardware name: Dell Inc. Precision T3610/09M8Y8, BIOS A06 02/28/2014
> [    7.324265] task: ffff880450c14150 ti: ffff88045226c000 task.ti: ffff88045226c000
> [    7.324270] RIP: 0010:[<ffffffff8136733b>]  [<ffffffff8136733b>] pci_get_hp_params+0x2b/0x620
> [    7.324278] RSP: 0018:ffff88045226f8e8  EFLAGS: 00010202
> [    7.324282] RAX: ffff880459df2800 RBX: ffff880450a8a000 RCX: 0000000000000000
> [    7.324287] RDX: 0000000000000098 RSI: ffff88045226f950 RDI: ffff880450a8a000
> [    7.324292] RBP: ffff88045226f938 R08: ffff880459df55e8 R09: ffff88045226f984
> [    7.324297] R10: 0000000000000001 R11: ffff88045226f51e R12: ffff88045226f950
> [    7.324302] R13: ffff880450a8a098 R14: ffff8804521ce000 R15: ffff880450a8a0a8
> [    7.324307] FS:  00007f3dcede3880(0000) GS:ffff88046fd80000(0000) knlGS:0000000000000000
> [    7.324312] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    7.324317] CR2: 00000000000002d8 CR3: 00000004514ab000 CR4: 00000000001407e0
> [    7.324322] Stack:
> [    7.324325]  ffff88045226f8f8 0000000000000006 ffff88045226f938 ffffffff8150d959
> [    7.324333]  ffff88045226f918 ffff880450a8a000 ffff8804521ce028 ffff880450a8a098
> [    7.324342]  ffff8804521ce000 ffff880450a8a0a8 ffff88045226f9d8 ffffffff813422ce
> [    7.324351] Call Trace:
> [    7.324357]  [<ffffffff8150d959>] ? pci_conf1_read+0xb9/0x120
> [    7.324364]  [<ffffffff813422ce>] pci_configure_device+0x2e/0x340
> [    7.324369]  [<ffffffff81343a13>] pci_device_add+0x23/0x160
> [    7.324373]  [<ffffffff813665ce>] pci_enable_sriov+0x44e/0x7a0
> [    7.324379]  [<ffffffffa0313f9c>] vxge_probe+0xaec/0x1b70 [vxge]
> [    7.324384]  [<ffffffff8134ab30>] local_pci_probe+0x40/0xa0
> [    7.324388]  [<ffffffff8134bd85>] ? pci_match_device+0xe5/0x110
> [    7.324392]  [<ffffffff8134bec1>] pci_device_probe+0xd1/0x130
> [    7.324397]  [<ffffffff8140f98b>] driver_probe_device+0x8b/0x3d0
> [    7.324401]  [<ffffffff8140fda3>] __driver_attach+0x93/0xa0
> [    7.324405]  [<ffffffff8140fd10>] ? __device_attach+0x40/0x40
> [    7.324409]  [<ffffffff8140da03>] bus_for_each_dev+0x63/0xa0
> [    7.324415]  [<ffffffff8140f409>] driver_attach+0x19/0x20
> [    7.324419]  [<ffffffff8140f020>] bus_add_driver+0x180/0x250
> [    7.324424]  [<ffffffffa02ef000>] ? 0xffffffffa02ef000
> [    7.324427]  [<ffffffff814105ff>] driver_register+0x5f/0xf0
> [    7.324431]  [<ffffffff8134a4d7>] __pci_register_driver+0x47/0x50
> [    7.324436]  [<ffffffffa02ef0d8>] vxge_starter+0xd8/0x1000 [vxge]
> [    7.324439]  [<ffffffffa02ef000>] ? 0xffffffffa02ef000
> [    7.324445]  [<ffffffff810002f4>] do_one_initcall+0xb4/0x1f0
> [    7.324450]  [<ffffffff81179472>] ? __vunmap+0xb2/0x100
> [    7.324455]  [<ffffffff810d6ef1>] load_module+0x2181/0x26c0
> [    7.324459]  [<ffffffff810d2900>] ? store_uevent+0x40/0x40
> [    7.324463]  [<ffffffff810d759e>] SyS_finit_module+0x7e/0xa0
> [    7.324469]  [<ffffffff8160e6ed>] system_call_fastpath+0x16/0x1b
> [    7.324472] Code: 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 f4 53 48 83 ec 28 48 8b 57 10 48 85 d2 75 2b eb 41 90 48 8b 52 38 48 81 c2 98 00 00 00 <48> 8b 92 40 02 00 00 48 85 d2 74 09 48 8b 5a 08 48 85 db 75 38
> [    7.324519] RIP  [<ffffffff8136733b>] pci_get_hp_params+0x2b/0x620
> [    7.324524]  RSP <ffff88045226f8e8>
> [    7.324526] CR2: 00000000000002d8
> [    7.332761] ---[ end trace 32633098d70cadfd ]---
>
> Here is lspci from the box:
>
> 00:00.0 Host bridge: Intel Corporation Xeon E5 v2/Core i7 DMI2 (rev 04)
> 00:01.0 PCI bridge: Intel Corporation Xeon E5 v2/Core i7 PCI Express Root Port 1a (rev 04)
> 00:02.0 PCI bridge: Intel Corporation Xeon E5 v2/Core i7 PCI Express Root Port 2a (rev 04)
> 00:03.0 PCI bridge: Intel Corporation Xeon E5 v2/Core i7 PCI Express Root Port 3a (rev 04)
> 00:05.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 VTd/Memory Map/Misc (rev 04)
> 00:05.2 System peripheral: Intel Corporation Xeon E5 v2/Core i7 IIO RAS (rev 04)
> 00:05.4 PIC: Intel Corporation Xeon E5 v2/Core i7 IOAPIC (rev 04)
> 00:11.0 PCI bridge: Intel Corporation C600/X79 series chipset PCI Express Virtual Root Port (rev 06)
> 00:16.0 Communication controller: Intel Corporation C600/X79 series chipset MEI Controller #1 (rev 05)
> 00:16.2 IDE interface: Intel Corporation C600/X79 series chipset IDE-r Controller (rev 05)
> 00:16.3 Serial controller: Intel Corporation C600/X79 series chipset KT Controller (rev 05)
> 00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network Connection (rev 06)
> 00:1a.0 USB controller: Intel Corporation C600/X79 series chipset USB2 Enhanced Host Controller #2 (rev 06)
> 00:1b.0 Audio device: Intel Corporation C600/X79 series chipset High Definition Audio Controller (rev 06)
> 00:1c.0 PCI bridge: Intel Corporation C600/X79 series chipset PCI Express Root Port 3 (rev b6)
> 00:1c.4 PCI bridge: Intel Corporation C600/X79 series chipset PCI Express Root Port 5 (rev b6)
> 00:1d.0 USB controller: Intel Corporation C600/X79 series chipset USB2 Enhanced Host Controller #1 (rev 06)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a6)
> 00:1f.0 ISA bridge: Intel Corporation C600/X79 series chipset LPC Controller (rev 06)
> 00:1f.2 RAID bus controller: Intel Corporation C600/X79 series chipset SATA RAID Controller (rev 06)
> 00:1f.3 SMBus: Intel Corporation C600/X79 series chipset SMBus Host Controller (rev 06)
> 02:00.0 VGA compatible controller: NVIDIA Corporation GF119 [NVS 310] (rev a1)
> 02:00.1 Audio device: NVIDIA Corporation GF119 HDMI Audio Controller (rev a1)
> 03:00.0 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (be3) (rev 01)
> 03:00.1 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (be3) (rev 01)
> 05:00.0 USB controller: Renesas Technology Corp. uPD720201 USB 3.0 Host Controller (rev 03)
> 06:00.0 Ethernet controller: Exar Corp. X3100 Series 10 Gigabit Ethernet PCIe (rev 02)
> ff:08.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 QPI Link 0 (rev 04)
> ff:09.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 QPI Link 1 (rev 04)
> ff:0a.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Power Control Unit 0 (rev 04)
> ff:0a.1 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Power Control Unit 1 (rev 04)
> ff:0a.2 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Power Control Unit 2 (rev 04)
> ff:0a.3 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Power Control Unit 3 (rev 04)
> ff:0b.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 UBOX Registers (rev 04)
> ff:0b.3 System peripheral: Intel Corporation Xeon E5 v2/Core i7 UBOX Registers (rev 04)
> ff:0c.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Unicast Registers (rev 04)
> ff:0c.1 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Unicast Registers (rev 04)
> ff:0d.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Unicast Registers (rev 04)
> ff:0d.1 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Unicast Registers (rev 04)
> ff:0e.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Home Agent 0 (rev 04)
> ff:0e.1 Performance counters: Intel Corporation Xeon E5 v2/Core i7 Home Agent 0 (rev 04)
> ff:0f.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 0 Target Address/Thermal Registers (rev 04)
> ff:0f.1 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 0 RAS Registers (rev 04)
> ff:0f.2 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 0 Channel Target Address Decoder Registers (rev 04)
> ff:0f.3 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 0 Channel Target Address Decoder Registers (rev 04)
> ff:0f.4 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 0 Channel Target Address Decoder Registers (rev 04)
> ff:0f.5 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 0 Channel Target Address Decoder Registers (rev 04)
> ff:10.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 1 Channel 0-3 Thermal Control 0 (rev 04)
> ff:10.1 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 1 Channel 0-3 Thermal Control 1 (rev 04)
> ff:10.2 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 1 Channel 0-3 ERROR Registers 0 (rev 04)
> ff:10.3 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 1 Channel 0-3 ERROR Registers 1 (rev 04)
> ff:10.4 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 1 Channel 0-3 Thermal Control 2 (rev 04)
> ff:10.5 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 1 Channel 0-3 Thermal Control 3 (rev 04)
> ff:10.6 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 1 Channel 0-3 ERROR Registers 2 (rev 04)
> ff:10.7 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Integrated Memory Controller 1 Channel 0-3 ERROR Registers 3 (rev 04)
> ff:13.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 R2PCIe (rev 04)
> ff:13.1 Performance counters: Intel Corporation Xeon E5 v2/Core i7 R2PCIe (rev 04)
> ff:13.4 System peripheral: Intel Corporation Xeon E5 v2/Core i7 QPI Ring Registers (rev 04)
> ff:13.5 Performance counters: Intel Corporation Xeon E5 v2/Core i7 QPI Ring Performance Ring Monitoring (rev 04)
> ff:16.0 System peripheral: Intel Corporation Xeon E5 v2/Core i7 System Address Decoder (rev 04)
> ff:16.1 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Broadcast Registers (rev 04)
> ff:16.2 System peripheral: Intel Corporation Xeon E5 v2/Core i7 Broadcast Registers (rev 04)
>
> Please let me know if you need more information.
>
>
>         Joerg
>
