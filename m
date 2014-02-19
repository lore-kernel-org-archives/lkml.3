Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaBSMR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:17:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:7022 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbaBSMRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:17:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,505,1389772800"; 
   d="log'?scan'208";a="477617976"
Date: Wed, 19 Feb 2014 20:17:03 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [sched/balance] BUG: MAX_LOCK_DEPTH too low!
Message-ID: <20140219121703.GD7241@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

https://github.com/alexshi/power-scheduling.git single-balance
commit 98564060e5c360908d93f61a78ccbef4a082d3c2
Author:     Alex Shi <alex.shi@linaro.org>
AuthorDate: Tue Feb 18 21:01:54 2014 +0800
Commit:     Alex Shi <alex.shi@linaro.org>
CommitDate: Tue Feb 18 21:33:06 2014 +0800

    sched/balance: add balance_interval to tuning top level balance frequency
    
    Since central balance stains less cpu cache as current balance, we
    can set the balance interval more short.
    
    Signed-off-by: Alex Shi <alex.shi@linaro.org>

[    1.180022] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_count 00000100, exited with 00000101?
[    1.183355] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_count 00000100, exited with 00000101?
[    1.186691] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_count 00000100, exited with 00000101?
[    1.187437] BUG: MAX_LOCK_DEPTH too low!
[    1.187731] turning off the locking correctness validator.
[    1.188138] Please attach the output of /proc/lock_stat to the bug report
[    1.188643] depth: 48  max: 48!
[    1.188881] 48 locks held by swapper/0/1:
[    1.189194]  #0:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.189827]  #1:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #2:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #3:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #4:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #5:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #6:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #7:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #8:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #9:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #10:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #11:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #12:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #13:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #14:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #15:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #16:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #17:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #18:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #19:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #20:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #21:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #22:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #23:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #24:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #25:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #26:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #27:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #28:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #29:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #30:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #31:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #32:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #33:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #34:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #35:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #36:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #37:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #38:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #39:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #40:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #41:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #42:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #43:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #44:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #45:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.190010]  #46:  (&rq->lock){-.-.-.}, at: [<4158e188>] __schedule+0x7e/0x5ce
[    1.190010]  #47:  ((null)){.-.-..}, at: [<4158e243>] __schedule+0x139/0x5ce

git bisect start d5471974ffc0bd5cbf7213231e4d6276007cab37 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2 --
git bisect good 52732e61f8895e45c10f3b1977b1252a58a2b64e  # 01:08     23+      6  Merge 'drdb/for-3.15-p2' into devel-hourly-2014021821
git bisect good 9737c3be3ccc4aac6ab919b897dcf68c4a2b4f33  # 01:13     23+      7  Merge 'arm-perf/misc-patches' into devel-hourly-2014021821
git bisect good 0e1ba5d0198d3d1cd947287661fc9ac30164e666  # 01:16     23+      0  Merge 'regulator/topic/tps6507x' into devel-hourly-2014021821
git bisect good b8e87ddb72da627fd03aeb02b77c07065e13427c  # 01:20     23+     11  Merge 'iio/fixes-togreg' into devel-hourly-2014021821
git bisect good 6648c2574f90963cb0bc2421f00f173e9fdc8cc0  # 01:24     23+      3  Merge 'arm-perf/pci/bios32' into devel-hourly-2014021821
git bisect  bad 037d40fe91c5721054a8d1a61cd926dbdb75f968  # 01:28      0-      1  Merge 'alexshi/single-balance' into devel-hourly-2014021821
git bisect good 4a5d7c9f371d437e80369739bc7c38743f0d87c3  # 01:32     23+      3  sched: rename update_*_cpu_load
git bisect good 480c3ba7685296b8da892020d408223e7abdc70b  # 01:35     23+      9  sched: remove un-used functions
git bisect good 0e32dab5df39cfb1be9a937d67c877404b964324  # 01:37     23+     11  sched/balance: rebuild ovutil tree after task moving
git bisect  bad 98564060e5c360908d93f61a78ccbef4a082d3c2  # 01:38      0-      6  sched/balance: add balance_interval to tuning top level balance frequency
git bisect good 34c6c7844fd7ac6b7636614534d83c1099ab6fc7  # 01:42     23+      3  sched/balance: add llc balance interval
# first bad commit: [98564060e5c360908d93f61a78ccbef4a082d3c2] sched/balance: add balance_interval to tuning top level balance frequency
git bisect good 34c6c7844fd7ac6b7636614534d83c1099ab6fc7  # 01:45     69+     20  sched/balance: add llc balance interval
git bisect  bad d5471974ffc0bd5cbf7213231e4d6276007cab37  # 01:45      0-     19  0day head guard for 'devel-hourly-2014021821'
git bisect good 7a455ad6947d320cdf0234d07c4e4575b018cc11  # 01:50     69+     14  Revert "sched/balance: add balance_interval to tuning top level balance frequency"
git bisect good 60f76eab19e3903e810bdc3ec846c158efcd2e21  # 01:55     69+     22  Merge tag 'dma-buf-for-3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf
git bisect good 02d56d4d19b8aa889c856287729d89c805ee42ec  # 01:59     69+     11  Add linux-next specific files for 20140218

