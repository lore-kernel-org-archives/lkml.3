Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaESCsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 22:48:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:4432 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbaESCsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 22:48:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,864,1392192000"; 
   d="scan'208";a="513669905"
Message-ID: <53797084.20706@intel.com>
Date: Mon, 19 May 2014 10:46:28 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alan <alan@acox1-desk.ger.corp.intel.com>
CC: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Jet Chen <jet.chen@intel.com>
Subject: [goldfish] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080
 (goldfish_pdev_bus)
Content-Type: multipart/mixed;
 boundary="------------020608010801060400010501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020608010801060400010501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Alan,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git staging-next
commit 9b17aeec232a5f0a61ce3952c2e728a0eeddda8b
Author:     Alan <alan@acox1-desk.ger.corp.intel.com>
AuthorDate: Mon May 12 16:55:35 2014 +0100
Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitDate: Thu May 15 13:19:01 2014 -0700

     goldfish: Allow 64bit builds
         We can now enable the 64bit option for the Goldfish 64bit emulator.
         Signed-off-by: Alan Cox <alan@linux.intel.com>
     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

+----------------------------------------------------------+------------+------------+
|                                                          | b8658bc810 | 9b17aeec23 |
+----------------------------------------------------------+------------+------------+
| boot_successes                                           | 60         | 0          |
| boot_failures                                            | 0          | 20         |
| genirq:Flags_mismatch_irq.(serial)vs.(goldfish_pdev_bus) | 0          | 20         |
+----------------------------------------------------------+------------+------------+


[    8.668148] ALSA device list:
[    8.668419]   #0: Loopback 1
[    8.668677]   #1: MTPAV on parallel port at 0x378
[    8.669432] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
[    8.671901] Freeing unused kernel memory: 1196K (ffffffff82bf0000 - ffffffff82d1b000)
[    8.672607] Write protecting the kernel read-only data: 18432k
[    8.673681] Freeing unused kernel memory: 80K (ffff880001bec000 - ffff880001c00000)
[    8.677081] Freeing unused kernel memory: 1076K (ffff8800020f3000 - ffff880002200000)
[    8.678569] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
[    8.679593] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
[    8.680682] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
[    8.681640] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
[    8.682609] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
[    8.684017] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
[    8.685239] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
[    8.692514] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
[    8.693570] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
[    8.694499] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000080 (goldfish_pdev_bus)
[    8.765477] gfs2: path_lookup on rootfs returned error -2
[   60.373367] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0 [   69.215881] random: nonblocking pool is initialized

git bisect start 0856ad1ef175c45dc6a0bc629ca355fdfbb1001e v3.14 --
git bisect good 200bde278d78318cbd10cd865f94016924e76c56  # 16:16     20+      0  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 9ae8df66e6742271b49a1518c7bf0debdfc523cf  # 16:32     20+      0  Merge remote-tracking branch 'devicetree-current/devicetree/merge'
git bisect good 77645accb67841c8557483afe029ec80a240d636  # 16:39     20+      0  Merge remote-tracking branch 'drm/drm-next'
git bisect good 21dd17170d63646851debe993194e46811dbdb1b  # 16:47     20+      0  Merge remote-tracking branch 'ftrace/for-next'
git bisect good 2fa6c75b02c032252eaf3c0b8885ddb1b9ad4840  # 16:55     20+      0  Merge remote-tracking branch 'usb-gadget/next'
git bisect  bad 7dc48a5c223dddebc2bb263d6e77edb557c11f6f  # 17:00      0-      7  Merge remote-tracking branch 'dma-mapping/dma-mapping-next'
git bisect  bad a75b5bfa061c14e14261aed3771e2b174df72450  # 17:09      0-      8  Merge remote-tracking branch 'cgroup/for-next'
git bisect  bad 47bb948ff65de22da21d235cc768bba7802ad45f  # 17:15      0-     12  Merge remote-tracking branch 'staging/staging-next'
git bisect good d5cef008e95ffdaf457e38254e67d145a927df96  # 17:25     20+      0  Merge tag 'iio-for-3.16a' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next
git bisect good a1f3b3fdba2ab124c1e8c2b6aa17cfcf5c99d756  # 17:34     20+      0  staging: rtl8188eu: Remove 'u32 ref_cnt' from struct recv_buf
git bisect good be4c50604d22f0fd2c65853af18292f44d784b86  # 17:45     20+      0  staging: rtl8723au: Eliminate RTW_STATUS_CODE23a()
git bisect  bad 2b46be68a1b67f40df4f288b90e79181c387eda6  # 17:53      0-      8  staging: dgnc: cleanup dgnc_finalize_board_init()
git bisect good c7fff4e43ced0584bcbcef8a5f93bd9a813aac1b  # 18:01     20+      0  staging: rtl8723au: struct phy_info and struct odm_phy_info are identical
git bisect  bad f6279717bbb20bf90ec414af17d2a31d843f5eb5  # 18:12      0-     10  goldfish: clean up staging ifdefs
git bisect good 0cc6c3ab3cdbcf8a4a103d27599a6d0b44a6c315  # 18:18     20+      0  staging: rtl8723au: Remove unused pointer in rtw_wdev_free()
git bisect good f10d8434201859d5ad7f51032dcd2d0c09e85ee2  # 18:25     20+      0  goldfish: add support for 64bit to the virtual bus
git bisect good b8658bc81089d656fe54b12e21f0cae5116b6483  # 18:33     20+      0  goldfish: enable 64-bit tty driver
git bisect  bad 9b17aeec232a5f0a61ce3952c2e728a0eeddda8b  # 18:39      0-      9  goldfish: Allow 64bit builds
# first bad commit: [9b17aeec232a5f0a61ce3952c2e728a0eeddda8b] goldfish: Allow 64bit builds
git bisect good b8658bc81089d656fe54b12e21f0cae5116b6483  # 18:41     60+      0  goldfish: enable 64-bit tty driver
git bisect  bad 4151fa6adc65da14673ece623bbb2acc6936f8be  # 18:41      0-     13  Add linux-next specific files for 20140516
git bisect good 14186fea0cb06bc43181ce239efe0df6f1af260a  # 18:48     60+      0  Merge tag 'locks-v3.15-4' of git://git.samba.org/jlayton/linux
git bisect  bad 4151fa6adc65da14673ece623bbb2acc6936f8be  # 18:48      0-     13  Add linux-next specific files for 20140516


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm 	-kernel $kernel
	-initrd $initrd
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
-----------------------------------------------------------------------------

Thanks,
Jet


