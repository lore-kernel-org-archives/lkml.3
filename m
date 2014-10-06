Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaJFFML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:12:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:39624 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbaJFFMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:12:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="395882446"
Date: Mon, 6 Oct 2014 13:11:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [x86, this_cpu_ptr] BUG: unable to handle kernel paging request at
 000000000000d968
Message-ID: <20141006051144.GA28732@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Christoph,

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 89cbc76768c2fa4ed95545bf961f3a14ddfeed21 ("x86: Replace __get_cpu_var uses")


532d0d0690d1532  89cbc76768c2fa4ed95545bf9
---------------  -------------------------
         0           +Inf%          0 ±50%  dmesg.BUG:unable_to_handle_kernel
         0           +Inf%          1 ± 0%  last_state.running
         0           +Inf%          1 ± 0%  last_state.is_incomplete_run

run: /lkp/lkp/src/monitors/wrapper numa-vmstat	{}
run: /lkp/lkp/src/monitors/wrapper numa-meminfo	{}
run: /lkp/lkp/src/monitors/w
[   45.378447] BUG: unable to handle kernel paging request at 000000000000d968
[   45.379430] IP:PROGRESS CODE: V3020003 I0
Loading PEIM at 0x000FFFD57C0 EntryPoint=0x000FFFD673C 

Thanks,
Fengguang

