Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaGUBM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 21:12:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:33027 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaGUBMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 21:12:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,697,1400050800"; 
   d="log'?scan'208";a="572818351"
Message-ID: <53CC6872.70402@intel.com>
Date: Mon, 21 Jul 2014 09:10:10 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Su Tao <tao.su@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [Tree sweep] BUG: sleeping function called from invalid context at
 include/linux/highmem.h:58
Content-Type: multipart/mixed;
 boundary="------------010803070609060701020401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010803070609060701020401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andi,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git scale/rcu-symlink
commit 25c305debfd676aa495137ca1eec21fce15198e7
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat Jul 12 22:46:24 2014 -0700
Commit:     Andi Kleen <ak@linux.intel.com>
CommitDate: Sun Jul 20 09:43:32 2014 -0700

     Tree sweep: Mark all page_follow_link_light users as RCU safe
         Now that page_follow_link_light() is RCU safe, mark all
     users as supporting RCU by using the follow_link_rcu
     entry point.
         Signed-off-by: Andi Kleen <ak@linux.intel.com>

+------------------------------------------------------------------------------+------------+------------+
|                                                                              | 868656d432 | 25c305debf |
+------------------------------------------------------------------------------+------------+------------+
| boot_successes                                                               | 60         | 0          |
| boot_failures                                                                | 0          | 20         |
| BUG:sleeping_function_called_from_invalid_context_at_include/linux/highmem.h | 0          | 20         |
| backtrace:SYSC_socketcall                                                    | 0          | 11         |
| backtrace:SyS_socketcall                                                     | 0          | 12         |
| backtrace:do_sys_open                                                        | 0          | 1          |
| backtrace:SyS_open                                                           | 0          | 1          |
| backtrace:SYSC_faccessat                                                     | 0          | 7          |
| backtrace:SyS_access                                                         | 0          | 7          |
+------------------------------------------------------------------------------+------------+------------+

[    1.309807] evm: HMAC attrs: 0x0
[    1.311772] Freeing unused kernel memory: 424K (79650000 - 796ba000)
[    1.319415] random: init urandom read with 0 bits of entropy available
[    1.322727] BUG: sleeping function called from invalid context at include/linux/highmem.h:58
[    1.323637] in_atomic(): 0, irqs_disabled(): 0, pid: 91, name: rc.local
[    1.324200] 1 lock held by rc.local/91:
[    1.324514]  #0:  (rcu_read_lock){......}, at: [<790ca709>] rcu_read_lock+0x0/0x70
[    1.325199] Preemption disabled at:[<79063d3c>] console_unlock+0x37e/0x3d2
[    1.325774] [    1.325940] CPU: 0 PID: 91 Comm: rc.local Not tainted 3.16.0-rc4-00160-g25c305d #204
[    1.326610] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.327098]  00000000 00000000 849adb5c 793b1aa6 00000000 849adb88 7904b1b2 795b42cc
[    1.327827]  79063d3c 79063d3c 0000005b 8499c3d0 00000000 8a53bd80 89cc5830 849adbac
[    1.328584]  849adba4 790caeda 00000000 00000000 849adca0 00000003 00000000 849adbb4
[    1.329309] Call Trace:
[    1.329521]  [<793b1aa6>] dump_stack+0x49/0x73
[    1.329884]  [<7904b1b2>] __might_sleep+0x1d1/0x1d9
[    1.330302]  [<79063d3c>] ? console_unlock+0x37e/0x3d2
[    1.330723]  [<79063d3c>] ? console_unlock+0x37e/0x3d2
[    1.331144]  [<790caeda>] page_getlink.isra.31.constprop.47+0x78/0xbc
[    1.331666]  [<790caf40>] page_follow_link_light+0x22/0x30
[    1.332146]  [<790cb846>] link_path_walk+0x30b/0x524
[    1.332564]  [<790caf1e>] ? page_getlink.isra.31.constprop.47+0xbc/0xbc
[    1.332566]  [<790cbaad>] path_lookupat+0x4e/0x3e9
[    1.332571]  [<7905bb4e>] ? find_usage_backwards+0x62/0x69
[    1.332573]  [<7905c72f>] ? mark_lock+0x1e/0x217
[    1.332575]  [<790cbe67>] filename_lookup.isra.34+0x1f/0x54
[    1.332577]  [<790cbeca>] do_path_lookup+0x2e/0x36
[    1.332580]  [<790cbeef>] kern_path+0x1d/0x32
[    1.332585]  [<790b8d9f>] ? virt_to_head_page+0x8/0x49
[    1.332587]  [<790b94ab>] ? ksize+0x13/0x1e
[    1.332593]  [<79384cad>] ? __alloc_skb+0x80/0x154
[    1.332599]  [<793a828d>] unix_find_other.isra.30+0x27/0x160
[    1.332605]  [<79381e3f>] ? sock_wmalloc+0x53/0x5e
[    1.332606]  [<793a966f>] unix_stream_connect+0xd8/0x37a
[    1.332608]  [<7937f4b0>] SYSC_connect+0x7e/0xb4
[    1.332616]  [<791c466c>] ? _copy_from_user+0x35/0x49
[    1.332618]  [<7937fcf0>] SYSC_socketcall+0xba/0x3de
[    1.332620]  [<7905ef9f>] ? lock_release+0x151/0x195
[    1.332623]  [<793b97d6>] ? _raw_spin_unlock+0x27/0x39
[    1.332625]  [<790ab27b>] ? do_read_fault.isra.85+0x23c/0x246
[    1.332628]  [<7905ef9f>] ? lock_release+0x151/0x195
[    1.332630]  [<7904b099>] ? __might_sleep+0xb8/0x1d9
[    1.332631]  [<7905aa8c>] ? up_read+0x1d/0x20
[    1.332634]  [<790276f0>] ? __do_page_fault+0x35a/0x3d0
[    1.332636]  [<790aa047>] ? might_fault+0x92/0x98
[    1.332638]  [<793ba2cb>] ? restore_all+0xf/0xf
[    1.332642]  [<791d6677>] ? __this_cpu_preempt_check+0xf/0x11
[    1.332643]  [<79027780>] ? do_page_fault+0x1a/0x1e
[    1.332645]  [<79380045>] SyS_socketcall+0xe/0x10
[    1.332647]  [<793ba292>] syscall_call+0x7/0xb
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory

git bisect start c0902b93f0f427427f6cb75cb5074288f8001d5d 6b458ac195c51790830b2267bdf3edaae27eab3e --
git bisect  bad 25c305debfd676aa495137ca1eec21fce15198e7  # 04:23      0-     20  Tree sweep: Mark all page_follow_link_light users as RCU safe
git bisect good 07076cff76ba5dfaf3c0e7028df5e2dd47cf240d  # 04:25     20+      0  vfs: Add follow_link_rcu to inode_ops
git bisect good ee1765112b945f13fdac430d677621a20207d593  # 04:28     20+      0  vfs: Update path-lookup.txt for RCU symlink walking
git bisect good 868656d432372fc95e57ec7bcd0ac17b0734c806  # 04:31     20+      0  vfs: Make page_follow_link_light RCU safe
# first bad commit: [25c305debfd676aa495137ca1eec21fce15198e7] Tree sweep: Mark all page_follow_link_light users as RCU safe
git bisect good 868656d432372fc95e57ec7bcd0ac17b0734c806  # 04:34     60+      0  vfs: Make page_follow_link_light RCU safe
git bisect  bad c0902b93f0f427427f6cb75cb5074288f8001d5d  # 04:34      0-     11  fixup! xfs: Add RCU fast symlink path
git bisect good d057190925d994b808e1d07e6c76b90a32caac77  # 04:39     60+      0  Merge branch 'locking-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 58e323c3ee94f1abcecdeeef211a27d1c106c2b3  # 04:43     60+     60  Add linux-next specific files for 20140718


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 2
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null )

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=10
	softlockup_panic=1
	nmi_watchdog=panic
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Jet


--------------010803070609060701020401
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-quantal-kbuild-11:20140721042139:i386-randconfig-r0-0721:3.16.0-rc4-00160-g25c305d:204"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-quantal-kbuild-11:20140721042139:i386-randconfig-r0-07";
 filename*1="21:3.16.0-rc4-00160-g25c305d:204"

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc4-00160-g25c305d (kbuild@roam) (gcc=
 version 4.8.2 (Debian 4.8.2-18) ) #204 SMP PREEMPT Mon Jul 21 03:36:24 C=
ST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled:=
 non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13bfffff] page 2M
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x01e7a000, 0x01e7afff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001=
 BXPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001=
 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001=
 INTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001=
 BXPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001=
 BXPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001=
 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @8a513000 s27008 r0 d22144 u=
49152
[    0.000000] pcpu-alloc: s27008 r0 d22144 u49152 alloc=3D12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 125156c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-r0-0721/a=
k:scale:rcu-symlink:25c305debfd676aa495137ca1eec21fce15198e7:bisect-linux=
8/.vmlinuz-25c305debfd676aa495137ca1eec21fce15198e7-20140721042303-5-kbui=
ld branch=3Dak/scale/rcu-symlink BOOT_IMAGE=3D/kernel/i386-randconfig-r0-=
0721/25c305debfd676aa495137ca1eec21fce15198e7/vmlinuz-3.16.0-rc4-00160-g2=
5c305d drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 284424K/327280K available (3820K kernel code, 375K=
 rwdata, 2256K rodata, 424K init, 7884K bss, 42856K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     vmalloc : 0x8c7fe000 - 0xffd34000   (1845 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x8bffe000   ( 319 MB)
[    0.000000]       .init : 0x79650000 - 0x796ba000   ( 424 kB)
[    0.000000]       .data : 0x793bb632 - 0x7964ec80   (2637 kB)
[    0.000000]       .text : 0x79000000 - 0x793bb632   (3821 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D8a00a000 soft=3D8a00c000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 4911 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------=
------------------
[    0.000000]                                  | spin |wlock |rlock |mut=
ex | wsem | rsem |
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]               recursive read-lock:             |  ok  |   =
          |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |   =
          |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |   =
          |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |   =
          |  ok  |
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  o=
k  |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] allocated 655360 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.332 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5388.10 Bo=
goMIPS (lpj=3D8977773)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006666] ACPI: Core revision 20140424
[    0.009421] ACPI: All ACPI Tables successfully acquired
[    0.010071] Security Framework initialized
[    0.010428] Yama: becoming mindful.
[    0.010803] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes=
)
[    0.011366] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 =
bytes)
[    0.012756] Initializing cgroup subsys memory
[    0.013231] Initializing cgroup subsys perf_event
[    0.013433] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013433] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.013433] tlb_flushall_shift: 6
[    0.015184] Freeing SMP alternatives memory: 12K (796ba000 - 796bd000)=

[    0.017167] Getting VERSION: 1050014
[    0.017485] Getting VERSION: 1050014
[    0.017803] Getting ID: 0
[    0.018036] Getting ID: f000000
[    0.018310] Getting LVT0: 8700
[    0.018577] Getting LVT1: 8400
[    0.018847] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.019359] enabled ExtINT on CPU#0
[    0.020447] ENABLING IO-APIC IRQs
[    0.020749] init IO_APIC IRQs
[    0.021005]  apic 0 pin 0 not connected
[    0.021357] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.022043] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.022730] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.023354] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.024024] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.024697] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.025360] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.026031] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.026686] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.027357] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.028042] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.028724] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.029398] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.030022] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.030721] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.031406]  apic 0 pin 16 not connected
[    0.031735]  apic 0 pin 17 not connected
[    0.032061]  apic 0 pin 18 not connected
[    0.032395]  apic 0 pin 19 not connected
[    0.032724]  apic 0 pin 20 not connected
[    0.033338]  apic 0 pin 21 not connected
[    0.033675]  apic 0 pin 22 not connected
[    0.034000]  apic 0 pin 23 not connected
[    0.034476] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.035123] smpboot: CPU0: Intel Core Processor (Haswell) (fam: 06, mo=
del: 3c, stepping: 01)
[    0.036030] TSC deadline timer enabled
[    0.036434] Performance Events: unsupported p6 CPU model 60 no PMU dri=
ver, software events only.
[    0.053366] NMI watchdog: disabled (cpu0): hardware events not enabled=