--------------020608010801060400010501
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-yocto-f4-32:20140518183828:x86_64-randconfig-wa1-05181543:3.15.0-rc3-00781-g9b17aee:1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="dmesg-yocto-f4-32:20140518183828:x86_64-randconfig-wa1-05181";
 filename*1="543:3.15.0-rc3-00781-g9b17aee:1"

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc3-00781-g9b17aee (kbuild@jaketown) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Sun May 18 18:37:53 CST 2014
[    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-wa1-05181543/next:master:9b17aeec232a5f0a61ce3952c2e728a0eeddda8b:bisect-linux6/.vmlinuz-9b17aeec232a5f0a61ce3952c2e728a0eeddda8b-20140518183813-12-f4 branch=next/master BOOT_IMAGE=/kernel/x86_64-randconfig-wa1-05181543/9b17aeec232a5f0a61ce3952c2e728a0eeddda8b/vmlinuz-3.15.0-rc3-00781-g9b17aee drbd.minor_count=8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x036a9000, 0x036a9fff] PGTABLE
[    0.000000] BRK [0x036aa000, 0x036aafff] PGTABLE
[    0.000000] BRK [0x036ab000, 0x036abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x036ac000, 0x036acfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff4fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13cc1000-0x13ce5fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13bc1001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012c00000-ffff8800131fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff4fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff4fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880013800000 s82304 r0 d24192 u1048576
[    0.000000] pcpu-alloc: s82304 r0 d24192 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380dec0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 80679
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-wa1-05181543/next:master:9b17aeec232a5f0a61ce3952c2e728a0eeddda8b:bisect-linux6/.vmlinuz-9b17aeec232a5f0a61ce3952c2e728a0eeddda8b-20140518183813-12-f4 branch=next/master BOOT_IMAGE=/kernel/x86_64-randconfig-wa1-05181543/9b17aeec232a5f0a61ce3952c2e728a0eeddda8b/vmlinuz-3.15.0-rc3-00781-g9b17aee drbd.minor_count=8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 276612K/327280K available (12200K kernel code, 10168K rwdata, 5068K rodata, 1196K init, 9748K bss, 50668K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc3-00781-g9b17aee (kbuild@jaketown) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Sun May 18 18:37:53 CST 2014
[    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-wa1-05181543/next:master:9b17aeec232a5f0a61ce3952c2e728a0eeddda8b:bisect-linux6/.vmlinuz-9b17aeec232a5f0a61ce3952c2e728a0eeddda8b-20140518183813-12-f4 branch=next/master BOOT_IMAGE=/kernel/x86_64-randconfig-wa1-05181543/9b17aeec232a5f0a61ce3952c2e728a0eeddda8b/vmlinuz-3.15.0-rc3-00781-g9b17aee drbd.minor_count=8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x036a9000, 0x036a9fff] PGTABLE
[    0.000000] BRK [0x036aa000, 0x036aafff] PGTABLE
[    0.000000] BRK [0x036ab000, 0x036abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x036ac000, 0x036acfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff4fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13cc1000-0x13ce5fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13bc1001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012c00000-ffff8800131fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff4fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff4fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880013800000 s82304 r0 d24192 u1048576
[    0.000000] pcpu-alloc: s82304 r0 d24192 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380dec0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 80679
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-wa1-05181543/next:master:9b17aeec232a5f0a61ce3952c2e728a0eeddda8b:bisect-linux6/.vmlinuz-9b17aeec232a5f0a61ce3952c2e728a0eeddda8b-20140518183813-12-f4 branch=next/master BOOT_IMAGE=/kernel/x86_64-randconfig-wa1-05181543/9b17aeec232a5f0a61ce3952c2e728a0eeddda8b/vmlinuz-3.15.0-rc3-00781-g9b17aee drbd.minor_count=8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 276612K/327280K available (12200K kernel code, 10168K rwdata, 5068K rodata, 1196K init, 9748K bss, 50668K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  memory used by lock dependency info: 5823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 13 of 13 active objects replaced
[    0.000000] ODEBUG: 13 of 13 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.610 MHz processor
[    0.000000] tsc: Detected 2693.610 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.68 BogoMIPS (lpj=8978700)
5389.68 BogoMIPS (lpj=8978700)
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006677] ACPI: Core revision 20140214
[    0.006677] ACPI: Core revision 20140214
[    0.009242] ACPI: 
[    0.009242] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables successfully acquired

[    0.010689] Security Framework initialized
[    0.010689] Security Framework initialized
[    0.011449] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.011449] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.012765] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.012765] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.013405] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.013405] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.014642] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.014642] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.016930] Initializing cgroup subsys net_cls
[    0.016930] Initializing cgroup subsys net_cls
[    0.017715] Initializing cgroup subsys blkio
[    0.017715] Initializing cgroup subsys blkio
[    0.018492] Initializing cgroup subsys net_prio
[    0.018492] Initializing cgroup subsys net_prio
[    0.019364] mce: CPU supports 10 MCE banks
[    0.019364] mce: CPU supports 10 MCE banks
[    0.020053] numa_add_cpu cpu 0 node 0: mask now 0
[    0.020053] numa_add_cpu cpu 0 node 0: mask now 0
[    0.020868] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020868] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.020868] tlb_flushall_shift: 6
[    0.020868] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020868] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.020868] tlb_flushall_shift: 6
[    0.023463] Freeing SMP alternatives memory: 32K (ffffffff82d1b000 - ffffffff82d23000)
[    0.023463] Freeing SMP alternatives memory: 32K (ffffffff82d1b000 - ffffffff82d23000)
[    0.027967] Getting VERSION: 50014
[    0.027967] Getting VERSION: 50014
[    0.028598] Getting VERSION: 50014
[    0.028598] Getting VERSION: 50014
[    0.029222] Getting ID: 0
[    0.029222] Getting ID: 0
[    0.029680] Getting ID: ff000000
[    0.029680] Getting ID: ff000000
[    0.030008] Getting LVT0: 8700
[    0.030008] Getting LVT0: 8700
[    0.030569] Getting LVT1: 8400
[    0.030569] Getting LVT1: 8400
[    0.031131] enabled ExtINT on CPU#0
[    0.031131] enabled ExtINT on CPU#0
[    0.032331] ENABLING IO-APIC IRQs
[    0.032331] ENABLING IO-APIC IRQs
[    0.032923] init IO_APIC IRQs
[    0.032923] init IO_APIC IRQs
[    0.033337]  apic 0 pin 0 not connected
[    0.033337]  apic 0 pin 0 not connected
[    0.034073] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.034073] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.035532] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.035532] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.036682] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.036682] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.038117] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.038117] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.040034] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.040034] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.041384] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.041384] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.042791] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.042791] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.043362] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.043362] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.044730] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.044730] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.046682] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.046682] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.048067] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.048067] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.050016] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.050016] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.051465] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.051465] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.052872] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.052872] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.053349] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.053349] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.054788]  apic 0 pin 16 not connected
[    0.054788]  apic 0 pin 16 not connected
[    0.056669]  apic 0 pin 17 not connected
[    0.056669]  apic 0 pin 17 not connected
[    0.057378]  apic 0 pin 18 not connected
[    0.057378]  apic 0 pin 18 not connected
[    0.058050]  apic 0 pin 19 not connected
[    0.058050]  apic 0 pin 19 not connected
[    0.058750]  apic 0 pin 20 not connected
[    0.058750]  apic 0 pin 20 not connected
[    0.059439]  apic 0 pin 21 not connected
[    0.059439]  apic 0 pin 21 not connected
[    0.060002]  apic 0 pin 22 not connected
[    0.060002]  apic 0 pin 22 not connected
[    0.060677]  apic 0 pin 23 not connected
[    0.060677]  apic 0 pin 23 not connected
[    0.061495] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.061495] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.062712] smpboot: CPU0: 
[    0.062712] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.064527] Using local APIC timer interrupts.
[    0.064527] calibrating APIC timer ...
[    0.064527] Using local APIC timer interrupts.
[    0.064527] calibrating APIC timer ...
[    0.066666] ... lapic delta = 6250753
[    0.066666] ... lapic delta = 6250753
[    0.066666] ... PM-Timer delta = 357959
[    0.066666] ... PM-Timer delta = 357959
[    0.066666] ... PM-Timer result ok
[    0.066666] ... PM-Timer result ok
[    0.066666] ..... delta 6250753
[    0.066666] ..... delta 6250753
[    0.066666] ..... mult: 268467823
[    0.066666] ..... mult: 268467823
[    0.066666] ..... calibration result: 3333734
[    0.066666] ..... calibration result: 3333734
[    0.066666] ..... CPU clock speed is 2693.2631 MHz.
[    0.066666] ..... CPU clock speed is 2693.2631 MHz.
[    0.066666] ..... host bus clock speed is 1000.0734 MHz.
[    0.066666] ..... host bus clock speed is 1000.0734 MHz.
[    0.066704] Performance Events: 
[    0.066704] Performance Events: unsupported Netburst CPU model 6 unsupported Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.069065] x86: Booting SMP configuration:
[    0.069065] x86: Booting SMP configuration:
[    0.069901] .... node  #0, CPUs:  
[    0.069901] .... node  #0, CPUs:         #1 #1
[    0.006666] kvm-clock: cpu 1, msr 0:13bc1081, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.006666] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.083367] x86: Booted up 1 node, 2 CPUs
[    0.083367] x86: Booted up 1 node, 2 CPUs
[    0.083359] KVM setup async PF for cpu 1
[    0.083359] KVM setup async PF for cpu 1
[    0.083359] kvm-stealtime: cpu 1, msr 1390dec0
[    0.083359] kvm-stealtime: cpu 1, msr 1390dec0
[    0.086672] ----------------
[    0.086672] ----------------
[    0.087213] | NMI testsuite:
[    0.087213] | NMI testsuite:
[    0.087697] --------------------
[    0.087697] --------------------
[    0.088259]   remote IPI:
[    0.088259]   remote IPI:  ok  |  ok  |

[    0.096195]    local IPI:
[    0.096195]    local IPI:  ok  |  ok  |

[    0.106683] --------------------
[    0.106683] --------------------
[    0.107260] Good, all   2 testcases passed! |
[    0.107260] Good, all   2 testcases passed! |
[    0.108044] ---------------------------------
[    0.108044] ---------------------------------
[    0.108835] smpboot: Total of 2 processors activated (10778.37 BogoMIPS)
[    0.108835] smpboot: Total of 2 processors activated (10778.37 BogoMIPS)
[    0.113913] prandom: seed boundary self test passed
[    0.113913] prandom: seed boundary self test passed
[    0.115247] prandom: 100 self tests passed
[    0.115247] prandom: 100 self tests passed
[    0.116126] regulator-dummy: no parameters
[    0.116126] regulator-dummy: no parameters
[    0.116765] RTC time: 18:37:07, date: 05/18/14
[    0.116765] RTC time: 18:37:07, date: 05/18/14
[    0.117635] NET: Registered protocol family 16
[    0.117635] NET: Registered protocol family 16
[    0.119186] cpuidle: using governor ladder
[    0.119186] cpuidle: using governor ladder
[    0.120003] cpuidle: using governor menu
[    0.120003] cpuidle: using governor menu
[    0.121211] ACPI: bus type PCI registered
[    0.121211] ACPI: bus type PCI registered
[    0.121978] dca service started, version 1.12.1
[    0.121978] dca service started, version 1.12.1
[    0.122839] PCI: Using configuration type 1 for base access
[    0.122839] PCI: Using configuration type 1 for base access
[    0.136936] ACPI: Added _OSI(Module Device)
[    0.136936] ACPI: Added _OSI(Module Device)
[    0.137677] ACPI: Added _OSI(Processor Device)
[    0.137677] ACPI: Added _OSI(Processor Device)
[    0.138438] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.138438] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.139254] ACPI: Added _OSI(Processor Aggregator Device)
[    0.139254] ACPI: Added _OSI(Processor Aggregator Device)
[    0.144083] ACPI: Interpreter enabled
[    0.144083] ACPI: Interpreter enabled
[    0.144766] ACPI Exception: AE_NOT_FOUND, 
[    0.144766] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_]While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
 (20140214/hwxface-580)
[    0.146428] ACPI Exception: AE_NOT_FOUND, 
[    0.146428] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_]While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
 (20140214/hwxface-580)
