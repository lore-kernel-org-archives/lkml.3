Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab3CHVdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:33:19 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:57704 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3CHVdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:33:17 -0500
Message-ID: <1362778382.20990.17.camel@thor.lan>
Subject: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt
 responses)
From: Peter Hurley <peter@hurleysoftware.com>
To: Shawn Starr <shawn.starr@rogers.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Fri, 08 Mar 2013 16:33:02 -0500
In-Reply-To: <2663178.G2EStYDi2n@segfault.sh0n.net>
References: <2663178.G2EStYDi2n@segfault.sh0n.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +linux-usb ]

On Fri, 2013-03-08 at 14:12 -0500, Shawn Starr wrote:
> Hello folks,
> 
> I am noticing since rc0 and now rc1, very poor interrupt handling. Keyboard response, mouse movements, display refreshing etc. General input/display sluggishness. Did something break IRQ handling somewhere? I need to validate if this happens with X not running also if it is i915 related somehow. The behavor is noticed in a console login however.
> 
> Device: Lenovo W500 laptop

Hi Shawn,

Unhandled interrupts is the problem.

Is the device below being id'd properly?
If you remove this device, does the problem go away?

> Bus 006 Device 004: ID 0557:2004 ATEN International Co., Ltd UC-100KM PS/2 Mouse and Keyboard adapter


> [    2.947806] usb 6-2: New USB device found, idVendor=0557, idProduct=2004
> [    2.947825] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.947832] usb 6-2: Product: UC100KM V2.10
> [    2.947837] usb 6-2: Manufacturer: ATEN
> [    2.968796] input: ATEN UC100KM V2.10 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input7
> [    2.969451] hid-generic 0003:0557:2004.0002: input,hidraw1: USB HID v1.00 Keyboard [ATEN UC100KM V2.10] on usb-0000:00:1d.0-2/input0
> [    2.991716] input: ATEN UC100KM V2.10 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.1/input/input8
> [    2.992227] hid-generic 0003:0557:2004.0003: input,hidraw2: USB HID v1.00 Mouse [ATEN UC100KM V2.10] on usb-0000:00:1d.0-2/input1

> [    3.538457] irq 16: nobody cared (try booting with the "irqpoll" option)
> [    3.538463] Pid: 0, comm: swapper/1 Not tainted 3.9.0-0.rc1.git0.5.fc19.x86_64 #1
> [    3.538464] Call Trace:
> [    3.538466]  <IRQ>  [<ffffffff810ee1f2>] __report_bad_irq+0x32/0xd0
> [    3.538475]  [<ffffffff810ee608>] note_interrupt+0x138/0x1f0
> [    3.538479]  [<ffffffff814f0461>] ? cpuidle_wrap_enter+0x41/0x80
> [    3.538482]  [<ffffffff814efae0>] ? intel_pstate_timer_func+0x350/0x350
> [    3.538485]  [<ffffffff810ebfc1>] handle_irq_event_percpu+0xe1/0x1e0
> [    3.538488]  [<ffffffff814efae0>] ? intel_pstate_timer_func+0x350/0x350
> [    3.538490]  [<ffffffff810ec0f6>] handle_irq_event+0x36/0x60
> [    3.538493]  [<ffffffff810ef145>] handle_fasteoi_irq+0x55/0xf0
> [    3.538496]  [<ffffffff810151ef>] handle_irq+0xbf/0x150
> [    3.538500]  [<ffffffff81649e5a>] ? atomic_notifier_call_chain+0x1a/0x20
> [    3.538503]  [<ffffffff8164ff0d>] do_IRQ+0x4d/0xc0
> [    3.538505]  [<ffffffff816461ad>] common_interrupt+0x6d/0x6d
> [    3.538506]  <EOI>  [<ffffffff814f0461>] ? cpuidle_wrap_enter+0x41/0x80
> [    3.538511]  [<ffffffff814f04b0>] cpuidle_enter_tk+0x10/0x20
> [    3.538513]  [<ffffffff814f0212>] cpuidle_idle_call+0xb2/0x1e0
> [    3.538516]  [<ffffffff8101c025>] cpu_idle+0xe5/0x140
> [    3.538520]  [<ffffffff81634226>] start_secondary+0x249/0x24b
> [    3.538522] handlers:
> [    3.538525] [<ffffffff81458bf0>] usb_hcd_irq
> [    3.538530] [<ffffffffa0173a00>] yenta_interrupt [yenta_socket]
> [    3.538531] Disabling IRQ #16
> [    5.281769] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64>