Thanks,
Fengguang

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-athens-39:20140218222753:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Linux version 3.14.0-rc3-wl-ath-01897-gd547197 (kbuild@ant) =
(gcc version 4.8.1 (Debian 4.8.1-8) ) #4 SMP Tue Feb 18 22:23:00 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[400fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12000000-0x123fffff]
[    0.000000]  [mem 0x12000000-0x123fffff] page 4k
[    0.000000] BRK [0x02045000, 0x02045fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x11ffffff]
[    0.000000]  [mem 0x10000000-0x11ffffff] page 4k
[    0.000000] BRK [0x02046000, 0x02046fff] PGTABLE
[    0.000000] BRK [0x02047000, 0x02047fff] PGTABLE
[    0.000000] BRK [0x02048000, 0x02048fff] PGTABLE
[    0.000000] BRK [0x02049000, 0x02049fff] PGTABLE
[    0.000000] BRK [0x0204a000, 0x0204afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x13ffdfff]
[    0.000000]  [mem 0x12400000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   Normal zone: 720 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 330 pages/cpu @5212c000 s1337536 r0 d14144 =
u1351680
[    0.000000] pcpu-alloc: s1337536 r0 d14144 u1351680 alloc=3D330*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1212e580
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821/.vmlinu=
z-d5471974ffc0bd5cbf7213231e4d6276007cab37-20140218222337-5-athens branch=
=3Dlinux-devel/devel-hourly-2014021821 BOOT_IMAGE=3D/kernel/i386-randconfig=
-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/vmlinuz-3.14.0-rc3-w=
l-ath-01897-gd547197
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 279460K/327280K available (5712K kernel code, 683K r=
wdata, 2840K rodata, 1760K init, 5596K bss, 47820K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6d000 - 0xfffff000   (1608 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x547fe000 - 0xff7fe000   (2736 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x53ffe000   ( 319 MB)
[    0.000000]       .init : 0x41907000 - 0x41abf000   (1760 kB)
[    0.000000]       .data : 0x41594602 - 0x41906f00   (3530 kB)
[    0.000000]       .text : 0x41000000 - 0x41594602   (5713 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D40096000 soft=3D40080000
[    0.000000] ACPI: Core revision 20140114
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
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
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.044 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. lpj=3D9643480
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006666] Mount-cache hash table entries: 512
[    0.006666] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006666] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.006666] tlb_flushall_shift: 6
[    0.006954] debug: unmapping init [mem 0x41abf000-0x41ac2fff]
[    0.008336] Getting VERSION: 50014
[    0.008628] Getting VERSION: 50014
[    0.008892] Getting ID: 0
[    0.009103] Getting ID: f000000
[    0.009359] Getting LVT0: 8700
[    0.009597] Getting LVT1: 8400
[    0.010007] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.010526] enabled ExtINT on CPU#0
[    0.011517] ENABLING IO-APIC IRQs
[    0.011776] init IO_APIC IRQs
[    0.012005]  apic 0 pin 0 not connected
[    0.012340] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.012949] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.013354] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.013992] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.014608] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.015223] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.015837] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.016686] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.017286] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.017887] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.018496] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.019105] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.019725] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.020019] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.020630] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.021244]  apic 0 pin 16 not connected
[    0.021543]  apic 0 pin 17 not connected
[    0.021843]  apic 0 pin 18 not connected
[    0.022136]  apic 0 pin 19 not connected
[    0.022430]  apic 0 pin 20 not connected
[    0.023337]  apic 0 pin 21 not connected
[    0.023641]  apic 0 pin 22 not connected
[    0.023938]  apic 0 pin 23 not connected
[    0.024372] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.024919] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.025706] Using local APIC timer interrupts.
[    0.025706] calibrating APIC timer ...
[    0.026666] ... lapic delta =3D 6249989
[    0.026666] ... PM-Timer delta =3D 357939
[    0.026666] ... PM-Timer result ok
[    0.026666] ..... delta 6249989
[    0.026666] ..... mult: 268435010
[    0.026666] ..... calibration result: 3333327
[    0.026666] ..... CPU clock speed is 2892.2996 MHz.
[    0.026666] ..... host bus clock speed is 1000.0327 MHz.
[    0.026666] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.026666] CPU 1 irqstacks, hard=3D40110000 soft=3D40112000
[    0.026671] x86: Booting SMP configuration:
[    0.027065] .... node  #0, CPUs:      #1
[    0.003333] Initializing CPU#1
[    0.006666] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.040078] KVM setup async PF for cpu 1
[    0.040106] x86: Booted up 1 node, 2 CPUs
[    0.040110] ----------------
[    0.040111] | NMI testsuite:
[    0.040111] --------------------
[    0.041319]   remote IPI:
[    0.041319] kvm-stealtime: cpu 1, msr 12278580
[    0.050025]   ok  |
[    0.050222]    local IPI:  ok  |
[    0.070011] --------------------
[    0.070252] Good, all   2 testcases passed! |
[    0.070555] ---------------------------------
[    0.070874] smpboot: Total of 2 processors activated (11576.35 BogoMIPS)
[    0.071785] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.073695] regulator-dummy: no parameters
[    0.074290] NET: Registered protocol family 16
[    0.075112] cpuidle: using governor ladder
[    0.075406] cpuidle: using governor menu
[    0.076053] ACPI: bus type PCI registered
[    0.076477] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.076681] PCI: Using configuration type 1 for base access
[    0.083645] ACPI: Added _OSI(Module Device)
[    0.083976] ACPI: Added _OSI(Processor Device)
[    0.084310] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.084645] ACPI: Added _OSI(Processor Aggregator Device)
[    0.091593] ACPI: Interpreter enabled
[    0.091871] ACPI: (supports S0 S5)
[    0.092117] ACPI: Using IOAPIC for interrupt routing
[    0.092509] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.099979] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.100008] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.100426] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.101206] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.102123] PCI host bridge to bus 0000:00
[    0.102414] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.102800] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.103338] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.103801] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.104291] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.104835] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.105680] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.106977] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.109654] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.111112] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.111818] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.112326] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.113130] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.115437] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.117193] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.122564] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.123855] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.125121] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.126368] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.130810] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.131580] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.132910] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.134187] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.139084] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.140403] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.141634] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.146700] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.147996] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.149253] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.154124] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.155404] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.156611] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.161559] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.162824] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.163782] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.168638] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.170005] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.171218] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.176136] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.177123] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.180568] pci_bus 0000:00: on NUMA node 0
[    0.181493] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.182095] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.182701] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.183341] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.183878] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.184810] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.185710] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.186340] vgaarb: loaded
[    0.186531] vgaarb: bridge control possible 0000:00:02.0
[    0.187016] ACPI: bus type USB registered
[    0.187377] usbcore: registered new interface driver usbfs
[    0.187788] usbcore: registered new interface driver hub
[    0.188357] usbcore: registered new device driver usb
[    0.188357] Linux video capture interface: v2.00
[    0.188357] pps_core: LinuxPPS API ver. 1 registered
[    0.188357] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.190020] PTP clock support registered
[    0.190498] PCI: Using ACPI for IRQ routing
[    0.190798] PCI: pci_cache_line_size set to 64 bytes
[    0.191329] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.191758] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.192662] NET: Registered protocol family 23
[    0.193356] Bluetooth: Core ver 2.18
[    0.193660] NET: Registered protocol family 31
[    0.194009] Bluetooth: HCI device and connection manager initialized
[    0.194458] Bluetooth: HCI socket layer initialized
[    0.194834] Bluetooth: L2CAP socket layer initialized
[    0.195219] Bluetooth: SCO socket layer initialized
[    0.195574] NET: Registered protocol family 8
[    0.195886] NET: Registered protocol family 20
[    0.196738] cfg80211: Calling CRDA to update world regulatory domain
[    0.197318] nfc: nfc_init: NFC Core ver 0.1
[    0.197318] NET: Registered protocol family 39
[    0.197814] Switched to clocksource kvm-clock
[    0.198395] pnp: PnP ACPI init
[    0.198670] ACPI: bus type PNP registered
[    0.199053] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.199657] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.199657] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.199762] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.200278] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.200915] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.201416] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.202012] pnp 00:03: [dma 2]
[    0.202283] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.202810] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.203466] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.203977] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.204642] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.205418] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.206067] pnp: PnP ACPI: found 7 devices
[    0.206378] ACPI: bus type PNP unregistered
[    0.241749] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.242188] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.242615] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.243091] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.243648] NET: Registered protocol family 1
[    0.244016] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.244481] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.244935] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.245488] pci 0000:00:02.0: Boot video device
[    0.245944] PCI: CLS 0 bytes, default 64
[    0.246584] Unpacking initramfs...
[    0.990639] debug: unmapping init [mem 0x527ab000-0x53feffff]
[    1.011659] DMA-API: preallocated 65536 debug entries
[    1.012077] DMA-API: debugging enabled by kernel config
[    1.012819] kvm: no hardware support
[    1.013115] has_svm: not amd
[    1.013326] kvm: no hardware support
[    1.014286] cryptomgr_test (21) used greatest stack depth: 7280 bytes le=
ft
[    1.014829] cryptomgr_test (22) used greatest stack depth: 7248 bytes le=
ft
[    1.016580] PCLMULQDQ-NI instructions are not detected.
[    1.018054] Initializing RT-Tester: OK
[    1.018588] futex hash table entries: 16 (order: -2, 1024 bytes)
[    1.019091] audit: initializing netlink subsys (disabled)
[    1.019592] audit: type=3D2000 audit(1392733668.920:1): initialized
[    1.020552] VFS: Disk quotas dquot_6.5.2
[    1.020910] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.021607] fuse init (API version 7.22)
[    1.021998] msgmni has been set to 545
[    1.027063] NET: Registered protocol family 38
[    1.027434] list_sort_test: start testing list_sort()
[    1.028034] test_string_helpers: Running tests...
[    1.029849] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    1.030262] crc32: self tests passed, processed 225944 bytes in 683327 n=
sec
[    1.031476] crc32c: CRC_LE_BITS =3D 32
[    1.031748] crc32c: self tests passed, processed 225944 bytes in 346183 =
nsec
[    1.036683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.040017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.043350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.046685] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.050017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.053351] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.056684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.060017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.063351] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.066684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.070021] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.073351] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.076685] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.080020] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.083351] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.086685] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.090023] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.093352] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.096686] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.100019] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.103352] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.106686] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.110019] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.113353] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.116686] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.120021] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.123353] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.126686] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.130021] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.133353] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.136687] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.140021] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.143354] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.146687] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.150021] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.153354] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.156687] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.160021] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.163354] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.166688] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.170021] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.173361] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.176688] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.180022] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.183355] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.186691] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.187437] BUG: MAX_LOCK_DEPTH too low!
[    1.187731] turning off the locking correctness validator.
[    1.188138] Please attach the output of /proc/lock_stat to the bug report
[    1.188643] depth: 48  max: 48!
[    1.188881] 48 locks held by swapper/0/1:
[    1.189194]  #0:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_loc=
k+0x0/0x28
[    1.189827]  #1:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_loc=
k+0x0/0x28
[    1.190010]  #2:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_loc=
k+0x0/0x28
[    1.190010]  #3:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_loc=
k+0x0/0x28
[    1.190010]  #4:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_loc=
k+0x0/0x28
[    1.190010]  #5:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_loc=
k+0x0/0x28
[    1.190010]  #6:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_loc=
k+0x0/0x28
[    1.190010]  #7:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_loc=
k+0x0/0x28
[    1.190010]  #8:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_loc=
k+0x0/0x28
[    1.190010]  #9:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_loc=
k+0x0/0x28
[    1.190010]  #10:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #11:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #12:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #13:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #14:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #15:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #16:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #17:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #18:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #19:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #20:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #21:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #22:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #23:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #24:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #25:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #26:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #27:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #28:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #29:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #30:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #31:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #32:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #33:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #34:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #35:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #36:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #37:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #38:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #39:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #40:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #41:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #42:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #43:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #44:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #45:  (rcu_read_lock){.+.+..}, at: [<4107d10c>] rcu_read_lo=
ck+0x0/0x28
[    1.190010]  #46:  (&rq->lock){-.-.-.}, at: [<4158e188>] __schedule+0x7e=
/0x5ce
[    1.190010]  #47:  ((null)){.-.-..}, at: [<4158e243>] __schedule+0x139/0=
x5ce
[    1.190010] INFO: lockdep is turned off.
[    1.190010] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc3-wl-ath-=
01897-gd547197 #4
[    1.190010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.190010]  00000000 00000000 40041d84 415896ba 00003bea 40041df0 41087=
e1f 4179b72b
[    1.190010]  00000030 00000030 00000010 41d1b038 00000000 0176c9ad 4003f=
838 00000000
[    1.190010]  00020211 41ce9b58 00000000 41050d84 52272100 40041dd0 41034=
212 52272100
[    1.190010] Call Trace:
[    1.190010]  [<415896ba>] dump_stack+0x48/0x60
[    1.190010]  [<41087e1f>] __lock_acquire+0xb32/0xc7d
[    1.190010]  [<41050d84>] ? kvm_clock_read+0x1f/0x29
[    1.190010]  [<41034212>] ? paravirt_sched_clock+0x9/0xd
[    1.190010]  [<410348d1>] ? sched_clock+0x9/0xc
[    1.190010]  [<4107b7b1>] ? sched_clock_local+0x11/0xfa
[    1.190010]  [<4108821b>] lock_acquire+0x5e/0x7a
[    1.190010]  [<4158e243>] ? __schedule+0x139/0x5ce
[    1.190010]  [<410777c3>] update_rq_clock+0x93/0x178
[    1.190010]  [<4158e243>] ? __schedule+0x139/0x5ce
[    1.190010]  [<4158e243>] __schedule+0x139/0x5ce
[    1.190010]  [<4158e7ca>] _cond_resched+0x20/0x32
[    1.190010]  [<419224d9>] crc32test_init+0x351/0x474
[    1.190010]  [<41922188>] ? crc_t10dif_mod_init+0x57/0x57
[    1.190010]  [<419079fc>] do_one_initcall+0x98/0x11a
[    1.190010]  [<41907423>] ? repair_env_string+0x12/0x51
[    1.190010]  [<41907400>] ? do_early_param+0x62/0x73
[    1.190010]  [<410705b5>] ? parse_args+0x252/0x30d
[    1.190010]  [<41907411>] ? do_early_param+0x73/0x73
[    1.190010]  [<41907b72>] kernel_init_freeable+0xf4/0x16c
[    1.190010]  [<41907b72>] ? kernel_init_freeable+0xf4/0x16c
[    1.190010]  [<4158476d>] kernel_init+0x8/0xb3
[    1.190010]  [<415921f7>] ret_from_kernel_thread+0x1b/0x28
[    1.190010]  [<41584765>] ? rest_init+0xa5/0xa5
[    1.231698] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00200102, exited with 00200103?
[    1.233345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.236678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.240012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.243345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.246678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.250012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.253345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.256678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.260012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.263345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.266678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.270012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.273345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.276679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.280014] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.283345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.286678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.290012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.293345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.296679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.300012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.303345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.306678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.310012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.313345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.316245] crc32_combine: 8373 self tests passed
[    1.316679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.320012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.323345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.326679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.330012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.333345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.336678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.340012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.343345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.346678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.350012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.353345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.356678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.360012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.363345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.366678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.370014] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.373346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.376678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.380012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.383345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.386678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.390012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.393345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.396681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.400012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.403345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.406678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.410012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.413345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.416678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.420012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.423345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.426678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.430012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.433345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.436678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.440012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.443345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.446678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.450012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.453345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.456678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.460012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.463345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.466678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.470012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.473345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.476678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.480012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.483345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.486678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.490012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.493345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.496678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.500012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.503345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.506678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.510012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.513347] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.516679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.520012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.523345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.526678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.530012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.533345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.536679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.540012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.543345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.546678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.550012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.553345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.555220] crc32c_combine: 8373 self tests passed
[    1.555886] xz_dec_test: module loaded
[    1.556178] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    1.556894] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.557649] rbtree testing
[    1.560014] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.563345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.566679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.570011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.573345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.576678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.580011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.583344] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.586678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.590012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.593348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.596693] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.600014] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.603346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.606679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.610013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.613345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.616679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.620013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.623349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.626680] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.630012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.633346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.636679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.640013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.643346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.646679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.650012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.653346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.656679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.660012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.663347] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.666679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.670012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.673346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.676679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.680012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.683345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.686679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.690013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.693345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.696679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.700012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.703346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.706679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.710012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.713345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.716679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.720012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.723345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.726679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.730012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.733345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.736679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.740012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.743348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.746679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.750012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.753344] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.756678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.760012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.763345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.766679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.770012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.773345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.776678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.780011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.783346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.786678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.790012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.793345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.796679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.800011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.803345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.806679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.810012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.813345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.816679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.820012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.823345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.826678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.830012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.833346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.836679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.840013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.843346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.846679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.850012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.853345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.856678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.860015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.863346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.866679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.870013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.873346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.876679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.880012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.883344] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.886678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.890011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.893344] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.896679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.900012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.903346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.906679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.910012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.913345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.916679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.920012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.923346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.926679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.930012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.933346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.936679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.940014] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.943347] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.946678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.950012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.953346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.956679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.960013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.963346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.966679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.970013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.973345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.976682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.980012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.983345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.986679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.989442]  -> 12486 cycles
[    1.990013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.993347] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    1.996680] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.000014] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.003347] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.006684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.010014] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.013347] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.016686] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.020014] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.023347] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.025430] augmented rbtree testing
[    2.026680] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.030012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.033346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.036678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.040012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.043345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.046678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.050011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.053346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.056679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.060013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.063346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.066679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.070012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.073346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.076679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.080013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.083345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.086678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.090011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.093348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.096680] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.100012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.103345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.106679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.110012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.113345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.116679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.120012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.123345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.126678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.130012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.133344] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.136678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.140012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.143344] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.146679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.150012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.153345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.156679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.160012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.163345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.166678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.170012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.173345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.176679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.180012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.183345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.186679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.190012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.193346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.196678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.200011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.203345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.206679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.210015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.213346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.216679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.220012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.223346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.226679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.230013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.233345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.236679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.240012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.243345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.246678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.250012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.253345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.256678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.260012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.263345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.266678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.270012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.273345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.276678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.280012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.283344] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.286678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.290012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.293346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.296678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.300012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.303346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.306679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.310012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.313346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.316678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.320012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.323345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.326678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.330014] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.333344] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.336678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.340011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.343346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.346679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.350012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.353346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.356679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.360012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.363345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.366678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.370013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.373345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.376678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.380012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.383345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.386678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.390012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.393345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.396679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.400012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.403346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.406679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.410012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.413346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.416678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.420012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.423345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.426678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.430012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.433345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.436679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.440011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.443345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.446681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.450013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.453345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.456679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.460012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.463346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.466679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.470013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.473345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.476678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.480011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.483344] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.486679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.490011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.493345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.496679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.500012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.503345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.506679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.510012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.513348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.516681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.520012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.523345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.526678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.530012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.533345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.536679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.540011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.543345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.546679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.550012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.553345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.556679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.560012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.563348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.566678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.570012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.573345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.576679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.580012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.583346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.586678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.590012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.593345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.596678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.600012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.603345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.606678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.610011] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.613345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.616678] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.620012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.623345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.625280]  -> 17346 cycles
[    2.626679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.630012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.633345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.636679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.640012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.643346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.646679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.650012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.653345] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.656679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.660012] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.663346] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.666679] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.670013] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.672655] tsc: Refined TSC clocksource calibration: 2892.947 MHz
[    2.673351] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.674236] no IO addresses supplied
[    2.674558] usbcore: registered new interface driver udlfb
[    2.674983] usbcore: registered new interface driver smscufx
[    2.675548] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.676101] ACPI: Power Button [PWRF]
[    2.676685] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.677451] r3964: Philips r3964 Driver $Revision: 1.10 $
[    2.677857] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.699520] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.700313] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.700866] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.701978] serial: Freescale lpuart driver
[    2.702395] toshiba: not a supported Toshiba laptop
[    2.702904] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    2.703456] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.704212] platform pc8736x_gpio.0: no device found
[    2.704595] nsc_gpio initializing
[    2.704855] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    2.705329] [drm] Initialized drm 1.1.0 20060810
[    2.705706] parport_pc 00:04: reported by Plug and Play ACPI
[    2.706221] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE
[    2.706703] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.707470] ]
[    2.716688] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.726685] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.736685] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.746700] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.756701] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.766700] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.776700] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.786701] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.787712] dummy-irq: no IRQ given.  Use irq=3DN
[    2.788278] usbcore: registered new interface driver viperboard
[    2.788755] usbcore: registered new interface driver pn533
[    2.789209] usbcore: registered new interface driver port100
[    2.789647] usbcore: registered new interface driver nfcmrvl
[    2.790087] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.790972] HSI/SSI char device loaded
[    2.791660] libphy: Fixed MDIO Bus: probed
[    2.792061] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    2.792747] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[    2.793427] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.794190] vcan: Virtual CAN interface driver
[    2.794527] slcan: serial line CAN interface driver
[    2.794890] slcan: 10 dynamic interface channels.
[    2.795353] usbcore: registered new interface driver irda-usb
[    2.795794] usbcore: registered new interface driver stir4200
[    2.796682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.797428] usbcore: registered new interface driver ksdazzle-sir
[    2.797892] usbcore: registered new interface driver ks959-sir
[    2.798332] PPP generic driver version 2.4.2
[    2.798691] PPP BSD Compression module registered
[    2.799050] PPP Deflate Compression module registered
[    2.799438] NET: Registered protocol family 24
[    2.799779] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[    2.800321] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.801053] SLIP linefill/keepalive option.
[    2.801376] hdlc: HDLC support module revision 1.22
[    2.801773] usbcore: registered new interface driver i2400m_usb
[    2.802389] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMA=
C hardware
[    2.802967] usbcore: registered new interface driver kaweth
[    2.803399] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.804139] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    2.804696] usbcore: registered new interface driver pegasus
[    2.805147] usbcore: registered new interface driver r8152
[    2.805571] usbcore: registered new interface driver asix
[    2.805989] usbcore: registered new interface driver cdc_ether
[    2.806440] usbcore: registered new interface driver r815x
[    2.806866] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.807615] usbcore: registered new interface driver cdc_eem
[    2.808050] usbcore: registered new interface driver smsc75xx
[    2.808492] usbcore: registered new interface driver gl620a
[    2.808925] usbcore: registered new interface driver net1080
[    2.809367] usbcore: registered new interface driver plusb
[    2.809789] usbcore: registered new interface driver rndis_host
[    2.810249] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.810997] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    2.811569] usbcore: registered new interface driver cdc_phonet
[    2.812021] usbcore: registered new interface driver kalmia
[    2.812451] usbcore: registered new interface driver ipheth
[    2.812886] usbcore: registered new interface driver sierra_net
[    2.813347] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.814084] usbcore: registered new interface driver cx82310_eth
[    2.814547] usbcore: registered new interface driver cdc_ncm
[    2.814983] usbcore: registered new interface driver cdc_mbim
[    2.815418] adummy: version 1.0
[    2.815826] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.816306] ohci-pci: OHCI PCI platform driver
[    2.816656] ohci-platform: OHCI generic platform driver
[    2.817063] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.817853] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    2.818309] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    2.818980] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    2.819420]=20
[    2.820092] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.820858] usbcore: registered new interface driver cdc_acm
[    2.821286] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    2.821894] usbcore: registered new interface driver usblp
[    2.822323] usbcore: registered new interface driver cdc_wdm
[    2.822754] usbcore: registered new interface driver usbtmc
[    2.823189] usbcore: registered new interface driver mdc800
[    2.823619] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.824354] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    2.824928] usbcore: registered new interface driver adutux
[    2.825481] usbcore: registered new interface driver appledisplay
[    2.825959] usbcore: registered new interface driver cypress_cy7c63
[    2.826461] usbcore: registered new interface driver cytherm
[    2.826907] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.827663] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    2.828191] driver ftdi-elan
[    2.828726] usbcore: registered new interface driver ftdi-elan
[    2.829190] usbcore: registered new interface driver idmouse
[    2.829633] usbcore: registered new interface driver usblcd
[    2.830066] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.830814] usbcore: registered new interface driver legousbtower
[    2.831293] usbcore: registered new interface driver trancevibrator
[    2.831769] usbcore: registered new interface driver usbsevseg
[    2.832214] usbcore: registered new interface driver yurex
[    2.832651] usbcore: registered new interface driver sisusb
[    2.833157] usbcore: registered new interface driver cxacru
[    2.833594] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.834342] usbcore: registered new interface driver speedtch
[    2.834781] usbcore: registered new interface driver ueagle-atm
[    2.835227] xusbatm: malformed module parameters
[    2.835648] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.836685] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.837649] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.838042] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.840019] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.843351] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.846684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.850018] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.853349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.856683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.860016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.863350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.866683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.870016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.873350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.876683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.880017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.883350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.886683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.888361] mousedev: PS/2 mouse device common for all mice
[    2.889049] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.889860] usbcore: registered new interface driver appletouch
[    2.890350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.891151] usbcore: registered new interface driver bcm5974
[    2.892465] usbcore: registered new interface driver synaptics_usb
[    2.893041] usbcore: registered new interface driver usb_acecad
[    2.893566] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.894416] usbcore: registered new interface driver kbtab
[    2.894921] usbcore: registered new interface driver wacom
[    2.895463] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.896001] usbcore: registered new interface driver ati_remote2
[    2.896494] cm109: Keymap for Komunikate KIP1000 phone loaded
[    2.896965] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.897804] usbcore: registered new interface driver cm109
[    2.898294] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    2.898875] usbcore: registered new interface driver ims_pcu
[    2.899617] wistron_btns: System unknown
[    2.899966] usbcore: registered new interface driver yealink
[    2.900457] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.901407] usbcore: registered new interface driver i2c-diolan-u2c
[    2.901925] i2c-parport: adapter type unspecified
[    2.902326] i2c-parport-light: adapter type unspecified
[    2.903188] vivi-000: V4L2 device registered as video0
[    2.903634] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.904428] Video Technology Magazine Virtual Video Capture Board ver 0.=
8.1 successfully loaded.
[    2.905152] m2m-testdev m2m-testdev.0: Device registered as /dev/video1
[    2.905654] Colour QuickCam for Video4Linux v0.06
[    2.906686] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.910017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.913349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.916683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.920016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.923349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.926683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.930016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.933349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.936682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.940016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.943349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.946682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.950016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.953349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.956683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.960017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.963350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.966683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.970016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.973349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.976683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.980016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.983353] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.986682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.990016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    2.993349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    2.996682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.000016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.003349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.006682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.010016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.013349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.016683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.020016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.023349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.026688] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.030016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.033349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.036683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.040016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.043349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.046682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.050016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.053349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.056683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.060016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.063349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.066683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.070015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.073349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.076682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.080015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.083349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.086682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.090016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.093349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.096683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.100026] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.103349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.106682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.110015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.113348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.116682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.120015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.123348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.126682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.130016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.133349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.136682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.140016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.143349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.146682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.150015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.153349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.156682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.160016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.163348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.166682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.170015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.173349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.176682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.180015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.183348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.186682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.190015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.193348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.196682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.200015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.203348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.206681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.210015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.213348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.216685] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.220015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.223348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.226681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.230015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.233348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.236682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.240015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.243348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.246682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.250015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.253348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.256682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.260015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.263348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.266681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.270015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.273348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.276682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.280015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.283348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.286681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.290015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.293348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.296681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.300015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.303348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.306681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.310015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.313348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.316681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.320015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.323348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.326682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.330015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.333348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.336685] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.340015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.343349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.346682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.350015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.353348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.356681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.360015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.363348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.366681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.370015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.373348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.376682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.380015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.383348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.386682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.390015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.393348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.396682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.400016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.403348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.406682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.410015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.413348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.416682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.420015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.423348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.426682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.430016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.433348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.436682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.440015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.443348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.446682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.450015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.453348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.456682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.460015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.463348] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.466681] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.470016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.473349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.476683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.480016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.483349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.486683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.490016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.493349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.496683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.500017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.503349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.506683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.510016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.513361] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.516683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.520016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.523350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.526683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.530017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.533350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.536683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.540016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.543350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.546683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.550016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.553349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.556683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.560016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.563349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.566686] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.570016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.573349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.576683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.580016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.583349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.586683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.590016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.593349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.596683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.600017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.603350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.606683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.610016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.613350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.616683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.620016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.623350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.626683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.630017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.633349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.636683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.640017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.643350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.646683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.650017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.653350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.656683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.660017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.663350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.666683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.670029] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.673350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.676683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.680016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.683350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.686687] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.690017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.693349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.696683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.700016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.703350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.706683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.710017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.713349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.716683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.720017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.723349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.726683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.730017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.733349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.736683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.740016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.743350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.746683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.750017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.753350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.756683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.760016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.763349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.766683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.770017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.773349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.776683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.780016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.783350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.786683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.790016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.793350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.796683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.800017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.803353] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.806683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.810017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.813350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.816683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.820016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.823350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.826683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.830017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.833349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.836683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.840017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.843350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.846683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.850017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.853350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.856684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.860017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.863350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.866683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.870016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.873350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.876683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.880017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.883350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.886686] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.890017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.893349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.896683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.900017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.903350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.906683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.910016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.913349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.916683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.920019] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.923350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.926683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.930016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.933349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.936682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.940015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.943349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.946682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.950016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.953349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.956683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.960016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.963349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.966683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.970016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.973349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.976683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.980016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.983349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    3.986682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.990016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.993349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    3.996682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.000023] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.003349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.006682] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.010016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.013349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.016683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.020016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.023350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.026683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.030016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.033350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.036683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.040019] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.043350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.046683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.050017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.053350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.056683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.060016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.063350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.066683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.070016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.073350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.076683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.080016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.083349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.086683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.090016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.093349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.096683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.100016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.103350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.106683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.110016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.113349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.116683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.120016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.123350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.126683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.130016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.133350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.136683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.140016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.143350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.146683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.150017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.153350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.156684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.160016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.163350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.166683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.170016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.173350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.176683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.180016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.183350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.186683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.190016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.193349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.196684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.200017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.203350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.206683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.210017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.213349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.216683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.220016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.223350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.226683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.230016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.233349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.236683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.240016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.243350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.246683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.250017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.253349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.256683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.260016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.263350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.266683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.270017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.273350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.276683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.280016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.283350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.286683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.290016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.293349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.296683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.300017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.303350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.306683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.310016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.313349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.316684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.320016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.323350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.326683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.330017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.333350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.336685] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.340017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.343350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.346683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.350017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.353350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.356683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.360016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.363350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.366683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.370016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.373349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.376683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.380016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.383350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.386683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.390016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.393349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.396683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.400016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.403350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.406683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.410016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.413349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.416683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.420017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.423349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.426683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.430016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.433349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.436683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.440016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.443350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.446683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.450017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.453350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.456683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.460017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.463350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.466683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.470017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.473350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.476683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.480016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.483350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.486683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.490016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.493349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.496683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.500017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.503350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.506683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.510016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.513349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.516683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.520016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.523350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.526683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.530016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.533349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.536683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.540016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.543350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.546683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.550017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.553349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.556683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.560016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.563349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.566683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.570016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.573350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.576683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.577462] No Quickcam found on port parport0
[    4.577814] Quickcam detection counter: 0
[    4.578140] pps_ldisc: PPS line discipline registered
[    4.578540] pps_parport: parallel port PPS client
[    4.579284] pps pps0: new PPS source pps_parport
[    4.579963] pps_parport: attached to parport0
[    4.580334] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.581198] Driver for 1-wire Dallas network protocol.
[    4.581752] usbcore: registered new interface driver DS9490R
[    4.582267] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    4.583351] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.584310] applesmc: supported laptop not found!
[    4.584669] applesmc: driver init failed (ret=3D-19)!
[    4.585150] f71882fg: Not a Fintek device
[    4.585470] f71882fg: Not a Fintek device
[    4.586160] pc87360: PC8736x not detected, module not inserted
[    4.586619] sch56xx_common: Unsupported device id: 0xff
[    4.587072] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.587836] sch56xx_common: Unsupported device id: 0xff
[    4.588451] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    4.589007] usbcore: registered new interface driver pcwd_usb
[    4.589458] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    4.590022] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.590904] acquirewdt: I/O address 0x0043 already in use
[    4.591322] acquirewdt: probe of acquirewdt failed with error -5
[    4.591802] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    4.592449] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    4.592972] sc520_wdt: cannot register miscdev on minor=3D130 (err=3D-16)
[    4.593472] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.594331] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    4.594920] ib700wdt: START method I/O 443 is not available
[    4.595369] ib700wdt: probe of ib700wdt failed with error -5
[    4.595791] pc87413_wdt: Version 1.1 at io 0x2E
[    4.596158] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    4.596649] sbc60xxwdt: I/O address 0x0443 already in use
[    4.597140] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.597889] sbc8360: failed to register misc device
[    4.598299] cpu5wdt: misc_register failed
[    4.598628] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    4.600017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000102, exited with 00000103?
[    4.600839] smsc37b787_wdt: Unable to register miscdev on minor 130
[    4.601357] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    4.601848] w83697hf_wdt: watchdog not found at address 0x2e
[    4.602273] w83697hf_wdt: No W83697HF/HG could be found
[    4.602680] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    4.603350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.604132] w83697ug_wdt: No W83697UG/UF could be found
[    4.604570] w83877f_wdt: I/O address 0x0443 already in use
[    4.604977] w83977f_wdt: driver v1.00
[    4.605258] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    4.605747] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    4.606289] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    4.606932] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.607703] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    4.608348] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    4.609158] Bluetooth: Virtual HCI driver ver 1.4
[    4.609546] Bluetooth: HCI UART driver ver 2.2
[    4.609889] usbcore: registered new interface driver bpa10x
[    4.610343] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.611145] usbcore: registered new interface driver btusb
[    4.611557] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    4.613181] ISDN subsystem Rev: 1.1.2.3/
[    4.613492] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.614346] 1.1.2.2/none/none/1.1.2.2
[    4.614698] Modular ISDN core version 1.1.29
[    4.615093] NET: Registered protocol family 34
[    4.615430] dss1_divert module successfully installed
[    4.615804] HiSax: Linux Driver for passive ISDN cards
[    4.616210] HiSax: Version 3.5 (kernel)
[    4.616499] HiSax: Layer1 Revision 2.46.2.5
[    4.616841] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.617638] HiSax: Layer2 Revision 2.30.2.4
[    4.617950] HiSax: TeiMgr Revision 2.20.2.3
[    4.618297] HiSax: Layer3 Revision 2.22.2.3
[    4.618606] HiSax: LinkLayer Revision 2.59.2.4
[    4.618953] HiSax: Total 1 card defined
[    4.619271] HiSax: Card 1 Protocol NI1 Id=3DHiSax (0)
[    4.619654] Gazel: Driver Revision 2.19.2.4
[    4.619971] Gazel: ISA PnP card automatic recognition
[    4.620411] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.621184] Gazel: Card ISA R647/R648 found
[    4.621494] Gazel: config irq:15 isac:0x8180  cfg:0xC180
[    4.621917] Gazel: hscx A:0x180  hscx B:0x4180
[    4.623350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.626684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.630017] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.633350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.636684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.640018] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.643350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.646685] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.650019] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.653351] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.656684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.660029] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.663350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.666684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.670032] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.673351] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.676684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.677776] Gazel: ISAC version (ff): 2085 V2.3
[    4.678140] Gazel: HSCX version A: ???  B: ???
[    4.678491] Gazel: wrong HSCX versions check IO address
[    4.678890] HiSax: Card Gazel not installed !
[    4.679222] HFC-4S/8S: Layer 1 driver module for HFC-4S/8S isdn chips, R=
evision: 1.10
[    4.679818] HFC-4S/8S: (C) 2003 Cornelius Consult, www.cornelius-consult=
=2Ede
[    4.680389] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.681199] HFC-4S/8S: found 0 cards
[    4.681469] gigaset: Driver for Gigaset 307x
[    4.681827] gigaset: Kernel CAPI interface
[    4.682167] usbcore: registered new interface driver usb_gigaset
[    4.682642] usb_gigaset: USB Driver for Gigaset 307x using M105
[    4.683109] usbcore: registered new interface driver bas_gigaset
[    4.683631] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.684415] bas_gigaset: USB Driver for Gigaset 307x
[    4.684832] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    4.685562] usbcore: registered new interface driver vub300
[    4.686332] ledtrig-cpu: registered to indicate activity on CPUs
[    4.686804] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.687700] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    4.688333] hidraw: raw HID events driver (C) Jiri Kosina
[    4.689422] usbcore: registered new interface driver usbhid
[    4.689850] usbhid: USB HID core driver
[    4.690168] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.691579] intel_rapl: driver does not support CPU family 15 model 6
[    4.692202] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[    4.692680] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    4.693241] ad1848: No ISAPnP cards found, trying standard ones...
[    4.693782] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.694566] sb: Init: Starting Probe...
[    4.694880] sb: Init: Done
[    4.695126] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red=
 Hat Inc