[    0.147648] ACPI: (supports S0 S3 S4 S5)
[    0.147648] ACPI: (supports S0 S3 S4 S5)
[    0.148379] ACPI: Using IOAPIC for interrupt routing
[    0.148379] ACPI: Using IOAPIC for interrupt routing
[    0.149274] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.149274] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.156398] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.156398] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.156679] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.156679] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.157833] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.157833] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.160213] PCI host bridge to bus 0000:00
[    0.160213] PCI host bridge to bus 0000:00
[    0.160962] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.160962] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.161885] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.161885] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.162910] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.162910] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.163337] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.163337] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.164515] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.164515] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.165739] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.165739] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.167103] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.167103] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.168604] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.168604] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.172208] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.172208] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.174172] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.174172] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.175390] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.175390] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.176670] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.176670] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.177930] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.177930] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.179176] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.179176] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.180307] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.180307] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.181467] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.181467] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.182860] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.182860] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.187168] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.187168] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.189438] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.189438] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.195368] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.195368] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.197142] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.197142] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.199012] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.199012] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.200781] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.200781] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.205693] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.205693] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.206866] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.206866] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.208436] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.208436] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.213378] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.213378] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.214569] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.214569] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.215694] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.215694] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.216909] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.216909] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.218038] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.218038] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.219632] ACPI: 
[    0.219632] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in block 00 to 0F

[    0.220523] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.220523] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.222019] vgaarb: loaded
[    0.222019] vgaarb: loaded
[    0.222522] vgaarb: bridge control possible 0000:00:02.0
[    0.222522] vgaarb: bridge control possible 0000:00:02.0
[    0.224313] SCSI subsystem initialized
[    0.224313] SCSI subsystem initialized
[    0.225182] Linux video capture interface: v2.00
[    0.225182] Linux video capture interface: v2.00
[    0.226725] pps_core: LinuxPPS API ver. 1 registered
[    0.226725] pps_core: LinuxPPS API ver. 1 registered
[    0.227567] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.227567] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.229233] PTP clock support registered
[    0.229233] PTP clock support registered
[    0.230388] wmi: Mapper loaded
[    0.230388] wmi: Mapper loaded
[    0.231050] Advanced Linux Sound Architecture Driver Initialized.
[    0.231050] Advanced Linux Sound Architecture Driver Initialized.
[    0.232158] PCI: Using ACPI for IRQ routing
[    0.232158] PCI: Using ACPI for IRQ routing
[    0.232941] PCI: pci_cache_line_size set to 64 bytes
[    0.232941] PCI: pci_cache_line_size set to 64 bytes
[    0.233449] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.233449] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.234544] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.234544] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.236047] Bluetooth: Core ver 2.19
[    0.236047] Bluetooth: Core ver 2.19
[    0.236693] NET: Registered protocol family 31
[    0.236693] NET: Registered protocol family 31
[    0.237522] Bluetooth: HCI device and connection manager initialized
[    0.237522] Bluetooth: HCI device and connection manager initialized
[    0.238636] Bluetooth: HCI socket layer initialized
[    0.238636] Bluetooth: HCI socket layer initialized
[    0.240012] Bluetooth: L2CAP socket layer initialized
[    0.240012] Bluetooth: L2CAP socket layer initialized
[    0.240928] Bluetooth: SCO socket layer initialized
[    0.240928] Bluetooth: SCO socket layer initialized
[    0.241836] nfc: nfc_init: NFC Core ver 0.1
[    0.241836] nfc: nfc_init: NFC Core ver 0.1
[    0.242575] NET: Registered protocol family 39
[    0.242575] NET: Registered protocol family 39
[    0.244002] Switched to clocksource kvm-clock
[    0.244002] Switched to clocksource kvm-clock
[    0.244002] FS-Cache: Loaded
[    0.244002] FS-Cache: Loaded
[    0.244002] pnp: PnP ACPI init
[    0.244002] pnp: PnP ACPI init
[    0.245427] ACPI: bus type PNP registered
[    0.245427] ACPI: bus type PNP registered
[    0.246190] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.246190] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.247687] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.247687] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.248825] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.248825] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.250259] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.250259] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.251442] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.251442] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.252877] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.252877] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.254075] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.254075] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.255454] pnp 00:03: [dma 2]
[    0.255454] pnp 00:03: [dma 2]
[    0.256094] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.256094] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.257270] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.257270] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.258634] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.258634] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.259828] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.259828] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.261236] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.261236] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.262343] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:3)
[    0.262343] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:3)
[    0.263779] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.263779] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.265091] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.265091] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.266291] pnp: PnP ACPI: found 8 devices
[    0.266291] pnp: PnP ACPI: found 8 devices
[    0.267025] ACPI: bus type PNP unregistered
[    0.267025] ACPI: bus type PNP unregistered
[    0.272894] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.272894] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.273857] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.273857] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.274763] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.274763] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.275808] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.275808] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.276882] NET: Registered protocol family 1
[    0.276882] NET: Registered protocol family 1
[    0.277689] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.277689] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.278660] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.278660] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.279643] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.279643] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.280706] pci 0000:00:02.0: Boot video device
[    0.280706] pci 0000:00:02.0: Boot video device
[    0.281448] PCI: CLS 0 bytes, default 64
[    0.281448] PCI: CLS 0 bytes, default 64
[    0.282289] Unpacking initramfs...
[    0.282289] Unpacking initramfs...
[    0.339294] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013ff0000)
[    0.339294] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013ff0000)
[    0.341097] kvm: no hardware support
[    0.341097] kvm: no hardware support
[    0.341991] Machine check injector initialized
[    0.341991] Machine check injector initialized
[    0.343166] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    0.343166] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    0.343210] cryptomgr_test (29) used greatest stack depth: 6648 bytes left
[    0.343210] cryptomgr_test (29) used greatest stack depth: 6648 bytes left
[    0.346170] cryptomgr_test (30) used greatest stack depth: 6632 bytes left
[    0.346170] cryptomgr_test (30) used greatest stack depth: 6632 bytes left
[    0.347461] cryptomgr_probe (38) used greatest stack depth: 6136 bytes left
[    0.347461] cryptomgr_probe (38) used greatest stack depth: 6136 bytes left
[    0.348956] cryptomgr_test (37) used greatest stack depth: 5592 bytes left
[    0.348956] cryptomgr_test (37) used greatest stack depth: 5592 bytes left
[    0.350573] PCLMULQDQ-NI instructions are not detected.
[    0.350573] PCLMULQDQ-NI instructions are not detected.
[    0.351518] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.351518] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.352629] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.352629] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.353733] AVX or AES-NI instructions are not detected.
[    0.353733] AVX or AES-NI instructions are not detected.
[    0.354629] AVX instructions are not detected.
[    0.354629] AVX instructions are not detected.
[    0.355392] AVX instructions are not detected.
[    0.355392] AVX instructions are not detected.
[    0.356172] AVX instructions are not detected.
[    0.356172] AVX instructions are not detected.
[    0.356925] AVX2 or AES-NI instructions are not detected.
[    0.356925] AVX2 or AES-NI instructions are not detected.
[    0.357999] spin_lock-torture:--- Start of test: nwriters_stress=4 stat_interval=60 verbose=1 shuffle_interval=3 stutter=5 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    0.357999] spin_lock-torture:--- Start of test: nwriters_stress=4 stat_interval=60 verbose=1 shuffle_interval=3 stutter=5 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    0.360654] spin_lock-torture: Creating torture_shuffle task
[    0.360654] spin_lock-torture: Creating torture_shuffle task
[    0.361707] spin_lock-torture: Creating torture_stutter task
[    0.361707] spin_lock-torture: Creating torture_stutter task
[    0.362732] spin_lock-torture: torture_shuffle task started
[    0.362732] spin_lock-torture: torture_shuffle task started
[    0.363759] spin_lock-torture: Creating lock_torture_writer task
[    0.363759] spin_lock-torture: Creating lock_torture_writer task
[    0.363768] spin_lock-torture: torture_stutter task started
[    0.363768] spin_lock-torture: torture_stutter task started
[    0.366066] spin_lock-torture: Creating lock_torture_writer task
[    0.366066] spin_lock-torture: Creating lock_torture_writer task
[    0.367218] spin_lock-torture: lock_torture_writer task started
[    0.367218] spin_lock-torture: lock_torture_writer task started
[    0.368316] spin_lock-torture: Creating lock_torture_writer task
[    0.368316] spin_lock-torture: Creating lock_torture_writer task
[    0.368363] spin_lock-torture: lock_torture_writer task started
[    0.368363] spin_lock-torture: lock_torture_writer task started
[    0.370585] spin_lock-torture: Creating lock_torture_writer task
[    0.370585] spin_lock-torture: Creating lock_torture_writer task
[    0.371667] spin_lock-torture: lock_torture_writer task started
[    0.371667] spin_lock-torture: lock_torture_writer task started
[    0.372694] spin_lock-torture: Creating lock_torture_stats task
[    0.372694] spin_lock-torture: Creating lock_torture_stats task
[    0.372708] spin_lock-torture: lock_torture_writer task started
[    0.372708] spin_lock-torture: lock_torture_writer task started
[    0.374807] spin_lock-torture: lock_torture_stats task started
[    0.374807] spin_lock-torture: lock_torture_stats task started
[    0.376351] futex hash table entries: 16 (order: -1, 2048 bytes)
[    0.376351] futex hash table entries: 16 (order: -1, 2048 bytes)
[    0.378092] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    0.378092] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    0.379018] fuse init (API version 7.23)
[    0.379018] fuse init (API version 7.23)
[    0.379866] JFS: nTxBlock = 2185, nTxLock = 17484
[    0.379866] JFS: nTxBlock = 2185, nTxLock = 17484
[    0.382312] SGI XFS with security attributes, realtime, large block/inode numbers, debug enabled
[    0.382312] SGI XFS with security attributes, realtime, large block/inode numbers, debug enabled
[    0.384306] NILFS version 2 loaded
[    0.384306] NILFS version 2 loaded
[    0.385378] gfs2: GFS2 installed
[    0.385378] gfs2: GFS2 installed
[    0.391285] alg: No test for stdrng (krng)
[    0.391285] alg: No test for stdrng (krng)
[    0.395482] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    0.395482] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    0.396652] NET: Registered protocol family 38
[    0.396652] NET: Registered protocol family 38
[    0.397494] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    0.397494] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    0.398744] io scheduler noop registered (default)
[    0.398744] io scheduler noop registered (default)
[    0.399555] io scheduler deadline registered
[    0.399555] io scheduler deadline registered
[    0.401118] list_sort_test: start testing list_sort()
[    0.401118] list_sort_test: start testing list_sort()
[    0.402386] test_string_helpers: Running tests...
[    0.402386] test_string_helpers: Running tests...
[    0.404424] crc32: CRC_LE_BITS = 8, CRC_BE BITS = 8
[    0.404424] crc32: CRC_LE_BITS = 8, CRC_BE BITS = 8
[    0.405194] crc32: self tests passed, processed 225944 bytes in 563792 nsec
[    0.405194] crc32: self tests passed, processed 225944 bytes in 563792 nsec
[    0.406923] crc32c: CRC_LE_BITS = 8
[    0.406923] crc32c: CRC_LE_BITS = 8
[    0.407587] crc32c: self tests passed, processed 225944 bytes in 305116 nsec
[    0.407587] crc32c: self tests passed, processed 225944 bytes in 305116 nsec
[    0.596485] crc32_combine: 8373 self tests passed
[    0.596485] crc32_combine: 8373 self tests passed
[    0.778521] crc32c_combine: 8373 self tests passed
[    0.778521] crc32c_combine: 8373 self tests passed
[    0.779394] xz_dec_test: module loaded
[    0.779394] xz_dec_test: module loaded
[    0.780073] xz_dec_test: Create a device node with 'mknod xz_dec_test c 250 0' and write .xz files to it.
[    0.780073] xz_dec_test: Create a device node with 'mknod xz_dec_test c 250 0' and write .xz files to it.
[    0.781692] rbtree testing
[    0.781692] rbtree testing -> 8500 cycles
 -> 8500 cycles