> -- device info --
> 
> PCI Bus:
> 
> 00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
> 00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
> 00:03.0 Communication controller: Intel Corporation Mobile 4 Series Chipset MEI Controller (rev 07)
> 00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
> 00:1a.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
> 00:1a.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
> 00:1a.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
> 00:1a.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
> 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
> 00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
> 00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 03)
> 00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
> 00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
> 00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
> 00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
> 00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
> 00:1f.2 SATA controller: Intel Corporation 82801IBM/IEM (ICH9M/ICH9M-E) 4 port SATA Controller [AHCI mode] (rev 03)
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] Network Connection
> 15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
> 15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
> 15:00.4 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 11)
> 15:00.5 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 11)
> 
> USB Bus:
> 
> Bus 001 Device 003: ID 046d:0990 Logitech, Inc. QuickCam Pro 9000
> Bus 006 Device 005: ID 045e:00cb Microsoft Corp. Basic Optical Mouse v2.0
> Bus 006 Device 004: ID 0557:2004 ATEN International Co., Ltd UC-100KM PS/2 Mouse and Keyboard adapter
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> 
> 
> IRQ listing:
> 
>            CPU0       CPU1       
>   0:      69725      70165   IO-APIC-edge      timer
>   1:        394        399   IO-APIC-edge      i8042
>   8:          1          0   IO-APIC-edge      rtc0
>   9:        832        838   IO-APIC-fasteoi   acpi
>  12:      12274      12373   IO-APIC-edge      i8042
>  16:      50489      49512   IO-APIC-fasteoi   uhci_hcd:usb6, yenta
>  17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb7
>  18:         27         25   IO-APIC-fasteoi   uhci_hcd:usb8, mmc0, r592
>  19:          4          3   IO-APIC-fasteoi   ehci_hcd:usb2
>  20:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  21:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
>  23:       8252       7917   IO-APIC-fasteoi   ehci_hcd:usb1, i801_smbus
>  40:          0          0   PCI-MSI-edge      PCIe PME, pciehp
>  41:          0          0   PCI-MSI-edge      PCIe PME, pciehp
>  42:          0          0   PCI-MSI-edge      PCIe PME, pciehp
>  43:      15869      15940   PCI-MSI-edge      ahci
>  44:      78508      78030   PCI-MSI-edge      i915
>  45:         10       3243   PCI-MSI-edge      eth0
>  46:          0          1   PCI-MSI-edge      iwlwifi
>  47:        151        145   PCI-MSI-edge      snd_hda_intel
> NMI:         53         60   Non-maskable interrupts
> LOC:      90697     218602   Local timer interrupts
> SPU:          0          0   Spurious interrupts
> PMI:         53         60   Performance monitoring interrupts
> IWI:          0          1   IRQ work interrupts
> RTR:          0          0   APIC ICR read retries
> RES:      30534      11218   Rescheduling interrupts
> CAL:      40751      15944   Function call interrupts
> TLB:        279        402   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> THR:          0          0   Threshold APIC interrupts
> MCE:          0          0   Machine check exceptions
> MCP:          5          5   Machine check polls
> ERR:          0
> MIS:          0
> 
> 
> full kernel boot:
> 
> [spstarr@segfault ~]$ dmesg -f kern
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.9.0-0.rc1.git0.5.fc19.x86_64 (mockbuild@buildvm-22.phx2.fedoraproject.org) (gcc version 4.8.0 20130304 (Red Hat 4.8.0-0.15) (GCC) ) #1 SMP Thu Mar 7 04:22:17 UTC 2013
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.9.0-0.rc1.git0.5.fc19.x86_64 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap rd.md=0 rd.dm=0 rd.luks=0 rd.lvm.lv=fedora/root rhgb quiet elevator=deadline slub_debug=- LANG=en_US.UTF-8
> [    0.000000] Disabled fast string operations
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bd4a0fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bd4a1000-0x00000000bd4a6fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bd4a7000-0x00000000bd5b6fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bd5b7000-0x00000000bd60efff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bd60f000-0x00000000bd6c5fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bd6c6000-0x00000000bd6d0fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bd6d1000-0x00000000bd6d3fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bd6d4000-0x00000000bd6d7fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bd6d8000-0x00000000bd6dbfff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bd6dc000-0x00000000bd6defff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bd6df000-0x00000000bd705fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bd706000-0x00000000bd707fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bd708000-0x00000000bd90efff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bd90f000-0x00000000bd99efff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bd99f000-0x00000000bd9fefff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bd9ff000-0x00000000bd9fffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bdc00000-0x00000000bfffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023bffffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: LENOVO 4058CTO/4058CTO, BIOS 6FET93WW (3.23 ) 10/12/2012
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x23c000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 23C000000 mask FFC000000 uncachable
> [    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
> [    0.000000]   2 base 000000000 mask F80000000 write-back
> [    0.000000]   3 base 080000000 mask FC0000000 write-back
> [    0.000000]   4 base 100000000 mask F00000000 write-back
> [    0.000000]   5 base 200000000 mask FC0000000 write-back
> [    0.000000]   6 base 0BDE00000 mask FFFE00000 uncachable
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] original variable MTRRs
> [    0.000000] reg 0, base: 9152MB, range: 64MB, type UC
> [    0.000000] reg 1, base: 3040MB, range: 32MB, type UC
> [    0.000000] reg 2, base: 0GB, range: 2GB, type WB
> [    0.000000] reg 3, base: 2GB, range: 1GB, type WB
> [    0.000000] reg 4, base: 4GB, range: 4GB, type WB
> [    0.000000] reg 5, base: 8GB, range: 1GB, type WB
> [    0.000000] reg 6, base: 3038MB, range: 2MB, type UC
> [    0.000000] total RAM covered: 8094M
> [    0.000000]  gran_size: 64K  chunk_size: 64K         num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 64K  chunk_size: 128K        num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 64K  chunk_size: 256K        num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 64K  chunk_size: 512K        num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 64K  chunk_size: 1M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 64K  chunk_size: 2M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 64K  chunk_size: 4M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 64K  chunk_size: 8M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 64K  chunk_size: 16M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 64K  chunk_size: 32M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 64K  chunk_size: 64M         num_reg: 7      lose cover RAM: 192M
> [    0.000000]  gran_size: 64K  chunk_size: 128M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 64K  chunk_size: 256M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 64K  chunk_size: 512M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 64K  chunk_size: 1G  num_reg: 7      lose cover RAM: 0G
> [    0.000000] *BAD*gran_size: 64K      chunk_size: 2G  num_reg: 7      lose cover RAM: -1G
> [    0.000000]  gran_size: 128K         chunk_size: 128K        num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 128K         chunk_size: 256K        num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 128K         chunk_size: 512K        num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 128K         chunk_size: 1M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 128K         chunk_size: 2M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 128K         chunk_size: 4M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 128K         chunk_size: 8M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 128K         chunk_size: 16M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 128K         chunk_size: 32M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 128K         chunk_size: 64M         num_reg: 7      lose cover RAM: 192M
> [    0.000000]  gran_size: 128K         chunk_size: 128M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 128K         chunk_size: 256M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 128K         chunk_size: 512M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 128K         chunk_size: 1G  num_reg: 7      lose cover RAM: 0G
> [    0.000000] *BAD*gran_size: 128K     chunk_size: 2G  num_reg: 7      lose cover RAM: -1G
> [    0.000000]  gran_size: 256K         chunk_size: 256K        num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 256K         chunk_size: 512K        num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 256K         chunk_size: 1M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 256K         chunk_size: 2M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 256K         chunk_size: 4M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 256K         chunk_size: 8M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 256K         chunk_size: 16M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 256K         chunk_size: 32M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 256K         chunk_size: 64M         num_reg: 7      lose cover RAM: 192M
> [    0.000000]  gran_size: 256K         chunk_size: 128M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 256K         chunk_size: 256M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 256K         chunk_size: 512M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 256K         chunk_size: 1G  num_reg: 7      lose cover RAM: 0G
> [    0.000000] *BAD*gran_size: 256K     chunk_size: 2G  num_reg: 7      lose cover RAM: -1G
> [    0.000000]  gran_size: 512K         chunk_size: 512K        num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 512K         chunk_size: 1M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 512K         chunk_size: 2M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 512K         chunk_size: 4M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 512K         chunk_size: 8M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 512K         chunk_size: 16M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 512K         chunk_size: 32M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 512K         chunk_size: 64M         num_reg: 7      lose cover RAM: 192M
> [    0.000000]  gran_size: 512K         chunk_size: 128M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 512K         chunk_size: 256M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 512K         chunk_size: 512M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 512K         chunk_size: 1G  num_reg: 7      lose cover RAM: 0G
> [    0.000000] *BAD*gran_size: 512K     chunk_size: 2G  num_reg: 7      lose cover RAM: -1G
> [    0.000000]  gran_size: 1M   chunk_size: 1M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 1M   chunk_size: 2M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 1M   chunk_size: 4M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 1M   chunk_size: 8M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 1M   chunk_size: 16M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 1M   chunk_size: 32M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 1M   chunk_size: 64M         num_reg: 7      lose cover RAM: 192M
> [    0.000000]  gran_size: 1M   chunk_size: 128M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 1M   chunk_size: 256M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 1M   chunk_size: 512M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 1M   chunk_size: 1G  num_reg: 7      lose cover RAM: 0G
> [    0.000000] *BAD*gran_size: 1M       chunk_size: 2G  num_reg: 7      lose cover RAM: -1G
> [    0.000000]  gran_size: 2M   chunk_size: 2M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 2M   chunk_size: 4M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 2M   chunk_size: 8M  num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 2M   chunk_size: 16M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 2M   chunk_size: 32M         num_reg: 7      lose cover RAM: 5056M
> [    0.000000]  gran_size: 2M   chunk_size: 64M         num_reg: 7      lose cover RAM: 192M
> [    0.000000]  gran_size: 2M   chunk_size: 128M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 2M   chunk_size: 256M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 2M   chunk_size: 512M        num_reg: 7      lose cover RAM: 0G
> [    0.000000]  gran_size: 2M   chunk_size: 1G  num_reg: 7      lose cover RAM: 0G
> [    0.000000] *BAD*gran_size: 2M       chunk_size: 2G  num_reg: 7      lose cover RAM: -1G
> [    0.000000]  gran_size: 4M   chunk_size: 4M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 4M   chunk_size: 8M  num_reg: 7      lose cover RAM: 5058M
> [    0.000000]  gran_size: 4M   chunk_size: 16M         num_reg: 7      lose cover RAM: 5058M
> [    0.000000]  gran_size: 4M   chunk_size: 32M         num_reg: 7      lose cover RAM: 5058M
> [    0.000000]  gran_size: 4M   chunk_size: 64M         num_reg: 7      lose cover RAM: 194M
> [    0.000000]  gran_size: 4M   chunk_size: 128M        num_reg: 7      lose cover RAM: 2M
> [    0.000000]  gran_size: 4M   chunk_size: 256M        num_reg: 7      lose cover RAM: 2M
> [    0.000000]  gran_size: 4M   chunk_size: 512M        num_reg: 7      lose cover RAM: 2M
> [    0.000000]  gran_size: 4M   chunk_size: 1G  num_reg: 7      lose cover RAM: 2M
> [    0.000000] *BAD*gran_size: 4M       chunk_size: 2G  num_reg: 7      lose cover RAM: -1022M
> [    0.000000]  gran_size: 8M   chunk_size: 8M  num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 8M   chunk_size: 16M         num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 8M   chunk_size: 32M         num_reg: 7      lose cover RAM: 5062M
> [    0.000000]  gran_size: 8M   chunk_size: 64M         num_reg: 7      lose cover RAM: 198M
> [    0.000000]  gran_size: 8M   chunk_size: 128M        num_reg: 7      lose cover RAM: 6M
> [    0.000000]  gran_size: 8M   chunk_size: 256M        num_reg: 7      lose cover RAM: 6M
> [    0.000000]  gran_size: 8M   chunk_size: 512M        num_reg: 7      lose cover RAM: 6M
> [    0.000000]  gran_size: 8M   chunk_size: 1G  num_reg: 7      lose cover RAM: 6M
> [    0.000000] *BAD*gran_size: 8M       chunk_size: 2G  num_reg: 7      lose cover RAM: -1018M
> [    0.000000]  gran_size: 16M  chunk_size: 16M         num_reg: 7      lose cover RAM: 974M
> [    0.000000]  gran_size: 16M  chunk_size: 32M         num_reg: 7      lose cover RAM: 5070M
> [    0.000000]  gran_size: 16M  chunk_size: 64M         num_reg: 7      lose cover RAM: 206M
> [    0.000000]  gran_size: 16M  chunk_size: 128M        num_reg: 7      lose cover RAM: 14M
> [    0.000000]  gran_size: 16M  chunk_size: 256M        num_reg: 7      lose cover RAM: 14M
> [    0.000000]  gran_size: 16M  chunk_size: 512M        num_reg: 7      lose cover RAM: 14M
> [    0.000000]  gran_size: 16M  chunk_size: 1G  num_reg: 7      lose cover RAM: 14M
> [    0.000000] *BAD*gran_size: 16M      chunk_size: 2G  num_reg: 7      lose cover RAM: -1010M
> [    0.000000]  gran_size: 32M  chunk_size: 32M         num_reg: 7      lose cover RAM: 478M
> [    0.000000]  gran_size: 32M  chunk_size: 64M         num_reg: 7      lose cover RAM: 478M
> [    0.000000]  gran_size: 32M  chunk_size: 128M        num_reg: 6      lose cover RAM: 30M
> [    0.000000]  gran_size: 32M  chunk_size: 256M        num_reg: 6      lose cover RAM: 30M
> [    0.000000]  gran_size: 32M  chunk_size: 512M        num_reg: 6      lose cover RAM: 30M
> [    0.000000]  gran_size: 32M  chunk_size: 1G  num_reg: 6      lose cover RAM: 30M
> [    0.000000]  gran_size: 32M  chunk_size: 2G  num_reg: 7      lose cover RAM: 30M
> [    0.000000]  gran_size: 64M  chunk_size: 64M         num_reg: 7      lose cover RAM: 478M
> [    0.000000]  gran_size: 64M  chunk_size: 128M        num_reg: 6      lose cover RAM: 30M
> [    0.000000]  gran_size: 64M  chunk_size: 256M        num_reg: 6      lose cover RAM: 30M
> [    0.000000]  gran_size: 64M  chunk_size: 512M        num_reg: 6      lose cover RAM: 30M
> [    0.000000]  gran_size: 64M  chunk_size: 1G  num_reg: 6      lose cover RAM: 30M
> [    0.000000]  gran_size: 64M  chunk_size: 2G  num_reg: 7      lose cover RAM: 30M
> [    0.000000]  gran_size: 128M         chunk_size: 128M        num_reg: 7      lose cover RAM: 286M
> [    0.000000]  gran_size: 128M         chunk_size: 256M        num_reg: 6      lose cover RAM: 158M
> [    0.000000]  gran_size: 128M         chunk_size: 512M        num_reg: 6      lose cover RAM: 158M
> [    0.000000]  gran_size: 128M         chunk_size: 1G  num_reg: 6      lose cover RAM: 158M
> [    0.000000]  gran_size: 128M         chunk_size: 2G  num_reg: 7      lose cover RAM: 158M
> [    0.000000]  gran_size: 256M         chunk_size: 256M        num_reg: 6      lose cover RAM: 414M
> [    0.000000]  gran_size: 256M         chunk_size: 512M        num_reg: 6      lose cover RAM: 414M
> [    0.000000]  gran_size: 256M         chunk_size: 1G  num_reg: 6      lose cover RAM: 414M
> [    0.000000]  gran_size: 256M         chunk_size: 2G  num_reg: 7      lose cover RAM: 414M
> [    0.000000]  gran_size: 512M         chunk_size: 512M        num_reg: 4      lose cover RAM: 926M
> [    0.000000]  gran_size: 512M         chunk_size: 1G  num_reg: 6      lose cover RAM: 926M
> [    0.000000]  gran_size: 512M         chunk_size: 2G  num_reg: 7      lose cover RAM: 926M
> [    0.000000]  gran_size: 1G   chunk_size: 1G  num_reg: 2      lose cover RAM: 1950M
> [    0.000000]  gran_size: 1G   chunk_size: 2G  num_reg: 2      lose cover RAM: 1950M
> [    0.000000]  gran_size: 2G   chunk_size: 2G  num_reg: 2      lose cover RAM: 1950M
> [    0.000000] mtrr_cleanup: can not find optimal value
> [    0.000000] please specify mtrr_gran_size/mtrr_chunk_size
> [    0.000000] e820: update [mem 0xbde00000-0xffffffff] usable ==> reserved
> [    0.000000] e820: last_pfn = 0xbda00 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000f6480-0x000f648f] mapped at [ffff8800000f6480]
> [    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x01fc8000, 0x01fc8fff] PGTABLE
> [    0.000000] BRK [0x01fc9000, 0x01fc9fff] PGTABLE
> [    0.000000] BRK [0x01fca000, 0x01fcafff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x23be00000-0x23bffffff]
> [    0.000000]  [mem 0x23be00000-0x23bffffff] page 2M
> [    0.000000] BRK [0x01fcb000, 0x01fcbfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x238000000-0x23bdfffff]
> [    0.000000]  [mem 0x238000000-0x23bdfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x200000000-0x237ffffff]
> [    0.000000]  [mem 0x200000000-0x237ffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0xbd4a0fff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0xbd3fffff] page 2M
> [    0.000000]  [mem 0xbd400000-0xbd4a0fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0xbd4a7000-0xbd5b6fff]
> [    0.000000]  [mem 0xbd4a7000-0xbd5b6fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0xbd60f000-0xbd6c5fff]
> [    0.000000]  [mem 0xbd60f000-0xbd6c5fff] page 4k
> [    0.000000] BRK [0x01fcc000, 0x01fccfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0xbd9ff000-0xbd9fffff]
> [    0.000000]  [mem 0xbd9ff000-0xbd9fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
> [    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
> [    0.000000] RAMDISK: [mem 0x343b4000-0x361d1fff]
> [    0.000000] ACPI: RSDP 00000000000f6440 00024 (v02 LENOVO)
> [    0.000000] ACPI: XSDT 00000000bd949b3a 0009C (v01 LENOVO TP-6F    00003230  LTP 00000000)
> [    0.000000] ACPI: FACP 00000000bd949c00 000F4 (v03 LENOVO TP-6F    00003230 LNVO 00000001)
> [    0.000000] ACPI: DSDT 00000000bd94a00e 0FB01 (v01 LENOVO TP-6F    00003230 MSFT 03000000)
> [    0.000000] ACPI: FACS 00000000bd98e000 00040
> [    0.000000] ACPI: SSDT 00000000bd949db4 0025A (v01 LENOVO TP-6F    00003230 MSFT 03000000)
> [    0.000000] ACPI: ECDT 00000000bd959b0f 00052 (v01 LENOVO TP-6F    00003230 LNVO 00000001)
> [    0.000000] ACPI: APIC 00000000bd959b61 00078 (v01 LENOVO TP-6F    00003230 LNVO 00000001)
> [    0.000000] ACPI: MCFG 00000000bd959bd9 0003C (v01 LENOVO TP-6F    00003230 LNVO 00000001)
> [    0.000000] ACPI: HPET 00000000bd959c15 00038 (v01 LENOVO TP-6F    00003230 LNVO 00000001)
> [    0.000000] ACPI: SLIC 00000000bd959dc2 00176 (v01 LENOVO TP-6F    00003230  LTP 00000000)
> [    0.000000] ACPI: BOOT 00000000bd959f38 00028 (v01 LENOVO TP-6F    00003230  LTP 00000001)
> [    0.000000] ACPI: ASF! 00000000bd959f60 000A0 (v16 LENOVO TP-6F    00003230 PTL  00000001)
> [    0.000000] ACPI: SSDT 00000000bd98d1fa 00568 (v01 LENOVO TP-6F    00003230 INTL 20050513)
> [    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000000      00000000)
> [    0.000000] ACPI: DMAR 00000000bd706000 00120 (v01               ? 00000001      00000000)
> [    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
> [    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
> [    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023bffffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x23bffffff]
> [    0.000000]   NODE_DATA [mem 0x23bfe4000-0x23bff7fff]
> [    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880233600000-ffff88023b5fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x23bffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
> [    0.000000]   node   0: [mem 0x00100000-0xbd4a0fff]
> [    0.000000]   node   0: [mem 0xbd4a7000-0xbd5b6fff]
> [    0.000000]   node   0: [mem 0xbd60f000-0xbd6c5fff]
> [    0.000000]   node   0: [mem 0xbd9ff000-0xbd9fffff]
> [    0.000000]   node   0: [mem 0x100000000-0x23bffffff]
> [    0.000000] On node 0 totalpages: 2070022
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3997 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 12058 pages used for memmap
> [    0.000000]   DMA32 zone: 771689 pages, LIFO batch:31
> [    0.000000]   Normal zone: 20224 pages used for memmap
> [    0.000000]   Normal zone: 1294336 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
> [    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 00000000bd4a1000 - 00000000bd4a7000
> [    0.000000] PM: Registered nosave memory: 00000000bd5b7000 - 00000000bd60f000
> [    0.000000] PM: Registered nosave memory: 00000000bd6c6000 - 00000000bd6d1000
> [    0.000000] PM: Registered nosave memory: 00000000bd6d1000 - 00000000bd6d4000
> [    0.000000] PM: Registered nosave memory: 00000000bd6d4000 - 00000000bd6d8000
> [    0.000000] PM: Registered nosave memory: 00000000bd6d8000 - 00000000bd6dc000
> [    0.000000] PM: Registered nosave memory: 00000000bd6dc000 - 00000000bd6df000
> [    0.000000] PM: Registered nosave memory: 00000000bd6df000 - 00000000bd706000
> [    0.000000] PM: Registered nosave memory: 00000000bd706000 - 00000000bd708000
> [    0.000000] PM: Registered nosave memory: 00000000bd708000 - 00000000bd90f000
> [    0.000000] PM: Registered nosave memory: 00000000bd90f000 - 00000000bd99f000
> [    0.000000] PM: Registered nosave memory: 00000000bd99f000 - 00000000bd9ff000
> [    0.000000] PM: Registered nosave memory: 00000000bda00000 - 00000000bdc00000
> [    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
> [    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
> [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
> [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
> [    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
> [    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
> [    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
> [    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
> [    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
> [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
> [    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
> [    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
> [    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88023bc00000 s85120 r8192 d21376 u524288
> [    0.000000] pcpu-alloc: s85120 r8192 d21376 u524288 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2037655
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.9.0-0.rc1.git0.5.fc19.x86_64 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap rd.md=0 rd.dm=0 rd.luks=0 rd.lvm.lv=fedora/root rhgb quiet elevator=deadline slub_debug=- LANG=en_US.UTF-8
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 8035144k/9371648k available (6472k kernel code, 1091560k absent, 244944k reserved, 6771k data, 1356k init)
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=4.
> [    0.000000] NR_IRQS:8448 nr_irqs:712 16
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 33554432 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration failed
> [    0.000000] tsc: Unable to calibrate against PIT
> [    0.000000] tsc: using HPET reference calibration
> [    0.000000] tsc: Detected 2526.945 MHz processor
> [    0.004003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.89 BogoMIPS (lpj=2526945)
> [    0.004006] pid_max: default: 32768 minimum: 301
> [    0.004043] Security Framework initialized
> [    0.004053] SELinux:  Initializing.
> [    0.004063] SELinux:  Starting in permissive mode
> [    0.005544] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.009804] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.011821] Mount-cache hash table entries: 256
> [    0.012083] Initializing cgroup subsys cpuacct
> [    0.012087] Initializing cgroup subsys memory
> [    0.012101] Initializing cgroup subsys devices
> [    0.012103] Initializing cgroup subsys freezer
> [    0.012104] Initializing cgroup subsys net_cls
> [    0.012106] Initializing cgroup subsys blkio
> [    0.012108] Initializing cgroup subsys perf_event
> [    0.012140] Disabled fast string operations
> [    0.012145] CPU: Physical Processor ID: 0
> [    0.012146] CPU: Processor Core ID: 0
> [    0.012148] mce: CPU supports 6 MCE banks
> [    0.012156] CPU0: Thermal monitoring enabled (TM2)
> [    0.012164] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
> Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
> tlb_flushall_shift: -1
> [    0.012226] Freeing SMP alternatives: 24k freed
> [    0.014051] ACPI: Core revision 20130117
> [    0.020620] ACPI: All ACPI Tables successfully acquired
> [    0.021011] ftrace: allocating 24409 entries in 96 pages
> [    0.027091] dmar: Host address width 36
> [    0.027093] dmar: DRHD base: 0x000000feb03000 flags: 0x0
> [    0.027099] dmar: IOMMU 0: reg_base_addr feb03000 ver 1:0 cap c9008020e30260 ecap 1000
> [    0.027100] dmar: DRHD base: 0x000000feb01000 flags: 0x0
> [    0.027105] dmar: IOMMU 1: reg_base_addr feb01000 ver 1:0 cap c0000020630260 ecap 1000
> [    0.027106] dmar: DRHD base: 0x000000feb00000 flags: 0x0
> [    0.027110] dmar: IOMMU 2: reg_base_addr feb00000 ver 1:0 cap c0000020630270 ecap 1000
> [    0.027112] dmar: DRHD base: 0x000000feb02000 flags: 0x1
> [    0.027116] dmar: IOMMU 3: reg_base_addr feb02000 ver 1:0 cap c9008020630260 ecap 1000
> [    0.027117] dmar: RMRR base: 0x000000fc226c00 end: 0x000000fc2273ff
> [    0.027119] dmar: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
> [    0.027631] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.037835] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz (fam: 06, model: 17, stepping: 0a)
> [    0.038000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
> [    0.038000] ... version:                2
> [    0.038000] ... bit width:              40
> [    0.038000] ... generic registers:      2
> [    0.038000] ... value mask:             000000ffffffffff
> [    0.038000] ... max period:             000000007fffffff
> [    0.038000] ... fixed-purpose events:   3
> [    0.038000] ... event mask:             0000000700000003
> [    0.005000] Disabled fast string operations
> [    0.038679] smpboot: Booting Node   0, Processors  #1
> [    0.050035] Brought up 2 CPUs
> [    0.050039] smpboot: Total of 2 processors activated (10107.78 BogoMIPS)
> [    0.050167] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.052046] devtmpfs: initialized
> [    0.052173] PM: Registering ACPI NVS region [mem 0xbd6c6000-0xbd6d0fff] (45056 bytes)
> [    0.052173] PM: Registering ACPI NVS region [mem 0xbd6d8000-0xbd6dbfff] (16384 bytes)
> [    0.052173] PM: Registering ACPI NVS region [mem 0xbd6df000-0xbd705fff] (159744 bytes)
> [    0.052173] PM: Registering ACPI NVS region [mem 0xbd90f000-0xbd99efff] (589824 bytes)
> [    0.052528] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    0.052528] RTC time: 13:44:06, date: 03/08/13
> [    0.052528] NET: Registered protocol family 16
> [    0.052557] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.052559] ACPI: bus type pci registered
> [    0.052612] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
> [    0.052615] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
> [    0.060706] PCI: Using configuration type 1 for base access
> [    0.062025] bio: create slab <bio-0> at 0
> [    0.062053] ACPI: Added _OSI(Module Device)
> [    0.062053] ACPI: Added _OSI(Processor Device)
> [    0.062053] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.062053] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.064005] ACPI: EC: EC description table is found, configuring boot EC
> [    0.068782] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.077314] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
> [    0.077689] ACPI: Dynamic OEM Table Load:
> [    0.077691] ACPI: SSDT           (null) 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
> [    0.077792] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
> [    0.078189] ACPI: Dynamic OEM Table Load:
> [    0.078191] ACPI: SSDT           (null) 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
> [    0.084182] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
> [    0.084570] ACPI: Dynamic OEM Table Load:
> [    0.084572] ACPI: SSDT           (null) 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
> [    0.087056] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
> [    0.087431] ACPI: Dynamic OEM Table Load:
> [    0.087432] ACPI: SSDT           (null) 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
> [    0.092089] ACPI: Interpreter enabled
> [    0.092093] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
> [    0.092099] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
> [    0.092104]  S3 S4 S5)
> [    0.092111] ACPI: Using IOAPIC for interrupt routing
> [    0.092132] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.099038] ACPI: Power Resource [PUBS] (on)
> [    0.103305] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 *6 7 9 10 11)
> [    0.103386] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.103465] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11)
> [    0.103544] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.103622] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11)
> [    0.103700] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10 11)
> [    0.103778] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.103856] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
> [    0.103903] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.104235] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
> [    0.104532] acpi PNP0A08:00: ACPI _OSC control (0x1d) granted
> [    0.104560] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
> [    0.104585] PCI host bridge to bus 0000:00
> [    0.104587] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.104589] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.104591] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.104593] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.104594] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
> [    0.104596] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> [    0.104598] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> [    0.104599] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
> [    0.104608] pci 0000:00:00.0: [8086:2a40] type 00 class 0x060000
> [    0.104627] DMAR: Forcing write-buffer flush capability
> [    0.104628] DMAR: Disabling IOMMU for graphics on this chipset
> [    0.104694] pci 0000:00:02.0: [8086:2a42] type 00 class 0x030000
> [    0.104706] pci 0000:00:02.0: reg 10: [mem 0xf4400000-0xf47fffff 64bit]
> [    0.104713] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
> [    0.104718] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
> [    0.104774] pci 0000:00:02.1: [8086:2a43] type 00 class 0x038000
> [    0.104784] pci 0000:00:02.1: reg 10: [mem 0xf4200000-0xf42fffff 64bit]
> [    0.104873] pci 0000:00:03.0: [8086:2a44] type 00 class 0x078000
> [    0.104888] pci 0000:00:03.0: reg 10: [mem 0xfc226800-0xfc22680f 64bit]
> [    0.104935] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
> [    0.105047] pci 0000:00:19.0: [8086:10f5] type 00 class 0x020000
> [    0.105071] pci 0000:00:19.0: reg 10: [mem 0xfc000000-0xfc01ffff]
> [    0.105081] pci 0000:00:19.0: reg 14: [mem 0xfc025000-0xfc025fff]
> [    0.105092] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
> [    0.105179] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> [    0.105206] pci 0000:00:19.0: System wakeup disabled by ACPI
> [    0.105244] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
> [    0.105298] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
> [    0.105389] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.105425] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
> [    0.105480] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
> [    0.105585] pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
> [    0.105640] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
> [    0.105729] pci 0000:00:1a.2: System wakeup disabled by ACPI
> [    0.105776] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
> [    0.105800] pci 0000:00:1a.7: reg 10: [mem 0xfc226c00-0xfc226fff]
> [    0.105907] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.105952] pci 0000:00:1a.7: System wakeup disabled by ACPI
> [    0.105993] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
> [    0.106016] pci 0000:00:1b.0: reg 10: [mem 0xfc020000-0xfc023fff 64bit]
> [    0.106111] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.106159] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.106195] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
> [    0.106295] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.106325] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.106363] pci 0000:00:1c.1: [8086:2942] type 01 class 0x060400
> [    0.106462] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.106493] pci 0000:00:1c.1: System wakeup disabled by ACPI
> [    0.106531] pci 0000:00:1c.4: [8086:2948] type 01 class 0x060400
> [    0.106630] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.106664] pci 0000:00:1c.4: System wakeup disabled by ACPI
> [    0.106705] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
> [    0.106760] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
> [    0.106844] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.106880] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
> [    0.106935] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
> [    0.107042] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
> [    0.107097] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
> [    0.107211] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
> [    0.107236] pci 0000:00:1d.7: reg 10: [mem 0xfc227000-0xfc2273ff]
> [    0.107343] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.107383] pci 0000:00:1d.7: System wakeup disabled by ACPI
> [    0.107420] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
> [    0.107510] pci 0000:00:1e.0: System wakeup disabled by ACPI
> [    0.107551] pci 0000:00:1f.0: [8086:2917] type 00 class 0x060100
> [    0.107737] pci 0000:00:1f.2: [8086:2929] type 00 class 0x010601
> [    0.107764] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
> [    0.107774] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
> [    0.107785] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
> [    0.107796] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
> [    0.107806] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
> [    0.107817] pci 0000:00:1f.2: reg 24: [mem 0xfc226000-0xfc2267ff]
> [    0.107884] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.107945] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
> [    0.107966] pci 0000:00:1f.3: reg 10: [mem 0xfc227400-0xfc2274ff 64bit]
> [    0.107994] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
> [    0.108135] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.108272] pci 0000:03:00.0: [8086:4237] type 00 class 0x028000
> [    0.108316] pci 0000:03:00.0: reg 10: [mem 0xf4300000-0xf4301fff 64bit]
> [    0.108517] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    0.110043] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.110051] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
> [    0.110126] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
> [    0.110131] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
> [    0.110135] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
> [    0.110142] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
> [    0.110196] pci 0000:15:00.0: [1180:0476] type 02 class 0x060700
> [    0.110218] pci 0000:15:00.0: proprietary Ricoh MMC controller disabled (via cardbus function)
> [    0.110220] pci 0000:15:00.0: MMC cards are now supported by standard SDHCI controller
> [    0.110234] pci 0000:15:00.0: reg 10: [mem 0xf4800000-0xf4800fff]
> [    0.110270] pci 0000:15:00.0: supports D1 D2
> [    0.110271] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.110321] pci 0000:15:00.2: [1180:0822] type 00 class 0x080500
> [    0.110342] pci 0000:15:00.2: reg 10: [mem 0xf4801000-0xf48010ff]
> [    0.110433] pci 0000:15:00.2: supports D1 D2
> [    0.110434] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.110483] pci 0000:15:00.4: [1180:0592] type 00 class 0x088000
> [    0.110503] pci 0000:15:00.4: reg 10: [mem 0xf4801800-0xf48018ff]
> [    0.110593] pci 0000:15:00.4: supports D1 D2
> [    0.110595] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.110644] pci 0000:15:00.5: [1180:0852] type 00 class 0x088000
> [    0.110664] pci 0000:15:00.5: reg 10: [mem 0xf4801c00-0xf4801cff]
> [    0.110757] pci 0000:15:00.5: supports D1 D2
> [    0.110758] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.110851] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
> [    0.110856] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
> [    0.110860] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
> [    0.110867] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
> [    0.110869] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> [    0.110871] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> [    0.110872] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    0.110874] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
> [    0.110876] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
> [    0.110877] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
> [    0.110879] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
> [    0.110928] pci_bus 0000:16: busn_res: can not insert [bus 16-ff] under [bus 15-18] (conflicts with (null) [bus 15-18])
> [    0.110933] pci_bus 0000:16: busn_res: [bus 16-ff] end is updated to 17
> [    0.112524] ACPI: Enabled 3 GPEs in block 00 to 3F
> [    0.112558] acpi root: \_SB_.PCI0 notify handler is installed
> [    0.112605] Found 1 acpi root devices
> [    0.115055] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
> [    0.116047] ACPI: ACPI Dock Station Driver: 3 docks/bays found
> [    0.116081] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.116081] vgaarb: loaded
> [    0.116081] vgaarb: bridge control possible 0000:00:02.0
> [    0.116084] SCSI subsystem initialized
> [    0.116086] ACPI: bus type scsi registered
> [    0.116093] libata version 3.00 loaded.
> [    0.116093] ACPI: bus type usb registered
> [    0.116093] usbcore: registered new interface driver usbfs
> [    0.116093] usbcore: registered new interface driver hub
> [    0.116093] usbcore: registered new device driver usb
> [    0.116093] PCI: Using ACPI for IRQ routing
> [    0.117821] PCI: pci_cache_line_size set to 64 bytes
> [    0.117900] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
> [    0.117902] e820: reserve RAM buffer [mem 0xbd4a1000-0xbfffffff]
> [    0.117904] e820: reserve RAM buffer [mem 0xbd5b7000-0xbfffffff]
> [    0.117906] e820: reserve RAM buffer [mem 0xbd6c6000-0xbfffffff]
> [    0.117908] e820: reserve RAM buffer [mem 0xbda00000-0xbfffffff]
> [    0.117993] NetLabel: Initializing
> [    0.117994] NetLabel:  domain hash size = 128
> [    0.117995] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.118010] NetLabel:  unlabeled traffic allowed by default
> [    0.118056] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> [    0.118061] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.118065] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
> [    0.120009] Switching to clocksource hpet
> [    0.126103] pnp: PnP ACPI init
> [    0.126116] ACPI: bus type pnp registered
> [    0.146386] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.146389] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
> [    0.146391] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
> [    0.146393] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
> [    0.146395] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
> [    0.146400] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
> [    0.146402] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
> [    0.146404] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
> [    0.146406] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
> [    0.146408] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
> [    0.146410] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
> [    0.146412] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
> [    0.146414] system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
> [    0.146418] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.166430] system 00:01: [io  0x1000-0x107f] has been reserved
> [    0.166432] system 00:01: [io  0x1180-0x11ff] has been reserved
> [    0.166435] system 00:01: [io  0x0800-0x080f] has been reserved
> [    0.166437] system 00:01: [io  0x15e0-0x15ef] has been reserved
> [    0.166439] system 00:01: [io  0x1600-0x167f] has been reserved
> [    0.166441] system 00:01: [io  0x1680-0x169f] has been reserved
> [    0.166443] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.166445] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.166447] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
> [    0.166449] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.166451] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.166453] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
> [    0.166455] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
> [    0.166458] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.166508] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.166516] pnp 00:03: [dma 4]
> [    0.166532] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.166556] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.166588] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.166616] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.166642] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.166671] pnp 00:08: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
> [    0.187030] pnp: PnP ACPI: found 9 devices
> [    0.187032] ACPI: ACPI bus type pnp unregistered
> [    0.193674] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
> [    0.193678] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
> [    0.193680] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
> [    0.193690] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
> [    0.193693] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
> [    0.193724] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
> [    0.193726] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
> [    0.193728] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
> [    0.193730] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    0.193731] pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    0.193736] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
> [    0.193739] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
> [    0.193742] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.193745] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
> [    0.193747] pci 0000:00:1c.1: BAR 13: assigned [io  0x8000-0x8fff]
> [    0.193750] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.193754] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
> [    0.193759] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
> [    0.193764] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
> [    0.193771] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.193774] pci 0000:00:1c.1:   bridge window [io  0x8000-0x8fff]
> [    0.193779] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
> [    0.193783] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.193790] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
> [    0.193793] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
> [    0.193799] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
> [    0.193803] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
> [    0.193811] pci 0000:15:00.0: res[15]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
> [    0.193813] pci 0000:15:00.0: res[16]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
> [    0.193815] pci 0000:15:00.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
> [    0.193817] pci 0000:15:00.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
> [    0.193819] pci 0000:15:00.0: BAR 15: assigned [mem 0xf0000000-0xf3ffffff pref]
> [    0.193823] pci 0000:15:00.0: BAR 16: assigned [mem 0xc4000000-0xc7ffffff]
> [    0.193824] pci 0000:15:00.0: BAR 13: assigned [io  0x4000-0x40ff]
> [    0.193826] pci 0000:15:00.0: BAR 14: assigned [io  0x4400-0x44ff]
> [    0.193829] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
> [    0.193830] pci 0000:15:00.0:   bridge window [io  0x4000-0x40ff]
> [    0.193835] pci 0000:15:00.0:   bridge window [io  0x4400-0x44ff]
> [    0.193839] pci 0000:15:00.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
> [    0.193843] pci 0000:15:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
> [    0.193848] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
> [    0.193851] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
> [    0.193856] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
> [    0.193860] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
> [    0.193975] pci 0000:00:1e.0: setting latency timer to 64
> [    0.194013] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.194015] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.194017] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.194019] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
> [    0.194020] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
> [    0.194022] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
> [    0.194024] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfebfffff]
> [    0.194026] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
> [    0.194027] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
> [    0.194029] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
> [    0.194031] pci_bus 0000:03: resource 0 [io  0x8000-0x8fff]
> [    0.194033] pci_bus 0000:03: resource 1 [mem 0xf4300000-0xf43fffff]
> [    0.194035] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.194036] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
> [    0.194038] pci_bus 0000:0d: resource 1 [mem 0xfa000000-0xfbffffff]
> [    0.194040] pci_bus 0000:0d: resource 2 [mem 0xf4100000-0xf41fffff 64bit pref]
> [    0.194042] pci_bus 0000:15: resource 0 [io  0x4000-0x7fff]
> [    0.194043] pci_bus 0000:15: resource 1 [mem 0xf4800000-0xf7ffffff]
> [    0.194045] pci_bus 0000:15: resource 2 [mem 0xf0000000-0xf3ffffff 64bit pref]
> [    0.194047] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
> [    0.194049] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
> [    0.194050] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.194052] pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff]
> [    0.194054] pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff]
> [    0.194055] pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff]
> [    0.194057] pci_bus 0000:15: resource 10 [mem 0xc0000000-0xfebfffff]
> [    0.194059] pci_bus 0000:16: resource 0 [io  0x4000-0x40ff]
> [    0.194061] pci_bus 0000:16: resource 1 [io  0x4400-0x44ff]
> [    0.194063] pci_bus 0000:16: resource 2 [mem 0xf0000000-0xf3ffffff pref]
> [    0.194064] pci_bus 0000:16: resource 3 [mem 0xc4000000-0xc7ffffff]
> [    0.194099] NET: Registered protocol family 2
> [    0.194327] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.194811] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.195230] TCP: Hash tables configured (established 65536 bind 65536)
> [    0.195288] TCP: reno registered
> [    0.195302] UDP hash table entries: 4096 (order: 5, 131072 bytes)
> [    0.195365] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
> [    0.195474] NET: Registered protocol family 1
> [    0.195485] pci 0000:00:02.0: Boot video device
> [    0.195498] pci 0000:00:1a.0: power state changed by ACPI to D0
> [    0.195641] pci 0000:00:1a.2: power state changed by ACPI to D0
> [    0.195799] pci 0000:00:1d.0: power state changed by ACPI to D0
> [    0.196113] PCI: CLS 64 bytes, default 64
> [    0.196152] Unpacking initramfs...
> [    0.744148] Freeing initrd memory: 30840k freed
> [    0.760504] dmar: Device scope device [0000:00:03.02] not found
> [    0.760508] dmar: Device scope device [0000:00:03.03] not found
> [    0.760515] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.760518] software IO TLB [mem 0xb94a1000-0xbd4a1000] (64MB) mapped at [ffff8800b94a1000-ffff8800bd4a0fff]
> [    0.760576] Simple Boot Flag at 0x35 set to 0x1
> [    0.761000] Initialise system trusted keyring
> [    0.761079] audit: initializing netlink socket (disabled)
> [    0.761094] type=2000 audit(1362750246.760:1): initialized
> [    0.783251] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.785106] VFS: Disk quotas dquot_6.5.2
> [    0.785147] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.785524] msgmni has been set to 15753
> [    0.785580] SELinux:  Registering netfilter hooks
> [    0.786083] alg: No test for stdrng (krng)
> [    0.786091] NET: Registered protocol family 38
> [    0.786094] Key type asymmetric registered
> [    0.786096] Asymmetric key parser 'x509' registered
> [    0.786097] Asymmetric key parser 'pefile' registered
> [    0.786130] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.786159] io scheduler noop registered
> [    0.786161] io scheduler deadline registered (default)
> [    0.786168] io scheduler cfq registered
> [    0.786326] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
> [    0.786467] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
> [    0.786613] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
> [    0.786729] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
> [    0.786735] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
> [    0.786753] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
> [    0.786755] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
> [    0.786760] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
> [    0.786781] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
> [    0.786785] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
> [    0.786798] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.786844] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 17aa ss_did 20f3
> [    0.786866] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
> [    0.786878] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 17aa ss_did 20f3
> [    0.786896] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
> [    0.786908] pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086 device_id 2948 ss_vid 17aa ss_did 20f3
> [    0.786925] pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
> [    0.786930] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.786931] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.787106] vesafb: mode is 1600x1200x32, linelength=6400, pages=0
> [    0.787107] vesafb: scrolling: redraw
> [    0.787109] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    0.788296] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90004f00000, using 7552k, total 7552k
> [    0.788375] Console: switching to colour frame buffer device 200x75
> [    0.846978] fb0: VESA VGA frame buffer device
> [    0.846987] intel_idle: does not run on family 6 model 23
> [    0.847285] ACPI: AC Adapter [AC] (on-line)
> [    0.847429] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
> [    0.847615] ACPI: Lid Switch [LID]
> [    0.847647] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
> [    0.847650] ACPI: Sleep Button [SLPB]
> [    0.847692] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    0.847694] ACPI: Power Button [PWRF]
> [    0.847757] ACPI: Requesting acpi_cpufreq
> [    0.848768] Monitor-Mwait will be used to enter C-1 state
> [    0.848774] Monitor-Mwait will be used to enter C-2 state
> [    0.848778] Monitor-Mwait will be used to enter C-3 state
> [    0.848781] tsc: Marking TSC unstable due to TSC halts in idle
> [    0.848790] ACPI: acpi_idle registered with cpuidle
> [    0.892209] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.892211] ACPI: Thermal Zone [THM0] (48 C)
> [    0.898875] thermal LNXTHERM:01: registered as thermal_zone1
> [    0.898878] ACPI: Thermal Zone [THM1] (48 C)
> [    0.898910] GHES: HEST is not enabled!
> [    0.899035] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.899627] Non-volatile memory driver v1.3
> [    0.899629] Linux agpgart interface v0.103
> [    0.899741] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
> [    0.899910] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
> [    0.901815] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
> [    0.902055] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> [    0.902888] loop: module loaded
> [    0.902990] ahci 0000:00:1f.2: version 3.0
> [    0.903146] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
> [    0.903183] ahci: SSS flag set, parallel bus scan disabled
> [    0.903208] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
> [    0.903211] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
> [    0.903216] ahci 0000:00:1f.2: setting latency timer to 64
> [    0.903714] scsi0 : ahci
> [    0.903790] scsi1 : ahci
> [    0.903846] scsi2 : ahci
> [    0.903904] scsi3 : ahci
> [    0.903975] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 43
> [    0.903978] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 43
> [    0.903979] ata3: DUMMY
> [    0.903980] ata4: DUMMY
> [    0.904114] libphy: Fixed MDIO Bus: probed
> [    0.904278] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.904280] ehci-pci: EHCI PCI platform driver
> [    0.904356] ehci-pci 0000:00:1a.7: setting latency timer to 64
> [    0.904360] ehci-pci 0000:00:1a.7: EHCI Host Controller
> [    0.904396] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
> [    0.904410] ehci-pci 0000:00:1a.7: debug port 1
> [    0.908337] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
> [    0.908355] ehci-pci 0000:00:1a.7: irq 23, io mem 0xfc226c00
> [    0.913647] ACPI: Battery Slot [BAT0] (battery present)
> [    0.914013] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    0.914048] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.914050] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.914052] usb usb1: Product: EHCI Host Controller
> [    0.914054] usb usb1: Manufacturer: Linux 3.9.0-0.rc1.git0.5.fc19.x86_64 ehci_hcd
> [    0.914055] usb usb1: SerialNumber: 0000:00:1a.7
> [    0.914154] hub 1-0:1.0: USB hub found
> [    0.914158] hub 1-0:1.0: 6 ports detected
> [    0.914393] ehci-pci 0000:00:1d.7: setting latency timer to 64
> [    0.914397] ehci-pci 0000:00:1d.7: EHCI Host Controller
> [    0.914436] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
> [    0.914450] ehci-pci 0000:00:1d.7: debug port 1
> [    0.918348] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
> [    0.918361] ehci-pci 0000:00:1d.7: irq 19, io mem 0xfc227000
> [    0.924016] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    0.924046] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.924048] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.924050] usb usb2: Product: EHCI Host Controller
> [    0.924051] usb usb2: Manufacturer: Linux 3.9.0-0.rc1.git0.5.fc19.x86_64 ehci_hcd
> [    0.924053] usb usb2: SerialNumber: 0000:00:1d.7
> [    0.928216] hub 2-0:1.0: USB hub found
> [    0.928220] hub 2-0:1.0: 6 ports detected
> [    0.928279] Monitor-Mwait will be used to enter C-3 state
> [    0.928575] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.928585] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.928664] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    0.928669] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    0.928713] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
> [    0.928748] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
> [    0.928781] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.928784] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.928785] usb usb3: Product: UHCI Host Controller
> [    0.928787] usb usb3: Manufacturer: Linux 3.9.0-0.rc1.git0.5.fc19.x86_64 uhci_hcd
> [    0.928789] usb usb3: SerialNumber: 0000:00:1a.0
> [    0.928876] hub 3-0:1.0: USB hub found
> [    0.928880] hub 3-0:1.0: 2 ports detected
> [    0.929009] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    0.929013] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    0.929053] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> [    0.929087] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
> [    0.929116] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.929118] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.929120] usb usb4: Product: UHCI Host Controller
> [    0.929121] usb usb4: Manufacturer: Linux 3.9.0-0.rc1.git0.5.fc19.x86_64 uhci_hcd
> [    0.929123] usb usb4: SerialNumber: 0000:00:1a.1
> [    0.929201] hub 4-0:1.0: USB hub found
> [    0.929204] hub 4-0:1.0: 2 ports detected
> [    0.929324] uhci_hcd 0000:00:1a.2: setting latency timer to 64
> [    0.929327] uhci_hcd 0000:00:1a.2: UHCI Host Controller
> [    0.929368] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
> [    0.929400] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
> [    0.929429] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.929431] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.929432] usb usb5: Product: UHCI Host Controller
> [    0.929434] usb usb5: Manufacturer: Linux 3.9.0-0.rc1.git0.5.fc19.x86_64 uhci_hcd
> [    0.929436] usb usb5: SerialNumber: 0000:00:1a.2
> [    0.929517] hub 5-0:1.0: USB hub found
> [    0.929520] hub 5-0:1.0: 2 ports detected
> [    0.929639] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    0.929642] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    0.929689] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
> [    0.929722] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
> [    0.929751] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.929753] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.929754] usb usb6: Product: UHCI Host Controller
> [    0.929756] usb usb6: Manufacturer: Linux 3.9.0-0.rc1.git0.5.fc19.x86_64 uhci_hcd
> [    0.929758] usb usb6: SerialNumber: 0000:00:1d.0
> [    0.929836] hub 6-0:1.0: USB hub found
> [    0.929842] hub 6-0:1.0: 2 ports detected
> [    0.929959] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    0.929962] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    0.930011] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
> [    0.930043] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
> [    0.930072] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.930074] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.930075] usb usb7: Product: UHCI Host Controller
> [    0.930077] usb usb7: Manufacturer: Linux 3.9.0-0.rc1.git0.5.fc19.x86_64 uhci_hcd
> [    0.930079] usb usb7: SerialNumber: 0000:00:1d.1
> [    0.930160] hub 7-0:1.0: USB hub found
> [    0.930164] hub 7-0:1.0: 2 ports detected
> [    0.930284] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    0.930287] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    0.930325] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
> [    0.930359] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
> [    0.930390] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.930392] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.930394] usb usb8: Product: UHCI Host Controller
> [    0.930395] usb usb8: Manufacturer: Linux 3.9.0-0.rc1.git0.5.fc19.x86_64 uhci_hcd
> [    0.930397] usb usb8: SerialNumber: 0000:00:1d.2
> [    0.930480] hub 8-0:1.0: USB hub found
> [    0.930484] hub 8-0:1.0: 2 ports detected
> [    0.930619] usbcore: registered new interface driver usbserial
> [    0.930626] usbcore: registered new interface driver usbserial_generic
> [    0.930631] usbserial: USB Serial support registered for generic
> [    0.930663] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    0.939032] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.939037] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.939115] mousedev: PS/2 mouse device common for all mice
> [    0.939286] rtc_cmos 00:06: RTC can wake from S4
> [    0.939431] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> [    0.939460] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    0.939518] device-mapper: uevent: version 1.0.3
> [    0.939580] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
> [    0.939642] cpuidle: using governor ladder
> [    0.939679] cpuidle: using governor menu
> [    0.939963] EFI Variables Facility v0.08 2004-May-17
> [    0.939978] hidraw: raw HID events driver (C) Jiri Kosina
> [    0.940065] usbcore: registered new interface driver usbhid
> [    0.940066] usbhid: USB HID core driver
> [    0.940085] drop_monitor: Initializing network drop monitor service
> [    0.940152] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    0.940182] TCP: cubic registered
> [    0.940184] Initializing XFRM netlink socket
> [    0.940287] NET: Registered protocol family 10
> [    0.940446] mip6: Mobile IPv6
> [    0.940448] NET: Registered protocol family 17
> [    0.940727] PM: Hibernation image not present or could not be loaded.
> [    0.940728] Loading compiled-in X.509 certificates
> [    0.941717] Loaded X.509 cert 'Fedora kernel signing key: 56b865f7669446a039dbd72b05436a8504be0543'
> [    0.941725] registered taskstats version 1
> [    0.942622]   Magic number: 5:643:735
> [    0.945393] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
> [    1.260841] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.266821] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    1.266830] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    1.266906] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
> [    1.266913] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [    1.311081] ata1.00: ATA-8: WDC WD1600BEVS-08VAT2, 14.01A14, max UDMA/133
> [    1.311089] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    1.312670] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    1.312678] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    1.312801] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 (SET FEATURES) succeeded
> [    1.312809] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [    1.314202] ata1.00: configured for UDMA/133
> [    1.314503] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVS-0 14.0 PQ: 0 ANSI: 5
> [    1.314834] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.314847] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
> [    1.315048] sd 0:0:0:0: [sda] Write Protect is off
> [    1.315056] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.315177] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.319292]  sda: sda1 sda2 sda3
> [    1.320272] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.567264] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    1.620087] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.623126] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
> [    1.623964] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
> [    1.625775] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AC, SB01, max UDMA/33
> [    1.629167] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
> [    1.629988] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
> [    1.631797] ata2.00: configured for UDMA/33
> [    1.634739] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AC  SB01 PQ: 0 ANSI: 5
> [    1.636956] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [    1.636963] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    1.637237] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    1.637485] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [    1.640943] Freeing unused kernel memory: 1356k freed
> [    1.641771] Write protecting the kernel read-only data: 12288k
> [    1.653434] Freeing unused kernel memory: 1708k freed
> [    1.661862] Freeing unused kernel memory: 1324k freed
> [    1.786089] RPC: Registered named UNIX socket transport module.
> [    1.786092] RPC: Registered udp transport module.
> [    1.786093] RPC: Registered tcp transport module.
> [    1.786094] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    1.795152] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04791/0xb00000/0x20000, board id: 71, fw id: 434116
> [    1.795158] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
> [    1.816537] usb 1-1: New USB device found, idVendor=046d, idProduct=0990
> [    1.816539] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=2
> [    1.816541] usb 1-1: SerialNumber: B4261720
> [    1.836908] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input4
> [    1.932341] wmi: Mapper loaded
> [    1.938671] [drm] Initialized drm 1.1.0 20060810
> [    1.938975] pps_core: LinuxPPS API ver. 1 registered
> [    1.938978] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    1.942334] PTP clock support registered
> [    1.953441] [drm] Memory usable by graphics device = 2048M
> [    1.953446] checking generic (d0000000 760000) vs hw (d0000000 10000000)
> [    1.953448] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
> [    1.953468] Console: switching to colour dummy device 80x25
> [    1.953574] i915 0000:00:02.0: setting latency timer to 64
> [    1.953666] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
> [    1.958987] sdhci: Secure Digital Host Controller Interface driver
> [    1.958989] sdhci: Copyright(c) Pierre Ossman
> [    1.961889] e1000e: Intel(R) PRO/1000 Network Driver - 2.2.14-k
> [    1.961891] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
> [    1.997815] i915 0000:00:02.0: irq 44 for MSI/MSI-X
> [    1.997824] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    1.997826] [drm] Driver supports precise vblank timestamp query.
> [    1.997877] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    2.078158] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
> [    2.078168] yenta_cardbus 0000:15:00.0: Socket status: 30000006
> [    2.078174] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x4000-0x7fff]
> [    2.078176] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf4800000-0xf7ffffff]
> [    2.078184] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf4800000-0xf7ffffff:
> [    2.078273]  excluding 0xf4800000-0xf4b7ffff
> [    2.078364] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xf0000000-0xf3ffffff 64bit pref]
> [    2.078366] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf0000000-0xf3ffffff:
> [    2.078948]  excluding 0xf0000000-0xf3ffffff
> [    2.079649] sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
> [    2.080778] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
> [    2.081803] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
> [    2.082461] fbcon: inteldrmfb (fb0) is primary device
> [    2.103060] mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
> [    2.140290] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
> [    2.175158] Console: switching to colour frame buffer device 240x75
> [    2.195689] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    2.195690] i915 0000:00:02.0: registered panic notifier
> [    2.201084] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
> [    2.205575] acpi device:01: registered as cooling_device2
> [    2.205646] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [    2.205823] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
> [    2.206585] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    2.206706] e1000e 0000:00:19.0: setting latency timer to 64
> [    2.206835] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [    2.206912] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
> [    2.249033] usb 6-1: new low-speed USB device number 2 using uhci_hcd
> [    2.271005] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
> [    2.346170] sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
> [    2.396934] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:22:68:0c:96:e3
> [    2.396946] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
> [    2.396991] e1000e 0000:00:19.0 eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
> [    2.421784] usb 6-1: New USB device found, idVendor=045e, idProduct=00cb
> [    2.421798] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.421800] usb 6-1: Product: Microsoft Basic Optical Mouse v2.0 
> [    2.421802] usb 6-1: Manufacturer: Microsoft 
> [    2.449350] input: Microsoft  Microsoft Basic Optical Mouse v2.0  as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input6
> [    2.449557] hid-generic 0003:045E:00CB.0001: input,hidraw0: USB HID v1.11 Mouse [Microsoft  Microsoft Basic Optical Mouse v2.0 ] on usb-0000:00:1d.0-1/input0
> [    2.505061] bio: create slab <bio-1> at 1
> [    2.655101] usb 6-2: new full-speed USB device number 3 using uhci_hcd
> [    2.901843] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
> [    2.947806] usb 6-2: New USB device found, idVendor=0557, idProduct=2004
> [    2.947825] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.947832] usb 6-2: Product: UC100KM V2.10
> [    2.947837] usb 6-2: Manufacturer: ATEN
> [    2.968796] input: ATEN UC100KM V2.10 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input7
> [    2.969451] hid-generic 0003:0557:2004.0002: input,hidraw1: USB HID v1.00 Keyboard [ATEN UC100KM V2.10] on usb-0000:00:1d.0-2/input0
> [    2.991716] input: ATEN UC100KM V2.10 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.1/input/input8
> [    2.992227] hid-generic 0003:0557:2004.0003: input,hidraw2: USB HID v1.00 Mouse [ATEN UC100KM V2.10] on usb-0000:00:1d.0-2/input1
> [    3.301886] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
> [    3.538457] irq 16: nobody cared (try booting with the "irqpoll" option)
> [    3.538463] Pid: 0, comm: swapper/1 Not tainted 3.9.0-0.rc1.git0.5.fc19.x86_64 #1
> [    3.538464] Call Trace:
> [    3.538466]  <IRQ>  [<ffffffff810ee1f2>] __report_bad_irq+0x32/0xd0
> [    3.538475]  [<ffffffff810ee608>] note_interrupt+0x138/0x1f0
> [    3.538479]  [<ffffffff814f0461>] ? cpuidle_wrap_enter+0x41/0x80
> [    3.538482]  [<ffffffff814efae0>] ? intel_pstate_timer_func+0x350/0x350
> [    3.538485]  [<ffffffff810ebfc1>] handle_irq_event_percpu+0xe1/0x1e0
> [    3.538488]  [<ffffffff814efae0>] ? intel_pstate_timer_func+0x350/0x350
> [    3.538490]  [<ffffffff810ec0f6>] handle_irq_event+0x36/0x60
> [    3.538493]  [<ffffffff810ef145>] handle_fasteoi_irq+0x55/0xf0
> [    3.538496]  [<ffffffff810151ef>] handle_irq+0xbf/0x150
> [    3.538500]  [<ffffffff81649e5a>] ? atomic_notifier_call_chain+0x1a/0x20
> [    3.538503]  [<ffffffff8164ff0d>] do_IRQ+0x4d/0xc0
> [    3.538505]  [<ffffffff816461ad>] common_interrupt+0x6d/0x6d
> [    3.538506]  <EOI>  [<ffffffff814f0461>] ? cpuidle_wrap_enter+0x41/0x80
> [    3.538511]  [<ffffffff814f04b0>] cpuidle_enter_tk+0x10/0x20
> [    3.538513]  [<ffffffff814f0212>] cpuidle_idle_call+0xb2/0x1e0
> [    3.538516]  [<ffffffff8101c025>] cpu_idle+0xe5/0x140
> [    3.538520]  [<ffffffff81634226>] start_secondary+0x249/0x24b
> [    3.538522] handlers:
> [    3.538525] [<ffffffff81458bf0>] usb_hcd_irq
> [    3.538530] [<ffffffffa0173a00>] yenta_interrupt [yenta_socket]
> [    3.538531] Disabling IRQ #16
> [    5.281769] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
> [    6.022427] SELinux:  Disabled at runtime.
> [    6.022494] SELinux:  Unregistering netfilter hooks
> [    6.260082] type=1404 audit(1362750252.259:2): selinux=0 auid=4294967295 ses=4294967295
> [    8.967056] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
> [    9.211142] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input9
> [   10.506770] EXT4-fs (dm-1): re-mounted. Opts: (null)
> [   11.387958] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [   12.027499] tun: Universal TUN/TAP device driver, 1.6
> [   12.027508] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [   13.385148] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa0c
> [   13.647354] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa0c
> [   13.647577] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [   15.191106] Adding 3948540k swap on /dev/mapper/fedora-swap.  Priority:-1 extents:1 across:3948540k 
> [   16.245335] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
> [   16.255823] ACPI Warning: 0x0000000000001028-0x000000000000102f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20130117/utaddress-251)
> [   16.255838] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   16.255847] ACPI Warning: 0x00000000000011b0-0x00000000000011bf SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20130117/utaddress-251)
> [   16.255856] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   16.255860] ACPI Warning: 0x0000000000001180-0x00000000000011af SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20130117/utaddress-251)
> [   16.255869] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   16.255873] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [   16.309505] thinkpad_acpi: ThinkPad ACPI Extras v0.24
> [   16.309507] thinkpad_acpi: http://ibm-acpi.sf.net/
> [   16.309509] thinkpad_acpi: ThinkPad BIOS 6FET93WW (3.23 ), EC 7VHT16WW-1.06
> [   16.309510] thinkpad_acpi: Lenovo ThinkPad W500, model 4058CTO
> [   16.330444] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
> [   16.330616] thinkpad_acpi: radio switch found; radios are disabled
> [   16.330633] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
> [   16.330635] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
> [   16.334361] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
> [   16.334421] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
> [   16.336087] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input10
> [   16.486199] r592: driver successfully loaded
> [   16.929605] iTCO_vendor_support: vendor-support=0
> [   17.051207] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
> [   17.051280] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
> [   17.051520] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [   17.466064] media: Linux media interface: v0.10
> [   17.523768] cfg80211: Calling CRDA to update world regulatory domain
> [   17.643441] Linux video capture interface: v2.00
> [   17.989437] cfg80211: World regulatory domain updated:
> [   17.989445] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   17.989451] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   17.989456] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   17.989461] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   17.989466] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   17.989470] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   18.047565] Intel(R) Wireless WiFi driver for Linux, in-tree:d
> [   18.047572] Copyright(c) 2003-2013 Intel Corporation
> [   18.047927] iwlwifi 0000:03:00.0: irq 46 for MSI/MSI-X
> [   18.066621] uvcvideo: Found UVC 1.00 device <unnamed> (046d:0990)
> [   18.083256] input: UVC Camera (046d:0990) as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/input/input11
> [   18.083439] usbcore: registered new interface driver uvcvideo
> [   18.083444] USB Video Class driver (1.1.1)
> [   18.108898] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692
> [   18.712924] ALSA sound/usb/mixer.c:930 5:2: cannot get min/max values for control 2 (id 5)
> [   18.713528] usbcore: registered new interface driver snd-usb-audio
> [   18.793339] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
> [   18.793348] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [   18.793354] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> [   18.793359] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
> [   18.793363] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
> [   18.793370] iwlwifi 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
> [   18.793410] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   18.793818] iwlwifi 0000:03:00.0: RF_KILL bit toggled to disable radio.
> [   18.824343] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
> [   18.857964] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> [   19.002676] hda_codec: CX20561 (Hermosa): BIOS auto-probing.
> [   19.002676] ALSA sound/pci/hda/hda_auto_parser.c:335 autoconfig: line_outs=1 (0x1a/0x0/0x0/0x0/0x0) type:speaker
> [   19.002676] ALSA sound/pci/hda/hda_auto_parser.c:339    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [   19.002676] ALSA sound/pci/hda/hda_auto_parser.c:343    hp_outs=2 (0x19/0x16/0x0/0x0/0x0)
> [   19.002676] ALSA sound/pci/hda/hda_auto_parser.c:344    mono: mono_out=0x0
> [   19.002676] ALSA sound/pci/hda/hda_auto_parser.c:347    dig-out=0x1c/0x0
> [   19.002676] ALSA sound/pci/hda/hda_auto_parser.c:348    inputs:
> [   19.002676] ALSA sound/pci/hda/hda_auto_parser.c:352      Mic=0x18
> [   19.002676] ALSA sound/pci/hda/hda_auto_parser.c:352      Internal Mic=0x1d
> [   19.002676] ALSA sound/pci/hda/hda_auto_parser.c:352      Dock Mic=0x17
> [   19.002676] ALSA sound/pci/hda/patch_conexant.c:3402 hda_codec: Enable sync_write for stable communication
> [   19.017975] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
> [   19.018092] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input13
> [   19.018152] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input14
> [   19.018207] input: HDA Intel Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input15
> [   23.156571] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
> [   24.218894] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
> [   30.143895] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
> [   30.244192] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
> [   30.244383] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   30.421616] Bridge firewalling registered
> [   32.718939] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
> [   32.719150] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   36.682554] NFSD: starting 90-second grace period (net ffffffff81cbb000)
> [   46.220573] Ebtables v2.0 registered
> [   46.417191] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   46.605109] cgroup: libvirtd (907) created nested cgroup for controller "memory" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
> [   46.605113] cgroup: "memory" requires setting use_hierarchy to 1 on the root.
> [   46.605167] cgroup: libvirtd (907) created nested cgroup for controller "devices" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
> [   46.605221] cgroup: libvirtd (907) created nested cgroup for controller "blkio" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