[    0.057336] CPU 1 irqstacks, hard=3D8a152000 soft=3D8a154000
[    0.057934] x86: Booting SMP configuration:
[    0.058410] .... node  #0, CPUs:      #1
[    0.003333] Initializing CPU#1
[    0.006666] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.073458] x86: Booted up 1 node, 2 CPUs
[    0.073426] KVM setup async PF for cpu 1
[    0.073432] kvm-stealtime: cpu 1, msr 125216c0
[    0.074530] ----------------
[    0.074783] | NMI testsuite:
[    0.075022] --------------------
[    0.075291]   remote IPI:  ok  |
[    0.080192]    local IPI:  ok  |
[    0.093369] --------------------
[    0.093810] Good, all   2 testcases passed! |
[    0.094383] ---------------------------------
[    0.095081] smpboot: Total of 2 processors activated (10777.21 BogoMIP=
S)
[    0.097784] evm: security.capability
[    0.099182] prandom: seed boundary self test passed
[    0.100822] prandom: 100 self tests passed
[    0.101929] NET: Registered protocol family 16
[    0.103705] cpuidle: using governor ladder
[    0.104250] cpuidle: using governor menu
[    0.105152] ACPI: bus type PCI registered
[    0.106335] dca service started, version 1.12.1
[    0.107024] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0=

[    0.107741] PCI: Using configuration type 1 for base access
[    0.120654] ACPI: Added _OSI(Module Device)
[    0.121072] ACPI: Added _OSI(Processor Device)
[    0.121604] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.123343] ACPI: Added _OSI(Processor Aggregator Device)
[    0.130687] ACPI: Interpreter enabled
[    0.131046] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S1_] (20140424/hwxface-580)
[    0.131826] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20140424/hwxface-580)
[    0.132625] ACPI: (supports S0 S3 S5)
[    0.132960] ACPI: Using IOAPIC for interrupt routing
[    0.133391] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.144855] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.145378] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.145918] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASP=
M
[    0.146943] acpi PNP0A03:00: fail to add MMCONFIG information, can't a=
ccess extended PCI configuration space under this bridge.
[    0.148184] PCI host bridge to bus 0000:00
[    0.148531] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.148987] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.149487] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.149996] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.150009] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebff=
fff]
[    0.150688] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.151792] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.153063] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.155532] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.156695] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-=
0x01f7]
[    0.157275] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]=

[    0.157816] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-=
0x0177]
[    0.158390] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]=

[    0.159356] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.160189] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PI=
IX4 ACPI
[    0.160790] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PI=
IX4 SMB
[    0.161803] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.163890] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pre=
f]
[    0.165498] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.170569] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pre=
f]
[    0.171840] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.173153] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.174138] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.178286] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pre=
f]
[    0.179255] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.180222] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.183757] pci_bus 0000:00: on NUMA node 0
[    0.185182] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.185921] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.186638] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.187014] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.187674] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.188927] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.190099] SCSI subsystem initialized
[    0.190520] libata version 3.00 loaded.
[    0.190921] ACPI: bus type USB registered
[    0.191401] usbcore: registered new interface driver usbfs
[    0.191905] usbcore: registered new interface driver hub
[    0.192470] usbcore: registered new device driver usb
[    0.193355] PCI: Using ACPI for IRQ routing
[    0.193710] PCI: pci_cache_line_size set to 64 bytes
[    0.194218] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.194711] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.196274] HPET: 3 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.196878] Switched to clocksource kvm-clock
[    0.197576] pnp: PnP ACPI init
[    0.197895] ACPI: bus type PNP registered
[    0.198469] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:3)
[    0.199306] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.199770] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:3)
[    0.200547] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)=

[    0.201176] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:3)
[    0.201949] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)=

[    0.202554] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:3)
[    0.203219] pnp 00:03: [dma 2]
[    0.203576] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)=

[    0.204195] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:3)
[    0.205003] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)=

[    0.205611] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:3)
[    0.206354] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.206977] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:3)
[    0.207733] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.208748] pnp: PnP ACPI: found 7 devices
[    0.209092] ACPI: bus type PNP unregistered
[    0.209443] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.245631] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.246107] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.246560] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.247093] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.247674] NET: Registered protocol family 1
[    0.248111] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.248607] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.249096] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.249623] pci 0000:00:02.0: Boot video device
[    0.250033] PCI: CLS 0 bytes, default 64
[    0.251060] Unpacking initramfs...
[    1.133701] Freeing initrd memory: 24852K (8a7ab000 - 8bff0000)
[    1.134914] apm: BIOS not found.
[    1.136694] The force parameter has not been set to 1. The Iris powero=
ff handler will not be installed.
[    1.137538] spin_lock-torture:--- Start of test: nwriters_stress=3D4 s=
tat_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_s=
ecs=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.138786] spin_lock-torture: Creating torture_shuffle task
[    1.139383] spin_lock-torture: torture_shuffle task started
[    1.139390] spin_lock-torture: Creating torture_stutter task
[    1.139465] spin_lock-torture: Creating lock_torture_writer task
[    1.139494] spin_lock-torture: torture_stutter task started
[    1.142525] spin_lock-torture: Creating lock_torture_writer task
[    1.142543] spin_lock-torture: lock_torture_writer task started
[    1.143690] spin_lock-torture: Creating lock_torture_writer task
[    1.143703] spin_lock-torture: lock_torture_writer task started
[    1.144829] spin_lock-torture: Creating lock_torture_writer task
[    1.144846] spin_lock-torture: lock_torture_writer task started
[    1.145961] spin_lock-torture: Creating lock_torture_stats task
[    1.145989] spin_lock-torture: lock_torture_writer task started
[    1.147153] spin_lock-torture: lock_torture_stats task started
[    1.147827] futex hash table entries: 512 (order: 3, 32768 bytes)
[    1.147890] Initialise system trusted keyring
[    1.148645] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.150533] VFS: Disk quotas dquot_6.5.2
[    1.150969] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=

[    1.152468] NILFS version 2 loaded
[    1.152778] msgmni has been set to 604
[    1.157416] alg: No test for crc32 (crc32-table)
[    1.158344] alg: No test for stdrng (krng)
[    1.166082] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    1.166865] Key type asymmetric registered
[    1.167257] Asymmetric key parser 'x509' registered
[    1.167729] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 254)
[    1.168358] io scheduler noop registered (default)
[    1.168755] start plist test
[    1.170547] end plist test
[    1.171425] ipmi message handler version 39.2
[    1.172109] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
[    1.172749] ACPI: Power Button [PWRF]
[    1.173732] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.174827] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.199415] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200=
) is a 16550A
[    1.201499] SyncLink GT
[    1.201724] SyncLink GT, tty major#252
[    1.202076] SyncLink GT no devices found
[    1.202409] SyncLink MultiPort driver $Revision: 4.38 $
[    1.211631] SyncLink MultiPort driver $Revision: 4.38 $, tty major#251=

[    1.212254] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw=
2 Exp $
[    1.212836] ac.o: No PCI boards found.
[    1.213150] ac.o: For an ISA board you must supply memory and irq para=
meters.
[    1.213840] Linux agpgart interface v0.103
[    1.214199] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 sec=
onds, margin is 60 seconds).
[    1.214914] Hangcheck: Using getrawmonotonic().
[    1.215774] usbcore: registered new interface driver viperboard
[    1.216832] SCSI Media Changer driver v0.25=20
[    1.218287] Rounding down aligned max_sectors from 4294967295 to 42949=
67288
[    1.219572] platform physmap-flash.0: failed to claim resource 0
[    1.220715] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.221261] ohci-platform: OHCI generic platform driver
[    1.221727] driver u132_hcd
[    1.222209] usbcore: registered new interface driver cdc_acm
[    1.222677] cdc_acm: USB Abstract Control Model driver for USB modems =
and ISDN adapters
[    1.223399] usbcore: registered new interface driver usbtmc
[    1.223926] usbcore: registered new interface driver usb-storage
[    1.224464] usbcore: registered new interface driver ums-datafab
[    1.224982] usbcore: registered new interface driver ums-freecom
[    1.225608] usbcore: registered new interface driver usbserial
[    1.226127] usbcore: registered new interface driver usbserial_generic=

[    1.226773] usbserial: USB Serial support registered for generic
[    1.227318] usbcore: registered new interface driver aircable
[    1.227822] usbserial: USB Serial support registered for aircable
[    1.228353] usbcore: registered new interface driver ark3116
[    1.228850] usbserial: USB Serial support registered for ark3116
[    1.229379] usbcore: registered new interface driver cp210x
[    1.229865] usbserial: USB Serial support registered for cp210x
[    1.230444] usbcore: registered new interface driver usb_debug
[    1.230959] usbserial: USB Serial support registered for debug
[    1.231487] usbcore: registered new interface driver digi_acceleport
[    1.232034] usbserial: USB Serial support registered for Digi 2 port U=
SB adapter
[    1.232673] usbserial: USB Serial support registered for Digi 4 port U=
SB adapter
[    1.233312] usbcore: registered new interface driver ipaq
[    1.233815] usbserial: USB Serial support registered for PocketPC PDA
[    1.234389] usbcore: registered new interface driver ir_usb
[    1.234879] usbserial: USB Serial support registered for IR Dongle
[    1.235425] usbcore: registered new interface driver mct_u232
[    1.235940] usbserial: USB Serial support registered for MCT U232
[    1.236478] usbcore: registered new interface driver metro_usb
[    1.237001] usbserial: USB Serial support registered for Metrologic US=
B to Serial
[    1.237653] usbcore: registered new interface driver mxuport
[    1.238153] usbserial: USB Serial support registered for MOXA UPort
[    1.238698] usbcore: registered new interface driver opticon
[    1.239200] usbserial: USB Serial support registered for opticon
[    1.239724] usbcore: registered new interface driver qcserial
[    1.240284] usbserial: USB Serial support registered for Qualcomm USB =
modem
[    1.240891] usbcore: registered new interface driver sierra
[    1.241387] usbserial: USB Serial support registered for Sierra USB mo=
dem
[    1.241981] usbcore: registered new interface driver usb_serial_simple=

[    1.242601] usbserial: USB Serial support registered for zio
[    1.243097] usbserial: USB Serial support registered for funsoft
[    1.243686] usbserial: USB Serial support registered for flashloader
[    1.244275] usbserial: USB Serial support registered for vivopay
[    1.244833] usbserial: USB Serial support registered for moto_modem
[    1.245416] usbserial: USB Serial support registered for hp4x
[    1.245921] usbserial: USB Serial support registered for suunto
[    1.246478] usbserial: USB Serial support registered for siemens_mpi
[    1.247050] usbcore: registered new interface driver ssu100
[    1.247581] usbserial: USB Serial support registered for Quatech SSU-1=
00 USB to Serial Driver
[    1.248339] usbcore: registered new interface driver ti_usb_3410_5052
[    1.248898] usbserial: USB Serial support registered for TI USB 3410 1=
 port adapter
[    1.249595] usbserial: USB Serial support registered for TI USB 5052 2=
 port adapter