[    1.123914] augmented rbtree testing
[    1.123914] augmented rbtree testing

[    1.343404] tsc: Refined TSC clocksource calibration: 2693.512 MHz
[    1.343404] tsc: Refined TSC clocksource calibration: 2693.512 MHz
[    1.549950]  -> 11461 cycles
[    1.549950]  -> 11461 cycles
[    1.586876] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.586876] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.587911] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.587911] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.589568] rivafb_setup START
[    1.589568] rivafb_setup START
[    1.590158] nvidiafb_setup START
[    1.590158] nvidiafb_setup START
[    1.590895] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.590895] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.592369] no IO addresses supplied
[    1.592369] no IO addresses supplied
[    1.593124] hgafb: HGA card not detected.
[    1.593124] hgafb: HGA card not detected.
[    1.593860] hgafb: probe of hgafb.0 failed with error -22
[    1.593860] hgafb: probe of hgafb.0 failed with error -22
[    1.595228] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.595228] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.596532] ACPI: Power Button [PWRF]
[    1.596532] ACPI: Power Button [PWRF]
[    1.597693] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.597693] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.616002] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.616002] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.642392] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.642392] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.644416] lp: driver loaded but no devices found
[    1.644416] lp: driver loaded but no devices found
[    1.645270] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    1.645270] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    1.646487] ac.o: No PCI boards found.
[    1.646487] ac.o: No PCI boards found.
[    1.647195] ac.o: For an ISA board you must supply memory and irq parameters.
[    1.647195] ac.o: For an ISA board you must supply memory and irq parameters.
[    1.648474] Non-volatile memory driver v1.3
[    1.648474] Non-volatile memory driver v1.3
[    1.649335] ppdev: user-space parallel port driver
[    1.649335] ppdev: user-space parallel port driver
[    1.650242] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    1.650242] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    1.651164] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.651164] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.652732] Hangcheck: Using getrawmonotonic().
[    1.652732] Hangcheck: Using getrawmonotonic().
[    1.653746] [drm] Initialized drm 1.1.0 20060810
[    1.653746] [drm] Initialized drm 1.1.0 20060810
[    1.654628] [drm] radeon kernel modesetting enabled.
[    1.654628] [drm] radeon kernel modesetting enabled.
[    1.656262] [TTM] Zone  kernel: Available graphics memory: 139878 kiB
[    1.656262] [TTM] Zone  kernel: Available graphics memory: 139878 kiB
[    1.657427] [TTM] Initializing pool allocator
[    1.657427] [TTM] Initializing pool allocator
[    1.658245] [TTM] Initializing DMA pool allocator
[    1.658245] [TTM] Initializing DMA pool allocator
[    1.659542] [drm] fb mappable at 0xFC000000
[    1.659542] [drm] fb mappable at 0xFC000000
[    1.660352] [drm] vram aper at 0xFC000000
[    1.660352] [drm] vram aper at 0xFC000000
[    1.661066] [drm] size 4194304
[    1.661066] [drm] size 4194304
[    1.661600] [drm] fb depth is 24
[    1.661600] [drm] fb depth is 24
[    1.662162] [drm]    pitch is 3072
[    1.662162] [drm]    pitch is 3072
[    1.662953] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    1.662953] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    1.664103] cirrus 0000:00:02.0: registered panic notifier
[    1.664103] cirrus 0000:00:02.0: registered panic notifier
[    1.665069] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
[    1.665069] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on minor 0
[    1.666606] HP CISS Driver (v 3.6.26)
[    1.666606] HP CISS Driver (v 3.6.26)
[    1.667811] MM: desc_per_page = 128
[    1.667811] MM: desc_per_page = 128
[    1.669172] nbd: registered device at major 43
[    1.669172] nbd: registered device at major 43
[    1.675107] mtip32xx Version 1.3.1
[    1.675107] mtip32xx Version 1.3.1
[    1.675917] dummy-irq: no IRQ given.  Use irq=N
[    1.675917] dummy-irq: no IRQ given.  Use irq=N
[    1.676768] lkdtm: No crash points registered, enable through debugfs
[    1.676768] lkdtm: No crash points registered, enable through debugfs
[    1.678081] Phantom Linux Driver, version n0.9.8, init OK
[    1.678081] Phantom Linux Driver, version n0.9.8, init OK
[    1.679264] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    1.679264] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    1.680774] c2port c2port0: C2 port uc added
[    1.680774] c2port c2port0: C2 port uc added
[    1.681511] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    1.681511] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    1.683041] Guest personality initialized and is inactive
[    1.683041] Guest personality initialized and is inactive
[    1.684090] VMCI host device registered (name=vmci, major=10, minor=59)
[    1.684090] VMCI host device registered (name=vmci, major=10, minor=59)
[    1.685245] Initialized host personality
[    1.685245] Initialized host personality
[    1.685969] mic_init not running on X100 ret -19
[    1.685969] mic_init not running on X100 ret -19
[    1.688111] emc: device handler registered
[    1.688111] emc: device handler registered
[    1.688843] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    1.688843] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    1.690151] SCSI Media Changer driver v0.25 
[    1.690151] SCSI Media Changer driver v0.25 
[    1.691349] Rounding down aligned max_sectors from 4294967295 to 4294967288
[    1.691349] Rounding down aligned max_sectors from 4294967295 to 4294967288
[    1.694731] arcnet loaded.
[    1.694731] arcnet loaded.
[    1.695244] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[    1.695244] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[    1.696446] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[    1.696446] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[    1.697814] arcnet: raw mode (`r') encapsulation support loaded.
[    1.697814] arcnet: raw mode (`r') encapsulation support loaded.
[    1.698868] arcnet: cap mode (`c') encapsulation support loaded.
[    1.698868] arcnet: cap mode (`c') encapsulation support loaded.
[    1.699970] arcnet: COM90xx chipset support
[    1.699970] arcnet: COM90xx chipset support
[    2.001424] S3: No ARCnet cards found.
[    2.001424] S3: No ARCnet cards found.
[    2.002119] arcnet: RIM I (entirely mem-mapped) support
[    2.002119] arcnet: RIM I (entirely mem-mapped) support
[    2.003041] E-mail me if you actually test the RIM I driver, please!
[    2.003041] E-mail me if you actually test the RIM I driver, please!
[    2.004168] Given: node 00h, shmem 0h, irq 0
[    2.004168] Given: node 00h, shmem 0h, irq 0
[    2.004929] No autoprobe for RIM I; you must specify the shmem and irq!
[    2.004929] No autoprobe for RIM I; you must specify the shmem and irq!
[    2.006089] hdlc: HDLC support module revision 1.22
[    2.006089] hdlc: HDLC support module revision 1.22
[    2.007002] LAPB Ethernet driver version 0.02
[    2.007002] LAPB Ethernet driver version 0.02
[    2.008624] aoe: AoE v85 initialised.
[    2.008624] aoe: AoE v85 initialised.
[    2.009592] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.009592] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.011895] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.011895] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.012795] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.012795] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.013708] parkbd: no such parport
[    2.013708] parkbd: no such parport
[    2.014742] mousedev: PS/2 mouse device common for all mice
[    2.014742] mousedev: PS/2 mouse device common for all mice
[    2.016308] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    2.016308] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    2.018359] I2O subsystem v1.325
[    2.018359] I2O subsystem v1.325
[    2.018945] i2o: max drivers = 8
[    2.018945] i2o: max drivers = 8
[    2.020113] I2O Configuration OSM v1.323
[    2.020113] I2O Configuration OSM v1.323
[    2.021052] I2O Bus Adapter OSM v1.317
[    2.021052] I2O Bus Adapter OSM v1.317
[    2.021764] I2O Block Device OSM v1.325
[    2.021764] I2O Block Device OSM v1.325
[    2.022774] i2c /dev entries driver
[    2.022774] i2c /dev entries driver
[    2.023805] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[    2.023805] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[    2.037136] i2c-parport: adapter type unspecified
[    2.037136] i2c-parport: adapter type unspecified
[    2.038016] i2c-parport-light: adapter type unspecified
[    2.038016] i2c-parport-light: adapter type unspecified
[    2.039893] saa7146: register extension 'budget dvb'
[    2.039893] saa7146: register extension 'budget dvb'
[    2.040839] saa7146: register extension 'budget_patch dvb'
[    2.040839] saa7146: register extension 'budget_patch dvb'
[    2.041835] saa7146: register extension 'av7110'
[    2.041835] saa7146: register extension 'av7110'
[    2.042789] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[    2.042789] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[    2.044044] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH
[    2.044044] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH
[    2.045517] cx25821: driver version 0.0.106 loaded
[    2.045517] cx25821: driver version 0.0.106 loaded
[    2.046401] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    2.046401] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    2.047469] saa7164 driver loaded
[    2.047469] saa7164 driver loaded
[    2.048316] pps pps0: new PPS source ktimer
[    2.048316] pps pps0: new PPS source ktimer
[    2.049078] pps pps0: ktimer PPS source registered
[    2.049078] pps pps0: ktimer PPS source registered
[    2.049923] pps_parport: parallel port PPS client
[    2.049923] pps_parport: parallel port PPS client
[    2.050844] Driver for 1-wire Dallas network protocol.
[    2.050844] Driver for 1-wire Dallas network protocol.
[    2.051949] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.051949] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.053109] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[    2.053109] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[    2.166733] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[    2.166733] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[    2.180063] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[    2.180063] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[    2.193406] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[    2.193406] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[    2.206742] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[    2.206742] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[    2.220066] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.220066] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.233389] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.233389] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.246731] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.246731] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.260069] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.260069] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.273405] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.273405] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.286743] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.286743] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.300070] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.300070] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.313408] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.313408] i2c i2c-0: Detection of w83781d chip failed at step 3
[    2.380065] i2c i2c-0: ADM1025 detection failed at 0x2c
[    2.380065] i2c i2c-0: ADM1025 detection failed at 0x2c
[    2.393404] i2c i2c-0: ADM1025 detection failed at 0x2d
[    2.393404] i2c i2c-0: ADM1025 detection failed at 0x2d
[    2.406728] i2c i2c-0: ADM1025 detection failed at 0x2e
[    2.406728] i2c i2c-0: ADM1025 detection failed at 0x2e
[    2.426716] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and VERSTEP: 0xff
[    2.426716] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and VERSTEP: 0xff
[    2.428108] i2c i2c-0: Autodetecting device at 0,0x2c...
[    2.428108] i2c i2c-0: Autodetecting device at 0,0x2c...
[    2.429032] i2c i2c-0: Autodetection failed
[    2.429032] i2c i2c-0: Autodetection failed
[    2.446728] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and VERSTEP: 0xff
[    2.446728] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and VERSTEP: 0xff
[    2.448117] i2c i2c-0: Autodetecting device at 0,0x2d...
[    2.448117] i2c i2c-0: Autodetecting device at 0,0x2d...
[    2.449008] i2c i2c-0: Autodetection failed
[    2.449008] i2c i2c-0: Autodetection failed
[    2.466728] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and VERSTEP: 0xff
[    2.466728] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and VERSTEP: 0xff
[    2.468127] i2c i2c-0: Autodetecting device at 0,0x2e...
[    2.468127] i2c i2c-0: Autodetecting device at 0,0x2e...
[    2.469066] i2c i2c-0: Autodetection failed
[    2.469066] i2c i2c-0: Autodetection failed
[    2.624632] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[    2.624632] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[    2.806735] i2c i2c-0: detect fail: address match, 0x2c
[    2.806735] i2c i2c-0: detect fail: address match, 0x2c
[    2.820091] i2c i2c-0: detect fail: address match, 0x2d
[    2.820091] i2c i2c-0: detect fail: address match, 0x2d
[    2.833417] i2c i2c-0: detect fail: address match, 0x2e
[    2.833417] i2c i2c-0: detect fail: address match, 0x2e
[    2.846760] i2c i2c-0: detect fail: address match, 0x2f
[    2.846760] i2c i2c-0: detect fail: address match, 0x2f
[    2.860070]  (null): Wrong manufacturer ID. Got 255, expected 65
[    2.860070]  (null): Wrong manufacturer ID. Got 255, expected 65
[    2.873403]  (null): Wrong manufacturer ID. Got 255, expected 65
[    2.873403]  (null): Wrong manufacturer ID. Got 255, expected 65
[    2.886729]  (null): Wrong manufacturer ID. Got 255, expected 65
[    2.886729]  (null): Wrong manufacturer ID. Got 255, expected 65
[    3.220092] f71882fg: Not a Fintek device
[    3.220092] f71882fg: Not a Fintek device
[    3.220853] f71882fg: Not a Fintek device
[    3.220853] f71882fg: Not a Fintek device
[    3.353405]  (null): Unknown chip type, skipping
[    3.353405]  (null): Unknown chip type, skipping
[    3.366733]  (null): Unknown chip type, skipping
[    3.366733]  (null): Unknown chip type, skipping
[    3.940072] i2c i2c-0: LM83 detection failed at 0x18
[    3.940072] i2c i2c-0: LM83 detection failed at 0x18
[    3.953406] i2c i2c-0: LM83 detection failed at 0x19
[    3.953406] i2c i2c-0: LM83 detection failed at 0x19
[    3.966732] i2c i2c-0: LM83 detection failed at 0x1a
[    3.966732] i2c i2c-0: LM83 detection failed at 0x1a
[    3.980071] i2c i2c-0: LM83 detection failed at 0x29
[    3.980071] i2c i2c-0: LM83 detection failed at 0x29
[    3.993410] i2c i2c-0: LM83 detection failed at 0x2a
[    3.993410] i2c i2c-0: LM83 detection failed at 0x2a
[    4.006747] i2c i2c-0: LM83 detection failed at 0x2b
[    4.006747] i2c i2c-0: LM83 detection failed at 0x2b
[    4.020069] i2c i2c-0: LM83 detection failed at 0x4c
[    4.020069] i2c i2c-0: LM83 detection failed at 0x4c
[    4.033422] i2c i2c-0: LM83 detection failed at 0x4d
[    4.033422] i2c i2c-0: LM83 detection failed at 0x4d
[    4.046732] i2c i2c-0: LM83 detection failed at 0x4e
[    4.046732] i2c i2c-0: LM83 detection failed at 0x4e
[    4.066732] i2c i2c-0: Detecting device at 0x2c with COMPANY: 0xff and VERSTEP: 0xff
[    4.066732] i2c i2c-0: Detecting device at 0x2c with COMPANY: 0xff and VERSTEP: 0xff
[    4.068075] i2c i2c-0: Autodetection failed: unsupported version
[    4.068075] i2c i2c-0: Autodetection failed: unsupported version
[    4.086733] i2c i2c-0: Detecting device at 0x2d with COMPANY: 0xff and VERSTEP: 0xff
[    4.086733] i2c i2c-0: Detecting device at 0x2d with COMPANY: 0xff and VERSTEP: 0xff
[    4.088073] i2c i2c-0: Autodetection failed: unsupported version
[    4.088073] i2c i2c-0: Autodetection failed: unsupported version
[    4.106737] i2c i2c-0: Detecting device at 0x2e with COMPANY: 0xff and VERSTEP: 0xff
[    4.106737] i2c i2c-0: Detecting device at 0x2e with COMPANY: 0xff and VERSTEP: 0xff
[    4.108084] i2c i2c-0: Autodetection failed: unsupported version
[    4.108084] i2c i2c-0: Autodetection failed: unsupported version
[    4.160066] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    4.160066] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    4.173412] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    4.173412] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    4.186732] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    4.186732] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[    4.293413] i2c i2c-0: MAX1619 detection failed at 0x18
[    4.293413] i2c i2c-0: MAX1619 detection failed at 0x18
[    4.320071] i2c i2c-0: MAX1619 detection failed at 0x19
[    4.320071] i2c i2c-0: MAX1619 detection failed at 0x19
[    4.346752] i2c i2c-0: MAX1619 detection failed at 0x1a
[    4.346752] i2c i2c-0: MAX1619 detection failed at 0x1a
[    4.373404] i2c i2c-0: MAX1619 detection failed at 0x29
[    4.373404] i2c i2c-0: MAX1619 detection failed at 0x29
[    4.400072] i2c i2c-0: MAX1619 detection failed at 0x2a
[    4.400072] i2c i2c-0: MAX1619 detection failed at 0x2a
[    4.426732] i2c i2c-0: MAX1619 detection failed at 0x2b
[    4.426732] i2c i2c-0: MAX1619 detection failed at 0x2b
[    4.453421] i2c i2c-0: MAX1619 detection failed at 0x4c
[    4.453421] i2c i2c-0: MAX1619 detection failed at 0x4c
[    4.480068] i2c i2c-0: MAX1619 detection failed at 0x4d
[    4.480068] i2c i2c-0: MAX1619 detection failed at 0x4d
[    4.506733] i2c i2c-0: MAX1619 detection failed at 0x4e
[    4.506733] i2c i2c-0: MAX1619 detection failed at 0x4e
[    4.733596] sch56xx_common: Unsupported device id: 0xff
[    4.733596] sch56xx_common: Unsupported device id: 0xff
[    4.734536] sch56xx_common: Unsupported device id: 0xff
[    4.734536] sch56xx_common: Unsupported device id: 0xff
[    4.753415] i2c i2c-0: SMSC47M192 detection failed at 0x2c
[    4.753415] i2c i2c-0: SMSC47M192 detection failed at 0x2c
[    4.773414] i2c i2c-0: SMSC47M192 detection failed at 0x2d
[    4.773414] i2c i2c-0: SMSC47M192 detection failed at 0x2d
[    4.780070] i2c i2c-0: amc6821_detect called.
[    4.780070] i2c i2c-0: amc6821_detect called.
[    4.793406] i2c i2c-0: amc6821: detection failed at 0x18.
[    4.793406] i2c i2c-0: amc6821: detection failed at 0x18.
[    4.800067] i2c i2c-0: amc6821_detect called.
[    4.800067] i2c i2c-0: amc6821_detect called.
[    4.813419] i2c i2c-0: amc6821: detection failed at 0x19.
[    4.813419] i2c i2c-0: amc6821: detection failed at 0x19.
[    4.820062] i2c i2c-0: amc6821_detect called.
[    4.820062] i2c i2c-0: amc6821_detect called.
[    4.833410] i2c i2c-0: amc6821: detection failed at 0x1a.
[    4.833410] i2c i2c-0: amc6821: detection failed at 0x1a.
[    4.840068] i2c i2c-0: amc6821_detect called.
[    4.840068] i2c i2c-0: amc6821_detect called.
[    4.853402] i2c i2c-0: amc6821: detection failed at 0x2c.
[    4.853402] i2c i2c-0: amc6821: detection failed at 0x2c.
[    4.860064] i2c i2c-0: amc6821_detect called.
[    4.860064] i2c i2c-0: amc6821_detect called.
[    4.873424] i2c i2c-0: amc6821: detection failed at 0x2d.
[    4.873424] i2c i2c-0: amc6821: detection failed at 0x2d.
[    4.880066] i2c i2c-0: amc6821_detect called.
[    4.880066] i2c i2c-0: amc6821_detect called.
[    4.893408] i2c i2c-0: amc6821: detection failed at 0x2e.
[    4.893408] i2c i2c-0: amc6821: detection failed at 0x2e.
[    4.900067] i2c i2c-0: amc6821_detect called.
[    4.900067] i2c i2c-0: amc6821_detect called.
[    4.913407] i2c i2c-0: amc6821: detection failed at 0x4c.
[    4.913407] i2c i2c-0: amc6821: detection failed at 0x4c.
[    4.920063] i2c i2c-0: amc6821_detect called.
[    4.920063] i2c i2c-0: amc6821_detect called.
[    4.933421] i2c i2c-0: amc6821: detection failed at 0x4d.
[    4.933421] i2c i2c-0: amc6821: detection failed at 0x4d.
[    4.940078] i2c i2c-0: amc6821_detect called.
[    4.940078] i2c i2c-0: amc6821_detect called.
[    4.953408] i2c i2c-0: amc6821: detection failed at 0x4e.
[    4.953408] i2c i2c-0: amc6821: detection failed at 0x4e.
[    4.960066] thmc50: Probing for THMC50 at 0x2C on bus 0
[    4.960066] thmc50: Probing for THMC50 at 0x2C on bus 0
[    4.986729] thmc50: Probing for THMC50 at 0x2D on bus 0
[    4.986729] thmc50: Probing for THMC50 at 0x2D on bus 0
[    5.013410] thmc50: Probing for THMC50 at 0x2E on bus 0
[    5.013410] thmc50: Probing for THMC50 at 0x2E on bus 0
[    5.153408] i2c i2c-0: W83L786NG detection failed at 0x2e
[    5.153408] i2c i2c-0: W83L786NG detection failed at 0x2e
[    5.166732] i2c i2c-0: W83L786NG detection failed at 0x2f
[    5.166732] i2c i2c-0: W83L786NG detection failed at 0x2f
[    5.168023] advantechwdt: WDT driver for Advantech single board computer initialising
[    5.168023] advantechwdt: WDT driver for Advantech single board computer initialising
[    5.169566] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[    5.169566] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[    5.170675] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[    5.170675] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[    5.171880] ib700wdt: WDT driver for IB700 single board computer initialising
[    5.171880] ib700wdt: WDT driver for IB700 single board computer initialising
[    5.173238] ib700wdt: START method I/O 443 is not available
[    5.173238] ib700wdt: START method I/O 443 is not available
[    5.174239] ib700wdt: probe of ib700wdt failed with error -5
[    5.174239] ib700wdt: probe of ib700wdt failed with error -5
[    5.175302] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[    5.175302] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[    5.176688] wafer5823wdt: I/O address 0x0443 already in use
[    5.176688] wafer5823wdt: I/O address 0x0443 already in use
[    5.177687] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    5.177687] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    5.178830] i6300esb: cannot register miscdev on minor=130 (err=-16)
[    5.178830] i6300esb: cannot register miscdev on minor=130 (err=-16)
[    5.179939] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[    5.179939] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[    5.181219] it87_wdt: no device
[    5.181219] it87_wdt: no device
[    5.181804] sc1200wdt: build 20020303
[    5.181804] sc1200wdt: build 20020303
[    5.182469] sc1200wdt: io parameter must be specified
[    5.182469] sc1200wdt: io parameter must be specified
[    5.183366] pc87413_wdt: Version 1.1 at io 0x2E
[    5.183366] pc87413_wdt: Version 1.1 at io 0x2E
[    5.184167] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
[    5.184167] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
[    5.185318] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    5.185318] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    5.186302] sbc60xxwdt: I/O address 0x0443 already in use
[    5.186302] sbc60xxwdt: I/O address 0x0443 already in use
[    5.187387] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    5.187387] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    5.188461] w83697hf_wdt: watchdog not found at address 0x2e
[    5.188461] w83697hf_wdt: watchdog not found at address 0x2e
[    5.189433] w83697hf_wdt: No W83697HF/HG could be found
[    5.189433] w83697hf_wdt: No W83697HF/HG could be found
[    5.190344] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[    5.190344] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[    5.191866] w83697ug_wdt: No W83697UG/UF could be found
[    5.191866] w83697ug_wdt: No W83697UG/UF could be found
[    5.192765] w83877f_wdt: I/O address 0x0443 already in use
[    5.192765] w83877f_wdt: I/O address 0x0443 already in use
[    5.193721] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    5.193721] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    5.194755] machzwd: no ZF-Logic found
[    5.194755] machzwd: no ZF-Logic found
[    5.195403] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
[    5.195403] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
[    5.196641] md: linear personality registered for level -1
[    5.196641] md: linear personality registered for level -1
[    5.197601] md: raid1 personality registered for level 1
[    5.197601] md: raid1 personality registered for level 1
[    5.198801] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    5.198801] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    5.200561] device-mapper: multipath: version 1.7.0 loaded
[    5.200561] device-mapper: multipath: version 1.7.0 loaded
[    5.201522] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.201522] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.202640] device-mapper: multipath service-time: version 0.2.0 loaded
[    5.202640] device-mapper: multipath service-time: version 0.2.0 loaded
[    5.203798] device-mapper: cache-policy-mq: version 1.2.0 loaded
[    5.203798] device-mapper: cache-policy-mq: version 1.2.0 loaded
[    5.204840] device-mapper: cache cleaner: version 1.0.0 loaded
[    5.204840] device-mapper: cache cleaner: version 1.0.0 loaded
[    5.205840] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    5.205840] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    5.206859] sdhci: Secure Digital Host Controller Interface driver
[    5.206859] sdhci: Secure Digital Host Controller Interface driver
[    5.207929] sdhci: Copyright(c) Pierre Ossman
[    5.207929] sdhci: Copyright(c) Pierre Ossman
[    5.208721] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    5.208721] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    5.209738] wbsd: Copyright(c) Pierre Ossman
[    5.209738] wbsd: Copyright(c) Pierre Ossman
[    8.560068]  (null): enodev DEV ADDR = 0xFF
[    8.560068]  (null): enodev DEV ADDR = 0xFF
[    8.561374] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    8.561374] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    8.564161] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98
[    8.564161] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98
[    8.565509] aedsp16: I/O, IRQ and DMA are mandatory
[    8.565509] aedsp16: I/O, IRQ and DMA are mandatory
[    8.566362] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
[    8.566362] MediaTrix audio driver Copyright (C) by Hannu Savolainen 1993-1996
[    8.567622] I/O, IRQ, DMA and type are mandatory
[    8.567622] I/O, IRQ, DMA and type are mandatory
[    8.568429] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
[    8.568429] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen 1993-1996
[    8.569728] ad1848: No ISAPnP cards found, trying standard ones...
[    8.569728] ad1848: No ISAPnP cards found, trying standard ones...
[    8.570804] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
[    8.570804] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen 1993-1996
[    8.572093] I/O, IRQ, DMA and type are mandatory
[    8.572093] I/O, IRQ, DMA and type are mandatory
[    8.572887] sb: Init: Starting Probe...
[    8.572887] sb: Init: Starting Probe...
[    8.573646] sb: Init: Done
[    8.573646] sb: Init: Done
[    8.574138] uart6850: irq and io must be set.
[    8.574138] uart6850: irq and io must be set.
[    8.574891] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft 1993-1996
[    8.574891] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, Rob Hooft 1993-1996
[    8.576304] MIDI Loopback device driver
[    8.576304] MIDI Loopback device driver
[    8.578257] snd_aloop snd_aloop.0: unable to register OSS PCM device 0:0
[    8.578257] snd_aloop snd_aloop.0: unable to register OSS PCM device 0:0
[    8.580819] snd_mtpav snd_mtpav: unable to register OSS rawmidi device 1:0
[    8.580819] snd_mtpav snd_mtpav: unable to register OSS rawmidi device 1:0
[    8.582173] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[    8.582173] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[    8.583406] oprofile: using NMI interrupt.
[    8.583406] oprofile: using NMI interrupt.
[    8.584156] GACT probability on
[    8.584156] GACT probability on
[    8.584720] Mirror/redirect action on
[    8.584720] Mirror/redirect action on
[    8.585358] Simple TC action Loaded
[    8.585358] Simple TC action Loaded
[    8.585965] netem: version 1.3
[    8.585965] netem: version 1.3
[    8.586507] u32 classifier
[    8.586507] u32 classifier
[    8.586990]     Performance counters on
[    8.586990]     Performance counters on
[    8.587662]     input device check on
[    8.587662]     input device check on
[    8.588300]     Actions configured
[    8.588300]     Actions configured
[    8.588918] NET: Registered protocol family 17
[    8.588918] NET: Registered protocol family 17
[    8.589792] NET: Registered protocol family 15
[    8.589792] NET: Registered protocol family 15
[    8.590626] NET: Registered protocol family 9
[    8.590626] NET: Registered protocol family 9
[    8.591396] X25: Linux Version 0.2
[    8.591396] X25: Linux Version 0.2
[    8.592144] Bluetooth: RFCOMM socket layer initialized
[    8.592144] Bluetooth: RFCOMM socket layer initialized
[    8.593064] Bluetooth: RFCOMM ver 1.11
[    8.593064] Bluetooth: RFCOMM ver 1.11
[    8.593738] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    8.593738] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    8.594664] Bluetooth: BNEP filters: protocol multicast
[    8.594664] Bluetooth: BNEP filters: protocol multicast
[    8.595570] Bluetooth: BNEP socket layer initialized
[    8.595570] Bluetooth: BNEP socket layer initialized
[    8.596442] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    8.596442] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    8.597871] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    8.597871] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    8.599012] NET: Registered protocol family 12
[    8.599012] NET: Registered protocol family 12
[    8.599809] NET: Registered protocol family 35
[    8.599809] NET: Registered protocol family 35
[    8.600673] NET: Registered protocol family 36
[    8.600673] NET: Registered protocol family 36
[    8.601499] openvswitch: Open vSwitch switching datapath
[    8.601499] openvswitch: Open vSwitch switching datapath
[    8.602591] NET: Registered protocol family 40
[    8.602591] NET: Registered protocol family 40
[    8.604373] 
[    8.604373] printing PIC contents
[    8.604373] 
[    8.604373] printing PIC contents
[    8.605219] ... PIC  IMR: ffff
[    8.605219] ... PIC  IMR: ffff
[    8.605762] ... PIC  IRR: 1013
[    8.605762] ... PIC  IRR: 1013
[    8.606304] ... PIC  ISR: 0000
[    8.606304] ... PIC  ISR: 0000
[    8.606854] ... PIC ELCR: 0c00
[    8.606854] ... PIC ELCR: 0c00
[    8.607394] printing local APIC contents on CPU#0/0:
[    8.607394] printing local APIC contents on CPU#0/0:
[    8.608244] ... APIC ID:      00000000 (0)
[    8.608244] ... APIC ID:      00000000 (0)
[    8.608962] ... APIC VERSION: 00050014
[    8.608962] ... APIC VERSION: 00050014
[    8.609616] ... APIC TASKPRI: 00000000 (00)
[    8.609616] ... APIC TASKPRI: 00000000 (00)
[    8.610177] ... APIC PROCPRI: 00000000
[    8.610177] ... APIC PROCPRI: 00000000
[    8.610177] ... APIC LDR: 01000000
[    8.610177] ... APIC LDR: 01000000
[    8.610177] ... APIC DFR: ffffffff
[    8.610177] ... APIC DFR: ffffffff
[    8.610177] ... APIC SPIV: 000001ff
[    8.610177] ... APIC SPIV: 000001ff
[    8.610177] ... APIC ISR field:
[    8.610177] ... APIC ISR field:
[    8.610177] 00000000
[    8.610177] 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

