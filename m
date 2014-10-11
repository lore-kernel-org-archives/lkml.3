Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaJKFaC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 01:30:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:59292 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaJKF37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 01:29:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="yaml'?scan'208";a="398601403"
Date: Sat, 11 Oct 2014 13:29:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: [drm/i915] 5ba60fc3d71:
 dmesg.WARNING:at_drivers/gpu/drm/i915/intel_pm.c:sandybridge_pcode_write_i915()
Message-ID: <20141011052935.GE21803@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GZVR6ND4mMseVXL/"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://gitorious.org/vsyrjala/linux cdclk_3
commit 5ba60fc3d719988a404d35a3e46f109bea643fef ("drm/i915: BDW cdclk change support")


testbox/testcase/testparams: lkp-bdw01/boot/1

8df76759beb2354a  5ba60fc3d719988a404d35a3e4  
----------------  --------------------------  
       fail:runs  %reproduction    fail:runs
           |             |             |    
           :1           20%           1:5     dmesg.WARNING:at_drivers/gpu/drm/i915/intel_pm.c:sandybridge_pcode_write_i915()
          3:10         -30%            :5     dmesg.WARNING:at_drivers/gpu/drm/i915/i915_irq.c:gen8_irq_power_well_post_enable_i915()

To reproduce:

	apt-get install ruby ruby-oj
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/wfg/lkp-tests.git
	cd lkp-tests
	bin/setup-local job.yaml # the job file attached in this email
	bin/run-local   job.yaml

Attached 2 dmesg outputs for commit 5ba60fc3d719988a404d35a3e4.

Thanks,
Fengguang

--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
testcase: boot
default_monitors:
  boottime: 
  kernel-size: 
default_watchdogs:
  watch-oom: 
  watchdog: 
model: Broadwell ULT
memory: 4G
nr_ssd_partitions: 1
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2CW120A3_CVCV252505YF120BGN-part1"
rootfs_partition: "/dev/disk/by-id/ata-INTEL_SSDSC2CW120A3_CVCV252505YF120BGN-part2"
boot-meminfo: 
boot-slabinfo: 
boot-memory: 
memmap: 
bootmem: 
sleep: 1
branch: linux-devel/devel-hourly-2014100721
commit: 58b9cff9104be12815b5d3f95210ea0c14f0b7e7
repeat_to: 1
enqueue_time: 2014-10-07 22:33:20.253277392 +08:00
testbox: lkp-bdw01
kconfig: x86_64-rhel
kernel: "/kernel/x86_64-rhel/58b9cff9104be12815b5d3f95210ea0c14f0b7e7/vmlinuz-3.17.0-wl-g58b9cff"
user: lkp
queue: boot
result_root: "/result/lkp-bdw01/boot/1/debian-x86_64.cgz/x86_64-rhel/58b9cff9104be12815b5d3f95210ea0c14f0b7e7/0"
job_file: "/lkp/scheduled/lkp-bdw01/boot_boot-1-x86_64-rhel-58b9cff9104be12815b5d3f95210ea0c14f0b7e7-0.yaml"
dequeue_time: 2014-10-07 23:13:18.189000346 +08:00
job_state: finished
loadavg: 0.11 0.03 0.01 1/90 1956
start_time: '1412694834'
end_time: '1412694835'
version: "/lkp/lkp/.src-20141007-214742"