[    1.250312] usbcore: registered new interface driver whiteheat
[    1.250834] usbserial: USB Serial support registered for Connect Tech =
- WhiteHEAT - (prerenumeration)
[    1.251645] usbserial: USB Serial support registered for Connect Tech =
- WhiteHEAT
[    1.252293] usbcore: registered new interface driver keyspan_pda
[    1.252829] usbserial: USB Serial support registered for Keyspan PDA
[    1.253452] usbserial: USB Serial support registered for Xircom / Entr=
egra PGS - (prerenumeration)
[    1.254222] usbcore: registered new interface driver zte_ev
[    1.254745] usbserial: USB Serial support registered for zte_ev
[    1.255277] usbcore: registered new interface driver cytherm
[    1.255772] ftdi_elan: driver ftdi-elan
[    1.256482] usbcore: registered new interface driver ftdi-elan
[    1.257035] usbcore: registered new interface driver idmouse
[    1.257581] usbcore: registered new interface driver usbled
[    1.258217] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0=
x60,0x64 irq 1,12
[    1.259689] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.260482] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.261267] evbug: Connected device: input0 (Power Button at LNXPWRBN/=
button/input0)
[    1.262958] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input1
[    1.263726] evbug: Connected device: input1 (AT Translated Set 2 keybo=
ard at isa0060/serio0/input0)
[    1.265277] Driver for 1-wire Dallas network protocol.
[    1.265855] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    1.267613] lguest: switcher text too large (4384)
[    1.268051] ledtrig-cpu: registered to indicate activity on CPUs
[    1.268759] vme_user: VME User Space Access Driver
[    1.269192] vme_user: No cards, skipping registration
[    1.269641] vme_pio2: No cards, skipping registration
[    1.270816] FPGA DOWNLOAD --->
[    1.271089] FPGA image file name: xlinx_fpga_firmware.bit
[    1.271636] GPIO INIT FAIL!!
[    1.272463]=20
[    1.272463] printing PIC contents
[    1.272940] ... PIC  IMR: ffff
[    1.273254] ... PIC  IRR: 1012
[    1.273540] ... PIC  ISR: 0000
[    1.273804] ... PIC ELCR: 0c00
[    1.274084] printing local APIC contents on CPU#0/0:
[    1.274526] ... APIC ID:      00000000 (0)
[    1.274864] ... APIC VERSION: 01050014
[    1.275205] ... APIC TASKPRI: 00000000 (00)
[    1.275547] ... APIC PROCPRI: 00000000
[    1.275910] ... APIC LDR: 01000000
[    1.276200] ... APIC DFR: ffffffff
[    1.276518] ... APIC SPIV: 000001ff
[    1.276804] ... APIC ISR field:
[    1.277066] 0000000000000000000000000000000000000000000000000000000000=
000000
[    1.277409] ... APIC TMR field:
[    1.277409] 0000000002000000000000000000000000000000000000000000000000=
000000
[    1.277409] ... APIC IRR field:
[    1.277409] 0000000000000000000000000000000000000000000000000000000000=
000000
[    1.277409] ... APIC ESR: 00000000
[    1.277409] ... APIC ICR: 000008fd
[    1.277409] ... APIC ICR2: 02000000
[    1.277409] ... APIC LVTT: 000400ef
[    1.277409] ... APIC LVTPC: 00010000
[    1.277409] ... APIC LVT0: 00010700
[    1.277409] ... APIC LVT1: 00000400
[    1.277409] ... APIC LVTERR: 000000fe
[    1.277409] ... APIC TMICT: 00000000
[    1.277409] ... APIC TMCCT: 00000000
[    1.277409] ... APIC TDCR: 00000000
[    1.277409]=20
[    1.283298] number of MP IRQ sources: 15.
[    1.283660] number of IO-APIC #0 registers: 24.
[    1.284038] testing the IO APIC.......................
[    1.284488] IO APIC #0......
[    1.284734] .... register #00: 00000000
[    1.285061] .......    : physical APIC id: 00
[    1.285503] .......    : Delivery Type: 0
[    1.285838] .......    : LTS          : 0
[    1.286176] .... register #01: 00170011
[    1.286495] .......     : max redirection entries: 17
[    1.286930] .......     : PRQ implemented: 0
[    1.287290] .......     : IO APIC version: 11
[    1.287657] .... register #02: 00000000
[    1.287977] .......     : arbitration: 00
[    1.288317] .... IRQ redirection table:
[    1.288683] 1    0    0   0   0    0    0    00
[    1.289069] 0    0    0   0   0    1    1    31
[    1.289464] 0    0    0   0   0    1    1    30
[    1.289854] 0    0    0   0   0    1    1    33
[    1.290266] 1    0    0   0   0    1    1    34
[    1.290654] 1    1    0   0   0    1    1    35
[    1.291040] 0    0    0   0   0    1    1    36
[    1.291434] 0    0    0   0   0    1    1    37
[    1.291819] 0    0    0   0   0    1    1    38
[    1.292212] 0    1    0   0   0    1    1    39
[    1.292600] 1    1    0   0   0    1    1    3A
[    1.293020] 1    1    0   0   0    1    1    3B
[    1.293450] 0    0    0   0   0    1    1    3C
[    1.293840] 0    0    0   0   0    1    1    3D
[    1.294239] 0    0    0   0   0    1    1    3E
[    1.294623] 0    0    0   0   0    1    1    3F
[    1.295005] 1    0    0   0   0    0    0    00
[    1.295462] 1    0    0   0   0    0    0    00
[    1.295848] 1    0    0   0   0    0    0    00
[    1.296244] 1    0    0   0   0    0    0    00
[    1.296634] 1    0    0   0   0    0    0    00
[    1.297039] 1    0    0   0   0    0    0    00
[    1.297435] 1    0    0   0   0    0    0    00
[    1.297820] 1    0    0   0   0    0    0    00
[    1.298203] IRQ to pin mappings:
[    1.298475] IRQ0 -> 0:2
[    1.298711] IRQ1 -> 0:1
[    1.298943] IRQ3 -> 0:3
[    1.299184] IRQ4 -> 0:4
[    1.299447] IRQ5 -> 0:5
[    1.299681] IRQ6 -> 0:6
[    1.299915] IRQ7 -> 0:7
[    1.300174] IRQ8 -> 0:8
[    1.300408] IRQ9 -> 0:9
[    1.300643] IRQ10 -> 0:10
[    1.300892] IRQ11 -> 0:11
[    1.301144] IRQ12 -> 0:12
[    1.301394] IRQ13 -> 0:13
[    1.301643] IRQ14 -> 0:14
[    1.301891] IRQ15 -> 0:15
[    1.302144] .................................... done.
[    1.302574] Using IPI No-Shortcut mode
[    1.303222] Loading compiled-in X.509 certificates
[    1.306389] Loaded X.509 cert 'Magrathea: Glacier signing key: 1bf58c4=
d9c6a09aa77ec8b2a703e1061ab4380fb'
[    1.308668] Key type encrypted registered
[    1.309807] evm: HMAC attrs: 0x0
[    1.311772] Freeing unused kernel memory: 424K (79650000 - 796ba000)
[    1.319415] random: init urandom read with 0 bits of entropy available=

[    1.322727] BUG: sleeping function called from invalid context at incl=
ude/linux/highmem.h:58
[    1.323637] in_atomic(): 0, irqs_disabled(): 0, pid: 91, name: rc.loca=
l
[    1.324200] 1 lock held by rc.local/91:
[    1.324514]  #0:  (rcu_read_lock){......}, at: [<790ca709>] rcu_read_l=
ock+0x0/0x70
[    1.325199] Preemption disabled at:[<79063d3c>] console_unlock+0x37e/0=
x3d2
[    1.325774]=20
[    1.325940] CPU: 0 PID: 91 Comm: rc.local Not tainted 3.16.0-rc4-00160=
-g25c305d #204
[    1.326610] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.327098]  00000000 00000000 849adb5c 793b1aa6 00000000 849adb88 790=
4b1b2 795b42cc
[    1.327827]  79063d3c 79063d3c 0000005b 8499c3d0 00000000 8a53bd80 89c=
c5830 849adbac
[    1.328584]  849adba4 790caeda 00000000 00000000 849adca0 00000003 000=
00000 849adbb4
[    1.329309] Call Trace:
[    1.329521]  [<793b1aa6>] dump_stack+0x49/0x73
[    1.329884]  [<7904b1b2>] __might_sleep+0x1d1/0x1d9
[    1.330302]  [<79063d3c>] ? console_unlock+0x37e/0x3d2
[    1.330723]  [<79063d3c>] ? console_unlock+0x37e/0x3d2
[    1.331144]  [<790caeda>] page_getlink.isra.31.constprop.47+0x78/0xbc
[    1.331666]  [<790caf40>] page_follow_link_light+0x22/0x30
[    1.332146]  [<790cb846>] link_path_walk+0x30b/0x524
[    1.332564]  [<790caf1e>] ? page_getlink.isra.31.constprop.47+0xbc/0xb=
c
[    1.332566]  [<790cbaad>] path_lookupat+0x4e/0x3e9
[    1.332571]  [<7905bb4e>] ? find_usage_backwards+0x62/0x69
[    1.332573]  [<7905c72f>] ? mark_lock+0x1e/0x217
[    1.332575]  [<790cbe67>] filename_lookup.isra.34+0x1f/0x54
[    1.332577]  [<790cbeca>] do_path_lookup+0x2e/0x36
[    1.332580]  [<790cbeef>] kern_path+0x1d/0x32
[    1.332585]  [<790b8d9f>] ? virt_to_head_page+0x8/0x49
[    1.332587]  [<790b94ab>] ? ksize+0x13/0x1e
[    1.332593]  [<79384cad>] ? __alloc_skb+0x80/0x154
[    1.332599]  [<793a828d>] unix_find_other.isra.30+0x27/0x160
[    1.332605]  [<79381e3f>] ? sock_wmalloc+0x53/0x5e
[    1.332606]  [<793a966f>] unix_stream_connect+0xd8/0x37a
[    1.332608]  [<7937f4b0>] SYSC_connect+0x7e/0xb4
[    1.332616]  [<791c466c>] ? _copy_from_user+0x35/0x49
[    1.332618]  [<7937fcf0>] SYSC_socketcall+0xba/0x3de
[    1.332620]  [<7905ef9f>] ? lock_release+0x151/0x195
[    1.332623]  [<793b97d6>] ? _raw_spin_unlock+0x27/0x39
[    1.332625]  [<790ab27b>] ? do_read_fault.isra.85+0x23c/0x246
[    1.332628]  [<7905ef9f>] ? lock_release+0x151/0x195
[    1.332630]  [<7904b099>] ? __might_sleep+0xb8/0x1d9
[    1.332631]  [<7905aa8c>] ? up_read+0x1d/0x20
[    1.332634]  [<790276f0>] ? __do_page_fault+0x35a/0x3d0
[    1.332636]  [<790aa047>] ? might_fault+0x92/0x98
[    1.332638]  [<793ba2cb>] ? restore_all+0xf/0xf
[    1.332642]  [<791d6677>] ? __this_cpu_preempt_check+0xf/0x11
[    1.332643]  [<79027780>] ? do_page_fault+0x1a/0x1e
[    1.332645]  [<79380045>] SyS_socketcall+0xe/0x10
[    1.332647]  [<793ba292>] syscall_call+0x7/0xb
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[    2.136803] tsc: Refined TSC clocksource calibration: 2693.503 MHz

Elapsed time: 5
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/i=
386-randconfig-r0-0721/25c305debfd676aa495137ca1eec21fce15198e7/vmlinuz-3=
=2E16.0-rc4-00160-g25c305d -append 'hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-r0-0721/a=
k:scale:rcu-symlink:25c305debfd676aa495137ca1eec21fce15198e7:bisect-linux=
8/.vmlinuz-25c305debfd676aa495137ca1eec21fce15198e7-20140721042303-5-kbui=
ld branch=3Dak/scale/rcu-symlink BOOT_IMAGE=3D/kernel/i386-randconfig-r0-=
0721/25c305debfd676aa495137ca1eec21fce15198e7/vmlinuz-3.16.0-rc4-00160-g2=
5c305d drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-core-i=
386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 =
-boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pid=
file /dev/shm/kboot/pid-quantal-kbuild-11 -serial file:/dev/shm/kboot/ser=
ial-quantal-kbuild-11 -daemonize -display none -monitor null=20


--------------010803070609060701020401
Content-Type: application/octet-stream;
 name="i386-randconfig-r0-0721-c0902b93f0f427427f6cb75cb5074288f8001d5d-BUG:-sleeping-function-called-from-invalid-context-at-43083.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="i386-randconfig-r0-0721-c0902b93f0f427427f6cb75cb5074288f800";
 filename*1="1d5d-BUG:-sleeping-function-called-from-invalid-context-at-4";
 filename*2="3083.log"