[    4.695687] uart6850: irq and io must be set.
[    4.696047] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[    4.696654] MIDI Loopback device driver
[    4.697000] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.697891] NET: Registered protocol family 26
[    4.698412] netem: version 1.3
[    4.698653] u32 classifier
[    4.698857]     Performance counters on
[    4.699148]     input device check on
[    4.699453] NET: Registered protocol family 17
[    4.699798] NET: Registered protocol family 15
[    4.700159] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.700975] NET: Registered protocol family 5
[    4.701337] NET: Registered protocol family 9
[    4.701662] X25: Linux Version 0.2
[    4.701947] can: controller area network core (rev 20120528 abi 9)
[    4.702432] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[    4.702958] NET: Registered protocol family 29
[    4.703297] can: raw protocol (rev 20120528)
[    4.703684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.704466] can: netlink gateway (rev 20130117) max_hops=3D1
[    4.705036] IrCOMM protocol (Dag Brattli)
[    4.705761] Bluetooth: CMTP (CAPI Emulation) ver 1.0
[    4.706169] Bluetooth: CMTP socket layer initialized
[    4.706538] lec:lane_module_init: lec.c: initialized
[    4.706949] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.707758] 8021q: 802.1Q VLAN Support v1.8
[    4.708106] NET: Registered protocol family 37
[    4.708517] NET: Registered protocol family 36
[    4.708973] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[    4.709595] openvswitch: Open vSwitch switching datapath
[    4.710016] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000103, exited with 00000104?
[    4.710866] mpls_gso: MPLS GSO support
[    4.711514]=20
[    4.711514] printing PIC contents
[    4.711919] ... PIC  IMR: ffff
[    4.712161] ... PIC  IRR: 1093
[    4.712399] ... PIC  ISR: 0000
[    4.712654] ... PIC ELCR: 0c00
[    4.712908] printing local APIC contents on CPU#0/0:
[    4.713307] ... APIC ID:      00000000 (0)
[    4.713349] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000102, exited with 00000103?
[    4.714366] ... APIC VERSION: 00050014
[    4.714650] ... APIC TASKPRI: 00000000 (00)
[    4.715021] ... APIC PROCPRI: 00000000
[    4.715312] ... APIC LDR: 01000000
[    4.715572] ... APIC DFR: ffffffff
[    4.715830] ... APIC SPIV: 000001ff
[    4.716097] ... APIC ISR field:
[    4.716232] 00000000000000000000000000000000
[    4.716684] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000102, exited with 00000103?