[    8.610177] ... APIC TMR field:
[    8.610177] ... APIC TMR field:
[    8.610177] 00000000
[    8.610177] 000000000200000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

[    8.610177] ... APIC IRR field:
[    8.610177] ... APIC IRR field:
[    8.610177] 00000000
[    8.610177] 000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000008000

[    8.610177] ... APIC ESR: 00000000
[    8.610177] ... APIC ESR: 00000000
[    8.610177] ... APIC ICR: 000008fd
[    8.610177] ... APIC ICR: 000008fd
[    8.610177] ... APIC ICR2: 02000000
[    8.610177] ... APIC ICR2: 02000000
[    8.610177] ... APIC LVTT: 000000ef
[    8.610177] ... APIC LVTT: 000000ef
[    8.610177] ... APIC LVTPC: 00010000
[    8.610177] ... APIC LVTPC: 00010000
[    8.610177] ... APIC LVT0: 00010700
[    8.610177] ... APIC LVT0: 00010700
[    8.610177] ... APIC LVT1: 00000400
[    8.610177] ... APIC LVT1: 00000400
[    8.610177] ... APIC LVTERR: 000000fe
[    8.610177] ... APIC LVTERR: 000000fe
[    8.610177] ... APIC TMICT: 000301f4
[    8.610177] ... APIC TMICT: 000301f4
[    8.610177] ... APIC TMCCT: 00000000
[    8.610177] ... APIC TMCCT: 00000000
[    8.610177] ... APIC TDCR: 00000003
[    8.610177] ... APIC TDCR: 00000003
[    8.610177] 
[    8.610177] 
[    8.625315] number of MP IRQ sources: 15.
[    8.625315] number of MP IRQ sources: 15.
[    8.626014] number of IO-APIC #0 registers: 24.
[    8.626014] number of IO-APIC #0 registers: 24.
[    8.626807] testing the IO APIC.......................
[    8.626807] testing the IO APIC.......................
[    8.627704] IO APIC #0......
[    8.627704] IO APIC #0......
[    8.628202] .... register #00: 00000000
[    8.628202] .... register #00: 00000000
[    8.628865] .......    : physical APIC id: 00
[    8.628865] .......    : physical APIC id: 00
[    8.629613] .......    : Delivery Type: 0
[    8.629613] .......    : Delivery Type: 0
[    8.630313] .......    : LTS          : 0
[    8.630313] .......    : LTS          : 0
[    8.631005] .... register #01: 00170011
[    8.631005] .... register #01: 00170011
[    8.631672] .......     : max redirection entries: 17
[    8.631672] .......     : max redirection entries: 17
[    8.632552] .......     : PRQ implemented: 0
[    8.632552] .......     : PRQ implemented: 0
[    8.633283] .......     : IO APIC version: 11
[    8.633283] .......     : IO APIC version: 11
[    8.634043] .... register #02: 00000000
[    8.634043] .... register #02: 00000000
[    8.634708] .......     : arbitration: 00
[    8.634708] .......     : arbitration: 00
[    8.635403] .... IRQ redirection table:
[    8.635403] .... IRQ redirection table:
[    8.636072] 1    0    0   0   0    0    0    00
[    8.636072] 1    0    0   0   0    0    0    00
[    8.636874] 0    0    0   0   0    1    1    31
[    8.636874] 0    0    0   0   0    1    1    31
[    8.637673] 0    0    0   0   0    1    1    30
[    8.637673] 0    0    0   0   0    1    1    30
[    8.638469] 0    0    0   0   0    1    1    33
[    8.638469] 0    0    0   0   0    1    1    33
[    8.639253] 0    0    0   0   0    1    1    34
[    8.639253] 0    0    0   0   0    1    1    34
[    8.640052] 1    1    0   0   0    1    1    35
[    8.640052] 1    1    0   0   0    1    1    35
[    8.640846] 0    0    0   0   0    1    1    36
[    8.640846] 0    0    0   0   0    1    1    36
[    8.641643] 0    0    0   0   0    1    1    37
[    8.641643] 0    0    0   0   0    1    1    37
[    8.642437] 0    0    0   0   0    1    1    38
[    8.642437] 0    0    0   0   0    1    1    38
[    8.643221] 0    1    0   0   0    1    1    39
[    8.643221] 0    1    0   0   0    1    1    39
[    8.644019] 1    1    0   0   0    1    1    3A
[    8.644019] 1    1    0   0   0    1    1    3A
[    8.644818] 1    1    0   0   0    1    1    3B
[    8.644818] 1    1    0   0   0    1    1    3B
[    8.645610] 0    0    0   0   0    1    1    3C
[    8.645610] 0    0    0   0   0    1    1    3C
[    8.646403] 0    0    0   0   0    1    1    3D
[    8.646403] 0    0    0   0   0    1    1    3D
[    8.647198] 0    0    0   0   0    1    1    3E
[    8.647198] 0    0    0   0   0    1    1    3E
[    8.647993] 0    0    0   0   0    1    1    3F
[    8.647993] 0    0    0   0   0    1    1    3F
[    8.648786] 1    0    0   0   0    0    0    00
[    8.648786] 1    0    0   0   0    0    0    00
[    8.649575] 1    0    0   0   0    0    0    00
[    8.649575] 1    0    0   0   0    0    0    00
[    8.650431] 1    0    0   0   0    0    0    00
[    8.650431] 1    0    0   0   0    0    0    00
[    8.651228] 1    0    0   0   0    0    0    00
[    8.651228] 1    0    0   0   0    0    0    00
[    8.652023] 1    0    0   0   0    0    0    00
[    8.652023] 1    0    0   0   0    0    0    00
[    8.652824] 1    0    0   0   0    0    0    00
[    8.652824] 1    0    0   0   0    0    0    00
[    8.653632] 1    0    0   0   0    0    0    00
[    8.653632] 1    0    0   0   0    0    0    00
[    8.654429] 1    0    0   0   0    0    0    00
[    8.654429] 1    0    0   0   0    0    0    00
[    8.655212] IRQ to pin mappings:
[    8.655212] IRQ to pin mappings:
[    8.655778] IRQ0 
[    8.655778] IRQ0 -> 0:2-> 0:2