--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-0

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-g5ba60fc (kbuild@cairo) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Sat Oct 11 12:38:06 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-bdw01/bisect_boot-1-x86_64-rhel-5ba60fc3d719988a404d35a3e46f109bea643fef-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/vmlinuz-3.17.0-rc7-g5ba60fc kconfig=x86_64-rhel commit=5ba60fc3d719988a404d35a3e46f109bea643fef branch=linux-devel/devel-hourly-2014100721 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-bdw01/boot/1/debian-x86_64.cgz/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/0 ip=::::lkp-bdw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009a3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009a400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009df19fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009df1a000-0x000000009df38fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009df39000-0x00000000ab262fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ab263000-0x00000000ab762fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ab763000-0x00000000ab7b5fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ab7b6000-0x00000000ab7e1fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000ab7e2000-0x00000000ab7fefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ab7ff000-0x00000000af7fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed84000-0x00000000fed84fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed90000-0x00000000fed91fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000014f7fffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation Broadwell Client platform/WhiteTip Mountain 1, BIOS BDW-E1R1.86C.0079.R00.1406020127 06/02/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x14f800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00C0000000 mask 7FC0000000 uncachable
[    0.000000]   1 base 00B0000000 mask 7FF0000000 uncachable
[    0.000000]   2 base 00AE000000 mask 7FFE000000 uncachable
[    0.000000]   3 base 00AD000000 mask 7FFF000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xab7ff max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009a400-0x0009a7ff]
[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x14f177000, 0x14f177fff] PGTABLE
[    0.000000] BRK [0x14f178000, 0x14f178fff] PGTABLE
[    0.000000] BRK [0x14f179000, 0x14f179fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x14f600000-0x14f7fffff]
[    0.000000]  [mem 0x14f600000-0x14f7fffff] page 2M
[    0.000000] BRK [0x14f17a000, 0x14f17afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x14c000000-0x14f5fffff]
[    0.000000]  [mem 0x14c000000-0x14f5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x14bffffff]
[    0.000000]  [mem 0x100000000-0x13fffffff] page 1G
[    0.000000]  [mem 0x140000000-0x14bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x9df19fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0x9ddfffff] page 2M
[    0.000000]  [mem 0x9de00000-0x9df19fff] page 4k
[    0.000000] BRK [0x14f17b000, 0x14f17bfff] PGTABLE
[    0.000000] BRK [0x14f17c000, 0x14f17cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x9df39000-0xab262fff]
[    0.000000]  [mem 0x9df39000-0x9dffffff] page 4k
[    0.000000]  [mem 0x9e000000-0xab1fffff] page 2M
[    0.000000]  [mem 0xab200000-0xab262fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xab7e2000-0xab7fefff]
[    0.000000]  [mem 0xab7e2000-0xab7fefff] page 4k
[    0.000000] RAMDISK: [mem 0x1466d3000-0x14dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000AB7C8188 000114 (v01 INTEL  BDW-ULT  00000000      01000013)
[    0.000000] ACPI: FACP 0x00000000AB7D7000 0000F4 (v05 INTEL  BDW-ULT  00000000 MSFT 0000005F)
[    0.000000] ACPI: DSDT 0x000000009DF1A000 01E50D (v02 INTEL  BDW      00000000 INTL 20130927)
[    0.000000] ACPI: FACS 0x00000000AB79D000 000040
[    0.000000] ACPI: TCPA 0x00000000AB7DF000 000032 (v02 INTEL  EDK2     00000002      01000013)
[    0.000000] ACPI: UEFI 0x00000000AB7A0000 000042 (v01 INTEL  EDK2     00000002      01000013)
[    0.000000] ACPI: SSDT 0x00000000AB7DE000 0004B5 (v01 Intel_ Tpm2Tabl 00001000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7DD000 00004E (v01 MeSsdt MeSsdt   00003000 INTL 20130927)
[    0.000000] ACPI: TPM2 0x00000000AB7DC000 000034 (v03                 00000000      00000000)
[    0.000000] ACPI: SSDT 0x00000000AB7DB000 0005B1 (v01 Intel  PerfTune 00001000 INTL 20130927)
[    0.000000] ACPI: DBGP 0x00000000AB7DA000 000034 (v01 INTEL           00000000 MSFT 0000005F)
[    0.000000] ACPI: DBG2 0x00000000AB7D9000 000054 (v00 INTEL           00000000 MSFT 0000005F)
[    0.000000] ACPI: LPIT 0x00000000AB7D8000 000094 (v01 INTEL  BDW-ULT  00000000 MSFT 0000005F)
[    0.000000] ACPI: HPET 0x00000000AB7D6000 000038 (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
[    0.000000] ACPI: APIC 0x00000000AB7D5000 0000BC (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
[    0.000000] ACPI: MCFG 0x00000000AB7D4000 00003C (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
[    0.000000] ACPI: WDAT 0x00000000AB7D3000 000104 (v01 INTEL  BDW-ULT  00000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x00000000AB7D2000 000250 (v01 INTEL  sensrhub 00000000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7CE000 00340B (v01 INTEL  PtidDevc 00001000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7CD000 000C7D (v01 INTEL  Ther_Rvp 00001000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7CC000 00017F (v01 INTEL  zpodd    00001000 INTL 20130927)
[    0.000000] ACPI: BOOT 0x00000000AB7CB000 000028 (v01 INTEL  TIANO    00000002 MSFT 01000013)
[    0.000000] ACPI: SSDT 0x00000000AB7CA000 0004D8 (v01 PmRef  Cpu0Ist  00003000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7C9000 000B74 (v01 CpuRef CpuSsdt  00003000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7C1000 006F06 (v01 SaSsdt SaSsdt   00003000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7E0000 0006A7 (v01 CppcTa CppcTabl 00001000 INTL 20130927)
[    0.000000] ACPI: PCCT 0x00000000AB7C0000 00006E (v05 PcctTa PcctTabl 00001000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7BF000 000AC4 (v01 Cpc_Ta Cpc_Tabl 00001000 INTL 20130927)
[    0.000000] ACPI: CSRT 0x00000000AB7BE000 0000C4 (v01 INTL   BDW-ULT  00000001 INTL 20100528)
[    0.000000] ACPI: DMAR 0x00000000AB7BD000 0000F0 (v01 INTEL  BDW      00000001 INTL 00000001)
[    0.000000] ACPI: FPDT 0x00000000AB7BC000 000044 (v01 INTEL  EDK2     00000002      01000013)
[    0.000000] ACPI: ASF! 0x00000000AB7BB000 0000A0 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[    0.000000] ACPI: BGRT 0x00000000AB7BA000 000038 (v01 INTEL  EDK2     00000002      01000013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000014f7fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x14f7fffff]
[    0.000000]   NODE_DATA [mem 0x14f7d8000-0x14f7fdfff]
[    0.000000]  [ffffea0000000000-ffffea00053fffff] PMD -> [ffff880142200000-ffff8801461fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x14f7fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
[    0.000000]   node   0: [mem 0x00100000-0x9df19fff]
[    0.000000]   node   0: [mem 0x9df39000-0xab262fff]
[    0.000000]   node   0: [mem 0xab7e2000-0xab7fefff]
[    0.000000]   node   0: [mem 0x100000000-0x14f7fffff]
[    0.000000] On node 0 totalpages: 1026554
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3993 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10890 pages used for memmap
[    0.000000]   DMA32 zone: 696929 pages, LIFO batch:31
[    0.000000]   Normal zone: 5088 pages used for memmap
[    0.000000]   Normal zone: 325632 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xad800000-0xaf7fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009afff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9df1a000-0x9df38fff]
[    0.000000] PM: Registered nosave memory: [mem 0xab263000-0xab762fff]
[    0.000000] PM: Registered nosave memory: [mem 0xab763000-0xab7b5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xab7b6000-0xab7e1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xab7ff000-0xaf7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xaf800000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfed83fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed84000-0xfed84fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed85000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfed91fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed92000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xff9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffa00000-0xffffffff]
[    0.000000] e820: [mem 0xaf800000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88014f400000 s88960 r8192 d21632 u262144
[    0.000000] pcpu-alloc: s88960 r8192 d21632 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1010491
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-bdw01/bisect_boot-1-x86_64-rhel-5ba60fc3d719988a404d35a3e46f109bea643fef-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/vmlinuz-3.17.0-rc7-g5ba60fc kconfig=x86_64-rhel commit=5ba60fc3d719988a404d35a3e46f109bea643fef branch=linux-devel/devel-hourly-2014100721 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-bdw01/boot/1/debian-x86_64.cgz/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/0 ip=::::lkp-bdw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 3831208K/4106216K available (8595K kernel code, 1702K rwdata, 3832K rodata, 1804K init, 1888K bss, 275008K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:524544 nr_irqs:760 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1596.353 MHz processor
[    0.000041] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.70 BogoMIPS (lpj=1596353)
[    0.012065] pid_max: default: 32768 minimum: 301
[    0.017297] ACPI: Core revision 20140724
[    0.061342] ACPI: All ACPI Tables successfully acquired
[    0.067312] Security Framework initialized
[    0.071952] SELinux:  Initializing.
[    0.075905] SELinux:  Starting in permissive mode
[    0.081614] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.090891] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.099351] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.106944] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.115263] Initializing cgroup subsys memory
[    0.120199] Initializing cgroup subsys devices
[    0.125228] Initializing cgroup subsys freezer
[    0.130260] Initializing cgroup subsys net_cls
[    0.135290] Initializing cgroup subsys blkio
[    0.140124] Initializing cgroup subsys perf_event
[    0.145450] Initializing cgroup subsys hugetlb
[    0.150507] CPU: Physical Processor ID: 0
[    0.155045] CPU: Processor Core ID: 1
[    0.160481] mce: CPU supports 7 MCE banks
[    0.165029] CPU0: Thermal LVT vector (0xfa) already installed
[    0.171541] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.171541] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.184913] Freeing SMP alternatives memory: 36K (ffffffff81f94000 - ffffffff81f9d000)
[    0.195174] ftrace: allocating 31083 entries in 122 pages
[    0.219761] Getting VERSION: 1060015
[    0.223808] Getting VERSION: 1060015
[    0.227854] Getting ID: 2000000
[    0.231409] Getting ID: 2000000
[    0.234973] dmar: Host address width 39
[    0.239315] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.245334] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 7e1ff0505e
[    0.254989] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.261007] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap d2008c20660462 ecap f010da
[    0.270169] dmar: RMRR base: 0x000000ab6f2000 end: 0x000000ab705fff
[    0.277266] dmar: RMRR base: 0x000000ad000000 end: 0x000000af7fffff
[    0.284361] dmar: ANDD device: 1 name: \_SB.PCI0.SDMA
[    0.290080] dmar: ANDD device: 2 name: \_SB.PCI0.SDHC
[    0.295924] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.302226] HPET id 0 under DRHD base 0xfed91000
[    0.307453] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.316319] Your BIOS is broken and requested that x2apic be disabled.
[    0.316319] This will slightly decrease performance.
[    0.316319] Use 'intremap=no_x2apic_optout' to override BIOS request.
[    0.336875] Enabled IRQ remapping in xapic mode
[    0.342005] x2apic not enabled, IRQ remapping is in xapic mode
[    0.348615] masked ExtINT on CPU#0
[    0.352909] ENABLING IO-APIC IRQs
[    0.356661] init IO_APIC IRQs
[    0.360019]  apic 2 pin 0 not connected
[    0.364363] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.373323] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.388589] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.397556] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.412814] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.421795] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.437062] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.446030] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.461296] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.470264] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.485531] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.494500] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:35 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.509767] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.518736] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:36 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.534001] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.542973] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:37 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.558239] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.567208] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.582474] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.591444] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.606709] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.615874] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3A Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.631138] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.640303] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3B Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.655569] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.664737] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3C Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.680003] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.689171] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.704437] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.713604] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3E Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.728869] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.738034] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3F Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.753300]  apic 2 pin 16 not connected
[    0.757742]  apic 2 pin 17 not connected
[    0.762183]  apic 2 pin 18 not connected
[    0.766624]  apic 2 pin 19 not connected
[    0.771063]  apic 2 pin 20 not connected
[    0.775502]  apic 2 pin 21 not connected
[    0.779942]  apic 2 pin 22 not connected
[    0.784383]  apic 2 pin 23 not connected
[    0.788824]  apic 2 pin 24 not connected
[    0.793265]  apic 2 pin 25 not connected
[    0.797706]  apic 2 pin 26 not connected
[    0.802148]  apic 2 pin 27 not connected
[    0.806589]  apic 2 pin 28 not connected
[    0.811030]  apic 2 pin 29 not connected
[    0.815471]  apic 2 pin 30 not connected
[    0.819912]  apic 2 pin 31 not connected
[    0.824354]  apic 2 pin 32 not connected
[    0.828795]  apic 2 pin 33 not connected
[    0.833236]  apic 2 pin 34 not connected
[    0.837677]  apic 2 pin 35 not connected
[    0.842118]  apic 2 pin 36 not connected
[    0.846560]  apic 2 pin 37 not connected
[    0.851001]  apic 2 pin 38 not connected
[    0.855442]  apic 2 pin 39 not connected
[    0.860028] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.876823] smpboot: CPU0: Genuine Intel(R) CPU 0000 @ 1.60GHz (fam: 06, model: 3d, stepping: 03)
[    0.886917] TSC deadline timer enabled
[    0.891189] Performance Events: PEBS fmt2+, generic architected perfmon, full-width counters, Intel PMU driver.
[    0.902664] ... version:                3
[    0.907195] ... bit width:              48
[    0.911831] ... generic registers:      4
[    0.916368] ... value mask:             0000ffffffffffff
[    0.922384] ... max period:             0000ffffffffffff
[    0.928398] ... fixed-purpose events:   3
[    0.932937] ... event mask:             000000070000000f
[    0.941254] x86: Booting SMP configuration:
[    0.945994] .... node  #0, CPUs:      #1
[    0.961365] masked ExtINT on CPU#1
[    0.966721] CPU1: Thermal LVT vector (0xfa) already installed
[    0.975393] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.984557]  #2
[    0.997445] masked ExtINT on CPU#2
[    1.002802] CPU2: Thermal LVT vector (0xfa) already installed
[    1.011486]  #3
[    1.024442] masked ExtINT on CPU#3
[    1.029837] CPU3: Thermal LVT vector (0xfa) already installed
[    1.038412] x86: Booted up 1 node, 4 CPUs
[    1.042956] smpboot: Total of 4 processors activated (12770.82 BogoMIPS)
[    1.056750] devtmpfs: initialized
[    1.063136] evm: security.selinux
[    1.066890] evm: security.ima
[    1.070250] evm: security.capability
[    1.074446] PM: Registering ACPI NVS region [mem 0xab763000-0xab7b5fff] (339968 bytes)
[    1.084590] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    1.092604] NET: Registered protocol family 16
[    1.097884] cpuidle: using governor menu
[    1.102470] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    1.111044] ACPI: bus type PCI registered
[    1.115584] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.122966] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.133500] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.141589] PCI: Using configuration type 1 for base access
[    1.152320] ACPI: Added _OSI(Module Device)
[    1.157060] ACPI: Added _OSI(Processor Device)
[    1.162094] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.167411] ACPI: Added _OSI(Processor Aggregator Device)
[    1.177929] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:15)
[    1.187003] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    1.210254] ACPI: Executed 18 blocks of module-level executable AML code
[    1.237548] ACPI: Dynamic OEM Table Load:
[    1.242134] ACPI: SSDT 0xFFFF88013FCB1800 0004AE (v01 PmRef  Cpu0Cst  00003001 INTL 20130927)
[    1.256670] ACPI: Dynamic OEM Table Load:
[    1.261256] ACPI: SSDT 0xFFFF88013FED8000 000792 (v01 PmRef  ApIst    00003000 INTL 20130927)
[    1.274535] ACPI: Dynamic OEM Table Load:
[    1.279113] ACPI: SSDT 0xFFFF88013FED4E00 000119 (v01 PmRef  ApCst    00003000 INTL 20130927)
[    1.297375] ACPI: Interpreter enabled
[    1.301533] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
[    1.312044] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    1.322571] ACPI: (supports S0 S3 S4 S5)
[    1.327018] ACPI: Using IOAPIC for interrupt routing
[    1.332694] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.343638] ACPI: Power Resource [PG00] (on)
[    1.354688] ACPI: Power Resource [PG01] (on)
[    1.363680] ACPI: Power Resource [PG02] (on)
[    1.395319] acpi ABCD0000:00: ACPI dock station (docks/bays count: 1)
[    1.404126] ACPI: Power Resource [FN00] (off)
[    1.409153] ACPI: Power Resource [FN01] (off)
[    1.414175] ACPI: Power Resource [FN02] (on)
[    1.419437] ACPI: Power Resource [FN03] (on)
[    1.424405] ACPI: Power Resource [FN04] (off)
[    1.430676] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    1.437698] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.448071] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    1.458490] PCI host bridge to bus 0000:00
[    1.463133] pci_bus 0000:00: root bus resource [bus 00-fe]
[    1.469368] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.476390] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.483413] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.491225] pci_bus 0000:00: root bus resource [mem 0xaf800000-0xfeafffff]
[    1.499041] pci 0000:00:00.0: [8086:1604] type 00 class 0x060000
[    1.506164] pci 0000:00:02.0: [8086:1616] type 00 class 0x030000
[    1.512995] pci 0000:00:02.0: reg 0x10: [mem 0xc0000000-0xc0ffffff 64bit]
[    1.520691] pci 0000:00:02.0: reg 0x18: [mem 0xb0000000-0xbfffffff 64bit pref]
[    1.528891] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
[    1.535517] pci 0000:00:03.0: [8086:160c] type 00 class 0x040300
[    1.542346] pci 0000:00:03.0: reg 0x10: [mem 0xc1130000-0xc1133fff 64bit]
[    1.550370] pci 0000:00:14.0: [8086:9cb1] type 00 class 0x0c0330
[    1.557199] pci 0000:00:14.0: reg 0x10: [mem 0xc1120000-0xc112ffff 64bit]
[    1.564967] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    1.571833] pci 0000:00:14.0: System wakeup disabled by ACPI
[    1.578305] pci 0000:00:16.0: [8086:9cba] type 00 class 0x078000
[    1.585144] pci 0000:00:16.0: reg 0x10: [mem 0xc1135000-0xc113501f 64bit]
[    1.592912] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.600122] pci 0000:00:19.0: [8086:15a2] type 00 class 0x020000
[    1.606950] pci 0000:00:19.0: reg 0x10: [mem 0xc1100000-0xc111ffff]
[    1.614070] pci 0000:00:19.0: reg 0x14: [mem 0xc1138000-0xc1138fff]
[    1.621190] pci 0000:00:19.0: reg 0x18: [io  0x3080-0x309f]
[    1.627564] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.634732] pci 0000:00:19.0: System wakeup disabled by ACPI
[    1.641205] pci 0000:00:1c.0: [8086:9c90] type 01 class 0x060400
[    1.648100] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.655265] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.661742] pci 0000:00:1f.0: [8086:9cc3] type 00 class 0x060100
[    1.668959] pci 0000:00:1f.2: [8086:9c83] type 00 class 0x010601
[    1.675793] pci 0000:00:1f.2: reg 0x10: [io  0x30a8-0x30af]
[    1.682125] pci 0000:00:1f.2: reg 0x14: [io  0x30b4-0x30b7]
[    1.688457] pci 0000:00:1f.2: reg 0x18: [io  0x30a0-0x30a7]
[    1.694790] pci 0000:00:1f.2: reg 0x1c: [io  0x30b0-0x30b3]
[    1.701121] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
[    1.707453] pci 0000:00:1f.2: reg 0x24: [mem 0xc1137000-0xc11377ff]
[    1.714607] pci 0000:00:1f.2: PME# supported from D3hot
[    1.720817] pci 0000:00:1f.3: [8086:9ca2] type 00 class 0x0c0500
[    1.727649] pci 0000:00:1f.3: reg 0x10: [mem 0xc1134000-0xc11340ff 64bit]
[    1.735372] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    1.741980] pci 0000:00:1f.6: [8086:9ca4] type 00 class 0x118000
[    1.748831] pci 0000:00:1f.6: reg 0x10: [mem 0xc1136000-0xc1136fff 64bit]
[    1.756999] pci 0000:01:00.0: [8086:08b1] type 00 class 0x028000
[    1.763858] pci 0000:01:00.0: reg 0x10: [mem 0xc1000000-0xc1001fff 64bit]
[    1.771753] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    1.778710] pci 0000:01:00.0: System wakeup disabled by ACPI
[    1.787140] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.792783] pci 0000:00:1c.0:   bridge window [mem 0xc1000000-0xc10fffff]
[    1.800499] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    1.811482] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    1.820571] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.829863] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    1.838945] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    1.847993] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    1.857057] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.866346] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.875635] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.885477] ACPI: Enabled 4 GPEs in block 00 to 7F
[    1.891212] ACPI : EC: GPE = 0xa, I/O: command/status = 0x66, data = 0x62
[    1.899061] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.905468] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.914657] vgaarb: loaded
[    1.917722] vgaarb: bridge control possible 0000:00:02.0
[    1.923840] SCSI subsystem initialized
[    1.928143] ACPI: bus type USB registered
[    1.932724] usbcore: registered new interface driver usbfs
[    1.938980] usbcore: registered new interface driver hub
[    1.945077] usbcore: registered new device driver usb
[    1.950901] pps_core: LinuxPPS API ver. 1 registered
[    1.956525] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.966877] PTP clock support registered
[    1.971403] PCI: Using ACPI for IRQ routing
[    1.982379] PCI: pci_cache_line_size set to 64 bytes
[    1.988037] e820: reserve RAM buffer [mem 0x0009a400-0x0009ffff]
[    1.994841] e820: reserve RAM buffer [mem 0x9df1a000-0x9fffffff]
[    2.001645] e820: reserve RAM buffer [mem 0xab263000-0xabffffff]
[    2.008447] e820: reserve RAM buffer [mem 0xab7ff000-0xabffffff]
[    2.015250] e820: reserve RAM buffer [mem 0x14f800000-0x14fffffff]
[    2.022378] NetLabel: Initializing
[    2.026233] NetLabel:  domain hash size = 128
[    2.031166] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.036803] NetLabel:  unlabeled traffic allowed by default
[    2.043248] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    2.050348] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.058987] Switched to clocksource hpet
[    2.074712] pnp: PnP ACPI init
[    2.078568] system 00:00: [io  0x06a4] has been reserved
[    2.084592] system 00:00: [io  0x06a0] has been reserved
[    2.090611] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.098545] system 00:01: [io  0x0680-0x069f] has been reserved
[    2.105246] system 00:01: [io  0xffff] has been reserved
[    2.111269] system 00:01: [io  0xffff] has been reserved
[    2.117287] system 00:01: [io  0xffff] has been reserved
[    2.123306] system 00:01: [io  0x1800-0x18fe] could not be reserved
[    2.130406] system 00:01: [io  0x164e-0x164f] has been reserved
[    2.137112] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.144839] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    2.153914] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    2.169201] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.176640] system 00:03: [io  0x1854-0x1857] has been reserved
[    2.183348] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    2.191947] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
[    2.201018] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    2.216303] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.223772] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
[    2.232842] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    2.248127] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.256296] system 00:06: [mem 0xfe102000-0xfe102fff] has been reserved
[    2.263791] system 00:06: [mem 0xfe104000-0xfe104fff] has been reserved
[    2.271286] system 00:06: [mem 0xfe106000-0xfe106fff] has been reserved
[    2.278779] system 00:06: [mem 0xfe10e000-0xfe10efff] has been reserved
[    2.286273] system 00:06: [mem 0xfe112000-0xfe112fff] has been reserved
[    2.293766] system 00:06: [mem 0xfe111000-0xfe111007] has been reserved
[    2.301262] system 00:06: [mem 0xfe111014-0xfe111fff] has been reserved
[    2.308756] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.317970] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.325466] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    2.332959] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.340453] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.347947] system 00:07: [mem 0xe0000000-0xefffffff] has been reserved
[    2.355441] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.362934] system 00:07: [mem 0xfed90000-0xfed93fff] could not be reserved
[    2.370822] system 00:07: [mem 0xfed45000-0xfed8ffff] could not be reserved
[    2.378710] system 00:07: [mem 0xff000000-0xffffffff] could not be reserved
[    2.386597] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    2.394484] system 00:07: [mem 0xaf810000-0xaf81ffff] has been reserved
[    2.401978] system 00:07: [mem 0xaf800000-0xaf80ffff] has been reserved
[    2.409472] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.417448] system 00:08: [mem 0x00000000-0x0009cfff] could not be reserved
[    2.425338] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.433198] pnp: PnP ACPI: found 9 devices
[    2.444327] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    2.449958] pci 0000:00:1c.0:   bridge window [mem 0xc1000000-0xc10fffff]
[    2.457656] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.463961] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.470274] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.477374] pci_bus 0000:00: resource 7 [mem 0xaf800000-0xfeafffff]
[    2.484474] pci_bus 0000:01: resource 1 [mem 0xc1000000-0xc10fffff]
[    2.491613] NET: Registered protocol family 2
[    2.496772] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    2.505050] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    2.512620] TCP: Hash tables configured (established 32768 bind 32768)
[    2.520037] TCP: reno registered
[    2.523700] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    2.530522] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.537884] NET: Registered protocol family 1
[    2.542917] RPC: Registered named UNIX socket transport module.
[    2.549627] RPC: Registered udp transport module.
[    2.554956] RPC: Registered tcp transport module.
[    2.560283] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.567594] pci 0000:00:02.0: Video device with shadowed ROM
[    2.574120] pci 0000:00:14.0: can't derive routing for PCI INT A
[    2.580926] pci 0000:00:14.0: PCI INT A: no GSI
[    2.586157] pci 0000:00:14.0: can't derive routing for PCI INT A
[    2.592982] PCI: CLS 0 bytes, default 64
[    2.597492] Unpacking initramfs...
[    5.718946] Freeing initrd memory: 124084K (ffff8801466d3000 - ffff88014e000000)
[    5.727368] dmar: ACPI device "INTL9C60:00" under DMAR at fed91000 as 00:15.0
[    5.735480] dmar: ACPI device "INT3436:00" under DMAR at fed91000 as 00:17.0
[    5.743474] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.750773] software IO TLB [mem 0xa7263000-0xab263000] (64MB) mapped at [ffff8800a7263000-ffff8800ab262fff]
[    5.762059] Simple Boot Flag at 0x47 set to 0x80
[    5.768221] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    5.775350] Initialise system trusted keyring
[    5.780309] audit: initializing netlink subsys (disabled)
[    5.786441] audit: type=2000 audit(1413031342.190:1): initialized
[    5.793722] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.802808] zpool: loaded
[    5.805778] zbud: loaded
[    5.808863] VFS: Disk quotas dquot_6.5.2
[    5.813354] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.821238] SGI XFS with ACLs, security attributes, no debug enabled
[    5.828872] 9p: Installing v9fs 9p2000 file system support
[    5.835129] msgmni has been set to 7725
[    5.839547] Key type big_key registered
[    5.843896] SELinux:  Registering netfilter hooks
[    5.849869] NET: Registered protocol family 38
[    5.854917] Key type asymmetric registered
[    5.859561] Asymmetric key parser 'x509' registered
[    5.865137] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    5.873563] io scheduler noop registered
[    5.878014] io scheduler deadline registered (default)
[    5.883846] io scheduler cfq registered
[    5.888415] IOAPIC[0]: Set routing entry (2-16 -> 0x61 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    5.897690] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:61 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    5.912991] pcieport 0000:00:1c.0: irq 42 for MSI/MSI-X
[    5.919011] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    5.926901] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    5.934300] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    5.941914] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.948246] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.955789] intel_idle: MWAIT substates: 0x11142120
[    5.961316] intel_idle: v0.4 model 0x3D
[    5.965662] intel_idle: lapic_timer_reliable_states 0xffffffff
[    5.972638] ACPI: AC Adapter [ADP1] (off-line)
[    5.977813] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    5.987226] ACPI: Lid Switch [LID0]
[    5.991237] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    6.000701] ACPI: Power Button [PWRB]
[    6.004889] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    6.014354] ACPI: Sleep Button [SLPB]
[    6.018546] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    6.026926] ACPI: Power Button [PWRF]
[    6.031161] ACPI: Fan [FAN0] (off)
[    6.035045] ACPI: Fan [FAN1] (off)
[    6.038924] ACPI: Fan [FAN2] (on)
[    6.042708] ACPI: Fan [FAN3] (on)
[    6.046489] ACPI: Fan [FAN4] (off)
[    6.057758] thermal LNXTHERM:00: registered as thermal_zone0
[    6.064174] ACPI: Thermal Zone [TZ00] (52 C)
[    6.069803] thermal LNXTHERM:01: registered as thermal_zone1
[    6.076217] ACPI: Thermal Zone [TZ01] (52 C)
[    6.081115] GHES: HEST is not enabled!
[    6.081374] ACPI: Battery Slot [BAT0] (battery present)
[    6.081417] ACPI: Battery Slot [BAT1] (battery absent)
[    6.081510] ACPI: Battery Slot [BAT2] (battery absent)
[    6.103031] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    6.130734] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    6.139847] Non-volatile memory driver v1.3
[    6.144605] Linux agpgart interface v0.103
[    6.149530] mei_me 0000:00:16.0: irq 43 for MSI/MSI-X
[    6.157060] rdac: device handler registered
[    6.161855] hp_sw: device handler registered
[    6.166700] emc: device handler registered
[    6.171341] alua: device handler registered
[    6.176122] libphy: Fixed MDIO Bus: probed
[    6.180798] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    6.188784] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.195307] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    6.201914] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    6.208727] IOAPIC[0]: Set routing entry (2-20 -> 0x91 -> IRQ 20 Mode:1 Active:1 Dest:15)
[    6.217998] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:91 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    6.233323] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    6.243889] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.414133] e1000e 0000:00:19.0 eth0: registered PHC clock
[    6.420356] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:13:20:fc:e4:31
[    6.429328] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    6.437140] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
[    6.444946] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.13-k
[    6.452931] igb: Copyright (c) 2007-2014 Intel Corporation.
[    6.459259] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    6.468031] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    6.474612] usbcore: registered new interface driver catc
[    6.480744] usbcore: registered new interface driver kaweth
[    6.487063] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    6.495460] usbcore: registered new interface driver pegasus
[    6.501882] usbcore: registered new interface driver rtl8150
[    6.508316] usbcore: registered new interface driver asix
[    6.514443] usbcore: registered new interface driver cdc_ether
[    6.521059] usbcore: registered new interface driver cdc_eem
[    6.527485] usbcore: registered new interface driver dm9601
[    6.533820] usbcore: registered new interface driver smsc75xx
[    6.540347] usbcore: registered new interface driver smsc95xx
[    6.546867] usbcore: registered new interface driver gl620a
[    6.553196] usbcore: registered new interface driver net1080
[    6.559620] usbcore: registered new interface driver plusb
[    6.565847] usbcore: registered new interface driver rndis_host
[    6.572572] usbcore: registered new interface driver cdc_subset
[    6.579294] usbcore: registered new interface driver zaurus
[    6.585618] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    6.594023] usbcore: registered new interface driver int51x1
[    6.600451] usbcore: registered new interface driver ipheth
[    6.606779] usbcore: registered new interface driver sierra_net
[    6.613541] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.620941] ehci-pci: EHCI PCI platform driver
[    6.625989] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.632993] ohci-pci: OHCI PCI platform driver
[    6.638039] uhci_hcd: USB Universal Host Controller Interface driver
[    6.645359] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
[    6.652658] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
[    6.658304] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    6.664281] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    6.672754] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    6.680468] xhci_hcd 0000:00:14.0: irq 45 for MSI/MSI-X
[    6.686451] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.694143] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.702326] usb usb1: Product: xHCI Host Controller
[    6.707851] usb usb1: Manufacturer: Linux 3.17.0-rc7-g5ba60fc xhci_hcd
[    6.715246] usb usb1: SerialNumber: 0000:00:14.0
[    6.720619] hub 1-0:1.0: USB hub found
[    6.724882] hub 1-0:1.0: 11 ports detected
[    6.733890] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    6.739853] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    6.748275] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    6.755959] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.764144] usb usb2: Product: xHCI Host Controller
[    6.768473] tsc: Refined TSC clocksource calibration: 1596.304 MHz
[    6.776673] usb usb2: Manufacturer: Linux 3.17.0-rc7-g5ba60fc xhci_hcd
[    6.784068] usb usb2: SerialNumber: 0000:00:14.0
[    6.789421] hub 2-0:1.0: USB hub found
[    6.793678] hub 2-0:1.0: 4 ports detected
[    6.800018] usbcore: registered new interface driver usbserial
[    6.806637] usbcore: registered new interface driver usbserial_generic
[    6.814039] usbserial: USB Serial support registered for generic
[    6.820875] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    6.828565] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    6.840652] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.846365] mousedev: PS/2 mouse device common for all mice
[    6.852945] rtc_cmos 00:02: RTC can wake from S4
[    6.858331] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    6.865272] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    6.873977] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    6.880320] iTCO_wdt: Found a Wildcat Point_LP TCO device (Version=2, TCOBASE=0x1860)
[    6.889286] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.896107] iTCO_vendor_support: vendor-support=0
[    6.901488] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    6.911259] Intel P-state driver initializing.
[    6.918658] hidraw: raw HID events driver (C) Jiri Kosina
[    6.925251] usbcore: registered new interface driver usbhid
[    6.931604] usbhid: USB HID core driver
[    6.936111] drop_monitor: Initializing network drop monitor service
[    6.943378] TCP: cubic registered
[    6.947150] Initializing XFRM netlink socket
[    6.952232] NET: Registered protocol family 10
[    6.957806] NET: Registered protocol family 17
[    6.962877] 9pnet: Installing 9P2000 support
[    6.968251] 
[    6.968251] printing PIC contents
[    6.973709] ... PIC  IMR: ffff
[    6.977169] ... PIC  IRR: 0c00
[    6.980636] ... PIC  ISR: 0000
[    6.984100] ... PIC ELCR: 0c00
[    6.987560] printing local APIC contents on CPU#0/2:
[    6.993181] ... APIC ID:      02000000 (2)
[    6.997818] ... APIC VERSION: 01060015
[    7.002061] ... APIC TASKPRI: 00000000 (00)
[    7.006796] ... APIC PROCPRI: 00000000
[    7.011039] ... APIC LDR: 01000000
[    7.014889] ... APIC DFR: ffffffff
[    7.018738] ... APIC SPIV: 000001ff
[    7.022685] ... APIC ISR field:
[    7.026239] 0000000000000000000000000000000000000000000000000000000000000000
[    7.034306] ... APIC TMR field:
[    7.037860] 0000000000000000000000000000000000000000000000000000000000000000
[    7.045923] ... APIC IRR field:
[    7.049479] 0000000000000000000000000000000000000000000200000000000000008000
[    7.057543] ... APIC ESR: 00000000
[    7.061393] ... APIC ICR: 000008fd
[    7.065243] ... APIC ICR2: 02000000
[    7.069191] ... APIC LVTT: 000400ef
[    7.073139] ... APIC LVTPC: 00000400
[    7.077185] ... APIC LVT0: 00010700
[    7.081131] ... APIC LVT1: 00000400
[    7.085079] ... APIC LVTERR: 000000fe
[    7.089224] ... APIC TMICT: 00000000
[    7.092273] usb 1-8: new full-speed USB device number 2 using xhci_hcd
[    7.100659] ... APIC TMCCT: 00000000
[    7.104706] ... APIC TDCR: 00000000
[    7.108653] 
[    7.110364] number of MP IRQ sources: 15.
[    7.114911] number of IO-APIC #2 registers: 40.
[    7.120044] testing the IO APIC.......................
[    7.125873] IO APIC #2......
[    7.129136] .... register #00: 02000000
[    7.133480] .......    : physical APIC id: 02
[    7.138417] .......    : Delivery Type: 0
[    7.142958] .......    : LTS          : 0
[    7.147489] .... register #01: 00270020
[    7.151836] .......     : max redirection entries: 27
[    7.157557] .......     : PRQ implemented: 0
[    7.162386] .......     : IO APIC version: 20
[    7.167322] .... register #02: 00000000
[    7.171678] .......     : arbitration: 00
[    7.176220] .... IRQ redirection table:
[    7.180571] 0   1    0    0   0   0    0     0    00
[    7.186199] 1   0    0    0   0   0    0     0    01
[    7.191826] 1   0    0    0   0   0    0     0    02
[    7.197454] 1   0    0    0   0   0    0     0    03
[    7.203082] 1   0    0    0   0   0    0     0    04
[    7.208710] 1   0    0    0   0   0    0     0    05
[    7.214339] 1   0    0    0   0   0    0     0    06
[    7.219968] 1   0    0    0   0   0    0     0    07
[    7.225595] 1   0    0    0   0   0    0     0    08
[    7.231223] 1   0    1    0   0   0    0     0    09
[    7.236850] 1   0    0    0   0   0    0     0    0A
[    7.242478] 1   0    0    0   0   0    0     0    0B
[    7.248106] 1   0    0    0   0   0    0     0    0C
[    7.253734] 1   0    0    0   0   0    0     0    0D
[    7.259362] 1   0    0    0   0   0    0     0    0E
[    7.264989] 1   0    0    0   0   0    0     0    0F
[    7.270622] 1   1    1    0   1   0    0     0    10
[    7.276252] 0   1    0    0   0   0    0     0    00
[    7.281878] 0   1    0    0   0   0    0     0    00
[    7.287534] 0   1    0    0   0   0    0     0    00
[    7.293194] 1   1    1    0   1   0    0     0    14
[    7.298858] 0   1    0    0   0   0    0     0    00
[    7.304514] 0   1    0    0   0   0    0     0    00
[    7.310167] 0   1    0    0   0   0    0     0    00
[    7.315820] 0   1    0    0   0   0    0     0    00
[    7.315824] usb 1-8: New USB device found, idVendor=8087, idProduct=07dc
[    7.315826] usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.337189] 0   1    0    0   0   0    0     0    00
[    7.342837] 0   1    0    0   0   0    0     0    00
[    7.348485] 0   1    0    0   0   0    0     0    00
[    7.354134] 0   1    0    0   0   0    0     0    00
[    7.359780] 0   1    0    0   0   0    0     0    00
[    7.365428] 0   1    0    0   0   0    0     0    00
[    7.371076] 0   1    0    0   0   0    0     0    00
[    7.376724] 0   1    0    0   0   0    0     0    00
[    7.382370] 0   1    0    0   0   0    0     0    00
[    7.387995] 0   1    0    0   0   0    0     0    00
[    7.393624] 0   1    0    0   0   0    0     0    00
[    7.399271] 0   1    0    0   0   0    0     0    00
[    7.404920] 0   1    0    0   0   0    0     0    00
[    7.410568] 0   1    0    0   0   0    0     0    00
[    7.416215] 0   1    0    0   0   0    0     0    00
[    7.421858] IRQ to pin mappings:
[    7.425535] IRQ0 -> 0:2
[    7.428323] IRQ1 -> 0:1
[    7.431140] IRQ3 -> 0:3
[    7.433923] IRQ4 -> 0:4
[    7.436738] IRQ5 -> 0:5
[    7.439551] IRQ6 -> 0:6
[    7.442339] IRQ7 -> 0:7
[    7.445154] IRQ8 -> 0:8
[    7.447943] IRQ9 -> 0:9
[    7.450760] IRQ10 -> 0:10
[    7.453745] IRQ11 -> 0:11
[    7.456758] IRQ12 -> 0:12
[    7.459771] IRQ13 -> 0:13
[    7.462755] IRQ14 -> 0:14
[    7.465760] IRQ15 -> 0:15
[    7.468745] IRQ16 -> 0:16
[    7.471758] IRQ20 -> 0:20
[    7.474752] .................................... done.
[    7.480772] Loading compiled-in X.509 certificates
[    7.487380] Loaded X.509 cert 'Magrathea: Glacier signing key: 51f66d467af578e89ed61c5fc40ea9267fc4638d'
[    7.498144] registered taskstats version 1
[    7.504819] Key type trusted registered
[    7.510903] Key type encrypted registered
[    7.517031] ima: No TPM chip found, activating TPM-bypass!
[    7.523298] evm: HMAC attrs: 0x1
[    7.527403] rtc_cmos 00:02: setting system clock to 2014-10-11 12:42:27 UTC (1413031347)
[    7.637423] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    7.743756] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    7.749538] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.767812] Switched to clocksource tsc
[   10.448308] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   10.457765] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.468714] Sending DHCP requests .., OK
[   13.020837] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.151
[   13.029682] IP-Config: Complete:
[   13.033339]      device=eth0, hwaddr=00:13:20:fc:e4:31, ipaddr=192.168.1.151, mask=255.255.255.0, gw=192.168.1.1
[   13.044868]      host=lkp-bdw01, domain=lkp.intel.com, nis-domain=(none)
[   13.052457]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   13.060048]      nameserver0=192.168.1.1
[   13.064716] PM: Hibernation image not present or could not be loaded.
[   13.073207] Freeing unused kernel memory: 1804K (ffffffff81dd1000 - ffffffff81f94000)
[   13.252738] sdhci: Secure Digital Host Controller Interface driver
[   13.259740] sdhci: Copyright(c) Pierre Ossman
[   13.416747] libata version 3.00 loaded.
[   13.422192] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   13.436087] ahci 0000:00:1f.2: version 3.0
[   13.441301] IOAPIC[0]: Set routing entry (2-19 -> 0xe1 -> IRQ 19 Mode:1 Active:1 Dest:15)
[   13.450647] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E1 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[   13.466076] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
[   13.474281] [drm] Initialized drm 1.1.0 20060810
[   13.483502] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 2 ports 6 Gbps 0x2 impl SATA mode
[   13.492692] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo only pio slum part deso sadm sds apst 
[   13.521023] Error: Driver 'pcspkr' is already registered, aborting...
[   13.524899] scsi host0: ahci
[   13.525044] scsi host1: ahci
[   13.525122] ata1: DUMMY
[   13.525125] ata2: SATA max UDMA/133 abar m2048@0xc1137000 port 0xc1137180 irq 46
[   13.525333] IOAPIC[0]: Set routing entry (2-18 -> 0x42 -> IRQ 18 Mode:1 Active:1 Dest:15)
[   13.525342] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:42 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[   13.525357] ACPI Warning: SystemIO range 0x000000000000efa0-0x000000000000efbf conflicts with OpRegion 0x000000000000efa0-0x000000000000efaf (\_SB_.PCI0.SBUS.SMBI) (20140724/utaddress-258)
[   13.525358] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.602975] [drm] Memory usable by graphics device = 4096M
[   13.609201] [drm] Replacing VGA console driver
[   13.628051] i915 0000:00:02.0: irq 47 for MSI/MSI-X
[   13.633603] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   13.641100] [drm] Driver supports precise vblank timestamp query.
[   13.648111] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   13.691672] fbcon: inteldrmfb (fb0) is primary device
[   13.707423] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   13.707532] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
[   13.707651] [drm] Initialized i915 1.6.0 20141003 for 0000:00:02.0 on minor 0
[   13.832196] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   13.843200] ata2.00: ATA-9: INTEL SSDSC2CW120A3, 400i, max UDMA/133
[   13.843202] ata2.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   13.853148] ata2.00: configured for UDMA/133
[   13.853417] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW12 400i PQ: 0 ANSI: 5
[   13.959058] ------------[ cut here ]------------
[   13.959092] WARNING: CPU: 0 PID: 75 at drivers/gpu/drm/i915/intel_pm.c:6231 sandybridge_pcode_write+0x171/0x190 [i915]()
[   13.959112] Modules linked in: snd_hda_intel i915 snd_hda_controller snd_hda_codec snd_hwdep snd_pcm drm_kms_helper snd_timer snd winbond_cir drm soundcore ahci libahci rc_core pcspkr i2c_i801 libata parport_pc parport i2c_hid sdhci_acpi sdhci mmc_core video dw_dmac dw_dmac_core acpi_pad
[   13.959115] CPU: 0 PID: 75 Comm: kworker/u16:1 Not tainted 3.17.0-rc7-g5ba60fc #1
[   13.959116] Hardware name: Intel Corporation Broadwell Client platform/WhiteTip Mountain 1, BIOS BDW-E1R1.86C.0079.R00.1406020127 06/02/2014
[   13.959122] Workqueue: events_unbound async_run_entry_fn
[   13.959126]  0000000000000009 ffff880092cbb850 ffffffff818570a6 0000000000000000
[   13.959129]  ffff880092cbb888 ffffffff8106ef1d ffff88014d380000 0000000000000000
[   13.959131]  0000000000000018 ffff88014dc862f0 ffff88014d380000 ffff880092cbb898
[   13.959132] Call Trace:
[   13.959137]  [<ffffffff818570a6>] dump_stack+0x4d/0x66
[   13.959142]  [<ffffffff8106ef1d>] warn_slowpath_common+0x7d/0xa0
[   13.959145]  [<ffffffff8106effa>] warn_slowpath_null+0x1a/0x20
[   13.959173]  [<ffffffffa0213a51>] sandybridge_pcode_write+0x171/0x190 [i915]
[   13.959212]  [<ffffffffa0267926>] haswell_modeset_global_resources+0x196/0x4a0 [i915]
[   13.959248]  [<ffffffffa0269188>] __intel_set_mode+0x718/0xb20 [i915]
[   13.959280]  [<ffffffffa026f146>] intel_set_mode+0x16/0x30 [i915]
[   13.959309]  [<ffffffffa027025a>] intel_crtc_set_config+0xa9a/0xea0 [i915]
[   13.959328]  [<ffffffffa01406c0>] drm_mode_set_config_internal+0x60/0xf0 [drm]
[   13.959336]  [<ffffffffa01d2df3>] restore_fbdev_mode+0xd3/0x100 [drm_kms_helper]
[   13.959342]  [<ffffffffa01d2e43>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
[   13.959349]  [<ffffffffa01d48f8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
[   13.959384]  [<ffffffffa027afca>] intel_fbdev_set_par+0x1a/0x60 [i915]
[   13.959388]  [<ffffffff81453f18>] fbcon_init+0x578/0x600
[   13.959391]  [<ffffffff814cb978>] visual_init+0xb8/0x120
[   13.959394]  [<ffffffff814cdf0e>] do_bind_con_driver+0x17e/0x3b0
[   13.959397]  [<ffffffff814ce6e4>] do_take_over_console+0xb4/0x1b0
[   13.959401]  [<ffffffff8144ee43>] do_fbcon_takeover+0x63/0xd0
[   13.959403]  [<ffffffff81454a3d>] fbcon_event_notify+0x6cd/0x7d0
[   13.959407]  [<ffffffff8108f45d>] notifier_call_chain+0x4d/0x70
[   13.959411]  [<ffffffff8108f7c7>] __blocking_notifier_call_chain+0x47/0x60
[   13.959414]  [<ffffffff8108f7f6>] blocking_notifier_call_chain+0x16/0x20
[   13.959417]  [<ffffffff8145a6fb>] fb_notifier_call_chain+0x1b/0x20
[   13.959420]  [<ffffffff8145ca66>] register_framebuffer+0x206/0x340
[   13.959427]  [<ffffffffa01d4b9f>] drm_fb_helper_initial_config+0x25f/0x3b0 [drm_kms_helper]
[   13.959460]  [<ffffffffa027c20b>] intel_fbdev_initial_config+0x1b/0x20 [i915]
[   13.959463]  [<ffffffff81090ee9>] async_run_entry_fn+0x39/0x120
[   13.959468]  [<ffffffff8108814a>] process_one_work+0x15a/0x4b0
[   13.959471]  [<ffffffff8108850b>] worker_thread+0x6b/0x5e0
[   13.959475]  [<ffffffff810884a0>] ? process_one_work+0x4b0/0x4b0
[   13.959478]  [<ffffffff8108e1ab>] kthread+0xdb/0x100
[   13.959482]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
[   13.959486]  [<ffffffff8185fcbc>] ret_from_fork+0x7c/0xb0
[   13.959489]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
[   13.959490] ---[ end trace cdab09cd792673ee ]---
[   13.961051] ------------[ cut here ]------------
[   13.961081] WARNING: CPU: 0 PID: 75 at drivers/gpu/drm/i915/intel_pm.c:6231 sandybridge_pcode_write+0x171/0x190 [i915]()
[   13.961099] Modules linked in: snd_hda_intel i915 snd_hda_controller snd_hda_codec snd_hwdep snd_pcm drm_kms_helper snd_timer snd winbond_cir drm soundcore ahci libahci rc_core pcspkr i2c_i801 libata parport_pc parport i2c_hid sdhci_acpi sdhci mmc_core video dw_dmac dw_dmac_core acpi_pad
[   13.961102] CPU: 0 PID: 75 Comm: kworker/u16:1 Tainted: G        W      3.17.0-rc7-g5ba60fc #1
[   13.961103] Hardware name: Intel Corporation Broadwell Client platform/WhiteTip Mountain 1, BIOS BDW-E1R1.86C.0079.R00.1406020127 06/02/2014
[   13.961107] Workqueue: events_unbound async_run_entry_fn
[   13.961110]  0000000000000009 ffff880092cbb850 ffffffff818570a6 0000000000000000
[   13.961113]  ffff880092cbb888 ffffffff8106ef1d ffff88014d380000 0000000000000000
[   13.961116]  0000000000000017 00000000fffb9c7a ffff88014d380000 ffff880092cbb898
[   13.961116] Call Trace:
[   13.961119]  [<ffffffff818570a6>] dump_stack+0x4d/0x66
[   13.961123]  [<ffffffff8106ef1d>] warn_slowpath_common+0x7d/0xa0
[   13.961127]  [<ffffffff8106effa>] warn_slowpath_null+0x1a/0x20
[   13.961151]  [<ffffffffa0213a51>] sandybridge_pcode_write+0x171/0x190 [i915]
[   13.961186]  [<ffffffffa0267a95>] haswell_modeset_global_resources+0x305/0x4a0 [i915]
[   13.961215]  [<ffffffffa0269188>] __intel_set_mode+0x718/0xb20 [i915]
[   13.961244]  [<ffffffffa026f146>] intel_set_mode+0x16/0x30 [i915]
[   13.961271]  [<ffffffffa027025a>] intel_crtc_set_config+0xa9a/0xea0 [i915]
[   13.961288]  [<ffffffffa01406c0>] drm_mode_set_config_internal+0x60/0xf0 [drm]
[   13.961295]  [<ffffffffa01d2df3>] restore_fbdev_mode+0xd3/0x100 [drm_kms_helper]
[   13.961302]  [<ffffffffa01d2e43>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
[   13.961308]  [<ffffffffa01d48f8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
[   13.961342]  [<ffffffffa027afca>] intel_fbdev_set_par+0x1a/0x60 [i915]
[   13.961345]  [<ffffffff81453f18>] fbcon_init+0x578/0x600
[   13.961348]  [<ffffffff814cb978>] visual_init+0xb8/0x120
[   13.961351]  [<ffffffff814cdf0e>] do_bind_con_driver+0x17e/0x3b0
[   13.961353]  [<ffffffff814ce6e4>] do_take_over_console+0xb4/0x1b0
[   13.961357]  [<ffffffff8144ee43>] do_fbcon_takeover+0x63/0xd0
[   13.961360]  [<ffffffff81454a3d>] fbcon_event_notify+0x6cd/0x7d0
[   13.961363]  [<ffffffff8108f45d>] notifier_call_chain+0x4d/0x70
[   13.961367]  [<ffffffff8108f7c7>] __blocking_notifier_call_chain+0x47/0x60
[   13.961370]  [<ffffffff8108f7f6>] blocking_notifier_call_chain+0x16/0x20
[   13.961373]  [<ffffffff8145a6fb>] fb_notifier_call_chain+0x1b/0x20
[   13.961376]  [<ffffffff8145ca66>] register_framebuffer+0x206/0x340
[   13.961383]  [<ffffffffa01d4b9f>] drm_fb_helper_initial_config+0x25f/0x3b0 [drm_kms_helper]
[   13.961413]  [<ffffffffa027c20b>] intel_fbdev_initial_config+0x1b/0x20 [i915]
[   13.961417]  [<ffffffff81090ee9>] async_run_entry_fn+0x39/0x120
[   13.961421]  [<ffffffff8108814a>] process_one_work+0x15a/0x4b0
[   13.961424]  [<ffffffff8108850b>] worker_thread+0x6b/0x5e0
[   13.961428]  [<ffffffff810884a0>] ? process_one_work+0x4b0/0x4b0
[   13.961431]  [<ffffffff8108e1ab>] kthread+0xdb/0x100
[   13.961434]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
[   13.961438]  [<ffffffff8185fcbc>] ret_from_fork+0x7c/0xb0
[   13.961441]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
[   13.961442] ---[ end trace cdab09cd792673ef ]---
[   14.751502] Console: switching to colour frame buffer device 240x67
[   15.651593] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   15.660082] i915 0000:00:02.0: registered panic notifier
[   15.672838] snd_hda_intel 0000:00:03.0: irq 48 for MSI/MSI-X
[   15.688270] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input7
[   15.700400] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input8
[   15.712512] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
[   15.743823] sd 1:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[   15.754178] sd 1:0:0:0: [sda] Write Protect is off
[   15.761083] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   15.768286] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.781319]  sda: sda1 sda2
[   15.786405] sd 1:0:0:0: [sda] Attached SCSI disk
[   15.796816] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   16.243839] random: dd urandom read with 63 bits of entropy available
<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.17.0-rc7-g5ba60fc (kbuild@cairo) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Sat Oct 11 12:38:06 CST 2014
<6>[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-bdw01/bisect_boot-1-x86_64-rhel-5ba60fc3d719988a404d35a3e46f109bea643fef-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/vmlinuz-3.17.0-rc7-g5ba60fc kconfig=x86_64-rhel commit=5ba60fc3d719988a404d35a3e46f109bea643fef branch=linux-devel/devel-hourly-2014100721 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-bdw01/boot/1/debian-x86_64.cgz/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/0 ip=::::lkp-bdw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] e820: BIOS-provided physical RAM map:
<6>[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009a3ff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000000009a400-0x000000000009ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009df19fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000009df1a000-0x000000009df38fff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000009df39000-0x00000000ab262fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000ab263000-0x00000000ab762fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000ab763000-0x00000000ab7b5fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000ab7b6000-0x00000000ab7e1fff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x00000000ab7e2000-0x00000000ab7fefff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000ab7ff000-0x00000000af7fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed84000-0x00000000fed84fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed90000-0x00000000fed91fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000014f7fffff] usable
<6>[    0.000000] bootconsole [earlyser0] enabled
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] SMBIOS 2.7 present.
<7>[    0.000000] DMI: Intel Corporation Broadwell Client platform/WhiteTip Mountain 1, BIOS BDW-E1R1.86C.0079.R00.1406020127 06/02/2014
<7>[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
<7>[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
<6>[    0.000000] AGP: No AGP bridge found
<6>[    0.000000] e820: last_pfn = 0x14f800 max_arch_pfn = 0x400000000
<7>[    0.000000] MTRR default type: write-back
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-BFFFF uncachable
<7>[    0.000000]   C0000-FFFFF write-protect
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 00C0000000 mask 7FC0000000 uncachable
<7>[    0.000000]   1 base 00B0000000 mask 7FF0000000 uncachable
<7>[    0.000000]   2 base 00AE000000 mask 7FFE000000 uncachable
<7>[    0.000000]   3 base 00AD000000 mask 7FFF000000 uncachable
<7>[    0.000000]   4 disabled
<7>[    0.000000]   5 disabled
<7>[    0.000000]   6 disabled
<7>[    0.000000]   7 disabled
<7>[    0.000000]   8 disabled
<7>[    0.000000]   9 disabled
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
<6>[    0.000000] e820: last_pfn = 0xab7ff max_arch_pfn = 0x400000000
<4>[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
<4>[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
<4>[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
<4>[    0.000000] Scan for SMP in [mem 0x0009a400-0x0009a7ff]
<7>[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 24576
<6>[    0.000000] Using GB pages for direct mapping
<6>[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
<7>[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
<7>[    0.000000] BRK [0x14f177000, 0x14f177fff] PGTABLE
<7>[    0.000000] BRK [0x14f178000, 0x14f178fff] PGTABLE
<7>[    0.000000] BRK [0x14f179000, 0x14f179fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x14f600000-0x14f7fffff]
<7>[    0.000000]  [mem 0x14f600000-0x14f7fffff] page 2M
<7>[    0.000000] BRK [0x14f17a000, 0x14f17afff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x14c000000-0x14f5fffff]
<7>[    0.000000]  [mem 0x14c000000-0x14f5fffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x100000000-0x14bffffff]
<7>[    0.000000]  [mem 0x100000000-0x13fffffff] page 1G
<7>[    0.000000]  [mem 0x140000000-0x14bffffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x00100000-0x9df19fff]
<7>[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
<7>[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
<7>[    0.000000]  [mem 0x80000000-0x9ddfffff] page 2M
<7>[    0.000000]  [mem 0x9de00000-0x9df19fff] page 4k
<7>[    0.000000] BRK [0x14f17b000, 0x14f17bfff] PGTABLE
<7>[    0.000000] BRK [0x14f17c000, 0x14f17cfff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x9df39000-0xab262fff]
<7>[    0.000000]  [mem 0x9df39000-0x9dffffff] page 4k
<7>[    0.000000]  [mem 0x9e000000-0xab1fffff] page 2M
<7>[    0.000000]  [mem 0xab200000-0xab262fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0xab7e2000-0xab7fefff]
<7>[    0.000000]  [mem 0xab7e2000-0xab7fefff] page 4k
<6>[    0.000000] RAMDISK: [mem 0x1466d3000-0x14dffffff]
<6>[    0.000000] ACPI: Early table checksum verification disabled
<4>[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
<4>[    0.000000] ACPI: XSDT 0x00000000AB7C8188 000114 (v01 INTEL  BDW-ULT  00000000      01000013)
<4>[    0.000000] ACPI: FACP 0x00000000AB7D7000 0000F4 (v05 INTEL  BDW-ULT  00000000 MSFT 0000005F)
<4>[    0.000000] ACPI: DSDT 0x000000009DF1A000 01E50D (v02 INTEL  BDW      00000000 INTL 20130927)
<4>[    0.000000] ACPI: FACS 0x00000000AB79D000 000040
<4>[    0.000000] ACPI: TCPA 0x00000000AB7DF000 000032 (v02 INTEL  EDK2     00000002      01000013)
<4>[    0.000000] ACPI: UEFI 0x00000000AB7A0000 000042 (v01 INTEL  EDK2     00000002      01000013)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7DE000 0004B5 (v01 Intel_ Tpm2Tabl 00001000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7DD000 00004E (v01 MeSsdt MeSsdt   00003000 INTL 20130927)
<4>[    0.000000] ACPI: TPM2 0x00000000AB7DC000 000034 (v03                 00000000      00000000)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7DB000 0005B1 (v01 Intel  PerfTune 00001000 INTL 20130927)
<4>[    0.000000] ACPI: DBGP 0x00000000AB7DA000 000034 (v01 INTEL           00000000 MSFT 0000005F)
<4>[    0.000000] ACPI: DBG2 0x00000000AB7D9000 000054 (v00 INTEL           00000000 MSFT 0000005F)
<4>[    0.000000] ACPI: LPIT 0x00000000AB7D8000 000094 (v01 INTEL  BDW-ULT  00000000 MSFT 0000005F)
<4>[    0.000000] ACPI: HPET 0x00000000AB7D6000 000038 (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
<4>[    0.000000] ACPI: APIC 0x00000000AB7D5000 0000BC (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
<4>[    0.000000] ACPI: MCFG 0x00000000AB7D4000 00003C (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
<4>[    0.000000] ACPI: WDAT 0x00000000AB7D3000 000104 (v01 INTEL  BDW-ULT  00000000 MSFT 0000005F)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7D2000 000250 (v01 INTEL  sensrhub 00000000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7CE000 00340B (v01 INTEL  PtidDevc 00001000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7CD000 000C7D (v01 INTEL  Ther_Rvp 00001000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7CC000 00017F (v01 INTEL  zpodd    00001000 INTL 20130927)
<4>[    0.000000] ACPI: BOOT 0x00000000AB7CB000 000028 (v01 INTEL  TIANO    00000002 MSFT 01000013)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7CA000 0004D8 (v01 PmRef  Cpu0Ist  00003000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7C9000 000B74 (v01 CpuRef CpuSsdt  00003000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7C1000 006F06 (v01 SaSsdt SaSsdt   00003000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7E0000 0006A7 (v01 CppcTa CppcTabl 00001000 INTL 20130927)
<4>[    0.000000] ACPI: PCCT 0x00000000AB7C0000 00006E (v05 PcctTa PcctTabl 00001000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7BF000 000AC4 (v01 Cpc_Ta Cpc_Tabl 00001000 INTL 20130927)
<4>[    0.000000] ACPI: CSRT 0x00000000AB7BE000 0000C4 (v01 INTL   BDW-ULT  00000001 INTL 20100528)
<4>[    0.000000] ACPI: DMAR 0x00000000AB7BD000 0000F0 (v01 INTEL  BDW      00000001 INTL 00000001)
<4>[    0.000000] ACPI: FPDT 0x00000000AB7BC000 000044 (v01 INTEL  EDK2     00000002      01000013)
<4>[    0.000000] ACPI: ASF! 0x00000000AB7BB000 0000A0 (v32 INTEL   HCG     00000001 TFSM 000F4240)
<4>[    0.000000] ACPI: BGRT 0x00000000AB7BA000 000038 (v01 INTEL  EDK2     00000002      01000013)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>[    0.000000] No NUMA configuration found
<6>[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000014f7fffff]
<6>[    0.000000] Initmem setup node 0 [mem 0x00000000-0x14f7fffff]
<6>[    0.000000]   NODE_DATA [mem 0x14f7d8000-0x14f7fdfff]
<7>[    0.000000]  [ffffea0000000000-ffffea00053fffff] PMD -> [ffff880142200000-ffff8801461fffff] on node 0
<4>[    0.000000] Zone ranges:
<4>[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
<4>[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
<4>[    0.000000]   Normal   [mem 0x100000000-0x14f7fffff]
<4>[    0.000000] Movable zone start for each node
<4>[    0.000000] Early memory node ranges
<4>[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
<4>[    0.000000]   node   0: [mem 0x00100000-0x9df19fff]
<4>[    0.000000]   node   0: [mem 0x9df39000-0xab262fff]
<4>[    0.000000]   node   0: [mem 0xab7e2000-0xab7fefff]
<4>[    0.000000]   node   0: [mem 0x100000000-0x14f7fffff]
<7>[    0.000000] On node 0 totalpages: 1026554
<7>[    0.000000]   DMA zone: 64 pages used for memmap
<7>[    0.000000]   DMA zone: 21 pages reserved
<7>[    0.000000]   DMA zone: 3993 pages, LIFO batch:0
<7>[    0.000000]   DMA32 zone: 10890 pages used for memmap
<7>[    0.000000]   DMA32 zone: 696929 pages, LIFO batch:31
<7>[    0.000000]   Normal zone: 5088 pages used for memmap
<7>[    0.000000]   Normal zone: 325632 pages, LIFO batch:31
<6>[    0.000000] Reserving Intel graphics stolen memory at 0xad800000-0xaf7fffff
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x1808
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-39
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<4>[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
<7>[    0.000000] ACPI: IRQ0 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
<7>[    0.000000] ACPI: IRQ9 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
<6>[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
<4>[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009afff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x9df1a000-0x9df38fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xab263000-0xab762fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xab763000-0xab7b5fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xab7b6000-0xab7e1fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xab7ff000-0xaf7fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xaf800000-0xdfffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed0ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfed83fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed84000-0xfed84fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed85000-0xfed8ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfed91fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed92000-0xfedfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xff9fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xffa00000-0xffffffff]
<6>[    0.000000] e820: [mem 0xaf800000-0xdfffffff] available for PCI devices
<6>[    0.000000] Booting paravirtualized kernel on bare hardware
<6>[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
<6>[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88014f400000 s88960 r8192 d21632 u262144
<7>[    0.000000] pcpu-alloc: s88960 r8192 d21632 u262144 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
<4>[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1010491
<4>[    0.000000] Policy zone: Normal
<5>[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-bdw01/bisect_boot-1-x86_64-rhel-5ba60fc3d719988a404d35a3e46f109bea643fef-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/vmlinuz-3.17.0-rc7-g5ba60fc kconfig=x86_64-rhel commit=5ba60fc3d719988a404d35a3e46f109bea643fef branch=linux-devel/devel-hourly-2014100721 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-bdw01/boot/1/debian-x86_64.cgz/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/0 ip=::::lkp-bdw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] sysrq: sysrq always enabled.
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
<6>[    0.000000] AGP: Checking aperture...
<6>[    0.000000] AGP: No AGP bridge found
<4>[    0.000000] Memory: 3831208K/4106216K available (8595K kernel code, 1702K rwdata, 3832K rodata, 1804K init, 1888K bss, 275008K reserved)
<6>[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
<6>[    0.000000] 	Offload RCU callbacks from all CPUs
<6>[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
<6>[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
<6>[    0.000000] NR_IRQS:524544 nr_irqs:760 0
<6>[    0.000000] Console: colour dummy device 80x25
<6>[    0.000000] console [tty0] enabled
<6>[    0.000000] bootconsole [earlyser0] disabled
<6>[    0.000000] console [ttyS0] enabled
<6>[    0.000000] allocated 16777216 bytes of page_cgroup
<6>[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
<7>[    0.000000] hpet clockevent registered
<6>[    0.000000] tsc: Fast TSC calibration using PIT
<6>[    0.000000] tsc: Detected 1596.353 MHz processor
<6>[    0.000041] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.70 BogoMIPS (lpj=1596353)
<6>[    0.012065] pid_max: default: 32768 minimum: 301
<6>[    0.017297] ACPI: Core revision 20140724
<4>[    0.061342] ACPI: All ACPI Tables successfully acquired
<6>[    0.067312] Security Framework initialized
<6>[    0.071952] SELinux:  Initializing.
<7>[    0.075905] SELinux:  Starting in permissive mode
<6>[    0.081614] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
<6>[    0.090891] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
<6>[    0.099351] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
<6>[    0.106944] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
<6>[    0.115263] Initializing cgroup subsys memory
<6>[    0.120199] Initializing cgroup subsys devices
<6>[    0.125228] Initializing cgroup subsys freezer
<6>[    0.130260] Initializing cgroup subsys net_cls
<6>[    0.135290] Initializing cgroup subsys blkio
<6>[    0.140124] Initializing cgroup subsys perf_event
<6>[    0.145450] Initializing cgroup subsys hugetlb
<6>[    0.150507] CPU: Physical Processor ID: 0
<6>[    0.155045] CPU: Processor Core ID: 1
<6>[    0.160481] mce: CPU supports 7 MCE banks
<7>[    0.165029] CPU0: Thermal LVT vector (0xfa) already installed
<6>[    0.171541] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
<6>[    0.171541] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
<6>[    0.184913] Freeing SMP alternatives memory: 36K (ffffffff81f94000 - ffffffff81f9d000)
<6>[    0.195174] ftrace: allocating 31083 entries in 122 pages
<4>[    0.219761] Getting VERSION: 1060015
<4>[    0.223808] Getting VERSION: 1060015
<4>[    0.227854] Getting ID: 2000000
<4>[    0.231409] Getting ID: 2000000
<6>[    0.234973] dmar: Host address width 39
<6>[    0.239315] dmar: DRHD base: 0x000000fed90000 flags: 0x0
<6>[    0.245334] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 7e1ff0505e
<6>[    0.254989] dmar: DRHD base: 0x000000fed91000 flags: 0x1
<6>[    0.261007] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap d2008c20660462 ecap f010da
<6>[    0.270169] dmar: RMRR base: 0x000000ab6f2000 end: 0x000000ab705fff
<6>[    0.277266] dmar: RMRR base: 0x000000ad000000 end: 0x000000af7fffff
<6>[    0.284361] dmar: ANDD device: 1 name: \_SB.PCI0.SDMA
<6>[    0.290080] dmar: ANDD device: 2 name: \_SB.PCI0.SDHC
<6>[    0.295924] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
<6>[    0.302226] HPET id 0 under DRHD base 0xfed91000
<6>[    0.307453] Queued invalidation will be enabled to support x2apic and Intr-remapping.
<4>[    0.316319] Your BIOS is broken and requested that x2apic be disabled.
<4>[    0.316319] This will slightly decrease performance.
<4>[    0.316319] Use 'intremap=no_x2apic_optout' to override BIOS request.
<6>[    0.336875] Enabled IRQ remapping in xapic mode
<6>[    0.342005] x2apic not enabled, IRQ remapping is in xapic mode
<4>[    0.348615] masked ExtINT on CPU#0
<4>[    0.352909] ENABLING IO-APIC IRQs
<7>[    0.356661] init IO_APIC IRQs
<7>[    0.360019]  apic 2 pin 0 not connected
<7>[    0.364363] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>[    0.373323] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.388589] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.397556] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.412814] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.421795] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.437062] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>[    0.446030] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.461296] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>[    0.470264] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.485531] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>[    0.494500] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:35 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.509767] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>[    0.518736] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:36 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.534001] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>[    0.542973] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:37 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.558239] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>[    0.567208] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.582474] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>[    0.591444] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.606709] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>[    0.615874] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3A Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.631138] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>[    0.640303] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3B Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.655569] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>[    0.664737] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3C Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.680003] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>[    0.689171] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.704437] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>[    0.713604] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3E Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.728869] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>[    0.738034] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3F Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.753300]  apic 2 pin 16 not connected
<7>[    0.757742]  apic 2 pin 17 not connected
<7>[    0.762183]  apic 2 pin 18 not connected
<7>[    0.766624]  apic 2 pin 19 not connected
<7>[    0.771063]  apic 2 pin 20 not connected
<7>[    0.775502]  apic 2 pin 21 not connected
<7>[    0.779942]  apic 2 pin 22 not connected
<7>[    0.784383]  apic 2 pin 23 not connected
<7>[    0.788824]  apic 2 pin 24 not connected
<7>[    0.793265]  apic 2 pin 25 not connected
<7>[    0.797706]  apic 2 pin 26 not connected
<7>[    0.802148]  apic 2 pin 27 not connected
<7>[    0.806589]  apic 2 pin 28 not connected
<7>[    0.811030]  apic 2 pin 29 not connected
<7>[    0.815471]  apic 2 pin 30 not connected
<7>[    0.819912]  apic 2 pin 31 not connected
<7>[    0.824354]  apic 2 pin 32 not connected
<7>[    0.828795]  apic 2 pin 33 not connected
<7>[    0.833236]  apic 2 pin 34 not connected
<7>[    0.837677]  apic 2 pin 35 not connected
<7>[    0.842118]  apic 2 pin 36 not connected
<7>[    0.846560]  apic 2 pin 37 not connected
<7>[    0.851001]  apic 2 pin 38 not connected
<7>[    0.855442]  apic 2 pin 39 not connected
<6>[    0.860028] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.876823] smpboot: CPU0: Genuine Intel(R) CPU 0000 @ 1.60GHz (fam: 06, model: 3d, stepping: 03)
<7>[    0.886917] TSC deadline timer enabled
<6>[    0.891189] Performance Events: PEBS fmt2+, generic architected perfmon, full-width counters, Intel PMU driver.
<6>[    0.902664] ... version:                3
<6>[    0.907195] ... bit width:              48
<6>[    0.911831] ... generic registers:      4
<6>[    0.916368] ... value mask:             0000ffffffffffff
<6>[    0.922384] ... max period:             0000ffffffffffff
<6>[    0.928398] ... fixed-purpose events:   3
<6>[    0.932937] ... event mask:             000000070000000f
<6>[    0.941254] x86: Booting SMP configuration:
<6>[    0.945994] .... node  #0, CPUs:      #1
<4>[    0.961365] masked ExtINT on CPU#1
<7>[    0.966721] CPU1: Thermal LVT vector (0xfa) already installed
<6>[    0.975393] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>[    0.984557]  #2
<4>[    0.997445] masked ExtINT on CPU#2
<7>[    1.002802] CPU2: Thermal LVT vector (0xfa) already installed
<4>[    1.011486]  #3
<4>[    1.024442] masked ExtINT on CPU#3
<7>[    1.029837] CPU3: Thermal LVT vector (0xfa) already installed
<6>[    1.038412] x86: Booted up 1 node, 4 CPUs
<6>[    1.042956] smpboot: Total of 4 processors activated (12770.82 BogoMIPS)
<6>[    1.056750] devtmpfs: initialized
<6>[    1.063136] evm: security.selinux
<6>[    1.066890] evm: security.ima
<6>[    1.070250] evm: security.capability
<6>[    1.074446] PM: Registering ACPI NVS region [mem 0xab763000-0xab7b5fff] (339968 bytes)
<6>[    1.084590] atomic64_test: passed for x86-64 platform with CX8 and with SSE
<6>[    1.092604] NET: Registered protocol family 16
<6>[    1.097884] cpuidle: using governor menu
<6>[    1.102470] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
<6>[    1.111044] ACPI: bus type PCI registered
<6>[    1.115584] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>[    1.122966] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
<6>[    1.133500] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
<6>[    1.141589] PCI: Using configuration type 1 for base access
<6>[    1.152320] ACPI: Added _OSI(Module Device)
<6>[    1.157060] ACPI: Added _OSI(Processor Device)
<6>[    1.162094] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>[    1.167411] ACPI: Added _OSI(Processor Aggregator Device)
<7>[    1.177929] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:15)
<7>[    1.187003] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<4>[    1.210254] ACPI: Executed 18 blocks of module-level executable AML code
<4>[    1.237548] ACPI: Dynamic OEM Table Load:
<4>[    1.242134] ACPI: SSDT 0xFFFF88013FCB1800 0004AE (v01 PmRef  Cpu0Cst  00003001 INTL 20130927)
<4>[    1.256670] ACPI: Dynamic OEM Table Load:
<4>[    1.261256] ACPI: SSDT 0xFFFF88013FED8000 000792 (v01 PmRef  ApIst    00003000 INTL 20130927)
<4>[    1.274535] ACPI: Dynamic OEM Table Load:
<4>[    1.279113] ACPI: SSDT 0xFFFF88013FED4E00 000119 (v01 PmRef  ApCst    00003000 INTL 20130927)
<6>[    1.297375] ACPI: Interpreter enabled
<4>[    1.301533] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
<4>[    1.312044] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
<6>[    1.322571] ACPI: (supports S0 S3 S4 S5)
<6>[    1.327018] ACPI: Using IOAPIC for interrupt routing
<6>[    1.332694] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>[    1.343638] ACPI: Power Resource [PG00] (on)
<6>[    1.354688] ACPI: Power Resource [PG01] (on)
<6>[    1.363680] ACPI: Power Resource [PG02] (on)
<6>[    1.395319] acpi ABCD0000:00: ACPI dock station (docks/bays count: 1)
<6>[    1.404126] ACPI: Power Resource [FN00] (off)
<6>[    1.409153] ACPI: Power Resource [FN01] (off)
<6>[    1.414175] ACPI: Power Resource [FN02] (on)
<6>[    1.419437] ACPI: Power Resource [FN03] (on)
<6>[    1.424405] ACPI: Power Resource [FN04] (off)
<6>[    1.430676] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
<6>[    1.437698] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    1.448071] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
<6>[    1.458490] PCI host bridge to bus 0000:00
<6>[    1.463133] pci_bus 0000:00: root bus resource [bus 00-fe]
<6>[    1.469368] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
<6>[    1.476390] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>[    1.483413] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>[    1.491225] pci_bus 0000:00: root bus resource [mem 0xaf800000-0xfeafffff]
<7>[    1.499041] pci 0000:00:00.0: [8086:1604] type 00 class 0x060000
<7>[    1.506164] pci 0000:00:02.0: [8086:1616] type 00 class 0x030000
<7>[    1.512995] pci 0000:00:02.0: reg 0x10: [mem 0xc0000000-0xc0ffffff 64bit]
<7>[    1.520691] pci 0000:00:02.0: reg 0x18: [mem 0xb0000000-0xbfffffff 64bit pref]
<7>[    1.528891] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
<7>[    1.535517] pci 0000:00:03.0: [8086:160c] type 00 class 0x040300
<7>[    1.542346] pci 0000:00:03.0: reg 0x10: [mem 0xc1130000-0xc1133fff 64bit]
<7>[    1.550370] pci 0000:00:14.0: [8086:9cb1] type 00 class 0x0c0330
<7>[    1.557199] pci 0000:00:14.0: reg 0x10: [mem 0xc1120000-0xc112ffff 64bit]
<7>[    1.564967] pci 0000:00:14.0: PME# supported from D3hot D3cold
<6>[    1.571833] pci 0000:00:14.0: System wakeup disabled by ACPI
<7>[    1.578305] pci 0000:00:16.0: [8086:9cba] type 00 class 0x078000
<7>[    1.585144] pci 0000:00:16.0: reg 0x10: [mem 0xc1135000-0xc113501f 64bit]
<7>[    1.592912] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
<7>[    1.600122] pci 0000:00:19.0: [8086:15a2] type 00 class 0x020000
<7>[    1.606950] pci 0000:00:19.0: reg 0x10: [mem 0xc1100000-0xc111ffff]
<7>[    1.614070] pci 0000:00:19.0: reg 0x14: [mem 0xc1138000-0xc1138fff]
<7>[    1.621190] pci 0000:00:19.0: reg 0x18: [io  0x3080-0x309f]
<7>[    1.627564] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
<6>[    1.634732] pci 0000:00:19.0: System wakeup disabled by ACPI
<7>[    1.641205] pci 0000:00:1c.0: [8086:9c90] type 01 class 0x060400
<7>[    1.648100] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<6>[    1.655265] pci 0000:00:1c.0: System wakeup disabled by ACPI
<7>[    1.661742] pci 0000:00:1f.0: [8086:9cc3] type 00 class 0x060100
<7>[    1.668959] pci 0000:00:1f.2: [8086:9c83] type 00 class 0x010601
<7>[    1.675793] pci 0000:00:1f.2: reg 0x10: [io  0x30a8-0x30af]
<7>[    1.682125] pci 0000:00:1f.2: reg 0x14: [io  0x30b4-0x30b7]
<7>[    1.688457] pci 0000:00:1f.2: reg 0x18: [io  0x30a0-0x30a7]
<7>[    1.694790] pci 0000:00:1f.2: reg 0x1c: [io  0x30b0-0x30b3]
<7>[    1.701121] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
<7>[    1.707453] pci 0000:00:1f.2: reg 0x24: [mem 0xc1137000-0xc11377ff]
<7>[    1.714607] pci 0000:00:1f.2: PME# supported from D3hot
<7>[    1.720817] pci 0000:00:1f.3: [8086:9ca2] type 00 class 0x0c0500
<7>[    1.727649] pci 0000:00:1f.3: reg 0x10: [mem 0xc1134000-0xc11340ff 64bit]
<7>[    1.735372] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
<7>[    1.741980] pci 0000:00:1f.6: [8086:9ca4] type 00 class 0x118000
<7>[    1.748831] pci 0000:00:1f.6: reg 0x10: [mem 0xc1136000-0xc1136fff 64bit]
<7>[    1.756999] pci 0000:01:00.0: [8086:08b1] type 00 class 0x028000
<7>[    1.763858] pci 0000:01:00.0: reg 0x10: [mem 0xc1000000-0xc1001fff 64bit]
<7>[    1.771753] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
<6>[    1.778710] pci 0000:01:00.0: System wakeup disabled by ACPI
<6>[    1.787140] pci 0000:00:1c.0: PCI bridge to [bus 01]
<7>[    1.792783] pci 0000:00:1c.0:   bridge window [mem 0xc1000000-0xc10fffff]
<6>[    1.800499] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
<6>[    1.811482] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
<6>[    1.820571] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.829863] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
<6>[    1.838945] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
<6>[    1.847993] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
<6>[    1.857057] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.866346] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.875635] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<4>[    1.885477] ACPI: Enabled 4 GPEs in block 00 to 7F
<6>[    1.891212] ACPI : EC: GPE = 0xa, I/O: command/status = 0x66, data = 0x62
<6>[    1.899061] vgaarb: setting as boot device: PCI:0000:00:02.0
<6>[    1.905468] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    1.914657] vgaarb: loaded
<6>[    1.917722] vgaarb: bridge control possible 0000:00:02.0
<5>[    1.923840] SCSI subsystem initialized
<6>[    1.928143] ACPI: bus type USB registered
<6>[    1.932724] usbcore: registered new interface driver usbfs
<6>[    1.938980] usbcore: registered new interface driver hub
<6>[    1.945077] usbcore: registered new device driver usb
<6>[    1.950901] pps_core: LinuxPPS API ver. 1 registered
<6>[    1.956525] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>[    1.966877] PTP clock support registered
<6>[    1.971403] PCI: Using ACPI for IRQ routing
<7>[    1.982379] PCI: pci_cache_line_size set to 64 bytes
<7>[    1.988037] e820: reserve RAM buffer [mem 0x0009a400-0x0009ffff]
<7>[    1.994841] e820: reserve RAM buffer [mem 0x9df1a000-0x9fffffff]
<7>[    2.001645] e820: reserve RAM buffer [mem 0xab263000-0xabffffff]
<7>[    2.008447] e820: reserve RAM buffer [mem 0xab7ff000-0xabffffff]
<7>[    2.015250] e820: reserve RAM buffer [mem 0x14f800000-0x14fffffff]
<6>[    2.022378] NetLabel: Initializing
<6>[    2.026233] NetLabel:  domain hash size = 128
<6>[    2.031166] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    2.036803] NetLabel:  unlabeled traffic allowed by default
<6>[    2.043248] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
<6>[    2.050348] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
<6>[    2.058987] Switched to clocksource hpet
<6>[    2.074712] pnp: PnP ACPI init
<6>[    2.078568] system 00:00: [io  0x06a4] has been reserved
<6>[    2.084592] system 00:00: [io  0x06a0] has been reserved
<7>[    2.090611] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
<6>[    2.098545] system 00:01: [io  0x0680-0x069f] has been reserved
<6>[    2.105246] system 00:01: [io  0xffff] has been reserved
<6>[    2.111269] system 00:01: [io  0xffff] has been reserved
<6>[    2.117287] system 00:01: [io  0xffff] has been reserved
<6>[    2.123306] system 00:01: [io  0x1800-0x18fe] could not be reserved
<6>[    2.130406] system 00:01: [io  0x164e-0x164f] has been reserved
<7>[    2.137112] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    2.144839] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
<7>[    2.153914] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<7>[    2.169201] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
<6>[    2.176640] system 00:03: [io  0x1854-0x1857] has been reserved
<7>[    2.183348] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
<7>[    2.191947] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
<7>[    2.201018] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<7>[    2.216303] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
<7>[    2.223772] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
<7>[    2.232842] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<7>[    2.248127] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
<6>[    2.256296] system 00:06: [mem 0xfe102000-0xfe102fff] has been reserved
<6>[    2.263791] system 00:06: [mem 0xfe104000-0xfe104fff] has been reserved
<6>[    2.271286] system 00:06: [mem 0xfe106000-0xfe106fff] has been reserved
<6>[    2.278779] system 00:06: [mem 0xfe10e000-0xfe10efff] has been reserved
<6>[    2.286273] system 00:06: [mem 0xfe112000-0xfe112fff] has been reserved
<6>[    2.293766] system 00:06: [mem 0xfe111000-0xfe111007] has been reserved
<6>[    2.301262] system 00:06: [mem 0xfe111014-0xfe111fff] has been reserved
<7>[    2.308756] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
<6>[    2.317970] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>[    2.325466] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
<6>[    2.332959] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
<6>[    2.340453] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
<6>[    2.347947] system 00:07: [mem 0xe0000000-0xefffffff] has been reserved
<6>[    2.355441] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
<6>[    2.362934] system 00:07: [mem 0xfed90000-0xfed93fff] could not be reserved
<6>[    2.370822] system 00:07: [mem 0xfed45000-0xfed8ffff] could not be reserved
<6>[    2.378710] system 00:07: [mem 0xff000000-0xffffffff] could not be reserved
<6>[    2.386597] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
<6>[    2.394484] system 00:07: [mem 0xaf810000-0xaf81ffff] has been reserved
<6>[    2.401978] system 00:07: [mem 0xaf800000-0xaf80ffff] has been reserved
<7>[    2.409472] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
<6>[    2.417448] system 00:08: [mem 0x00000000-0x0009cfff] could not be reserved
<7>[    2.425338] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    2.433198] pnp: PnP ACPI: found 9 devices
<6>[    2.444327] pci 0000:00:1c.0: PCI bridge to [bus 01]
<6>[    2.449958] pci 0000:00:1c.0:   bridge window [mem 0xc1000000-0xc10fffff]
<7>[    2.457656] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>[    2.463961] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>[    2.470274] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    2.477374] pci_bus 0000:00: resource 7 [mem 0xaf800000-0xfeafffff]
<7>[    2.484474] pci_bus 0000:01: resource 1 [mem 0xc1000000-0xc10fffff]
<6>[    2.491613] NET: Registered protocol family 2
<6>[    2.496772] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
<6>[    2.505050] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
<6>[    2.512620] TCP: Hash tables configured (established 32768 bind 32768)
<6>[    2.520037] TCP: reno registered
<6>[    2.523700] UDP hash table entries: 2048 (order: 4, 65536 bytes)
<6>[    2.530522] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
<6>[    2.537884] NET: Registered protocol family 1
<6>[    2.542917] RPC: Registered named UNIX socket transport module.
<6>[    2.549627] RPC: Registered udp transport module.
<6>[    2.554956] RPC: Registered tcp transport module.
<6>[    2.560283] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    2.567594] pci 0000:00:02.0: Video device with shadowed ROM
<4>[    2.574120] pci 0000:00:14.0: can't derive routing for PCI INT A
<4>[    2.580926] pci 0000:00:14.0: PCI INT A: no GSI
<4>[    2.586157] pci 0000:00:14.0: can't derive routing for PCI INT A
<7>[    2.592982] PCI: CLS 0 bytes, default 64
<6>[    2.597492] Unpacking initramfs...
<6>[    5.718946] Freeing initrd memory: 124084K (ffff8801466d3000 - ffff88014e000000)
<6>[    5.727368] dmar: ACPI device "INTL9C60:00" under DMAR at fed91000 as 00:15.0
<6>[    5.735480] dmar: ACPI device "INT3436:00" under DMAR at fed91000 as 00:17.0
<6>[    5.743474] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
<6>[    5.750773] software IO TLB [mem 0xa7263000-0xab263000] (64MB) mapped at [ffff8800a7263000-ffff8800ab262fff]
<6>[    5.762059] Simple Boot Flag at 0x47 set to 0x80
<6>[    5.768221] futex hash table entries: 2048 (order: 5, 131072 bytes)
<5>[    5.775350] Initialise system trusted keyring
<6>[    5.780309] audit: initializing netlink subsys (disabled)
<5>[    5.786441] audit: type=2000 audit(1413031342.190:1): initialized
<6>[    5.793722] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>[    5.802808] zpool: loaded
<6>[    5.805778] zbud: loaded
<5>[    5.808863] VFS: Disk quotas dquot_6.5.2
<4>[    5.813354] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>[    5.821238] SGI XFS with ACLs, security attributes, no debug enabled
<6>[    5.828872] 9p: Installing v9fs 9p2000 file system support
<6>[    5.835129] msgmni has been set to 7725
<5>[    5.839547] Key type big_key registered
<7>[    5.843896] SELinux:  Registering netfilter hooks
<6>[    5.849869] NET: Registered protocol family 38
<5>[    5.854917] Key type asymmetric registered
<5>[    5.859561] Asymmetric key parser 'x509' registered
<6>[    5.865137] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>[    5.873563] io scheduler noop registered
<6>[    5.878014] io scheduler deadline registered (default)
<6>[    5.883846] io scheduler cfq registered
<7>[    5.888415] IOAPIC[0]: Set routing entry (2-16 -> 0x61 -> IRQ 16 Mode:1 Active:1 Dest:15)
<7>[    5.897690] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:61 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<7>[    5.912991] pcieport 0000:00:1c.0: irq 42 for MSI/MSI-X
<6>[    5.919011] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
<6>[    5.926901] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
<7>[    5.934300] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
<6>[    5.941914] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>[    5.948246] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<7>[    5.955789] intel_idle: MWAIT substates: 0x11142120
<7>[    5.961316] intel_idle: v0.4 model 0x3D
<7>[    5.965662] intel_idle: lapic_timer_reliable_states 0xffffffff
<6>[    5.972638] ACPI: AC Adapter [ADP1] (off-line)
<6>[    5.977813] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
<6>[    5.987226] ACPI: Lid Switch [LID0]
<6>[    5.991237] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
<6>[    6.000701] ACPI: Power Button [PWRB]
<6>[    6.004889] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
<6>[    6.014354] ACPI: Sleep Button [SLPB]
<6>[    6.018546] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
<6>[    6.026926] ACPI: Power Button [PWRF]
<6>[    6.031161] ACPI: Fan [FAN0] (off)
<6>[    6.035045] ACPI: Fan [FAN1] (off)
<6>[    6.038924] ACPI: Fan [FAN2] (on)
<6>[    6.042708] ACPI: Fan [FAN3] (on)
<6>[    6.046489] ACPI: Fan [FAN4] (off)
<6>[    6.057758] thermal LNXTHERM:00: registered as thermal_zone0
<6>[    6.064174] ACPI: Thermal Zone [TZ00] (52 C)
<6>[    6.069803] thermal LNXTHERM:01: registered as thermal_zone1
<6>[    6.076217] ACPI: Thermal Zone [TZ01] (52 C)
<6>[    6.081115] GHES: HEST is not enabled!
<6>[    6.081374] ACPI: Battery Slot [BAT0] (battery present)
<6>[    6.081417] ACPI: Battery Slot [BAT1] (battery absent)
<6>[    6.081510] ACPI: Battery Slot [BAT2] (battery absent)
<6>[    6.103031] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<6>[    6.130734] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
<6>[    6.139847] Non-volatile memory driver v1.3
<6>[    6.144605] Linux agpgart interface v0.103
<7>[    6.149530] mei_me 0000:00:16.0: irq 43 for MSI/MSI-X
<6>[    6.157060] rdac: device handler registered
<6>[    6.161855] hp_sw: device handler registered
<6>[    6.166700] emc: device handler registered
<6>[    6.171341] alua: device handler registered
<6>[    6.176122] libphy: Fixed MDIO Bus: probed
<6>[    6.180798] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>[    6.188784] e1000: Copyright (c) 1999-2006 Intel Corporation.
<6>[    6.195307] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>[    6.201914] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
<7>[    6.208727] IOAPIC[0]: Set routing entry (2-20 -> 0x91 -> IRQ 20 Mode:1 Active:1 Dest:15)
<7>[    6.217998] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:91 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<6>[    6.233323] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
<7>[    6.243889] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
<6>[    6.414133] e1000e 0000:00:19.0 eth0: registered PHC clock
<6>[    6.420356] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:13:20:fc:e4:31
<6>[    6.429328] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
<6>[    6.437140] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
<6>[    6.444946] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.13-k
<6>[    6.452931] igb: Copyright (c) 2007-2014 Intel Corporation.
<6>[    6.459259] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>[    6.468031] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
<6>[    6.474612] usbcore: registered new interface driver catc
<6>[    6.480744] usbcore: registered new interface driver kaweth
<6>[    6.487063] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<6>[    6.495460] usbcore: registered new interface driver pegasus
<6>[    6.501882] usbcore: registered new interface driver rtl8150
<6>[    6.508316] usbcore: registered new interface driver asix
<6>[    6.514443] usbcore: registered new interface driver cdc_ether
<6>[    6.521059] usbcore: registered new interface driver cdc_eem
<6>[    6.527485] usbcore: registered new interface driver dm9601
<6>[    6.533820] usbcore: registered new interface driver smsc75xx
<6>[    6.540347] usbcore: registered new interface driver smsc95xx
<6>[    6.546867] usbcore: registered new interface driver gl620a
<6>[    6.553196] usbcore: registered new interface driver net1080
<6>[    6.559620] usbcore: registered new interface driver plusb
<6>[    6.565847] usbcore: registered new interface driver rndis_host
<6>[    6.572572] usbcore: registered new interface driver cdc_subset
<6>[    6.579294] usbcore: registered new interface driver zaurus
<6>[    6.585618] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<6>[    6.594023] usbcore: registered new interface driver int51x1
<6>[    6.600451] usbcore: registered new interface driver ipheth
<6>[    6.606779] usbcore: registered new interface driver sierra_net
<6>[    6.613541] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[    6.620941] ehci-pci: EHCI PCI platform driver
<6>[    6.625989] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[    6.632993] ohci-pci: OHCI PCI platform driver
<6>[    6.638039] uhci_hcd: USB Universal Host Controller Interface driver
<4>[    6.645359] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
<4>[    6.652658] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
<6>[    6.658304] xhci_hcd 0000:00:14.0: xHCI Host Controller
<6>[    6.664281] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
<7>[    6.672754] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
<7>[    6.680468] xhci_hcd 0000:00:14.0: irq 45 for MSI/MSI-X
<6>[    6.686451] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    6.694143] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    6.702326] usb usb1: Product: xHCI Host Controller
<6>[    6.707851] usb usb1: Manufacturer: Linux 3.17.0-rc7-g5ba60fc xhci_hcd
<6>[    6.715246] usb usb1: SerialNumber: 0000:00:14.0
<6>[    6.720619] hub 1-0:1.0: USB hub found
<6>[    6.724882] hub 1-0:1.0: 11 ports detected
<6>[    6.733890] xhci_hcd 0000:00:14.0: xHCI Host Controller
<6>[    6.739853] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
<6>[    6.748275] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
<6>[    6.755959] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    6.764144] usb usb2: Product: xHCI Host Controller
<6>[    6.768473] tsc: Refined TSC clocksource calibration: 1596.304 MHz
<6>[    6.776673] usb usb2: Manufacturer: Linux 3.17.0-rc7-g5ba60fc xhci_hcd
<6>[    6.784068] usb usb2: SerialNumber: 0000:00:14.0
<6>[    6.789421] hub 2-0:1.0: USB hub found
<6>[    6.793678] hub 2-0:1.0: 4 ports detected
<6>[    6.800018] usbcore: registered new interface driver usbserial
<6>[    6.806637] usbcore: registered new interface driver usbserial_generic
<6>[    6.814039] usbserial: USB Serial support registered for generic
<6>[    6.820875] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
<4>[    6.828565] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
<6>[    6.840652] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[    6.846365] mousedev: PS/2 mouse device common for all mice
<6>[    6.852945] rtc_cmos 00:02: RTC can wake from S4
<6>[    6.858331] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
<6>[    6.865272] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
<6>[    6.873977] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
<6>[    6.880320] iTCO_wdt: Found a Wildcat Point_LP TCO device (Version=2, TCOBASE=0x1860)
<6>[    6.889286] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<6>[    6.896107] iTCO_vendor_support: vendor-support=0
<6>[    6.901488] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
<6>[    6.911259] Intel P-state driver initializing.
<6>[    6.918658] hidraw: raw HID events driver (C) Jiri Kosina
<6>[    6.925251] usbcore: registered new interface driver usbhid
<6>[    6.931604] usbhid: USB HID core driver
<6>[    6.936111] drop_monitor: Initializing network drop monitor service
<6>[    6.943378] TCP: cubic registered
<6>[    6.947150] Initializing XFRM netlink socket
<6>[    6.952232] NET: Registered protocol family 10
<6>[    6.957806] NET: Registered protocol family 17
<6>[    6.962877] 9pnet: Installing 9P2000 support
<7>[    6.968251] 
<7>[    6.968251] printing PIC contents
<7>[    6.973709] ... PIC  IMR: ffff
<7>[    6.977169] ... PIC  IRR: 0c00
<7>[    6.980636] ... PIC  ISR: 0000
<7>[    6.984100] ... PIC ELCR: 0c00
<7>[    6.987560] printing local APIC contents on CPU#0/2:
<6>[    6.993181] ... APIC ID:      02000000 (2)
<6>[    6.997818] ... APIC VERSION: 01060015
<7>[    7.002061] ... APIC TASKPRI: 00000000 (00)
<7>[    7.006796] ... APIC PROCPRI: 00000000
<7>[    7.011039] ... APIC LDR: 01000000
<7>[    7.014889] ... APIC DFR: ffffffff
<7>[    7.018738] ... APIC SPIV: 000001ff
<7>[    7.022685] ... APIC ISR field:
<4>[    7.026239] 0000000000000000000000000000000000000000000000000000000000000000
<7>[    7.034306] ... APIC TMR field:
<4>[    7.037860] 0000000000000000000000000000000000000000000000000000000000000000
<7>[    7.045923] ... APIC IRR field:
<4>[    7.049479] 0000000000000000000000000000000000000000000200000000000000008000
<7>[    7.057543] ... APIC ESR: 00000000
<7>[    7.061393] ... APIC ICR: 000008fd
<7>[    7.065243] ... APIC ICR2: 02000000
<7>[    7.069191] ... APIC LVTT: 000400ef
<7>[    7.073139] ... APIC LVTPC: 00000400
<7>[    7.077185] ... APIC LVT0: 00010700
<7>[    7.081131] ... APIC LVT1: 00000400
<7>[    7.085079] ... APIC LVTERR: 000000fe
<7>[    7.089224] ... APIC TMICT: 00000000
<6>[    7.092273] usb 1-8: new full-speed USB device number 2 using xhci_hcd
<7>[    7.100659] ... APIC TMCCT: 00000000
<7>[    7.104706] ... APIC TDCR: 00000000
<4>[    7.108653] 
<7>[    7.110364] number of MP IRQ sources: 15.
<7>[    7.114911] number of IO-APIC #2 registers: 40.
<6>[    7.120044] testing the IO APIC.......................
<7>[    7.125873] IO APIC #2......
<7>[    7.129136] .... register #00: 02000000
<7>[    7.133480] .......    : physical APIC id: 02
<7>[    7.138417] .......    : Delivery Type: 0
<7>[    7.142958] .......    : LTS          : 0
<7>[    7.147489] .... register #01: 00270020
<7>[    7.151836] .......     : max redirection entries: 27
<7>[    7.157557] .......     : PRQ implemented: 0
<7>[    7.162386] .......     : IO APIC version: 20
<7>[    7.167322] .... register #02: 00000000
<7>[    7.171678] .......     : arbitration: 00
<7>[    7.176220] .... IRQ redirection table:
<4>[    7.180571] 0   1    0    0   0   0    0     0    00
<4>[    7.186199] 1   0    0    0   0   0    0     0    01
<4>[    7.191826] 1   0    0    0   0   0    0     0    02
<4>[    7.197454] 1   0    0    0   0   0    0     0    03
<4>[    7.203082] 1   0    0    0   0   0    0     0    04
<4>[    7.208710] 1   0    0    0   0   0    0     0    05
<4>[    7.214339] 1   0    0    0   0   0    0     0    06
<4>[    7.219968] 1   0    0    0   0   0    0     0    07
<4>[    7.225595] 1   0    0    0   0   0    0     0    08
<4>[    7.231223] 1   0    1    0   0   0    0     0    09
<4>[    7.236850] 1   0    0    0   0   0    0     0    0A
<4>[    7.242478] 1   0    0    0   0   0    0     0    0B
<4>[    7.248106] 1   0    0    0   0   0    0     0    0C
<4>[    7.253734] 1   0    0    0   0   0    0     0    0D
<4>[    7.259362] 1   0    0    0   0   0    0     0    0E
<4>[    7.264989] 1   0    0    0   0   0    0     0    0F
<4>[    7.270622] 1   1    1    0   1   0    0     0    10
<4>[    7.276252] 0   1    0    0   0   0    0     0    00
<4>[    7.281878] 0   1    0    0   0   0    0     0    00
<4>[    7.287534] 0   1    0    0   0   0    0     0    00
<4>[    7.293194] 1   1    1    0   1   0    0     0    14
<4>[    7.298858] 0   1    0    0   0   0    0     0    00
<4>[    7.304514] 0   1    0    0   0   0    0     0    00
<4>[    7.310167] 0   1    0    0   0   0    0     0    00
<4>[    7.315820] 0   1    0    0   0   0    0     0    00
<6>[    7.315824] usb 1-8: New USB device found, idVendor=8087, idProduct=07dc
<6>[    7.315826] usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<4>[    7.337189] 0   1    0    0   0   0    0     0    00
<4>[    7.342837] 0   1    0    0   0   0    0     0    00
<4>[    7.348485] 0   1    0    0   0   0    0     0    00
<4>[    7.354134] 0   1    0    0   0   0    0     0    00
<4>[    7.359780] 0   1    0    0   0   0    0     0    00
<4>[    7.365428] 0   1    0    0   0   0    0     0    00
<4>[    7.371076] 0   1    0    0   0   0    0     0    00
<4>[    7.376724] 0   1    0    0   0   0    0     0    00
<4>[    7.382370] 0   1    0    0   0   0    0     0    00
<4>[    7.387995] 0   1    0    0   0   0    0     0    00
<4>[    7.393624] 0   1    0    0   0   0    0     0    00
<4>[    7.399271] 0   1    0    0   0   0    0     0    00
<4>[    7.404920] 0   1    0    0   0   0    0     0    00
<4>[    7.410568] 0   1    0    0   0   0    0     0    00
<4>[    7.416215] 0   1    0    0   0   0    0     0    00
<7>[    7.421858] IRQ to pin mappings:
<7>[    7.425535] IRQ0 -> 0:2
<7>[    7.428323] IRQ1 -> 0:1
<7>[    7.431140] IRQ3 -> 0:3
<7>[    7.433923] IRQ4 -> 0:4
<7>[    7.436738] IRQ5 -> 0:5
<7>[    7.439551] IRQ6 -> 0:6
<7>[    7.442339] IRQ7 -> 0:7
<7>[    7.445154] IRQ8 -> 0:8
<7>[    7.447943] IRQ9 -> 0:9
<7>[    7.450760] IRQ10 -> 0:10
<7>[    7.453745] IRQ11 -> 0:11
<7>[    7.456758] IRQ12 -> 0:12
<7>[    7.459771] IRQ13 -> 0:13
<7>[    7.462755] IRQ14 -> 0:14
<7>[    7.465760] IRQ15 -> 0:15
<7>[    7.468745] IRQ16 -> 0:16
<7>[    7.471758] IRQ20 -> 0:20
<6>[    7.474752] .................................... done.
<5>[    7.480772] Loading compiled-in X.509 certificates
<5>[    7.487380] Loaded X.509 cert 'Magrathea: Glacier signing key: 51f66d467af578e89ed61c5fc40ea9267fc4638d'
<6>[    7.498144] registered taskstats version 1
<5>[    7.504819] Key type trusted registered
<5>[    7.510903] Key type encrypted registered
<6>[    7.517031] ima: No TPM chip found, activating TPM-bypass!
<6>[    7.523298] evm: HMAC attrs: 0x1
<6>[    7.527403] rtc_cmos 00:02: setting system clock to 2014-10-11 12:42:27 UTC (1413031347)
<7>[    7.637423] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
<7>[    7.743756] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
<6>[    7.749538] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>[    7.767812] Switched to clocksource tsc
<6>[   10.448308] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
<6>[   10.457765] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>[   10.468714] Sending DHCP requests .., OK
<4>[   13.020837] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.151
<6>[   13.029682] IP-Config: Complete:
<6>[   13.033339]      device=eth0, hwaddr=00:13:20:fc:e4:31, ipaddr=192.168.1.151, mask=255.255.255.0, gw=192.168.1.1
<6>[   13.044868]      host=lkp-bdw01, domain=lkp.intel.com, nis-domain=(none)
<6>[   13.052457]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>[   13.060048]      nameserver0=192.168.1.1
<7>[   13.064716] PM: Hibernation image not present or could not be loaded.
<6>[   13.073207] Freeing unused kernel memory: 1804K (ffffffff81dd1000 - ffffffff81f94000)
<6>[   13.252738] sdhci: Secure Digital Host Controller Interface driver
<6>[   13.259740] sdhci: Copyright(c) Pierre Ossman
<7>[   13.416747] libata version 3.00 loaded.
<6>[   13.422192] input: PC Speaker as /devices/platform/pcspkr/input/input5
<7>[   13.436087] ahci 0000:00:1f.2: version 3.0
<7>[   13.441301] IOAPIC[0]: Set routing entry (2-19 -> 0xe1 -> IRQ 19 Mode:1 Active:1 Dest:15)
<7>[   13.450647] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E1 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<7>[   13.466076] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
<6>[   13.474281] [drm] Initialized drm 1.1.0 20060810
<6>[   13.483502] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 2 ports 6 Gbps 0x2 impl SATA mode
<6>[   13.492692] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo only pio slum part deso sadm sds apst 
<3>[   13.521023] Error: Driver 'pcspkr' is already registered, aborting...
<6>[   13.524899] scsi host0: ahci
<6>[   13.525044] scsi host1: ahci
<6>[   13.525122] ata1: DUMMY
<6>[   13.525125] ata2: SATA max UDMA/133 abar m2048@0xc1137000 port 0xc1137180 irq 46
<7>[   13.525333] IOAPIC[0]: Set routing entry (2-18 -> 0x42 -> IRQ 18 Mode:1 Active:1 Dest:15)
<7>[   13.525342] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:42 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<4>[   13.525357] ACPI Warning: SystemIO range 0x000000000000efa0-0x000000000000efbf conflicts with OpRegion 0x000000000000efa0-0x000000000000efaf (\_SB_.PCI0.SBUS.SMBI) (20140724/utaddress-258)
<6>[   13.525358] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<6>[   13.602975] [drm] Memory usable by graphics device = 4096M
<6>[   13.609201] [drm] Replacing VGA console driver
<7>[   13.628051] i915 0000:00:02.0: irq 47 for MSI/MSI-X
<6>[   13.633603] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
<6>[   13.641100] [drm] Driver supports precise vblank timestamp query.
<6>[   13.648111] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
<6>[   13.691672] fbcon: inteldrmfb (fb0) is primary device
<6>[   13.707423] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
<6>[   13.707532] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
<6>[   13.707651] [drm] Initialized i915 1.6.0 20141003 for 0000:00:02.0 on minor 0
<6>[   13.832196] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<6>[   13.843200] ata2.00: ATA-9: INTEL SSDSC2CW120A3, 400i, max UDMA/133
<6>[   13.843202] ata2.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
<6>[   13.853148] ata2.00: configured for UDMA/133
<5>[   13.853417] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW12 400i PQ: 0 ANSI: 5
<4>[   13.959058] ------------[ cut here ]------------
<4>[   13.959092] WARNING: CPU: 0 PID: 75 at drivers/gpu/drm/i915/intel_pm.c:6231 sandybridge_pcode_write+0x171/0x190 [i915]()
<4>[   13.959112] Modules linked in: snd_hda_intel i915 snd_hda_controller snd_hda_codec snd_hwdep snd_pcm drm_kms_helper snd_timer snd winbond_cir drm soundcore ahci libahci rc_core pcspkr i2c_i801 libata parport_pc parport i2c_hid sdhci_acpi sdhci mmc_core video dw_dmac dw_dmac_core acpi_pad
<4>[   13.959115] CPU: 0 PID: 75 Comm: kworker/u16:1 Not tainted 3.17.0-rc7-g5ba60fc #1
<4>[   13.959116] Hardware name: Intel Corporation Broadwell Client platform/WhiteTip Mountain 1, BIOS BDW-E1R1.86C.0079.R00.1406020127 06/02/2014
<4>[   13.959122] Workqueue: events_unbound async_run_entry_fn
<4>[   13.959126]  0000000000000009 ffff880092cbb850 ffffffff818570a6 0000000000000000
<4>[   13.959129]  ffff880092cbb888 ffffffff8106ef1d ffff88014d380000 0000000000000000
<4>[   13.959131]  0000000000000018 ffff88014dc862f0 ffff88014d380000 ffff880092cbb898
<4>[   13.959132] Call Trace:
<4>[   13.959137]  [<ffffffff818570a6>] dump_stack+0x4d/0x66
<4>[   13.959142]  [<ffffffff8106ef1d>] warn_slowpath_common+0x7d/0xa0
<4>[   13.959145]  [<ffffffff8106effa>] warn_slowpath_null+0x1a/0x20
<4>[   13.959173]  [<ffffffffa0213a51>] sandybridge_pcode_write+0x171/0x190 [i915]
<4>[   13.959212]  [<ffffffffa0267926>] haswell_modeset_global_resources+0x196/0x4a0 [i915]
<4>[   13.959248]  [<ffffffffa0269188>] __intel_set_mode+0x718/0xb20 [i915]
<4>[   13.959280]  [<ffffffffa026f146>] intel_set_mode+0x16/0x30 [i915]
<4>[   13.959309]  [<ffffffffa027025a>] intel_crtc_set_config+0xa9a/0xea0 [i915]
<4>[   13.959328]  [<ffffffffa01406c0>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   13.959336]  [<ffffffffa01d2df3>] restore_fbdev_mode+0xd3/0x100 [drm_kms_helper]
<4>[   13.959342]  [<ffffffffa01d2e43>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
<4>[   13.959349]  [<ffffffffa01d48f8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
<4>[   13.959384]  [<ffffffffa027afca>] intel_fbdev_set_par+0x1a/0x60 [i915]
<4>[   13.959388]  [<ffffffff81453f18>] fbcon_init+0x578/0x600
<4>[   13.959391]  [<ffffffff814cb978>] visual_init+0xb8/0x120
<4>[   13.959394]  [<ffffffff814cdf0e>] do_bind_con_driver+0x17e/0x3b0
<4>[   13.959397]  [<ffffffff814ce6e4>] do_take_over_console+0xb4/0x1b0
<4>[   13.959401]  [<ffffffff8144ee43>] do_fbcon_takeover+0x63/0xd0
<4>[   13.959403]  [<ffffffff81454a3d>] fbcon_event_notify+0x6cd/0x7d0
<4>[   13.959407]  [<ffffffff8108f45d>] notifier_call_chain+0x4d/0x70
<4>[   13.959411]  [<ffffffff8108f7c7>] __blocking_notifier_call_chain+0x47/0x60
<4>[   13.959414]  [<ffffffff8108f7f6>] blocking_notifier_call_chain+0x16/0x20
<4>[   13.959417]  [<ffffffff8145a6fb>] fb_notifier_call_chain+0x1b/0x20
<4>[   13.959420]  [<ffffffff8145ca66>] register_framebuffer+0x206/0x340
<4>[   13.959427]  [<ffffffffa01d4b9f>] drm_fb_helper_initial_config+0x25f/0x3b0 [drm_kms_helper]
<4>[   13.959460]  [<ffffffffa027c20b>] intel_fbdev_initial_config+0x1b/0x20 [i915]
<4>[   13.959463]  [<ffffffff81090ee9>] async_run_entry_fn+0x39/0x120
<4>[   13.959468]  [<ffffffff8108814a>] process_one_work+0x15a/0x4b0
<4>[   13.959471]  [<ffffffff8108850b>] worker_thread+0x6b/0x5e0
<4>[   13.959475]  [<ffffffff810884a0>] ? process_one_work+0x4b0/0x4b0
<4>[   13.959478]  [<ffffffff8108e1ab>] kthread+0xdb/0x100
<4>[   13.959482]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
<4>[   13.959486]  [<ffffffff8185fcbc>] ret_from_fork+0x7c/0xb0
<4>[   13.959489]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
<4>[   13.959490] ---[ end trace cdab09cd792673ee ]---
<4>[   13.961051] ------------[ cut here ]------------
<4>[   13.961081] WARNING: CPU: 0 PID: 75 at drivers/gpu/drm/i915/intel_pm.c:6231 sandybridge_pcode_write+0x171/0x190 [i915]()
<4>[   13.961099] Modules linked in: snd_hda_intel i915 snd_hda_controller snd_hda_codec snd_hwdep snd_pcm drm_kms_helper snd_timer snd winbond_cir drm soundcore ahci libahci rc_core pcspkr i2c_i801 libata parport_pc parport i2c_hid sdhci_acpi sdhci mmc_core video dw_dmac dw_dmac_core acpi_pad
<4>[   13.961102] CPU: 0 PID: 75 Comm: kworker/u16:1 Tainted: G        W      3.17.0-rc7-g5ba60fc #1
<4>[   13.961103] Hardware name: Intel Corporation Broadwell Client platform/WhiteTip Mountain 1, BIOS BDW-E1R1.86C.0079.R00.1406020127 06/02/2014
<4>[   13.961107] Workqueue: events_unbound async_run_entry_fn
<4>[   13.961110]  0000000000000009 ffff880092cbb850 ffffffff818570a6 0000000000000000
<4>[   13.961113]  ffff880092cbb888 ffffffff8106ef1d ffff88014d380000 0000000000000000
<4>[   13.961116]  0000000000000017 00000000fffb9c7a ffff88014d380000 ffff880092cbb898
<4>[   13.961116] Call Trace:
<4>[   13.961119]  [<ffffffff818570a6>] dump_stack+0x4d/0x66
<4>[   13.961123]  [<ffffffff8106ef1d>] warn_slowpath_common+0x7d/0xa0
<4>[   13.961127]  [<ffffffff8106effa>] warn_slowpath_null+0x1a/0x20
<4>[   13.961151]  [<ffffffffa0213a51>] sandybridge_pcode_write+0x171/0x190 [i915]
<4>[   13.961186]  [<ffffffffa0267a95>] haswell_modeset_global_resources+0x305/0x4a0 [i915]
<4>[   13.961215]  [<ffffffffa0269188>] __intel_set_mode+0x718/0xb20 [i915]
<4>[   13.961244]  [<ffffffffa026f146>] intel_set_mode+0x16/0x30 [i915]
<4>[   13.961271]  [<ffffffffa027025a>] intel_crtc_set_config+0xa9a/0xea0 [i915]
<4>[   13.961288]  [<ffffffffa01406c0>] drm_mode_set_config_internal+0x60/0xf0 [drm]
<4>[   13.961295]  [<ffffffffa01d2df3>] restore_fbdev_mode+0xd3/0x100 [drm_kms_helper]
<4>[   13.961302]  [<ffffffffa01d2e43>] drm_fb_helper_restore_fbdev_mode_unlocked+0x23/0x40 [drm_kms_helper]
<4>[   13.961308]  [<ffffffffa01d48f8>] drm_fb_helper_set_par+0x28/0x70 [drm_kms_helper]
<4>[   13.961342]  [<ffffffffa027afca>] intel_fbdev_set_par+0x1a/0x60 [i915]
<4>[   13.961345]  [<ffffffff81453f18>] fbcon_init+0x578/0x600
<4>[   13.961348]  [<ffffffff814cb978>] visual_init+0xb8/0x120
<4>[   13.961351]  [<ffffffff814cdf0e>] do_bind_con_driver+0x17e/0x3b0
<4>[   13.961353]  [<ffffffff814ce6e4>] do_take_over_console+0xb4/0x1b0
<4>[   13.961357]  [<ffffffff8144ee43>] do_fbcon_takeover+0x63/0xd0
<4>[   13.961360]  [<ffffffff81454a3d>] fbcon_event_notify+0x6cd/0x7d0
<4>[   13.961363]  [<ffffffff8108f45d>] notifier_call_chain+0x4d/0x70
<4>[   13.961367]  [<ffffffff8108f7c7>] __blocking_notifier_call_chain+0x47/0x60
<4>[   13.961370]  [<ffffffff8108f7f6>] blocking_notifier_call_chain+0x16/0x20
<4>[   13.961373]  [<ffffffff8145a6fb>] fb_notifier_call_chain+0x1b/0x20
<4>[   13.961376]  [<ffffffff8145ca66>] register_framebuffer+0x206/0x340
<4>[   13.961383]  [<ffffffffa01d4b9f>] drm_fb_helper_initial_config+0x25f/0x3b0 [drm_kms_helper]
<4>[   13.961413]  [<ffffffffa027c20b>] intel_fbdev_initial_config+0x1b/0x20 [i915]
<4>[   13.961417]  [<ffffffff81090ee9>] async_run_entry_fn+0x39/0x120
<4>[   13.961421]  [<ffffffff8108814a>] process_one_work+0x15a/0x4b0
<4>[   13.961424]  [<ffffffff8108850b>] worker_thread+0x6b/0x5e0
<4>[   13.961428]  [<ffffffff810884a0>] ? process_one_work+0x4b0/0x4b0
<4>[   13.961431]  [<ffffffff8108e1ab>] kthread+0xdb/0x100
<4>[   13.961434]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
<4>[   13.961438]  [<ffffffff8185fcbc>] ret_from_fork+0x7c/0xb0
<4>[   13.961441]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
<4>[   13.961442] ---[ end trace cdab09cd792673ef ]---
<6>[   14.751502] Console: switching to colour frame buffer device 240x67
<6>[   15.651593] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
<6>[   15.660082] i915 0000:00:02.0: registered panic notifier
<7>[   15.672838] snd_hda_intel 0000:00:03.0: irq 48 for MSI/MSI-X
<6>[   15.688270] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input7
<6>[   15.700400] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input8
<6>[   15.712512] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
<5>[   15.743823] sd 1:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
<5>[   15.754178] sd 1:0:0:0: [sda] Write Protect is off
<7>[   15.761083] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[   15.768286] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6>[   15.781319]  sda: sda1 sda2
<5>[   15.786405] sd 1:0:0:0: [sda] Attached SCSI disk
<5>[   15.796816] sd 1:0:0:0: Attached scsi generic sg0 type 0
<5>[   16.243839] random: dd urandom read with 63 bits of entropy available
<6>[   23.397767] ipmi message handler version 39.2
<6>[   23.406892] IPMI Watchdog: driver initialized

--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-1

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-g5ba60fc (kbuild@cairo) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Sat Oct 11 12:38:06 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-bdw01/validate_boot-1-x86_64-rhel-5ba60fc3d719988a404d35a3e46f109bea643fef-2.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/vmlinuz-3.17.0-rc7-g5ba60fc kconfig=x86_64-rhel commit=5ba60fc3d719988a404d35a3e46f109bea643fef branch=linux-devel/devel-hourly-2014100721 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-bdw01/boot/1/debian-x86_64.cgz/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/2 ip=::::lkp-bdw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009a3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009a400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009df19fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009df1a000-0x000000009df38fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000009df39000-0x00000000ab262fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ab263000-0x00000000ab762fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ab763000-0x00000000ab7b5fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ab7b6000-0x00000000ab7e1fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000ab7e2000-0x00000000ab7fefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ab7ff000-0x00000000af7fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed84000-0x00000000fed84fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed90000-0x00000000fed91fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000014f7fffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation Broadwell Client platform/WhiteTip Mountain 1, BIOS BDW-E1R1.86C.0079.R00.1406020127 06/02/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x14f800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00C0000000 mask 7FC0000000 uncachable
[    0.000000]   1 base 00B0000000 mask 7FF0000000 uncachable
[    0.000000]   2 base 00AE000000 mask 7FFE000000 uncachable
[    0.000000]   3 base 00AD000000 mask 7FFF000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xab7ff max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009a400-0x0009a7ff]
[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x14f177000, 0x14f177fff] PGTABLE
[    0.000000] BRK [0x14f178000, 0x14f178fff] PGTABLE
[    0.000000] BRK [0x14f179000, 0x14f179fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x14f600000-0x14f7fffff]
[    0.000000]  [mem 0x14f600000-0x14f7fffff] page 2M
[    0.000000] BRK [0x14f17a000, 0x14f17afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x14c000000-0x14f5fffff]
[    0.000000]  [mem 0x14c000000-0x14f5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x14bffffff]
[    0.000000]  [mem 0x100000000-0x13fffffff] page 1G
[    0.000000]  [mem 0x140000000-0x14bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x9df19fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0x9ddfffff] page 2M
[    0.000000]  [mem 0x9de00000-0x9df19fff] page 4k
[    0.000000] BRK [0x14f17b000, 0x14f17bfff] PGTABLE
[    0.000000] BRK [0x14f17c000, 0x14f17cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x9df39000-0xab262fff]
[    0.000000]  [mem 0x9df39000-0x9dffffff] page 4k
[    0.000000]  [mem 0x9e000000-0xab1fffff] page 2M
[    0.000000]  [mem 0xab200000-0xab262fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xab7e2000-0xab7fefff]
[    0.000000]  [mem 0xab7e2000-0xab7fefff] page 4k
[    0.000000] RAMDISK: [mem 0x1466d3000-0x14dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000AB7C8188 000114 (v01 INTEL  BDW-ULT  00000000      01000013)
[    0.000000] ACPI: FACP 0x00000000AB7D7000 0000F4 (v05 INTEL  BDW-ULT  00000000 MSFT 0000005F)
[    0.000000] ACPI: DSDT 0x000000009DF1A000 01E50D (v02 INTEL  BDW      00000000 INTL 20130927)
[    0.000000] ACPI: FACS 0x00000000AB79D000 000040
[    0.000000] ACPI: TCPA 0x00000000AB7DF000 000032 (v02 INTEL  EDK2     00000002      01000013)
[    0.000000] ACPI: UEFI 0x00000000AB7A0000 000042 (v01 INTEL  EDK2     00000002      01000013)
[    0.000000] ACPI: SSDT 0x00000000AB7DE000 0004B5 (v01 Intel_ Tpm2Tabl 00001000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7DD000 00004E (v01 MeSsdt MeSsdt   00003000 INTL 20130927)
[    0.000000] ACPI: TPM2 0x00000000AB7DC000 000034 (v03                 00000000      00000000)
[    0.000000] ACPI: SSDT 0x00000000AB7DB000 0005B1 (v01 Intel  PerfTune 00001000 INTL 20130927)
[    0.000000] ACPI: DBGP 0x00000000AB7DA000 000034 (v01 INTEL           00000000 MSFT 0000005F)
[    0.000000] ACPI: DBG2 0x00000000AB7D9000 000054 (v00 INTEL           00000000 MSFT 0000005F)
[    0.000000] ACPI: LPIT 0x00000000AB7D8000 000094 (v01 INTEL  BDW-ULT  00000000 MSFT 0000005F)
[    0.000000] ACPI: HPET 0x00000000AB7D6000 000038 (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
[    0.000000] ACPI: APIC 0x00000000AB7D5000 0000BC (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
[    0.000000] ACPI: MCFG 0x00000000AB7D4000 00003C (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
[    0.000000] ACPI: WDAT 0x00000000AB7D3000 000104 (v01 INTEL  BDW-ULT  00000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x00000000AB7D2000 000250 (v01 INTEL  sensrhub 00000000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7CE000 00340B (v01 INTEL  PtidDevc 00001000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7CD000 000C7D (v01 INTEL  Ther_Rvp 00001000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7CC000 00017F (v01 INTEL  zpodd    00001000 INTL 20130927)
[    0.000000] ACPI: BOOT 0x00000000AB7CB000 000028 (v01 INTEL  TIANO    00000002 MSFT 01000013)
[    0.000000] ACPI: SSDT 0x00000000AB7CA000 0004D8 (v01 PmRef  Cpu0Ist  00003000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7C9000 000B74 (v01 CpuRef CpuSsdt  00003000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7C1000 006F06 (v01 SaSsdt SaSsdt   00003000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7E0000 0006A7 (v01 CppcTa CppcTabl 00001000 INTL 20130927)
[    0.000000] ACPI: PCCT 0x00000000AB7C0000 00006E (v05 PcctTa PcctTabl 00001000 INTL 20130927)
[    0.000000] ACPI: SSDT 0x00000000AB7BF000 000AC4 (v01 Cpc_Ta Cpc_Tabl 00001000 INTL 20130927)
[    0.000000] ACPI: CSRT 0x00000000AB7BE000 0000C4 (v01 INTL   BDW-ULT  00000001 INTL 20100528)
[    0.000000] ACPI: DMAR 0x00000000AB7BD000 0000F0 (v01 INTEL  BDW      00000001 INTL 00000001)
[    0.000000] ACPI: FPDT 0x00000000AB7BC000 000044 (v01 INTEL  EDK2     00000002      01000013)
[    0.000000] ACPI: ASF! 0x00000000AB7BB000 0000A0 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[    0.000000] ACPI: BGRT 0x00000000AB7BA000 000038 (v01 INTEL  EDK2     00000002      01000013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000014f7fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x14f7fffff]
[    0.000000]   NODE_DATA [mem 0x14f7d8000-0x14f7fdfff]
[    0.000000]  [ffffea0000000000-ffffea00053fffff] PMD -> [ffff880142200000-ffff8801461fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x14f7fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
[    0.000000]   node   0: [mem 0x00100000-0x9df19fff]
[    0.000000]   node   0: [mem 0x9df39000-0xab262fff]
[    0.000000]   node   0: [mem 0xab7e2000-0xab7fefff]
[    0.000000]   node   0: [mem 0x100000000-0x14f7fffff]
[    0.000000] On node 0 totalpages: 1026554
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3993 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10890 pages used for memmap
[    0.000000]   DMA32 zone: 696929 pages, LIFO batch:31
[    0.000000]   Normal zone: 5088 pages used for memmap
[    0.000000]   Normal zone: 325632 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xad800000-0xaf7fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009afff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9df1a000-0x9df38fff]
[    0.000000] PM: Registered nosave memory: [mem 0xab263000-0xab762fff]
[    0.000000] PM: Registered nosave memory: [mem 0xab763000-0xab7b5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xab7b6000-0xab7e1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xab7ff000-0xaf7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xaf800000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfed83fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed84000-0xfed84fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed85000-0xfed8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfed91fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed92000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xff9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffa00000-0xffffffff]
[    0.000000] e820: [mem 0xaf800000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88014f400000 s88960 r8192 d21632 u262144
[    0.000000] pcpu-alloc: s88960 r8192 d21632 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1010491
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-bdw01/validate_boot-1-x86_64-rhel-5ba60fc3d719988a404d35a3e46f109bea643fef-2.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/vmlinuz-3.17.0-rc7-g5ba60fc kconfig=x86_64-rhel commit=5ba60fc3d719988a404d35a3e46f109bea643fef branch=linux-devel/devel-hourly-2014100721 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-bdw01/boot/1/debian-x86_64.cgz/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/2 ip=::::lkp-bdw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 3831208K/4106216K available (8595K kernel code, 1702K rwdata, 3832K rodata, 1804K init, 1888K bss, 275008K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:524544 nr_irqs:760 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1596.191 MHz processor
[    0.000042] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.38 BogoMIPS (lpj=1596191)
[    0.012085] pid_max: default: 32768 minimum: 301
[    0.017326] ACPI: Core revision 20140724
[    0.061442] ACPI: All ACPI Tables successfully acquired
[    0.067425] Security Framework initialized
[    0.072073] SELinux:  Initializing.
[    0.076022] SELinux:  Starting in permissive mode
[    0.081739] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.091028] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.099493] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.107098] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.115430] Initializing cgroup subsys memory
[    0.120374] Initializing cgroup subsys devices
[    0.125411] Initializing cgroup subsys freezer
[    0.130449] Initializing cgroup subsys net_cls
[    0.135488] Initializing cgroup subsys blkio
[    0.140328] Initializing cgroup subsys perf_event
[    0.145662] Initializing cgroup subsys hugetlb
[    0.150727] CPU: Physical Processor ID: 0
[    0.155272] CPU: Processor Core ID: 1
[    0.160714] mce: CPU supports 7 MCE banks
[    0.165270] CPU0: Thermal LVT vector (0xfa) already installed
[    0.171793] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.171793] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.185184] Freeing SMP alternatives memory: 36K (ffffffff81f94000 - ffffffff81f9d000)
[    0.195466] ftrace: allocating 31083 entries in 122 pages
[    0.220145] Getting VERSION: 1060015
[    0.224201] Getting VERSION: 1060015
[    0.228253] Getting ID: 2000000
[    0.231814] Getting ID: 2000000
[    0.235383] dmar: Host address width 39
[    0.239732] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.245760] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 7e1ff0505e
[    0.255432] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.261458] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap d2008c20660462 ecap f010da
[    0.270634] dmar: RMRR base: 0x000000ab6f2000 end: 0x000000ab705fff
[    0.277741] dmar: RMRR base: 0x000000ad000000 end: 0x000000af7fffff
[    0.284848] dmar: ANDD device: 1 name: \_SB.PCI0.SDMA
[    0.290575] dmar: ANDD device: 2 name: \_SB.PCI0.SDHC
[    0.296428] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.302738] HPET id 0 under DRHD base 0xfed91000
[    0.307972] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.316852] Your BIOS is broken and requested that x2apic be disabled.
[    0.316852] This will slightly decrease performance.
[    0.316852] Use 'intremap=no_x2apic_optout' to override BIOS request.
[    0.337454] Enabled IRQ remapping in xapic mode
[    0.342588] x2apic not enabled, IRQ remapping is in xapic mode
[    0.349210] masked ExtINT on CPU#0
[    0.353511] ENABLING IO-APIC IRQs
[    0.357269] init IO_APIC IRQs
[    0.360633]  apic 2 pin 0 not connected
[    0.364984] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.373968] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.389257] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.398238] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.413525] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.422518] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.437809] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.446791] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.462082] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.471068] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.486358] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.495343] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:35 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.510634] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.519618] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:36 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.534909] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.543891] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:37 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.559182] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.568165] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.583456] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.592438] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.607728] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.616908] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3A Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.632197] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.641379] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3B Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.656668] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.665851] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3C Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.681140] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.690323] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.705613] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.714795] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3E Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.730084] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.739264] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3F Dest:00000100 SID:F0F8 SQ:0 SVT:1)
[    0.754551]  apic 2 pin 16 not connected
[    0.758991]  apic 2 pin 17 not connected
[    0.763439]  apic 2 pin 18 not connected
[    0.767887]  apic 2 pin 19 not connected
[    0.772335]  apic 2 pin 20 not connected
[    0.776783]  apic 2 pin 21 not connected
[    0.781231]  apic 2 pin 22 not connected
[    0.785679]  apic 2 pin 23 not connected
[    0.790126]  apic 2 pin 24 not connected
[    0.794574]  apic 2 pin 25 not connected
[    0.799022]  apic 2 pin 26 not connected
[    0.803471]  apic 2 pin 27 not connected
[    0.807920]  apic 2 pin 28 not connected
[    0.812368]  apic 2 pin 29 not connected
[    0.816818]  apic 2 pin 30 not connected
[    0.821265]  apic 2 pin 31 not connected
[    0.825714]  apic 2 pin 32 not connected
[    0.830162]  apic 2 pin 33 not connected
[    0.834610]  apic 2 pin 34 not connected
[    0.839058]  apic 2 pin 35 not connected
[    0.843506]  apic 2 pin 36 not connected
[    0.847954]  apic 2 pin 37 not connected
[    0.852403]  apic 2 pin 38 not connected
[    0.856851]  apic 2 pin 39 not connected
[    0.861444] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.878266] smpboot: CPU0: Genuine Intel(R) CPU 0000 @ 1.60GHz (fam: 06, model: 3d, stepping: 03)
[    0.888379] TSC deadline timer enabled
[    0.892660] Performance Events: PEBS fmt2+, generic architected perfmon, full-width counters, Intel PMU driver.
[    0.904158] ... version:                3
[    0.908705] ... bit width:              48
[    0.913351] ... generic registers:      4
[    0.917899] ... value mask:             0000ffffffffffff
[    0.923923] ... max period:             0000ffffffffffff
[    0.929948] ... fixed-purpose events:   3
[    0.934494] ... event mask:             000000070000000f
[    0.942868] x86: Booting SMP configuration:
[    0.947616] .... node  #0, CPUs:      #1
[    0.963005] masked ExtINT on CPU#1
[    0.968371] CPU1: Thermal LVT vector (0xfa) already installed
[    0.977051] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.986228]  #2
[    0.999137] masked ExtINT on CPU#2
[    1.004500] CPU2: Thermal LVT vector (0xfa) already installed
[    1.013193]  #3
[    1.026172] masked ExtINT on CPU#3
[    1.031575] CPU3: Thermal LVT vector (0xfa) already installed
[    1.040160] x86: Booted up 1 node, 4 CPUs
[    1.044711] smpboot: Total of 4 processors activated (12769.52 BogoMIPS)
[    1.058540] devtmpfs: initialized
[    1.064940] evm: security.selinux
[    1.068699] evm: security.ima
[    1.072064] evm: security.capability
[    1.076269] PM: Registering ACPI NVS region [mem 0xab763000-0xab7b5fff] (339968 bytes)
[    1.086427] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    1.094452] NET: Registered protocol family 16
[    1.099741] cpuidle: using governor menu
[    1.104335] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    1.112922] ACPI: bus type PCI registered
[    1.117470] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.124861] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.135422] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    1.143557] PCI: Using configuration type 1 for base access
[    1.154300] ACPI: Added _OSI(Module Device)
[    1.159049] ACPI: Added _OSI(Processor Device)
[    1.164090] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.169417] ACPI: Added _OSI(Processor Aggregator Device)
[    1.179948] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:15)
[    1.189034] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    1.212319] ACPI: Executed 18 blocks of module-level executable AML code
[    1.239600] ACPI: Dynamic OEM Table Load:
[    1.244191] ACPI: SSDT 0xFFFF88013FCB1800 0004AE (v01 PmRef  Cpu0Cst  00003001 INTL 20130927)
[    1.258743] ACPI: Dynamic OEM Table Load:
[    1.263336] ACPI: SSDT 0xFFFF88013FED8000 000792 (v01 PmRef  ApIst    00003000 INTL 20130927)
[    1.276639] ACPI: Dynamic OEM Table Load:
[    1.281216] ACPI: SSDT 0xFFFF88013FED4E00 000119 (v01 PmRef  ApCst    00003000 INTL 20130927)
[    1.299421] ACPI: Interpreter enabled
[    1.303587] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
[    1.314112] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    1.324653] ACPI: (supports S0 S3 S4 S5)
[    1.329117] ACPI: Using IOAPIC for interrupt routing
[    1.334803] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.345759] ACPI: Power Resource [PG00] (on)
[    1.356910] ACPI: Power Resource [PG01] (on)
[    1.365916] ACPI: Power Resource [PG02] (on)
[    1.397614] acpi ABCD0000:00: ACPI dock station (docks/bays count: 1)
[    1.406430] ACPI: Power Resource [FN00] (off)
[    1.411464] ACPI: Power Resource [FN01] (off)
[    1.416495] ACPI: Power Resource [FN02] (off)
[    1.421521] ACPI: Power Resource [FN03] (off)
[    1.426549] ACPI: Power Resource [FN04] (off)
[    1.432803] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    1.439822] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.450184] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    1.460564] PCI host bridge to bus 0000:00
[    1.465213] pci_bus 0000:00: root bus resource [bus 00-fe]
[    1.471453] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.478478] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.485499] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.493322] pci_bus 0000:00: root bus resource [mem 0xaf800000-0xfeafffff]
[    1.501146] pci 0000:00:00.0: [8086:1604] type 00 class 0x060000
[    1.508261] pci 0000:00:02.0: [8086:1616] type 00 class 0x030000
[    1.515088] pci 0000:00:02.0: reg 0x10: [mem 0xc0000000-0xc0ffffff 64bit]
[    1.522797] pci 0000:00:02.0: reg 0x18: [mem 0xb0000000-0xbfffffff 64bit pref]
[    1.530994] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
[    1.537611] pci 0000:00:03.0: [8086:160c] type 00 class 0x040300
[    1.544434] pci 0000:00:03.0: reg 0x10: [mem 0xc1130000-0xc1133fff 64bit]
[    1.552446] pci 0000:00:14.0: [8086:9cb1] type 00 class 0x0c0330
[    1.559281] pci 0000:00:14.0: reg 0x10: [mem 0xc1120000-0xc112ffff 64bit]
[    1.567048] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    1.573912] pci 0000:00:14.0: System wakeup disabled by ACPI
[    1.580377] pci 0000:00:16.0: [8086:9cba] type 00 class 0x078000
[    1.587212] pci 0000:00:16.0: reg 0x10: [mem 0xc1135000-0xc113501f 64bit]
[    1.594988] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.602187] pci 0000:00:19.0: [8086:15a2] type 00 class 0x020000
[    1.609017] pci 0000:00:19.0: reg 0x10: [mem 0xc1100000-0xc111ffff]
[    1.616133] pci 0000:00:19.0: reg 0x14: [mem 0xc1138000-0xc1138fff]
[    1.623251] pci 0000:00:19.0: reg 0x18: [io  0x3080-0x309f]
[    1.629634] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.636794] pci 0000:00:19.0: System wakeup disabled by ACPI
[    1.643249] pci 0000:00:1c.0: [8086:9c90] type 01 class 0x060400
[    1.650127] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.657281] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.663754] pci 0000:00:1f.0: [8086:9cc3] type 00 class 0x060100
[    1.670955] pci 0000:00:1f.2: [8086:9c83] type 00 class 0x010601
[    1.677784] pci 0000:00:1f.2: reg 0x10: [io  0x30a8-0x30af]
[    1.684110] pci 0000:00:1f.2: reg 0x14: [io  0x30b4-0x30b7]
[    1.690435] pci 0000:00:1f.2: reg 0x18: [io  0x30a0-0x30a7]
[    1.696760] pci 0000:00:1f.2: reg 0x1c: [io  0x30b0-0x30b3]
[    1.703086] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
[    1.709413] pci 0000:00:1f.2: reg 0x24: [mem 0xc1137000-0xc11377ff]
[    1.716560] pci 0000:00:1f.2: PME# supported from D3hot
[    1.722760] pci 0000:00:1f.3: [8086:9ca2] type 00 class 0x0c0500
[    1.729588] pci 0000:00:1f.3: reg 0x10: [mem 0xc1134000-0xc11340ff 64bit]
[    1.737311] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    1.743920] pci 0000:00:1f.6: [8086:9ca4] type 00 class 0x118000
[    1.750765] pci 0000:00:1f.6: reg 0x10: [mem 0xc1136000-0xc1136fff 64bit]
[    1.758926] pci 0000:01:00.0: [8086:08b1] type 00 class 0x028000
[    1.765783] pci 0000:01:00.0: reg 0x10: [mem 0xc1000000-0xc1001fff 64bit]
[    1.773677] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    1.780632] pci 0000:01:00.0: System wakeup disabled by ACPI
[    1.789075] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.794710] pci 0000:00:1c.0:   bridge window [mem 0xc1000000-0xc10fffff]
[    1.802425] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    1.813432] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    1.822510] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.831784] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    1.840849] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    1.849913] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    1.858977] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.868250] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.877519] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.887343] ACPI: Enabled 4 GPEs in block 00 to 7F
[    1.893077] ACPI : EC: GPE = 0xa, I/O: command/status = 0x66, data = 0x62
[    1.900935] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.907354] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.916534] vgaarb: loaded
[    1.919604] vgaarb: bridge control possible 0000:00:02.0
[    1.925719] SCSI subsystem initialized
[    1.930008] ACPI: bus type USB registered
[    1.934578] usbcore: registered new interface driver usbfs
[    1.940811] usbcore: registered new interface driver hub
[    1.946865] usbcore: registered new device driver usb
[    1.952624] pps_core: LinuxPPS API ver. 1 registered
[    1.958254] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.968621] PTP clock support registered
[    1.973154] PCI: Using ACPI for IRQ routing
[    1.984146] PCI: pci_cache_line_size set to 64 bytes
[    1.989812] e820: reserve RAM buffer [mem 0x0009a400-0x0009ffff]
[    1.996618] e820: reserve RAM buffer [mem 0x9df1a000-0x9fffffff]
[    2.003433] e820: reserve RAM buffer [mem 0xab263000-0xabffffff]
[    2.010238] e820: reserve RAM buffer [mem 0xab7ff000-0xabffffff]
[    2.017052] e820: reserve RAM buffer [mem 0x14f800000-0x14fffffff]
[    2.024183] NetLabel: Initializing
[    2.028041] NetLabel:  domain hash size = 128
[    2.032981] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.038627] NetLabel:  unlabeled traffic allowed by default
[    2.045081] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    2.052185] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.060837] Switched to clocksource hpet
[    2.076562] pnp: PnP ACPI init
[    2.080435] system 00:00: [io  0x06a4] has been reserved
[    2.086467] system 00:00: [io  0x06a0] has been reserved
[    2.092496] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.100442] system 00:01: [io  0x0680-0x069f] has been reserved
[    2.107160] system 00:01: [io  0xffff] has been reserved
[    2.113190] system 00:01: [io  0xffff] has been reserved
[    2.119217] system 00:01: [io  0xffff] has been reserved
[    2.125245] system 00:01: [io  0x1800-0x18fe] could not be reserved
[    2.132356] system 00:01: [io  0x164e-0x164f] has been reserved
[    2.139073] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.146812] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    2.155902] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    2.171212] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.178663] system 00:03: [io  0x1854-0x1857] has been reserved
[    2.185382] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    2.194002] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
[    2.203088] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    2.218398] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.225884] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
[    2.234970] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    2.250275] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.258434] system 00:06: [mem 0xfe102000-0xfe102fff] has been reserved
[    2.265943] system 00:06: [mem 0xfe104000-0xfe104fff] has been reserved
[    2.273448] system 00:06: [mem 0xfe106000-0xfe106fff] has been reserved
[    2.280954] system 00:06: [mem 0xfe10e000-0xfe10efff] has been reserved
[    2.288459] system 00:06: [mem 0xfe112000-0xfe112fff] has been reserved
[    2.295965] system 00:06: [mem 0xfe111000-0xfe111007] has been reserved
[    2.303470] system 00:06: [mem 0xfe111014-0xfe111fff] has been reserved
[    2.310978] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.320203] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.327711] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    2.335216] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.342722] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.350230] system 00:07: [mem 0xe0000000-0xefffffff] has been reserved
[    2.357736] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.365243] system 00:07: [mem 0xfed90000-0xfed93fff] could not be reserved
[    2.373142] system 00:07: [mem 0xfed45000-0xfed8ffff] could not be reserved
[    2.381041] system 00:07: [mem 0xff000000-0xffffffff] could not be reserved
[    2.388940] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    2.396839] system 00:07: [mem 0xaf810000-0xaf81ffff] has been reserved
[    2.404344] system 00:07: [mem 0xaf800000-0xaf80ffff] has been reserved
[    2.411849] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.419842] system 00:08: [mem 0x00000000-0x0009cfff] could not be reserved
[    2.427747] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.435619] pnp: PnP ACPI: found 9 devices
[    2.446805] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    2.452445] pci 0000:00:1c.0:   bridge window [mem 0xc1000000-0xc10fffff]
[    2.460154] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.466477] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.472800] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.479911] pci_bus 0000:00: resource 7 [mem 0xaf800000-0xfeafffff]
[    2.487022] pci_bus 0000:01: resource 1 [mem 0xc1000000-0xc10fffff]
[    2.494165] NET: Registered protocol family 2
[    2.499350] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    2.507645] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    2.515228] TCP: Hash tables configured (established 32768 bind 32768)
[    2.522652] TCP: reno registered
[    2.526322] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    2.533146] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.540524] NET: Registered protocol family 1
[    2.545545] RPC: Registered named UNIX socket transport module.
[    2.552266] RPC: Registered udp transport module.
[    2.557604] RPC: Registered tcp transport module.
[    2.562942] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.570276] pci 0000:00:02.0: Video device with shadowed ROM
[    2.576810] pci 0000:00:14.0: can't derive routing for PCI INT A
[    2.583628] pci 0000:00:14.0: PCI INT A: no GSI
[    2.588870] pci 0000:00:14.0: can't derive routing for PCI INT A
[    2.595706] PCI: CLS 0 bytes, default 64
[    2.600215] Unpacking initramfs...
[    5.727637] Freeing initrd memory: 124084K (ffff8801466d3000 - ffff88014e000000)
[    5.736065] dmar: ACPI device "INTL9C60:00" under DMAR at fed91000 as 00:15.0
[    5.744169] dmar: ACPI device "INT3436:00" under DMAR at fed91000 as 00:17.0
[    5.752176] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.759489] software IO TLB [mem 0xa7263000-0xab263000] (64MB) mapped at [ffff8800a7263000-ffff8800ab262fff]
[    5.770791] Simple Boot Flag at 0x47 set to 0x80
[    5.776924] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    5.784063] Initialise system trusted keyring
[    5.789031] audit: initializing netlink subsys (disabled)
[    5.795168] audit: type=2000 audit(1413031782.698:1): initialized
[    5.802456] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.811548] zpool: loaded
[    5.814528] zbud: loaded
[    5.817616] VFS: Disk quotas dquot_6.5.2
[    5.822113] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.830016] SGI XFS with ACLs, security attributes, no debug enabled
[    5.837656] 9p: Installing v9fs 9p2000 file system support
[    5.843919] msgmni has been set to 7725
[    5.848342] Key type big_key registered
[    5.852698] SELinux:  Registering netfilter hooks
[    5.858662] NET: Registered protocol family 38
[    5.863716] Key type asymmetric registered
[    5.868368] Asymmetric key parser 'x509' registered
[    5.873953] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    5.882392] io scheduler noop registered
[    5.886848] io scheduler deadline registered (default)
[    5.892687] io scheduler cfq registered
[    5.897264] IOAPIC[0]: Set routing entry (2-16 -> 0x61 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    5.906553] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:61 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    5.921876] pcieport 0000:00:1c.0: irq 42 for MSI/MSI-X
[    5.927904] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    5.935806] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    5.943220] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    5.950846] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.957189] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.964743] intel_idle: MWAIT substates: 0x11142120
[    5.970281] intel_idle: v0.4 model 0x3D
[    5.974633] intel_idle: lapic_timer_reliable_states 0xffffffff
[    5.981615] ACPI: AC Adapter [ADP1] (off-line)
[    5.986782] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    5.996201] ACPI: Lid Switch [LID0]
[    6.000221] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    6.009701] ACPI: Power Button [PWRB]
[    6.013898] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    6.023376] ACPI: Sleep Button [SLPB]
[    6.027574] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    6.035968] ACPI: Power Button [PWRF]
[    6.040209] ACPI: Fan [FAN0] (off)
[    6.044100] ACPI: Fan [FAN1] (off)
[    6.047987] ACPI: Fan [FAN2] (off)
[    6.051871] ACPI: Fan [FAN3] (off)
[    6.055749] ACPI: Fan [FAN4] (off)
[    6.061052] thermal LNXTHERM:00: registered as thermal_zone0
[    6.067478] ACPI: Thermal Zone [TZ00] (52 C)
[    6.073121] thermal LNXTHERM:01: registered as thermal_zone1
[    6.079537] ACPI: Thermal Zone [TZ01] (52 C)
[    6.084435] GHES: HEST is not enabled!
[    6.084694] ACPI: Battery Slot [BAT0] (battery present)
[    6.084738] ACPI: Battery Slot [BAT1] (battery absent)
[    6.084834] ACPI: Battery Slot [BAT2] (battery absent)
[    6.106403] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    6.134156] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    6.143254] Non-volatile memory driver v1.3
[    6.148021] Linux agpgart interface v0.103
[    6.152952] mei_me 0000:00:16.0: irq 43 for MSI/MSI-X
[    6.160257] rdac: device handler registered
[    6.165234] hp_sw: device handler registered
[    6.170124] emc: device handler registered
[    6.174817] alua: device handler registered
[    6.179630] libphy: Fixed MDIO Bus: probed
[    6.184324] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    6.192321] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.198845] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    6.205464] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    6.212304] IOAPIC[0]: Set routing entry (2-20 -> 0x91 -> IRQ 20 Mode:1 Active:1 Dest:15)
[    6.221592] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:91 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[    6.236938] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    6.247518] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.417772] e1000e 0000:00:19.0 eth0: registered PHC clock
[    6.424005] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:13:20:fc:e4:31
[    6.432987] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    6.440813] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
[    6.448629] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.13-k
[    6.456628] igb: Copyright (c) 2007-2014 Intel Corporation.
[    6.462967] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    6.471756] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    6.478340] usbcore: registered new interface driver catc
[    6.484475] usbcore: registered new interface driver kaweth
[    6.490799] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    6.499197] usbcore: registered new interface driver pegasus
[    6.505626] usbcore: registered new interface driver rtl8150
[    6.512061] usbcore: registered new interface driver asix
[    6.518195] usbcore: registered new interface driver cdc_ether
[    6.524821] usbcore: registered new interface driver cdc_eem
[    6.531241] usbcore: registered new interface driver dm9601
[    6.537576] usbcore: registered new interface driver smsc75xx
[    6.544108] usbcore: registered new interface driver smsc95xx
[    6.550637] usbcore: registered new interface driver gl620a
[    6.556967] usbcore: registered new interface driver net1080
[    6.563387] usbcore: registered new interface driver plusb
[    6.569619] usbcore: registered new interface driver rndis_host
[    6.576336] usbcore: registered new interface driver cdc_subset
[    6.583061] usbcore: registered new interface driver zaurus
[    6.589392] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    6.597797] usbcore: registered new interface driver int51x1
[    6.604226] usbcore: registered new interface driver ipheth
[    6.610550] usbcore: registered new interface driver sierra_net
[    6.617321] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.624733] ehci-pci: EHCI PCI platform driver
[    6.629786] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.636803] ohci-pci: OHCI PCI platform driver
[    6.641857] uhci_hcd: USB Universal Host Controller Interface driver
[    6.649188] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
[    6.656499] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
[    6.662150] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    6.668130] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    6.676614] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    6.684343] xhci_hcd 0000:00:14.0: irq 45 for MSI/MSI-X
[    6.690337] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.698041] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.706236] usb usb1: Product: xHCI Host Controller
[    6.711771] usb usb1: Manufacturer: Linux 3.17.0-rc7-g5ba60fc xhci_hcd
[    6.719176] usb usb1: SerialNumber: 0000:00:14.0
[    6.724550] hub 1-0:1.0: USB hub found
[    6.728817] hub 1-0:1.0: 11 ports detected
[    6.737893] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    6.743876] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    6.752305] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    6.760011] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.768206] usb usb2: Product: xHCI Host Controller
[    6.773742] usb usb2: Manufacturer: Linux 3.17.0-rc7-g5ba60fc xhci_hcd
[    6.781150] usb usb2: SerialNumber: 0000:00:14.0
[    6.786394] tsc: Refined TSC clocksource calibration: 1596.304 MHz
[    6.793524] hub 2-0:1.0: USB hub found
[    6.797796] hub 2-0:1.0: 4 ports detected
[    6.804190] usbcore: registered new interface driver usbserial
[    6.810821] usbcore: registered new interface driver usbserial_generic
[    6.818235] usbserial: USB Serial support registered for generic
[    6.825078] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    6.832780] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    6.844929] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.850651] mousedev: PS/2 mouse device common for all mice
[    6.857239] rtc_cmos 00:02: RTC can wake from S4
[    6.862635] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    6.869587] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    6.878306] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    6.884658] iTCO_wdt: Found a Wildcat Point_LP TCO device (Version=2, TCOBASE=0x1860)
[    6.893637] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.900481] iTCO_vendor_support: vendor-support=0
[    6.905868] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    6.915656] Intel P-state driver initializing.
[    6.923025] hidraw: raw HID events driver (C) Jiri Kosina
[    6.929606] usbcore: registered new interface driver usbhid
[    6.935970] usbhid: USB HID core driver
[    6.940476] drop_monitor: Initializing network drop monitor service
[    6.947724] TCP: cubic registered
[    6.951499] Initializing XFRM netlink socket
[    6.956553] NET: Registered protocol family 10
[    6.962028] NET: Registered protocol family 17
[    6.967101] 9pnet: Installing 9P2000 support
[    6.972374] 
[    6.972374] printing PIC contents
[    6.977822] ... PIC  IMR: ffff
[    6.981278] ... PIC  IRR: 0c00
[    6.984754] ... PIC  ISR: 0000
[    6.988220] ... PIC ELCR: 0c00
[    6.991687] printing local APIC contents on CPU#0/2:
[    6.997317] ... APIC ID:      02000000 (2)
[    7.001962] ... APIC VERSION: 01060015
[    7.006212] ... APIC TASKPRI: 00000000 (00)
[    7.010954] ... APIC PROCPRI: 00000000
[    7.015202] ... APIC LDR: 01000000
[    7.019058] ... APIC DFR: ffffffff
[    7.022913] ... APIC SPIV: 000001ff
[    7.026867] ... APIC ISR field:
[    7.030427] 0000000000000000000000000000000000000000000000000000000000000000
[    7.038507] ... APIC TMR field:
[    7.042066] 0000000000000000000000000000000000000000000000000000000000000000
[    7.050145] ... APIC IRR field:
[    7.053704] 0000000000000000000000000000000000000000000200000000000000008000
[    7.061781] ... APIC ESR: 00000000
[    7.065638] ... APIC ICR: 000008fd
[    7.069493] ... APIC ICR2: 02000000
[    7.073447] ... APIC LVTT: 000400ef
[    7.077401] ... APIC LVTPC: 00000400
[    7.081453] ... APIC LVT0: 00010700
[    7.085408] ... APIC LVT1: 00000400
[    7.089362] ... APIC LVTERR: 000000fe
[    7.093513] ... APIC TMICT: 00000000
[    7.096963] usb 1-8: new full-speed USB device number 2 using xhci_hcd
[    7.104967] ... APIC TMCCT: 00000000
[    7.109019] ... APIC TDCR: 00000000
[    7.112973] 
[    7.114711] number of MP IRQ sources: 15.
[    7.119289] number of IO-APIC #2 registers: 40.
[    7.124448] testing the IO APIC.......................
[    7.130305] IO APIC #2......
[    7.133593] .... register #00: 02000000
[    7.137947] .......    : physical APIC id: 02
[    7.142910] .......    : Delivery Type: 0
[    7.147478] .......    : LTS          : 0
[    7.152047] .... register #01: 00270020
[    7.156419] .......     : max redirection entries: 27
[    7.162170] .......     : PRQ implemented: 0
[    7.167032] .......     : IO APIC version: 20
[    7.171994] .... register #02: 00000000
[    7.176377] .......     : arbitration: 00
[    7.180924] .... IRQ redirection table:
[    7.185282] 0   1    0    0   0   0    0     0    00
[    7.190939] 1   0    0    0   0   0    0     0    01
[    7.196588] 1   0    0    0   0   0    0     0    02
[    7.202244] 1   0    0    0   0   0    0     0    03
[    7.207901] 1   0    0    0   0   0    0     0    04
[    7.213558] 1   0    0    0   0   0    0     0    05
[    7.219216] 1   0    0    0   0   0    0     0    06
[    7.224874] 1   0    0    0   0   0    0     0    07
[    7.230532] 1   0    0    0   0   0    0     0    08
[    7.236189] 1   0    1    0   0   0    0     0    09
[    7.241844] 1   0    0    0   0   0    0     0    0A
[    7.247501] 1   0    0    0   0   0    0     0    0B
[    7.253159] 1   0    0    0   0   0    0     0    0C
[    7.258816] 1   0    0    0   0   0    0     0    0D
[    7.264473] 1   0    0    0   0   0    0     0    0E
[    7.270130] 1   0    0    0   0   0    0     0    0F
[    7.275792] 1   1    1    0   1   0    0     0    10
[    7.281453] 0   1    0    0   0   0    0     0    00
[    7.287108] 0   1    0    0   0   0    0     0    00
[    7.292751] 0   1    0    0   0   0    0     0    00
[    7.298401] 1   1    1    0   1   0    0     0    14
[    7.304079] 0   1    0    0   0   0    0     0    00
[    7.309745] 0   1    0    0   0   0    0     0    00
[    7.315405] 0   1    0    0   0   0    0     0    00
[    7.321063] 0   1    0    0   0   0    0     0    00
[    7.321071] usb 1-8: New USB device found, idVendor=8087, idProduct=07dc
[    7.321073] usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.342462] 0   1    0    0   0   0    0     0    00
[    7.348123] 0   1    0    0   0   0    0     0    00
[    7.353779] 0   1    0    0   0   0    0     0    00
[    7.359436] 0   1    0    0   0   0    0     0    00
[    7.365093] 0   1    0    0   0   0    0     0    00
[    7.370750] 0   1    0    0   0   0    0     0    00
[    7.376404] 0   1    0    0   0   0    0     0    00
[    7.382059] 0   1    0    0   0   0    0     0    00
[    7.387715] 0   1    0    0   0   0    0     0    00
[    7.393371] 0   1    0    0   0   0    0     0    00
[    7.399028] 0   1    0    0   0   0    0     0    00
[    7.404666] 0   1    0    0   0   0    0     0    00
[    7.410324] 0   1    0    0   0   0    0     0    00
[    7.415982] 0   1    0    0   0   0    0     0    00
[    7.421638] 0   1    0    0   0   0    0     0    00
[    7.427290] IRQ to pin mappings:
[    7.430973] IRQ0 -> 0:2
[    7.433775] IRQ1 -> 0:1
[    7.436596] IRQ3 -> 0:3
[    7.439396] IRQ4 -> 0:4
[    7.442205] IRQ5 -> 0:5
[    7.445010] IRQ6 -> 0:6
[    7.447802] IRQ7 -> 0:7
[    7.450620] IRQ8 -> 0:8
[    7.453420] IRQ9 -> 0:9
[    7.456241] IRQ10 -> 0:10
[    7.459238] IRQ11 -> 0:11
[    7.462244] IRQ12 -> 0:12
[    7.465253] IRQ13 -> 0:13
[    7.468248] IRQ14 -> 0:14
[    7.471263] IRQ15 -> 0:15
[    7.474252] IRQ16 -> 0:16
[    7.477270] IRQ20 -> 0:20
[    7.480286] .................................... done.
[    7.486410] Loading compiled-in X.509 certificates
[    7.493018] Loaded X.509 cert 'Magrathea: Glacier signing key: 51f66d467af578e89ed61c5fc40ea9267fc4638d'
[    7.503797] registered taskstats version 1
[    7.510289] Key type trusted registered
[    7.516213] Key type encrypted registered
[    7.522620] ima: No TPM chip found, activating TPM-bypass!
[    7.528892] evm: HMAC attrs: 0x1
[    7.533035] rtc_cmos 00:02: setting system clock to 2014-10-11 12:49:47 UTC (1413031787)
[    7.643081] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    7.749509] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    7.755309] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.793579] Switched to clocksource tsc
[   10.656396] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   10.665875] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.676838] Sending DHCP requests .., OK
[   13.476176] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.151
[   13.485037] IP-Config: Complete:
[   13.488702]      device=eth0, hwaddr=00:13:20:fc:e4:31, ipaddr=192.168.1.151, mask=255.255.255.0, gw=192.168.1.1
[   13.500244]      host=lkp-bdw01, domain=lkp.intel.com, nis-domain=(none)
[   13.507847]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   13.515441]      nameserver0=192.168.1.1
[   13.520117] PM: Hibernation image not present or could not be loaded.
[   13.528606] Freeing unused kernel memory: 1804K (ffffffff81dd1000 - ffffffff81f94000)
[   13.699783] [drm] Initialized drm 1.1.0 20060810
[   13.722934] IOAPIC[0]: Set routing entry (2-18 -> 0xe1 -> IRQ 18 Mode:1 Active:1 Dest:15)
[   13.740318] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E1 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[   13.760311] libata version 3.00 loaded.
[   13.767934] ACPI Warning: SystemIO range 0x000000000000efa0-0x000000000000efbf conflicts with OpRegion 0x000000000000efa0-0x000000000000efaf (\_SB_.PCI0.SBUS.SMBI) (20140724/utaddress-258)
[   13.787061] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.809869] sdhci: Secure Digital Host Controller Interface driver
[   13.816906] sdhci: Copyright(c) Pierre Ossman
[   13.821873] [drm] Memory usable by graphics device = 4096M
[   13.828114] [drm] Replacing VGA console driver
[   13.839481] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[   13.845023] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   13.852528] [drm] Driver supports precise vblank timestamp query.
[   13.859526] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   14.008225] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   14.018536] Error: Driver 'pcspkr' is already registered, aborting...
[   14.912258] [drm:stop_ring] *ERROR* render ring : timed out trying to stop ring
[   14.922806] fbcon: inteldrmfb (fb0) is primary device
[   14.926358] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   14.926464] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
[   14.926614] [drm] Initialized i915 1.6.0 20141003 for 0000:00:02.0 on minor 0
[   14.926859] snd_hda_intel 0000:00:03.0: irq 47 for MSI/MSI-X
[   14.927005] ahci 0000:00:1f.2: version 3.0
[   14.927147] IOAPIC[0]: Set routing entry (2-19 -> 0x52 -> IRQ 19 Mode:1 Active:1 Dest:15)
[   14.927155] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:52 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
[   14.927202] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[   14.934320] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input7
[   14.934452] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input8
[   14.935855] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
[   14.938268] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 2 ports 6 Gbps 0x2 impl SATA mode
[   14.938273] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo only pio slum part deso sadm sds apst 
[   14.938742] scsi host0: ahci
[   14.938931] scsi host1: ahci
[   14.939015] ata1: DUMMY
[   14.939018] ata2: SATA max UDMA/133 abar m2048@0xc1137000 port 0xc1137180 irq 48
[   15.243493] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   15.254520] ata2.00: ATA-9: INTEL SSDSC2CW120A3, 400i, max UDMA/133
[   15.254523] ata2.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   15.264482] ata2.00: configured for UDMA/133
[   16.032170] Console: switching to colour frame buffer device 240x67
[   16.221149] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   16.228217] i915 0000:00:02.0: registered panic notifier
[   16.237548] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW12 400i PQ: 0 ANSI: 5
[   16.259443] sd 1:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[   16.268041] sd 1:0:0:0: [sda] Write Protect is off
[   16.273501] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   16.279267] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.290456]  sda: sda1 sda2
[   16.293929] sd 1:0:0:0: [sda] Attached SCSI disk
[   16.302749] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   16.743472] random: dd urandom read with 62 bits of entropy available
[   18.813477] [drm] stuck on render ring
[   18.825825] [drm] GPU HANG: ecode 0:0xdfe58c9a, reason: Ring hung, action: reset
[   18.840268] [drm] GPU hangs can indicate a bug anywhere in the entire gfx stack, including userspace.
[   18.856821] [drm] Please file a _new_ bug report on bugs.freedesktop.org against DRI -> DRM/Intel
[   18.872980] [drm] drm/i915 developers can then reassign to the right component if it's not a kernel issue.
[   18.888828] [drm] The gpu crash dump is required to analyze gpu hangs, so please always attach it.
[   18.903594] [drm] GPU crash dump saved to /sys/class/drm/card0/error
[   18.917481] drm/i915: Resetting chip after gpu hang
[   20.815201] ------------[ cut here ]------------
[   20.825077] WARNING: CPU: 0 PID: 4 at drivers/gpu/drm/i915/intel_pm.c:3683 gen8_enable_rps_interrupts+0xd1/0x100 [i915]()
[   20.843726] Modules linked in: sg sd_mod crc_t10dif crct10dif_generic crct10dif_pclmul crct10dif_common snd_hda_codec_hdmi winbond_cir rc_core pcspkr parport_pc parport i2c_hid sdhci_acpi ahci snd_hda_intel sdhci dw_dmac dw_dmac_core mmc_core libahci snd_hda_controller i915 snd_hda_codec libata snd_hwdep i2c_i801 snd_pcm video snd_timer drm_kms_helper snd drm soundcore acpi_pad
[   20.892012] CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 3.17.0-rc7-g5ba60fc #1
[   20.905126] Hardware name: Intel Corporation Broadwell Client platform/WhiteTip Mountain 1, BIOS BDW-E1R1.86C.0079.R00.1406020127 06/02/2014
[   20.924567] Workqueue: events intel_gen6_powersave_work [i915]
[   20.936261]  0000000000000009 ffff8801407ffd68 ffffffff818570a6 0000000000000000
[   20.949809]  ffff8801407ffda0 ffffffff8106ef1d ffff88014d840000 ffff88014d847290
[   20.963332]  ffff88014d848728 0000000000040000 ffff88014d847240 ffff8801407ffdb0
[   20.976890] Call Trace:
[   20.984753]  [<ffffffff818570a6>] dump_stack+0x4d/0x66
[   20.995688]  [<ffffffff8106ef1d>] warn_slowpath_common+0x7d/0xa0
[   21.007598]  [<ffffffff8106effa>] warn_slowpath_null+0x1a/0x20
[   21.019304]  [<ffffffffa01890c1>] gen8_enable_rps_interrupts+0xd1/0x100 [i915]
[   21.032610]  [<ffffffffa0190743>] intel_gen6_powersave_work+0x973/0x1070 [i915]
[   21.045986]  [<ffffffff8108814a>] process_one_work+0x15a/0x4b0
[   21.057663]  [<ffffffff8108850b>] worker_thread+0x6b/0x5e0
[   21.068915]  [<ffffffff810884a0>] ? process_one_work+0x4b0/0x4b0
[   21.080762]  [<ffffffff8108e1ab>] kthread+0xdb/0x100
[   21.091377]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
[   21.103757]  [<ffffffff8185fcbc>] ret_from_fork+0x7c/0xb0
[   21.114836]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
[   21.127222] ---[ end trace 8b3e479c87d3f9f5 ]---
<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.17.0-rc7-g5ba60fc (kbuild@cairo) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Sat Oct 11 12:38:06 CST 2014
<6>[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-bdw01/validate_boot-1-x86_64-rhel-5ba60fc3d719988a404d35a3e46f109bea643fef-2.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/vmlinuz-3.17.0-rc7-g5ba60fc kconfig=x86_64-rhel commit=5ba60fc3d719988a404d35a3e46f109bea643fef branch=linux-devel/devel-hourly-2014100721 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-bdw01/boot/1/debian-x86_64.cgz/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/2 ip=::::lkp-bdw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] e820: BIOS-provided physical RAM map:
<6>[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009a3ff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000000009a400-0x000000000009ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009df19fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000009df1a000-0x000000009df38fff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000009df39000-0x00000000ab262fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000ab263000-0x00000000ab762fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000ab763000-0x00000000ab7b5fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000ab7b6000-0x00000000ab7e1fff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x00000000ab7e2000-0x00000000ab7fefff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000ab7ff000-0x00000000af7fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed84000-0x00000000fed84fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed90000-0x00000000fed91fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000ffa00000-0x00000000ffffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000014f7fffff] usable
<6>[    0.000000] bootconsole [earlyser0] enabled
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] SMBIOS 2.7 present.
<7>[    0.000000] DMI: Intel Corporation Broadwell Client platform/WhiteTip Mountain 1, BIOS BDW-E1R1.86C.0079.R00.1406020127 06/02/2014
<7>[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
<7>[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
<6>[    0.000000] AGP: No AGP bridge found
<6>[    0.000000] e820: last_pfn = 0x14f800 max_arch_pfn = 0x400000000
<7>[    0.000000] MTRR default type: write-back
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-BFFFF uncachable
<7>[    0.000000]   C0000-FFFFF write-protect
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 00C0000000 mask 7FC0000000 uncachable
<7>[    0.000000]   1 base 00B0000000 mask 7FF0000000 uncachable
<7>[    0.000000]   2 base 00AE000000 mask 7FFE000000 uncachable
<7>[    0.000000]   3 base 00AD000000 mask 7FFF000000 uncachable
<7>[    0.000000]   4 disabled
<7>[    0.000000]   5 disabled
<7>[    0.000000]   6 disabled
<7>[    0.000000]   7 disabled
<7>[    0.000000]   8 disabled
<7>[    0.000000]   9 disabled
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
<6>[    0.000000] e820: last_pfn = 0xab7ff max_arch_pfn = 0x400000000
<4>[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
<4>[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
<4>[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
<4>[    0.000000] Scan for SMP in [mem 0x0009a400-0x0009a7ff]
<7>[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 24576
<6>[    0.000000] Using GB pages for direct mapping
<6>[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
<7>[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
<7>[    0.000000] BRK [0x14f177000, 0x14f177fff] PGTABLE
<7>[    0.000000] BRK [0x14f178000, 0x14f178fff] PGTABLE
<7>[    0.000000] BRK [0x14f179000, 0x14f179fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x14f600000-0x14f7fffff]
<7>[    0.000000]  [mem 0x14f600000-0x14f7fffff] page 2M
<7>[    0.000000] BRK [0x14f17a000, 0x14f17afff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x14c000000-0x14f5fffff]
<7>[    0.000000]  [mem 0x14c000000-0x14f5fffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x100000000-0x14bffffff]
<7>[    0.000000]  [mem 0x100000000-0x13fffffff] page 1G
<7>[    0.000000]  [mem 0x140000000-0x14bffffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x00100000-0x9df19fff]
<7>[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
<7>[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
<7>[    0.000000]  [mem 0x80000000-0x9ddfffff] page 2M
<7>[    0.000000]  [mem 0x9de00000-0x9df19fff] page 4k
<7>[    0.000000] BRK [0x14f17b000, 0x14f17bfff] PGTABLE
<7>[    0.000000] BRK [0x14f17c000, 0x14f17cfff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x9df39000-0xab262fff]
<7>[    0.000000]  [mem 0x9df39000-0x9dffffff] page 4k
<7>[    0.000000]  [mem 0x9e000000-0xab1fffff] page 2M
<7>[    0.000000]  [mem 0xab200000-0xab262fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0xab7e2000-0xab7fefff]
<7>[    0.000000]  [mem 0xab7e2000-0xab7fefff] page 4k
<6>[    0.000000] RAMDISK: [mem 0x1466d3000-0x14dffffff]
<6>[    0.000000] ACPI: Early table checksum verification disabled
<4>[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
<4>[    0.000000] ACPI: XSDT 0x00000000AB7C8188 000114 (v01 INTEL  BDW-ULT  00000000      01000013)
<4>[    0.000000] ACPI: FACP 0x00000000AB7D7000 0000F4 (v05 INTEL  BDW-ULT  00000000 MSFT 0000005F)
<4>[    0.000000] ACPI: DSDT 0x000000009DF1A000 01E50D (v02 INTEL  BDW      00000000 INTL 20130927)
<4>[    0.000000] ACPI: FACS 0x00000000AB79D000 000040
<4>[    0.000000] ACPI: TCPA 0x00000000AB7DF000 000032 (v02 INTEL  EDK2     00000002      01000013)
<4>[    0.000000] ACPI: UEFI 0x00000000AB7A0000 000042 (v01 INTEL  EDK2     00000002      01000013)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7DE000 0004B5 (v01 Intel_ Tpm2Tabl 00001000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7DD000 00004E (v01 MeSsdt MeSsdt   00003000 INTL 20130927)
<4>[    0.000000] ACPI: TPM2 0x00000000AB7DC000 000034 (v03                 00000000      00000000)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7DB000 0005B1 (v01 Intel  PerfTune 00001000 INTL 20130927)
<4>[    0.000000] ACPI: DBGP 0x00000000AB7DA000 000034 (v01 INTEL           00000000 MSFT 0000005F)
<4>[    0.000000] ACPI: DBG2 0x00000000AB7D9000 000054 (v00 INTEL           00000000 MSFT 0000005F)
<4>[    0.000000] ACPI: LPIT 0x00000000AB7D8000 000094 (v01 INTEL  BDW-ULT  00000000 MSFT 0000005F)
<4>[    0.000000] ACPI: HPET 0x00000000AB7D6000 000038 (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
<4>[    0.000000] ACPI: APIC 0x00000000AB7D5000 0000BC (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
<4>[    0.000000] ACPI: MCFG 0x00000000AB7D4000 00003C (v01 INTEL  BDW-ULT  00000001 MSFT 0000005F)
<4>[    0.000000] ACPI: WDAT 0x00000000AB7D3000 000104 (v01 INTEL  BDW-ULT  00000000 MSFT 0000005F)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7D2000 000250 (v01 INTEL  sensrhub 00000000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7CE000 00340B (v01 INTEL  PtidDevc 00001000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7CD000 000C7D (v01 INTEL  Ther_Rvp 00001000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7CC000 00017F (v01 INTEL  zpodd    00001000 INTL 20130927)
<4>[    0.000000] ACPI: BOOT 0x00000000AB7CB000 000028 (v01 INTEL  TIANO    00000002 MSFT 01000013)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7CA000 0004D8 (v01 PmRef  Cpu0Ist  00003000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7C9000 000B74 (v01 CpuRef CpuSsdt  00003000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7C1000 006F06 (v01 SaSsdt SaSsdt   00003000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7E0000 0006A7 (v01 CppcTa CppcTabl 00001000 INTL 20130927)
<4>[    0.000000] ACPI: PCCT 0x00000000AB7C0000 00006E (v05 PcctTa PcctTabl 00001000 INTL 20130927)
<4>[    0.000000] ACPI: SSDT 0x00000000AB7BF000 000AC4 (v01 Cpc_Ta Cpc_Tabl 00001000 INTL 20130927)
<4>[    0.000000] ACPI: CSRT 0x00000000AB7BE000 0000C4 (v01 INTL   BDW-ULT  00000001 INTL 20100528)
<4>[    0.000000] ACPI: DMAR 0x00000000AB7BD000 0000F0 (v01 INTEL  BDW      00000001 INTL 00000001)
<4>[    0.000000] ACPI: FPDT 0x00000000AB7BC000 000044 (v01 INTEL  EDK2     00000002      01000013)
<4>[    0.000000] ACPI: ASF! 0x00000000AB7BB000 0000A0 (v32 INTEL   HCG     00000001 TFSM 000F4240)
<4>[    0.000000] ACPI: BGRT 0x00000000AB7BA000 000038 (v01 INTEL  EDK2     00000002      01000013)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>[    0.000000] No NUMA configuration found
<6>[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000014f7fffff]
<6>[    0.000000] Initmem setup node 0 [mem 0x00000000-0x14f7fffff]
<6>[    0.000000]   NODE_DATA [mem 0x14f7d8000-0x14f7fdfff]
<7>[    0.000000]  [ffffea0000000000-ffffea00053fffff] PMD -> [ffff880142200000-ffff8801461fffff] on node 0
<4>[    0.000000] Zone ranges:
<4>[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
<4>[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
<4>[    0.000000]   Normal   [mem 0x100000000-0x14f7fffff]
<4>[    0.000000] Movable zone start for each node
<4>[    0.000000] Early memory node ranges
<4>[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
<4>[    0.000000]   node   0: [mem 0x00100000-0x9df19fff]
<4>[    0.000000]   node   0: [mem 0x9df39000-0xab262fff]
<4>[    0.000000]   node   0: [mem 0xab7e2000-0xab7fefff]
<4>[    0.000000]   node   0: [mem 0x100000000-0x14f7fffff]
<7>[    0.000000] On node 0 totalpages: 1026554
<7>[    0.000000]   DMA zone: 64 pages used for memmap
<7>[    0.000000]   DMA zone: 21 pages reserved
<7>[    0.000000]   DMA zone: 3993 pages, LIFO batch:0
<7>[    0.000000]   DMA32 zone: 10890 pages used for memmap
<7>[    0.000000]   DMA32 zone: 696929 pages, LIFO batch:31
<7>[    0.000000]   Normal zone: 5088 pages used for memmap
<7>[    0.000000]   Normal zone: 325632 pages, LIFO batch:31
<6>[    0.000000] Reserving Intel graphics stolen memory at 0xad800000-0xaf7fffff
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x1808
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-39
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<4>[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
<7>[    0.000000] ACPI: IRQ0 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
<7>[    0.000000] ACPI: IRQ9 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
<6>[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
<4>[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009afff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x9df1a000-0x9df38fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xab263000-0xab762fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xab763000-0xab7b5fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xab7b6000-0xab7e1fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xab7ff000-0xaf7fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xaf800000-0xdfffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed0ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfed83fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed84000-0xfed84fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed85000-0xfed8ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed90000-0xfed91fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed92000-0xfedfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xff9fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xffa00000-0xffffffff]
<6>[    0.000000] e820: [mem 0xaf800000-0xdfffffff] available for PCI devices
<6>[    0.000000] Booting paravirtualized kernel on bare hardware
<6>[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
<6>[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88014f400000 s88960 r8192 d21632 u262144
<7>[    0.000000] pcpu-alloc: s88960 r8192 d21632 u262144 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
<4>[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1010491
<4>[    0.000000] Policy zone: Normal
<5>[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-bdw01/validate_boot-1-x86_64-rhel-5ba60fc3d719988a404d35a3e46f109bea643fef-2.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/vmlinuz-3.17.0-rc7-g5ba60fc kconfig=x86_64-rhel commit=5ba60fc3d719988a404d35a3e46f109bea643fef branch=linux-devel/devel-hourly-2014100721 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-bdw01/boot/1/debian-x86_64.cgz/x86_64-rhel/5ba60fc3d719988a404d35a3e46f109bea643fef/2 ip=::::lkp-bdw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] sysrq: sysrq always enabled.
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
<6>[    0.000000] AGP: Checking aperture...
<6>[    0.000000] AGP: No AGP bridge found
<4>[    0.000000] Memory: 3831208K/4106216K available (8595K kernel code, 1702K rwdata, 3832K rodata, 1804K init, 1888K bss, 275008K reserved)
<6>[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
<6>[    0.000000] 	Offload RCU callbacks from all CPUs
<6>[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
<6>[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
<6>[    0.000000] NR_IRQS:524544 nr_irqs:760 0
<6>[    0.000000] Console: colour dummy device 80x25
<6>[    0.000000] console [tty0] enabled
<6>[    0.000000] bootconsole [earlyser0] disabled
<6>[    0.000000] console [ttyS0] enabled
<6>[    0.000000] allocated 16777216 bytes of page_cgroup
<6>[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
<7>[    0.000000] hpet clockevent registered
<6>[    0.000000] tsc: Fast TSC calibration using PIT
<6>[    0.000000] tsc: Detected 1596.191 MHz processor
<6>[    0.000042] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.38 BogoMIPS (lpj=1596191)
<6>[    0.012085] pid_max: default: 32768 minimum: 301
<6>[    0.017326] ACPI: Core revision 20140724
<4>[    0.061442] ACPI: All ACPI Tables successfully acquired
<6>[    0.067425] Security Framework initialized
<6>[    0.072073] SELinux:  Initializing.
<7>[    0.076022] SELinux:  Starting in permissive mode
<6>[    0.081739] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
<6>[    0.091028] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
<6>[    0.099493] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
<6>[    0.107098] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
<6>[    0.115430] Initializing cgroup subsys memory
<6>[    0.120374] Initializing cgroup subsys devices
<6>[    0.125411] Initializing cgroup subsys freezer
<6>[    0.130449] Initializing cgroup subsys net_cls
<6>[    0.135488] Initializing cgroup subsys blkio
<6>[    0.140328] Initializing cgroup subsys perf_event
<6>[    0.145662] Initializing cgroup subsys hugetlb
<6>[    0.150727] CPU: Physical Processor ID: 0
<6>[    0.155272] CPU: Processor Core ID: 1
<6>[    0.160714] mce: CPU supports 7 MCE banks
<7>[    0.165270] CPU0: Thermal LVT vector (0xfa) already installed
<6>[    0.171793] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
<6>[    0.171793] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
<6>[    0.185184] Freeing SMP alternatives memory: 36K (ffffffff81f94000 - ffffffff81f9d000)
<6>[    0.195466] ftrace: allocating 31083 entries in 122 pages
<4>[    0.220145] Getting VERSION: 1060015
<4>[    0.224201] Getting VERSION: 1060015
<4>[    0.228253] Getting ID: 2000000
<4>[    0.231814] Getting ID: 2000000
<6>[    0.235383] dmar: Host address width 39
<6>[    0.239732] dmar: DRHD base: 0x000000fed90000 flags: 0x0
<6>[    0.245760] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 7e1ff0505e
<6>[    0.255432] dmar: DRHD base: 0x000000fed91000 flags: 0x1
<6>[    0.261458] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap d2008c20660462 ecap f010da
<6>[    0.270634] dmar: RMRR base: 0x000000ab6f2000 end: 0x000000ab705fff
<6>[    0.277741] dmar: RMRR base: 0x000000ad000000 end: 0x000000af7fffff
<6>[    0.284848] dmar: ANDD device: 1 name: \_SB.PCI0.SDMA
<6>[    0.290575] dmar: ANDD device: 2 name: \_SB.PCI0.SDHC
<6>[    0.296428] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
<6>[    0.302738] HPET id 0 under DRHD base 0xfed91000
<6>[    0.307972] Queued invalidation will be enabled to support x2apic and Intr-remapping.
<4>[    0.316852] Your BIOS is broken and requested that x2apic be disabled.
<4>[    0.316852] This will slightly decrease performance.
<4>[    0.316852] Use 'intremap=no_x2apic_optout' to override BIOS request.
<6>[    0.337454] Enabled IRQ remapping in xapic mode
<6>[    0.342588] x2apic not enabled, IRQ remapping is in xapic mode
<4>[    0.349210] masked ExtINT on CPU#0
<4>[    0.353511] ENABLING IO-APIC IRQs
<7>[    0.357269] init IO_APIC IRQs
<7>[    0.360633]  apic 2 pin 0 not connected
<7>[    0.364984] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>[    0.373968] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.389257] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.398238] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.413525] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.422518] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.437809] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>[    0.446791] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.462082] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>[    0.471068] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.486358] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>[    0.495343] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:35 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.510634] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>[    0.519618] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:36 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.534909] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>[    0.543891] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:37 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.559182] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>[    0.568165] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.583456] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>[    0.592438] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.607728] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>[    0.616908] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3A Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.632197] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>[    0.641379] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3B Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.656668] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>[    0.665851] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3C Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.681140] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>[    0.690323] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.705613] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>[    0.714795] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3E Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.730084] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>[    0.739264] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3F Dest:00000100 SID:F0F8 SQ:0 SVT:1)
<7>[    0.754551]  apic 2 pin 16 not connected
<7>[    0.758991]  apic 2 pin 17 not connected
<7>[    0.763439]  apic 2 pin 18 not connected
<7>[    0.767887]  apic 2 pin 19 not connected
<7>[    0.772335]  apic 2 pin 20 not connected
<7>[    0.776783]  apic 2 pin 21 not connected
<7>[    0.781231]  apic 2 pin 22 not connected
<7>[    0.785679]  apic 2 pin 23 not connected
<7>[    0.790126]  apic 2 pin 24 not connected
<7>[    0.794574]  apic 2 pin 25 not connected
<7>[    0.799022]  apic 2 pin 26 not connected
<7>[    0.803471]  apic 2 pin 27 not connected
<7>[    0.807920]  apic 2 pin 28 not connected
<7>[    0.812368]  apic 2 pin 29 not connected
<7>[    0.816818]  apic 2 pin 30 not connected
<7>[    0.821265]  apic 2 pin 31 not connected
<7>[    0.825714]  apic 2 pin 32 not connected
<7>[    0.830162]  apic 2 pin 33 not connected
<7>[    0.834610]  apic 2 pin 34 not connected
<7>[    0.839058]  apic 2 pin 35 not connected
<7>[    0.843506]  apic 2 pin 36 not connected
<7>[    0.847954]  apic 2 pin 37 not connected
<7>[    0.852403]  apic 2 pin 38 not connected
<7>[    0.856851]  apic 2 pin 39 not connected
<6>[    0.861444] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.878266] smpboot: CPU0: Genuine Intel(R) CPU 0000 @ 1.60GHz (fam: 06, model: 3d, stepping: 03)
<7>[    0.888379] TSC deadline timer enabled
<6>[    0.892660] Performance Events: PEBS fmt2+, generic architected perfmon, full-width counters, Intel PMU driver.
<6>[    0.904158] ... version:                3
<6>[    0.908705] ... bit width:              48
<6>[    0.913351] ... generic registers:      4
<6>[    0.917899] ... value mask:             0000ffffffffffff
<6>[    0.923923] ... max period:             0000ffffffffffff
<6>[    0.929948] ... fixed-purpose events:   3
<6>[    0.934494] ... event mask:             000000070000000f
<6>[    0.942868] x86: Booting SMP configuration:
<6>[    0.947616] .... node  #0, CPUs:      #1
<4>[    0.963005] masked ExtINT on CPU#1
<7>[    0.968371] CPU1: Thermal LVT vector (0xfa) already installed
<6>[    0.977051] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>[    0.986228]  #2
<4>[    0.999137] masked ExtINT on CPU#2
<7>[    1.004500] CPU2: Thermal LVT vector (0xfa) already installed
<4>[    1.013193]  #3
<4>[    1.026172] masked ExtINT on CPU#3
<7>[    1.031575] CPU3: Thermal LVT vector (0xfa) already installed
<6>[    1.040160] x86: Booted up 1 node, 4 CPUs
<6>[    1.044711] smpboot: Total of 4 processors activated (12769.52 BogoMIPS)
<6>[    1.058540] devtmpfs: initialized
<6>[    1.064940] evm: security.selinux
<6>[    1.068699] evm: security.ima
<6>[    1.072064] evm: security.capability
<6>[    1.076269] PM: Registering ACPI NVS region [mem 0xab763000-0xab7b5fff] (339968 bytes)
<6>[    1.086427] atomic64_test: passed for x86-64 platform with CX8 and with SSE
<6>[    1.094452] NET: Registered protocol family 16
<6>[    1.099741] cpuidle: using governor menu
<6>[    1.104335] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
<6>[    1.112922] ACPI: bus type PCI registered
<6>[    1.117470] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>[    1.124861] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
<6>[    1.135422] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
<6>[    1.143557] PCI: Using configuration type 1 for base access
<6>[    1.154300] ACPI: Added _OSI(Module Device)
<6>[    1.159049] ACPI: Added _OSI(Processor Device)
<6>[    1.164090] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>[    1.169417] ACPI: Added _OSI(Processor Aggregator Device)
<7>[    1.179948] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:15)
<7>[    1.189034] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<4>[    1.212319] ACPI: Executed 18 blocks of module-level executable AML code
<4>[    1.239600] ACPI: Dynamic OEM Table Load:
<4>[    1.244191] ACPI: SSDT 0xFFFF88013FCB1800 0004AE (v01 PmRef  Cpu0Cst  00003001 INTL 20130927)
<4>[    1.258743] ACPI: Dynamic OEM Table Load:
<4>[    1.263336] ACPI: SSDT 0xFFFF88013FED8000 000792 (v01 PmRef  ApIst    00003000 INTL 20130927)
<4>[    1.276639] ACPI: Dynamic OEM Table Load:
<4>[    1.281216] ACPI: SSDT 0xFFFF88013FED4E00 000119 (v01 PmRef  ApCst    00003000 INTL 20130927)
<6>[    1.299421] ACPI: Interpreter enabled
<4>[    1.303587] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
<4>[    1.314112] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
<6>[    1.324653] ACPI: (supports S0 S3 S4 S5)
<6>[    1.329117] ACPI: Using IOAPIC for interrupt routing
<6>[    1.334803] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>[    1.345759] ACPI: Power Resource [PG00] (on)
<6>[    1.356910] ACPI: Power Resource [PG01] (on)
<6>[    1.365916] ACPI: Power Resource [PG02] (on)
<6>[    1.397614] acpi ABCD0000:00: ACPI dock station (docks/bays count: 1)
<6>[    1.406430] ACPI: Power Resource [FN00] (off)
<6>[    1.411464] ACPI: Power Resource [FN01] (off)
<6>[    1.416495] ACPI: Power Resource [FN02] (off)
<6>[    1.421521] ACPI: Power Resource [FN03] (off)
<6>[    1.426549] ACPI: Power Resource [FN04] (off)
<6>[    1.432803] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
<6>[    1.439822] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    1.450184] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
<6>[    1.460564] PCI host bridge to bus 0000:00
<6>[    1.465213] pci_bus 0000:00: root bus resource [bus 00-fe]
<6>[    1.471453] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
<6>[    1.478478] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>[    1.485499] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>[    1.493322] pci_bus 0000:00: root bus resource [mem 0xaf800000-0xfeafffff]
<7>[    1.501146] pci 0000:00:00.0: [8086:1604] type 00 class 0x060000
<7>[    1.508261] pci 0000:00:02.0: [8086:1616] type 00 class 0x030000
<7>[    1.515088] pci 0000:00:02.0: reg 0x10: [mem 0xc0000000-0xc0ffffff 64bit]
<7>[    1.522797] pci 0000:00:02.0: reg 0x18: [mem 0xb0000000-0xbfffffff 64bit pref]
<7>[    1.530994] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
<7>[    1.537611] pci 0000:00:03.0: [8086:160c] type 00 class 0x040300
<7>[    1.544434] pci 0000:00:03.0: reg 0x10: [mem 0xc1130000-0xc1133fff 64bit]
<7>[    1.552446] pci 0000:00:14.0: [8086:9cb1] type 00 class 0x0c0330
<7>[    1.559281] pci 0000:00:14.0: reg 0x10: [mem 0xc1120000-0xc112ffff 64bit]
<7>[    1.567048] pci 0000:00:14.0: PME# supported from D3hot D3cold
<6>[    1.573912] pci 0000:00:14.0: System wakeup disabled by ACPI
<7>[    1.580377] pci 0000:00:16.0: [8086:9cba] type 00 class 0x078000
<7>[    1.587212] pci 0000:00:16.0: reg 0x10: [mem 0xc1135000-0xc113501f 64bit]
<7>[    1.594988] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
<7>[    1.602187] pci 0000:00:19.0: [8086:15a2] type 00 class 0x020000
<7>[    1.609017] pci 0000:00:19.0: reg 0x10: [mem 0xc1100000-0xc111ffff]
<7>[    1.616133] pci 0000:00:19.0: reg 0x14: [mem 0xc1138000-0xc1138fff]
<7>[    1.623251] pci 0000:00:19.0: reg 0x18: [io  0x3080-0x309f]
<7>[    1.629634] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
<6>[    1.636794] pci 0000:00:19.0: System wakeup disabled by ACPI
<7>[    1.643249] pci 0000:00:1c.0: [8086:9c90] type 01 class 0x060400
<7>[    1.650127] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<6>[    1.657281] pci 0000:00:1c.0: System wakeup disabled by ACPI
<7>[    1.663754] pci 0000:00:1f.0: [8086:9cc3] type 00 class 0x060100
<7>[    1.670955] pci 0000:00:1f.2: [8086:9c83] type 00 class 0x010601
<7>[    1.677784] pci 0000:00:1f.2: reg 0x10: [io  0x30a8-0x30af]
<7>[    1.684110] pci 0000:00:1f.2: reg 0x14: [io  0x30b4-0x30b7]
<7>[    1.690435] pci 0000:00:1f.2: reg 0x18: [io  0x30a0-0x30a7]
<7>[    1.696760] pci 0000:00:1f.2: reg 0x1c: [io  0x30b0-0x30b3]
<7>[    1.703086] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
<7>[    1.709413] pci 0000:00:1f.2: reg 0x24: [mem 0xc1137000-0xc11377ff]
<7>[    1.716560] pci 0000:00:1f.2: PME# supported from D3hot
<7>[    1.722760] pci 0000:00:1f.3: [8086:9ca2] type 00 class 0x0c0500
<7>[    1.729588] pci 0000:00:1f.3: reg 0x10: [mem 0xc1134000-0xc11340ff 64bit]
<7>[    1.737311] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
<7>[    1.743920] pci 0000:00:1f.6: [8086:9ca4] type 00 class 0x118000
<7>[    1.750765] pci 0000:00:1f.6: reg 0x10: [mem 0xc1136000-0xc1136fff 64bit]
<7>[    1.758926] pci 0000:01:00.0: [8086:08b1] type 00 class 0x028000
<7>[    1.765783] pci 0000:01:00.0: reg 0x10: [mem 0xc1000000-0xc1001fff 64bit]
<7>[    1.773677] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
<6>[    1.780632] pci 0000:01:00.0: System wakeup disabled by ACPI
<6>[    1.789075] pci 0000:00:1c.0: PCI bridge to [bus 01]
<7>[    1.794710] pci 0000:00:1c.0:   bridge window [mem 0xc1000000-0xc10fffff]
<6>[    1.802425] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
<6>[    1.813432] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
<6>[    1.822510] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.831784] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
<6>[    1.840849] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
<6>[    1.849913] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
<6>[    1.858977] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.868250] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.877519] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<4>[    1.887343] ACPI: Enabled 4 GPEs in block 00 to 7F
<6>[    1.893077] ACPI : EC: GPE = 0xa, I/O: command/status = 0x66, data = 0x62
<6>[    1.900935] vgaarb: setting as boot device: PCI:0000:00:02.0
<6>[    1.907354] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    1.916534] vgaarb: loaded
<6>[    1.919604] vgaarb: bridge control possible 0000:00:02.0
<5>[    1.925719] SCSI subsystem initialized
<6>[    1.930008] ACPI: bus type USB registered
<6>[    1.934578] usbcore: registered new interface driver usbfs
<6>[    1.940811] usbcore: registered new interface driver hub
<6>[    1.946865] usbcore: registered new device driver usb
<6>[    1.952624] pps_core: LinuxPPS API ver. 1 registered
<6>[    1.958254] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>[    1.968621] PTP clock support registered
<6>[    1.973154] PCI: Using ACPI for IRQ routing
<7>[    1.984146] PCI: pci_cache_line_size set to 64 bytes
<7>[    1.989812] e820: reserve RAM buffer [mem 0x0009a400-0x0009ffff]
<7>[    1.996618] e820: reserve RAM buffer [mem 0x9df1a000-0x9fffffff]
<7>[    2.003433] e820: reserve RAM buffer [mem 0xab263000-0xabffffff]
<7>[    2.010238] e820: reserve RAM buffer [mem 0xab7ff000-0xabffffff]
<7>[    2.017052] e820: reserve RAM buffer [mem 0x14f800000-0x14fffffff]
<6>[    2.024183] NetLabel: Initializing
<6>[    2.028041] NetLabel:  domain hash size = 128
<6>[    2.032981] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    2.038627] NetLabel:  unlabeled traffic allowed by default
<6>[    2.045081] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
<6>[    2.052185] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
<6>[    2.060837] Switched to clocksource hpet
<6>[    2.076562] pnp: PnP ACPI init
<6>[    2.080435] system 00:00: [io  0x06a4] has been reserved
<6>[    2.086467] system 00:00: [io  0x06a0] has been reserved
<7>[    2.092496] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
<6>[    2.100442] system 00:01: [io  0x0680-0x069f] has been reserved
<6>[    2.107160] system 00:01: [io  0xffff] has been reserved
<6>[    2.113190] system 00:01: [io  0xffff] has been reserved
<6>[    2.119217] system 00:01: [io  0xffff] has been reserved
<6>[    2.125245] system 00:01: [io  0x1800-0x18fe] could not be reserved
<6>[    2.132356] system 00:01: [io  0x164e-0x164f] has been reserved
<7>[    2.139073] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    2.146812] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
<7>[    2.155902] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<7>[    2.171212] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
<6>[    2.178663] system 00:03: [io  0x1854-0x1857] has been reserved
<7>[    2.185382] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
<7>[    2.194002] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
<7>[    2.203088] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<7>[    2.218398] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
<7>[    2.225884] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:15)
<7>[    2.234970] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<7>[    2.250275] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
<6>[    2.258434] system 00:06: [mem 0xfe102000-0xfe102fff] has been reserved
<6>[    2.265943] system 00:06: [mem 0xfe104000-0xfe104fff] has been reserved
<6>[    2.273448] system 00:06: [mem 0xfe106000-0xfe106fff] has been reserved
<6>[    2.280954] system 00:06: [mem 0xfe10e000-0xfe10efff] has been reserved
<6>[    2.288459] system 00:06: [mem 0xfe112000-0xfe112fff] has been reserved
<6>[    2.295965] system 00:06: [mem 0xfe111000-0xfe111007] has been reserved
<6>[    2.303470] system 00:06: [mem 0xfe111014-0xfe111fff] has been reserved
<7>[    2.310978] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
<6>[    2.320203] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>[    2.327711] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
<6>[    2.335216] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
<6>[    2.342722] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
<6>[    2.350230] system 00:07: [mem 0xe0000000-0xefffffff] has been reserved
<6>[    2.357736] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
<6>[    2.365243] system 00:07: [mem 0xfed90000-0xfed93fff] could not be reserved
<6>[    2.373142] system 00:07: [mem 0xfed45000-0xfed8ffff] could not be reserved
<6>[    2.381041] system 00:07: [mem 0xff000000-0xffffffff] could not be reserved
<6>[    2.388940] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
<6>[    2.396839] system 00:07: [mem 0xaf810000-0xaf81ffff] has been reserved
<6>[    2.404344] system 00:07: [mem 0xaf800000-0xaf80ffff] has been reserved
<7>[    2.411849] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
<6>[    2.419842] system 00:08: [mem 0x00000000-0x0009cfff] could not be reserved
<7>[    2.427747] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    2.435619] pnp: PnP ACPI: found 9 devices
<6>[    2.446805] pci 0000:00:1c.0: PCI bridge to [bus 01]
<6>[    2.452445] pci 0000:00:1c.0:   bridge window [mem 0xc1000000-0xc10fffff]
<7>[    2.460154] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>[    2.466477] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>[    2.472800] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    2.479911] pci_bus 0000:00: resource 7 [mem 0xaf800000-0xfeafffff]
<7>[    2.487022] pci_bus 0000:01: resource 1 [mem 0xc1000000-0xc10fffff]
<6>[    2.494165] NET: Registered protocol family 2
<6>[    2.499350] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
<6>[    2.507645] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
<6>[    2.515228] TCP: Hash tables configured (established 32768 bind 32768)
<6>[    2.522652] TCP: reno registered
<6>[    2.526322] UDP hash table entries: 2048 (order: 4, 65536 bytes)
<6>[    2.533146] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
<6>[    2.540524] NET: Registered protocol family 1
<6>[    2.545545] RPC: Registered named UNIX socket transport module.
<6>[    2.552266] RPC: Registered udp transport module.
<6>[    2.557604] RPC: Registered tcp transport module.
<6>[    2.562942] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    2.570276] pci 0000:00:02.0: Video device with shadowed ROM
<4>[    2.576810] pci 0000:00:14.0: can't derive routing for PCI INT A
<4>[    2.583628] pci 0000:00:14.0: PCI INT A: no GSI
<4>[    2.588870] pci 0000:00:14.0: can't derive routing for PCI INT A
<7>[    2.595706] PCI: CLS 0 bytes, default 64
<6>[    2.600215] Unpacking initramfs...
<6>[    5.727637] Freeing initrd memory: 124084K (ffff8801466d3000 - ffff88014e000000)
<6>[    5.736065] dmar: ACPI device "INTL9C60:00" under DMAR at fed91000 as 00:15.0
<6>[    5.744169] dmar: ACPI device "INT3436:00" under DMAR at fed91000 as 00:17.0
<6>[    5.752176] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
<6>[    5.759489] software IO TLB [mem 0xa7263000-0xab263000] (64MB) mapped at [ffff8800a7263000-ffff8800ab262fff]
<6>[    5.770791] Simple Boot Flag at 0x47 set to 0x80
<6>[    5.776924] futex hash table entries: 2048 (order: 5, 131072 bytes)
<5>[    5.784063] Initialise system trusted keyring
<6>[    5.789031] audit: initializing netlink subsys (disabled)
<5>[    5.795168] audit: type=2000 audit(1413031782.698:1): initialized
<6>[    5.802456] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>[    5.811548] zpool: loaded
<6>[    5.814528] zbud: loaded
<5>[    5.817616] VFS: Disk quotas dquot_6.5.2
<4>[    5.822113] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>[    5.830016] SGI XFS with ACLs, security attributes, no debug enabled
<6>[    5.837656] 9p: Installing v9fs 9p2000 file system support
<6>[    5.843919] msgmni has been set to 7725
<5>[    5.848342] Key type big_key registered
<7>[    5.852698] SELinux:  Registering netfilter hooks
<6>[    5.858662] NET: Registered protocol family 38
<5>[    5.863716] Key type asymmetric registered
<5>[    5.868368] Asymmetric key parser 'x509' registered
<6>[    5.873953] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>[    5.882392] io scheduler noop registered
<6>[    5.886848] io scheduler deadline registered (default)
<6>[    5.892687] io scheduler cfq registered
<7>[    5.897264] IOAPIC[0]: Set routing entry (2-16 -> 0x61 -> IRQ 16 Mode:1 Active:1 Dest:15)
<7>[    5.906553] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:61 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<7>[    5.921876] pcieport 0000:00:1c.0: irq 42 for MSI/MSI-X
<6>[    5.927904] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
<6>[    5.935806] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
<7>[    5.943220] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
<6>[    5.950846] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>[    5.957189] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<7>[    5.964743] intel_idle: MWAIT substates: 0x11142120
<7>[    5.970281] intel_idle: v0.4 model 0x3D
<7>[    5.974633] intel_idle: lapic_timer_reliable_states 0xffffffff
<6>[    5.981615] ACPI: AC Adapter [ADP1] (off-line)
<6>[    5.986782] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
<6>[    5.996201] ACPI: Lid Switch [LID0]
<6>[    6.000221] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
<6>[    6.009701] ACPI: Power Button [PWRB]
<6>[    6.013898] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
<6>[    6.023376] ACPI: Sleep Button [SLPB]
<6>[    6.027574] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
<6>[    6.035968] ACPI: Power Button [PWRF]
<6>[    6.040209] ACPI: Fan [FAN0] (off)
<6>[    6.044100] ACPI: Fan [FAN1] (off)
<6>[    6.047987] ACPI: Fan [FAN2] (off)
<6>[    6.051871] ACPI: Fan [FAN3] (off)
<6>[    6.055749] ACPI: Fan [FAN4] (off)
<6>[    6.061052] thermal LNXTHERM:00: registered as thermal_zone0
<6>[    6.067478] ACPI: Thermal Zone [TZ00] (52 C)
<6>[    6.073121] thermal LNXTHERM:01: registered as thermal_zone1
<6>[    6.079537] ACPI: Thermal Zone [TZ01] (52 C)
<6>[    6.084435] GHES: HEST is not enabled!
<6>[    6.084694] ACPI: Battery Slot [BAT0] (battery present)
<6>[    6.084738] ACPI: Battery Slot [BAT1] (battery absent)
<6>[    6.084834] ACPI: Battery Slot [BAT2] (battery absent)
<6>[    6.106403] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<6>[    6.134156] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
<6>[    6.143254] Non-volatile memory driver v1.3
<6>[    6.148021] Linux agpgart interface v0.103
<7>[    6.152952] mei_me 0000:00:16.0: irq 43 for MSI/MSI-X
<6>[    6.160257] rdac: device handler registered
<6>[    6.165234] hp_sw: device handler registered
<6>[    6.170124] emc: device handler registered
<6>[    6.174817] alua: device handler registered
<6>[    6.179630] libphy: Fixed MDIO Bus: probed
<6>[    6.184324] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>[    6.192321] e1000: Copyright (c) 1999-2006 Intel Corporation.
<6>[    6.198845] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>[    6.205464] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
<7>[    6.212304] IOAPIC[0]: Set routing entry (2-20 -> 0x91 -> IRQ 20 Mode:1 Active:1 Dest:15)
<7>[    6.221592] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:91 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<6>[    6.236938] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
<7>[    6.247518] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
<6>[    6.417772] e1000e 0000:00:19.0 eth0: registered PHC clock
<6>[    6.424005] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:13:20:fc:e4:31
<6>[    6.432987] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
<6>[    6.440813] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
<6>[    6.448629] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.13-k
<6>[    6.456628] igb: Copyright (c) 2007-2014 Intel Corporation.
<6>[    6.462967] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>[    6.471756] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
<6>[    6.478340] usbcore: registered new interface driver catc
<6>[    6.484475] usbcore: registered new interface driver kaweth
<6>[    6.490799] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<6>[    6.499197] usbcore: registered new interface driver pegasus
<6>[    6.505626] usbcore: registered new interface driver rtl8150
<6>[    6.512061] usbcore: registered new interface driver asix
<6>[    6.518195] usbcore: registered new interface driver cdc_ether
<6>[    6.524821] usbcore: registered new interface driver cdc_eem
<6>[    6.531241] usbcore: registered new interface driver dm9601
<6>[    6.537576] usbcore: registered new interface driver smsc75xx
<6>[    6.544108] usbcore: registered new interface driver smsc95xx
<6>[    6.550637] usbcore: registered new interface driver gl620a
<6>[    6.556967] usbcore: registered new interface driver net1080
<6>[    6.563387] usbcore: registered new interface driver plusb
<6>[    6.569619] usbcore: registered new interface driver rndis_host
<6>[    6.576336] usbcore: registered new interface driver cdc_subset
<6>[    6.583061] usbcore: registered new interface driver zaurus
<6>[    6.589392] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<6>[    6.597797] usbcore: registered new interface driver int51x1
<6>[    6.604226] usbcore: registered new interface driver ipheth
<6>[    6.610550] usbcore: registered new interface driver sierra_net
<6>[    6.617321] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[    6.624733] ehci-pci: EHCI PCI platform driver
<6>[    6.629786] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[    6.636803] ohci-pci: OHCI PCI platform driver
<6>[    6.641857] uhci_hcd: USB Universal Host Controller Interface driver
<4>[    6.649188] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
<4>[    6.656499] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
<6>[    6.662150] xhci_hcd 0000:00:14.0: xHCI Host Controller
<6>[    6.668130] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
<7>[    6.676614] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
<7>[    6.684343] xhci_hcd 0000:00:14.0: irq 45 for MSI/MSI-X
<6>[    6.690337] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    6.698041] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    6.706236] usb usb1: Product: xHCI Host Controller
<6>[    6.711771] usb usb1: Manufacturer: Linux 3.17.0-rc7-g5ba60fc xhci_hcd
<6>[    6.719176] usb usb1: SerialNumber: 0000:00:14.0
<6>[    6.724550] hub 1-0:1.0: USB hub found
<6>[    6.728817] hub 1-0:1.0: 11 ports detected
<6>[    6.737893] xhci_hcd 0000:00:14.0: xHCI Host Controller
<6>[    6.743876] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
<6>[    6.752305] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
<6>[    6.760011] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    6.768206] usb usb2: Product: xHCI Host Controller
<6>[    6.773742] usb usb2: Manufacturer: Linux 3.17.0-rc7-g5ba60fc xhci_hcd
<6>[    6.781150] usb usb2: SerialNumber: 0000:00:14.0
<6>[    6.786394] tsc: Refined TSC clocksource calibration: 1596.304 MHz
<6>[    6.793524] hub 2-0:1.0: USB hub found
<6>[    6.797796] hub 2-0:1.0: 4 ports detected
<6>[    6.804190] usbcore: registered new interface driver usbserial
<6>[    6.810821] usbcore: registered new interface driver usbserial_generic
<6>[    6.818235] usbserial: USB Serial support registered for generic
<6>[    6.825078] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
<4>[    6.832780] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
<6>[    6.844929] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[    6.850651] mousedev: PS/2 mouse device common for all mice
<6>[    6.857239] rtc_cmos 00:02: RTC can wake from S4
<6>[    6.862635] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
<6>[    6.869587] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
<6>[    6.878306] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
<6>[    6.884658] iTCO_wdt: Found a Wildcat Point_LP TCO device (Version=2, TCOBASE=0x1860)
<6>[    6.893637] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<6>[    6.900481] iTCO_vendor_support: vendor-support=0
<6>[    6.905868] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
<6>[    6.915656] Intel P-state driver initializing.
<6>[    6.923025] hidraw: raw HID events driver (C) Jiri Kosina
<6>[    6.929606] usbcore: registered new interface driver usbhid
<6>[    6.935970] usbhid: USB HID core driver
<6>[    6.940476] drop_monitor: Initializing network drop monitor service
<6>[    6.947724] TCP: cubic registered
<6>[    6.951499] Initializing XFRM netlink socket
<6>[    6.956553] NET: Registered protocol family 10
<6>[    6.962028] NET: Registered protocol family 17
<6>[    6.967101] 9pnet: Installing 9P2000 support
<7>[    6.972374] 
<7>[    6.972374] printing PIC contents
<7>[    6.977822] ... PIC  IMR: ffff
<7>[    6.981278] ... PIC  IRR: 0c00
<7>[    6.984754] ... PIC  ISR: 0000
<7>[    6.988220] ... PIC ELCR: 0c00
<7>[    6.991687] printing local APIC contents on CPU#0/2:
<6>[    6.997317] ... APIC ID:      02000000 (2)
<6>[    7.001962] ... APIC VERSION: 01060015
<7>[    7.006212] ... APIC TASKPRI: 00000000 (00)
<7>[    7.010954] ... APIC PROCPRI: 00000000
<7>[    7.015202] ... APIC LDR: 01000000
<7>[    7.019058] ... APIC DFR: ffffffff
<7>[    7.022913] ... APIC SPIV: 000001ff
<7>[    7.026867] ... APIC ISR field:
<4>[    7.030427] 0000000000000000000000000000000000000000000000000000000000000000
<7>[    7.038507] ... APIC TMR field:
<4>[    7.042066] 0000000000000000000000000000000000000000000000000000000000000000
<7>[    7.050145] ... APIC IRR field:
<4>[    7.053704] 0000000000000000000000000000000000000000000200000000000000008000
<7>[    7.061781] ... APIC ESR: 00000000
<7>[    7.065638] ... APIC ICR: 000008fd
<7>[    7.069493] ... APIC ICR2: 02000000
<7>[    7.073447] ... APIC LVTT: 000400ef
<7>[    7.077401] ... APIC LVTPC: 00000400
<7>[    7.081453] ... APIC LVT0: 00010700
<7>[    7.085408] ... APIC LVT1: 00000400
<7>[    7.089362] ... APIC LVTERR: 000000fe
<7>[    7.093513] ... APIC TMICT: 00000000
<6>[    7.096963] usb 1-8: new full-speed USB device number 2 using xhci_hcd
<7>[    7.104967] ... APIC TMCCT: 00000000
<7>[    7.109019] ... APIC TDCR: 00000000
<4>[    7.112973] 
<7>[    7.114711] number of MP IRQ sources: 15.
<7>[    7.119289] number of IO-APIC #2 registers: 40.
<6>[    7.124448] testing the IO APIC.......................
<7>[    7.130305] IO APIC #2......
<7>[    7.133593] .... register #00: 02000000
<7>[    7.137947] .......    : physical APIC id: 02
<7>[    7.142910] .......    : Delivery Type: 0
<7>[    7.147478] .......    : LTS          : 0
<7>[    7.152047] .... register #01: 00270020
<7>[    7.156419] .......     : max redirection entries: 27
<7>[    7.162170] .......     : PRQ implemented: 0
<7>[    7.167032] .......     : IO APIC version: 20
<7>[    7.171994] .... register #02: 00000000
<7>[    7.176377] .......     : arbitration: 00
<7>[    7.180924] .... IRQ redirection table:
<4>[    7.185282] 0   1    0    0   0   0    0     0    00
<4>[    7.190939] 1   0    0    0   0   0    0     0    01
<4>[    7.196588] 1   0    0    0   0   0    0     0    02
<4>[    7.202244] 1   0    0    0   0   0    0     0    03
<4>[    7.207901] 1   0    0    0   0   0    0     0    04
<4>[    7.213558] 1   0    0    0   0   0    0     0    05
<4>[    7.219216] 1   0    0    0   0   0    0     0    06
<4>[    7.224874] 1   0    0    0   0   0    0     0    07
<4>[    7.230532] 1   0    0    0   0   0    0     0    08
<4>[    7.236189] 1   0    1    0   0   0    0     0    09
<4>[    7.241844] 1   0    0    0   0   0    0     0    0A
<4>[    7.247501] 1   0    0    0   0   0    0     0    0B
<4>[    7.253159] 1   0    0    0   0   0    0     0    0C
<4>[    7.258816] 1   0    0    0   0   0    0     0    0D
<4>[    7.264473] 1   0    0    0   0   0    0     0    0E
<4>[    7.270130] 1   0    0    0   0   0    0     0    0F
<4>[    7.275792] 1   1    1    0   1   0    0     0    10
<4>[    7.281453] 0   1    0    0   0   0    0     0    00
<4>[    7.287108] 0   1    0    0   0   0    0     0    00
<4>[    7.292751] 0   1    0    0   0   0    0     0    00
<4>[    7.298401] 1   1    1    0   1   0    0     0    14
<4>[    7.304079] 0   1    0    0   0   0    0     0    00
<4>[    7.309745] 0   1    0    0   0   0    0     0    00
<4>[    7.315405] 0   1    0    0   0   0    0     0    00
<4>[    7.321063] 0   1    0    0   0   0    0     0    00
<6>[    7.321071] usb 1-8: New USB device found, idVendor=8087, idProduct=07dc
<6>[    7.321073] usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<4>[    7.342462] 0   1    0    0   0   0    0     0    00
<4>[    7.348123] 0   1    0    0   0   0    0     0    00
<4>[    7.353779] 0   1    0    0   0   0    0     0    00
<4>[    7.359436] 0   1    0    0   0   0    0     0    00
<4>[    7.365093] 0   1    0    0   0   0    0     0    00
<4>[    7.370750] 0   1    0    0   0   0    0     0    00
<4>[    7.376404] 0   1    0    0   0   0    0     0    00
<4>[    7.382059] 0   1    0    0   0   0    0     0    00
<4>[    7.387715] 0   1    0    0   0   0    0     0    00
<4>[    7.393371] 0   1    0    0   0   0    0     0    00
<4>[    7.399028] 0   1    0    0   0   0    0     0    00
<4>[    7.404666] 0   1    0    0   0   0    0     0    00
<4>[    7.410324] 0   1    0    0   0   0    0     0    00
<4>[    7.415982] 0   1    0    0   0   0    0     0    00
<4>[    7.421638] 0   1    0    0   0   0    0     0    00
<7>[    7.427290] IRQ to pin mappings:
<7>[    7.430973] IRQ0 -> 0:2
<7>[    7.433775] IRQ1 -> 0:1
<7>[    7.436596] IRQ3 -> 0:3
<7>[    7.439396] IRQ4 -> 0:4
<7>[    7.442205] IRQ5 -> 0:5
<7>[    7.445010] IRQ6 -> 0:6
<7>[    7.447802] IRQ7 -> 0:7
<7>[    7.450620] IRQ8 -> 0:8
<7>[    7.453420] IRQ9 -> 0:9
<7>[    7.456241] IRQ10 -> 0:10
<7>[    7.459238] IRQ11 -> 0:11
<7>[    7.462244] IRQ12 -> 0:12
<7>[    7.465253] IRQ13 -> 0:13
<7>[    7.468248] IRQ14 -> 0:14
<7>[    7.471263] IRQ15 -> 0:15
<7>[    7.474252] IRQ16 -> 0:16
<7>[    7.477270] IRQ20 -> 0:20
<6>[    7.480286] .................................... done.
<5>[    7.486410] Loading compiled-in X.509 certificates
<5>[    7.493018] Loaded X.509 cert 'Magrathea: Glacier signing key: 51f66d467af578e89ed61c5fc40ea9267fc4638d'
<6>[    7.503797] registered taskstats version 1
<5>[    7.510289] Key type trusted registered
<5>[    7.516213] Key type encrypted registered
<6>[    7.522620] ima: No TPM chip found, activating TPM-bypass!
<6>[    7.528892] evm: HMAC attrs: 0x1
<6>[    7.533035] rtc_cmos 00:02: setting system clock to 2014-10-11 12:49:47 UTC (1413031787)
<7>[    7.643081] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
<7>[    7.749509] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
<6>[    7.755309] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>[    7.793579] Switched to clocksource tsc
<6>[   10.656396] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
<6>[   10.665875] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>[   10.676838] Sending DHCP requests .., OK
<4>[   13.476176] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.151
<6>[   13.485037] IP-Config: Complete:
<6>[   13.488702]      device=eth0, hwaddr=00:13:20:fc:e4:31, ipaddr=192.168.1.151, mask=255.255.255.0, gw=192.168.1.1
<6>[   13.500244]      host=lkp-bdw01, domain=lkp.intel.com, nis-domain=(none)
<6>[   13.507847]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>[   13.515441]      nameserver0=192.168.1.1
<7>[   13.520117] PM: Hibernation image not present or could not be loaded.
<6>[   13.528606] Freeing unused kernel memory: 1804K (ffffffff81dd1000 - ffffffff81f94000)
<6>[   13.699783] [drm] Initialized drm 1.1.0 20060810
<7>[   13.722934] IOAPIC[0]: Set routing entry (2-18 -> 0xe1 -> IRQ 18 Mode:1 Active:1 Dest:15)
<7>[   13.740318] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E1 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<7>[   13.760311] libata version 3.00 loaded.
<4>[   13.767934] ACPI Warning: SystemIO range 0x000000000000efa0-0x000000000000efbf conflicts with OpRegion 0x000000000000efa0-0x000000000000efaf (\_SB_.PCI0.SBUS.SMBI) (20140724/utaddress-258)
<6>[   13.787061] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<6>[   13.809869] sdhci: Secure Digital Host Controller Interface driver
<6>[   13.816906] sdhci: Copyright(c) Pierre Ossman
<6>[   13.821873] [drm] Memory usable by graphics device = 4096M
<6>[   13.828114] [drm] Replacing VGA console driver
<7>[   13.839481] i915 0000:00:02.0: irq 46 for MSI/MSI-X
<6>[   13.845023] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
<6>[   13.852528] [drm] Driver supports precise vblank timestamp query.
<6>[   13.859526] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
<6>[   14.008225] input: PC Speaker as /devices/platform/pcspkr/input/input5
<3>[   14.018536] Error: Driver 'pcspkr' is already registered, aborting...
<3>[   14.912258] [drm:stop_ring] *ERROR* render ring : timed out trying to stop ring
<6>[   14.922806] fbcon: inteldrmfb (fb0) is primary device
<6>[   14.926358] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
<6>[   14.926464] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
<6>[   14.926614] [drm] Initialized i915 1.6.0 20141003 for 0000:00:02.0 on minor 0
<7>[   14.926859] snd_hda_intel 0000:00:03.0: irq 47 for MSI/MSI-X
<7>[   14.927005] ahci 0000:00:1f.2: version 3.0
<7>[   14.927147] IOAPIC[0]: Set routing entry (2-19 -> 0x52 -> IRQ 19 Mode:1 Active:1 Dest:15)
<7>[   14.927155] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:52 Dest:00000F00 SID:F0F8 SQ:0 SVT:1)
<7>[   14.927202] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
<6>[   14.934320] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input7
<6>[   14.934452] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input8
<6>[   14.935855] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
<6>[   14.938268] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 2 ports 6 Gbps 0x2 impl SATA mode
<6>[   14.938273] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo only pio slum part deso sadm sds apst 
<6>[   14.938742] scsi host0: ahci
<6>[   14.938931] scsi host1: ahci
<6>[   14.939015] ata1: DUMMY
<6>[   14.939018] ata2: SATA max UDMA/133 abar m2048@0xc1137000 port 0xc1137180 irq 48
<6>[   15.243493] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<6>[   15.254520] ata2.00: ATA-9: INTEL SSDSC2CW120A3, 400i, max UDMA/133
<6>[   15.254523] ata2.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
<6>[   15.264482] ata2.00: configured for UDMA/133
<6>[   16.032170] Console: switching to colour frame buffer device 240x67
<6>[   16.221149] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
<6>[   16.228217] i915 0000:00:02.0: registered panic notifier
<5>[   16.237548] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW12 400i PQ: 0 ANSI: 5
<5>[   16.259443] sd 1:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
<5>[   16.268041] sd 1:0:0:0: [sda] Write Protect is off
<7>[   16.273501] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[   16.279267] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6>[   16.290456]  sda: sda1 sda2
<5>[   16.293929] sd 1:0:0:0: [sda] Attached SCSI disk
<5>[   16.302749] sd 1:0:0:0: Attached scsi generic sg0 type 0
<5>[   16.743472] random: dd urandom read with 62 bits of entropy available
<6>[   18.813477] [drm] stuck on render ring
<6>[   18.825825] [drm] GPU HANG: ecode 0:0xdfe58c9a, reason: Ring hung, action: reset
<6>[   18.840268] [drm] GPU hangs can indicate a bug anywhere in the entire gfx stack, including userspace.
<6>[   18.856821] [drm] Please file a _new_ bug report on bugs.freedesktop.org against DRI -> DRM/Intel
<6>[   18.872980] [drm] drm/i915 developers can then reassign to the right component if it's not a kernel issue.
<6>[   18.888828] [drm] The gpu crash dump is required to analyze gpu hangs, so please always attach it.
<6>[   18.903594] [drm] GPU crash dump saved to /sys/class/drm/card0/error
<5>[   18.917481] drm/i915: Resetting chip after gpu hang
<4>[   20.815201] ------------[ cut here ]------------
<4>[   20.825077] WARNING: CPU: 0 PID: 4 at drivers/gpu/drm/i915/intel_pm.c:3683 gen8_enable_rps_interrupts+0xd1/0x100 [i915]()
<4>[   20.843726] Modules linked in: sg sd_mod crc_t10dif crct10dif_generic crct10dif_pclmul crct10dif_common snd_hda_codec_hdmi winbond_cir rc_core pcspkr parport_pc parport i2c_hid sdhci_acpi ahci snd_hda_intel sdhci dw_dmac dw_dmac_core mmc_core libahci snd_hda_controller i915 snd_hda_codec libata snd_hwdep i2c_i801 snd_pcm video snd_timer drm_kms_helper snd drm soundcore acpi_pad
<4>[   20.892012] CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 3.17.0-rc7-g5ba60fc #1
<4>[   20.905126] Hardware name: Intel Corporation Broadwell Client platform/WhiteTip Mountain 1, BIOS BDW-E1R1.86C.0079.R00.1406020127 06/02/2014
<4>[   20.924567] Workqueue: events intel_gen6_powersave_work [i915]
<4>[   20.936261]  0000000000000009 ffff8801407ffd68 ffffffff818570a6 0000000000000000
<4>[   20.949809]  ffff8801407ffda0 ffffffff8106ef1d ffff88014d840000 ffff88014d847290
<4>[   20.963332]  ffff88014d848728 0000000000040000 ffff88014d847240 ffff8801407ffdb0
<4>[   20.976890] Call Trace:
<4>[   20.984753]  [<ffffffff818570a6>] dump_stack+0x4d/0x66
<4>[   20.995688]  [<ffffffff8106ef1d>] warn_slowpath_common+0x7d/0xa0
<4>[   21.007598]  [<ffffffff8106effa>] warn_slowpath_null+0x1a/0x20
<4>[   21.019304]  [<ffffffffa01890c1>] gen8_enable_rps_interrupts+0xd1/0x100 [i915]
<4>[   21.032610]  [<ffffffffa0190743>] intel_gen6_powersave_work+0x973/0x1070 [i915]
<4>[   21.045986]  [<ffffffff8108814a>] process_one_work+0x15a/0x4b0
<4>[   21.057663]  [<ffffffff8108850b>] worker_thread+0x6b/0x5e0
<4>[   21.068915]  [<ffffffff810884a0>] ? process_one_work+0x4b0/0x4b0
<4>[   21.080762]  [<ffffffff8108e1ab>] kthread+0xdb/0x100
<4>[   21.091377]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
<4>[   21.103757]  [<ffffffff8185fcbc>] ret_from_fork+0x7c/0xb0
<4>[   21.114836]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
<4>[   21.127222] ---[ end trace 8b3e479c87d3f9f5 ]---
<6>[   23.882099] ipmi message handler version 39.2
<6>[   23.891663] IPMI Watchdog: driver initialized

--GZVR6ND4mMseVXL/--