[    4.716232] 00000000000000000000000000000000
[    4.716232] ... APIC TMR field:
[    4.716232] 000000000200000000000000000000000000000000000000000000000000=
0000
[    4.716232] ... APIC IRR field:
[    4.716232] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.716232] ... APIC ESR: 00000000
[    4.716232] ... APIC ICR: 000008fd
[    4.720018] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000102, exited with 00000103?
[    4.716232] ... APIC ICR2: 02000000
[    4.716232] ... APIC LVTT: 000000ef
[    4.716232] ... APIC LVTPC: 00010000
[    4.716232] ... APIC LVT0: 00010700
[    4.716232] ... APIC LVT1: 00000400
[    4.716232] ... APIC LVTERR: 000000fe
[    4.716232] ... APIC TMICT: 01b7af37
[    4.716232] ... APIC TMCCT: 01aa8711
[    4.716232] ... APIC TDCR: 00000003
[    4.716232]=20
[    4.723350] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000102, exited with 00000103?
[    4.724132] number of MP IRQ sources: 15.
[    4.724501] number of IO-APIC #0 registers: 24.
[    4.724829] testing the IO APIC.......................
[    4.725230] IO APIC #0......
[    4.725456] .... register #00: 00000000
[    4.725732] .......    : physical APIC id: 00
[    4.726075] .......    : Delivery Type: 0
[    4.726394] .......    : LTS          : 0
[    4.726699] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.727477] .... register #01: 00170011
[    4.727776] .......     : max redirection entries: 17
[    4.728181] .......     : PRQ implemented: 0
[    4.728508] .......     : IO APIC version: 11
[    4.728824] .... register #02: 00000000
[    4.729108] .......     : arbitration: 00
[    4.729443] .... IRQ redirection table:
[    4.729732] 1    0    0   0   0    0    0    00
[    4.730076] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.730905] 0    0    0   0   0    1    1    31
[    4.731261] 0    0    0   0   0    1    1    30
[    4.731609] 0    0    0   0   0    1    1    33
[    4.732012] 1    0    0   0   0    1    1    34
[    4.732365] 1    1    0   0   0    1    1    35
[    4.732720] 0    0    0   0   0    1    1    36
[    4.733062] 0    0    0   0   0    1    1    37
[    4.733403] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.734177] 0    0    0   0   0    1    1    38
[    4.734559] 0    1    0   0   0    1    1    39
[    4.734892] 1    1    0   0   0    1    1    3A
[    4.735253] 1    1    0   0   0    1    1    3B
[    4.735586] 0    0    0   0   0    1    1    3C
[    4.735929] 0    0    0   0   0    1    1    3D
[    4.736292] 0    0    0   0   0    1    1    3E
[    4.736640] 0    0    0   0   0    1    1    3F
[    4.737015] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.737779] 1    0    0   0   0    0    0    00
[    4.738122] 1    0    0   0   0    0    0    00
[    4.738517] 1    0    0   0   0    0    0    00
[    4.738851] 1    0    0   0   0    0    0    00
[    4.739190] 1    0    0   0   0    0    0    00
[    4.739568] 1    0    0   0   0    0    0    00
[    4.739902] 1    0    0   0   0    0    0    00
[    4.740282] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.741089] 1    0    0   0   0    0    0    00
[    4.741440] IRQ to pin mappings:
[    4.741676] IRQ0 -> 0:2
[    4.741908] IRQ1 -> 0:1
[    4.742116] IRQ3 -> 0:3
[    4.742345] IRQ4 -> 0:4
[    4.742547] IRQ5 -> 0:5
[    4.742766] IRQ6 -> 0:6
[    4.742967] IRQ7 -> 0:7
[    4.743174] IRQ8 -> 0:8
[    4.743392] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.744174]=20
[    4.744358] IRQ9 -> 0:9
[    4.744561] IRQ10 -> 0:10
[    4.744776] IRQ11 -> 0:11
[    4.744990] IRQ12 -> 0:12
[    4.745212] IRQ13 -> 0:13
[    4.745454] IRQ14 -> 0:14
[    4.745673] IRQ15 -> 0:15
[    4.745889] .................................... done.
[    4.746304] Using IPI Shortcut mode
[    4.746660] registered taskstats version 1
[    4.747043] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.748331] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.748781] EDD information not available.
[    4.749392] debug: unmapping init [mem 0x41907000-0x41abefff]
[    4.750027] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.753353] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.755532] random: init urandom read with 1 bits of entropy available
[    4.756683] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.760034] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.761368] hostname (100) used greatest stack depth: 6984 bytes left
[    4.763353] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.765306] sh (102) used greatest stack depth: 6836 bytes left
[    4.766689] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
/bin/sh: /proc/self/fd/9: No such file or directory
[    4.770069] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?