[    8.656233] IRQ1 
[    8.656233] IRQ1 -> 0:1-> 0:1

[    8.656706] IRQ3 
[    8.656706] IRQ3 -> 0:3-> 0:3

[    8.657165] IRQ4 
[    8.657165] IRQ4 -> 0:4-> 0:4

[    8.657631] IRQ5 
[    8.657631] IRQ5 -> 0:5-> 0:5

[    8.658088] IRQ6 
[    8.658088] IRQ6 -> 0:6-> 0:6

[    8.658546] IRQ7 
[    8.658546] IRQ7 -> 0:7-> 0:7

[    8.659001] IRQ8 
[    8.659001] IRQ8 -> 0:8-> 0:8

[    8.659460] IRQ9 
[    8.659460] IRQ9 -> 0:9-> 0:9

[    8.659926] IRQ10 
[    8.659926] IRQ10 -> 0:10-> 0:10

[    8.660431] IRQ11 
[    8.660431] IRQ11 -> 0:11-> 0:11

[    8.660919] IRQ12 
[    8.660919] IRQ12 -> 0:12-> 0:12

[    8.661413] IRQ13 
[    8.661413] IRQ13 -> 0:13-> 0:13

[    8.661899] IRQ14 
[    8.661899] IRQ14 -> 0:14-> 0:14