--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc1-00017-g89cbc76 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Wed Sep 24 23:52:31 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/brickland3/bisect_aim9-performance-300s-mem_rtns_2-x86_64-rhel-89cbc76768c2fa4ed95545bf961f3a14ddfeed21-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/89cbc76768c2fa4ed95545bf961f3a14ddfeed21/vmlinuz-3.17.0-rc1-00017-g89cbc76 kconfig=x86_64-rhel commit=89cbc76768c2fa4ed95545bf961f3a14ddfeed21 branch=next/master root=/dev/ram0 max_uptime=1313 RESULT_ROOT=/result/brickland3/aim9/performance-300s-mem_rtns_2/debian-x86_64.cgz/x86_64-rhel/89cbc76768c2fa4ed95545bf961f3a14ddfeed21/0 ip=::::brickland3::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006504afff] usable
[    0.000000] BIOS-e820: [mem 0x000000006504b000-0x0000000065324fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000065325000-0x0000000065c1cfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065c1d000-0x0000000065cd4fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000065cd5000-0x0000000065d8efff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065d8f000-0x0000000066d8efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000066d8f000-0x000000007abcefff] usable
[    0.000000] BIOS-e820: [mem 0x000000007abcf000-0x000000007accefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007accf000-0x000000007b6fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b6ff000-0x000000007b7e8fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7e9000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000807fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation BRICKLAND/BRICKLAND, BIOS BIVTSDP1.86B.0038.R02.1307231126 07/23/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x8080000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000080000000 mask 3FFF80000000 uncachable
[    0.000000]   1 base 380000000000 mask 3F8000000000 uncachable
[    0.000000]   2 base 00007C000000 mask 3FFFFC000000 uncachable
[    0.000000]   3 base 00007FC00000 mask 3FFFFFC00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x7b800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009d000-0x0009d3ff]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x807f185000, 0x807f185fff] PGTABLE
[    0.000000] BRK [0x807f186000, 0x807f186fff] PGTABLE
[    0.000000] BRK [0x807f187000, 0x807f187fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x807fe00000-0x807fffffff]
[    0.000000]  [mem 0x807fe00000-0x807fffffff] page 1G
[    0.000000] BRK [0x807f188000, 0x807f188fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x807c000000-0x807fdfffff]
[    0.000000]  [mem 0x807c000000-0x807fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x8000000000-0x807bffffff]
[    0.000000]  [mem 0x8000000000-0x807bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x7000000000-0x7fffffffff]
[    0.000000]  [mem 0x7000000000-0x7fffffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6504afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x64ffffff] page 2M
[    0.000000]  [mem 0x65000000-0x6504afff] page 4k
[    0.000000] BRK [0x807f189000, 0x807f189fff] PGTABLE
[    0.000000] BRK [0x807f18a000, 0x807f18afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x65325000-0x65c1cfff]
[    0.000000]  [mem 0x65325000-0x653fffff] page 4k
[    0.000000]  [mem 0x65400000-0x65bfffff] page 2M
[    0.000000]  [mem 0x65c00000-0x65c1cfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x65cd5000-0x65d8efff]
[    0.000000]  [mem 0x65cd5000-0x65d8efff] page 4k
[    0.000000] init_memory_mapping: [mem 0x66d8f000-0x7abcefff]
[    0.000000]  [mem 0x66d8f000-0x66dfffff] page 4k
[    0.000000]  [mem 0x66e00000-0x7a9fffff] page 2M
[    0.000000]  [mem 0x7aa00000-0x7abcefff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7b7e9000-0x7b7fffff]
[    0.000000]  [mem 0x7b7e9000-0x7b7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x6fffffffff]
[    0.000000]  [mem 0x100000000-0x6fffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x807661b000-0x807dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x000000007B7E70E8 0000AC (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: FACP 0x000000007B7E4000 0000F4 (v04 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: DSDT 0x000000007B7B5000 023651 (v02 INTEL  TIANO    00000003 MSFT 01000013)
[    0.000000] ACPI: FACS 0x000000007AE13000 000040
[    0.000000] ACPI: TCPA 0x000000007B7E6000 000064 (v02 INTEL  BRICKLAN 06222004 INTL 20121004)
[    0.000000] ACPI: BDAT 0x000000007B7E5000 000030 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: HPET 0x000000007B7E3000 000038 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 0x000000007B7E2000 00085C (v03 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: MCFG 0x000000007B7E1000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: MSCT 0x000000007B7E0000 000090 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: PCCT 0x000000007B7DF000 0000AC (v01 INTEL  TIANO    00000002 MSFT 01000013)
[    0.000000] ACPI: PMCT 0x000000007B7DE000 000060 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: RASF 0x000000007B7DD000 000030 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SLIT 0x000000007B7DC000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SRAT 0x000000007B7DB000 000E30 (v03 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SVOS 0x000000007B7DA000 000032 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: WDDT 0x000000007B7D9000 000040 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: SSDT 0x0000000065C1D000 0B723B (v02 INTEL  SSDT  PM 00004000 INTL 20090521)
[    0.000000] ACPI: SSDT 0x000000007B7B4000 000064 (v02 INTEL  SpsNvs   00000002 INTL 20090521)
[    0.000000] ACPI: SPCR 0x000000007B7B3000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x18 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1c -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x38 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3c -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x48 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4c -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4e -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x58 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5c -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x68 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6c -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6e -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x78 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7c -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0f -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x19 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1d -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2d -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2f -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x39 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3d -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x49 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4d -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4f -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x59 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5d -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x69 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6d -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6f -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x79 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7d -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x207fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x2080000000-0x407fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x4080000000-0x607fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x6080000000-0x807fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x207fffffff] -> [mem 0x00000000-0x207fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x207fffffff]
[    0.000000]   NODE_DATA [mem 0x207ffda000-0x207fffffff]
[    0.000000] Initmem setup node 1 [mem 0x2080000000-0x407fffffff]
[    0.000000]   NODE_DATA [mem 0x407ffda000-0x407fffffff]
[    0.000000] Initmem setup node 2 [mem 0x4080000000-0x607fffffff]
[    0.000000]   NODE_DATA [mem 0x607ffda000-0x607fffffff]
[    0.000000] Initmem setup node 3 [mem 0x6080000000-0x807fffffff]
[    0.000000]   NODE_DATA [mem 0x807ffd4000-0x807fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0081ffffff] PMD -> [ffff881fffe00000-ffff88207fdfffff] on node 0
[    0.000000]  [ffffea0082000000-ffffea0101ffffff] PMD -> [ffff883fffe00000-ffff88407fdfffff] on node 1
[    0.000000]  [ffffea0102000000-ffffea0181ffffff] PMD -> [ffff885fffe00000-ffff88607fdfffff] on node 2
[    0.000000]  [ffffea0182000000-ffffea0201ffffff] PMD -> [ffff887ff6600000-ffff8880765fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x807fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x6504afff]
[    0.000000]   node   0: [mem 0x65325000-0x65c1cfff]
[    0.000000]   node   0: [mem 0x65cd5000-0x65d8efff]
[    0.000000]   node   0: [mem 0x66d8f000-0x7abcefff]
[    0.000000]   node   0: [mem 0x7b7e9000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x207fffffff]
[    0.000000]   node   1: [mem 0x2080000000-0x407fffffff]
[    0.000000]   node   2: [mem 0x4080000000-0x607fffffff]
[    0.000000]   node   3: [mem 0x6080000000-0x807fffffff]
[    0.000000] On node 0 totalpages: 33527793
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7714 pages used for memmap
[    0.000000]   DMA32 zone: 493652 pages, LIFO batch:31
[    0.000000]   Normal zone: 516096 pages used for memmap
[    0.000000]   Normal zone: 33030144 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 33554432
[    0.000000]   Normal zone: 524288 pages used for memmap
[    0.000000]   Normal zone: 33554432 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 33554432
[    0.000000]   Normal zone: 524288 pages used for memmap
[    0.000000]   Normal zone: 33554432 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 33554432
[    0.000000]   Normal zone: 524288 pages used for memmap
[    0.000000]   Normal zone: 33554432 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0x2c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0x2e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x52] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x54] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x58] lapic_id[0x38] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5a] lapic_id[0x3a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5c] lapic_id[0x3c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x80] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x82] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x84] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x86] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x88] lapic_id[0x48] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8a] lapic_id[0x4a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8c] lapic_id[0x4c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8e] lapic_id[0x4e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x90] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x92] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x94] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x96] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x98] lapic_id[0x58] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9a] lapic_id[0x5a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9c] lapic_id[0x5c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc0] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc2] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc4] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc6] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc8] lapic_id[0x68] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xca] lapic_id[0x6a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcc] lapic_id[0x6c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xce] lapic_id[0x6e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd0] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd2] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd4] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd6] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd8] lapic_id[0x78] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xda] lapic_id[0x7a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdc] lapic_id[0x7c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0x2d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0x2f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x53] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x55] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x59] lapic_id[0x39] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5b] lapic_id[0x3b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5d] lapic_id[0x3d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x81] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x83] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x85] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x87] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x89] lapic_id[0x49] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8b] lapic_id[0x4b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8d] lapic_id[0x4d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8f] lapic_id[0x4f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x91] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x93] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x95] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x97] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x99] lapic_id[0x59] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9b] lapic_id[0x5b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9d] lapic_id[0x5d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc1] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc3] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc5] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc7] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc9] lapic_id[0x69] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcb] lapic_id[0x6b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcd] lapic_id[0x6d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcf] lapic_id[0x6f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd1] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd3] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd5] lapic_id[0x75] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd7] lapic_id[0x77] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd9] lapic_id[0x79] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdb] lapic_id[0x7b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdd] lapic_id[0x7d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x28] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x29] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x32] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x33] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x34] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x35] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x38] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x39] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x40] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x41] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x42] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x43] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x44] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x45] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x46] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x47] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x48] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x49] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x50] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x51] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x52] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x53] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x54] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x55] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x56] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x57] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x58] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x59] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x60] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x61] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x62] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x63] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x64] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x65] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x66] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x67] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x68] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x69] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x70] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x71] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x72] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x73] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x74] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x75] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x76] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x77] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x78] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x79] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x80] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x81] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x82] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x83] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x84] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x85] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x86] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x87] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x88] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x89] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec40000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec40000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x0b] address[0xfec80000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 11, version 32, address 0xfec80000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x0c] address[0xfecc0000] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 12, version 32, address 0xfecc0000, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 144 CPUs, 24 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec40000)
[    0.000000] mapped IOAPIC to ffffffffff578000 (fec80000)
[    0.000000] mapped IOAPIC to ffffffffff577000 (fecc0000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x6504b000-0x65324fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65c1d000-0x65cd4fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65d8f000-0x66d8efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7abcf000-0x7accefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7accf000-0x7b6fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6ff000-0x7b7e8fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b800000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:144 nr_cpu_ids:144 nr_node_ids:4
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff881fff800000 s88960 r8192 d21632 u131072
[    0.000000] pcpu-alloc: s88960 r8192 d21632 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 008 009 010 011 012 013 014 060 
[    0.000000] pcpu-alloc: [0] 061 062 063 064 065 066 067 068 069 070 071 072 073 074 120 124 
[    0.000000] pcpu-alloc: [0] 128 132 136 140 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [1] 015 016 017 018 019 020 021 022 023 024 025 026 027 028 029 075 
[    0.000000] pcpu-alloc: [1] 076 077 078 079 080 081 082 083 084 085 086 087 088 089 121 125 
[    0.000000] pcpu-alloc: [1] 129 133 137 141 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [2] 030 031 032 033 034 035 036 037 038 039 040 041 042 043 044 090 
[    0.000000] pcpu-alloc: [2] 091 092 093 094 095 096 097 098 099 100 101 102 103 104 122 126 
[    0.000000] pcpu-alloc: [2] 130 134 138 142 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [3] 045 046 047 048 049 050 051 052 053 054 055 056 057 058 059 105 
[    0.000000] pcpu-alloc: [3] 106 107 108 109 110 111 112 113 114 115 116 117 118 119 123 127 
[    0.000000] pcpu-alloc: [3] 131 135 139 143 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 132094328
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/brickland3/bisect_aim9-performance-300s-mem_rtns_2-x86_64-rhel-89cbc76768c2fa4ed95545bf961f3a14ddfeed21-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/89cbc76768c2fa4ed95545bf961f3a14ddfeed21/vmlinuz-3.17.0-rc1-00017-g89cbc76 kconfig=x86_64-rhel commit=89cbc76768c2fa4ed95545bf961f3a14ddfeed21 branch=next/master root=/dev/ram0 max_uptime=1313 RESULT_ROOT=/result/brickland3/aim9/performance-300s-mem_rtns_2/debian-x86_64.cgz/x86_64-rhel/89cbc76768c2fa4ed95545bf961f3a14ddfeed21/0 ip=::::brickland3::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 585728 bytes
[    0.000000] log_buf_len min size: 524288 bytes
[    0.000000] log_buf_len: 2097152 bytes
[    0.000000] early log buf free: 479960(91%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 528146608K/536764356K available (8611K kernel code, 1703K rwdata, 3868K rodata, 1804K init, 1888K bss, 8617748K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=144.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-143.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=144
[    0.000000] NR_IRQS:524544 nr_irqs:3208 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc1-00017-g89cbc76 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Wed Sep 24 23:52:31 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/brickland3/bisect_aim9-performance-300s-mem_rtns_2-x86_64-rhel-89cbc76768c2fa4ed95545bf961f3a14ddfeed21-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/89cbc76768c2fa4ed95545bf961f3a14ddfeed21/vmlinuz-3.17.0-rc1-00017-g89cbc76 kconfig=x86_64-rhel commit=89cbc76768c2fa4ed95545bf961f3a14ddfeed21 branch=next/master root=/dev/ram0 max_uptime=1313 RESULT_ROOT=/result/brickland3/aim9/performance-300s-mem_rtns_2/debian-x86_64.cgz/x86_64-rhel/89cbc76768c2fa4ed95545bf961f3a14ddfeed21/0 ip=::::brickland3::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006504afff] usable
[    0.000000] BIOS-e820: [mem 0x000000006504b000-0x0000000065324fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000065325000-0x0000000065c1cfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065c1d000-0x0000000065cd4fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000065cd5000-0x0000000065d8efff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065d8f000-0x0000000066d8efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000066d8f000-0x000000007abcefff] usable
[    0.000000] BIOS-e820: [mem 0x000000007abcf000-0x000000007accefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007accf000-0x000000007b6fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b6ff000-0x000000007b7e8fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7e9000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000807fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation BRICKLAND/BRICKLAND, BIOS BIVTSDP1.86B.0038.R02.1307231126 07/23/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x8080000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000080000000 mask 3FFF80000000 uncachable
[    0.000000]   1 base 380000000000 mask 3F8000000000 uncachable
[    0.000000]   2 base 00007C000000 mask 3FFFFC000000 uncachable
[    0.000000]   3 base 00007FC00000 mask 3FFFFFC00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x7b800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009d000-0x0009d3ff]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x807f185000, 0x807f185fff] PGTABLE
[    0.000000] BRK [0x807f186000, 0x807f186fff] PGTABLE
[    0.000000] BRK [0x807f187000, 0x807f187fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x807fe00000-0x807fffffff]
[    0.000000]  [mem 0x807fe00000-0x807fffffff] page 1G
[    0.000000] BRK [0x807f188000, 0x807f188fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x807c000000-0x807fdfffff]
[    0.000000]  [mem 0x807c000000-0x807fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x8000000000-0x807bffffff]
[    0.000000]  [mem 0x8000000000-0x807bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x7000000000-0x7fffffffff]
[    0.000000]  [mem 0x7000000000-0x7fffffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6504afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x64ffffff] page 2M
[    0.000000]  [mem 0x65000000-0x6504afff] page 4k
[    0.000000] BRK [0x807f189000, 0x807f189fff] PGTABLE
[    0.000000] BRK [0x807f18a000, 0x807f18afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x65325000-0x65c1cfff]
[    0.000000]  [mem 0x65325000-0x653fffff] page 4k
[    0.000000]  [mem 0x65400000-0x65bfffff] page 2M
[    0.000000]  [mem 0x65c00000-0x65c1cfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x65cd5000-0x65d8efff]
[    0.000000]  [mem 0x65cd5000-0x65d8efff] page 4k
[    0.000000] init_memory_mapping: [mem 0x66d8f000-0x7abcefff]
[    0.000000]  [mem 0x66d8f000-0x66dfffff] page 4k
[    0.000000]  [mem 0x66e00000-0x7a9fffff] page 2M
[    0.000000]  [mem 0x7aa00000-0x7abcefff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7b7e9000-0x7b7fffff]
[    0.000000]  [mem 0x7b7e9000-0x7b7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x6fffffffff]
[    0.000000]  [mem 0x100000000-0x6fffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x807661b000-0x807dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x000000007B7E70E8 0000AC (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: FACP 0x000000007B7E4000 0000F4 (v04 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: DSDT 0x000000007B7B5000 023651 (v02 INTEL  TIANO    00000003 MSFT 01000013)
[    0.000000] ACPI: FACS 0x000000007AE13000 000040
[    0.000000] ACPI: TCPA 0x000000007B7E6000 000064 (v02 INTEL  BRICKLAN 06222004 INTL 20121004)
[    0.000000] ACPI: BDAT 0x000000007B7E5000 000030 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: HPET 0x000000007B7E3000 000038 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 0x000000007B7E2000 00085C (v03 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: MCFG 0x000000007B7E1000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: MSCT 0x000000007B7E0000 000090 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: PCCT 0x000000007B7DF000 0000AC (v01 INTEL  TIANO    00000002 MSFT 01000013)
[    0.000000] ACPI: PMCT 0x000000007B7DE000 000060 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: RASF 0x000000007B7DD000 000030 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SLIT 0x000000007B7DC000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SRAT 0x000000007B7DB000 000E30 (v03 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SVOS 0x000000007B7DA000 000032 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: WDDT 0x000000007B7D9000 000040 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: SSDT 0x0000000065C1D000 0B723B (v02 INTEL  SSDT  PM 00004000 INTL 20090521)
[    0.000000] ACPI: SSDT 0x000000007B7B4000 000064 (v02 INTEL  SpsNvs   00000002 INTL 20090521)
[    0.000000] ACPI: SPCR 0x000000007B7B3000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x18 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1c -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x38 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3c -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x48 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4c -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4e -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x58 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5c -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x68 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6c -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6e -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x78 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7c -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0f -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x19 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1d -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2d -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2f -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x39 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3d -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x49 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4d -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4f -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x59 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5d -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x69 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6d -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6f -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x79 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7d -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x207fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x2080000000-0x407fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x4080000000-0x607fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x6080000000-0x807fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x207fffffff] -> [mem 0x00000000-0x207fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x207fffffff]
[    0.000000]   NODE_DATA [mem 0x207ffda000-0x207fffffff]
[    0.000000] Initmem setup node 1 [mem 0x2080000000-0x407fffffff]
[    0.000000]   NODE_DATA [mem 0x407ffda000-0x407fffffff]
[    0.000000] Initmem setup node 2 [mem 0x4080000000-0x607fffffff]
[    0.000000]   NODE_DATA [mem 0x607ffda000-0x607fffffff]
[    0.000000] Initmem setup node 3 [mem 0x6080000000-0x807fffffff]
[    0.000000]   NODE_DATA [mem 0x807ffd4000-0x807fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0081ffffff] PMD -> [ffff881fffe00000-ffff88207fdfffff] on node 0
[    0.000000]  [ffffea0082000000-ffffea0101ffffff] PMD -> [ffff883fffe00000-ffff88407fdfffff] on node 1
[    0.000000]  [ffffea0102000000-ffffea0181ffffff] PMD -> [ffff885fffe00000-ffff88607fdfffff] on node 2
[    0.000000]  [ffffea0182000000-ffffea0201ffffff] PMD -> [ffff887ff6600000-ffff8880765fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x807fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x6504afff]
[    0.000000]   node   0: [mem 0x65325000-0x65c1cfff]
[    0.000000]   node   0: [mem 0x65cd5000-0x65d8efff]
[    0.000000]   node   0: [mem 0x66d8f000-0x7abcefff]
[    0.000000]   node   0: [mem 0x7b7e9000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x207fffffff]
[    0.000000]   node   1: [mem 0x2080000000-0x407fffffff]
[    0.000000]   node   2: [mem 0x4080000000-0x607fffffff]
[    0.000000]   node   3: [mem 0x6080000000-0x807fffffff]
[    0.000000] On node 0 totalpages: 33527793
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7714 pages used for memmap
[    0.000000]   DMA32 zone: 493652 pages, LIFO batch:31
[    0.000000]   Normal zone: 516096 pages used for memmap
[    0.000000]   Normal zone: 33030144 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 33554432
[    0.000000]   Normal zone: 524288 pages used for memmap
[    0.000000]   Normal zone: 33554432 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 33554432
[    0.000000]   Normal zone: 524288 pages used for memmap
[    0.000000]   Normal zone: 33554432 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 33554432
[    0.000000]   Normal zone: 524288 pages used for memmap
[    0.000000]   Normal zone: 33554432 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0x2c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0x2e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x52] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x54] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x58] lapic_id[0x38] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5a] lapic_id[0x3a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5c] lapic_id[0x3c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x80] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x82] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x84] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x86] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x88] lapic_id[0x48] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8a] lapic_id[0x4a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8c] lapic_id[0x4c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8e] lapic_id[0x4e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x90] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x92] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x94] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x96] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x98] lapic_id[0x58] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9a] lapic_id[0x5a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9c] lapic_id[0x5c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc0] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc2] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc4] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc6] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc8] lapic_id[0x68] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xca] lapic_id[0x6a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcc] lapic_id[0x6c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xce] lapic_id[0x6e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd0] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd2] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd4] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd6] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd8] lapic_id[0x78] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xda] lapic_id[0x7a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdc] lapic_id[0x7c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0x2d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0x2f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x53] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x55] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x59] lapic_id[0x39] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5b] lapic_id[0x3b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5d] lapic_id[0x3d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x81] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x83] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x85] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x87] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x89] lapic_id[0x49] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8b] lapic_id[0x4b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8d] lapic_id[0x4d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8f] lapic_id[0x4f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x91] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x93] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x95] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x97] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x99] lapic_id[0x59] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9b] lapic_id[0x5b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9d] lapic_id[0x5d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc1] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc3] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc5] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc7] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc9] lapic_id[0x69] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcb] lapic_id[0x6b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcd] lapic_id[0x6d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcf] lapic_id[0x6f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd1] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd3] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd5] lapic_id[0x75] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd7] lapic_id[0x77] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd9] lapic_id[0x79] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdb] lapic_id[0x7b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdd] lapic_id[0x7d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x28] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x29] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x32] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x33] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x34] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x35] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x38] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x39] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x40] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x41] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x42] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x43] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x44] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x45] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x46] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x47] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x48] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x49] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x50] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x51] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x52] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x53] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x54] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x55] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x56] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x57] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x58] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x59] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x60] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x61] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x62] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x63] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x64] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x65] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x66] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x67] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x68] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x69] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x70] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x71] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x72] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x73] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x74] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x75] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x76] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x77] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x78] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x79] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x80] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x81] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x82] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x83] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x84] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x85] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x86] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x87] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x88] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x89] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec40000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec40000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x0b] address[0xfec80000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 11, version 32, address 0xfec80000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x0c] address[0xfecc0000] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 12, version 32, address 0xfecc0000, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 144 CPUs, 24 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec40000)
[    0.000000] mapped IOAPIC to ffffffffff578000 (fec80000)
[    0.000000] mapped IOAPIC to ffffffffff577000 (fecc0000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x6504b000-0x65324fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65c1d000-0x65cd4fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65d8f000-0x66d8efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7abcf000-0x7accefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7accf000-0x7b6fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6ff000-0x7b7e8fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b800000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:144 nr_cpu_ids:144 nr_node_ids:4
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff881fff800000 s88960 r8192 d21632 u131072
[    0.000000] pcpu-alloc: s88960 r8192 d21632 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 008 009 010 011 012 013 014 060 
[    0.000000] pcpu-alloc: [0] 061 062 063 064 065 066 067 068 069 070 071 072 073 074 120 124 
[    0.000000] pcpu-alloc: [0] 128 132 136 140 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [1] 015 016 017 018 019 020 021 022 023 024 025 026 027 028 029 075 
[    0.000000] pcpu-alloc: [1] 076 077 078 079 080 081 082 083 084 085 086 087 088 089 121 125 
[    0.000000] pcpu-alloc: [1] 129 133 137 141 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [2] 030 031 032 033 034 035 036 037 038 039 040 041 042 043 044 090 
[    0.000000] pcpu-alloc: [2] 091 092 093 094 095 096 097 098 099 100 101 102 103 104 122 126 
[    0.000000] pcpu-alloc: [2] 130 134 138 142 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [3] 045 046 047 048 049 050 051 052 053 054 055 056 057 058 059 105 
[    0.000000] pcpu-alloc: [3] 106 107 108 109 110 111 112 113 114 115 116 117 118 119 123 127 
[    0.000000] pcpu-alloc: [3] 131 135 139 143 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 132094328
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/brickland3/bisect_aim9-performance-300s-mem_rtns_2-x86_64-rhel-89cbc76768c2fa4ed95545bf961f3a14ddfeed21-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/89cbc76768c2fa4ed95545bf961f3a14ddfeed21/vmlinuz-3.17.0-rc1-00017-g89cbc76 kconfig=x86_64-rhel commit=89cbc76768c2fa4ed95545bf961f3a14ddfeed21 branch=next/master root=/dev/ram0 max_uptime=1313 RESULT_ROOT=/result/brickland3/aim9/performance-300s-mem_rtns_2/debian-x86_64.cgz/x86_64-rhel/89cbc76768c2fa4ed95545bf961f3a14ddfeed21/0 ip=::::brickland3::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 585728 bytes
[    0.000000] log_buf_len min size: 524288 bytes
[    0.000000] log_buf_len: 2097152 bytes
[    0.000000] early log buf free: 479960(91%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 528146608K/536764356K available (8611K kernel code, 1703K rwdata, 3868K rodata, 1804K init, 1888K bss, 8617748K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=144.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-143.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=144
[    0.000000] NR_IRQS:524544 nr_irqs:3208 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 2147483648 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2793.244 MHz processor
[    0.000089] Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.48 BogoMIPS (lpj=2793244)
[    0.011968] pid_max: default: 147456 minimum: 1152
[    0.017361] ACPI: Core revision 20140724
[    0.082022] ACPI: All ACPI Tables successfully acquired
[    0.088110] Security Framework initialized
[    0.092695] SELinux:  Initializing.
[    0.096594] SELinux:  Starting in permissive mode
[    0.131665] Dentry cache hash table entries: 67108864 (order: 17, 536870912 bytes)
[    0.283336] Inode-cache hash table entries: 33554432 (order: 16, 268435456 bytes)
[    0.356535] Mount-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.365076] Mountpoint-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.378082] Initializing cgroup subsys memory
[    0.382992] Initializing cgroup subsys devices
[    0.387961] Initializing cgroup subsys freezer
[    0.392929] Initializing cgroup subsys net_cls
[    0.397897] Initializing cgroup subsys blkio
[    0.402674] Initializing cgroup subsys perf_event
[    0.407936] Initializing cgroup subsys hugetlb
[    0.412964] CPU: Physical Processor ID: 0
[    0.417442] CPU: Processor Core ID: 3
[    0.422278] mce: CPU supports 32 MCE banks
[    0.426894] CPU0: Thermal LVT vector (0xfa) already installed
[    0.433333] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.433333] Last level dTLB entries: 4KB 512, 2MB 0, 4MB 0, 1GB 4
[    0.446987] Freeing SMP alternatives memory: 36K (ffffffff81fa1000 - ffffffff81faa000)
[    0.457395] ftrace: allocating 31168 entries in 122 pages
[    0.479101] Getting VERSION: 1060015
[    0.483094] Getting VERSION: 1060015
[    0.487085] Getting ID: 6000000
[    0.490591] Getting ID: 6000000
[    0.494418] Switched APIC routing to physical flat.
[    0.499869] masked ExtINT on CPU#0
[    0.504341] ENABLING IO-APIC IRQs
[    0.508049] init IO_APIC IRQs
[    0.511363]  apic 8 pin 0 not connected
[    0.515656] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:6)
[    0.524510] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:6)
[    0.533361] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:6)
[    0.542229] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:6)
[    0.551086] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:6)
[    0.559928] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:6)
[    0.568778] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:6)
[    0.577629] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:6)
[    0.586479] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:6)
[    0.595329] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:6)
[    0.604375] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:6)
[    0.613421] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:6)
[    0.622465] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:6)
[    0.631510] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:6)
[    0.640554] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:6)
[    0.649598]  apic 8 pin 16 not connected
[    0.653977]  apic 8 pin 17 not connected
[    0.658356]  apic 8 pin 18 not connected
[    0.662735]  apic 8 pin 19 not connected
[    0.667114]  apic 8 pin 20 not connected
[    0.671493]  apic 8 pin 21 not connected
[    0.675873]  apic 8 pin 22 not connected
[    0.680254]  apic 8 pin 23 not connected
[    0.684633]  apic 9 pin 0 not connected
[    0.688914]  apic 9 pin 1 not connected
[    0.693198]  apic 9 pin 2 not connected
[    0.697480]  apic 9 pin 3 not connected
[    0.701761]  apic 9 pin 4 not connected
[    0.706042]  apic 9 pin 5 not connected
[    0.710326]  apic 9 pin 6 not connected
[    0.714609]  apic 9 pin 7 not connected
[    0.718892]  apic 9 pin 8 not connected
[    0.723173]  apic 9 pin 9 not connected
[    0.727455]  apic 9 pin 10 not connected
[    0.731835]  apic 9 pin 11 not connected
[    0.736216]  apic 9 pin 12 not connected
[    0.740596]  apic 9 pin 13 not connected
[    0.744975]  apic 9 pin 14 not connected
[    0.749356]  apic 9 pin 15 not connected
[    0.753735]  apic 9 pin 16 not connected
[    0.758117]  apic 9 pin 17 not connected
[    0.762498]  apic 9 pin 18 not connected
[    0.766879]  apic 9 pin 19 not connected
[    0.771258]  apic 9 pin 20 not connected
[    0.775639]  apic 9 pin 21 not connected
[    0.780021]  apic 9 pin 22 not connected
[    0.784400]  apic 9 pin 23 not connected
[    0.788782]  apic 10 pin 0 not connected
[    0.793161]  apic 10 pin 1 not connected
[    0.797544]  apic 10 pin 2 not connected
[    0.801923]  apic 10 pin 3 not connected
[    0.806302]  apic 10 pin 4 not connected
[    0.810681]  apic 10 pin 5 not connected
[    0.815063]  apic 10 pin 6 not connected
[    0.819442]  apic 10 pin 7 not connected
[    0.823821]  apic 10 pin 8 not connected
[    0.828201]  apic 10 pin 9 not connected
[    0.832581]  apic 10 pin 10 not connected
[    0.837059]  apic 10 pin 11 not connected
[    0.841536]  apic 10 pin 12 not connected
[    0.846014]  apic 10 pin 13 not connected
[    0.850493]  apic 10 pin 14 not connected
[    0.854971]  apic 10 pin 15 not connected
[    0.859448]  apic 10 pin 16 not connected
[    0.863926]  apic 10 pin 17 not connected
[    0.868405]  apic 10 pin 18 not connected
[    0.872885]  apic 10 pin 19 not connected
[    0.877364]  apic 10 pin 20 not connected
[    0.881843]  apic 10 pin 21 not connected
[    0.886323]  apic 10 pin 22 not connected
[    0.890800]  apic 10 pin 23 not connected
[    0.895278]  apic 11 pin 0 not connected
[    0.899657]  apic 11 pin 1 not connected
[    0.904038]  apic 11 pin 2 not connected
[    0.908417]  apic 11 pin 3 not connected
[    0.912796]  apic 11 pin 4 not connected
[    0.917175]  apic 11 pin 5 not connected
[    0.921557]  apic 11 pin 6 not connected
[    0.925936]  apic 11 pin 7 not connected
[    0.930315]  apic 11 pin 8 not connected
[    0.934694]  apic 11 pin 9 not connected
[    0.939075]  apic 11 pin 10 not connected
[    0.943553]  apic 11 pin 11 not connected
[    0.948030]  apic 11 pin 12 not connected
[    0.952507]  apic 11 pin 13 not connected
[    0.956987]  apic 11 pin 14 not connected
[    0.961464]  apic 11 pin 15 not connected
[    0.965941]  apic 11 pin 16 not connected
[    0.970419]  apic 11 pin 17 not connected
[    0.974897]  apic 11 pin 18 not connected
[    0.979372]  apic 11 pin 19 not connected
[    0.983850]  apic 11 pin 20 not connected
[    0.988327]  apic 11 pin 21 not connected
[    0.992806]  apic 11 pin 22 not connected
[    0.997284]  apic 11 pin 23 not connected
[    1.001761]  apic 12 pin 0 not connected
[    1.006140]  apic 12 pin 1 not connected
[    1.010519]  apic 12 pin 2 not connected
[    1.014899]  apic 12 pin 3 not connected
[    1.019278]  apic 12 pin 4 not connected
[    1.023657]  apic 12 pin 5 not connected
[    1.028038]  apic 12 pin 6 not connected
[    1.032417]  apic 12 pin 7 not connected
[    1.036796]  apic 12 pin 8 not connected
[    1.041175]  apic 12 pin 9 not connected
[    1.045554]  apic 12 pin 10 not connected
[    1.050032]  apic 12 pin 11 not connected
[    1.054510]  apic 12 pin 12 not connected
[    1.058987]  apic 12 pin 13 not connected
[    1.063467]  apic 12 pin 14 not connected
[    1.067944]  apic 12 pin 15 not connected
[    1.072422]  apic 12 pin 16 not connected
[    1.076899]  apic 12 pin 17 not connected
[    1.081377]  apic 12 pin 18 not connected
[    1.085854]  apic 12 pin 19 not connected
[    1.090331]  apic 12 pin 20 not connected
[    1.094809]  apic 12 pin 21 not connected
[    1.099286]  apic 12 pin 22 not connected
[    1.103764]  apic 12 pin 23 not connected
[    1.108381] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.125106] smpboot: CPU0: Intel(R) Xeon(R) CPU E7-4890 v2 @ 2.80GHz (fam: 06, model: 3e, stepping: 07)
[    1.135652] TSC deadline timer enabled
[    1.139892] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    1.151441] ... version:                3
[    1.155919] ... bit width:              48
[    1.160493] ... generic registers:      4
[    1.164973] ... value mask:             0000ffffffffffff
[    1.170904] ... max period:             0000ffffffffffff
[    1.176836] ... fixed-purpose events:   3
[    1.181313] ... event mask:             000000070000000f
[    1.193731] x86: Booting SMP configuration:
[    1.198406] .... node  #0, CPUs:          #1
[    1.214138] masked ExtINT on CPU#1
[    1.218934] CPU1: Thermal LVT vector (0xfa) already installed
[    1.231658] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    1.240799]    #2
[    1.255480] masked ExtINT on CPU#2
[    1.260276] CPU2: Thermal LVT vector (0xfa) already installed
[    1.269033]    #3
[    1.282155] masked ExtINT on CPU#3
[    1.286968] CPU3: Thermal LVT vector (0xfa) already installed
[    1.295757]    #4
[    1.308882] masked ExtINT on CPU#4
[    1.313696] CPU4: Thermal LVT vector (0xfa) already installed
[    1.322472]    #5
[    1.335623] masked ExtINT on CPU#5
[    1.340485] CPU5: Thermal LVT vector (0xfa) already installed
[    1.349283]    #6
[    1.362430] masked ExtINT on CPU#6
[    1.367258] CPU6: Thermal LVT vector (0xfa) already installed
[    1.376091]    #7
[    1.389216] masked ExtINT on CPU#7
[    1.394042] CPU7: Thermal LVT vector (0xfa) already installed
[    1.402812]    #8
[    1.415961] masked ExtINT on CPU#8
[    1.420777] CPU8: Thermal LVT vector (0xfa) already installed
[    1.429623]    #9
[    1.442751] masked ExtINT on CPU#9
[    1.447571] CPU9: Thermal LVT vector (0xfa) already installed
[    1.456334]   #10
[    1.469416] masked ExtINT on CPU#10
[    1.474340] CPU10: Thermal LVT vector (0xfa) already installed
[    1.483252]   #11
[    1.496328] masked ExtINT on CPU#11
[    1.501221] CPU11: Thermal LVT vector (0xfa) already installed
[    1.510162]   #12
[    1.523240] masked ExtINT on CPU#12
[    1.528135] CPU12: Thermal LVT vector (0xfa) already installed
[    1.537077]   #13
[    1.550154] masked ExtINT on CPU#13
[    1.555033] CPU13: Thermal LVT vector (0xfa) already installed
[    1.563906]   #14
[    1.576989] masked ExtINT on CPU#14
[    1.581881] CPU14: Thermal LVT vector (0xfa) already installed
[    1.590864] 
[    1.592534] .... node  #1, CPUs:    #15
[    1.609994] masked ExtINT on CPU#15
[    1.614892] CPU15: Thermal LVT vector (0xfa) already installed
[    1.701549] TSC synchronization [CPU#0 -> CPU#15]:
[    1.706900] Measured 23666 cycles TSC warp between CPUs, turning off TSC clock.
[    1.715077] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.001000]   #16
[    0.001000] masked ExtINT on CPU#16
[    0.001000] CPU16: Thermal LVT vector (0xfa) already installed
[    0.607836]   #17
[    0.607737] masked ExtINT on CPU#17
[    0.607737] CPU17: Thermal LVT vector (0xfa) already installed
[    0.630850]   #18
[    0.630731] masked ExtINT on CPU#18
[    0.630731] CPU18: Thermal LVT vector (0xfa) already installed
[    0.653775]   #19
[    0.653673] masked ExtINT on CPU#19
[    0.653673] CPU19: Thermal LVT vector (0xfa) already installed
[    0.676787]   #20
[    0.676663] masked ExtINT on CPU#20
[    0.676663] CPU20: Thermal LVT vector (0xfa) already installed
[    0.699872]   #21
[    0.699770] masked ExtINT on CPU#21
[    0.699770] CPU21: Thermal LVT vector (0xfa) already installed
[    0.722875]   #22
[    0.722757] masked ExtINT on CPU#22
[    0.722757] CPU22: Thermal LVT vector (0xfa) already installed
[    0.745756]   #23
[    0.745649] masked ExtINT on CPU#23
[    0.745649] CPU23: Thermal LVT vector (0xfa) already installed
[    0.768900]   #24
[    0.768773] masked ExtINT on CPU#24
[    0.768773] CPU24: Thermal LVT vector (0xfa) already installed
[    0.791751]   #25
[    0.791654] masked ExtINT on CPU#25
[    0.791654] CPU25: Thermal LVT vector (0xfa) already installed
[    0.814788]   #26
[    0.814662] masked ExtINT on CPU#26
[    0.814662] CPU26: Thermal LVT vector (0xfa) already installed
[    0.837749]   #27
[    0.837654] masked ExtINT on CPU#27
[    0.837654] CPU27: Thermal LVT vector (0xfa) already installed
[    0.860794]   #28
[    0.860668] masked ExtINT on CPU#28
[    0.860668] CPU28: Thermal LVT vector (0xfa) already installed
[    0.883686]   #29
[    0.883578] masked ExtINT on CPU#29
[    0.883578] CPU29: Thermal LVT vector (0xfa) already installed
[    0.906816] 
[    0.907001] .... node  #2, CPUs:    #30
[    0.906677] masked ExtINT on CPU#30
[    0.906677] CPU30: Thermal LVT vector (0xfa) already installed
[    0.992257]   #31
[    0.992164] masked ExtINT on CPU#31
[    0.992164] CPU31: Thermal LVT vector (0xfa) already installed
[    1.015839]   #32
[    1.015713] masked ExtINT on CPU#32
[    1.015713] CPU32: Thermal LVT vector (0xfa) already installed
[    1.038771]   #33
[    1.038676] masked ExtINT on CPU#33
[    1.038676] CPU33: Thermal LVT vector (0xfa) already installed
[    1.061799]   #34
[    1.061678] masked ExtINT on CPU#34
[    1.061678] CPU34: Thermal LVT vector (0xfa) already installed
[    1.084776]   #35
[    1.084673] masked ExtINT on CPU#35
[    1.084673] CPU35: Thermal LVT vector (0xfa) already installed
[    1.107891]   #36
[    1.107771] masked ExtINT on CPU#36
[    1.107771] CPU36: Thermal LVT vector (0xfa) already installed
[    1.130865]   #37
[    1.130772] masked ExtINT on CPU#37
[    1.130772] CPU37: Thermal LVT vector (0xfa) already installed
[    1.153890]   #38
[    1.153764] masked ExtINT on CPU#38
[    1.153764] CPU38: Thermal LVT vector (0xfa) already installed
[    1.176868]   #39
[    1.176773] masked ExtINT on CPU#39
[    1.176773] CPU39: Thermal LVT vector (0xfa) already installed
[    1.199790]   #40
[    1.199666] masked ExtINT on CPU#40
[    1.199666] CPU40: Thermal LVT vector (0xfa) already installed
[    1.222782]   #41
[    1.222671] masked ExtINT on CPU#41
[    1.222671] CPU41: Thermal LVT vector (0xfa) already installed
[    1.245799]   #42
[    1.245681] masked ExtINT on CPU#42
[    1.245681] CPU42: Thermal LVT vector (0xfa) already installed
[    1.268766]   #43
[    1.268674] masked ExtINT on CPU#43
[    1.268674] CPU43: Thermal LVT vector (0xfa) already installed
[    1.291804]   #44
[    1.291675] masked ExtINT on CPU#44
[    1.291675] CPU44: Thermal LVT vector (0xfa) already installed
[    1.314796] 
[    1.315001] .... node  #3, CPUs:    #45
[    1.314674] masked ExtINT on CPU#45
[    1.314674] CPU45: Thermal LVT vector (0xfa) already installed
[    1.400233]   #46
[    1.400115] masked ExtINT on CPU#46
[    1.400115] CPU46: Thermal LVT vector (0xfa) already installed
[    1.423822]   #47
[    1.423727] masked ExtINT on CPU#47
[    1.423727] CPU47: Thermal LVT vector (0xfa) already installed
[    1.446845]   #48
[    1.446726] masked ExtINT on CPU#48
[    1.446726] CPU48: Thermal LVT vector (0xfa) already installed
[    1.469826]   #49
[    1.469725] masked ExtINT on CPU#49
[    1.469725] CPU49: Thermal LVT vector (0xfa) already installed
[    1.492851]   #50
[    1.492725] masked ExtINT on CPU#50
[    1.492725] CPU50: Thermal LVT vector (0xfa) already installed
[    1.515922]   #51
[    1.515827] masked ExtINT on CPU#51
[    1.515827] CPU51: Thermal LVT vector (0xfa) already installed
[    1.538853]   #52
[    1.538727] masked ExtINT on CPU#52
[    1.538727] CPU52: Thermal LVT vector (0xfa) already installed
[    1.561817]   #53
[    1.561725] masked ExtINT on CPU#53
[    1.561725] CPU53: Thermal LVT vector (0xfa) already installed
[    1.584848]   #54
[    1.584723] masked ExtINT on CPU#54
[    1.584723] CPU54: Thermal LVT vector (0xfa) already installed
[    1.607827]   #55
[    1.607725] masked ExtINT on CPU#55
[    1.607725] CPU55: Thermal LVT vector (0xfa) already installed
[    1.630849]   #56
[    1.630731] masked ExtINT on CPU#56
[    1.630731] CPU56: Thermal LVT vector (0xfa) already installed
[    1.653725]   #57
[    1.653628] masked ExtINT on CPU#57
[    1.653628] CPU57: Thermal LVT vector (0xfa) already installed
[    1.676750]   #58
[    1.676628] masked ExtINT on CPU#58
[    1.676628] CPU58: Thermal LVT vector (0xfa) already installed
[    1.699728]   #59
[    1.699626] masked ExtINT on CPU#59
[    1.699626] CPU59: Thermal LVT vector (0xfa) already installed
[    1.722736] 
[    1.723001] .... node  #0, CPUs:    #60
[    1.722624] masked ExtINT on CPU#60
[    1.722624] CPU60: Thermal LVT vector (0xfa) already installed
[    1.748040]   #61
[    1.747889] masked ExtINT on CPU#61
[    1.747889] CPU61: Thermal LVT vector (0xfa) already installed
[    1.771957]   #62
[    1.771803] masked ExtINT on CPU#62
[    1.771803] CPU62: Thermal LVT vector (0xfa) already installed
[    1.794853]   #63
[    1.794704] masked ExtINT on CPU#63
[    1.794704] CPU63: Thermal LVT vector (0xfa) already installed
[    1.817771]   #64
[    1.817615] masked ExtINT on CPU#64
[    1.817615] CPU64: Thermal LVT vector (0xfa) already installed
[    1.840951]   #65
[    1.840800] masked ExtINT on CPU#65
[    1.840800] CPU65: Thermal LVT vector (0xfa) already installed
[    1.863953]   #66
[    1.863805] masked ExtINT on CPU#66
[    1.863805] CPU66: Thermal LVT vector (0xfa) already installed
[    1.886854]   #67
[    1.886703] masked ExtINT on CPU#67
[    1.886703] CPU67: Thermal LVT vector (0xfa) already installed
[    1.909858]   #68
[    1.909702] masked ExtINT on CPU#68
[    1.909702] CPU68: Thermal LVT vector (0xfa) already installed
[    1.932849]   #69
[    1.932705] masked ExtINT on CPU#69
[    1.932705] CPU69: Thermal LVT vector (0xfa) already installed
[    1.955863]   #70
[    1.955709] masked ExtINT on CPU#70
[    1.955709] CPU70: Thermal LVT vector (0xfa) already installed
[    1.978855]   #71
[    1.978708] masked ExtINT on CPU#71
[    1.978708] CPU71: Thermal LVT vector (0xfa) already installed
[    2.001761]   #72
[    2.001608] masked ExtINT on CPU#72
[    2.001608] CPU72: Thermal LVT vector (0xfa) already installed
[    2.024757]   #73
[    2.024605] masked ExtINT on CPU#73
[    2.024605] CPU73: Thermal LVT vector (0xfa) already installed
[    2.047760]   #74
[    2.047607] masked ExtINT on CPU#74
[    2.047607] CPU74: Thermal LVT vector (0xfa) already installed
[    2.070785] 
[    2.071003] .... node  #1, CPUs:    #75
[    2.070607] masked ExtINT on CPU#75
[    2.070607] CPU75: Thermal LVT vector (0xfa) already installed
[    2.095341]   #76
[    2.095216] masked ExtINT on CPU#76
[    2.095216] CPU76: Thermal LVT vector (0xfa) already installed
[    2.118820]   #77
[    2.118720] masked ExtINT on CPU#77
[    2.118720] CPU77: Thermal LVT vector (0xfa) already installed
[    2.141839]   #78
[    2.141721] masked ExtINT on CPU#78
[    2.141721] CPU78: Thermal LVT vector (0xfa) already installed
[    2.164816]   #79
[    2.164719] masked ExtINT on CPU#79
[    2.164719] CPU79: Thermal LVT vector (0xfa) already installed
[    2.187844]   #80
[    2.187722] masked ExtINT on CPU#80
[    2.187722] CPU80: Thermal LVT vector (0xfa) already installed
[    2.210915]   #81
[    2.210816] masked ExtINT on CPU#81
[    2.210816] CPU81: Thermal LVT vector (0xfa) already installed
[    2.233844]   #82
[    2.233720] masked ExtINT on CPU#82
[    2.233720] CPU82: Thermal LVT vector (0xfa) already installed
[    2.256812]   #83
[    2.256717] masked ExtINT on CPU#83
[    2.256717] CPU83: Thermal LVT vector (0xfa) already installed
[    2.279840]   #84
[    2.279720] masked ExtINT on CPU#84
[    2.279720] CPU84: Thermal LVT vector (0xfa) already installed
[    2.302817]   #85
[    2.302720] masked ExtINT on CPU#85
[    2.302720] CPU85: Thermal LVT vector (0xfa) already installed
[    2.325837]   #86
[    2.325718] masked ExtINT on CPU#86
[    2.325718] CPU86: Thermal LVT vector (0xfa) already installed
[    2.348722]   #87
[    2.348621] masked ExtINT on CPU#87
[    2.348621] CPU87: Thermal LVT vector (0xfa) already installed
[    2.371738]   #88
[    2.371618] masked ExtINT on CPU#88
[    2.371618] CPU88: Thermal LVT vector (0xfa) already installed
[    2.394707]   #89
[    2.394612] masked ExtINT on CPU#89
[    2.394612] CPU89: Thermal LVT vector (0xfa) already installed
[    2.417755] 
[    2.418001] .... node  #2, CPUs:    #90
[    2.417618] masked ExtINT on CPU#90
[    2.417618] CPU90: Thermal LVT vector (0xfa) already installed
[    2.442314]   #91
[    2.442207] masked ExtINT on CPU#91
[    2.442207] CPU91: Thermal LVT vector (0xfa) already installed
[    2.465838]   #92
[    2.465720] masked ExtINT on CPU#92
[    2.465720] CPU92: Thermal LVT vector (0xfa) already installed
[    2.488818]   #93
[    2.488719] masked ExtINT on CPU#93
[    2.488719] CPU93: Thermal LVT vector (0xfa) already installed
[    2.511839]   #94
[    2.511718] masked ExtINT on CPU#94
[    2.511718] CPU94: Thermal LVT vector (0xfa) already installed
[    2.534813]   #95
[    2.534717] masked ExtINT on CPU#95
[    2.534717] CPU95: Thermal LVT vector (0xfa) already installed
[    2.557943]   #96
[    2.557817] masked ExtINT on CPU#96
[    2.557817] CPU96: Thermal LVT vector (0xfa) already installed
[    2.580823]   #97
[    2.580718] masked ExtINT on CPU#97
[    2.580718] CPU97: Thermal LVT vector (0xfa) already installed
[    2.603829]   #98
[    2.603713] masked ExtINT on CPU#98
[    2.603713] CPU98: Thermal LVT vector (0xfa) already installed
[    2.626815]   #99
[    2.626716] masked ExtINT on CPU#99
[    2.626716] CPU99: Thermal LVT vector (0xfa) already installed
[    2.649844]  #100
[    2.649722] masked ExtINT on CPU#100
[    2.649722] CPU100: Thermal LVT vector (0xfa) already installed
[    2.672914]  #101
[    2.672819] masked ExtINT on CPU#101
[    2.672819] CPU101: Thermal LVT vector (0xfa) already installed
[    2.695947]  #102
[    2.695823] masked ExtINT on CPU#102
[    2.695823] CPU102: Thermal LVT vector (0xfa) already installed
[    2.718926]  #103
[    2.718821] masked ExtINT on CPU#103
[    2.718821] CPU103: Thermal LVT vector (0xfa) already installed
[    2.741936]  #104
[    2.741820] masked ExtINT on CPU#104
[    2.741820] CPU104: Thermal LVT vector (0xfa) already installed
[    2.764928] 
[    2.765001] .... node  #3, CPUs:   #105
[    2.764816] masked ExtINT on CPU#105
[    2.764816] CPU105: Thermal LVT vector (0xfa) already installed
[    2.789537]  #106
[    2.789411] masked ExtINT on CPU#106
[    2.789411] CPU106: Thermal LVT vector (0xfa) already installed
[    2.813019]  #107
[    2.812918] masked ExtINT on CPU#107
[    2.812918] CPU107: Thermal LVT vector (0xfa) already installed
[    2.837034]  #108
[    2.836918] masked ExtINT on CPU#108
[    2.836918] CPU108: Thermal LVT vector (0xfa) already installed
[    2.861015]  #109
[    2.860917] masked ExtINT on CPU#109
[    2.860917] CPU109: Thermal LVT vector (0xfa) already installed
[    2.885039]  #110
[    2.884919] masked ExtINT on CPU#110
[    2.884919] CPU110: Thermal LVT vector (0xfa) already installed
[    2.909019]  #111
[    2.908919] masked ExtINT on CPU#111
[    2.908919] CPU111: Thermal LVT vector (0xfa) already installed
[    2.933041]  #112
[    2.932918] masked ExtINT on CPU#112
[    2.932918] CPU112: Thermal LVT vector (0xfa) already installed
[    2.957017]  #113
[    2.956921] masked ExtINT on CPU#113
[    2.956921] CPU113: Thermal LVT vector (0xfa) already installed
[    2.981044]  #114
[    2.980916] masked ExtINT on CPU#114
[    2.980916] CPU114: Thermal LVT vector (0xfa) already installed
[    3.005015]  #115
[    3.004918] masked ExtINT on CPU#115
[    3.004918] CPU115: Thermal LVT vector (0xfa) already installed
[    3.028939]  #116
[    3.028818] masked ExtINT on CPU#116
[    3.028818] CPU116: Thermal LVT vector (0xfa) already installed
[    3.051920]  #117
[    3.051819] masked ExtINT on CPU#117
[    3.051819] CPU117: Thermal LVT vector (0xfa) already installed
[    3.074946]  #118
[    3.074818] masked ExtINT on CPU#118
[    3.074818] CPU118: Thermal LVT vector (0xfa) already installed
[    3.097920]  #119
[    3.097820] masked ExtINT on CPU#119
[    3.097820] CPU119: Thermal LVT vector (0xfa) already installed
[    3.120816] x86: Booted up 4 nodes, 120 CPUs
[    3.121007] smpboot: Total of 120 processors activated (671714.82 BogoMIPS)
[    3.127004] devtmpfs: initialized
[    3.128082] memory block size : 2048MB
[    3.132356] evm: security.selinux
[    3.133001] evm: security.ima
[    3.134001] evm: security.capability
[    3.135102] PM: Registering ACPI NVS region [mem 0x6504b000-0x65324fff] (2990080 bytes)
[    3.136042] PM: Registering ACPI NVS region [mem 0x65d8f000-0x66d8efff] (16777216 bytes)
[    3.137177] PM: Registering ACPI NVS region [mem 0x7accf000-0x7b6fefff] (10682368 bytes)
[    3.139814] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    3.140244] NET: Registered protocol family 16
[    3.141285] cpuidle: using governor menu
[    3.142147] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    3.143003] ACPI: bus type PCI registered
[    3.144002] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    3.145136] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    3.146002] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[    3.147410] PCI: Using configuration type 1 for base access
[    3.157444] ACPI: Added _OSI(Module Device)
[    3.158001] ACPI: Added _OSI(Processor Device)
[    3.159001] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.160001] ACPI: Added _OSI(Processor Aggregator Device)
[    3.250386] ACPI Error: Field [CPB3] at 96 exceeds Buffer [NULL] size 64 (bits) (20140724/dsopcode-236)
[    3.253001] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff881fff49dcf8), AE_AML_BUFFER_LIMIT (20140724/psparse-536)
[    3.282015] ACPI: Interpreter enabled
[    3.286011] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    3.297002] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140724/hwxface-580)
[    3.307007] ACPI: (supports S0 S1 S4 S5)
[    3.311002] ACPI: Using IOAPIC for interrupt routing
[    3.317046] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    3.358461] ACPI: PCI Root Bridge [UNC3] (domain 0000 [bus ff])
[    3.365006] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    3.374004] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    3.382039] PCI host bridge to bus 0000:ff
[    3.386003] pci_bus 0000:ff: root bus resource [bus ff]
[    3.392010] pci 0000:ff:08.0: [8086:0e80] type 00 class 0x088000
[    3.399056] pci 0000:ff:08.2: [8086:0e32] type 00 class 0x110100
[    3.405049] pci 0000:ff:08.3: [8086:0e83] type 00 class 0x088000
[    3.412059] pci 0000:ff:08.4: [8086:0e84] type 00 class 0x088000
[    3.419061] pci 0000:ff:09.0: [8086:0e90] type 00 class 0x088000
[    3.426043] pci 0000:ff:09.2: [8086:0e33] type 00 class 0x110100
[    3.432045] pci 0000:ff:09.3: [8086:0e93] type 00 class 0x088000
[    3.439056] pci 0000:ff:09.4: [8086:0e94] type 00 class 0x088000
[    3.446067] pci 0000:ff:0a.0: [8086:0ec0] type 00 class 0x088000
[    3.453044] pci 0000:ff:0a.1: [8086:0ec1] type 00 class 0x088000
[    3.459049] pci 0000:ff:0a.2: [8086:0ec2] type 00 class 0x088000
[    3.466037] pci 0000:ff:0a.3: [8086:0ec3] type 00 class 0x088000
[    3.473046] pci 0000:ff:0b.0: [8086:0e1e] type 00 class 0x088000
[    3.480049] pci 0000:ff:0b.3: [8086:0e1f] type 00 class 0x088000
[    3.486038] pci 0000:ff:0c.0: [8086:0ee0] type 00 class 0x088000
[    3.493043] pci 0000:ff:0c.1: [8086:0ee2] type 00 class 0x088000
[    3.500038] pci 0000:ff:0c.2: [8086:0ee4] type 00 class 0x088000
[    3.507044] pci 0000:ff:0c.3: [8086:0ee6] type 00 class 0x088000
[    3.513044] pci 0000:ff:0c.4: [8086:0ee8] type 00 class 0x088000
[    3.520045] pci 0000:ff:0c.5: [8086:0eea] type 00 class 0x088000
[    3.527035] pci 0000:ff:0c.6: [8086:0eec] type 00 class 0x088000
[    3.534034] pci 0000:ff:0c.7: [8086:0eee] type 00 class 0x088000
[    3.540042] pci 0000:ff:0d.0: [8086:0ee1] type 00 class 0x088000
[    3.547041] pci 0000:ff:0d.1: [8086:0ee3] type 00 class 0x088000
[    3.554044] pci 0000:ff:0d.2: [8086:0ee5] type 00 class 0x088000
[    3.560038] pci 0000:ff:0d.3: [8086:0ee7] type 00 class 0x088000
[    3.567040] pci 0000:ff:0d.4: [8086:0ee9] type 00 class 0x088000
[    3.574040] pci 0000:ff:0d.5: [8086:0eeb] type 00 class 0x088000
[    3.581041] pci 0000:ff:0d.6: [8086:0eed] type 00 class 0x088000
[    3.587044] pci 0000:ff:0e.0: [8086:0ea0] type 00 class 0x088000
[    3.594041] pci 0000:ff:0e.1: [8086:0e30] type 00 class 0x110100
[    3.601053] pci 0000:ff:0f.0: [8086:0ea8] type 00 class 0x088000
[    3.608058] pci 0000:ff:0f.1: [8086:0e71] type 00 class 0x088000
[    3.614057] pci 0000:ff:0f.2: [8086:0eaa] type 00 class 0x088000
[    3.621057] pci 0000:ff:0f.3: [8086:0eab] type 00 class 0x088000
[    3.628052] pci 0000:ff:0f.4: [8086:0eac] type 00 class 0x088000
[    3.635052] pci 0000:ff:0f.5: [8086:0ead] type 00 class 0x088000
[    3.641051] pci 0000:ff:10.0: [8086:0eb0] type 00 class 0x088000
[    3.648056] pci 0000:ff:10.1: [8086:0eb1] type 00 class 0x088000
[    3.655056] pci 0000:ff:10.2: [8086:0eb2] type 00 class 0x088000
[    3.662060] pci 0000:ff:10.3: [8086:0eb3] type 00 class 0x088000
[    3.668053] pci 0000:ff:10.4: [8086:0eb4] type 00 class 0x088000
[    3.675054] pci 0000:ff:10.5: [8086:0eb5] type 00 class 0x088000
[    3.682050] pci 0000:ff:10.6: [8086:0eb6] type 00 class 0x088000
[    3.689061] pci 0000:ff:10.7: [8086:0eb7] type 00 class 0x088000
[    3.695052] pci 0000:ff:11.0: [8086:0ef8] type 00 class 0x088000
[    3.702059] pci 0000:ff:13.0: [8086:0e1d] type 00 class 0x088000
[    3.709041] pci 0000:ff:13.1: [8086:0e34] type 00 class 0x110100
[    3.716043] pci 0000:ff:13.4: [8086:0e81] type 00 class 0x088000
[    3.722042] pci 0000:ff:13.5: [8086:0e36] type 00 class 0x110100
[    3.729042] pci 0000:ff:13.6: [8086:0e37] type 00 class 0x110100
[    3.736045] pci 0000:ff:16.0: [8086:0ec8] type 00 class 0x088000
[    3.742038] pci 0000:ff:16.1: [8086:0ec9] type 00 class 0x088000
[    3.749046] pci 0000:ff:16.2: [8086:0eca] type 00 class 0x088000
[    3.756043] pci 0000:ff:18.0: [8086:0e40] type 00 class 0x088000
[    3.763046] pci 0000:ff:18.2: [8086:0e3a] type 00 class 0x110100
[    3.769052] pci 0000:ff:18.3: [8086:0e43] type 00 class 0x088000
[    3.776056] pci 0000:ff:18.4: [8086:0e44] type 00 class 0x088000
[    3.783062] pci 0000:ff:1c.0: [8086:0e60] type 00 class 0x088000
[    3.790047] pci 0000:ff:1c.1: [8086:0e38] type 00 class 0x110100
[    3.796046] pci 0000:ff:1d.0: [8086:0e68] type 00 class 0x088000
[    3.803050] pci 0000:ff:1d.1: [8086:0e79] type 00 class 0x088000
[    3.810050] pci 0000:ff:1d.2: [8086:0e6a] type 00 class 0x088000
[    3.817060] pci 0000:ff:1d.3: [8086:0e6b] type 00 class 0x088000
[    3.823059] pci 0000:ff:1d.4: [8086:0e6c] type 00 class 0x088000
[    3.830057] pci 0000:ff:1d.5: [8086:0e6d] type 00 class 0x088000
[    3.837061] pci 0000:ff:1e.0: [8086:0ef0] type 00 class 0x088000
[    3.844053] pci 0000:ff:1e.1: [8086:0ef1] type 00 class 0x088000
[    3.850052] pci 0000:ff:1e.2: [8086:0ef2] type 00 class 0x088000
[    3.857063] pci 0000:ff:1e.3: [8086:0ef3] type 00 class 0x088000
[    3.864051] pci 0000:ff:1e.4: [8086:0ef4] type 00 class 0x088000
[    3.871055] pci 0000:ff:1e.5: [8086:0ef5] type 00 class 0x088000
[    3.877059] pci 0000:ff:1e.6: [8086:0ef6] type 00 class 0x088000
[    3.884058] pci 0000:ff:1e.7: [8086:0ef7] type 00 class 0x088000
[    3.891064] pci 0000:ff:1f.0: [8086:0ed8] type 00 class 0x088000
[    3.898057] pci 0000:ff:1f.1: [8086:0ed9] type 00 class 0x088000
[    3.904063] pci 0000:ff:1f.4: [8086:0edc] type 00 class 0x088000
[    3.911058] pci 0000:ff:1f.5: [8086:0edd] type 00 class 0x088000
[    3.918053] pci 0000:ff:1f.6: [8086:0ede] type 00 class 0x088000
[    3.925051] pci 0000:ff:1f.7: [8086:0edf] type 00 class 0x088000
[    3.931095] ACPI: PCI Root Bridge [UNC2] (domain 0000 [bus bf])
[    3.938003] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    3.947003] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    3.955026] PCI host bridge to bus 0000:bf
[    3.959002] pci_bus 0000:bf: root bus resource [bus bf]
[    3.965007] pci 0000:bf:08.0: [8086:0e80] type 00 class 0x088000
[    3.972046] pci 0000:bf:08.2: [8086:0e32] type 00 class 0x110100
[    3.978047] pci 0000:bf:08.3: [8086:0e83] type 00 class 0x088000
[    3.985056] pci 0000:bf:08.4: [8086:0e84] type 00 class 0x088000
[    3.992059] pci 0000:bf:09.0: [8086:0e90] type 00 class 0x088000
[    3.999040] pci 0000:bf:09.2: [8086:0e33] type 00 class 0x110100
[    4.005043] pci 0000:bf:09.3: [8086:0e93] type 00 class 0x088000
[    4.012054] pci 0000:bf:09.4: [8086:0e94] type 00 class 0x088000
[    4.019062] pci 0000:bf:0a.0: [8086:0ec0] type 00 class 0x088000
[    4.026045] pci 0000:bf:0a.1: [8086:0ec1] type 00 class 0x088000
[    4.032037] pci 0000:bf:0a.2: [8086:0ec2] type 00 class 0x088000
[    4.039039] pci 0000:bf:0a.3: [8086:0ec3] type 00 class 0x088000
[    4.046041] pci 0000:bf:0b.0: [8086:0e1e] type 00 class 0x088000
[    4.053044] pci 0000:bf:0b.3: [8086:0e1f] type 00 class 0x088000
[    4.059042] pci 0000:bf:0c.0: [8086:0ee0] type 00 class 0x088000
[    4.066038] pci 0000:bf:0c.1: [8086:0ee2] type 00 class 0x088000
[    4.073045] pci 0000:bf:0c.2: [8086:0ee4] type 00 class 0x088000
[    4.079034] pci 0000:bf:0c.3: [8086:0ee6] type 00 class 0x088000
[    4.086040] pci 0000:bf:0c.4: [8086:0ee8] type 00 class 0x088000
[    4.093036] pci 0000:bf:0c.5: [8086:0eea] type 00 class 0x088000
[    4.100044] pci 0000:bf:0c.6: [8086:0eec] type 00 class 0x088000
[    4.106041] pci 0000:bf:0c.7: [8086:0eee] type 00 class 0x088000
[    4.113037] pci 0000:bf:0d.0: [8086:0ee1] type 00 class 0x088000
[    4.120041] pci 0000:bf:0d.1: [8086:0ee3] type 00 class 0x088000
[    4.127042] pci 0000:bf:0d.2: [8086:0ee5] type 00 class 0x088000
[    4.133042] pci 0000:bf:0d.3: [8086:0ee7] type 00 class 0x088000
[    4.140042] pci 0000:bf:0d.4: [8086:0ee9] type 00 class 0x088000
[    4.147037] pci 0000:bf:0d.5: [8086:0eeb] type 00 class 0x088000
[    4.154034] pci 0000:bf:0d.6: [8086:0eed] type 00 class 0x088000
[    4.160045] pci 0000:bf:0e.0: [8086:0ea0] type 00 class 0x088000
[    4.167041] pci 0000:bf:0e.1: [8086:0e30] type 00 class 0x110100
[    4.174046] pci 0000:bf:0f.0: [8086:0ea8] type 00 class 0x088000
[    4.180057] pci 0000:bf:0f.1: [8086:0e71] type 00 class 0x088000
[    4.187056] pci 0000:bf:0f.2: [8086:0eaa] type 00 class 0x088000
[    4.194059] pci 0000:bf:0f.3: [8086:0eab] type 00 class 0x088000
[    4.201056] pci 0000:bf:0f.4: [8086:0eac] type 00 class 0x088000
[    4.207056] pci 0000:bf:0f.5: [8086:0ead] type 00 class 0x088000
[    4.214055] pci 0000:bf:10.0: [8086:0eb0] type 00 class 0x088000
[    4.221058] pci 0000:bf:10.1: [8086:0eb1] type 00 class 0x088000
[    4.228055] pci 0000:bf:10.2: [8086:0eb2] type 00 class 0x088000
[    4.234064] pci 0000:bf:10.3: [8086:0eb3] type 00 class 0x088000
[    4.241057] pci 0000:bf:10.4: [8086:0eb4] type 00 class 0x088000
[    4.248055] pci 0000:bf:10.5: [8086:0eb5] type 00 class 0x088000
[    4.255060] pci 0000:bf:10.6: [8086:0eb6] type 00 class 0x088000
[    4.261051] pci 0000:bf:10.7: [8086:0eb7] type 00 class 0x088000
[    4.268055] pci 0000:bf:11.0: [8086:0ef8] type 00 class 0x088000
[    4.275055] pci 0000:bf:13.0: [8086:0e1d] type 00 class 0x088000
[    4.282042] pci 0000:bf:13.1: [8086:0e34] type 00 class 0x110100
[    4.288045] pci 0000:bf:13.4: [8086:0e81] type 00 class 0x088000
[    4.295040] pci 0000:bf:13.5: [8086:0e36] type 00 class 0x110100
[    4.302046] pci 0000:bf:13.6: [8086:0e37] type 00 class 0x110100
[    4.309044] pci 0000:bf:16.0: [8086:0ec8] type 00 class 0x088000
[    4.315042] pci 0000:bf:16.1: [8086:0ec9] type 00 class 0x088000
[    4.322037] pci 0000:bf:16.2: [8086:0eca] type 00 class 0x088000
[    4.329051] pci 0000:bf:18.0: [8086:0e40] type 00 class 0x088000
[    4.336047] pci 0000:bf:18.2: [8086:0e3a] type 00 class 0x110100
[    4.342045] pci 0000:bf:18.3: [8086:0e43] type 00 class 0x088000
[    4.349058] pci 0000:bf:18.4: [8086:0e44] type 00 class 0x088000
[    4.356055] pci 0000:bf:1c.0: [8086:0e60] type 00 class 0x088000
[    4.363049] pci 0000:bf:1c.1: [8086:0e38] type 00 class 0x110100
[    4.369052] pci 0000:bf:1d.0: [8086:0e68] type 00 class 0x088000
[    4.376053] pci 0000:bf:1d.1: [8086:0e79] type 00 class 0x088000
[    4.383051] pci 0000:bf:1d.2: [8086:0e6a] type 00 class 0x088000
[    4.389057] pci 0000:bf:1d.3: [8086:0e6b] type 00 class 0x088000
[    4.396051] pci 0000:bf:1d.4: [8086:0e6c] type 00 class 0x088000
[    4.403062] pci 0000:bf:1d.5: [8086:0e6d] type 00 class 0x088000
[    4.410055] pci 0000:bf:1e.0: [8086:0ef0] type 00 class 0x088000
[    4.416051] pci 0000:bf:1e.1: [8086:0ef1] type 00 class 0x088000
[    4.423060] pci 0000:bf:1e.2: [8086:0ef2] type 00 class 0x088000
[    4.430057] pci 0000:bf:1e.3: [8086:0ef3] type 00 class 0x088000
[    4.437053] pci 0000:bf:1e.4: [8086:0ef4] type 00 class 0x088000
[    4.443058] pci 0000:bf:1e.5: [8086:0ef5] type 00 class 0x088000
[    4.450063] pci 0000:bf:1e.6: [8086:0ef6] type 00 class 0x088000
[    4.457056] pci 0000:bf:1e.7: [8086:0ef7] type 00 class 0x088000
[    4.464055] pci 0000:bf:1f.0: [8086:0ed8] type 00 class 0x088000
[    4.470055] pci 0000:bf:1f.1: [8086:0ed9] type 00 class 0x088000
[    4.477058] pci 0000:bf:1f.4: [8086:0edc] type 00 class 0x088000
[    4.484060] pci 0000:bf:1f.5: [8086:0edd] type 00 class 0x088000
[    4.491057] pci 0000:bf:1f.6: [8086:0ede] type 00 class 0x088000
[    4.497057] pci 0000:bf:1f.7: [8086:0edf] type 00 class 0x088000
[    4.504092] ACPI: PCI Root Bridge [UNC1] (domain 0000 [bus 7f])
[    4.511003] acpi PNP0A03:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    4.520003] acpi PNP0A03:02: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    4.527023] PCI host bridge to bus 0000:7f
[    4.532002] pci_bus 0000:7f: root bus resource [bus 7f]
[    4.538007] pci 0000:7f:08.0: [8086:0e80] type 00 class 0x088000
[    4.544046] pci 0000:7f:08.2: [8086:0e32] type 00 class 0x110100
[    4.551043] pci 0000:7f:08.3: [8086:0e83] type 00 class 0x088000
[    4.558054] pci 0000:7f:08.4: [8086:0e84] type 00 class 0x088000
[    4.565059] pci 0000:7f:09.0: [8086:0e90] type 00 class 0x088000
[    4.571040] pci 0000:7f:09.2: [8086:0e33] type 00 class 0x110100
[    4.578042] pci 0000:7f:09.3: [8086:0e93] type 00 class 0x088000
[    4.585056] pci 0000:7f:09.4: [8086:0e94] type 00 class 0x088000
[    4.592054] pci 0000:7f:0a.0: [8086:0ec0] type 00 class 0x088000
[    4.598035] pci 0000:7f:0a.1: [8086:0ec1] type 00 class 0x088000
[    4.605043] pci 0000:7f:0a.2: [8086:0ec2] type 00 class 0x088000
[    4.612041] pci 0000:7f:0a.3: [8086:0ec3] type 00 class 0x088000
[    4.619042] pci 0000:7f:0b.0: [8086:0e1e] type 00 class 0x088000
[    4.625036] pci 0000:7f:0b.3: [8086:0e1f] type 00 class 0x088000
[    4.632038] pci 0000:7f:0c.0: [8086:0ee0] type 00 class 0x088000
[    4.639041] pci 0000:7f:0c.1: [8086:0ee2] type 00 class 0x088000
[    4.645046] pci 0000:7f:0c.2: [8086:0ee4] type 00 class 0x088000
[    4.652042] pci 0000:7f:0c.3: [8086:0ee6] type 00 class 0x088000
[    4.659041] pci 0000:7f:0c.4: [8086:0ee8] type 00 class 0x088000
[    4.666041] pci 0000:7f:0c.5: [8086:0eea] type 00 class 0x088000
[    4.672037] pci 0000:7f:0c.6: [8086:0eec] type 00 class 0x088000
[    4.679040] pci 0000:7f:0c.7: [8086:0eee] type 00 class 0x088000
[    4.686039] pci 0000:7f:0d.0: [8086:0ee1] type 00 class 0x088000
[    4.693042] pci 0000:7f:0d.1: [8086:0ee3] type 00 class 0x088000
[    4.699039] pci 0000:7f:0d.2: [8086:0ee5] type 00 class 0x088000
[    4.706038] pci 0000:7f:0d.3: [8086:0ee7] type 00 class 0x088000
[    4.713040] pci 0000:7f:0d.4: [8086:0ee9] type 00 class 0x088000
[    4.720038] pci 0000:7f:0d.5: [8086:0eeb] type 00 class 0x088000
[    4.726040] pci 0000:7f:0d.6: [8086:0eed] type 00 class 0x088000
[    4.733041] pci 0000:7f:0e.0: [8086:0ea0] type 00 class 0x088000
[    4.740041] pci 0000:7f:0e.1: [8086:0e30] type 00 class 0x110100
[    4.746045] pci 0000:7f:0f.0: [8086:0ea8] type 00 class 0x088000
[    4.753061] pci 0000:7f:0f.1: [8086:0e71] type 00 class 0x088000
[    4.760055] pci 0000:7f:0f.2: [8086:0eaa] type 00 class 0x088000
[    4.767052] pci 0000:7f:0f.3: [8086:0eab] type 00 class 0x088000
[    4.773057] pci 0000:7f:0f.4: [8086:0eac] type 00 class 0x088000
[    4.780054] pci 0000:7f:0f.5: [8086:0ead] type 00 class 0x088000
[    4.787060] pci 0000:7f:10.0: [8086:0eb0] type 00 class 0x088000
[    4.794050] pci 0000:7f:10.1: [8086:0eb1] type 00 class 0x088000
[    4.800057] pci 0000:7f:10.2: [8086:0eb2] type 00 class 0x088000
[    4.807051] pci 0000:7f:10.3: [8086:0eb3] type 00 class 0x088000
[    4.814053] pci 0000:7f:10.4: [8086:0eb4] type 00 class 0x088000
[    4.821053] pci 0000:7f:10.5: [8086:0eb5] type 00 class 0x088000
[    4.827053] pci 0000:7f:10.6: [8086:0eb6] type 00 class 0x088000
[    4.834052] pci 0000:7f:10.7: [8086:0eb7] type 00 class 0x088000
[    4.841049] pci 0000:7f:11.0: [8086:0ef8] type 00 class 0x088000
[    4.848056] pci 0000:7f:13.0: [8086:0e1d] type 00 class 0x088000
[    4.854037] pci 0000:7f:13.1: [8086:0e34] type 00 class 0x110100
[    4.861041] pci 0000:7f:13.4: [8086:0e81] type 00 class 0x088000
[    4.868038] pci 0000:7f:13.5: [8086:0e36] type 00 class 0x110100
[    4.875041] pci 0000:7f:13.6: [8086:0e37] type 00 class 0x110100
[    4.881041] pci 0000:7f:16.0: [8086:0ec8] type 00 class 0x088000
[    4.888042] pci 0000:7f:16.1: [8086:0ec9] type 00 class 0x088000
[    4.895045] pci 0000:7f:16.2: [8086:0eca] type 00 class 0x088000
[    4.901048] pci 0000:7f:18.0: [8086:0e40] type 00 class 0x088000
[    4.908042] pci 0000:7f:18.2: [8086:0e3a] type 00 class 0x110100
[    4.915047] pci 0000:7f:18.3: [8086:0e43] type 00 class 0x088000
[    4.922058] pci 0000:7f:18.4: [8086:0e44] type 00 class 0x088000
[    4.928057] pci 0000:7f:1c.0: [8086:0e60] type 00 class 0x088000
[    4.935045] pci 0000:7f:1c.1: [8086:0e38] type 00 class 0x110100
[    4.942051] pci 0000:7f:1d.0: [8086:0e68] type 00 class 0x088000
[    4.949056] pci 0000:7f:1d.1: [8086:0e79] type 00 class 0x088000
[    4.955056] pci 0000:7f:1d.2: [8086:0e6a] type 00 class 0x088000
[    4.962053] pci 0000:7f:1d.3: [8086:0e6b] type 00 class 0x088000
[    4.969057] pci 0000:7f:1d.4: [8086:0e6c] type 00 class 0x088000
[    4.976057] pci 0000:7f:1d.5: [8086:0e6d] type 00 class 0x088000
[    4.982061] pci 0000:7f:1e.0: [8086:0ef0] type 00 class 0x088000
[    4.989053] pci 0000:7f:1e.1: [8086:0ef1] type 00 class 0x088000
[    4.996060] pci 0000:7f:1e.2: [8086:0ef2] type 00 class 0x088000
[    5.003063] pci 0000:7f:1e.3: [8086:0ef3] type 00 class 0x088000
[    5.009052] pci 0000:7f:1e.4: [8086:0ef4] type 00 class 0x088000
[    5.016058] pci 0000:7f:1e.5: [8086:0ef5] type 00 class 0x088000
[    5.023062] pci 0000:7f:1e.6: [8086:0ef6] type 00 class 0x088000
[    5.030059] pci 0000:7f:1e.7: [8086:0ef7] type 00 class 0x088000
[    5.036063] pci 0000:7f:1f.0: [8086:0ed8] type 00 class 0x088000
[    5.043059] pci 0000:7f:1f.1: [8086:0ed9] type 00 class 0x088000
[    5.050059] pci 0000:7f:1f.4: [8086:0edc] type 00 class 0x088000
[    5.057057] pci 0000:7f:1f.5: [8086:0edd] type 00 class 0x088000
[    5.063052] pci 0000:7f:1f.6: [8086:0ede] type 00 class 0x088000
[    5.070055] pci 0000:7f:1f.7: [8086:0edf] type 00 class 0x088000
[    5.077097] ACPI: PCI Root Bridge [UNC0] (domain 0000 [bus 3f])
[    5.084003] acpi PNP0A03:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.093005] acpi PNP0A03:03: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    5.100028] PCI host bridge to bus 0000:3f
[    5.105002] pci_bus 0000:3f: root bus resource [bus 3f]
[    5.110006] pci 0000:3f:08.0: [8086:0e80] type 00 class 0x088000
[    5.117047] pci 0000:3f:08.2: [8086:0e32] type 00 class 0x110100
[    5.124042] pci 0000:3f:08.3: [8086:0e83] type 00 class 0x088000
[    5.131052] pci 0000:3f:08.4: [8086:0e84] type 00 class 0x088000
[    5.137061] pci 0000:3f:09.0: [8086:0e90] type 00 class 0x088000
[    5.144042] pci 0000:3f:09.2: [8086:0e33] type 00 class 0x110100
[    5.151045] pci 0000:3f:09.3: [8086:0e93] type 00 class 0x088000
[    5.157053] pci 0000:3f:09.4: [8086:0e94] type 00 class 0x088000
[    5.164057] pci 0000:3f:0a.0: [8086:0ec0] type 00 class 0x088000
[    5.171039] pci 0000:3f:0a.1: [8086:0ec1] type 00 class 0x088000
[    5.178035] pci 0000:3f:0a.2: [8086:0ec2] type 00 class 0x088000
[    5.184042] pci 0000:3f:0a.3: [8086:0ec3] type 00 class 0x088000
[    5.191043] pci 0000:3f:0b.0: [8086:0e1e] type 00 class 0x088000
[    5.198039] pci 0000:3f:0b.3: [8086:0e1f] type 00 class 0x088000
[    5.205040] pci 0000:3f:0c.0: [8086:0ee0] type 00 class 0x088000
[    5.211044] pci 0000:3f:0c.1: [8086:0ee2] type 00 class 0x088000
[    5.218047] pci 0000:3f:0c.2: [8086:0ee4] type 00 class 0x088000
[    5.225043] pci 0000:3f:0c.3: [8086:0ee6] type 00 class 0x088000
[    5.232039] pci 0000:3f:0c.4: [8086:0ee8] type 00 class 0x088000
[    5.238041] pci 0000:3f:0c.5: [8086:0eea] type 00 class 0x088000
[    5.245041] pci 0000:3f:0c.6: [8086:0eec] type 00 class 0x088000
[    5.252038] pci 0000:3f:0c.7: [8086:0eee] type 00 class 0x088000
[    5.258042] pci 0000:3f:0d.0: [8086:0ee1] type 00 class 0x088000
[    5.265039] pci 0000:3f:0d.1: [8086:0ee3] type 00 class 0x088000
[    5.272046] pci 0000:3f:0d.2: [8086:0ee5] type 00 class 0x088000
[    5.279043] pci 0000:3f:0d.3: [8086:0ee7] type 00 class 0x088000
[    5.285042] pci 0000:3f:0d.4: [8086:0ee9] type 00 class 0x088000
[    5.292032] pci 0000:3f:0d.5: [8086:0eeb] type 00 class 0x088000
[    5.299040] pci 0000:3f:0d.6: [8086:0eed] type 00 class 0x088000
[    5.306040] pci 0000:3f:0e.0: [8086:0ea0] type 00 class 0x088000
[    5.312043] pci 0000:3f:0e.1: [8086:0e30] type 00 class 0x110100
[    5.319047] pci 0000:3f:0f.0: [8086:0ea8] type 00 class 0x088000
[    5.326050] pci 0000:3f:0f.1: [8086:0e71] type 00 class 0x088000
[    5.333059] pci 0000:3f:0f.2: [8086:0eaa] type 00 class 0x088000
[    5.339054] pci 0000:3f:0f.3: [8086:0eab] type 00 class 0x088000
[    5.346057] pci 0000:3f:0f.4: [8086:0eac] type 00 class 0x088000
[    5.353052] pci 0000:3f:0f.5: [8086:0ead] type 00 class 0x088000
[    5.359057] pci 0000:3f:10.0: [8086:0eb0] type 00 class 0x088000
[    5.366058] pci 0000:3f:10.1: [8086:0eb1] type 00 class 0x088000
[    5.373055] pci 0000:3f:10.2: [8086:0eb2] type 00 class 0x088000
[    5.380056] pci 0000:3f:10.3: [8086:0eb3] type 00 class 0x088000
[    5.386050] pci 0000:3f:10.4: [8086:0eb4] type 00 class 0x088000
[    5.393052] pci 0000:3f:10.5: [8086:0eb5] type 00 class 0x088000
[    5.400049] pci 0000:3f:10.6: [8086:0eb6] type 00 class 0x088000
[    5.407052] pci 0000:3f:10.7: [8086:0eb7] type 00 class 0x088000
[    5.413052] pci 0000:3f:11.0: [8086:0ef8] type 00 class 0x088000
[    5.420049] pci 0000:3f:13.0: [8086:0e1d] type 00 class 0x088000
[    5.427038] pci 0000:3f:13.1: [8086:0e34] type 00 class 0x110100
[    5.434039] pci 0000:3f:13.4: [8086:0e81] type 00 class 0x088000
[    5.440039] pci 0000:3f:13.5: [8086:0e36] type 00 class 0x110100
[    5.447036] pci 0000:3f:13.6: [8086:0e37] type 00 class 0x110100
[    5.454040] pci 0000:3f:16.0: [8086:0ec8] type 00 class 0x088000
[    5.461039] pci 0000:3f:16.1: [8086:0ec9] type 00 class 0x088000
[    5.467037] pci 0000:3f:16.2: [8086:0eca] type 00 class 0x088000
[    5.474041] pci 0000:3f:18.0: [8086:0e40] type 00 class 0x088000
[    5.481040] pci 0000:3f:18.2: [8086:0e3a] type 00 class 0x110100
[    5.487048] pci 0000:3f:18.3: [8086:0e43] type 00 class 0x088000
[    5.494053] pci 0000:3f:18.4: [8086:0e44] type 00 class 0x088000
[    5.501060] pci 0000:3f:1c.0: [8086:0e60] type 00 class 0x088000
[    5.508043] pci 0000:3f:1c.1: [8086:0e38] type 00 class 0x110100
[    5.514044] pci 0000:3f:1d.0: [8086:0e68] type 00 class 0x088000
[    5.521048] pci 0000:3f:1d.1: [8086:0e79] type 00 class 0x088000
[    5.528048] pci 0000:3f:1d.2: [8086:0e6a] type 00 class 0x088000
[    5.535056] pci 0000:3f:1d.3: [8086:0e6b] type 00 class 0x088000
[    5.541054] pci 0000:3f:1d.4: [8086:0e6c] type 00 class 0x088000
[    5.548052] pci 0000:3f:1d.5: [8086:0e6d] type 00 class 0x088000
[    5.555054] pci 0000:3f:1e.0: [8086:0ef0] type 00 class 0x088000
[    5.562049] pci 0000:3f:1e.1: [8086:0ef1] type 00 class 0x088000
[    5.568047] pci 0000:3f:1e.2: [8086:0ef2] type 00 class 0x088000
[    5.575056] pci 0000:3f:1e.3: [8086:0ef3] type 00 class 0x088000
[    5.582050] pci 0000:3f:1e.4: [8086:0ef4] type 00 class 0x088000
[    5.589054] pci 0000:3f:1e.5: [8086:0ef5] type 00 class 0x088000
[    5.595053] pci 0000:3f:1e.6: [8086:0ef6] type 00 class 0x088000
[    5.602048] pci 0000:3f:1e.7: [8086:0ef7] type 00 class 0x088000
[    5.609053] pci 0000:3f:1f.0: [8086:0ed8] type 00 class 0x088000
[    5.615053] pci 0000:3f:1f.1: [8086:0ed9] type 00 class 0x088000
[    5.622061] pci 0000:3f:1f.4: [8086:0edc] type 00 class 0x088000
[    5.629055] pci 0000:3f:1f.5: [8086:0edd] type 00 class 0x088000
[    5.636054] pci 0000:3f:1f.6: [8086:0ede] type 00 class 0x088000
[    5.642054] pci 0000:3f:1f.7: [8086:0edf] type 00 class 0x088000
[    5.656435] Section-unaligned hotplug range: start 0x1000000, size 0x7b000000
[    5.707519] ACPI: PCI Root Bridge [IIO0] (domain 0000 [bus 00-3e])
[    5.714004] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.723560] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    5.733242] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[    5.747206] PCI host bridge to bus 0000:00
[    5.752002] pci_bus 0000:00: root bus resource [bus 00-3e]
[    5.758002] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    5.765001] pci_bus 0000:00: root bus resource [io  0x1000-0x3fff]
[    5.771001] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    5.779004] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
[    5.787001] pci_bus 0000:00: root bus resource [mem 0x90000000-0xabffbfff]
[    5.794001] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x381fffffffff]
[    5.803009] pci 0000:00:00.0: [8086:0e00] type 00 class 0x060000
[    5.810055] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    5.816086] pci 0000:00:02.0: [8086:0e04] type 01 class 0x060400
[    5.823069] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    5.830051] pci 0000:00:02.0: System wakeup disabled by ACPI
[    5.836038] pci 0000:00:03.0: [8086:0e08] type 01 class 0x060400
[    5.843065] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    5.850049] pci 0000:00:03.0: System wakeup disabled by ACPI
[    5.856042] pci 0000:00:03.2: [8086:0e0a] type 01 class 0x060400
[    5.863068] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    5.870048] pci 0000:00:03.2: System wakeup disabled by ACPI
[    5.876036] pci 0000:00:03.3: [8086:0e0b] type 01 class 0x060400
[    5.883067] pci 0000:00:03.3: PME# supported from D0 D3hot D3cold
[    5.890048] pci 0000:00:03.3: System wakeup disabled by ACPI
[    5.896040] pci 0000:00:05.0: [8086:0e28] type 00 class 0x088000
[    5.903111] pci 0000:00:05.1: [8086:0e29] type 00 class 0x088000
[    5.910127] pci 0000:00:05.2: [8086:0e2a] type 00 class 0x088000
[    5.916109] pci 0000:00:05.4: [8086:0e2c] type 00 class 0x080020
[    5.923011] pci 0000:00:05.4: reg 0x10: [mem 0x93406000-0x93406fff]
[    5.930134] pci 0000:00:11.0: [8086:1d3e] type 01 class 0x060400
[    5.937095] pci 0000:00:11.0: PME# supported from D0 D3hot D3cold
[    5.944095] pci 0000:00:1a.0: [8086:1d2d] type 00 class 0x0c0320
[    5.951019] pci 0000:00:1a.0: reg 0x10: [mem 0x93402000-0x934023ff]
[    5.958083] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    5.965085] pci 0000:00:1c.0: [8086:1d10] type 01 class 0x060400
[    5.971138] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    5.978061] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    5.985037] pci 0000:00:1c.7: [8086:1d1e] type 01 class 0x060400
[    5.991076] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    5.998050] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    6.005041] pci 0000:00:1d.0: [8086:1d26] type 00 class 0x0c0320
[    6.011019] pci 0000:00:1d.0: reg 0x10: [mem 0x93401000-0x934013ff]
[    6.018083] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    6.025077] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    6.032081] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    6.038038] pci 0000:00:1f.0: [8086:1d41] type 00 class 0x060100
[    6.045172] pci 0000:00:1f.2: [8086:1d02] type 00 class 0x010601
[    6.052016] pci 0000:00:1f.2: reg 0x10: [io  0x2058-0x205f]
[    6.058007] pci 0000:00:1f.2: reg 0x14: [io  0x207c-0x207f]
[    6.064006] pci 0000:00:1f.2: reg 0x18: [io  0x2040-0x2047]
[    6.071007] pci 0000:00:1f.2: reg 0x1c: [io  0x2048-0x204b]
[    6.077007] pci 0000:00:1f.2: reg 0x20: [io  0x2020-0x203f]
[    6.083007] pci 0000:00:1f.2: reg 0x24: [mem 0x93400000-0x934007ff]
[    6.090040] pci 0000:00:1f.2: PME# supported from D3hot
[    6.096070] pci 0000:00:1f.3: [8086:1d22] type 00 class 0x0c0500
[    6.103014] pci 0000:00:1f.3: reg 0x10: [mem 0x381ffff00000-0x381ffff000ff 64bit]
[    6.111018] pci 0000:00:1f.3: reg 0x20: [io  0x2000-0x201f]
[    6.117219] acpiphp: Slot [8] registered
[    6.122022] pci 0000:01:00.0: [1000:0087] type 00 class 0x010700
[    6.129008] pci 0000:01:00.0: reg 0x10: [io  0x1000-0x10ff]
[    6.135007] pci 0000:01:00.0: reg 0x14: [mem 0x93340000-0x9334ffff 64bit]
[    6.142007] pci 0000:01:00.0: reg 0x1c: [mem 0x93300000-0x9333ffff 64bit]
[    6.150008] pci 0000:01:00.0: reg 0x30: [mem 0xfff00000-0xffffffff pref]
[    6.157029] pci 0000:01:00.0: supports D1 D2
[    6.164010] pci 0000:00:02.0: PCI bridge to [bus 01]
[    6.170004] pci 0000:00:02.0:   bridge window [io  0x1000-0x1fff]
[    6.176003] pci 0000:00:02.0:   bridge window [mem 0x93300000-0x933fffff]
[    6.184004] pci 0000:00:02.0:   bridge window [mem 0x90000000-0x900fffff 64bit pref]
[    6.193136] acpiphp: Slot [2] registered
[    6.197017] pci 0000:00:03.0: PCI bridge to [bus 02]
[    6.203137] acpiphp: Slot [1] registered
[    6.207028] pci 0000:03:00.0: [8086:1528] type 00 class 0x020000
[    6.214013] pci 0000:03:00.0: reg 0x10: [mem 0x92c00000-0x92dfffff 64bit pref]
[    6.222019] pci 0000:03:00.0: reg 0x20: [mem 0x92e04000-0x92e07fff 64bit pref]
[    6.230006] pci 0000:03:00.0: reg 0x30: [mem 0xfff80000-0xffffffff pref]
[    6.238039] pci 0000:03:00.0: PME# supported from D0 D3hot
[    6.244023] pci 0000:03:00.0: reg 0x184: [mem 0x93100000-0x93103fff 64bit]
[    6.251012] pci 0000:03:00.0: reg 0x190: [mem 0x93200000-0x93203fff 64bit]
[    6.259054] pci 0000:03:00.1: [8086:1528] type 00 class 0x020000
[    6.266013] pci 0000:03:00.1: reg 0x10: [mem 0x92a00000-0x92bfffff 64bit pref]
[    6.274018] pci 0000:03:00.1: reg 0x20: [mem 0x92e00000-0x92e03fff 64bit pref]
[    6.282006] pci 0000:03:00.1: reg 0x30: [mem 0xfff80000-0xffffffff pref]
[    6.289039] pci 0000:03:00.1: PME# supported from D0 D3hot
[    6.295023] pci 0000:03:00.1: reg 0x184: [mem 0x92f00000-0x92f03fff 64bit]
[    6.303012] pci 0000:03:00.1: reg 0x190: [mem 0x93000000-0x93003fff 64bit]
[    6.313010] pci 0000:00:03.2: PCI bridge to [bus 03-04]
[    6.319005] pci 0000:00:03.2:   bridge window [mem 0x92f00000-0x932fffff]
[    6.326004] pci 0000:00:03.2:   bridge window [mem 0x92a00000-0x92efffff 64bit pref]
[    6.335138] acpiphp: Slot [0] registered
[    6.339017] pci 0000:00:03.3: PCI bridge to [bus 05]
[    6.345076] pci 0000:00:11.0: PCI bridge to [bus 06]
[    6.350088] pci 0000:00:1c.0: PCI bridge to [bus 07]
[    6.356092] pci 0000:08:00.0: [102b:0522] type 00 class 0x030000
[    6.363027] pci 0000:08:00.0: reg 0x10: [mem 0x91000000-0x91ffffff pref]
[    6.370020] pci 0000:08:00.0: reg 0x14: [mem 0x92800000-0x92803fff]
[    6.377019] pci 0000:08:00.0: reg 0x18: [mem 0x92000000-0x927fffff]
[    6.384060] pci 0000:08:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
[    6.394014] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    6.399006] pci 0000:00:1c.7:   bridge window [mem 0x92000000-0x928fffff]
[    6.407005] pci 0000:00:1c.7:   bridge window [mem 0x91000000-0x91ffffff 64bit pref]
[    6.416067] pci 0000:00:1e.0: PCI bridge to [bus 09] (subtractive decode)
[    6.423008] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    6.432001] pci 0000:00:1e.0:   bridge window [io  0x1000-0x3fff] (subtractive decode)
[    6.441001] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    6.451002] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    6.460003] pci 0000:00:1e.0:   bridge window [mem 0x90000000-0xabffbfff] (subtractive decode)
[    6.470002] pci 0000:00:1e.0:   bridge window [mem 0x380000000000-0x381fffffffff] (subtractive decode)
[    6.480043] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    6.488161] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.498240] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.507240] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.517239] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.526239] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.536239] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.545239] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.555243] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.564422] ACPI: PCI Root Bridge [IIO1] (domain 0000 [bus 40-7e])
[    6.571003] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.580542] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    6.590110] PCI host bridge to bus 0000:40
[    6.595002] pci_bus 0000:40: root bus resource [bus 40-7e]
[    6.601002] pci_bus 0000:40: root bus resource [io  0x4000-0x7fff]
[    6.608005] pci_bus 0000:40: root bus resource [mem 0xac000000-0xc7ffbfff]
[    6.615004] pci_bus 0000:40: root bus resource [mem 0x382000000000-0x383fffffffff]
[    6.624013] pci 0000:40:02.0: [8086:0e04] type 01 class 0x060400
[    6.630074] pci 0000:40:02.0: PME# supported from D0 D3hot D3cold
[    6.637037] pci 0000:40:02.0: System wakeup disabled by ACPI
[    6.644038] pci 0000:40:02.2: [8086:0e06] type 01 class 0x060400
[    6.650074] pci 0000:40:02.2: PME# supported from D0 D3hot D3cold
[    6.657037] pci 0000:40:02.2: System wakeup disabled by ACPI
[    6.664042] pci 0000:40:03.0: [8086:0e08] type 01 class 0x060400
[    6.670069] pci 0000:40:03.0: PME# supported from D0 D3hot D3cold
[    6.677033] pci 0000:40:03.0: System wakeup disabled by ACPI
[    6.683034] pci 0000:40:05.0: [8086:0e28] type 00 class 0x088000
[    6.690102] pci 0000:40:05.1: [8086:0e29] type 00 class 0x088000
[    6.697109] pci 0000:40:05.2: [8086:0e2a] type 00 class 0x088000
[    6.704099] pci 0000:40:05.4: [8086:0e2c] type 00 class 0x080020
[    6.711010] pci 0000:40:05.4: reg 0x10: [mem 0xac000000-0xac000fff]
[    6.718249] pci 0000:40:02.0: PCI bridge to [bus 41]
[    6.723003] pci 0000:40:02.0:   bridge window [io  0x4000-0x4fff]
[    6.730003] pci 0000:40:02.0:   bridge window [mem 0xac100000-0xac2fffff]
[    6.738005] pci 0000:40:02.0:   bridge window [mem 0x382000000000-0x3820001fffff 64bit pref]
[    6.747142] pci 0000:40:02.2: PCI bridge to [bus 42]
[    6.753003] pci 0000:40:02.2:   bridge window [io  0x5000-0x5fff]
[    6.760003] pci 0000:40:02.2:   bridge window [mem 0xac300000-0xac4fffff]
[    6.767004] pci 0000:40:02.2:   bridge window [mem 0x382000200000-0x3820003fffff 64bit pref]
[    6.777125] acpiphp: Slot [6] registered
[    6.781016] pci 0000:40:03.0: PCI bridge to [bus 43]
[    6.787019] acpi PNP0A08:01: Disabling ASPM (FADT indicates it is unsupported)
[    6.795098] ACPI: PCI Root Bridge [IIO2] (domain 0000 [bus 80-be])
[    6.802003] acpi PNP0A08:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.811539] acpi PNP0A08:02: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    6.820017] acpi PNP0A08:02: ignoring host bridge window [io  0x4558-0xffff] (conflicts with PCI Bus 0000:40 [io  0x4000-0x7fff])
[    6.833102] PCI host bridge to bus 0000:80
[    6.838002] pci_bus 0000:80: root bus resource [bus 80-be]
[    6.844001] pci_bus 0000:80: root bus resource [mem 0xc8000000-0xe3ffbfff]
[    6.852002] pci_bus 0000:80: root bus resource [mem 0x384000000000-0x385fffffffff]
[    6.860012] pci 0000:80:02.0: [8086:0e04] type 01 class 0x060400
[    6.867074] pci 0000:80:02.0: PME# supported from D0 D3hot D3cold
[    6.874036] pci 0000:80:02.0: System wakeup disabled by ACPI
[    6.880039] pci 0000:80:02.2: [8086:0e06] type 01 class 0x060400
[    6.887073] pci 0000:80:02.2: PME# supported from D0 D3hot D3cold
[    6.894037] pci 0000:80:02.2: System wakeup disabled by ACPI
[    6.900041] pci 0000:80:03.0: [8086:0e08] type 01 class 0x060400
[    6.907069] pci 0000:80:03.0: PME# supported from D0 D3hot D3cold
[    6.914037] pci 0000:80:03.0: System wakeup disabled by ACPI
[    6.920040] pci 0000:80:05.0: [8086:0e28] type 00 class 0x088000
[    6.927108] pci 0000:80:05.1: [8086:0e29] type 00 class 0x088000
[    6.933114] pci 0000:80:05.2: [8086:0e2a] type 00 class 0x088000
[    6.940107] pci 0000:80:05.4: [8086:0e2c] type 00 class 0x080020
[    6.947010] pci 0000:80:05.4: reg 0x10: [mem 0xc8000000-0xc8000fff]
[    6.954250] acpiphp: Slot [4] registered
[    6.959016] pci 0000:80:02.0: PCI bridge to [bus 81]
[    6.964142] acpiphp: Slot [3] registered
[    6.969015] pci 0000:80:02.2: PCI bridge to [bus 82]
[    6.974130] acpiphp: Slot [9] registered
[    6.979015] pci 0000:80:03.0: PCI bridge to [bus 83]
[    6.984018] acpi PNP0A08:02: Disabling ASPM (FADT indicates it is unsupported)
[    6.992093] ACPI: PCI Root Bridge [IIO3] (domain 0000 [bus c0-fe])
[    6.999003] acpi PNP0A08:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    7.008539] acpi PNP0A08:03: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    7.018121] PCI host bridge to bus 0000:c0
[    7.023002] pci_bus 0000:c0: root bus resource [bus c0-fe]
[    7.029001] pci_bus 0000:c0: root bus resource [io  0xc000-0xffff]
[    7.036001] pci_bus 0000:c0: root bus resource [mem 0xe4000000-0xfbffbfff]
[    7.043002] pci_bus 0000:c0: root bus resource [mem 0x386000000000-0x387fffffffff]
[    7.052013] pci 0000:c0:02.0: [8086:0e04] type 01 class 0x060400
[    7.058074] pci 0000:c0:02.0: PME# supported from D0 D3hot D3cold
[    7.065035] pci 0000:c0:02.0: System wakeup disabled by ACPI
[    7.072039] pci 0000:c0:02.2: [8086:0e06] type 01 class 0x060400
[    7.078073] pci 0000:c0:02.2: PME# supported from D0 D3hot D3cold
[    7.085040] pci 0000:c0:02.2: System wakeup disabled by ACPI
[    7.092044] pci 0000:c0:03.0: [8086:0e08] type 01 class 0x060400
[    7.098070] pci 0000:c0:03.0: PME# supported from D0 D3hot D3cold
[    7.105037] pci 0000:c0:03.0: System wakeup disabled by ACPI
[    7.111037] pci 0000:c0:05.0: [8086:0e28] type 00 class 0x088000
[    7.118107] pci 0000:c0:05.1: [8086:0e29] type 00 class 0x088000
[    7.125117] pci 0000:c0:05.2: [8086:0e2a] type 00 class 0x088000
[    7.132103] pci 0000:c0:05.4: [8086:0e2c] type 00 class 0x080020
[    7.139012] pci 0000:c0:05.4: reg 0x10: [mem 0xe4000000-0xe4000fff]
[    7.146250] pci 0000:c0:02.0: PCI bridge to [bus c1]
[    7.151003] pci 0000:c0:02.0:   bridge window [io  0xc000-0xcfff]
[    7.158003] pci 0000:c0:02.0:   bridge window [mem 0xe4100000-0xe42fffff]
[    7.166005] pci 0000:c0:02.0:   bridge window [mem 0x386000000000-0x3860001fffff 64bit pref]
[    7.175142] pci 0000:c0:02.2: PCI bridge to [bus c2]
[    7.181003] pci 0000:c0:02.2:   bridge window [io  0xd000-0xdfff]
[    7.188003] pci 0000:c0:02.2:   bridge window [mem 0xe4300000-0xe44fffff]
[    7.195004] pci 0000:c0:02.2:   bridge window [mem 0x386000200000-0x3860003fffff 64bit pref]
[    7.205126] acpiphp: Slot [11] registered
[    7.209019] pci 0000:c0:03.0: PCI bridge to [bus c3]
[    7.215019] acpi PNP0A08:03: Disabling ASPM (FADT indicates it is unsupported)
[    7.223124] ACPI: Enabled 3 GPEs in block 00 to 3F
[    7.228146] vgaarb: device added: PCI:0000:08:00.0,decodes=io+mem,owns=io+mem,locks=none
[    7.238011] vgaarb: loaded
[    7.241001] vgaarb: bridge control possible 0000:08:00.0
[    7.246183] SCSI subsystem initialized
[    7.251041] ACPI: bus type USB registered
[    7.255029] usbcore: registered new interface driver usbfs
[    7.261010] usbcore: registered new interface driver hub
[    7.267021] usbcore: registered new device driver usb
[    7.273032] pps_core: LinuxPPS API ver. 1 registered
[    7.279001] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    7.289014] PTP clock support registered
[    7.294000] PCI: Using ACPI for IRQ routing
[    7.301004] PCI: pci_cache_line_size set to 64 bytes
[    7.307404] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    7.314004] e820: reserve RAM buffer [mem 0x6504b000-0x67ffffff]
[    7.321001] e820: reserve RAM buffer [mem 0x65c1d000-0x67ffffff]
[    7.327001] e820: reserve RAM buffer [mem 0x65d8f000-0x67ffffff]
[    7.334001] e820: reserve RAM buffer [mem 0x7abcf000-0x7bffffff]
[    7.341002] e820: reserve RAM buffer [mem 0x7b800000-0x7bffffff]
[    7.347185] NetLabel: Initializing
[    7.351001] NetLabel:  domain hash size = 128
[    7.356002] NetLabel:  protocols = UNLABELED CIPSOv4
[    7.362020] NetLabel:  unlabeled traffic allowed by default
[    7.368120] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    7.375207] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    7.385305] Switched to clocksource hpet
[    7.399337] pnp: PnP ACPI init
[    7.403392] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    7.410808] system 00:01: [io  0x0500-0x053f] has been reserved
[    7.417421] system 00:01: [io  0x0400-0x047f] could not be reserved
[    7.424419] system 00:01: [io  0x0540-0x057f] has been reserved
[    7.431031] system 00:01: [io  0x0600-0x061f] has been reserved
[    7.437642] system 00:01: [io  0x0ca0-0x0ca5] has been reserved
[    7.444252] system 00:01: [io  0x0880-0x0883] has been reserved
[    7.450863] system 00:01: [io  0x0800-0x081f] has been reserved
[    7.457474] system 00:01: [mem 0xfed1c000-0xfed3ffff] could not be reserved
[    7.465246] system 00:01: [mem 0xfed45000-0xfed8bfff] has been reserved
[    7.472623] system 00:01: [mem 0xff000000-0xffffffff] could not be reserved
[    7.480397] system 00:01: [mem 0xfee00000-0xfeefffff] has been reserved
[    7.487785] system 00:01: [mem 0xfed12000-0xfed1200f] has been reserved
[    7.495171] system 00:01: [mem 0xfed12010-0xfed1201f] has been reserved
[    7.502556] system 00:01: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    7.509943] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    7.517650] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    7.525062] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    7.532382] pnp 00:04: Plug and Play ACPI device, IDs IPI0001 (active)
[    7.539702] pnp 00:05: Plug and Play ACPI device, IDs PNP0c31 (active)
[    7.547317] pnp: PnP ACPI: found 6 devices
[    7.558204] pci 0000:01:00.0: can't claim BAR 6 [mem 0xfff00000-0xffffffff pref]: no compatible bridge window
[    7.569276] pci 0000:03:00.0: can't claim BAR 6 [mem 0xfff80000-0xffffffff pref]: no compatible bridge window
[    7.580348] pci 0000:03:00.1: can't claim BAR 6 [mem 0xfff80000-0xffffffff pref]: no compatible bridge window
[    7.591421] pci 0000:08:00.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]: no compatible bridge window
[    7.602590] pci 0000:01:00.0: BAR 6: assigned [mem 0x90000000-0x900fffff pref]
[    7.610661] pci 0000:00:02.0: PCI bridge to [bus 01]
[    7.616210] pci 0000:00:02.0:   bridge window [io  0x1000-0x1fff]
[    7.623019] pci 0000:00:02.0:   bridge window [mem 0x93300000-0x933fffff]
[    7.630601] pci 0000:00:02.0:   bridge window [mem 0x90000000-0x900fffff 64bit pref]
[    7.639254] pci 0000:00:03.0: PCI bridge to [bus 02]
[    7.644806] pci 0000:03:00.0: BAR 6: assigned [mem 0x92e80000-0x92efffff pref]
[    7.652873] pci 0000:03:00.1: BAR 6: no space for [mem size 0x00080000 pref]
[    7.660745] pci 0000:03:00.1: BAR 6: failed to assign [mem size 0x00080000 pref]
[    7.669006] pci 0000:00:03.2: PCI bridge to [bus 03-04]
[    7.674841] pci 0000:00:03.2:   bridge window [mem 0x92f00000-0x932fffff]
[    7.682422] pci 0000:00:03.2:   bridge window [mem 0x92a00000-0x92efffff 64bit pref]
[    7.691071] pci 0000:00:03.3: PCI bridge to [bus 05]
[    7.696622] pci 0000:00:11.0: PCI bridge to [bus 06]
[    7.702176] pci 0000:00:1c.0: PCI bridge to [bus 07]
[    7.707734] pci 0000:08:00.0: BAR 6: assigned [mem 0x92810000-0x9281ffff pref]
[    7.715799] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    7.721345] pci 0000:00:1c.7:   bridge window [mem 0x92000000-0x928fffff]
[    7.728926] pci 0000:00:1c.7:   bridge window [mem 0x91000000-0x91ffffff 64bit pref]
[    7.737577] pci 0000:00:1e.0: PCI bridge to [bus 09]
[    7.743129] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    7.749352] pci_bus 0000:00: resource 5 [io  0x1000-0x3fff]
[    7.755572] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    7.762569] pci_bus 0000:00: resource 7 [mem 0xfed40000-0xfedfffff]
[    7.769558] pci_bus 0000:00: resource 8 [mem 0x90000000-0xabffbfff]
[    7.776556] pci_bus 0000:00: resource 9 [mem 0x380000000000-0x381fffffffff]
[    7.784328] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    7.790547] pci_bus 0000:01: resource 1 [mem 0x93300000-0x933fffff]
[    7.797545] pci_bus 0000:01: resource 2 [mem 0x90000000-0x900fffff 64bit pref]
[    7.805611] pci_bus 0000:03: resource 1 [mem 0x92f00000-0x932fffff]
[    7.812609] pci_bus 0000:03: resource 2 [mem 0x92a00000-0x92efffff 64bit pref]
[    7.820674] pci_bus 0000:08: resource 1 [mem 0x92000000-0x928fffff]
[    7.827673] pci_bus 0000:08: resource 2 [mem 0x91000000-0x91ffffff 64bit pref]
[    7.835737] pci_bus 0000:09: resource 4 [io  0x0000-0x0cf7]
[    7.841957] pci_bus 0000:09: resource 5 [io  0x1000-0x3fff]
[    7.848179] pci_bus 0000:09: resource 6 [mem 0x000a0000-0x000bffff]
[    7.855176] pci_bus 0000:09: resource 7 [mem 0xfed40000-0xfedfffff]
[    7.862173] pci_bus 0000:09: resource 8 [mem 0x90000000-0xabffbfff]
[    7.869170] pci_bus 0000:09: resource 9 [mem 0x380000000000-0x381fffffffff]
[    7.876957] pci 0000:40:02.0: PCI bridge to [bus 41]
[    7.882501] pci 0000:40:02.0:   bridge window [io  0x4000-0x4fff]
[    7.889306] pci 0000:40:02.0:   bridge window [mem 0xac100000-0xac2fffff]
[    7.896887] pci 0000:40:02.0:   bridge window [mem 0x382000000000-0x3820001fffff 64bit pref]
[    7.906313] pci 0000:40:02.2: PCI bridge to [bus 42]
[    7.911856] pci 0000:40:02.2:   bridge window [io  0x5000-0x5fff]
[    7.918661] pci 0000:40:02.2:   bridge window [mem 0xac300000-0xac4fffff]
[    7.926242] pci 0000:40:02.2:   bridge window [mem 0x382000200000-0x3820003fffff 64bit pref]
[    7.935666] pci 0000:40:03.0: PCI bridge to [bus 43]
[    7.941216] pci_bus 0000:40: resource 4 [io  0x4000-0x7fff]
[    7.947440] pci_bus 0000:40: resource 5 [mem 0xac000000-0xc7ffbfff]
[    7.954438] pci_bus 0000:40: resource 6 [mem 0x382000000000-0x383fffffffff]
[    7.962210] pci_bus 0000:41: resource 0 [io  0x4000-0x4fff]
[    7.968432] pci_bus 0000:41: resource 1 [mem 0xac100000-0xac2fffff]
[    7.975429] pci_bus 0000:41: resource 2 [mem 0x382000000000-0x3820001fffff 64bit pref]
[    7.984269] pci_bus 0000:42: resource 0 [io  0x5000-0x5fff]
[    7.990480] pci_bus 0000:42: resource 1 [mem 0xac300000-0xac4fffff]
[    7.997478] pci_bus 0000:42: resource 2 [mem 0x382000200000-0x3820003fffff 64bit pref]
[    8.006333] pci 0000:80:02.0: PCI bridge to [bus 81]
[    8.011884] pci 0000:80:02.2: PCI bridge to [bus 82]
[    8.017436] pci 0000:80:03.0: PCI bridge to [bus 83]
[    8.022986] pci_bus 0000:80: resource 4 [mem 0xc8000000-0xe3ffbfff]
[    8.029986] pci_bus 0000:80: resource 5 [mem 0x384000000000-0x385fffffffff]
[    8.037775] pci 0000:c0:02.0: PCI bridge to [bus c1]
[    8.043311] pci 0000:c0:02.0:   bridge window [io  0xc000-0xcfff]
[    8.050116] pci 0000:c0:02.0:   bridge window [mem 0xe4100000-0xe42fffff]
[    8.057697] pci 0000:c0:02.0:   bridge window [mem 0x386000000000-0x3860001fffff 64bit pref]
[    8.067122] pci 0000:c0:02.2: PCI bridge to [bus c2]
[    8.072666] pci 0000:c0:02.2:   bridge window [io  0xd000-0xdfff]
[    8.079472] pci 0000:c0:02.2:   bridge window [mem 0xe4300000-0xe44fffff]
[    8.087055] pci 0000:c0:02.2:   bridge window [mem 0x386000200000-0x3860003fffff 64bit pref]
[    8.096479] pci 0000:c0:03.0: PCI bridge to [bus c3]
[    8.102031] pci_bus 0000:c0: resource 4 [io  0xc000-0xffff]
[    8.108255] pci_bus 0000:c0: resource 5 [mem 0xe4000000-0xfbffbfff]
[    8.115252] pci_bus 0000:c0: resource 6 [mem 0x386000000000-0x387fffffffff]
[    8.123024] pci_bus 0000:c1: resource 0 [io  0xc000-0xcfff]
[    8.129246] pci_bus 0000:c1: resource 1 [mem 0xe4100000-0xe42fffff]
[    8.136244] pci_bus 0000:c1: resource 2 [mem 0x386000000000-0x3860001fffff 64bit pref]
[    8.145083] pci_bus 0000:c2: resource 0 [io  0xd000-0xdfff]
[    8.151303] pci_bus 0000:c2: resource 1 [mem 0xe4300000-0xe44fffff]
[    8.158301] pci_bus 0000:c2: resource 2 [mem 0x386000200000-0x3860003fffff 64bit pref]
[    8.167263] NET: Registered protocol family 2
[    8.173225] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    8.182337] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    8.190010] TCP: Hash tables configured (established 524288 bind 65536)
[    8.197473] TCP: reno registered
[    8.201274] UDP hash table entries: 65536 (order: 9, 2097152 bytes)
[    8.208718] UDP-Lite hash table entries: 65536 (order: 9, 2097152 bytes)
[    8.217024] NET: Registered protocol family 1
[    8.222422] RPC: Registered named UNIX socket transport module.
[    8.229045] RPC: Registered udp transport module.
[    8.234298] RPC: Registered tcp transport module.
[    8.239553] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    8.250189] IOAPIC[0]: Set routing entry (8-16 -> 0x41 -> IRQ 16 Mode:1 Active:1 Dest:6)
[    8.259393] IOAPIC[0]: Set routing entry (8-23 -> 0x51 -> IRQ 23 Mode:1 Active:1 Dest:6)
[    8.268519] pci 0000:08:00.0: Boot video device
[    8.273619] PCI: CLS 64 bytes, default 64
[    8.278180] Unpacking initramfs...
[   10.210910] Freeing initrd memory: 124820K (ffff88807661b000 - ffff88807e000000)
[   10.219199] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   10.226393] software IO TLB [mem 0x76bcf000-0x7abcf000] (64MB) mapped at [ffff880076bcf000-ffff88007abcefff]
[   10.245792] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[   10.264628] futex hash table entries: 65536 (order: 10, 4194304 bytes)
[   10.272629] Initialise system trusted keyring
[   10.277529] audit: initializing netlink subsys (disabled)
[   10.283578] audit: type=2000 audit(1412568206.282:1): initialized
[   10.291593] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   10.299882] zpool: loaded
[   10.302808] zbud: loaded
[   10.305842] VFS: Disk quotas dquot_6.5.2
[   10.310321] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   10.318678] SGI XFS with ACLs, security attributes, no debug enabled
[   10.327338] 9p: Installing v9fs 9p2000 file system support
[   10.333515] msgmni has been set to 32768
[   10.338007] Key type big_key registered
[   10.342293] SELinux:  Registering netfilter hooks
[   10.356052] NET: Registered protocol family 38
[   10.361027] Key type asymmetric registered
[   10.365606] Asymmetric key parser 'x509' registered
[   10.371106] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[   10.379768] io scheduler noop registered
[   10.384148] io scheduler deadline registered (default)
[   10.389894] io scheduler cfq registered
[   10.394668] IOAPIC[1]: Set routing entry (9-23 -> 0x61 -> IRQ 24 Mode:1 Active:1 Dest:6)
[   10.403752] pcieport 0000:00:02.0: irq 25 for MSI/MSI-X
[   10.409756] pcieport 0000:00:03.0: irq 26 for MSI/MSI-X
[   10.415763] pcieport 0000:00:03.2: irq 27 for MSI/MSI-X
[   10.421751] pcieport 0000:00:03.3: irq 28 for MSI/MSI-X
[   10.427725] IOAPIC[0]: Set routing entry (8-19 -> 0xb1 -> IRQ 19 Mode:1 Active:1 Dest:6)
[   10.436800] pcieport 0000:00:11.0: irq 29 for MSI/MSI-X
[   10.442778] IOAPIC[0]: Set routing entry (8-16 -> 0xd1 -> IRQ 16 Mode:1 Active:1 Dest:6)
[   10.451858] pcieport 0000:00:1c.0: irq 30 for MSI/MSI-X
[   10.457873] pcieport 0000:00:1c.7: irq 31 for MSI/MSI-X
[   10.463830] IOAPIC[2]: Set routing entry (10-23 -> 0x42 -> IRQ 32 Mode:1 Active:1 Dest:6)
[   10.473024] pcieport 0000:40:02.0: irq 33 for MSI/MSI-X
[   10.479015] pcieport 0000:40:02.2: irq 34 for MSI/MSI-X
[   10.484998] pcieport 0000:40:03.0: irq 35 for MSI/MSI-X
[   10.490966] IOAPIC[3]: Set routing entry (11-23 -> 0x82 -> IRQ 36 Mode:1 Active:1 Dest:6)
[   10.500138] pcieport 0000:80:02.0: irq 37 for MSI/MSI-X
[   10.506118] pcieport 0000:80:02.2: irq 38 for MSI/MSI-X
[   10.512090] pcieport 0000:80:03.0: irq 39 for MSI/MSI-X
[   10.518075] IOAPIC[4]: Set routing entry (12-23 -> 0xc2 -> IRQ 40 Mode:1 Active:1 Dest:6)
[   10.527249] pcieport 0000:c0:02.0: irq 41 for MSI/MSI-X
[   10.533229] pcieport 0000:c0:02.2: irq 42 for MSI/MSI-X
[   10.539202] pcieport 0000:c0:03.0: irq 43 for MSI/MSI-X
[   10.545153] aer 0000:00:02.0:pcie02: service driver aer loaded
[   10.551691] aer 0000:00:03.0:pcie02: service driver aer loaded
[   10.558230] aer 0000:00:03.2:pcie02: service driver aer loaded
[   10.564767] aer 0000:00:03.3:pcie02: service driver aer loaded
[   10.571314] aer 0000:00:11.0:pcie02: service driver aer loaded
[   10.577858] aer 0000:40:02.0:pcie02: service driver aer loaded
[   10.584390] aer 0000:40:02.2:pcie02: service driver aer loaded
[   10.590923] aer 0000:40:03.0:pcie02: service driver aer loaded
[   10.597463] aer 0000:80:02.0:pcie02: service driver aer loaded
[   10.604009] aer 0000:80:02.2:pcie02: service driver aer loaded
[   10.610547] aer 0000:80:03.0:pcie02: service driver aer loaded
[   10.617085] aer 0000:c0:02.0:pcie02: service driver aer loaded
[   10.623614] aer 0000:c0:02.2:pcie02: service driver aer loaded
[   10.630151] aer 0000:c0:03.0:pcie02: service driver aer loaded
[   10.636679] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[   10.644453] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[   10.651748] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[   10.659237] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[   10.667011] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[   10.674501] pcieport 0000:00:03.2: Signaling PME through PCIe PME interrupt
[   10.682265] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[   10.689547] pci 0000:03:00.1: Signaling PME through PCIe PME interrupt
[   10.696844] pcie_pme 0000:00:03.2:pcie01: service driver pcie_pme loaded
[   10.704331] pcieport 0000:00:03.3: Signaling PME through PCIe PME interrupt
[   10.712107] pcie_pme 0000:00:03.3:pcie01: service driver pcie_pme loaded
[   10.719597] pcieport 0000:00:11.0: Signaling PME through PCIe PME interrupt
[   10.727374] pcie_pme 0000:00:11.0:pcie01: service driver pcie_pme loaded
[   10.734881] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[   10.742665] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[   10.750161] pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
[   10.757939] pci 0000:08:00.0: Signaling PME through PCIe PME interrupt
[   10.765230] pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme loaded
[   10.772720] pcieport 0000:40:02.0: Signaling PME through PCIe PME interrupt
[   10.780496] pcie_pme 0000:40:02.0:pcie01: service driver pcie_pme loaded
[   10.787985] pcieport 0000:40:02.2: Signaling PME through PCIe PME interrupt
[   10.795761] pcie_pme 0000:40:02.2:pcie01: service driver pcie_pme loaded
[   10.803250] pcieport 0000:40:03.0: Signaling PME through PCIe PME interrupt
[   10.811023] pcie_pme 0000:40:03.0:pcie01: service driver pcie_pme loaded
[   10.818511] pcieport 0000:80:02.0: Signaling PME through PCIe PME interrupt
[   10.826286] pcie_pme 0000:80:02.0:pcie01: service driver pcie_pme loaded
[   10.833775] pcieport 0000:80:02.2: Signaling PME through PCIe PME interrupt
[   10.841552] pcie_pme 0000:80:02.2:pcie01: service driver pcie_pme loaded
[   10.849039] pcieport 0000:80:03.0: Signaling PME through PCIe PME interrupt
[   10.856817] pcie_pme 0000:80:03.0:pcie01: service driver pcie_pme loaded
[   10.864305] pcieport 0000:c0:02.0: Signaling PME through PCIe PME interrupt
[   10.872079] pcie_pme 0000:c0:02.0:pcie01: service driver pcie_pme loaded
[   10.879569] pcieport 0000:c0:02.2: Signaling PME through PCIe PME interrupt
[   10.887338] pcie_pme 0000:c0:02.2:pcie01: service driver pcie_pme loaded
[   10.894829] pcieport 0000:c0:03.0: Signaling PME through PCIe PME interrupt
[   10.902605] pcie_pme 0000:c0:03.0:pcie01: service driver pcie_pme loaded
[   10.910123] ioapic: probe of 0000:00:05.4 failed with error -22
[   10.916744] ioapic: probe of 0000:40:05.4 failed with error -22
[   10.923363] ioapic: probe of 0000:80:05.4 failed with error -22
[   10.929980] ioapic: probe of 0000:c0:05.4 failed with error -22
[   10.936598] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   10.942861] pciehp 0000:40:02.0:pcie04: Slot #5 AttnBtn+ AttnInd+ PwrInd+ PwrCtrl+ MRL- Interlock- NoCompl- LLActRep+
[   12.044013] pciehp 0000:40:02.0:pcie04: Timeout on hotplug command 0x000007c0 (issued 13 msec ago)
[   12.054025] pciehp 0000:40:02.0:pcie04: service driver pciehp loaded
[   12.061130] pciehp 0000:40:02.2:pcie04: Slot #7 AttnBtn+ AttnInd+ PwrInd+ PwrCtrl+ MRL- Interlock- NoCompl- LLActRep+
[   13.162012] pciehp 0000:40:02.2:pcie04: Timeout on hotplug command 0x000007c0 (issued 12 msec ago)
[   13.172020] pciehp 0000:40:02.2:pcie04: service driver pciehp loaded
[   13.179123] pciehp 0000:c0:02.0:pcie04: Slot #12 AttnBtn+ AttnInd+ PwrInd+ PwrCtrl+ MRL- Interlock- NoCompl- LLActRep+
[   14.280013] pciehp 0000:c0:02.0:pcie04: Timeout on hotplug command 0x000007c0 (issued 12 msec ago)
[   14.290023] pciehp 0000:c0:02.0:pcie04: service driver pciehp loaded
[   14.297126] pciehp 0000:c0:02.2:pcie04: Slot #10 AttnBtn+ AttnInd+ PwrInd+ PwrCtrl+ MRL- Interlock- NoCompl- LLActRep+
[   15.398011] pciehp 0000:c0:02.2:pcie04: Timeout on hotplug command 0x000007c0 (issued 12 msec ago)
[   15.408020] pciehp 0000:c0:02.2:pcie04: service driver pciehp loaded
[   15.415120] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   15.422574] intel_idle: MWAIT substates: 0x1120
[   15.427630] intel_idle: v0.4 model 0x3E
[   15.431913] intel_idle: lapic_timer_reliable_states 0xffffffff
[   15.441792] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[   15.451125] ACPI: Sleep Button [SLPB]
[   15.455246] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   15.463504] ACPI: Power Button [PWRF]
[   15.478761] GHES: HEST is not enabled!
[   15.483151] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   15.510881] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[   15.539774] 00:03: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[   15.548600] Non-volatile memory driver v1.3
[   15.553294] Linux agpgart interface v0.103
[   15.558543] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
[   15.601205] rdac: device handler registered
[   15.606054] hp_sw: device handler registered
[   15.610830] emc: device handler registered
[   15.615400] alua: device handler registered
[   15.620098] libphy: Fixed MDIO Bus: probed
[   15.624798] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[   15.632667] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   15.639127] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   15.645646] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[   15.652334] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.13-k
[   15.660220] igb: Copyright (c) 2007-2014 Intel Corporation.
[   15.666502] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[   15.675139] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[   15.681660] IOAPIC[1]: Set routing entry (9-21 -> 0x43 -> IRQ 44 Mode:1 Active:1 Dest:6)
[   16.121476] ixgbe 0000:03:00.0: irq 45 for MSI/MSI-X
[   16.127037] ixgbe 0000:03:00.0: irq 46 for MSI/MSI-X
[   16.132611] ixgbe 0000:03:00.0: irq 47 for MSI/MSI-X
[   16.138169] ixgbe 0000:03:00.0: irq 48 for MSI/MSI-X
[   16.143725] ixgbe 0000:03:00.0: irq 49 for MSI/MSI-X
[   16.149282] ixgbe 0000:03:00.0: irq 50 for MSI/MSI-X
[   16.154840] ixgbe 0000:03:00.0: irq 51 for MSI/MSI-X
[   16.160393] ixgbe 0000:03:00.0: irq 52 for MSI/MSI-X
[   16.165949] ixgbe 0000:03:00.0: irq 53 for MSI/MSI-X
[   16.171503] ixgbe 0000:03:00.0: irq 54 for MSI/MSI-X
[   16.177061] ixgbe 0000:03:00.0: irq 55 for MSI/MSI-X
[   16.182615] ixgbe 0000:03:00.0: irq 56 for MSI/MSI-X
[   16.188173] ixgbe 0000:03:00.0: irq 57 for MSI/MSI-X
[   16.193729] ixgbe 0000:03:00.0: irq 58 for MSI/MSI-X
[   16.199285] ixgbe 0000:03:00.0: irq 59 for MSI/MSI-X
[   16.204839] ixgbe 0000:03:00.0: irq 60 for MSI/MSI-X
[   16.210396] ixgbe 0000:03:00.0: irq 61 for MSI/MSI-X
[   16.215949] ixgbe 0000:03:00.0: irq 62 for MSI/MSI-X
[   16.221522] ixgbe 0000:03:00.0: irq 63 for MSI/MSI-X
[   16.227097] ixgbe 0000:03:00.0: irq 64 for MSI/MSI-X
[   16.232653] ixgbe 0000:03:00.0: irq 65 for MSI/MSI-X
[   16.238213] ixgbe 0000:03:00.0: irq 66 for MSI/MSI-X
[   16.243769] ixgbe 0000:03:00.0: irq 67 for MSI/MSI-X
[   16.249324] ixgbe 0000:03:00.0: irq 68 for MSI/MSI-X
[   16.254879] ixgbe 0000:03:00.0: irq 69 for MSI/MSI-X
[   16.260437] ixgbe 0000:03:00.0: irq 70 for MSI/MSI-X
[   16.265994] ixgbe 0000:03:00.0: irq 71 for MSI/MSI-X
[   16.271549] ixgbe 0000:03:00.0: irq 72 for MSI/MSI-X
[   16.277115] ixgbe 0000:03:00.0: irq 73 for MSI/MSI-X
[   16.282673] ixgbe 0000:03:00.0: irq 74 for MSI/MSI-X
[   16.288228] ixgbe 0000:03:00.0: irq 75 for MSI/MSI-X
[   16.293785] ixgbe 0000:03:00.0: irq 76 for MSI/MSI-X
[   16.299343] ixgbe 0000:03:00.0: irq 77 for MSI/MSI-X
[   16.304898] ixgbe 0000:03:00.0: irq 78 for MSI/MSI-X
[   16.310475] ixgbe 0000:03:00.0: irq 79 for MSI/MSI-X
[   16.316034] ixgbe 0000:03:00.0: irq 80 for MSI/MSI-X
[   16.321598] ixgbe 0000:03:00.0: irq 81 for MSI/MSI-X
[   16.327154] ixgbe 0000:03:00.0: irq 82 for MSI/MSI-X
[   16.332711] ixgbe 0000:03:00.0: irq 83 for MSI/MSI-X
[   16.338267] ixgbe 0000:03:00.0: irq 84 for MSI/MSI-X
[   16.343822] ixgbe 0000:03:00.0: irq 85 for MSI/MSI-X
[   16.349379] ixgbe 0000:03:00.0: irq 86 for MSI/MSI-X
[   16.354937] ixgbe 0000:03:00.0: irq 87 for MSI/MSI-X
[   16.360495] ixgbe 0000:03:00.0: irq 88 for MSI/MSI-X
[   16.366058] ixgbe 0000:03:00.0: irq 89 for MSI/MSI-X
[   16.371614] ixgbe 0000:03:00.0: irq 90 for MSI/MSI-X
[   16.377174] ixgbe 0000:03:00.0: irq 91 for MSI/MSI-X
[   16.382732] ixgbe 0000:03:00.0: irq 92 for MSI/MSI-X
[   16.388291] ixgbe 0000:03:00.0: irq 93 for MSI/MSI-X
[   16.393847] ixgbe 0000:03:00.0: irq 94 for MSI/MSI-X
[   16.399423] ixgbe 0000:03:00.0: irq 95 for MSI/MSI-X
[   16.404981] ixgbe 0000:03:00.0: irq 96 for MSI/MSI-X
[   16.410541] ixgbe 0000:03:00.0: irq 97 for MSI/MSI-X
[   16.416099] ixgbe 0000:03:00.0: irq 98 for MSI/MSI-X
[   16.421656] ixgbe 0000:03:00.0: irq 99 for MSI/MSI-X
[   16.427214] ixgbe 0000:03:00.0: irq 100 for MSI/MSI-X
[   16.432868] ixgbe 0000:03:00.0: irq 101 for MSI/MSI-X
[   16.438523] ixgbe 0000:03:00.0: irq 102 for MSI/MSI-X
[   16.444177] ixgbe 0000:03:00.0: irq 103 for MSI/MSI-X
[   16.449833] ixgbe 0000:03:00.0: irq 104 for MSI/MSI-X
[   16.455493] ixgbe 0000:03:00.0: irq 105 for MSI/MSI-X
[   16.461147] ixgbe 0000:03:00.0: irq 106 for MSI/MSI-X
[   16.466802] ixgbe 0000:03:00.0: irq 107 for MSI/MSI-X
[   16.472444] ixgbe 0000:03:00.0: irq 108 for MSI/MSI-X
[   16.478252] ixgbe 0000:03:00.0: Multiqueue Enabled: Rx Queue count = 63, Tx Queue count = 63
[   16.548055] ixgbe 0000:03:00.0: PCI Express bandwidth of 16GT/s available
[   16.555644] ixgbe 0000:03:00.0: (Speed:5.0GT/s, Width: x4, Encoding Loss:20%)
[   16.563612] ixgbe 0000:03:00.0: This is not sufficient for optimal performance of this card.
[   16.573037] ixgbe 0000:03:00.0: For optimal performance, at least 20GT/s of bandwidth is required.
[   16.583042] ixgbe 0000:03:00.0: A slot with more lanes and/or higher speed is suggested.
[   16.749394] ixgbe 0000:03:00.0: MAC: 3, PHY: 3, PBA No: G36748-004
[   16.756328] ixgbe 0000:03:00.0: a0:36:9f:18:d6:a8
[   16.906297] ixgbe 0000:03:00.0: Intel(R) 10 Gigabit Network Connection
[   16.913681] IOAPIC[1]: Set routing entry (9-18 -> 0x98 -> IRQ 109 Mode:1 Active:1 Dest:6)
[   17.352336] ixgbe 0000:03:00.1: irq 110 for MSI/MSI-X
[   17.357994] ixgbe 0000:03:00.1: irq 111 for MSI/MSI-X
[   17.363638] ixgbe 0000:03:00.1: irq 112 for MSI/MSI-X
[   17.369295] ixgbe 0000:03:00.1: irq 113 for MSI/MSI-X
[   17.374949] ixgbe 0000:03:00.1: irq 114 for MSI/MSI-X
[   17.380596] ixgbe 0000:03:00.1: irq 115 for MSI/MSI-X
[   17.386254] ixgbe 0000:03:00.1: irq 116 for MSI/MSI-X
[   17.391904] ixgbe 0000:03:00.1: irq 117 for MSI/MSI-X
[   17.397558] ixgbe 0000:03:00.1: irq 118 for MSI/MSI-X
[   17.403208] ixgbe 0000:03:00.1: irq 119 for MSI/MSI-X
[   17.408858] ixgbe 0000:03:00.1: irq 120 for MSI/MSI-X
[   17.414511] ixgbe 0000:03:00.1: irq 121 for MSI/MSI-X
[   17.420162] ixgbe 0000:03:00.1: irq 122 for MSI/MSI-X
[   17.425814] ixgbe 0000:03:00.1: irq 123 for MSI/MSI-X
[   17.431467] ixgbe 0000:03:00.1: irq 124 for MSI/MSI-X
[   17.437121] ixgbe 0000:03:00.1: irq 125 for MSI/MSI-X
[   17.442799] ixgbe 0000:03:00.1: irq 126 for MSI/MSI-X
[   17.448454] ixgbe 0000:03:00.1: irq 127 for MSI/MSI-X
[   17.454126] ixgbe 0000:03:00.1: irq 128 for MSI/MSI-X
[   17.459783] ixgbe 0000:03:00.1: irq 129 for MSI/MSI-X
[   17.465436] ixgbe 0000:03:00.1: irq 130 for MSI/MSI-X
[   17.471096] ixgbe 0000:03:00.1: irq 131 for MSI/MSI-X
[   17.476751] ixgbe 0000:03:00.1: irq 132 for MSI/MSI-X
[   17.482407] ixgbe 0000:03:00.1: irq 133 for MSI/MSI-X
[   17.488060] ixgbe 0000:03:00.1: irq 134 for MSI/MSI-X
[   17.493716] ixgbe 0000:03:00.1: irq 135 for MSI/MSI-X
[   17.499369] ixgbe 0000:03:00.1: irq 136 for MSI/MSI-X
[   17.505021] ixgbe 0000:03:00.1: irq 137 for MSI/MSI-X
[   17.510674] ixgbe 0000:03:00.1: irq 138 for MSI/MSI-X
[   17.516335] ixgbe 0000:03:00.1: irq 139 for MSI/MSI-X
[   17.521989] ixgbe 0000:03:00.1: irq 140 for MSI/MSI-X
[   17.527644] ixgbe 0000:03:00.1: irq 141 for MSI/MSI-X
[   17.533388] ixgbe 0000:03:00.1: irq 142 for MSI/MSI-X
[   17.539044] ixgbe 0000:03:00.1: irq 143 for MSI/MSI-X
[   17.544698] ixgbe 0000:03:00.1: irq 144 for MSI/MSI-X
[   17.550350] ixgbe 0000:03:00.1: irq 145 for MSI/MSI-X
[   17.556011] ixgbe 0000:03:00.1: irq 146 for MSI/MSI-X
[   17.561667] ixgbe 0000:03:00.1: irq 147 for MSI/MSI-X
[   17.567319] ixgbe 0000:03:00.1: irq 148 for MSI/MSI-X
[   17.572968] ixgbe 0000:03:00.1: irq 149 for MSI/MSI-X
[   17.578617] ixgbe 0000:03:00.1: irq 150 for MSI/MSI-X
[   17.584268] ixgbe 0000:03:00.1: irq 151 for MSI/MSI-X
[   17.589918] ixgbe 0000:03:00.1: irq 152 for MSI/MSI-X
[   17.595568] ixgbe 0000:03:00.1: irq 153 for MSI/MSI-X
[   17.601218] ixgbe 0000:03:00.1: irq 154 for MSI/MSI-X
[   17.606875] ixgbe 0000:03:00.1: irq 155 for MSI/MSI-X
[   17.612526] ixgbe 0000:03:00.1: irq 156 for MSI/MSI-X
[   17.618179] ixgbe 0000:03:00.1: irq 157 for MSI/MSI-X
[   17.623851] ixgbe 0000:03:00.1: irq 158 for MSI/MSI-X
[   17.629501] ixgbe 0000:03:00.1: irq 159 for MSI/MSI-X
[   17.635151] ixgbe 0000:03:00.1: irq 160 for MSI/MSI-X
[   17.640801] ixgbe 0000:03:00.1: irq 161 for MSI/MSI-X
[   17.646464] ixgbe 0000:03:00.1: irq 162 for MSI/MSI-X
[   17.652117] ixgbe 0000:03:00.1: irq 163 for MSI/MSI-X
[   17.657772] ixgbe 0000:03:00.1: irq 164 for MSI/MSI-X
[   17.663427] ixgbe 0000:03:00.1: irq 165 for MSI/MSI-X
[   17.669077] ixgbe 0000:03:00.1: irq 166 for MSI/MSI-X
[   17.674728] ixgbe 0000:03:00.1: irq 167 for MSI/MSI-X
[   17.680379] ixgbe 0000:03:00.1: irq 168 for MSI/MSI-X
[   17.686030] ixgbe 0000:03:00.1: irq 169 for MSI/MSI-X
[   17.691680] ixgbe 0000:03:00.1: irq 170 for MSI/MSI-X
[   17.697331] ixgbe 0000:03:00.1: irq 171 for MSI/MSI-X
[   17.702984] ixgbe 0000:03:00.1: irq 172 for MSI/MSI-X
[   17.708634] ixgbe 0000:03:00.1: irq 173 for MSI/MSI-X
[   17.714439] ixgbe 0000:03:00.1: Multiqueue Enabled: Rx Queue count = 63, Tx Queue count = 63
[   17.784229] ixgbe 0000:03:00.1: PCI Express bandwidth of 16GT/s available
[   17.791816] ixgbe 0000:03:00.1: (Speed:5.0GT/s, Width: x4, Encoding Loss:20%)
[   17.799783] ixgbe 0000:03:00.1: This is not sufficient for optimal performance of this card.
[   17.809205] ixgbe 0000:03:00.1: For optimal performance, at least 20GT/s of bandwidth is required.
[   17.819209] ixgbe 0000:03:00.1: A slot with more lanes and/or higher speed is suggested.
[   17.989201] ixgbe 0000:03:00.1: MAC: 3, PHY: 3, PBA No: G36748-004
[   17.996108] ixgbe 0000:03:00.1: a0:36:9f:18:d6:aa
[   18.145301] ixgbe 0000:03:00.1: Intel(R) 10 Gigabit Network Connection
[   18.152734] usbcore: registered new interface driver catc
[   18.158777] usbcore: registered new interface driver kaweth
[   18.165003] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   18.173271] usbcore: registered new interface driver pegasus
[   18.179597] usbcore: registered new interface driver rtl8150
[   18.185933] usbcore: registered new interface driver asix
[   18.191970] usbcore: registered new interface driver cdc_ether
[   18.198488] usbcore: registered new interface driver cdc_eem
[   18.204815] usbcore: registered new interface driver dm9601
[   18.211050] usbcore: registered new interface driver smsc75xx
[   18.217484] usbcore: registered new interface driver smsc95xx
[   18.223910] usbcore: registered new interface driver gl620a
[   18.230142] usbcore: registered new interface driver net1080
[   18.236473] usbcore: registered new interface driver plusb
[   18.242605] usbcore: registered new interface driver rndis_host
[   18.249223] usbcore: registered new interface driver cdc_subset
[   18.255842] usbcore: registered new interface driver zaurus
[   18.262072] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   18.270342] usbcore: registered new interface driver int51x1
[   18.276668] usbcore: registered new interface driver ipheth
[   18.282902] usbcore: registered new interface driver sierra_net
[   18.289599] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   18.296899] ehci-pci: EHCI PCI platform driver
[   18.302063] ehci-pci 0000:00:1a.0: EHCI Host Controller
[   18.307984] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   18.316260] ehci-pci 0000:00:1a.0: debug port 2
[   18.325233] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[   18.332824] ehci-pci 0000:00:1a.0: irq 16, io mem 0x93402000
[   18.345065] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   18.351537] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   18.359122] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.367189] usb usb1: Product: EHCI Host Controller
[   18.372637] usb usb1: Manufacturer: Linux 3.17.0-rc1-00017-g89cbc76 ehci_hcd
[   18.380508] usb usb1: SerialNumber: 0000:00:1a.0
[   18.385824] hub 1-0:1.0: USB hub found
[   18.390023] hub 1-0:1.0: 2 ports detected
[   18.394751] IOAPIC[0]: Set routing entry (8-23 -> 0xed -> IRQ 23 Mode:1 Active:1 Dest:6)
[   18.403839] ehci-pci 0000:00:1d.0: EHCI Host Controller
[   18.409755] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   18.418028] ehci-pci 0000:00:1d.0: debug port 2
[   18.427000] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[   18.434594] ehci-pci 0000:00:1d.0: irq 23, io mem 0x93401000
[   18.446066] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   18.452526] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   18.460109] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   18.468176] usb usb2: Product: EHCI Host Controller
[   18.473623] usb usb2: Manufacturer: Linux 3.17.0-rc1-00017-g89cbc76 ehci_hcd
[   18.481494] usb usb2: SerialNumber: 0000:00:1d.0
[   18.486782] hub 2-0:1.0: USB hub found
[   18.490976] hub 2-0:1.0: 2 ports detected
[   18.495606] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   18.502520] ohci-pci: OHCI PCI platform driver
[   18.507520] uhci_hcd: USB Universal Host Controller Interface driver
[   18.514724] usbcore: registered new interface driver usbserial
[   18.521254] usbcore: registered new interface driver usbserial_generic
[   18.528556] usbserial: USB Serial support registered for generic
[   18.535279] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   19.057234] i8042: Can't read CTR while initializing i8042
[   19.063403] i8042: probe of i8042 failed with error -5
[   19.069246] mousedev: PS/2 mouse device common for all mice
[   19.075791] rtc_cmos 00:00: RTC can wake from S4
[   19.081127] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   19.087970] rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   19.096553] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   19.102782] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   19.111631] iTCO_vendor_support: vendor-support=0
[   19.116900] Intel P-state driver initializing.
[   19.121925] Intel pstate controlling: cpu 0
[   19.126667] Intel pstate controlling: cpu 1
[   19.131402] Intel pstate controlling: cpu 2
[   19.136141] Intel pstate controlling: cpu 3
[   19.140877] Intel pstate controlling: cpu 4
[   19.145609] Intel pstate controlling: cpu 5
[   19.150343] Intel pstate controlling: cpu 6
[   19.155074] Intel pstate controlling: cpu 7
[   19.159814] Intel pstate controlling: cpu 8
[   19.164556] Intel pstate controlling: cpu 9
[   19.165082] usb 1-1: new high-speed USB device number 2 using ehci-pci
[   19.176602] Intel pstate controlling: cpu 10
[   19.181435] Intel pstate controlling: cpu 11
[   19.186262] Intel pstate controlling: cpu 12
[   19.191083] Intel pstate controlling: cpu 13
[   19.195914] Intel pstate controlling: cpu 14
[   19.200723] Intel pstate controlling: cpu 15
[   19.205533] Intel pstate controlling: cpu 16
[   19.210336] Intel pstate controlling: cpu 17
[   19.215153] Intel pstate controlling: cpu 18
[   19.219973] Intel pstate controlling: cpu 19
[   19.224786] Intel pstate controlling: cpu 20
[   19.229571] Intel pstate controlling: cpu 21
[   19.234399] Intel pstate controlling: cpu 22
[   19.239260] Intel pstate controlling: cpu 23
[   19.244087] Intel pstate controlling: cpu 24
[   19.248905] Intel pstate controlling: cpu 25
[   19.253744] Intel pstate controlling: cpu 26
[   19.258569] Intel pstate controlling: cpu 27
[   19.263411] Intel pstate controlling: cpu 28
[   19.268242] Intel pstate controlling: cpu 29
[   19.273083] Intel pstate controlling: cpu 30
[   19.277922] Intel pstate controlling: cpu 31
[   19.279454] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[   19.279456] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   19.279842] hub 1-1:1.0: USB hub found
[   19.279943] hub 1-1:1.0: 6 ports detected
[   19.306894] Intel pstate controlling: cpu 32
[   19.311734] Intel pstate controlling: cpu 33
[   19.316602] Intel pstate controlling: cpu 34
[   19.321439] Intel pstate controlling: cpu 35
[   19.326299] Intel pstate controlling: cpu 36
[   19.331139] Intel pstate controlling: cpu 37
[   19.335970] Intel pstate controlling: cpu 38
[   19.340824] Intel pstate controlling: cpu 39
[   19.345653] Intel pstate controlling: cpu 40
[   19.350489] Intel pstate controlling: cpu 41
[   19.355319] Intel pstate controlling: cpu 42
[   19.360151] Intel pstate controlling: cpu 43
[   19.364989] Intel pstate controlling: cpu 44
[   19.369826] Intel pstate controlling: cpu 45
[   19.374667] Intel pstate controlling: cpu 46
[   19.379504] Intel pstate controlling: cpu 47
[   19.383267] usb 2-1: new high-speed USB device number 2 using ehci-pci
[   19.391658] Intel pstate controlling: cpu 48
[   19.396499] Intel pstate controlling: cpu 49
[   19.401347] Intel pstate controlling: cpu 50
[   19.406185] Intel pstate controlling: cpu 51
[   19.411031] Intel pstate controlling: cpu 52
[   19.415869] Intel pstate controlling: cpu 53
[   19.420712] Intel pstate controlling: cpu 54
[   19.425552] Intel pstate controlling: cpu 55
[   19.430399] Intel pstate controlling: cpu 56
[   19.435232] Intel pstate controlling: cpu 57
[   19.440074] Intel pstate controlling: cpu 58
[   19.444911] Intel pstate controlling: cpu 59
[   19.449736] Intel pstate controlling: cpu 60
[   19.454563] Intel pstate controlling: cpu 61
[   19.459385] Intel pstate controlling: cpu 62
[   19.464223] Intel pstate controlling: cpu 63
[   19.469075] Intel pstate controlling: cpu 64
[   19.473911] Intel pstate controlling: cpu 65
[   19.478741] Intel pstate controlling: cpu 66
[   19.483566] Intel pstate controlling: cpu 67
[   19.488397] Intel pstate controlling: cpu 68
[   19.493227] Intel pstate controlling: cpu 69
[   19.498063] Intel pstate controlling: cpu 70
[   19.499501] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[   19.499504] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   19.499985] hub 2-1:1.0: USB hub found
[   19.500069] hub 2-1:1.0: 8 ports detected
[   19.527016] Intel pstate controlling: cpu 71
[   19.531844] Intel pstate controlling: cpu 72
[   19.536686] Intel pstate controlling: cpu 73
[   19.541520] Intel pstate controlling: cpu 74
[   19.546333] Intel pstate controlling: cpu 75
[   19.551156] Intel pstate controlling: cpu 76
[   19.555967] Intel pstate controlling: cpu 77
[   19.560781] Intel pstate controlling: cpu 78
[   19.565598] Intel pstate controlling: cpu 79
[   19.570412] Intel pstate controlling: cpu 80
[   19.575204] Intel pstate controlling: cpu 81
[   19.580015] Intel pstate controlling: cpu 82
[   19.584827] Intel pstate controlling: cpu 83
[   19.589643] Intel pstate controlling: cpu 84
[   19.594455] Intel pstate controlling: cpu 85
[   19.599269] Intel pstate controlling: cpu 86
[   19.604087] Intel pstate controlling: cpu 87
[   19.608906] Intel pstate controlling: cpu 88
[   19.613724] Intel pstate controlling: cpu 89
[   19.618552] Intel pstate controlling: cpu 90
[   19.623383] Intel pstate controlling: cpu 91
[   19.628218] Intel pstate controlling: cpu 92
[   19.633058] Intel pstate controlling: cpu 93
[   19.637907] Intel pstate controlling: cpu 94
[   19.642737] Intel pstate controlling: cpu 95
[   19.647561] Intel pstate controlling: cpu 96
[   19.652390] Intel pstate controlling: cpu 97
[   19.657217] Intel pstate controlling: cpu 98
[   19.662052] Intel pstate controlling: cpu 99
[   19.666876] Intel pstate controlling: cpu 100
[   19.671799] Intel pstate controlling: cpu 101
[   19.676730] Intel pstate controlling: cpu 102
[   19.681652] Intel pstate controlling: cpu 103
[   19.686574] Intel pstate controlling: cpu 104
[   19.691508] Intel pstate controlling: cpu 105
[   19.696452] Intel pstate controlling: cpu 106
[   19.701389] Intel pstate controlling: cpu 107
[   19.706319] Intel pstate controlling: cpu 108
[   19.711250] Intel pstate controlling: cpu 109
[   19.716185] Intel pstate controlling: cpu 110
[   19.721120] Intel pstate controlling: cpu 111
[   19.726056] Intel pstate controlling: cpu 112
[   19.730988] Intel pstate controlling: cpu 113
[   19.735923] Intel pstate controlling: cpu 114
[   19.740856] Intel pstate controlling: cpu 115
[   19.745772] Intel pstate controlling: cpu 116
[   19.750715] Intel pstate controlling: cpu 117
[   19.755648] Intel pstate controlling: cpu 118
[   19.760574] Intel pstate controlling: cpu 119
[   19.768248] hidraw: raw HID events driver (C) Jiri Kosina
[   19.774379] usbcore: registered new interface driver usbhid
[   19.775207] usb 2-1.4: new full-speed USB device number 3 using ehci-pci
[   19.788089] usbhid: USB HID core driver
[   19.792435] drop_monitor: Initializing network drop monitor service
[   19.799760] TCP: cubic registered
[   19.803472] Initializing XFRM netlink socket
[   19.808457] NET: Registered protocol family 10
[   19.814922] NET: Registered protocol family 17
[   19.819906] 9pnet: Installing 9P2000 support
[   19.827415] 
[   19.827415] printing PIC contents
[   19.832770] ... PIC  IMR: ffff
[   19.833764] ... PIC  IRR: 0c20
[   19.839596] ... PIC  ISR: 0000
[   19.842998] ... PIC ELCR: 0e20
[   19.846457] printing local APIC contents on CPU#0/6:
[   19.847448] ... APIC ID:      06000000 (6)
[   19.847448] ... APIC VERSION: 01060015
[   19.847448] ... APIC TASKPRI: 00000000 (00)
[   19.847448] ... APIC PROCPRI: 00000000
[   19.847448] ... APIC LDR: 01000000
[   19.847448] ... APIC DFR: ffffffff
[   19.847448] ... APIC SPIV: 000001ff
[   19.847448] ... APIC ISR field:
[   19.847448] 0000000000000000000000000000000000000000000000000000000000000000
[   19.847448] ... APIC TMR field:
[   19.847448] 0000000000000000000200020000000000000000000000000002000000002000
[   19.847448] ... APIC IRR field:
[   19.847448] 0000000000000000000000000000000000000000000000000000000000008000
[   19.847448] ... APIC ESR: 00000000
[   19.847448] ... APIC ICR: 000000fd
[   19.847448] ... APIC ICR2: 00000000
[   19.847448] ... APIC LVTT: 000400ef
[   19.847448] ... APIC LVTPC: 00000400
[   19.847448] ... APIC LVT0: 00010700
[   19.847448] ... APIC LVT1: 00000400
[   19.847448] ... APIC LVTERR: 000000fe
[   19.847448] ... APIC TMICT: 00000000
[   19.847448] ... APIC TMCCT: 00000000
[   19.847448] ... APIC TDCR: 00000000
[   19.847448] 
[   19.960266] number of MP IRQ sources: 15.
[   19.964747] number of IO-APIC #8 registers: 24.
[   19.969810] number of IO-APIC #9 registers: 24.
[   19.974868] number of IO-APIC #10 registers: 24.
[   19.980024] number of IO-APIC #11 registers: 24.
[   19.985182] number of IO-APIC #12 registers: 24.
[   19.990341] testing the IO APIC.......................
[   19.992073] usb 2-1.4: New USB device found, idVendor=046b, idProduct=ff10
[   19.992076] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   19.992079] usb 2-1.4: Product: Virtual Keyboard and Mouse
[   19.992081] usb 2-1.4: Manufacturer: American Megatrends Inc.
[   19.992083] usb 2-1.4: SerialNumber: serial
[   19.993761] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/0003:046B:FF10.0001/input/input2
[   19.993978] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input0
[   19.995652] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.1/0003:046B:FF10.0002/input/input3
[   19.995888] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input1
[   20.069208] usb 2-1.6: new full-speed USB device number 4 using ehci-pci
[   20.102579] IO APIC #8......
[   20.105798] .... register #00: 08000000
[   20.110079] .......    : physical APIC id: 08
[   20.114944] .......    : Delivery Type: 0
[   20.119423] .......    : LTS          : 0
[   20.123901] .... register #01: 00170020
[   20.128182] .......     : max redirection entries: 17
[   20.133822] .......     : PRQ implemented: 0
[   20.138589] .......     : IO APIC version: 20
[   20.143454] .... IRQ redirection table:
[   20.147742] 1    0    0   0   0    0    0    00
[   20.152805] 0    0    0   0   0    0    0    31
[   20.154884] usb 2-1.6: New USB device found, idVendor=0557, idProduct=8021
[   20.154886] usb 2-1.6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   20.155337] hub 2-1.6:1.0: USB hub found
[   20.155446] hub 2-1.6:1.0: 4 ports detected
[   20.182762] 0    0    0   0   0    0    0    30
[   20.187823] 0    0    0   0   0    0    0    33
[   20.192884] 0    0    0   0   0    0    0    34
[   20.197950] 0    0    0   0   0    0    0    35
[   20.203009] 0    0    0   0   0    0    0    36
[   20.208070] 0    0    0   0   0    0    0    37
[   20.213131] 0    0    0   0   0    0    0    38
[   20.218192] 0    1    0   0   0    0    0    39
[   20.223252] 0    0    0   0   0    0    0    3A
[   20.228314] 0    0    0   0   0    0    0    3B
[   20.233374] 0    0    0   0   0    0    0    3C
[   20.238435] 0    0    0   0   0    0    0    3D
[   20.243494] 0    0    0   0   0    0    0    3E
[   20.248554] 0    0    0   0   0    0    0    3F
[   20.253613] 0    1    0   1   0    0    0    D1
[   20.258677] 1    0    0   0   0    0    0    00
[   20.263740] 1    0    0   0   0    0    0    00
[   20.268802] 1    1    0   1   0    0    0    B1
[   20.273867] 1    0    0   0   0    0    0    00
[   20.278929] 1    0    0   0   0    0    0    00
[   20.283990] 1    0    0   0   0    0    0    00
[   20.289053] 0    1    0   1   0    0    0    ED
[   20.294118] IO APIC #9......
[   20.297333] .... register #00: 09000000
[   20.301614] .......    : physical APIC id: 09
[   20.306478] .......    : Delivery Type: 0
[   20.310952] .......    : LTS          : 0
[   20.315428] .... register #01: 00170020
[   20.319699] .......     : max redirection entries: 17
[   20.325338] .......     : PRQ implemented: 0
[   20.330106] .......     : IO APIC version: 20
[   20.334969] .... register #02: 00000000
[   20.339251] .......     : arbitration: 00
[   20.343727] .... register #03: 00000001
[   20.348008] .......     : Boot DT    : 1
[   20.352387] .... IRQ redirection table:
[   20.356670] 1    0    0   0   0    0    0    00
[   20.361731] 1    0    0   0   0    0    0    00
[   20.366794] 1    0    0   0   0    0    0    00
[   20.371853] 1    0    0   0   0    0    0    00
[   20.376914] 1    0    0   0   0    0    0    00
[   20.381974] 1    0    0   0   0    0    0    00
[   20.387037] 1    0    0   0   0    0    0    00
[   20.392098] 1    0    0   0   0    0    0    00
[   20.397158] 1    0    0   0   0    0    0    00
[   20.402222] 1    0    0   0   0    0    0    00
[   20.407280] 1    0    0   0   0    0    0    00
[   20.412338] 1    0    0   0   0    0    0    00
[   20.417388] 1    0    0   0   0    0    0    00
[   20.418385] usb 2-1.6.1: new low-speed USB device number 5 using ehci-pci
[   20.430031] 1    0    0   0   0    0    0    00
[   20.435090] 1    0    0   0   0    0    0    00
[   20.440160] 1    0    0   0   0    0    0    00
[   20.445224] 1    0    0   0   0    0    0    00
[   20.450290] 1    0    0   0   0    0    0    00
[   20.455351] 1    1    0   1   0    0    0    98
[   20.460411] 1    0    0   0   0    0    0    00
[   20.465471] 1    0    0   0   0    0    0    00
[   20.470533] 1    1    0   1   0    0    0    43
[   20.475591] 1    0    0   0   0    0    0    00
[   20.480650] 1    1    0   1   0    0    0    61
[   20.485709] IO APIC #10......
[   20.489024] .... register #00: 0A000000
[   20.493312] .......    : physical APIC id: 0A
[   20.498179] .......    : Delivery Type: 0
[   20.502655] .......    : LTS          : 0
[   20.507124] .... register #01: 00170020
[   20.511410] .......     : max redirection entries: 17
[   20.517051] .......     : PRQ implemented: 0
[   20.521816] .......     : IO APIC version: 20
[   20.526680] .... register #02: 00000000
[   20.530953] .......     : arbitration: 00
[   20.535428] .... register #03: 00000001
[   20.539712] .......     : Boot DT    : 1
[   20.544092] .... IRQ redirection table:
[   20.548377] 1    0    0   0   0    0    0    00
[   20.553436] 1    0    0   0   0    0    0    00
[   20.554774] usb 2-1.6.1: New USB device found, idVendor=0557, idProduct=2261
[   20.554777] usb 2-1.6.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   20.554779] usb 2-1.6.1: Product: CS1716A V1.0.098
[   20.554782] usb 2-1.6.1: Manufacturer: ATEN International Co. Ltd
[   20.576518] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6.1/2-1.6.1:1.0/0003:0557:2261.0003/input/input4
[   20.576725] hid-generic 0003:0557:2261.0003: input,hidraw2: USB HID v1.00 Keyboard [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.6.1/input0
[   20.597876] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6.1/2-1.6.1:1.1/0003:0557:2261.0004/input/input5
[   20.598086] hid-generic 0003:0557:2261.0004: input,hidraw3: USB HID v1.00 Device [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.6.1/input1
[   20.613153] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6.1/2-1.6.1:1.2/0003:0557:2261.0005/input/input6
[   20.613386] hid-generic 0003:0557:2261.0005: input,hidraw4: USB HID v1.10 Mouse [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.6.1/input2
[   20.684548] 1    0    0   0   0    0    0    00
[   20.689611] 1    0    0   0   0    0    0    00
[   20.694676] 1    0    0   0   0    0    0    00
[   20.699734] 1    0    0   0   0    0    0    00
[   20.704798] 1    0    0   0   0    0    0    00
[   20.709862] 1    0    0   0   0    0    0    00
[   20.714927] 1    0    0   0   0    0    0    00
[   20.719991] 1    0    0   0   0    0    0    00
[   20.725056] 1    0    0   0   0    0    0    00
[   20.730119] 1    0    0   0   0    0    0    00
[   20.735183] 1    0    0   0   0    0    0    00
[   20.740247] 1    0    0   0   0    0    0    00
[   20.745307] 1    0    0   0   0    0    0    00
[   20.750372] 1    0    0   0   0    0    0    00
[   20.755436] 1    0    0   0   0    0    0    00
[   20.760500] 1    0    0   0   0    0    0    00
[   20.765563] 1    0    0   0   0    0    0    00
[   20.770627] 1    0    0   0   0    0    0    00
[   20.775692] 1    0    0   0   0    0    0    00
[   20.780747] 1    0    0   0   0    0    0    00
[   20.785812] 1    0    0   0   0    0    0    00
[   20.790876] 1    1    0   1   0    0    0    42
[   20.795942] IO APIC #11......
[   20.799250] .... register #00: 0B000000
[   20.803537] .......    : physical APIC id: 0B
[   20.808407] .......    : Delivery Type: 0
[   20.812888] .......    : LTS          : 0
[   20.817370] .... register #01: 00170020
[   20.821656] .......     : max redirection entries: 17
[   20.827300] .......     : PRQ implemented: 0
[   20.832072] .......     : IO APIC version: 20
[   20.836940] .... register #02: 00000000
[   20.841244] .......     : arbitration: 00
[   20.845725] .... register #03: 00000001
[   20.850011] .......     : Boot DT    : 1
[   20.854395] .... IRQ redirection table:
[   20.858682] 1    0    0   0   0    0    0    00
[   20.863746] 1    0    0   0   0    0    0    00
[   20.868808] 1    0    0   0   0    0    0    00
[   20.873872] 1    0    0   0   0    0    0    00
[   20.878936] 1    0    0   0   0    0    0    00
[   20.883997] 1    0    0   0   0    0    0    00
[   20.889058] 1    0    0   0   0    0    0    00
[   20.894121] 1    0    0   0   0    0    0    00
[   20.899184] 1    0    0   0   0    0    0    00
[   20.904248] 1    0    0   0   0    0    0    00
[   20.909311] 1    0    0   0   0    0    0    00
[   20.914375] 1    0    0   0   0    0    0    00
[   20.919441] 1    0    0   0   0    0    0    00
[   20.924503] 1    0    0   0   0    0    0    00
[   20.929569] 1    0    0   0   0    0    0    00
[   20.934632] 1    0    0   0   0    0    0    00
[   20.939697] 1    0    0   0   0    0    0    00
[   20.944761] 1    0    0   0   0    0    0    00
[   20.949824] 1    0    0   0   0    0    0    00
[   20.954887] 1    0    0   0   0    0    0    00
[   20.959950] 1    0    0   0   0    0    0    00
[   20.965013] 1    0    0   0   0    0    0    00
[   20.970077] 1    0    0   0   0    0    0    00
[   20.975142] 1    1    0   1   0    0    0    82
[   20.980207] IO APIC #12......
[   20.983523] .... register #00: 0C000000
[   20.987809] .......    : physical APIC id: 0C
[   20.992674] .......    : Delivery Type: 0
[   20.997152] .......    : LTS          : 0
[   21.001633] .... register #01: 00170020
[   21.005922] .......     : max redirection entries: 17
[   21.011568] .......     : PRQ implemented: 0
[   21.016336] .......     : IO APIC version: 20
[   21.021203] .... register #02: 00000000
[   21.025490] .......     : arbitration: 00
[   21.029972] .... register #03: 00000001
[   21.034256] .......     : Boot DT    : 1
[   21.038636] .... IRQ redirection table:
[   21.042926] 1    0    0   0   0    0    0    00
[   21.047988] 1    0    0   0   0    0    0    00
[   21.053053] 1    0    0   0   0    0    0    00
[   21.058115] 1    0    0   0   0    0    0    00
[   21.063180] 1    0    0   0   0    0    0    00
[   21.068244] 1    0    0   0   0    0    0    00
[   21.073309] 1    0    0   0   0    0    0    00
[   21.078373] 1    0    0   0   0    0    0    00
[   21.083439] 1    0    0   0   0    0    0    00
[   21.088503] 1    0    0   0   0    0    0    00
[   21.093567] 1    0    0   0   0    0    0    00
[   21.098632] 1    0    0   0   0    0    0    00
[   21.103697] 1    0    0   0   0    0    0    00
[   21.108759] 1    0    0   0   0    0    0    00
[   21.113823] 1    0    0   0   0    0    0    00
[   21.118887] 1    0    0   0   0    0    0    00
[   21.123951] 1    0    0   0   0    0    0    00
[   21.129013] 1    0    0   0   0    0    0    00
[   21.134080] 1    0    0   0   0    0    0    00
[   21.139143] 1    0    0   0   0    0    0    00
[   21.144207] 1    0    0   0   0    0    0    00
[   21.149271] 1    0    0   0   0    0    0    00
[   21.154333] 1    0    0   0   0    0    0    00
[   21.159397] 1    1    0   1   0    0    0    C2
[   21.164459] IRQ to pin mappings:
[   21.168066] IRQ0 -> 0:2
[   21.170825] IRQ1 -> 0:1
[   21.173590] IRQ3 -> 0:3
[   21.176340] IRQ4 -> 0:4
[   21.179101] IRQ5 -> 0:5
[   21.181847] IRQ6 -> 0:6
[   21.184611] IRQ7 -> 0:7
[   21.187351] IRQ8 -> 0:8
[   21.190110] IRQ9 -> 0:9
[   21.192868] IRQ10 -> 0:10
[   21.195827] IRQ11 -> 0:11
[   21.198785] IRQ12 -> 0:12
[   21.201742] IRQ13 -> 0:13
[   21.204690] IRQ14 -> 0:14
[   21.207646] IRQ15 -> 0:15
[   21.210605] IRQ16 -> 0:16
[   21.213555] IRQ19 -> 0:19
[   21.216509] IRQ23 -> 0:23
[   21.219467] IRQ24 -> 1:23
[   21.222420] IRQ32 -> 2:23
[   21.225372] IRQ36 -> 3:23
[   21.228328] IRQ40 -> 4:23
[   21.231279] IRQ44 -> 1:21
[   21.234232] IRQ109 -> 1:18
[   21.237286] .................................... done.
[   21.243228] Loading compiled-in X.509 certificates
[   21.249351] Loaded X.509 cert 'Magrathea: Glacier signing key: 71e44fd284b3151af7f9495a22edc2376992cddc'
[   21.260136] registered taskstats version 1
[   21.269496] Key type trusted registered
[   21.277539] Key type encrypted registered
[   21.351184] evm: HMAC attrs: 0x1
[   21.358306] rtc_cmos 00:00: setting system clock to 2014-10-06 04:03:44 UTC (1412568224)
[   21.646083] pps pps0: new PPS source ptp0
[   21.650580] ixgbe 0000:03:00.0: registered PHC device on eth0
[   22.062027] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   22.346254] pps pps1: new PPS source ptp1
[   22.350743] ixgbe 0000:03:00.1: registered PHC device on eth1
[   22.761347] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   24.895918] ixgbe 0000:03:00.0 eth0: NIC Link is Up 1 Gbps, Flow Control: RX/TX
[   24.906676] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   24.917077] Sending DHCP requests .., OK
[   28.391249] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.140
[   28.401146] ixgbe 0000:03:00.1: removed PHC on eth1
[   28.818293] IP-Config: Complete:
[   28.821918]      device=eth0, hwaddr=a0:36:9f:18:d6:a8, ipaddr=192.168.1.140, mask=255.255.255.0, gw=192.168.1.1
[   28.833291]      host=brickland3, domain=lkp.intel.com, nis-domain=(none)
[   28.840877]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   28.848371]      nameserver0=192.168.1.1
[   28.852993] PM: Hibernation image not present or could not be loaded.
[   28.863911] Freeing unused kernel memory: 1804K (ffffffff81dde000 - ffffffff81fa1000)
[   29.285075] ipmi message handler version 39.2
[   29.295526] IPMI System Interface driver.
[   29.300594] ipmi_si: probing via ACPI
[   29.304714] ipmi_si 00:04: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0
[   29.312209] ipmi_si: Adding ACPI-specified kcs state machine
[   29.318604] ipmi_si: probing via SMBIOS
[   29.319238] wmi: Mapper loaded
[   29.326301] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   29.332917] ipmi_si: Adding SMBIOS-specified kcs state machine duplicate interface
[   29.341399] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   29.353413] IOAPIC[0]: Set routing entry (8-18 -> 0x2e -> IRQ 18 Mode:1 Active:1 Dest:6)
[   29.362661] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   29.377741] EDAC MC: Ver: 3.0.0
[   29.379591] libata version 3.00 loaded.
[   29.387909] [drm] Initialized drm 1.1.0 20060810
[   29.399366] EDAC sbridge: Seeking for: PCI ID 8086:0ea0
[   29.405185] EDAC sbridge: Seeking for: PCI ID 8086:0ea0
[   29.411035] EDAC sbridge: Seeking for: PCI ID 8086:0ea0
[   29.416892] EDAC sbridge: Seeking for: PCI ID 8086:0ea0
[   29.422741] EDAC sbridge: Seeking for: PCI ID 8086:0ea0
[   29.428591] EDAC sbridge: Seeking for: PCI ID 8086:0ea8
[   29.434444] EDAC sbridge: Seeking for: PCI ID 8086:0ea8
[   29.440306] EDAC sbridge: Seeking for: PCI ID 8086:0ea8
[   29.444289] ipmi_si 00:04: Found new BMC (man_id: 0x000157, prod_id: 0x0063, dev_id: 0x21)
[   29.444294] ipmi_si 00:04: IPMI kcs interface initialized
[   29.461412] EDAC sbridge: Seeking for: PCI ID 8086:0ea8
[   29.467246] EDAC sbridge: Seeking for: PCI ID 8086:0ea8
[   29.473086] EDAC sbridge: Seeking for: PCI ID 8086:0e71
[   29.478926] EDAC sbridge: Seeking for: PCI ID 8086:0e71
[   29.479239] ahci 0000:00:1f.2: version 3.0
[   29.479468] ahci 0000:00:1f.2: irq 174 for MSI/MSI-X
[   29.479541] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x10 impl SATA mode
[   29.479543] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[   29.480615] scsi host0: ahci
[   29.480807] scsi host1: ahci
[   29.480974] scsi host2: ahci
[   29.481153] scsi host3: ahci
[   29.481324] scsi host4: ahci
[   29.481495] scsi host5: ahci
[   29.481526] ata1: DUMMY
[   29.481527] ata2: DUMMY
[   29.481527] ata3: DUMMY
[   29.481527] ata4: DUMMY
[   29.481529] ata5: SATA max UDMA/133 abar m2048@0x93400000 port 0x93400300 irq 174
[   29.481529] ata6: DUMMY
[   29.532369] mpt2sas version 16.100.00.00 loaded
[   29.533248] IOAPIC[1]: Set routing entry (9-8 -> 0x5e -> IRQ 175 Mode:1 Active:1 Dest:6)
[   29.533265] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (528273268 kB)
[   29.533316] mpt2sas 0000:01:00.0: irq 176 for MSI/MSI-X
[   29.533330] mpt2sas 0000:01:00.0: irq 177 for MSI/MSI-X
[   29.533343] mpt2sas 0000:01:00.0: irq 178 for MSI/MSI-X
[   29.533356] mpt2sas 0000:01:00.0: irq 179 for MSI/MSI-X
[   29.533379] mpt2sas 0000:01:00.0: irq 180 for MSI/MSI-X
[   29.533392] mpt2sas 0000:01:00.0: irq 181 for MSI/MSI-X
[   29.533415] mpt2sas 0000:01:00.0: irq 182 for MSI/MSI-X
[   29.533427] mpt2sas 0000:01:00.0: irq 183 for MSI/MSI-X
[   29.533439] mpt2sas 0000:01:00.0: irq 184 for MSI/MSI-X
[   29.533451] mpt2sas 0000:01:00.0: irq 185 for MSI/MSI-X
[   29.533464] mpt2sas 0000:01:00.0: irq 186 for MSI/MSI-X
[   29.533476] mpt2sas 0000:01:00.0: irq 187 for MSI/MSI-X
[   29.533487] mpt2sas 0000:01:00.0: irq 188 for MSI/MSI-X
[   29.533500] mpt2sas 0000:01:00.0: irq 189 for MSI/MSI-X
[   29.533512] mpt2sas 0000:01:00.0: irq 190 for MSI/MSI-X
[   29.533552] mpt2sas 0000:01:00.0: irq 191 for MSI/MSI-X
[   29.533679] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 176
[   29.533680] mpt2sas0-msix1: PCI-MSI-X enabled: IRQ 177
[   29.533682] mpt2sas0-msix2: PCI-MSI-X enabled: IRQ 178
[   29.533683] mpt2sas0-msix3: PCI-MSI-X enabled: IRQ 179
[   29.533683] mpt2sas0-msix4: PCI-MSI-X enabled: IRQ 180
[   29.533684] mpt2sas0-msix5: PCI-MSI-X enabled: IRQ 181
[   29.533684] mpt2sas0-msix6: PCI-MSI-X enabled: IRQ 182
[   29.533684] mpt2sas0-msix7: PCI-MSI-X enabled: IRQ 183
[   29.533685] mpt2sas0-msix8: PCI-MSI-X enabled: IRQ 184
[   29.533685] mpt2sas0-msix9: PCI-MSI-X enabled: IRQ 185
[   29.533686] mpt2sas0-msix10: PCI-MSI-X enabled: IRQ 186
[   29.533686] mpt2sas0-msix11: PCI-MSI-X enabled: IRQ 187
[   29.533686] mpt2sas0-msix12: PCI-MSI-X enabled: IRQ 188
[   29.533687] mpt2sas0-msix13: PCI-MSI-X enabled: IRQ 189
[   29.533687] mpt2sas0-msix14: PCI-MSI-X enabled: IRQ 190
[   29.533688] mpt2sas0-msix15: PCI-MSI-X enabled: IRQ 191
[   29.533689] mpt2sas0: iomem(0x0000000093340000), mapped(0xffffc90042540000), size(65536)
[   29.533690] mpt2sas0: ioport(0x0000000000001000), size(256)
[   29.648137] mpt2sas0: Allocated physical memory: size(7101 kB)
[   29.648137] mpt2sas0: Current Controller Queue Depth(2811), Max Controller Queue Depth(3072)
[   29.648138] mpt2sas0: Scatter Gather Elements per IO(128)
[   29.656542] [TTM] Zone  kernel: Available graphics memory: 264136634 kiB
[   29.656543] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   29.656544] [TTM] Initializing pool allocator
[   29.656557] [TTM] Initializing DMA pool allocator
[   29.706535] mpt2sas0: LSISAS2308: FWVersion(15.00.00.00), ChipRevision(0x05), BiosVersion(07.29.01.00)
[   29.706538] mpt2sas0: Protocol=(Initiator), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[   29.706601] scsi host6: Fusion MPT SAS Host
[   29.706989] mpt2sas0: sending port enable !!
[   29.786097] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   29.787940] ata5.00: ATAPI: TEAC    DV-W28S-W, 1.0A, max UDMA/100
[   29.790034] ata5.00: configured for UDMA/100
[   29.790775] scsi: waiting for bus probes to complete ...
[   29.882073] EDAC sbridge: Seeking for: PCI ID 8086:0e71
[   29.882080] EDAC sbridge: Seeking for: PCI ID 8086:0e71
[   29.882088] EDAC sbridge: Seeking for: PCI ID 8086:0e71
[   29.882094] EDAC sbridge: Seeking for: PCI ID 8086:0eaa
[   29.882098] fbcon: mgadrmfb (fb0) is primary device
[   29.882099] EDAC sbridge: Seeking for: PCI ID 8086:0eaa
[   29.882104] EDAC sbridge: Seeking for: PCI ID 8086:0eaa
[   29.882108] EDAC sbridge: Seeking for: PCI ID 8086:0eaa
[   29.882114] EDAC sbridge: Seeking for: PCI ID 8086:0eaa
[   29.882117] EDAC sbridge: Seeking for: PCI ID 8086:0eab
[   29.882121] EDAC sbridge: Seeking for: PCI ID 8086:0eab
[   29.882126] EDAC sbridge: Seeking for: PCI ID 8086:0eab
[   29.882131] EDAC sbridge: Seeking for: PCI ID 8086:0eab
[   29.882136] EDAC sbridge: Seeking for: PCI ID 8086:0eab
[   29.882140] EDAC sbridge: Seeking for: PCI ID 8086:0eac
[   29.882143] EDAC sbridge: Seeking for: PCI ID 8086:0eac
[   29.882148] EDAC sbridge: Seeking for: PCI ID 8086:0eac
[   29.882152] EDAC sbridge: Seeking for: PCI ID 8086:0eac
[   29.882157] EDAC sbridge: Seeking for: PCI ID 8086:0eac
[   29.882160] EDAC sbridge: Seeking for: PCI ID 8086:0ead
[   29.882164] EDAC sbridge: Seeking for: PCI ID 8086:0ead
[   29.882169] EDAC sbridge: Seeking for: PCI ID 8086:0ead
[   29.882174] EDAC sbridge: Seeking for: PCI ID 8086:0ead
[   29.882179] EDAC sbridge: Seeking for: PCI ID 8086:0ead
[   29.882182] EDAC sbridge: Seeking for: PCI ID 8086:0ec8
[   29.882186] EDAC sbridge: Seeking for: PCI ID 8086:0ec8
[   29.882190] EDAC sbridge: Seeking for: PCI ID 8086:0ec8
[   29.882195] EDAC sbridge: Seeking for: PCI ID 8086:0ec8
[   29.882199] EDAC sbridge: Seeking for: PCI ID 8086:0ec8
[   29.882202] EDAC sbridge: Seeking for: PCI ID 8086:0ec9
[   29.882205] EDAC sbridge: Seeking for: PCI ID 8086:0ec9
[   29.882210] EDAC sbridge: Seeking for: PCI ID 8086:0ec9
[   29.882214] EDAC sbridge: Seeking for: PCI ID 8086:0ec9
[   29.882218] EDAC sbridge: Seeking for: PCI ID 8086:0ec9
[   29.882221] EDAC sbridge: Seeking for: PCI ID 8086:0eca
[   29.882225] EDAC sbridge: Seeking for: PCI ID 8086:0eca
[   29.882230] EDAC sbridge: Seeking for: PCI ID 8086:0eca
[   29.882234] EDAC sbridge: Seeking for: PCI ID 8086:0eca
[   29.882239] EDAC sbridge: Seeking for: PCI ID 8086:0eca
[   29.882241] EDAC sbridge: Seeking for: PCI ID 8086:0e60
[   29.882245] EDAC sbridge: Seeking for: PCI ID 8086:0e60
[   29.882251] EDAC sbridge: Seeking for: PCI ID 8086:0e60
[   29.882255] EDAC sbridge: Seeking for: PCI ID 8086:0e60
[   29.882260] EDAC sbridge: Seeking for: PCI ID 8086:0e60
[   29.882263] EDAC sbridge: Seeking for: PCI ID 8086:0e6a
[   29.882267] EDAC sbridge: Seeking for: PCI ID 8086:0e6a
[   29.882272] EDAC sbridge: Seeking for: PCI ID 8086:0e6a
[   29.882277] EDAC sbridge: Seeking for: PCI ID 8086:0e6a
[   29.882282] EDAC sbridge: Seeking for: PCI ID 8086:0e6a
[   29.882284] EDAC sbridge: Seeking for: PCI ID 8086:0e6b
[   29.882288] EDAC sbridge: Seeking for: PCI ID 8086:0e6b
[   29.882293] EDAC sbridge: Seeking for: PCI ID 8086:0e6b
[   29.882298] EDAC sbridge: Seeking for: PCI ID 8086:0e6b
[   29.882303] EDAC sbridge: Seeking for: PCI ID 8086:0e6b
[   29.882305] EDAC sbridge: Seeking for: PCI ID 8086:0eb8
[   29.882317] EDAC sbridge: Seeking for: PCI ID 8086:0ebc
[   29.882526] EDAC MC0: Giving out device to module sbridge_edac.c controller Ivy Bridge Socket#0: DEV 0000:ff:0e.0 (POLLED)
[   29.882696] EDAC MC1: Giving out device to module sbridge_edac.c controller Ivy Bridge Socket#1: DEV 0000:bf:0e.0 (POLLED)
[   29.882851] EDAC MC2: Giving out device to module sbridge_edac.c controller Ivy Bridge Socket#2: DEV 0000:7f:0e.0 (POLLED)
[   29.883048] EDAC MC3: Giving out device to module sbridge_edac.c controller Ivy Bridge Socket#3: DEV 0000:3f:0e.0 (POLLED)
[   29.883048] EDAC sbridge: Driver loaded.
[   30.031693] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   30.053157] Error: Driver 'pcspkr' is already registered, aborting...
[   30.099035] Console: switching to colour frame buffer device 160x64
[   30.546315] mgag200 0000:08:00.0: fb0: mgadrmfb frame buffer device
[   30.553525] mgag200 0000:08:00.0: registered panic notifier
[   30.563216] [drm] Initialized mgag200 1.0.0 20110418 for 0000:08:00.0 on minor 0
[   31.312392] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b005c3d950), phys(8)
[   37.440100] mpt2sas0: port enable: SUCCESS
[   37.445725] scsi 6:1:0:0: Direct-Access     LSI      Logical Volume   3000 PQ: 0 ANSI: 6
[   37.455750] scsi 6:1:0:0: RAID1: handle(0x011e), wwid(0x0d15c5313ce972cd), pd_count(2), type(SSP)
[   37.466250] scsi 6:1:0:0: qdepth(128), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[   37.478248] scsi 6:0:0:0: Direct-Access     SEAGATE  ST930005SSUN300G 0606 PQ: 0 ANSI: 6
[   37.490810] scsi 6:0:0:0: SSP: handle(0x0009), sas_addr(0x5000c500486853f9), phy(2), device_name(0x5000c500486853f8)
[   37.490816] scsi 6:0:0:0: SSP: enclosure_logical_id(0x500605b005c3d950), slot(1)
[   37.490824] scsi 6:0:0:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[   37.495378] scsi 6:0:1:0: Direct-Access     SEAGATE  ST930005SSUN300G 0606 PQ: 0 ANSI: 6
[   37.496041] scsi 6:0:1:0: SSP: handle(0x000a), sas_addr(0x5000c5004868a5bd), phy(3), device_name(0x5000c5004868a5bc)
[   37.496045] scsi 6:0:1:0: SSP: enclosure_logical_id(0x500605b005c3d950), slot(0)
[   37.496051] scsi 6:0:1:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[   37.501534] scsi 4:0:0:0: CD-ROM            TEAC     DV-W28S-W        1.0A PQ: 0 ANSI: 5
[   37.672954] sd 6:1:0:0: [sda] 583983104 512-byte logical blocks: (298 GB/278 GiB)
[   37.675113] sr 4:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   37.675115] cdrom: Uniform CD-ROM driver Revision: 3.20
[   37.675327] sr 4:0:0:0: Attached scsi CD-ROM sr0
[   37.705806] sd 6:1:0:0: [sda] 4096-byte physical blocks
[   37.713913] sd 6:1:0:0: [sda] Write Protect is off
[   37.714065] sd 6:1:0:0: Attached scsi generic sg0 type 0
[   37.714148] scsi 6:0:0:0: Attached scsi generic sg1 type 0
[   37.714215] scsi 6:0:1:0: Attached scsi generic sg2 type 0
[   37.714411] sr 4:0:0:0: Attached scsi generic sg3 type 5
[   37.747117] sd 6:1:0:0: [sda] Mode Sense: 03 00 00 08
[   37.753480] sd 6:1:0:0: [sda] No Caching mode page found
[   37.760047] sd 6:1:0:0: [sda] Assuming drive cache: write through
[   37.793910]  sda: sda1 sda2 sda9
[   37.799822] sd 6:1:0:0: [sda] Attached SCSI disk
[   37.811237] random: nonblocking pool is initialized
[   39.491538] hrtimer: interrupt took 3335131 ns