[    4.773352] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.776688] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
[    4.780027] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000100, exited with 00000101?
/bin/sh: /proc/self/fd/9: No such file or directory
[    4.783351] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
/bin/sh: /proc/self/fd/9: No such file or directory
[    4.786702] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.793366] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.796692] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.800042] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.810029] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.816691] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.823368] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.836696] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.850040] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.856693] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?
[    4.876691] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_=
count 00000101, exited with 00000102?

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-a=
n1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/vmlinuz-3.14.0-rc3-wl-=
ath-01897-gd547197 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 =
debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi=
_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0=
 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-=
randconfig-an1-02182100/linux-devel:devel-hourly-2014021821/.vmlinuz-d54719=
74ffc0bd5cbf7213231e4d6276007cab37-20140218222337-5-athens branch=3Dlinux-d=
evel/devel-hourly-2014021821 BOOT_IMAGE=3D/kernel/i386-randconfig-an1-02182=
100/d5471974ffc0bd5cbf7213231e4d6276007cab37/vmlinuz-3.14.0-rc3-wl-ath-0189=
7-gd547197'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp=
 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::16629-=
:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -d=
rive file=3D/fs/LABEL=3DKVM/disk0-quantal-athens-39,media=3Ddisk,if=3Dvirti=
o -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-athens-39,media=3Ddisk,if=3Dv=
irtio -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-athens-39,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-quantal-athens-39,media=3Ddis=
k,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-quantal-athens-39,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-quantal-athens-39,m=
edia=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-athens-39 -seri=
al file:/dev/shm/kboot/serial-quantal-athens-39 -daemonize -display none -m=
onitor null=20

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="i386-randconfig-an1-02182100-d5471974ffc0bd5cbf7213231e4d6276007cab37-BUG:-MAX_LOCK_DEPTH-too-108380.log"

git checkout 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:bisect-linux
2014-02-19 00:58:36: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/6d0abeca3242a88cab8232e4acd7e2bf088f3bc2' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-00:58:36 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2 compiling
77 real  1241 user  110 sys  1738.94% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:00:04 detecting boot state 3.14.0-rc3....	6	10	23 SUCCESS