[    8.662389] IRQ15 
[    8.662389] IRQ15 -> 0:15-> 0:15

[    8.662873] .................................... done.
[    8.662873] .................................... done.
[    8.663977] bootconsole [earlyser0] disabled
[    8.663977] bootconsole [earlyser0] disabled
[    8.664758] registered taskstats version 1
[    8.665661]   Magic number: 14:835:645
[    8.666062] tty ptyda: hash matches
[    8.666534] saa7134 ALSA driver for DMA sound loaded
[    8.666991] saa7134 ALSA: no saa7134 cards found
[    8.667583] PM: Hibernation image not present or could not be loaded

--------------020608010801060400010501
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

_______________________________________________
LKP mailing list
LKP@linux.intel.com


--------------020608010801060400010501
Content-Type: text/plain; charset=UTF-8;
 name="config-3.15.0-rc3-00781-g9b17aee"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.15.0-rc3-00781-g9b17aee"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.15.0-rc3 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_THROTTLING is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
CONFIG_MPSC=y
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=12
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_INJECT=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSWAP is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_HHF=y
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=y
# CONFIG_NFC_NCI_SPI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_TRF7970A=y
CONFIG_NFC_SIM=y
CONFIG_NFC_MRVL=y
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
# CONFIG_DM_ERA is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_RAID is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
CONFIG_DM_MULTIPATH_ST=y
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
CONFIG_DM_VERITY=y
CONFIG_DM_SWITCH=y
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
CONFIG_SBP_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
# CONFIG_I2O_SCSI is not set
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_PCI is not set