SEVBRCBpcyBub3cgYXQgYzA5MDJiOS4uLiBmaXh1cCEgeGZzOiBBZGQgUkNVIGZhc3Qgc3lt
bGluayBwYXRoCmdpdCBjaGVja291dCA2YjQ1OGFjMTk1YzUxNzkwODMwYjIyNjdiZGYzZWRh
YWUyN2VhYjNlCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctcjAtMDcyMS9hazpzY2FsZTpyY3Utc3ltbGluazo2YjQ1OGFjMTk1YzUxNzkwODMw
YjIyNjdiZGYzZWRhYWUyN2VhYjNlOmJpc2VjdC1saW51eDgKCjIwMTQtMDctMjEtMDQ6MTY6
MDMgNmI0NThhYzE5NWM1MTc5MDgzMGIyMjY3YmRmM2VkYWFlMjdlYWIzZSBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJh
bmRjb25maWctcjAtMDcyMS02YjQ1OGFjMTk1YzUxNzkwODMwYjIyNjdiZGYzZWRhYWUyN2Vh
YjNlCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDcy
MS82YjQ1OGFjMTk1YzUxNzkwODMwYjIyNjdiZGYzZWRhYWUyN2VhYjNlCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctcjAtMDcyMS02YjQ1OGFjMTk1YzUxNzkwODMwYjIyNjdiZGYzZWRhYWUyN2VhYjNlCmtl
cm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDcyMS82YjQ1OGFjMTk1YzUxNzkw
ODMwYjIyNjdiZGYzZWRhYWUyN2VhYjNlL3ZtbGludXotMy4xNi4wLXJjNC0wMDE1My1nNmI0
NThhYwoKMjAxNC0wNy0yMS0wNDoxOTowMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uCTYJ
MTgJMTkJMjAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCA2YjQ1OGFjMTk1YzUxNzkw
ODMwYjIyNjdiZGYzZWRhYWUyN2VhYjNlCmdpdCBiaXNlY3Qgc3RhcnQgYzA5MDJiOTNmMGY0
Mjc0MjdmNmNiNzVjYjUwNzQyODhmODAwMWQ1ZCA2YjQ1OGFjMTk1YzUxNzkwODMwYjIyNjdi
ZGYzZWRhYWUyN2VhYjNlIC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1i
IiwgImMwOTAyYjkzZjBmNDI3NDI3ZjZjYjc1Y2I1MDc0Mjg4ZjgwMDFkNWQiLCAiLWciLCAi
NmI0NThhYzE5NWM1MTc5MDgzMGIyMjY3YmRmM2VkYWFlMjdlYWIzZSIsICIvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9jL2Jvb3QtYmlzZWN0L2xp
bnV4OC9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAxNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzI1YzMwNWRlYmZkNjc2YWE0OTUxMzdj
YTFlZWMyMWZjZTE1MTk4ZTddIFRyZWUgc3dlZXA6IE1hcmsgYWxsIHBhZ2VfZm9sbG93X2xp
bmtfbGlnaHQgdXNlcnMgYXMgUkNVIHNhZmUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4OC9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
cjAtMDcyMS9hazpzY2FsZTpyY3Utc3ltbGluazoyNWMzMDVkZWJmZDY3NmFhNDk1MTM3Y2Ex
ZWVjMjFmY2UxNTE5OGU3OmJpc2VjdC1saW51eDgKCjIwMTQtMDctMjEtMDQ6MjM6MDMgMjVj
MzA1ZGViZmQ2NzZhYTQ5NTEzN2NhMWVlYzIxZmNlMTUxOThlNyByZXVzZSAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMC0wNzIxLzI1YzMwNWRlYmZkNjc2YWE0OTUxMzdjYTFlZWMyMWZj
ZTE1MTk4ZTcvdm1saW51ei0zLjE2LjAtcmM0LTAwMTYwLWcyNWMzMDVkCgoyMDE0LTA3LTIx
LTA0OjIzOjAzIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgMS4z
MDk4MDddIGV2bTogSE1BQyBhdHRyczogMHgwClsgICAgMS4zMTE3NzJdIEZyZWVpbmcgdW51
c2VkIGtlcm5lbCBtZW1vcnk6IDQyNEsgKDc5NjUwMDAwIC0gNzk2YmEwMDApClsgICAgMS4z
MTk0MTVdIHJhbmRvbTogaW5pdCB1cmFuZG9tIHJlYWQgd2l0aCAwIGJpdHMgb2YgZW50cm9w
eSBhdmFpbGFibGUKWyAgICAxLjMyMjcyN10gQlVHOiBzbGVlcGluZyBmdW5jdGlvbiBjYWxs
ZWQgZnJvbSBpbnZhbGlkIGNvbnRleHQgYXQgL2tidWlsZC9zcmMvaTM4Ni9pbmNsdWRlL2xp
bnV4L2hpZ2htZW0uaDo1OApbICAgIDEuMzIzNjM3XSBpbl9hdG9taWMoKTogMCwgaXJxc19k
aXNhYmxlZCgpOiAwLCBwaWQ6IDkxLCBuYW1lOiByYy5sb2NhbApbICAgIDEuMzI0MjAwXSAx
IGxvY2sgaGVsZCBieSByYy5sb2NhbC85MToKWyAgICAxLjMyNDUxNF0gICMwOiAgKHJjdV9y
ZWFkX2xvY2spey4uLi4uLn0sIGF0OiBbPDc5MGNhNzA5Pl0gcmN1X3JlYWRfbG9jaysweDAv
MHg3MApbICAgIDEuMzI1MTk5XSBQcmVlbXB0aW9uIGRpc2FibGVkIGF0Ols8NzkwNjNkM2M+
XSBjb25zb2xlX3VubG9jaysweDM3ZS8weDNkMgpbICAgIDEuMzI1Nzc0XSAKWyAgICAxLjMy
NTk0MF0gQ1BVOiAwIFBJRDogOTEgQ29tbTogcmMubG9jYWwgTm90IHRhaW50ZWQgMy4xNi4w
LXJjNC0wMDE2MC1nMjVjMzA1ZCAjMjA0ClsgICAgMS4zMjY2MTBdIEhhcmR3YXJlIG5hbWU6
IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAxLjMyNzA5OF0gIDAw
MDAwMDAwIDAwMDAwMDAwIDg0OWFkYjVjIDc5M2IxYWE2IDAwMDAwMDAwIDg0OWFkYjg4IDc5
MDRiMWIyIDc5NWI0MmNjClsgICAgMS4zMjc4MjddICA3OTA2M2QzYyA3OTA2M2QzYyAwMDAw
MDA1YiA4NDk5YzNkMCAwMDAwMDAwMCA4YTUzYmQ4MCA4OWNjNTgzMCA4NDlhZGJhYwpbICAg
IDEuMzI4NTg0XSAgODQ5YWRiYTQgNzkwY2FlZGEgMDAwMDAwMDAgMDAwMDAwMDAgODQ5YWRj
YTAgMDAwMDAwMDMgMDAwMDAwMDAgODQ5YWRiYjQKWyAgICAxLjMyOTMwOV0gQ2FsbCBUcmFj
ZToKWyAgICAxLjMyOTUyMV0gIFs8NzkzYjFhYTY+XSBkdW1wX3N0YWNrKzB4NDkvMHg3Mwpb
ICAgIDEuMzI5ODg0XSAgWzw3OTA0YjFiMj5dIF9fbWlnaHRfc2xlZXArMHgxZDEvMHgxZDkK
WyAgICAxLjMzMDMwMl0gIFs8NzkwNjNkM2M+XSA/IGNvbnNvbGVfdW5sb2NrKzB4MzdlLzB4
M2QyClsgICAgMS4zMzA3MjNdICBbPDc5MDYzZDNjPl0gPyBjb25zb2xlX3VubG9jaysweDM3
ZS8weDNkMgpbICAgIDEuMzMxMTQ0XSAgWzw3OTBjYWVkYT5dIHBhZ2VfZ2V0bGluay5pc3Jh
LjMxLmNvbnN0cHJvcC40NysweDc4LzB4YmMKWyAgICAxLjMzMTY2Nl0gIFs8NzkwY2FmNDA+
XSBwYWdlX2ZvbGxvd19saW5rX2xpZ2h0KzB4MjIvMHgzMApbICAgIDEuMzMyMTQ2XSAgWzw3
OTBjYjg0Nj5dIGxpbmtfcGF0aF93YWxrKzB4MzBiLzB4NTI0ClsgICAgMS4zMzI1NjRdICBb
PDc5MGNhZjFlPl0gPyBwYWdlX2dldGxpbmsuaXNyYS4zMS5jb25zdHByb3AuNDcrMHhiYy8w
eGJjClsgICAgMS4zMzI1NjZdICBbPDc5MGNiYWFkPl0gcGF0aF9sb29rdXBhdCsweDRlLzB4
M2U5ClsgICAgMS4zMzI1NzFdICBbPDc5MDViYjRlPl0gPyBmaW5kX3VzYWdlX2JhY2t3YXJk
cysweDYyLzB4NjkKWyAgICAxLjMzMjU3M10gIFs8NzkwNWM3MmY+XSA/IG1hcmtfbG9jaysw
eDFlLzB4MjE3ClsgICAgMS4zMzI1NzVdICBbPDc5MGNiZTY3Pl0gZmlsZW5hbWVfbG9va3Vw
LmlzcmEuMzQrMHgxZi8weDU0ClsgICAgMS4zMzI1NzddICBbPDc5MGNiZWNhPl0gZG9fcGF0
aF9sb29rdXArMHgyZS8weDM2ClsgICAgMS4zMzI1ODBdICBbPDc5MGNiZWVmPl0ga2Vybl9w
YXRoKzB4MWQvMHgzMgpbICAgIDEuMzMyNTg1XSAgWzw3OTBiOGQ5Zj5dID8gdmlydF90b19o
ZWFkX3BhZ2UrMHg4LzB4NDkKWyAgICAxLjMzMjU4N10gIFs8NzkwYjk0YWI+XSA/IGtzaXpl
KzB4MTMvMHgxZQpbICAgIDEuMzMyNTkzXSAgWzw3OTM4NGNhZD5dID8gX19hbGxvY19za2Ir
MHg4MC8weDE1NApbICAgIDEuMzMyNTk5XSAgWzw3OTNhODI4ZD5dIHVuaXhfZmluZF9vdGhl
ci5pc3JhLjMwKzB4MjcvMHgxNjAKWyAgICAxLjMzMjYwNV0gIFs8NzkzODFlM2Y+XSA/IHNv
Y2tfd21hbGxvYysweDUzLzB4NWUKWyAgICAxLjMzMjYwNl0gIFs8NzkzYTk2NmY+XSB1bml4
X3N0cmVhbV9jb25uZWN0KzB4ZDgvMHgzN2EKWyAgICAxLjMzMjYwOF0gIFs8NzkzN2Y0YjA+
XSBTWVNDX2Nvbm5lY3QrMHg3ZS8weGI0ClsgICAgMS4zMzI2MTZdICBbPDc5MWM0NjZjPl0g
PyBfY29weV9mcm9tX3VzZXIrMHgzNS8weDQ5ClsgICAgMS4zMzI2MThdICBbPDc5MzdmY2Yw
Pl0gU1lTQ19zb2NrZXRjYWxsKzB4YmEvMHgzZGUKWyAgICAxLjMzMjYyMF0gIFs8NzkwNWVm
OWY+XSA/IGxvY2tfcmVsZWFzZSsweDE1MS8weDE5NQpbICAgIDEuMzMyNjIzXSAgWzw3OTNi
OTdkNj5dID8gX3Jhd19zcGluX3VubG9jaysweDI3LzB4MzkKWyAgICAxLjMzMjYyNV0gIFs8
NzkwYWIyN2I+XSA/IGRvX3JlYWRfZmF1bHQuaXNyYS44NSsweDIzYy8weDI0NgpbICAgIDEu
MzMyNjI4XSAgWzw3OTA1ZWY5Zj5dID8gbG9ja19yZWxlYXNlKzB4MTUxLzB4MTk1ClsgICAg
MS4zMzI2MzBdICBbPDc5MDRiMDk5Pl0gPyBfX21pZ2h0X3NsZWVwKzB4YjgvMHgxZDkKWyAg
ICAxLjMzMjYzMV0gIFs8NzkwNWFhOGM+XSA/IHVwX3JlYWQrMHgxZC8weDIwClsgICAgMS4z
MzI2MzRdICBbPDc5MDI3NmYwPl0gPyBfX2RvX3BhZ2VfZmF1bHQrMHgzNWEvMHgzZDAKWyAg
ICAxLjMzMjYzNl0gIFs8NzkwYWEwNDc+XSA/IG1pZ2h0X2ZhdWx0KzB4OTIvMHg5OApbICAg
IDEuMzMyNjM4XSAgWzw3OTNiYTJjYj5dID8gcmVzdG9yZV9hbGwrMHhmLzB4ZgpbICAgIDEu
MzMyNjQyXSAgWzw3OTFkNjY3Nz5dID8gX190aGlzX2NwdV9wcmVlbXB0X2NoZWNrKzB4Zi8w
eDExClsgICAgMS4zMzI2NDNdICBbPDc5MDI3NzgwPl0gPyBkb19wYWdlX2ZhdWx0KzB4MWEv
MHgxZQpbICAgIDEuMzMyNjQ1XSAgWzw3OTM4MDA0NT5dIFN5U19zb2NrZXRjYWxsKzB4ZS8w
eDEwClsgICAgMS4zMzI2NDddICBbPDc5M2JhMjkyPl0gc3lzY2FsbF9jYWxsKzB4Ny8weGIK
L2Jpbi9zaDogL3Byb2Mvc2VsZi9mZC85OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Ci9i
aW4vc2g6IC9wcm9jL3NlbGYvZmQvOTogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQovYmlu
L3NoOiAvcHJvYy9zZWxmL2ZkLzk6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctcjAtMDcyMS8yNWMzMDVkZWJmZDY3NmFhNDk1MTM3Y2ExZWVj
MjFmY2UxNTE5OGU3L2RtZXNnLXF1YW50YWwta2J1aWxkLTExOjIwMTQwNzIxMDQyMTM5Omkz
ODYtcmFuZGNvbmZpZy1yMC0wNzIxOjMuMTYuMC1yYzQtMDAxNjAtZzI1YzMwNWQ6MjA0Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEvMjVjMzA1ZGViZmQ2NzZhYTQ5NTEzN2Nh
MWVlYzIxZmNlMTUxOThlNy9kbWVzZy1xdWFudGFsLWtidWlsZC0xNDoyMDE0MDcyMTA0MjEz
NzppMzg2LXJhbmRjb25maWctcjAtMDcyMTozLjE2LjAtcmM0LTAwMTYwLWcyNWMzMDVkOjIw
NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wNzIxLzI1YzMwNWRlYmZkNjc2YWE0OTUx
MzdjYTFlZWMyMWZjZTE1MTk4ZTcvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTc6MjAxNDA3MjEw
NDIxMzk6aTM4Ni1yYW5kY29uZmlnLXIwLTA3MjE6My4xNi4wLXJjNC0wMDE2MC1nMjVjMzA1
ZDoyMDQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDcyMS8yNWMzMDVkZWJmZDY3NmFh
NDk1MTM3Y2ExZWVjMjFmY2UxNTE5OGU3L2RtZXNnLXF1YW50YWwta2J1aWxkLTIxOjIwMTQw
NzIxMDQyMTM2OmkzODYtcmFuZGNvbmZpZy1yMC0wNzIxOjMuMTYuMC1yYzQtMDAxNjAtZzI1
YzMwNWQ6MjA0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEvMjVjMzA1ZGViZmQ2
NzZhYTQ5NTEzN2NhMWVlYzIxZmNlMTUxOThlNy9kbWVzZy1xdWFudGFsLWtidWlsZC0yNDoy
MDE0MDcyMTA0MjEzOTppMzg2LXJhbmRjb25maWctcjAtMDcyMTozLjE2LjAtcmM0LTAwMTYw
LWcyNWMzMDVkOjIwNAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wNzIxLzI1YzMwNWRl
YmZkNjc2YWE0OTUxMzdjYTFlZWMyMWZjZTE1MTk4ZTcvZG1lc2ctcXVhbnRhbC1rYnVpbGQt
MjU6MjAxNDA3MjEwNDIxMzc6aTM4Ni1yYW5kY29uZmlnLXIwLTA3MjE6My4xNi4wLXJjNC0w
MDE2MC1nMjVjMzA1ZDoyMDQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDcyMS8yNWMz
MDVkZWJmZDY3NmFhNDk1MTM3Y2ExZWVjMjFmY2UxNTE5OGU3L2RtZXNnLXF1YW50YWwta2J1
aWxkLTI3OjIwMTQwNzIxMDQyMTM5OmkzODYtcmFuZGNvbmZpZy1yMC0wNzIxOjMuMTYuMC1y
YzQtMDAxNjAtZzI1YzMwNWQ6MjA0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEv
MjVjMzA1ZGViZmQ2NzZhYTQ5NTEzN2NhMWVlYzIxZmNlMTUxOThlNy9kbWVzZy1xdWFudGFs
LWtidWlsZC0yOToyMDE0MDcyMTA0MjEzMjppMzg2LXJhbmRjb25maWctcjAtMDcyMTozLjE2
LjAtcmM0LTAwMTYwLWcyNWMzMDVkOjIwNAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0w
NzIxLzI1YzMwNWRlYmZkNjc2YWE0OTUxMzdjYTFlZWMyMWZjZTE1MTk4ZTcvZG1lc2ctcXVh
bnRhbC1rYnVpbGQtMjoyMDE0MDcyMTA0MjEzNjppMzg2LXJhbmRjb25maWctcjAtMDcyMToz
LjE2LjAtcmM0LTAwMTYwLWcyNWMzMDVkOjIwNAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1y
MC0wNzIxLzI1YzMwNWRlYmZkNjc2YWE0OTUxMzdjYTFlZWMyMWZjZTE1MTk4ZTcvZG1lc2ct
cXVhbnRhbC1rYnVpbGQtMzA6MjAxNDA3MjEwNDIxMzk6aTM4Ni1yYW5kY29uZmlnLXIwLTA3
MjE6My4xNi4wLXJjNC0wMDE2MC1nMjVjMzA1ZDoyMDQKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjAtMDcyMS8yNWMzMDVkZWJmZDY3NmFhNDk1MTM3Y2ExZWVjMjFmY2UxNTE5OGU3L2Rt
ZXNnLXlvY3RvLWtidWlsZC0xMDoyMDE0MDcyMTA0MjEzODppMzg2LXJhbmRjb25maWctcjAt
MDcyMTozLjE2LjAtcmM0LTAwMTYwLWcyNWMzMDVkOjIwNAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yMC0wNzIxLzI1YzMwNWRlYmZkNjc2YWE0OTUxMzdjYTFlZWMyMWZjZTE1MTk4ZTcv
ZG1lc2cteW9jdG8ta2J1aWxkLTExOjIwMTQwNzIxMDQyMTM4OmkzODYtcmFuZGNvbmZpZy1y
MC0wNzIxOjMuMTYuMC1yYzQtMDAxNjAtZzI1YzMwNWQ6MjA0Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXIwLTA3MjEvMjVjMzA1ZGViZmQ2NzZhYTQ5NTEzN2NhMWVlYzIxZmNlMTUxOThl
Ny9kbWVzZy15b2N0by1rYnVpbGQtMTI6MjAxNDA3MjEwNDIxMzc6aTM4Ni1yYW5kY29uZmln
LXIwLTA3MjE6My4xNi4wLXJjNC0wMDE2MC1nMjVjMzA1ZDoyMDQKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjAtMDcyMS8yNWMzMDVkZWJmZDY3NmFhNDk1MTM3Y2ExZWVjMjFmY2UxNTE5
OGU3L2RtZXNnLXlvY3RvLWtidWlsZC0xNjoyMDE0MDcyMTA0MjEzNjppMzg2LXJhbmRjb25m
aWctcjAtMDcyMTozLjE2LjAtcmM0LTAwMTYwLWcyNWMzMDVkOjIwNAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yMC0wNzIxLzI1YzMwNWRlYmZkNjc2YWE0OTUxMzdjYTFlZWMyMWZjZTE1
MTk4ZTcvZG1lc2cteW9jdG8ta2J1aWxkLTE6MjAxNDA3MjEwNDIxMzY6aTM4Ni1yYW5kY29u
ZmlnLXIwLTA3MjE6My4xNi4wLXJjNC0wMDE2MC1nMjVjMzA1ZDoyMDQKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctcjAtMDcyMS8yNWMzMDVkZWJmZDY3NmFhNDk1MTM3Y2ExZWVjMjFmY2Ux
NTE5OGU3L2RtZXNnLXlvY3RvLWtidWlsZC0yMDoyMDE0MDcyMTA0MjEzNjppMzg2LXJhbmRj
b25maWctcjAtMDcyMTozLjE2LjAtcmM0LTAwMTYwLWcyNWMzMDVkOjIwNAova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMC0wNzIxLzI1YzMwNWRlYmZkNjc2YWE0OTUxMzdjYTFlZWMyMWZj
ZTE1MTk4ZTcvZG1lc2cteW9jdG8ta2J1aWxkLTI5OjIwMTQwNzIxMDQyMTMyOmkzODYtcmFu
ZGNvbmZpZy1yMC0wNzIxOjMuMTYuMC1yYzQtMDAxNjAtZzI1YzMwNWQ6MjA0Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEvMjVjMzA1ZGViZmQ2NzZhYTQ5NTEzN2NhMWVlYzIx
ZmNlMTUxOThlNy9kbWVzZy15b2N0by1rYnVpbGQtMzA6MjAxNDA3MjEwNDIxMzk6aTM4Ni1y
YW5kY29uZmlnLXIwLTA3MjE6My4xNi4wLXJjNC0wMDE2MC1nMjVjMzA1ZDoyMDQKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctcjAtMDcyMS8yNWMzMDVkZWJmZDY3NmFhNDk1MTM3Y2ExZWVj
MjFmY2UxNTE5OGU3L2RtZXNnLXF1YW50YWwta2J1aWxkLTE2OjIwMTQwNzIxMDQyMTQyOmkz
ODYtcmFuZGNvbmZpZy1yMC0wNzIxOjMuMTYuMC1yYzQtMDAxNjAtZzI1YzMwNWQ6MjA0Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEvMjVjMzA1ZGViZmQ2NzZhYTQ5NTEzN2Nh
MWVlYzIxZmNlMTUxOThlNy9kbWVzZy1xdWFudGFsLWtidWlsZC0zOjIwMTQwNzIxMDQyMTQx
OmkzODYtcmFuZGNvbmZpZy1yMC0wNzIxOjMuMTYuMC1yYzQtMDAxNjAtZzI1YzMwNWQ6MjA0
CjA6MjA6MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMjEg
MDQ6MjM6MzQgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJpc2VjdC9saW51eDgvb2Jq
LWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA3IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbMDcwNzZjZmY3NmJhNWRmYWYzYzBl
NzAyOGRmNWUyZGQ0N2NmMjQwZF0gdmZzOiBBZGQgZm9sbG93X2xpbmtfcmN1IHRvIGlub2Rl
X29wcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2MvYm9vdC1iaXNlY3QvbGludXg4L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMC0wNzIxL2FrOnNjYWxlOnJjdS1z
eW1saW5rOjA3MDc2Y2ZmNzZiYTVkZmFmM2MwZTcwMjhkZjVlMmRkNDdjZjI0MGQ6YmlzZWN0
LWxpbnV4OAoKMjAxNC0wNy0yMS0wNDoyMzozNSAwNzA3NmNmZjc2YmE1ZGZhZjNjMGU3MDI4
ZGY1ZTJkZDQ3Y2YyNDBkIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEv
MDcwNzZjZmY3NmJhNWRmYWYzYzBlNzAyOGRmNWUyZGQ0N2NmMjQwZC92bWxpbnV6LTMuMTYu
MC1yYzQtMDAxNTYtZzA3MDc2Y2YKCjIwMTQtMDctMjEtMDQ6MjM6MzUgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4JMTkJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0IHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbZWUxNzY1MTEyYjk0NWYx
M2ZkYWM0MzBkNjc3NjIxYTIwMjA3ZDU5M10gdmZzOiBVcGRhdGUgcGF0aC1sb29rdXAudHh0
IGZvciBSQ1Ugc3ltbGluayB3YWxraW5nCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDgvb2JqLWJpc2Vj
dApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIw
LTA3MjEvYWs6c2NhbGU6cmN1LXN5bWxpbms6ZWUxNzY1MTEyYjk0NWYxM2ZkYWM0MzBkNjc3
NjIxYTIwMjA3ZDU5MzpiaXNlY3QtbGludXg4CgoyMDE0LTA3LTIxLTA0OjI1OjM1IGVlMTc2
NTExMmI5NDVmMTNmZGFjNDMwZDY3NzYyMWEyMDIwN2Q1OTMgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LXIwLTA3MjEtZWUxNzY1MTEyYjk0NWYxM2ZkYWM0MzBkNjc3NjIxYTIwMjA3ZDU5MwpDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEvZWUxNzY1
MTEyYjk0NWYxM2ZkYWM0MzBkNjc3NjIxYTIwMjA3ZDU5Mwp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIwLTA3
MjEtZWUxNzY1MTEyYjk0NWYxM2ZkYWM0MzBkNjc3NjIxYTIwMjA3ZDU5MwprZXJuZWw6IC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEvZWUxNzY1MTEyYjk0NWYxM2ZkYWM0MzBk
Njc3NjIxYTIwMjA3ZDU5My92bWxpbnV6LTMuMTYuMC1yYzQtMDAxNTgtZ2VlMTc2NTEKCjIw
MTQtMDctMjEtMDQ6Mjc6MzUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTE3CTIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMiBzdGVwcykKWzg2ODY1NmQ0MzIzNzJmYzk1ZTU3ZWM3YmNkMGFjMTdiMDczNGM4MDZd
IHZmczogTWFrZSBwYWdlX2ZvbGxvd19saW5rX2xpZ2h0IFJDVSBzYWZlCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2Vj
dC9saW51eDgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEvYWs6c2NhbGU6cmN1LXN5bWxpbms6ODY4NjU2ZDQz
MjM3MmZjOTVlNTdlYzdiY2QwYWMxN2IwNzM0YzgwNjpiaXNlY3QtbGludXg4CgoyMDE0LTA3
LTIxLTA0OjI4OjM2IDg2ODY1NmQ0MzIzNzJmYzk1ZTU3ZWM3YmNkMGFjMTdiMDczNGM4MDYg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEtODY4NjU2ZDQzMjM3MmZjOTVlNTdlYzdiY2Qw
YWMxN2IwNzM0YzgwNgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXIwLTA3MjEvODY4NjU2ZDQzMjM3MmZjOTVlNTdlYzdiY2QwYWMxN2IwNzM0YzgwNgp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLXIwLTA3MjEtODY4NjU2ZDQzMjM3MmZjOTVlNTdlYzdiY2QwYWMxN2Iw
NzM0YzgwNgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEvODY4NjU2
ZDQzMjM3MmZjOTVlNTdlYzdiY2QwYWMxN2IwNzM0YzgwNi92bWxpbnV6LTMuMTYuMC1yYzQt
MDAxNTktZzg2ODY1NmQKCjIwMTQtMDctMjEtMDQ6MzA6MzYgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgCTIwIFNVQ0NFU1MKCjI1YzMwNWRlYmZkNjc2YWE0OTUxMzdjYTFlZWMyMWZjZTE1MTk4
ZTcgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDI1YzMwNWRlYmZkNjc2YWE0OTUx
MzdjYTFlZWMyMWZjZTE1MTk4ZTcKQXV0aG9yOiAgICAgQW5kaSBLbGVlbiA8YWtAbGludXgu
aW50ZWwuY29tPgpBdXRob3JEYXRlOiBTYXQgSnVsIDEyIDIyOjQ2OjI0IDIwMTQgLTA3MDAK
Q29tbWl0OiAgICAgQW5kaSBLbGVlbiA8YWtAbGludXguaW50ZWwuY29tPgpDb21taXREYXRl
OiBTdW4gSnVsIDIwIDA5OjQzOjMyIDIwMTQgLTA3MDAKCiAgICBUcmVlIHN3ZWVwOiBNYXJr
IGFsbCBwYWdlX2ZvbGxvd19saW5rX2xpZ2h0IHVzZXJzIGFzIFJDVSBzYWZlCiAgICAKICAg
IE5vdyB0aGF0IHBhZ2VfZm9sbG93X2xpbmtfbGlnaHQoKSBpcyBSQ1Ugc2FmZSwgbWFyayBh
bGwKICAgIHVzZXJzIGFzIHN1cHBvcnRpbmcgUkNVIGJ5IHVzaW5nIHRoZSBmb2xsb3dfbGlu
a19yY3UKICAgIGVudHJ5IHBvaW50LgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBBbmRpIEts
ZWVuIDxha0BsaW51eC5pbnRlbC5jb20+CgogZnMvYWZmcy9zeW1saW5rLmMgICAgIHwgMiAr
LQogZnMvYnRyZnMvaW5vZGUuYyAgICAgIHwgMiArLQogZnMvY29kYS9jbm9kZS5jICAgICAg
IHwgMiArLQogZnMvZXhvZnMvc3ltbGluay5jICAgIHwgMiArLQogZnMvZXh0Mi9zeW1saW5r
LmMgICAgIHwgMiArLQogZnMvZXh0My9zeW1saW5rLmMgICAgIHwgMiArLQogZnMvZXh0NC9z
eW1saW5rLmMgICAgIHwgMiArLQogZnMvZjJmcy9uYW1laS5jICAgICAgIHwgMiArLQogZnMv
amZzL3N5bWxpbmsuYyAgICAgIHwgMiArLQogZnMvbG9nZnMvZGlyLmMgICAgICAgIHwgMiAr
LQogZnMvbWluaXgvaW5vZGUuYyAgICAgIHwgMiArLQogZnMvbmFtZWkuYyAgICAgICAgICAg
IHwgMiArLQogZnMvbmNwZnMvaW5vZGUuYyAgICAgIHwgMiArLQogZnMvbmlsZnMyL25hbWVp
LmMgICAgIHwgMiArLQogZnMvb2NmczIvc3ltbGluay5jICAgIHwgMiArLQogZnMvcmVpc2Vy
ZnMvbmFtZWkuYyAgIHwgMiArLQogZnMvc3F1YXNoZnMvc3ltbGluay5jIHwgMiArLQogZnMv
c3lzdi9pbm9kZS5jICAgICAgIHwgMiArLQogZnMvdWRmL25hbWVpLmMgICAgICAgIHwgMiAr
LQogZnMvdWZzL3N5bWxpbmsuYyAgICAgIHwgNCArKy0tCiAyMCBmaWxlcyBjaGFuZ2VkLCAy
MSBpbnNlcnRpb25zKCspLCAyMSBkZWxldGlvbnMoLSkKSEVBRCBpcyBub3cgYXQgODY4NjU2
ZC4uLiB2ZnM6IE1ha2UgcGFnZV9mb2xsb3dfbGlua19saWdodCBSQ1Ugc2FmZQpscyAtYSAv
a2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIwLTA3MjEvYWs6
c2NhbGU6cmN1LXN5bWxpbms6ODY4NjU2ZDQzMjM3MmZjOTVlNTdlYzdiY2QwYWMxN2IwNzM0
YzgwNjpiaXNlY3QtbGludXg4CgoyMDE0LTA3LTIxLTA0OjMxOjA3IDg2ODY1NmQ0MzIzNzJm
Yzk1ZTU3ZWM3YmNkMGFjMTdiMDczNGM4MDYgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjAtMDcyMS84Njg2NTZkNDMyMzcyZmM5NWU1N2VjN2JjZDBhYzE3YjA3MzRjODA2L3Zt
bGludXotMy4xNi4wLXJjNC0wMDE1OS1nODY4NjU2ZAoKMjAxNC0wNy0yMS0wNDozMTowNyBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMzAJNTguCTYwIFNVQ0NFU1MKClByZXZpb3VzIEhF
QUQgcG9zaXRpb24gd2FzIDg2ODY1NmQuLi4gdmZzOiBNYWtlIHBhZ2VfZm9sbG93X2xpbmtf
bGlnaHQgUkNVIHNhZmUKSEVBRCBpcyBub3cgYXQgYzA5MDJiOS4uLiBmaXh1cCEgeGZzOiBB
ZGQgUkNVIGZhc3Qgc3ltbGluayBwYXRoCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctcjAtMDcyMS9hazpzY2FsZTpyY3Utc3ltbGluazpjMDkw
MmI5M2YwZjQyNzQyN2Y2Y2I3NWNiNTA3NDI4OGY4MDAxZDVkOmJpc2VjdC1saW51eDgKIFRF
U1QgRkFJTFVSRQpbICAgIDAuNTI3MDMzXSBLZXkgdHlwZSBlbmNyeXB0ZWQgcmVnaXN0ZXJl
ZApbICAgIDAuNTI3Njg0XSBldm06IEhNQUMgYXR0cnM6IDB4MApbICAgIDAuNTI5NjY4XSBG
cmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5OiA0MjRLICg3OTY1MDAwMCAtIDc5NmJhMDAw
KQpbICAgIDAuNTM0NDg1XSBCVUc6IHNsZWVwaW5nIGZ1bmN0aW9uIGNhbGxlZCBmcm9tIGlu
dmFsaWQgY29udGV4dCBhdCAva2J1aWxkL3NyYy9pMzg2L2luY2x1ZGUvbGludXgvaGlnaG1l
bS5oOjU4ClsgICAgMC41MzUyNTFdIGluX2F0b21pYygpOiAwLCBpcnFzX2Rpc2FibGVkKCk6
IDAsIHBpZDogODIsIG5hbWU6IGluaXQKWyAgICAwLjUzNTczM10gMSBsb2NrIGhlbGQgYnkg
aW5pdC84MjoKWyAgICAwLjUzNjAwNF0gICMwOiAgKHJjdV9yZWFkX2xvY2spey4uLi4uLn0s
IGF0OiBbPDc5MGNhNzA5Pl0gcmN1X3JlYWRfbG9jaysweDAvMHg3MApbICAgIDAuNTM2NjE0
XSBQcmVlbXB0aW9uIGRpc2FibGVkIGF0Ols8NzkwMjA1Mjk+XSBzbXBfYXBpY190aW1lcl9p
bnRlcnJ1cHQrMHgxYi8weDJmClsgICAgMC41MzcyODBdIApbICAgIDAuNTM3Mzk5XSBDUFU6
IDAgUElEOiA4MiBDb21tOiBpbml0IE5vdCB0YWludGVkIDMuMTYuMC1yYzQtMDAxNjctZ2Mw
OTAyYjkgIzIwNwpbICAgIDAuNTM3OTcwXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2Nocywg
QklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC41MzgzOTBdICAwMDAwMDAwMCAwMDAwMDAw
MCA4YTQ4ZmRjYyA3OTNiMWFlNiAwMDAwMDAwMCA4YTQ4ZmRmOCA3OTA0YjFiMiA3OTViNDJj
YwpbICAgIDAuNTM5MDk4XSAgNzkwMjA1MjkgNzkwMjA1MjkgMDAwMDAwNTIgOGE0OTZkNDAg
MDAwMDAwMDAgOGJhOWM3YzAgOGIwNGQ5YzAgOGE0OGZlMWMKWyAgICAwLjUzOTc1NF0gIDhh
NDhmZTE0IDc5MGNhZWRhIDAwMDAwMDAwIDAwMDAwMDAwIDhhNDhmZWU4IDAwMDAwMDAzIDAw
MDAwMDAwIDhhNDhmZTI0ClsgICAgMC41NDA0MjBdIENhbGwgVHJhY2U6ClsgICAgMC41NDA2
MDhdICBbPDc5M2IxYWU2Pl0gZHVtcF9zdGFjaysweDQ5LzB4NzMKWyAgICAwLjU0MDk0NF0g
IFs8NzkwNGIxYjI+XSBfX21pZ2h0X3NsZWVwKzB4MWQxLzB4MWQ5ClsgICAgMC41NDEzMDNd
ICBbPDc5MDIwNTI5Pl0gPyBzbXBfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgxYi8weDJmClsg
ICAgMC41NDE3MzRdICBbPDc5MDIwNTI5Pl0gPyBzbXBfYXBpY190aW1lcl9pbnRlcnJ1cHQr
MHgxYi8weDJmClsgICAgMC41NDIxNTldICBbPDc5MGNhZWRhPl0gcGFnZV9nZXRsaW5rLmlz
cmEuMzEuY29uc3Rwcm9wLjQ3KzB4NzgvMHhiYwpbICAgIDAuNTQyNjI3XSAgWzw3OTBjYWY0
MD5dIHBhZ2VfZm9sbG93X2xpbmtfbGlnaHQrMHgyMi8weDMwClsgICAgMC41NDMwMzJdICBb
PDc5MGNiODQ2Pl0gbGlua19wYXRoX3dhbGsrMHgzMGIvMHg1MjQKWyAgICAwLjU0MzQxN10g
IFs8NzkwY2FmMWU+XSA/IHBhZ2VfZ2V0bGluay5pc3JhLjMxLmNvbnN0cHJvcC40NysweGJj
LzB4YmMKWyAgICAwLjU0MzkwNV0gIFs8NzkwY2JhYWQ+XSBwYXRoX2xvb2t1cGF0KzB4NGUv
MHgzZTkKWyAgICAwLjU0NDI2M10gIFs8NzkwYjlmZGI+XSA/IGttZW1fY2FjaGVfYWxsb2Mr
MHg3Zi8weDlkClsgICAgMC41NDQ2NDJdICBbPDc5MGNiZTY3Pl0gZmlsZW5hbWVfbG9va3Vw
LmlzcmEuMzQrMHgxZi8weDU0ClsgICAgMC41NDUwNTBdICBbPDc5MGNlNTE2Pl0gdXNlcl9w
YXRoX2F0X2VtcHR5KzB4NDEvMHg2NgpbICAgIDAuNTQ1NDMwXSAgWzw3OTBiOWZkYj5dID8g
a21lbV9jYWNoZV9hbGxvYysweDdmLzB4OWQKWyAgICAwLjU0NTgxMV0gIFs8NzkwNDgzMDI+
XSA/IHByZXBhcmVfY3JlZHMrMHgyZS8weGM3ClsgICAgMC41NDYxNzBdICBbPDc5MGNlNTU1
Pl0gdXNlcl9wYXRoX2F0KzB4MWEvMHgxZgpbICAgIDAuNTQ2NTE0XSAgWzw3OTBjMWVhMT5d
IFNZU0NfZmFjY2Vzc2F0KzB4OTcvMHgxODcKWyAgICAwLjU0Njg5NV0gIFs8NzkzYmEzMGI+
XSA/IHJlc3RvcmVfYWxsKzB4Zi8weGYKWyAgICAwLjU0NzIzMF0gIFs8NzkwMjVlZjg+XSA/
IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHhhMi8weGEyClsgICAgMC41NDc2NDFdICBbPDc5
MGMyNTM3Pl0gU3lTX2FjY2VzcysweDIzLzB4MjUKWyAgICAwLjU0Nzk3NF0gIFs8NzkzYmEy
ZDI+XSBzeXNjYWxsX2NhbGwrMHg3LzB4Ygptb3VudDogbW91bnRpbmcgcHJvYyBvbiAvcHJv
YyBmYWlsZWQ6IE5vIHN1Y2ggZGV2aWNlCi9ldGMvcmNTLmQvUzAwZmJzZXR1cDogbGluZSAz
OiAvc2Jpbi9tb2Rwcm9iZTogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctcjAtMDcyMS9jMDkwMmI5M2YwZjQyNzQyN2Y2Y2I3NWNiNTA3NDI4
OGY4MDAxZDVkL2RtZXNnLXlvY3RvLXZwLTUxOjIwMTQwNzIxMDQxNjA1OmkzODYtcmFuZGNv
bmZpZy1yMC0wNzIxOjMuMTYuMC1yYzQtMDAxNjctZ2MwOTAyYjk6MjA3Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXIwLTA3MjEvYzA5MDJiOTNmMGY0Mjc0MjdmNmNiNzVjYjUwNzQyODhm
ODAwMWQ1ZC9kbWVzZy15b2N0by12cC0zMzoyMDE0MDcyMTAzNDEzMDppMzg2LXJhbmRjb25m
aWctcjAtMDcyMTozLjE2LjAtcmM0LTAwMTY3LWdjMDkwMmI5OjIwNwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yMC0wNzIxL2MwOTAyYjkzZjBmNDI3NDI3ZjZjYjc1Y2I1MDc0Mjg4Zjgw
MDFkNWQvZG1lc2cteW9jdG8tdnAtMTQ6MjAxNDA3MjEwNDE2MDU6aTM4Ni1yYW5kY29uZmln
LXIwLTA3MjE6My4xNi4wLXJjNC0wMDE2Ny1nYzA5MDJiOToyMDcKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjAtMDcyMS9jMDkwMmI5M2YwZjQyNzQyN2Y2Y2I3NWNiNTA3NDI4OGY4MDAx
ZDVkL2RtZXNnLXlvY3RvLXZwLTYyOjIwMTQwNzIxMDQxNjAzOmkzODYtcmFuZGNvbmZpZy1y
MC0wNzIxOjMuMTYuMC1yYzQtMDAxNjctZ2MwOTAyYjk6MjA3Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXIwLTA3MjEvYzA5MDJiOTNmMGY0Mjc0MjdmNmNiNzVjYjUwNzQyODhmODAwMWQ1
ZC9kbWVzZy15b2N0by12cC01ODoyMDE0MDcyMTA0MTYwNTppMzg2LXJhbmRjb25maWctcjAt
MDcyMTozLjE2LjAtcmM0LTAwMTY3LWdjMDkwMmI5OjIwNwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yMC0wNzIxL2MwOTAyYjkzZjBmNDI3NDI3ZjZjYjc1Y2I1MDc0Mjg4ZjgwMDFkNWQv
ZG1lc2cteW9jdG8tdnAtMjU6MjAxNDA3MjEwNDE2MDU6aTM4Ni1yYW5kY29uZmlnLXIwLTA3
MjE6My4xNi4wLXJjNC0wMDE2Ny1nYzA5MDJiOToyMDcKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjAtMDcyMS9jMDkwMmI5M2YwZjQyNzQyN2Y2Y2I3NWNiNTA3NDI4OGY4MDAxZDVkL2Rt
ZXNnLXlvY3RvLXZwLTE2OjIwMTQwNzIxMDQxNjA1OmkzODYtcmFuZGNvbmZpZy1yMC0wNzIx
OjMuMTYuMC1yYzQtMDAxNjctZ2MwOTAyYjk6MjA3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXIwLTA3MjEvYzA5MDJiOTNmMGY0Mjc0MjdmNmNiNzVjYjUwNzQyODhmODAwMWQ1ZC9kbWVz
Zy15b2N0by12cC0xNzoyMDE0MDcyMTA0MTYwNTppMzg2LXJhbmRjb25maWctcjAtMDcyMToz
LjE2LjAtcmM0LTAwMTY3LWdjMDkwMmI5OjIwNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1y
MC0wNzIxL2MwOTAyYjkzZjBmNDI3NDI3ZjZjYjc1Y2I1MDc0Mjg4ZjgwMDFkNWQvZG1lc2ct
eW9jdG8tdnAtMzoyMDE0MDcyMTA0MTYwNTppMzg2LXJhbmRjb25maWctcjAtMDcyMTozLjE2
LjAtcmM0LTAwMTY3LWdjMDkwMmI5OjIwNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0w
NzIxL2MwOTAyYjkzZjBmNDI3NDI3ZjZjYjc1Y2I1MDc0Mjg4ZjgwMDFkNWQvZG1lc2cteW9j
dG8tdnAtNzoyMDE0MDcyMTA0MTYwMzppMzg2LXJhbmRjb25maWctcjAtMDcyMTozLjE2LjAt
cmM0LTAwMTY3LWdjMDkwMmI5OjIwNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wNzIx
L2MwOTAyYjkzZjBmNDI3NDI3ZjZjYjc1Y2I1MDc0Mjg4ZjgwMDFkNWQvZG1lc2cteW9jdG8t
dnAtNDE6MjAxNDA3MjEwNDE2MDU6aTM4Ni1yYW5kY29uZmlnLXIwLTA3MjE6My4xNi4wLXJj
NC0wMDE2Ny1nYzA5MDJiOToyMDcKMDoxMToxMSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwoKSEVBRCBpcyBub3cgYXQgYzA5MDJiOSBmaXh1cCEgeGZzOiBBZGQgUkNVIGZhc3Qgc3lt
bGluayBwYXRoCgo9PT09PT09PT0gbGludXMvbWFzdGVyID09PT09PT09PQpQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyBjMDkwMmI5Li4uIGZpeHVwISB4ZnM6IEFkZCBSQ1UgZmFzdCBz
eW1saW5rIHBhdGgKSEVBRCBpcyBub3cgYXQgZDA1NzE5MC4uLiBNZXJnZSBicmFuY2ggJ2xv
Y2tpbmctdXJnZW50LWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMC0wNzIxL2xpbnVzOm1hc3RlcjpkMDU3MTkwOTI1
ZDk5NGI4MDhlMWQwN2U2Yzc2YjkwYTMyY2FhYzc3OmJpc2VjdC1saW51eDgKCjIwMTQtMDct
MjEtMDQ6MzQ6NDEgZDA1NzE5MDkyNWQ5OTRiODA4ZTFkMDdlNmM3NmI5MGEzMmNhYWM3NyBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9pMzg2LXJhbmRjb25maWctcjAtMDcyMS1kMDU3MTkwOTI1ZDk5NGI4MDhlMWQwN2U2Yzc2
YjkwYTMyY2FhYzc3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjAtMDcyMS9kMDU3MTkwOTI1ZDk5NGI4MDhlMWQwN2U2Yzc2YjkwYTMyY2FhYzc3Cndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctcjAtMDcyMS1kMDU3MTkwOTI1ZDk5NGI4MDhlMWQwN2U2Yzc2YjkwYTMy
Y2FhYzc3Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAtMDcyMS9kMDU3MTkw
OTI1ZDk5NGI4MDhlMWQwN2U2Yzc2YjkwYTMyY2FhYzc3L3ZtbGludXotMy4xNi4wLXJjNS0w
MDI1MS1nZDA1NzE5MAoKMjAxNC0wNy0yMS0wNDozNjo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAJMTcuLgk1Mwk1NAk2MCBTVUNDRVNTCgoKPT09PT09PT09IG5leHQvbWFzdGVyID09PT09
PT09PQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiArIDMxOGNkMmEuLi42NzVjN2U0IGFr
cG0gICAgICAgLT4gbmV4dC9ha3BtICAoZm9yY2VkIHVwZGF0ZSkKICsgNjRlMzI0NS4uLjRj
YmExNjggYWtwbS1iYXNlICAtPiBuZXh0L2FrcG0tYmFzZSAgKGZvcmNlZCB1cGRhdGUpCiAr
IGEyMDQxNmMuLi41OGUzMjNjMyBtYXN0ZXIgICAgIC0+IG5leHQvbWFzdGVyICAoZm9yY2Vk
IHVwZGF0ZSkKICAgMTc5NWNkOS4uNTljYTllZSAgc3RhYmxlICAgICAtPiBuZXh0L3N0YWJs
ZQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxNDA3MTUgLT4gbmV4dC0yMDE0MDcxNQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQwNzE2IC0+IG5leHQtMjAxNDA3MTYKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0
MDcxNyAtPiBuZXh0LTIwMTQwNzE3CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA3
MTggLT4gbmV4dC0yMDE0MDcxOApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBkMDU3MTkw
Li4uIE1lcmdlIGJyYW5jaCAnbG9ja2luZy11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApIRUFEIGlz
IG5vdyBhdCA1OGUzMjNjMy4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3Ig
MjAxNDA3MTgKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1yMC0wNzIxL25leHQ6bWFzdGVyOjU4ZTMyM2MzZWU5NGYxYWJjZWNkZWVlZjIxMWEy
N2QxYzEwNmMyYjM6YmlzZWN0LWxpbnV4OAoKMjAxNC0wNy0yMS0wNDo0MDozMCA1OGUzMjNj
M2VlOTRmMWFiY2VjZGVlZWYyMTFhMjdkMWMxMDZjMmIzIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1y
MC0wNzIxLTU4ZTMyM2MzZWU5NGYxYWJjZWNkZWVlZjIxMWEyN2QxYzEwNmMyYjMKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wNzIxLzU4ZTMyM2Mz
ZWU5NGYxYWJjZWNkZWVlZjIxMWEyN2QxYzEwNmMyYjMKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1yMC0wNzIx
LTU4ZTMyM2MzZWU5NGYxYWJjZWNkZWVlZjIxMWEyN2QxYzEwNmMyYjMKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1yMC0wNzIxLzU4ZTMyM2MzZWU5NGYxYWJjZWNkZWVlZjIx
MWEyN2QxYzEwNmMyYjMvdm1saW51ei0zLjE2LjAtcmM1LW5leHQtMjAxNDA3MTgKCjIwMTQt
MDctMjEtMDQ6NDI6MzAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTYwIFNVQ0NFU1MKCg==
--------------010803070609060701020401
Content-Type: text/plain; charset=UTF-8;
 name="config-3.16.0-rc4-00160-g25c305d"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.16.0-rc4-00160-g25c305d"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.16.0-rc4 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
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
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_KMEM is not set
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
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
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
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
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
CONFIG_MVIAC3_2=y
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX32=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
# CONFIG_X86_PAE is not set
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=m
CONFIG_SCx200HR_TIMER=m
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
# CONFIG_YENTA_ENE_TUNE is not set
CONFIG_YENTA_TOSHIBA=y
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=m
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=m
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=m
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=m
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
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
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_OF_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=m
CONFIG_RFD_FTL=y
CONFIG_SSFDC=m
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_PHYSMAP_OF=y
# CONFIG_MTD_SBC_GXX is not set
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
CONFIG_MTD_PCI=y
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
# CONFIG_MTD_PLATRAM is not set
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_SPI_NOR=y
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_MTD_UBI_BLOCK=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=m
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
CONFIG_PCH_PHUB=m
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
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
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_DELKIN=m
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_OPTI621=m
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
CONFIG_BLK_DEV_ALI15X3=m
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=m
CONFIG_BLK_DEV_TRIFLEX=m
CONFIG_BLK_DEV_CS5520=m
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_CS5535=m
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=m
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=m
CONFIG_BLK_DEV_IT8213=m
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=m
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=m
# CONFIG_BLK_DEV_SIS5513 is not set
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=m
CONFIG_BLK_DEV_TC86C001=m

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=m
# CONFIG_BLK_DEV_ALI14XX is not set
CONFIG_BLK_DEV_DTC2278=m
# CONFIG_BLK_DEV_HT6560B is not set
CONFIG_BLK_DEV_QD65XX=m
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
# CONFIG_SCSI_NETLINK is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=y
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_SCSI=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=y

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
CONFIG_KEYBOARD_GPIO=m
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=m
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_JOYSTICK_WALKERA0701=m
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_OF_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX is not set
CONFIG_TOUCHSCREEN_FUJITSU=m
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_HTCPEN=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=m
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_SERIO_APBPS2=y
CONFIG_SERIO_OLPC_APSP=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=m
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_OF_PLATFORM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_SC16IS7XX is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
CONFIG_SERIAL_XILINX_PS_UART=m
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=m
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=m
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RK3X is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_SCx200_I2C is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_DWAPB=m
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SYSCON=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=m
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_ADNP is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_INTEL_MID=y
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_SODAVILLE=y
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
# CONFIG_GPIO_BCM_KONA is not set

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=m
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_OLPC=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=m
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_OF is not set
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set
CONFIG_INTEL_SOC_DTS_THERMAL=m

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_MFD_AS3722 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=m
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=m
CONFIG_MFD_RTSX_PCI=m
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_DVB_CORE=m
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
# CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV is not set
# CONFIG_USB_GSPCA is not set
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_VIDEO_CPIA2=m
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_VIDEO_USBTV=m