==> /lkp/lkp/src/tmp/run_log <==

==> /lkp/lkp/src/tmp/err_log <==

==> /lkp/lkp/src/tmp/run_log <==
 6 Oct 04:04:09 ntpdate[3030]: step time server 192.168.1.1 offset 0.255419 sec
Kernel tests: Boot OK!
LKP: HOSTNAME brickland3, MAC a0:36:9f:18:d6:a8, kernel 3.17.0-rc1-00017-g89cbc76 1, serial console /dev/ttyS0
/lkp/lkp/src/bin/run-lkp
[   46.272049] IPMI Watchdog: driver initialized
Stopping watchdog keepalive daemon....
Starting watchdog daemon....
RESULT_ROOT=/result/brickland3/aim9/performance-300s-mem_rtns_2/debian-x86_64.cgz/x86_64-rhel/89cbc76768c2fa4ed95545bf961f3a14ddfeed21/0
job=/lkp/scheduled/brickland3/bisect_aim9-performance-300s-mem_rtns_2-x86_64-rhel-89cbc76768c2fa4ed95545bf961f3a14ddfe
[   46.307472] IPMI message handler: BMC returned incorrect response, expected netfn 7 cmd 22, got netfn 7 cmd 25
ed21-0.yaml
[   46.307473] IPMI Watchdog: response: Error ff on cmd 22
run-job /lkp/scheduled/brickland3/bisect_aim9-performance-300s-mem_rtns_2-x86_64-rhel-89cbc76768c2fa4ed95545bf961f3a14ddfeed21-0.yaml
run: /lkp/lkp/src/setup/cpufreq_governor performance	{}
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu100/cpufreq/scaling_governor
run: /lkp/lkp/src/monitors/wrapper watch-oom	{}
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu101/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu102/cpufreq/scaling_governor
run: /lkp/lkp/src/monitors/event/wait pre-test	{}
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu103/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu104/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu105/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu106/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu107/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu108/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu109/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu110/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu111/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu112/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu113/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu114/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu115/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu116/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu117/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu118/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu119/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu12/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu13/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu14/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu15/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu16/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu17/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu18/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu19/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu20/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu21/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu22/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu23/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu24/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu25/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu26/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu27/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu28/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu29/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu30/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu31/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu32/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu33/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu34/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu35/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu36/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu37/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu38/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu39/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu40/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu41/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu42/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu43/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu44/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu45/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu46/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu47/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu48/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu49/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu50/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu51/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu52/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu53/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu54/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu55/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu56/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu57/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu58/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu59/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu60/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu61/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu62/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu63/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu64/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu65/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu66/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu67/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu68/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu69/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu70/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu71/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu72/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu73/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu74/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu75/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu76/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu77/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu78/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu79/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu80/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu81/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu82/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu83/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu84/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu85/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu86/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu87/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu88/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu89/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu90/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu91/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu92/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu93/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu94/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu95/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu96/cpufreq/scaling_governor
2014-10-06 04:04:10 echo performance > /sys/devices/system/cpu/cpu97/cpufreq/scali
[   47.953720] BUG: unable to handle kernel PROGRESS CODE: V3020003 I0
Loading PEIM at 0x000FFFD57C0 EntryPoint=0x000FFFD673C 

--yrj/dFKFPuw6o+aM--