bisect: good commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2
git bisect start d5471974ffc0bd5cbf7213231e4d6276007cab37 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2 --
/c/kernel-tests/linear-bisect: ["-b", "d5471974ffc0bd5cbf7213231e4d6276007cab37", "-g", "6d0abeca3242a88cab8232e4acd7e2bf088f3bc2", "/c/kernel-tests/bisect-test-boot-failure.sh", "/kernel-tests/linux/obj-bisect"]
Bisecting: 1897 revisions left to test after this (roughly 11 steps)
[52732e61f8895e45c10f3b1977b1252a58a2b64e] Merge 'drdb/for-3.15-p2' into devel-hourly-2014021821
running /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:52732e61f8895e45c10f3b1977b1252a58a2b64e:bisect-linux
2014-02-19 01:03:36: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/52732e61f8895e45c10f3b1977b1252a58a2b64e' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-01:03:36 52732e61f8895e45c10f3b1977b1252a58a2b64e compiling
74 real  1240 user  112 sys  1818.00% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:05:04 detecting boot state 3.14.0-rc3-wl-ath-01203-g52732e6..	5	12	17	19	23 SUCCESS

Bisecting: 694 revisions left to test after this (roughly 10 steps)
[9737c3be3ccc4aac6ab919b897dcf68c4a2b4f33] Merge 'arm-perf/misc-patches' into devel-hourly-2014021821
running /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:9737c3be3ccc4aac6ab919b897dcf68c4a2b4f33:bisect-linux
2014-02-19 01:08:35: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/9737c3be3ccc4aac6ab919b897dcf68c4a2b4f33' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-01:08:35 9737c3be3ccc4aac6ab919b897dcf68c4a2b4f33 compiling
73 real  1240 user  111 sys  1829.54% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:10:03 detecting boot state 3.14.0-rc3-wl-ath-01486-g9737c3be..	2	10	18	22	23 SUCCESS

Bisecting: 411 revisions left to test after this (roughly 9 steps)
[0e1ba5d0198d3d1cd947287661fc9ac30164e666] Merge 'regulator/topic/tps6507x' into devel-hourly-2014021821
running /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:0e1ba5d0198d3d1cd947287661fc9ac30164e666:bisect-linux
2014-02-19 01:13:33: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/0e1ba5d0198d3d1cd947287661fc9ac30164e666' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-01:13:33 0e1ba5d0198d3d1cd947287661fc9ac30164e666 compiling
17 real  97 user  10 sys  624.51% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:13:59 detecting boot state 3.14.0-rc3-wl-ath-01749-g0e1ba5d..	3	19	23 SUCCESS

Bisecting: 148 revisions left to test after this (roughly 8 steps)
[b8e87ddb72da627fd03aeb02b77c07065e13427c] Merge 'iio/fixes-togreg' into devel-hourly-2014021821
running /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:b8e87ddb72da627fd03aeb02b77c07065e13427c:bisect-linux
2014-02-19 01:16:34: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/b8e87ddb72da627fd03aeb02b77c07065e13427c' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-01:16:34 b8e87ddb72da627fd03aeb02b77c07065e13427c compiling
14 real  29 user  4 sys  248.56% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:17:41 detecting boot state 3.14.0-rc3-wl-ath-01821-gb8e87dd..	2	12	18	23 SUCCESS

Bisecting: 76 revisions left to test after this (roughly 7 steps)
[6648c2574f90963cb0bc2421f00f173e9fdc8cc0] Merge 'arm-perf/pci/bios32' into devel-hourly-2014021821
running /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:6648c2574f90963cb0bc2421f00f173e9fdc8cc0:bisect-linux
2014-02-19 01:20:42: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/6648c2574f90963cb0bc2421f00f173e9fdc8cc0' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-01:20:42 6648c2574f90963cb0bc2421f00f173e9fdc8cc0 compiling
60 real  1083 user  94 sys  1939.47% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:21:55 detecting boot state 3.14.0-rc3-wl-ath-01875-g6648c25..	10	20	23 SUCCESS

Bisecting: 22 revisions left to test after this (roughly 5 steps)
[037d40fe91c5721054a8d1a61cd926dbdb75f968] Merge 'alexshi/single-balance' into devel-hourly-2014021821
running /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:037d40fe91c5721054a8d1a61cd926dbdb75f968:bisect-linux
2014-02-19 01:24:30: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/037d40fe91c5721054a8d1a61cd926dbdb75f968' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-01:24:31 037d40fe91c5721054a8d1a61cd926dbdb75f968 compiling
83 real  1242 user  107 sys  1619.29% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:27:12 detecting boot state 3.14.0-rc3-wl-ath-01896-g037d40f.. TEST FAILURE
[    1.193361] softirq: huh, entered softirq 7 SCHED 4107f8c4 with preempt_count 00000100, exited with 00000101?
[    1.196697] softirq: huh, entered softirq 7 SCHED 4107f8c4 with preempt_count 00000100, exited with 00000101?
[    1.200028] softirq: huh, entered softirq 7 SCHED 4107f8c4 with preempt_count 00000100, exited with 00000101?
[    1.200750] BUG: MAX_LOCK_DEPTH too low!
[    1.201061] turning off the locking correctness validator.
[    1.201449] Please attach the output of /proc/lock_stat to the bug report
[    1.201932] depth: 48  max: 48!
[    1.202160] 48 locks held by swapper/0/1:
[    1.202447]  #0:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203060]  #1:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #2:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #3:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #4:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #5:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #6:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #7:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #8:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #9:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #10:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #11:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #12:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #13:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #14:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #15:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #16:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #17:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #18:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #19:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #20:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #21:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #22:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #23:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #24:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #25:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #26:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #27:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #28:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #29:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #30:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #31:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #32:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #33:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #34:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #35:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #36:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #37:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #38:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #39:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #40:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #41:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #42:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #43:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #44:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #45:  (rcu_read_lock){.+.+.+}, at: [<4107d24d>] rcu_read_lock+0x0/0x28
[    1.203347]  #46:  (&rq->lock){-.-.-.}, at: [<4158f328>] __schedule+0x7e/0x5ce
[    1.203347]  #47:  ((null)){.-.-..}, at: [<4158f3e3>] __schedule+0x139/0x5ce
/kernel/i386-randconfig-an1-02182100/037d40fe91c5721054a8d1a61cd926dbdb75f968/dmesg-quantal-xian-4:20140219012805:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01896-g037d40f:137
/kernel/i386-randconfig-an1-02182100/037d40fe91c5721054a8d1a61cd926dbdb75f968/dmesg-quantal-xian-6:20140219012809:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01896-g037d40f:137
/kernel/i386-randconfig-an1-02182100/037d40fe91c5721054a8d1a61cd926dbdb75f968/dmesg-yocto-xgwo-7:20140219012814:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01896-g037d40f:137
/kernel/i386-randconfig-an1-02182100/037d40fe91c5721054a8d1a61cd926dbdb75f968/dmesg-yocto-xian-15:20140219012818:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01896-g037d40f:137
/kernel/i386-randconfig-an1-02182100/037d40fe91c5721054a8d1a61cd926dbdb75f968/dmesg-yocto-xian-58:20140219012813:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01896-g037d40f:137
0:5:1 all_good:bad:all_bad boots

linear-bisect: bad branch may be alexshi/single-balance
linear-bisect: handle over to git bisect
linear-bisect: git bisect start 037d40fe91c5721054a8d1a61cd926dbdb75f968 6648c2574f90963cb0bc2421f00f173e9fdc8cc0 --
Previous HEAD position was 037d40f... Merge 'alexshi/single-balance' into devel-hourly-2014021821
HEAD is now at adc429b... Merge 'cgroup/review-kernfs-conversion' into devel-hourly-2014021518
Bisecting: 10 revisions left to test after this (roughly 3 steps)
[4a5d7c9f371d437e80369739bc7c38743f0d87c3] sched: rename update_*_cpu_load
linear-bisect: git bisect run /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:4a5d7c9f371d437e80369739bc7c38743f0d87c3:bisect-linux
2014-02-19 01:28:44: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/4a5d7c9f371d437e80369739bc7c38743f0d87c3' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-01:28:44 4a5d7c9f371d437e80369739bc7c38743f0d87c3 compiling
75 real  1247 user  111 sys  1792.44% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:30:30 detecting boot state 3.14.0-rc2-00010-g4a5d7c9.	1	8	23 SUCCESS

Bisecting: 5 revisions left to test after this (roughly 3 steps)
[480c3ba7685296b8da892020d408223e7abdc70b] sched: remove un-used functions
running /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:480c3ba7685296b8da892020d408223e7abdc70b:bisect-linux
2014-02-19 01:32:30: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/480c3ba7685296b8da892020d408223e7abdc70b' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-01:32:30 480c3ba7685296b8da892020d408223e7abdc70b compiling
16 real  35 user  5 sys  252.76% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:32:57 detecting boot state 3.14.0-rc2-00015-g480c3ba.	4	12	20	23 SUCCESS

Bisecting: 2 revisions left to test after this (roughly 2 steps)
[0e32dab5df39cfb1be9a937d67c877404b964324] sched/balance: rebuild ovutil tree after task moving
running /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:0e32dab5df39cfb1be9a937d67c877404b964324:bisect-linux
2014-02-19 01:35:28: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/0e32dab5df39cfb1be9a937d67c877404b964324' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-01:35:28 0e32dab5df39cfb1be9a937d67c877404b964324 compiling
15 real  31 user  4 sys  229.28% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:35:57 detecting boot state 3.14.0-rc2-00018-g0e32dab.	4	18	23 SUCCESS