#
# Analog/digital TV USB devices
#
# CONFIG_VIDEO_AU0828 is not set

#
# Digital TV USB devices
#
# CONFIG_DVB_USB_V2 is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_SMS_USB_DRV is not set
# CONFIG_DVB_B2C2_FLEXCOP_USB is not set

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_VIDEO_EM28XX is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX25821 is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_SAA7164 is not set

#
# Media digital TV PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
# CONFIG_DVB_PLUTO2 is not set
# CONFIG_DVB_PT1 is not set
# CONFIG_DVB_NGENE is not set
# CONFIG_DVB_DDBRIDGE is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_MEM2MEM_TESTDEV=m

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_CYPRESS_FIRMWARE=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_SAA7191 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_AS3645A is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88TS2022=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_HD29L2=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_RTL2830=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=m
CONFIG_AGP_AMD=m
CONFIG_AGP_AMD64=m
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=m
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=m
# CONFIG_AGP_VIA is not set
CONFIG_AGP_EFFICEON=m
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_VGASTATE is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
CONFIG_HID_APPLEIR=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=m
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_ELO=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=m
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_OTG_FSM is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_PLATFORM=m
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=m
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PCI is not set
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
# CONFIG_USB_MUSB_TUSB6010 is not set
# CONFIG_USB_MUSB_DSPS is not set
CONFIG_USB_MUSB_UX500=m
CONFIG_USB_UX500_DMA=y
# CONFIG_MUSB_PIO_ONLY is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_HOST=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=y
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=m
# CONFIG_USB_SERIAL_CH341 is not set
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=m
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=m
CONFIG_USB_SERIAL_GARMIN=m
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=m
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_METRO=y
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MXUPORT=y
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=m
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
# CONFIG_USB_SERIAL_XSENS_MT is not set
CONFIG_USB_SERIAL_WISHBONE=m
CONFIG_USB_SERIAL_ZTE=y
CONFIG_USB_SERIAL_SSU100=y
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=m
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=m
CONFIG_SAMSUNG_USB3PHY=y
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_NET48XX=m
CONFIG_LEDS_WRAP=m
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=m
CONFIG_PCH_DMA=y
CONFIG_FSL_EDMA=m
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=m
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=m
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
CONFIG_COMEDI_ISA_DRIVERS=y
# CONFIG_COMEDI_PCL711 is not set
# CONFIG_COMEDI_PCL724 is not set
CONFIG_COMEDI_PCL726=m
# CONFIG_COMEDI_PCL730 is not set
CONFIG_COMEDI_PCL812=m
# CONFIG_COMEDI_PCL816 is not set
# CONFIG_COMEDI_PCL818 is not set
# CONFIG_COMEDI_PCM3724 is not set
CONFIG_COMEDI_AMPLC_DIO200_ISA=m
# CONFIG_COMEDI_AMPLC_PC236_ISA is not set
# CONFIG_COMEDI_AMPLC_PC263_ISA is not set
CONFIG_COMEDI_RTI800=m
CONFIG_COMEDI_RTI802=m
# CONFIG_COMEDI_DAC02 is not set
# CONFIG_COMEDI_DAS16M1 is not set
# CONFIG_COMEDI_DAS08_ISA is not set
CONFIG_COMEDI_DAS16=m
CONFIG_COMEDI_DAS800=m
# CONFIG_COMEDI_DAS1800 is not set
CONFIG_COMEDI_DAS6402=m
CONFIG_COMEDI_DT2801=m
# CONFIG_COMEDI_DT2811 is not set
# CONFIG_COMEDI_DT2814 is not set
CONFIG_COMEDI_DT2815=m
CONFIG_COMEDI_DT2817=m
# CONFIG_COMEDI_DT282X is not set
# CONFIG_COMEDI_DMM32AT is not set
CONFIG_COMEDI_UNIOXX5=m
# CONFIG_COMEDI_FL512 is not set
# CONFIG_COMEDI_AIO_AIO12_8 is not set
CONFIG_COMEDI_AIO_IIRO_16=m
CONFIG_COMEDI_II_PCI20KC=m
# CONFIG_COMEDI_C6XDIGIO is not set
CONFIG_COMEDI_MPC624=m
CONFIG_COMEDI_ADQ12B=m
CONFIG_COMEDI_NI_AT_A2150=m
CONFIG_COMEDI_NI_AT_AO=m
# CONFIG_COMEDI_NI_ATMIO is not set
# CONFIG_COMEDI_NI_ATMIO16D is not set
CONFIG_COMEDI_NI_LABPC_ISA=m
# CONFIG_COMEDI_PCMAD is not set
# CONFIG_COMEDI_PCMDA12 is not set
CONFIG_COMEDI_PCMMIO=m
CONFIG_COMEDI_PCMUIO=m
CONFIG_COMEDI_MULTIQ3=m
CONFIG_COMEDI_S526=m
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_LABPC_ISADMA=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_RTS5208 is not set
# CONFIG_TRANZPORT is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=m
# CONFIG_AD7606_IFACE_PARALLEL is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7152 is not set
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_USB_ENESTORAGE=m
# CONFIG_BCM_WIMAX is not set
CONFIG_FT1000=m
# CONFIG_FT1000_USB is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_AS102 is not set
# CONFIG_DVB_CXD2099 is not set
CONFIG_VIDEO_DT3155=m
CONFIG_DT3155_CCIR=y
# CONFIG_DT3155_STREAMING is not set
# CONFIG_VIDEO_TCM825X is not set
CONFIG_USB_SN9C102=m

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDER_IPC_32BIT=y
# CONFIG_ANDROID_LOGGER is not set
CONFIG_ANDROID_TIMED_OUTPUT=y
# CONFIG_ANDROID_TIMED_GPIO is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_SYNC is not set
# CONFIG_ION is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_LTE_GDM724X is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_PCIE=y
CONFIG_XILLYBUS_OF=y
# CONFIG_DGNC is not set
CONFIG_DGAP=m
CONFIG_GS_FPGABOOT=y
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_CHROMEOS_PSTORE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
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
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_MMA8452 is not set