#
# CAIF transport drivers
#
# CONFIG_VHOST_NET is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_MICREL_KS8995MA=y
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
# CONFIG_HDLC_RAW is not set
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y
CONFIG_HDLC_X25=y
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=y
CONFIG_PC300TOO=y
CONFIG_FARSYNC=y
# CONFIG_DLCI is not set
CONFIG_LAPBETHER=y
# CONFIG_X25_ASY is not set
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_GOLDFISH_TTY is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MRST_MAX3110 is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
CONFIG_SPI_GPIO=y
# CONFIG_SPI_LM70_LLP is not set
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_SPMI=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_MAX8998 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
# CONFIG_BATTERY_GOLDFISH is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_DA9055_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=y
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_EZX_PCAP=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
CONFIG_REGULATOR_88PM8607=y
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9055 is not set
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_MAX8997 is not set
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS80031 is not set
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8350=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_DVB_CORE=y
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX25821=y
# CONFIG_VIDEO_CX25821_ALSA is not set
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_ALSA=y
CONFIG_VIDEO_SAA7134_DVB=y
CONFIG_VIDEO_SAA7164=y

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110=y
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=y
CONFIG_DVB_BUDGET=y
# CONFIG_DVB_BUDGET_AV is not set
CONFIG_DVB_BUDGET_PATCH=y
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
CONFIG_DVB_PLUTO2=y
CONFIG_DVB_PT1=y
CONFIG_DVB_NGENE=y
CONFIG_DVB_DDBRIDGE=y

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set
# CONFIG_RADIO_ADAPTERS is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
# CONFIG_VIDEO_TDA7432 is not set
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
# CONFIG_VIDEO_VP27SMPX is not set
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=y
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_ML86V7667=y
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=y
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_AK881X is not set
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
# CONFIG_MEDIA_TUNER_MT2266 is not set
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
# CONFIG_MEDIA_TUNER_E4000 is not set
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_M88TS2022=y
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_MEDIA_TUNER_IT913X=y
# CONFIG_MEDIA_TUNER_R820T is not set

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_CX24117=y
# CONFIG_DVB_SI21XX is not set
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y
CONFIG_DVB_MB86A16=y
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
# CONFIG_DVB_CX22702 is not set
CONFIG_DVB_S5H1432=y
# CONFIG_DVB_DRXD is not set
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=y
# CONFIG_DVB_ZL10353 is not set
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
# CONFIG_DVB_DIB7000P is not set
CONFIG_DVB_DIB9000=y
# CONFIG_DVB_TDA10048 is not set
CONFIG_DVB_AF9013=y
# CONFIG_DVB_EC100 is not set
CONFIG_DVB_HD29L2=y
# CONFIG_DVB_STV0367 is not set
CONFIG_DVB_CXD2820R=y
# CONFIG_DVB_RTL2830 is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
CONFIG_DVB_OR51132=y
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
CONFIG_DVB_DIB8000=y
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
# CONFIG_DVB_PLL is not set
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_DRX39XYJ is not set
CONFIG_DVB_LNBP21=y
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6405=y
# CONFIG_DVB_ISL6421 is not set
CONFIG_DVB_ISL6423=y
# CONFIG_DVB_A8293 is not set
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
# CONFIG_DVB_TDA665x is not set
CONFIG_DVB_IX2505V=y
CONFIG_DVB_M88RS2000=y
CONFIG_DVB_AF9033=y

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
# CONFIG_DRM_BOCHS is not set
CONFIG_DRM_PTN3460=y

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
# CONFIG_FB_MATROX_I2C is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_HDMI=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
CONFIG_SND_ALOOP=y
CONFIG_SND_MTPAV=y
CONFIG_SND_MTS64=y
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set
# CONFIG_SND_PCI is not set

#
# HD-Audio
#
CONFIG_SND_SPI=y
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
# CONFIG_SND_DICE is not set
CONFIG_SND_FIREWIRE_SPEAKERS=y
CONFIG_SND_ISIGHT=y
CONFIG_SND_SCS1X=y
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
CONFIG_SOUND_DMAP=y
CONFIG_SOUND_VMIDI=y
CONFIG_SOUND_TRIX=y
# CONFIG_TRIX_HAVE_BOOT is not set
# CONFIG_SOUND_MSS is not set
# CONFIG_SOUND_MPU401 is not set
CONFIG_SOUND_PAS=y
CONFIG_PAS_JOYSTICK=y
# CONFIG_SOUND_PSS is not set
# CONFIG_SOUND_SB is not set
CONFIG_SOUND_YM3812=y
CONFIG_SOUND_UART6850=y
CONFIG_SOUND_AEDSP16=y
CONFIG_SC6600=y
# CONFIG_SC6600_JOY is not set
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_GOLDFISH=y
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_REALTEK_PCI=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
CONFIG_GOLDFISH_PIPE=y
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_MAX14577=y
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_PALMAS=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LPSS is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_SAMSUNG_USB2 is not set
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set

--------------020608010801060400010501--