Bisecting: 0 revisions left to test after this (roughly 1 step)
[98564060e5c360908d93f61a78ccbef4a082d3c2] sched/balance: add balance_interval to tuning top level balance frequency
running /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:98564060e5c360908d93f61a78ccbef4a082d3c2:bisect-linux
2014-02-19 01:37:58: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/98564060e5c360908d93f61a78ccbef4a082d3c2' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-01:37:58 98564060e5c360908d93f61a78ccbef4a082d3c2 compiling
14 real  38 user  5 sys  303.21% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:38:24 detecting boot state 3.14.0-rc2-00020-g9856406. TEST FAILURE
[    1.193365] softirq: huh, entered softirq 7 SCHED 4107f914 with preempt_count 00000100, exited with 00000101?
[    1.196698] softirq: huh, entered softirq 7 SCHED 4107f914 with preempt_count 00000100, exited with 00000101?
[    1.200031] softirq: huh, entered softirq 7 SCHED 4107f914 with preempt_count 00000100, exited with 00000101?
[    1.200768] BUG: MAX_LOCK_DEPTH too low!
[    1.201066] turning off the locking correctness validator.
[    1.201475] Please attach the output of /proc/lock_stat to the bug report
[    1.201957] depth: 48  max: 48!
[    1.202189] 48 locks held by swapper/0/1:
[    1.202484]  #0:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203091]  #1:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #2:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #3:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #4:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #5:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #6:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #7:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #8:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #9:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #10:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #11:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #12:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #13:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #14:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #15:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #16:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #17:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #18:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #19:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #20:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #21:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #22:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #23:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #24:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #25:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #26:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #27:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #28:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #29:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #30:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #31:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #32:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #33:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #34:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #35:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #36:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #37:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #38:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #39:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #40:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #41:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #42:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #43:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #44:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #45:  (rcu_read_lock){.+.+.+}, at: [<4107d29d>] rcu_read_lock+0x0/0x28
[    1.203349]  #46:  (&rq->lock){-.-.-.}, at: [<4158b4b8>] __schedule+0x7e/0x5ce
[    1.203349]  #47:  ((null)){.-.-..}, at: [<4158b573>] __schedule+0x139/0x5ce
/kernel/i386-randconfig-an1-02182100/98564060e5c360908d93f61a78ccbef4a082d3c2/dmesg-quantal-xian-1:20140219013837:i386-randconfig-an1-02182100:3.14.0-rc2-00020-g9856406:141
/kernel/i386-randconfig-an1-02182100/98564060e5c360908d93f61a78ccbef4a082d3c2/dmesg-yocto-athens-27:20140219013841:i386-randconfig-an1-02182100:3.14.0-rc2-00020-g9856406:141
/kernel/i386-randconfig-an1-02182100/98564060e5c360908d93f61a78ccbef4a082d3c2/dmesg-yocto-athens-2:20140219013842:i386-randconfig-an1-02182100:3.14.0-rc2-00020-g9856406:141
/kernel/i386-randconfig-an1-02182100/98564060e5c360908d93f61a78ccbef4a082d3c2/dmesg-yocto-athens-6:20140219013838:i386-randconfig-an1-02182100:3.14.0-rc2-00020-g9856406:141
/kernel/i386-randconfig-an1-02182100/98564060e5c360908d93f61a78ccbef4a082d3c2/dmesg-yocto-xian-33:20140219013837:i386-randconfig-an1-02182100:3.14.0-rc2-00020-g9856406:141
/kernel/i386-randconfig-an1-02182100/98564060e5c360908d93f61a78ccbef4a082d3c2/dmesg-yocto-xian-4:20140219013836:i386-randconfig-an1-02182100:3.14.0-rc2-00020-g9856406:141
0:6:6 all_good:bad:all_bad boots

Bisecting: 0 revisions left to test after this (roughly 0 steps)
[34c6c7844fd7ac6b7636614534d83c1099ab6fc7] sched/balance: add llc balance interval
running /c/kernel-tests/bisect-test-boot-failure.sh /kernel-tests/linux/obj-bisect
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:34c6c7844fd7ac6b7636614534d83c1099ab6fc7:bisect-linux
2014-02-19 01:38:55: cmd_fail: '/bin/grep' '-r' '--include=dmesg-*' '-s' '-l' 'BUG: MAX_LOCK_DEPTH too' '/kernel/i386-randconfig-an1-02182100/34c6c7844fd7ac6b7636614534d83c1099ab6fc7' , ret=2, ref: /kernel-tests/failed-cmd/bee-grep-kbuild.log

2014-02-19-01:38:55 34c6c7844fd7ac6b7636614534d83c1099ab6fc7 compiling
14 real  40 user  5 sys  306.77% cpu 	i386-randconfig-an1-02182100

2014-02-19-01:39:20 detecting boot state 3.14.0-rc2-00019-g34c6c78..	2	3	13	23 SUCCESS

98564060e5c360908d93f61a78ccbef4a082d3c2 is the first bad commit
commit 98564060e5c360908d93f61a78ccbef4a082d3c2
Author: Alex Shi <alex.shi@linaro.org>
Date:   Tue Feb 18 21:01:54 2014 +0800

    sched/balance: add balance_interval to tuning top level balance frequency
    
    Since central balance stains less cpu cache as current balance, we
    can set the balance interval more short.
    
    Signed-off-by: Alex Shi <alex.shi@linaro.org>

:040000 040000 1a5b5e08d930f1a88907b52e5c8403df0ea0bb21 1ac930e3f91d670e37d82a6b7e9d54e1f355f8d8 M	include
:040000 040000 bc7ea74ada5d7540e205c3feea69bdfd0c6155b6 9c27e6af630830a1a6973373abfb30a8929c5c8e M	kernel
bisect run success
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:34c6c7844fd7ac6b7636614534d83c1099ab6fc7:bisect-linux

2014-02-19-01:42:21 34c6c7844fd7ac6b7636614534d83c1099ab6fc7 reuse /kernel/i386-randconfig-an1-02182100/34c6c7844fd7ac6b7636614534d83c1099ab6fc7/vmlinuz-3.14.0-rc2-00019-g34c6c78

2014-02-19-01:42:21 detecting boot state ..	11	46	57	69 SUCCESS

ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:d5471974ffc0bd5cbf7213231e4d6276007cab37:bisect-linux
 TEST FAILURE
[    1.078906] audit: initializing netlink subsys (disabled)
[    1.078952] audit: type=2000 audit(1392733659.374:1): initialized
[    1.080493] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_count 00000100, exited with 00000101?
[    1.081238] [ BUG: cryptomgr_test/29 still has locks held! ]
[    1.081672] VFS: Disk quotas dquot_6.5.2
[    1.081674] 3.14.0-rc3-wl-ath-01897-gd547197 #4 Not tainted
[    1.081675] -------------------------------------
[    1.081676] 1 lock held by cryptomgr_test/29:
[    1.081702]  #0:  (rcu_read_lock){.+.+.+}, at: [<4107d10c>] rcu_read_lock+0x0/0x28
[    1.081702] 
[    1.081702] stack backtrace:
[    1.081706] CPU: 1 PID: 29 Comm: cryptomgr_test Not tainted 3.14.0-rc3-wl-ath-01897-gd547197 #4
[    1.081707] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.081709]  00000000 00000000 4c02dea8 415896ba 4c028090 4c02ded0 4108719a 4179a99e
[    1.081712]  417a9168 4179b52b 4c02832c 0000001d 4179abe1 417e872f 4c028090 4c02df14
[    1.081714]  41060dfe 00000006 4c028458 4c02825c 4c028088 4c02825c 00000001 4003eca0
[    1.081714] Call Trace:
[    1.081731]  [<415896ba>] dump_stack+0x48/0x60
[    1.081739]  [<4108719a>] debug_check_no_locks_held+0x76/0x7e
[    1.081745]  [<41060dfe>] do_exit+0x69d/0x6fd
[    1.081757]  [<4112522b>] ? crypto_unregister_pcomp+0xd/0xd
[    1.081759]  [<41125246>] cryptomgr_test+0x1b/0x1b
[    1.081763]  [<410717fe>] kthread+0x8e/0x93
[    1.081765]  [<41085f19>] ? trace_hardirqs_on+0xb/0xd
[    1.081767]  [<4108344a>] ? complete+0x12/0x35
[    1.081771]  [<415921f7>] ret_from_kernel_thread+0x1b/0x28
[    1.081772]  [<41071770>] ? __kthread_parkme+0x50/0x50
[    1.083355] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_count 00000101, exited with 00000102?
[    1.090018] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_count 00000101, exited with 00000102?
[    1.092746] softirq: huh, entered softirq 7 SCHED 4107f776 with preempt_count 00000100, exited with 00000101?
/kernel/i386-randconfig-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/dmesg-yocto-nhm4-4:20140219005714:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4
/kernel/i386-randconfig-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/dmesg-quantal-athens-39:20140218222753:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4
/kernel/i386-randconfig-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/dmesg-yocto-xps-4:20140219005710:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4
/kernel/i386-randconfig-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/dmesg-yocto-nhm4-1:20140219005710:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4
/kernel/i386-randconfig-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/dmesg-yocto-cairo-33:20140218222757:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4
/kernel/i386-randconfig-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/dmesg-yocto-athens-35:20140219005710:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4
/kernel/i386-randconfig-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/dmesg-yocto-xian-44:20140219005714:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4
/kernel/i386-randconfig-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/dmesg-yocto-xps-2:20140219005712:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4
/kernel/i386-randconfig-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/dmesg-yocto-athens-7:20140218222754:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4
/kernel/i386-randconfig-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/dmesg-yocto-xian-26:20140218222754:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4
/kernel/i386-randconfig-an1-02182100/d5471974ffc0bd5cbf7213231e4d6276007cab37/dmesg-yocto-xian-26:20140218222744:i386-randconfig-an1-02182100:3.14.0-rc3-wl-ath-01897-gd547197:4
0:11:19 all_good:bad:all_bad boots

[detached HEAD 7a455ad] Revert "sched/balance: add balance_interval to tuning top level balance frequency"
 Committer: Wu Fengguang <kbuild@bee>
Your name and email address were configured automatically based
on your username and hostname. Please check that they are accurate.
You can suppress this message by setting them explicitly:

    git config --global user.name "Your Name"
    git config --global user.email you@example.com

After doing this, you may fix the identity used for this commit with:

    git commit --amend --reset-author

 3 files changed, 19 deletions(-)
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:7a455ad6947d320cdf0234d07c4e4575b018cc11:bisect-linux

2014-02-19-01:45:24 7a455ad6947d320cdf0234d07c4e4575b018cc11 compiling

2014-02-19-01:46:51 detecting boot state 3.14.0-rc3-wl-ath-01898-g7a455ad..	9	27	31	55	65	69 SUCCESS


========= upstream =========
Warning: you are leaving 1 commit behind, not connected to
any of your branches:

  7a455ad Revert "sched/balance: add balance_interval to tuning top level balance frequency"

If you want to keep them by creating a new branch, this may be a good time
to do so with:

 git branch new_branch_name 7a455ad

HEAD is now at 60f76ea... Merge tag 'dma-buf-for-3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:60f76eab19e3903e810bdc3ec846c158efcd2e21:bisect-linux