#
# Analog to digital converters
#
# CONFIG_AD799X is not set
# CONFIG_MAX1363 is not set
# CONFIG_MCP3422 is not set
# CONFIG_NAU7802 is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_VF610_ADC is not set
# CONFIG_VIPERBOARD_ADC is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_DHT11=m
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_APDS9300 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_LTR501 is not set
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL4531 is not set
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_MAG3110 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
# CONFIG_MPL115 is not set
# CONFIG_MPL3115 is not set
# CONFIG_IIO_ST_PRESS is not set

#
# Lightning sensors
#

#
# Temperature sensors
#
# CONFIG_MLX90614 is not set
# CONFIG_TMP006 is not set
CONFIG_NTB=m
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=m
CONFIG_VME_TSI148=m

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_VME_USER=y
CONFIG_VME_PIO2=y
# CONFIG_PWM is not set
CONFIG_IRQCHIP=y
CONFIG_IPACK_BUS=m
CONFIG_BOARD_TPCI200=m
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=m
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
# CONFIG_MCB is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=m
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
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
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
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=m
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
# CONFIG_IMA is not set
CONFIG_EVM=y

#
# EVM options
#
# CONFIG_EVM_ATTR_FSUUID is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_XOR_BLOCKS=m
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=m
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_LGUEST=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=m
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y


--------------010803070609060701020401
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

_______________________________________________
LKP mailing list
LKP@linux.intel.com


--------------010803070609060701020401--