2014-02-19-01:50:52 60f76eab19e3903e810bdc3ec846c158efcd2e21 compiling

2014-02-19-01:52:23 detecting boot state 3.14.0-rc3-00020-g60f76ea..	7	17	35	61	69 SUCCESS


========= linux-next =========
Previous HEAD position was 60f76ea... Merge tag 'dma-buf-for-3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/sumits/dma-buf
HEAD is now at 02d56d4... Add linux-next specific files for 20140218
ls -a /kernel-tests/run-queue/kvm/i386-randconfig-an1-02182100/linux-devel:devel-hourly-2014021821:02d56d4d19b8aa889c856287729d89c805ee42ec:bisect-linux

2014-02-19-01:55:56 02d56d4d19b8aa889c856287729d89c805ee42ec reuse /kernel/i386-randconfig-an1-02182100/02d56d4d19b8aa889c856287729d89c805ee42ec/vmlinuz-3.14.0-rc3-next-20140218-03475-g02d56d4

2014-02-19-01:55:56 detecting boot state ..	12	20	48	65	69 SUCCESS


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc3-wl-ath-01897-gd547197"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc3 Kernel Configuration
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
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
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
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_COMPILE_TEST=y
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
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
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
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
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
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
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
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
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
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
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
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
CONFIG_VMSPLIT_1G=y
CONFIG_PAGE_OFFSET=0x40000000
CONFIG_HIGHMEM=y
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
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

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
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
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
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_ATM=y
CONFIG_ATM_LANE=y
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_6LOWPAN_IPHC=y
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_HHF=y
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_BPF is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=y
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_EMATCH_CANID=y
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_CMTP=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIUART_3WIRE is not set
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_ATH3K is not set
CONFIG_BT_WILINK=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_MINSTREL_HT is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
# CONFIG_MAC80211_STA_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_PS_DEBUG=y
# CONFIG_MAC80211_TDLS_DEBUG is not set
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=y
CONFIG_NFC_NCI_SPI=y
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
CONFIG_NFC_WILINK=y
# CONFIG_NFC_SIM is not set
CONFIG_NFC_PORT100=y
CONFIG_NFC_PN544=y
# CONFIG_NFC_MICROREAD is not set
CONFIG_NFC_MRVL=y
CONFIG_NFC_MRVL_USB=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
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
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=y
# CONFIG_CAIF_VIRTIO is not set
# CONFIG_VHOST_NET is not set

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
CONFIG_KS8851=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
# CONFIG_NET_VENDOR_8390 is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
CONFIG_WIZNET_BUS_DIRECT=y
# CONFIG_WIZNET_BUS_INDIRECT is not set
# CONFIG_WIZNET_BUS_ANY is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MICREL_KS8995MA=y
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=y
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_NET_CX82310_ETH=y
CONFIG_USB_NET_KALMIA=y
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
# CONFIG_HDLC_CISCO is not set
# CONFIG_HDLC_FR is not set
CONFIG_HDLC_PPP=y

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DLCI is not set
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_AUDIO is not set
# CONFIG_ISDN_X25 is not set

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
# CONFIG_HISAX_EURO is not set
# CONFIG_HISAX_1TR6 is not set
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
# CONFIG_HISAX_16_3 is not set
# CONFIG_HISAX_TELESPCI is not set
# CONFIG_HISAX_S0BOX is not set
CONFIG_HISAX_FRITZPCI=y
# CONFIG_HISAX_AVM_A1_PCMCIA is not set
# CONFIG_HISAX_ELSA is not set
# CONFIG_HISAX_DIEHLDIVA is not set
# CONFIG_HISAX_SEDLBAUER is not set
# CONFIG_HISAX_NETJET is not set
# CONFIG_HISAX_NETJET_U is not set
CONFIG_HISAX_NICCY=y
# CONFIG_HISAX_BKM_A4T is not set
# CONFIG_HISAX_SCT_QUADRO is not set
CONFIG_HISAX_GAZEL=y
# CONFIG_HISAX_HFC_PCI is not set
# CONFIG_HISAX_W6692 is not set
# CONFIG_HISAX_HFC_SX is not set
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
# CONFIG_HISAX_ST5481 is not set
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=y
# CONFIG_HISAX_FRITZ_PCIPNP is not set

#
# Active cards
#
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
# CONFIG_CAPI_TRACE is not set
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
# CONFIG_ISDN_CAPI_CAPI20 is not set
# CONFIG_ISDN_CAPI_CAPIDRV is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_I4L is not set
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=y
CONFIG_GIGASET_M105=y
CONFIG_GIGASET_M101=y
# CONFIG_GIGASET_DEBUG is not set
CONFIG_MISDN=y
# CONFIG_MISDN_DSP is not set
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
# CONFIG_MISDN_HFCMULTI is not set
# CONFIG_MISDN_HFCUSB is not set
# CONFIG_MISDN_AVMFRITZ is not set
# CONFIG_MISDN_SPEEDFAX is not set
# CONFIG_MISDN_INFINEON is not set
# CONFIG_MISDN_W6692 is not set
# CONFIG_MISDN_NETJET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
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
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
# CONFIG_MOUSE_PS2_CYPRESS is not set
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_ADXL34X_SPI is not set
CONFIG_INPUT_IMS_PCU=y
CONFIG_INPUT_CMA3000=y
# CONFIG_INPUT_CMA3000_I2C is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
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
CONFIG_SERIAL_CLPS711X=y
CONFIG_SERIAL_CLPS711X_CONSOLE=y
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
# CONFIG_SERIAL_ST_ASC is not set
CONFIG_TTY_PRINTK=y
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

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
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RIIC is not set
# CONFIG_I2C_SH_MOBILE is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_RCAR is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_ATMEL=y
CONFIG_SPI_BCM2835=y
# CONFIG_SPI_BCM63XX_HSSPI is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
CONFIG_SPI_EP93XX=y
CONFIG_SPI_GPIO=y
# CONFIG_SPI_IMX is not set
# CONFIG_SPI_LM70_LLP is not set
CONFIG_SPI_FSL_DSPI=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_TI_QSPI is not set
CONFIG_SPI_OMAP_100K=y
CONFIG_SPI_ORION=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_SH=y
# CONFIG_SPI_SH_HSPI is not set
CONFIG_SPI_SUN6I=y
# CONFIG_SPI_TEGRA114 is not set
# CONFIG_SPI_TEGRA20_SFLASH is not set
CONFIG_SPI_TEGRA20_SLINK=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_TXX9 is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
# CONFIG_DP83640_PHY is not set
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TWL6040=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_PALMAS=y
# CONFIG_GPIO_TPS6586X is not set

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_LP8788=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_RCAR_THERMAL=y
CONFIG_INTEL_POWERCLAMP=y
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
CONFIG_SOFT_WATCHDOG=y
# CONFIG_DA9052_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_RETU_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_MAX8997 is not set
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
# CONFIG_REGULATOR_TPS80031 is not set
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=y
CONFIG_VIDEO_MEM2MEM_TESTDEV=y

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_BWQCAM=y
CONFIG_VIDEO_CQCAM=y
# CONFIG_VIDEO_W9966 is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_CYPRESS_FIRMWARE is not set

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
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
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
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_ML86V7667=y
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=y
# CONFIG_VIDEO_SAA7191 is not set
CONFIG_VIDEO_TVP514X=y
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=y
# CONFIG_VIDEO_TW9903 is not set
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=y
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=y
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_AK881X=y
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_VS6624=y
# CONFIG_VIDEO_MT9V011 is not set
CONFIG_VIDEO_SR030PC30=y

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set

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
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=y
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
# CONFIG_MEDIA_TUNER_FC0013 is not set
# CONFIG_MEDIA_TUNER_TDA18212 is not set
# CONFIG_MEDIA_TUNER_E4000 is not set
CONFIG_MEDIA_TUNER_FC2580=y
# CONFIG_MEDIA_TUNER_M88TS2022 is not set
# CONFIG_MEDIA_TUNER_TUA9001 is not set
# CONFIG_MEDIA_TUNER_IT913X is not set
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_V4L=y
# CONFIG_DVB_TUNER_DIB0070 is not set
CONFIG_DVB_TUNER_DIB0090=y

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
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
CONFIG_SOUND_TRACEINIT=y
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=y
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=y
CONFIG_SOUND_MPU401=y
# CONFIG_SOUND_PAS is not set
CONFIG_SOUND_PSS=y
CONFIG_PSS_MIXER=y
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=y
CONFIG_SOUND_YM3812=y
CONFIG_SOUND_UART6850=y
# CONFIG_SOUND_AEDSP16 is not set
CONFIG_SOUND_KAHLUA=y

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
# CONFIG_USB_DWC3_EXYNOS is not set
CONFIG_USB_DWC3_PCI=y
CONFIG_USB_DWC3_KEYSTONE=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
# CONFIG_USB_DWC2 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
CONFIG_USB_XUSBATM=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
CONFIG_KEYSTONE_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_TAHVO_USB=y
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_RCAR_GEN2_PHY=y
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_OMAP_HS is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
# CONFIG_MMC_USHC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
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
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_MAX14577 is not set
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_PALMAS=y
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
CONFIG_HID_SENSOR_ACCEL_3D=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
# CONFIG_AD7476 is not set
CONFIG_AD7791=y
CONFIG_AD7793=y
# CONFIG_AD7887 is not set
CONFIG_AD7923=y
CONFIG_LP8788_ADC=y
# CONFIG_MAX1363 is not set
CONFIG_MCP320X=y
CONFIG_MCP3422=y
# CONFIG_NAU7802 is not set
# CONFIG_TI_ADC081C is not set
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
CONFIG_AD5504=y
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5686=y
# CONFIG_AD5755 is not set
CONFIG_AD5764=y
# CONFIG_AD5791 is not set
# CONFIG_AD7303 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
CONFIG_ADIS16136=y
# CONFIG_ADIS16260 is not set
CONFIG_ADXRS450=y
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
CONFIG_ITG3200=y

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=y

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
# CONFIG_CM32181 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_HID_SENSOR_ALS is not set
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_MAG3110=y
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_MPL3115=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_RENESAS_TPU=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FSNOTIFY is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_PSTORE is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
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
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MMC_REQUEST is not set
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
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
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
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
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
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
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
CONFIG_KVM_AMD=y
# CONFIG_LGUEST is not set
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
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
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--fUYQa+Pmc3FrFX/N--
