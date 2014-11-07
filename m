Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaKGGk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:40:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:18529 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaKGGkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:40:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,330,1413270000"; 
   d="scan'208";a="618692447"
Date: Fri, 7 Nov 2014 14:40:27 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [LKP] [x86_64,entry] f04e05b81e4: -62.7% time.user_time
Message-ID: <20141107064027.GA24745@yliu-dev.sh.intel.com>
References: <20141107060040.GD30507@yliu-dev.sh.intel.com>
 <CALCETrVBcZ=5YJMzjKwFpjz6p32FmXcdkR=8uSPm8kCECDka4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrVBcZ=5YJMzjKwFpjz6p32FmXcdkR=8uSPm8kCECDka4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 06, 2014 at 10:26:23PM -0800, Andy Lutomirski wrote:
> On Thu, Nov 6, 2014 at 10:00 PM, LKP <lkp@01.org> wrote:
> > FYI, we noticed the below changes on
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/entry
> > commit f04e05b81e4d9ae88bee379f12176f551a24394a ("x86_64,entry: Use sysret to return to userspace when possible")
> >
> >
> > f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  testbox/testcase/testparams
> > ----------------  --------------------------
> >          %stddev     %change         %stddev
> >              \          |                \
> >      24.09 ±  4%     -62.7%       8.99 ±  3%  lkp-wsx02/aim9/performance-300s-creat-clo
> >      24.09           -62.7%       8.99        GEO-MEAN time.user_time
> >
> 
> I don't really know how to interpret this.  Is this a good thing or a bad thing?

TBH, I don't, either. Here we just list the changes we captured, which
is then for your information to decide it's good or bad.

> 
> I actually expect this change to be a dramatic speedup for some
> workloads. 

Would you like to share your workload? If so, I can add them to our
testing system, and give feedback to you when datat is available.

> Any chance you can send me the .config, kernel command
> line, and whether you have any tracing features enabled?

.config and dmesg are attached.

	--yliu

--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc3-wl-ath-g7c130ce (kbuild@cairo) (gcc version 4.9.1 (Debian 4.9.1-19) ) #1 SMP Thu Nov 6 00:20:08 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-wsx02/cyclic_aim9-performance-300s-creat-clo-x86_64-rhel-HEAD-7c130ce86d3169fb078ea36d2351a9bc5394f7bf-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/7c130ce86d3169fb078ea36d2351a9bc5394f7bf/vmlinuz-3.18.0-rc3-wl-ath-g7c130ce kconfig=x86_64-rhel commit=7c130ce86d3169fb078ea36d2351a9bc5394f7bf branch=linux-devel/devel-hourly-2014110522 root=/dev/ram0 max_uptime=1393 RESULT_ROOT=/result/lkp-wsx02/aim9/performance-300s-creat-clo/debian-x86_64.cgz/x86_64-rhel/7c130ce86d3169fb078ea36d2351a9bc5394f7bf/0 ip=::::lkp-wsx02::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009b3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009b400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007b451fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b452000-0x000000007b454fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007b455000-0x000000007b68ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b690000-0x000000007b69efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b69f000-0x000000007b6a1fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007b6a2000-0x000000007b6a6fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b6a7000-0x000000007b7bcfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007b7bd000-0x000000007ba3cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007ba3d000-0x000000007baa7fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007baa8000-0x000000007bcfffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bd00000-0x000000007bd16fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007bd17000-0x000000007bd19fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bd1a000-0x000000007bd49fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007bd4a000-0x000000007bd5efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bd5f000-0x000000007bdfefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007bdff000-0x000000007bdfffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007be00000-0x000000007be4efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007be4f000-0x000000007bf70fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bf71000-0x000000007bfcefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007bfcf000-0x000000007bffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bfff000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI:  , BIOS QSSC-S4R.QCI.01.00.0030.031120111710 03/11/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x2080000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-through
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00080000000 mask FFF80000000 uncachable
[    0.000000]   1 base FC000000000 mask FFF00000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] e820: last_pfn = 0x7b452 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fd9e0-0x000fd9ef] mapped at [ffff8800000fd9e0]
[    0.000000]   mpc: efc20-eff2c
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x207f1d0000, 0x207f1d0fff] PGTABLE
[    0.000000] BRK [0x207f1d1000, 0x207f1d1fff] PGTABLE
[    0.000000] BRK [0x207f1d2000, 0x207f1d2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x207fe00000-0x207fffffff]
[    0.000000]  [mem 0x207fe00000-0x207fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x207c000000-0x207fdfffff]
[    0.000000]  [mem 0x207c000000-0x207fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x2000000000-0x207bffffff]
[    0.000000]  [mem 0x2000000000-0x207bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x1fffffffff]
[    0.000000]  [mem 0x1000000000-0x1fffffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7b451fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7b3fffff] page 2M
[    0.000000]  [mem 0x7b400000-0x7b451fff] page 4k
[    0.000000] BRK [0x207f1d3000, 0x207f1d3fff] PGTABLE
[    0.000000] BRK [0x207f1d4000, 0x207f1d4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x2076661000-0x207dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 QUANTA)
[    0.000000] ACPI: XSDT 0x000000007BFFE120 0000BC (v01 QUANTA QSSC-S4R 00000000      01000013)
[    0.000000] ACPI: FACP 0x000000007BFFD000 0000F4 (v04 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: DSDT 0x000000007BFE1000 01B7B5 (v02 QUANTA QSSC-S4R 00000003 MSFT 0100000D)
[    0.000000] ACPI: FACS 0x000000007BF71000 000040
[    0.000000] ACPI: APIC 0x000000007BFE0000 0004C4 (v02 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MSCT 0x000000007BFDF000 000090 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: MCFG 0x000000007BFDE000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: HPET 0x000000007BFDD000 000038 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SLIT 0x000000007BFDC000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SRAT 0x000000007BFDB000 000A30 (v02 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SPCR 0x000000007BFDA000 000050 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: WDDT 0x000000007BFD9000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: SSDT 0x000000007BF24000 04C744 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x000000007BFD8000 000174 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: PMCT 0x000000007BFD7000 000060 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MIGT 0x000000007BFD6000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: TCPA 0x000000007BFD3000 000032 (v00 QUANTA QSSC-S4R 00000000      00000000)
[    0.000000] ACPI: HEST 0x000000007BFD2000 0000A8 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 0x000000007BFD1000 000030 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 0x000000007BFD0000 000230 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 0x000000007BFCF000 000130 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: DMAR 0x000000007BF23000 0002F8 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Setting APIC routing to cluster x2apic.
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x20 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x21 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x22 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x23 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x24 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x25 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x30 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x31 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x32 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x33 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x40 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x41 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x42 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x43 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x44 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x45 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x50 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x51 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x52 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x53 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x60 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x61 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x62 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x63 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x64 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x65 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x70 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x71 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x72 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x73 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x80 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x81 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x82 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x83 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x84 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x85 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x90 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x91 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x92 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x93 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0xa0 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0xa1 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0xa2 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0xa3 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0xa4 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0xa5 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0xb0 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0xb1 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0xb2 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0xb3 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0xc0 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xc1 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xc2 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xc3 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xc4 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xc5 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xd0 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xd1 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xd2 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xd3 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xe0 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xe1 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xe2 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xe3 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xe4 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xe5 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xf0 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xf1 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xf2 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0xf3 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x87fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x880000000-0x107fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x1080000000-0x187fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x1880000000-0x207fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x2100000000-0x40ffffffff] hotplug
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x4100000000-0x60ffffffff] hotplug
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x6100000000-0x80ffffffff] hotplug
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x8100000000-0xa0ffffffff] hotplug
[    0.000000] SRAT: Node 2 PXM 2 [mem 0xa100000000-0xc0ffffffff] hotplug
[    0.000000] SRAT: Node 2 PXM 2 [mem 0xc100000000-0xe0ffffffff] hotplug
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xe100000000-0x100ffffffff] hotplug
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x10100000000-0x120ffffffff] hotplug
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x87ffda000-0x87fffffff]
[    0.000000] NODE_DATA(1) allocated [mem 0x107ffda000-0x107fffffff]
[    0.000000] NODE_DATA(2) allocated [mem 0x187ffda000-0x187fffffff]
[    0.000000] NODE_DATA(3) allocated [mem 0x207ffd9000-0x207fffefff]
[    0.000000]  [ffffea0000000000-ffffea0021ffffff] PMD -> [ffff88085fe00000-ffff88087fdfffff] on node 0
[    0.000000]  [ffffea0022000000-ffffea0041ffffff] PMD -> [ffff88105fe00000-ffff88107fdfffff] on node 1
[    0.000000]  [ffffea0042000000-ffffea0061ffffff] PMD -> [ffff88185fe00000-ffff88187fdfffff] on node 2
[    0.000000]  [ffffea0062000000-ffffea0081ffffff] PMD -> [ffff882056600000-ffff8820765fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x207fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0x7b451fff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   1: [mem 0x880000000-0x107fffffff]
[    0.000000]   node   2: [mem 0x1080000000-0x187fffffff]
[    0.000000]   node   3: [mem 0x1880000000-0x207fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x87fffffff]
[    0.000000] On node 0 totalpages: 8369132
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3994 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7826 pages used for memmap
[    0.000000]   DMA32 zone: 500818 pages, LIFO batch:31
[    0.000000]   Normal zone: 122880 pages used for memmap
[    0.000000]   Normal zone: 7864320 pages, LIFO batch:31
[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107fffffff]
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] Initmem setup node 2 [mem 0x1080000000-0x187fffffff]
[    0.000000] On node 2 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] Initmem setup node 3 [mem 0x1880000000-0x207fffffff]
[    0.000000] On node 3 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x80] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0xc0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0xa0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0xe0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x90] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0xd0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0xb0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0xf0] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x82] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0xc2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0xa2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0xe2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x92] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0xd2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0xb2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0xf2] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x81] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0xc1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0xa1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0xe1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x91] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0xd1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0xb1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0xf1] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x83] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0xc3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0xa3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0xe3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x93] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0xd3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0xb3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0xf3] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x84] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0xc4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0xa4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0xe4] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x85] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0xc5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0xa5] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0xe5] enabled)
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
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec04000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec04000, GSI 48-71
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
[    0.000000] ACPI: HPET id: 0x8086a401 base: 0xfed00000
[    0.000000] smpboot: Allowing 80 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec04000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b452000-0x7b454fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b455000-0x7b68ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b690000-0x7b69efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b69f000-0x7b6a1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6a2000-0x7b6a6fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6a7000-0x7b7bcfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b7bd000-0x7ba3cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ba3d000-0x7baa7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7baa8000-0x7bcfffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bd00000-0x7bd16fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bd17000-0x7bd19fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bd1a000-0x7bd49fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bd4a000-0x7bd5efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bd5f000-0x7bdfefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bdff000-0x7bdfffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7be00000-0x7be4efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7be4f000-0x7bf70fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bf71000-0x7bfcefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bfcf000-0x7bffefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bfff000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfcffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfd000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfbffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:80 nr_cpu_ids:80 nr_node_ids:4
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88085f800000 s89152 r8192 d29632 u262144
[    0.000000] pcpu-alloc: s89152 r8192 d29632 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 04 08 12 16 20 24 28 [0] 32 36 40 44 48 52 56 60 
[    0.000000] pcpu-alloc: [0] 64 68 72 76 -- -- -- -- [1] 01 05 09 13 17 21 25 29 
[    0.000000] pcpu-alloc: [1] 33 37 41 45 49 53 57 61 [1] 65 69 73 77 -- -- -- -- 
[    0.000000] pcpu-alloc: [2] 02 06 10 14 18 22 26 30 [2] 34 38 42 46 50 54 58 62 
[    0.000000] pcpu-alloc: [2] 66 70 74 78 -- -- -- -- [3] 03 07 11 15 19 23 27 31 
[    0.000000] pcpu-alloc: [3] 35 39 43 47 51 55 59 63 [3] 67 71 75 79 -- -- -- -- 
[    0.000000] Built 4 zonelists in Node order, mobility grouping on.  Total pages: 33010949
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-wsx02/cyclic_aim9-performance-300s-creat-clo-x86_64-rhel-HEAD-7c130ce86d3169fb078ea36d2351a9bc5394f7bf-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/7c130ce86d3169fb078ea36d2351a9bc5394f7bf/vmlinuz-3.18.0-rc3-wl-ath-g7c130ce kconfig=x86_64-rhel commit=7c130ce86d3169fb078ea36d2351a9bc5394f7bf branch=linux-devel/devel-hourly-2014110522 root=/dev/ram0 max_uptime=1393 RESULT_ROOT=/result/lkp-wsx02/aim9/performance-300s-creat-clo/debian-x86_64.cgz/x86_64-rhel/7c130ce86d3169fb078ea36d2351a9bc5394f7bf/0 ip=::::lkp-wsx02::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 323584 bytes
[    0.000000] log_buf_len min size: 524288 bytes
[    0.000000] log_buf_len: 1048576 bytes
[    0.000000] early log buf free: 489840(93%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 131821564K/134139824K available (8815K kernel code, 1715K rwdata, 3912K rodata, 1844K init, 1892K bss, 2318260K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=80, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=80.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=80
[    0.000000] NR_IRQS:524544 nr_irqs:1880 0
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-79.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 536870912 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2393.748 MHz processor
[    0.000079] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.49 BogoMIPS (lpj=2393748)
[    0.011940] pid_max: default: 81920 minimum: 640
[    0.017125] ACPI: Core revision 20140926
[    0.121328] ACPI: All ACPI Tables successfully acquired
[    0.127349] Security Framework initialized
[    0.131933] SELinux:  Initializing.
[    0.135837] SELinux:  Starting in permissive mode
[    0.151639] Dentry cache hash table entries: 16777216 (order: 15, 134217728 bytes)
[    0.197652] Inode-cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.222175] Mount-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.230228] Mountpoint-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.239999] Initializing cgroup subsys memory
[    0.244897] Initializing cgroup subsys devices
[    0.249859] Initializing cgroup subsys freezer
[    0.254821] Initializing cgroup subsys net_cls
[    0.259782] Initializing cgroup subsys blkio
[    0.264550] Initializing cgroup subsys perf_event
[    0.269818] Initializing cgroup subsys hugetlb
[    0.274835] CPU: Physical Processor ID: 0
[    0.279309] CPU: Processor Core ID: 0
[    0.283405] mce: CPU supports 24 MCE banks
[    0.287998] CPU0: Thermal LVT vector (0xfa) already installed
[    0.294426] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.294426] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.308458] Freeing SMP alternatives memory: 36K (ffffffff81fec000 - ffffffff81ff5000)
[    0.319460] ftrace: allocating 31422 entries in 123 pages
[    0.347911] Getting VERSION: 1060015
[    0.351901] Getting VERSION: 1060015
[    0.355889] Getting ID: 0
[    0.358809] Getting ID: 0
[    0.361744] dmar: Host address width 48
[    0.366025] dmar: DRHD base: 0x000000fd800000 flags: 0x0
[    0.371962] dmar: IOMMU 0: reg_base_addr fd800000 ver 1:0 cap c90780106f0462 ecap f020ff
[    0.380997] dmar: DRHD base: 0x000000fd000000 flags: 0x1
[    0.386931] dmar: IOMMU 1: reg_base_addr fd000000 ver 1:0 cap c90780106f0462 ecap f020ff
[    0.395967] dmar: RMRR base: 0x0000007be27000 end: 0x0000007be29fff
[    0.402963] dmar: RMRR base: 0x0000007be14000 end: 0x0000007be14fff
[    0.409959] dmar: RMRR base: 0x0000007be11000 end: 0x0000007be11fff
[    0.416956] dmar: RMRR base: 0x0000007be0e000 end: 0x0000007be0efff
[    0.423952] dmar: RMRR base: 0x0000007be0b000 end: 0x0000007be0bfff
[    0.430948] dmar: RMRR base: 0x0000007be08000 end: 0x0000007be08fff
[    0.437947] dmar: RMRR base: 0x0000007be05000 end: 0x0000007be05fff
[    0.444944] dmar: RMRR base: 0x0000007be02000 end: 0x0000007be02fff
[    0.451940] dmar: RMRR base: 0x0000007b6a0000 end: 0x0000007b6a0fff
[    0.458936] dmar: ATSR flags: 0x0
[    0.462633] dmar: ATSR flags: 0x0
[    0.466330] dmar: RHSA base: 0x000000fd000000 proximity domain: 0x0
[    0.473326] dmar: RHSA base: 0x000000fd800000 proximity domain: 0x2
[    0.480474] IOAPIC id 10 under DRHD base  0xfd800000 IOMMU 0
[    0.486792] IOAPIC id 8 under DRHD base  0xfd000000 IOMMU 1
[    0.493013] IOAPIC id 9 under DRHD base  0xfd000000 IOMMU 1
[    0.499234] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.508655] Enabled IRQ remapping in x2apic mode
[    0.513818] masked ExtINT on CPU#0
[    0.518198] ENABLING IO-APIC IRQs
[    0.521898] init IO_APIC IRQs
[    0.525208]  apic 8 pin 0 not connected
[    0.529492] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.538337] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.553392] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.562235] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.577290] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.586149] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.601207] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.610053] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.625110] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.633955] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.649012] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.657856] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:35 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.672911] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.681757] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:36 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.696815] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.705661] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:37 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.720717] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.729561] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.744617] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.753463] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.768519] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.777557] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3A Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.792613] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.801654] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3B Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.816710] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.825750] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3C Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.840806] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.849845] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.864902] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.873941] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3E Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.888998] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.898038] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3F Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.913093]  apic 8 pin 16 not connected
[    0.917471]  apic 8 pin 17 not connected
[    0.921851]  apic 8 pin 18 not connected
[    0.926230]  apic 8 pin 19 not connected
[    0.930609]  apic 8 pin 20 not connected
[    0.934987]  apic 8 pin 21 not connected
[    0.939366]  apic 8 pin 22 not connected
[    0.943743]  apic 8 pin 23 not connected
[    0.948120]  apic 9 pin 0 not connected
[    0.952401]  apic 9 pin 1 not connected
[    0.956683]  apic 9 pin 2 not connected
[    0.960963]  apic 9 pin 3 not connected
[    0.965244]  apic 9 pin 4 not connected
[    0.969524]  apic 9 pin 5 not connected
[    0.973805]  apic 9 pin 6 not connected
[    0.978085]  apic 9 pin 7 not connected
[    0.982366]  apic 9 pin 8 not connected
[    0.986647]  apic 9 pin 9 not connected
[    0.990928]  apic 9 pin 10 not connected
[    0.995306]  apic 9 pin 11 not connected
[    0.999684]  apic 9 pin 12 not connected
[    1.004062]  apic 9 pin 13 not connected
[    1.008440]  apic 9 pin 14 not connected
[    1.012818]  apic 9 pin 15 not connected
[    1.017196]  apic 9 pin 16 not connected
[    1.021574]  apic 9 pin 17 not connected
[    1.025952]  apic 9 pin 18 not connected
[    1.030330]  apic 9 pin 19 not connected
[    1.034709]  apic 9 pin 20 not connected
[    1.039087]  apic 9 pin 21 not connected
[    1.043465]  apic 9 pin 22 not connected
[    1.047843]  apic 9 pin 23 not connected
[    1.052220]  apic 10 pin 0 not connected
[    1.056599]  apic 10 pin 1 not connected
[    1.060977]  apic 10 pin 2 not connected
[    1.065355]  apic 10 pin 3 not connected
[    1.069734]  apic 10 pin 4 not connected
[    1.074112]  apic 10 pin 5 not connected
[    1.078490]  apic 10 pin 6 not connected
[    1.082867]  apic 10 pin 7 not connected
[    1.087245]  apic 10 pin 8 not connected
[    1.091624]  apic 10 pin 9 not connected
[    1.096001]  apic 10 pin 10 not connected
[    1.100477]  apic 10 pin 11 not connected
[    1.104952]  apic 10 pin 12 not connected
[    1.109426]  apic 10 pin 13 not connected
[    1.113901]  apic 10 pin 14 not connected
[    1.118377]  apic 10 pin 15 not connected
[    1.122853]  apic 10 pin 16 not connected
[    1.127329]  apic 10 pin 17 not connected
[    1.131805]  apic 10 pin 18 not connected
[    1.136281]  apic 10 pin 19 not connected
[    1.140757]  apic 10 pin 20 not connected
[    1.145232]  apic 10 pin 21 not connected
[    1.149707]  apic 10 pin 22 not connected
[    1.154183]  apic 10 pin 23 not connected
[    1.158794] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.175508] smpboot: CPU0: Intel(R) Xeon(R) CPU E7- 8870  @ 2.40GHz (fam: 06, model: 2f, stepping: 02)
[    1.185937] Using local APIC timer interrupts.
[    1.185937] calibrating APIC timer ...
[    1.297079] ... lapic delta = 831240
[    1.301069] ... PM-Timer delta = 357951
[    1.305348] ... PM-Timer result ok
[    1.309142] ..... delta 831240
[    1.312549] ..... mult: 35701486
[    1.316149] ..... calibration result: 132998
[    1.320914] ..... CPU clock speed is 2393.0976 MHz.
[    1.326358] ..... host bus clock speed is 132.0998 MHz.
[    1.332240] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    1.341630] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    1.349311] ... version:                3
[    1.353778] ... bit width:              48
[    1.358349] ... generic registers:      4
[    1.362823] ... value mask:             0000ffffffffffff
[    1.368752] ... max period:             000000007fffffff
[    1.374682] ... fixed-purpose events:   3
[    1.379157] ... event mask:             000000070000000f
[    1.388645] x86: Booting SMP configuration:
[    1.393319] .... node  #2, CPUs:        #1
[    1.410251] masked ExtINT on CPU#1
[    1.414303] CPU1: Thermal LVT vector (0xfa) already installed
[    1.502564] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    1.511687] 
[    1.513352] .... node  #1, CPUs:    #2
[    1.529886] masked ExtINT on CPU#2
[    1.533942] CPU2: Thermal LVT vector (0xfa) already installed
[    1.620637] 
[    1.622304] .... node  #3, CPUs:    #3
[    1.638828] masked ExtINT on CPU#3
[    1.642880] CPU3: Thermal LVT vector (0xfa) already installed
[    1.728674] 
[    1.730340] .... node  #0, CPUs:    #4
[    1.746683] masked ExtINT on CPU#4
[    1.750745] CPU4: Thermal LVT vector (0xfa) already installed
[    1.759498] 
[    1.761167] .... node  #2, CPUs:    #5
[    1.777699] masked ExtINT on CPU#5
[    1.781753] CPU5: Thermal LVT vector (0xfa) already installed
[    1.790415] 
[    1.792080] .... node  #1, CPUs:    #6
[    1.808611] masked ExtINT on CPU#6
[    1.812669] CPU6: Thermal LVT vector (0xfa) already installed
[    1.821323] 
[    1.822989] .... node  #3, CPUs:    #7
[    1.839524] masked ExtINT on CPU#7
[    1.843577] CPU7: Thermal LVT vector (0xfa) already installed
[    1.852231] 
[    1.853897] .... node  #0, CPUs:    #8
[    1.870241] masked ExtINT on CPU#8
[    1.874304] CPU8: Thermal LVT vector (0xfa) already installed
[    1.883058] 
[    1.884727] .... node  #2, CPUs:    #9
[    1.901263] masked ExtINT on CPU#9
[    1.905320] CPU9: Thermal LVT vector (0xfa) already installed
[    1.913981] 
[    1.915646] .... node  #1, CPUs:   #10
[    1.932181] masked ExtINT on CPU#10
[    1.936330] CPU10: Thermal LVT vector (0xfa) already installed
[    1.945097] 
[    1.946762] .... node  #3, CPUs:   #11
[    1.963298] masked ExtINT on CPU#11
[    1.967455] CPU11: Thermal LVT vector (0xfa) already installed
[    1.976203] 
[    1.977868] .... node  #0, CPUs:   #12
[    1.994208] masked ExtINT on CPU#12
[    1.998365] CPU12: Thermal LVT vector (0xfa) already installed
[    2.007228] 
[    2.008898] .... node  #2, CPUs:   #13
[    2.025434] masked ExtINT on CPU#13
[    2.029583] CPU13: Thermal LVT vector (0xfa) already installed
[    2.038354] 
[    2.040019] .... node  #1, CPUs:   #14
[    2.056551] masked ExtINT on CPU#14
[    2.060705] CPU14: Thermal LVT vector (0xfa) already installed
[    2.069458] 
[    2.071123] .... node  #3, CPUs:   #15
[    2.087655] masked ExtINT on CPU#15
[    2.091803] CPU15: Thermal LVT vector (0xfa) already installed
[    2.100558] 
[    2.102225] .... node  #0, CPUs:   #16
[    2.118558] masked ExtINT on CPU#16
[    2.122712] CPU16: Thermal LVT vector (0xfa) already installed
[    2.131589] 
[    2.133259] .... node  #2, CPUs:   #17
[    2.149793] masked ExtINT on CPU#17
[    2.153940] CPU17: Thermal LVT vector (0xfa) already installed
[    2.162719] 
[    2.164375] .... node  #1, CPUs:   #18
[    2.180907] masked ExtINT on CPU#18
[    2.185055] CPU18: Thermal LVT vector (0xfa) already installed
[    2.193822] 
[    2.195486] .... node  #3, CPUs:   #19
[    2.212019] masked ExtINT on CPU#19
[    2.216169] CPU19: Thermal LVT vector (0xfa) already installed
[    2.224917] 
[    2.226582] .... node  #0, CPUs:   #20
[    2.242918] masked ExtINT on CPU#20
[    2.247071] CPU20: Thermal LVT vector (0xfa) already installed
[    2.255958] 
[    2.257628] .... node  #2, CPUs:   #21
[    2.274161] masked ExtINT on CPU#21
[    2.278307] CPU21: Thermal LVT vector (0xfa) already installed
[    2.287081] 
[    2.288747] .... node  #1, CPUs:   #22
[    2.305281] masked ExtINT on CPU#22
[    2.309416] CPU22: Thermal LVT vector (0xfa) already installed
[    2.318190] 
[    2.319854] .... node  #3, CPUs:   #23
[    2.336388] masked ExtINT on CPU#23
[    2.340531] CPU23: Thermal LVT vector (0xfa) already installed
[    2.349296] 
[    2.350963] .... node  #0, CPUs:   #24
[    2.367308] masked ExtINT on CPU#24
[    2.371457] CPU24: Thermal LVT vector (0xfa) already installed
[    2.380331] 
[    2.382001] .... node  #2, CPUs:   #25
[    2.398537] masked ExtINT on CPU#25
[    2.402691] CPU25: Thermal LVT vector (0xfa) already installed
[    2.411458] 
[    2.413123] .... node  #1, CPUs:   #26
[    2.429658] masked ExtINT on CPU#26
[    2.433798] CPU26: Thermal LVT vector (0xfa) already installed
[    2.442561] 
[    2.444227] .... node  #3, CPUs:   #27
[    2.460761] masked ExtINT on CPU#27
[    2.464938] CPU27: Thermal LVT vector (0xfa) already installed
[    2.473770] 
[    2.475434] .... node  #0, CPUs:   #28
[    2.491774] masked ExtINT on CPU#28
[    2.495927] CPU28: Thermal LVT vector (0xfa) already installed
[    2.504794] 
[    2.506464] .... node  #2, CPUs:   #29
[    2.522996] masked ExtINT on CPU#29
[    2.527148] CPU29: Thermal LVT vector (0xfa) already installed
[    2.535928] 
[    2.537592] .... node  #1, CPUs:   #30
[    2.554123] masked ExtINT on CPU#30
[    2.558291] CPU30: Thermal LVT vector (0xfa) already installed
[    2.567129] 
[    2.568786] .... node  #3, CPUs:   #31
[    2.585319] masked ExtINT on CPU#31
[    2.589465] CPU31: Thermal LVT vector (0xfa) already installed
[    2.598228] 
[    2.599894] .... node  #0, CPUs:   #32
[    2.616972] masked ExtINT on CPU#32
[    2.621129] CPU32: Thermal LVT vector (0xfa) already installed
[    2.630025] 
[    2.631695] .... node  #2, CPUs:   #33
[    2.648230] masked ExtINT on CPU#33
[    2.652379] CPU33: Thermal LVT vector (0xfa) already installed
[    2.661156] 
[    2.662820] .... node  #1, CPUs:   #34
[    2.679352] masked ExtINT on CPU#34
[    2.683497] CPU34: Thermal LVT vector (0xfa) already installed
[    2.692261] 
[    2.693925] .... node  #3, CPUs:   #35
[    2.710459] masked ExtINT on CPU#35
[    2.714614] CPU35: Thermal LVT vector (0xfa) already installed
[    2.723366] 
[    2.725022] .... node  #0, CPUs:   #36
[    2.741360] masked ExtINT on CPU#36
[    2.745504] CPU36: Thermal LVT vector (0xfa) already installed
[    2.754387] 
[    2.756056] .... node  #2, CPUs:   #37
[    2.772592] masked ExtINT on CPU#37
[    2.776734] CPU37: Thermal LVT vector (0xfa) already installed
[    2.785513] 
[    2.787176] .... node  #1, CPUs:   #38
[    2.803711] masked ExtINT on CPU#38
[    2.807854] CPU38: Thermal LVT vector (0xfa) already installed
[    2.816613] 
[    2.818278] .... node  #3, CPUs:   #39
[    2.834813] masked ExtINT on CPU#39
[    2.838961] CPU39: Thermal LVT vector (0xfa) already installed
[    2.847724] 
[    2.849390] .... node  #0, CPUs:   #40
[    2.865734] masked ExtINT on CPU#40
[    2.869887] CPU40: Thermal LVT vector (0xfa) already installed
[    2.878763] 
[    2.880433] .... node  #2, CPUs:   #41
[    2.896972] masked ExtINT on CPU#41
[    2.901118] CPU41: Thermal LVT vector (0xfa) already installed
[    2.909897] 
[    2.911561] .... node  #1, CPUs:   #42
[    2.928096] masked ExtINT on CPU#42
[    2.932249] CPU42: Thermal LVT vector (0xfa) already installed
[    2.941013] 
[    2.942679] .... node  #3, CPUs:   #43
[    2.959211] masked ExtINT on CPU#43
[    2.963361] CPU43: Thermal LVT vector (0xfa) already installed
[    2.972119] 
[    2.973784] .... node  #0, CPUs:   #44
[    2.990121] masked ExtINT on CPU#44
[    2.994270] CPU44: Thermal LVT vector (0xfa) already installed
[    3.003152] 
[    3.004821] .... node  #2, CPUs:   #45
[    3.021358] masked ExtINT on CPU#45
[    3.025512] CPU45: Thermal LVT vector (0xfa) already installed
[    3.034290] 
[    3.035955] .... node  #1, CPUs:   #46
[    3.052488] masked ExtINT on CPU#46
[    3.056632] CPU46: Thermal LVT vector (0xfa) already installed
[    3.065404] 
[    3.067070] .... node  #3, CPUs:   #47
[    3.083603] masked ExtINT on CPU#47
[    3.087747] CPU47: Thermal LVT vector (0xfa) already installed
[    3.096508] 
[    3.098174] .... node  #0, CPUs:   #48
[    3.114511] masked ExtINT on CPU#48
[    3.118659] CPU48: Thermal LVT vector (0xfa) already installed
[    3.127559] 
[    3.129227] .... node  #2, CPUs:   #49
[    3.145765] masked ExtINT on CPU#49
[    3.149921] CPU49: Thermal LVT vector (0xfa) already installed
[    3.158686] 
[    3.160352] .... node  #1, CPUs:   #50
[    3.176888] masked ExtINT on CPU#50
[    3.181036] CPU50: Thermal LVT vector (0xfa) already installed
[    3.189797] 
[    3.191463] .... node  #3, CPUs:   #51
[    3.207998] masked ExtINT on CPU#51
[    3.212143] CPU51: Thermal LVT vector (0xfa) already installed
[    3.220899] 
[    3.222564] .... node  #0, CPUs:   #52
[    3.238903] masked ExtINT on CPU#52
[    3.243047] CPU52: Thermal LVT vector (0xfa) already installed
[    3.251937] 
[    3.253607] .... node  #2, CPUs:   #53
[    3.270144] masked ExtINT on CPU#53
[    3.274291] CPU53: Thermal LVT vector (0xfa) already installed
[    3.283068] 
[    3.284733] .... node  #1, CPUs:   #54
[    3.301266] masked ExtINT on CPU#54
[    3.305420] CPU54: Thermal LVT vector (0xfa) already installed
[    3.314171] 
[    3.315837] .... node  #3, CPUs:   #55
[    3.332371] masked ExtINT on CPU#55
[    3.336526] CPU55: Thermal LVT vector (0xfa) already installed
[    3.345279] 
[    3.346945] .... node  #0, CPUs:   #56
[    3.363278] masked ExtINT on CPU#56
[    3.367435] CPU56: Thermal LVT vector (0xfa) already installed
[    3.376314] 
[    3.377984] .... node  #2, CPUs:   #57
[    3.394520] masked ExtINT on CPU#57
[    3.398661] CPU57: Thermal LVT vector (0xfa) already installed
[    3.407448] 
[    3.409105] .... node  #1, CPUs:   #58
[    3.425640] masked ExtINT on CPU#58
[    3.429788] CPU58: Thermal LVT vector (0xfa) already installed
[    3.438542] 
[    3.440207] .... node  #3, CPUs:   #59
[    3.456742] masked ExtINT on CPU#59
[    3.460888] CPU59: Thermal LVT vector (0xfa) already installed
[    3.469645] 
[    3.471309] .... node  #0, CPUs:   #60
[    3.487647] masked ExtINT on CPU#60
[    3.491791] CPU60: Thermal LVT vector (0xfa) already installed
[    3.500690] 
[    3.502360] .... node  #2, CPUs:   #61
[    3.518895] masked ExtINT on CPU#61
[    3.523052] CPU61: Thermal LVT vector (0xfa) already installed
[    3.531813] 
[    3.533478] .... node  #1, CPUs:   #62
[    3.550014] masked ExtINT on CPU#62
[    3.554156] CPU62: Thermal LVT vector (0xfa) already installed
[    3.562917] 
[    3.564582] .... node  #3, CPUs:   #63
[    3.581118] masked ExtINT on CPU#63
[    3.585272] CPU63: Thermal LVT vector (0xfa) already installed
[    3.594026] 
[    3.595693] .... node  #0, CPUs:   #64
[    3.612031] masked ExtINT on CPU#64
[    3.616180] CPU64: Thermal LVT vector (0xfa) already installed
[    3.625075] 
[    3.626745] .... node  #2, CPUs:   #65
[    3.643282] masked ExtINT on CPU#65
[    3.647438] CPU65: Thermal LVT vector (0xfa) already installed
[    3.656207] 
[    3.657863] .... node  #1, CPUs:   #66
[    3.674399] masked ExtINT on CPU#66
[    3.678560] CPU66: Thermal LVT vector (0xfa) already installed
[    3.687409] 
[    3.689074] .... node  #3, CPUs:   #67
[    3.705607] masked ExtINT on CPU#67
[    3.709751] CPU67: Thermal LVT vector (0xfa) already installed
[    3.718512] 
[    3.720167] .... node  #0, CPUs:   #68
[    3.736507] masked ExtINT on CPU#68
[    3.740661] CPU68: Thermal LVT vector (0xfa) already installed
[    3.749534] 
[    3.751205] .... node  #2, CPUs:   #69
[    3.767744] masked ExtINT on CPU#69
[    3.771889] CPU69: Thermal LVT vector (0xfa) already installed
[    3.780673] 
[    3.782337] .... node  #1, CPUs:   #70
[    3.798874] masked ExtINT on CPU#70
[    3.803024] CPU70: Thermal LVT vector (0xfa) already installed
[    3.811789] 
[    3.813454] .... node  #3, CPUs:   #71
[    3.829990] masked ExtINT on CPU#71
[    3.834138] CPU71: Thermal LVT vector (0xfa) already installed
[    3.842893] 
[    3.844559] .... node  #0, CPUs:   #72
[    3.860904] masked ExtINT on CPU#72
[    3.865054] CPU72: Thermal LVT vector (0xfa) already installed
[    3.873942] 
[    3.875612] .... node  #2, CPUs:   #73
[    3.892151] masked ExtINT on CPU#73
[    3.896293] CPU73: Thermal LVT vector (0xfa) already installed
[    3.905063] 
[    3.906718] .... node  #1, CPUs:   #74
[    3.923254] masked ExtINT on CPU#74
[    3.927404] CPU74: Thermal LVT vector (0xfa) already installed
[    3.936159] 
[    3.937824] .... node  #3, CPUs:   #75
[    3.954360] masked ExtINT on CPU#75
[    3.958507] CPU75: Thermal LVT vector (0xfa) already installed
[    3.967264] 
[    3.968930] .... node  #0, CPUs:   #76
[    3.985271] masked ExtINT on CPU#76
[    3.989429] CPU76: Thermal LVT vector (0xfa) already installed
[    3.998408] 
[    4.000078] .... node  #2, CPUs:   #77
[    4.016616] masked ExtINT on CPU#77
[    4.020764] CPU77: Thermal LVT vector (0xfa) already installed
[    4.029532] 
[    4.031197] .... node  #1, CPUs:   #78
[    4.047736] masked ExtINT on CPU#78
[    4.051891] CPU78: Thermal LVT vector (0xfa) already installed
[    4.060740] 
[    4.062405] .... node  #3, CPUs:   #79
[    4.078941] masked ExtINT on CPU#79
[    4.083088] CPU79: Thermal LVT vector (0xfa) already installed
[    4.091678] x86: Booted up 4 nodes, 80 CPUs
[    4.096352] smpboot: Total of 80 processors activated (383024.00 BogoMIPS)
[    4.594424] devtmpfs: initialized
[    4.598225] Using 2GB memory block size for large-memory system
[    4.607271] evm: security.selinux
[    4.610972] evm: security.ima
[    4.614284] evm: security.capability
[    4.618486] PM: Registering ACPI NVS region [mem 0x7b455000-0x7b68ffff] (2338816 bytes)
[    4.627471] PM: Registering ACPI NVS region [mem 0x7b7bd000-0x7ba3cfff] (2621440 bytes)
[    4.636453] PM: Registering ACPI NVS region [mem 0x7bf71000-0x7bfcefff] (385024 bytes)
[    4.647315] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    4.655413] NET: Registered protocol family 16
[    4.663827] cpuidle: using governor menu
[    4.668381] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    4.676838] ACPI: bus type PCI registered
[    4.681316] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    4.688637] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    4.699038] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[    4.707193] PCI: Using configuration type 1 for base access
[    4.721539] ACPI: Added _OSI(Module Device)
[    4.726214] ACPI: Added _OSI(Processor Device)
[    4.731176] ACPI: Added _OSI(3.0 _SCP Extensions)
[    4.736429] ACPI: Added _OSI(Processor Aggregator Device)
[    4.748613] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    4.757467] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    4.889132] ACPI: Interpreter enabled
[    4.893234] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    4.903561] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140926/hwxface-580)
[    4.913888] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20140926/hwxface-580)
[    4.924209] ACPI: (supports S0 S1 S5)
[    4.928297] ACPI: Using IOAPIC for interrupt routing
[    4.933900] HEST: Table parsing has been initialized.
[    4.939544] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    4.974336] ACPI: PCI Root Bridge [IOH0] (domain 0000 [bus 00-7f])
[    4.981247] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    4.990581] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug AER]
[    4.998842] acpi PNP0A08:00: _OSC: OS now controls [PME PCIeCapability]
[    5.006850] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[    5.021154] PCI host bridge to bus 0000:00
[    5.025731] pci_bus 0000:00: root bus resource [bus 00-7f]
[    5.031858] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    5.038761] pci_bus 0000:00: root bus resource [io  0x1000-0x9fff]
[    5.045665] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    5.053345] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
[    5.061025] pci_bus 0000:00: root bus resource [mem 0x90000000-0xafffffff]
[    5.068704] pci_bus 0000:00: root bus resource [mem 0xfc000000000-0xfc07fffffff]
[    5.076969] pci 0000:00:00.0: [8086:3407] type 00 class 0x060000
[    5.083745] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    5.090674] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    5.097446] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    5.104324] pci 0000:00:01.0: System wakeup disabled by ACPI
[    5.110689] pci 0000:00:02.0: [8086:3409] type 01 class 0x060400
[    5.117457] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    5.124341] pci 0000:00:02.0: System wakeup disabled by ACPI
[    5.130702] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    5.137472] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    5.144396] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    5.151165] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    5.158046] pci 0000:00:05.0: System wakeup disabled by ACPI
[    5.164412] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    5.171180] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    5.178061] pci 0000:00:07.0: System wakeup disabled by ACPI
[    5.184424] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    5.191191] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    5.198072] pci 0000:00:09.0: System wakeup disabled by ACPI
[    5.204434] pci 0000:00:0a.0: [8086:3411] type 01 class 0x060400
[    5.211202] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    5.218081] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    5.224443] pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
[    5.231288] pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
[    5.238124] pci 0000:00:11.0: [8086:3427] type 00 class 0x080000
[    5.244966] pci 0000:00:11.1: [8086:3428] type 00 class 0x080000
[    5.251801] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    5.258523] pci 0000:00:13.0: reg 0x10: [mem 0x95c02000-0x95c02fff]
[    5.265570] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    5.272483] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    5.279339] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    5.286185] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    5.293029] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    5.299863] pci 0000:00:15.0: [8086:342f] type 00 class 0x080020
[    5.306700] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    5.313423] pci 0000:00:16.0: reg 0x10: [mem 0xaff1c000-0xaff1ffff 64bit]
[    5.321155] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    5.327878] pci 0000:00:16.1: reg 0x10: [mem 0xaff18000-0xaff1bfff 64bit]
[    5.335609] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    5.342332] pci 0000:00:16.2: reg 0x10: [mem 0xaff14000-0xaff17fff 64bit]
[    5.350063] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    5.356783] pci 0000:00:16.3: reg 0x10: [mem 0xaff10000-0xaff13fff 64bit]
[    5.364519] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    5.371243] pci 0000:00:16.4: reg 0x10: [mem 0xaff0c000-0xaff0ffff 64bit]
[    5.378972] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    5.385694] pci 0000:00:16.5: reg 0x10: [mem 0xaff08000-0xaff0bfff 64bit]
[    5.393423] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    5.400143] pci 0000:00:16.6: reg 0x10: [mem 0xaff04000-0xaff07fff 64bit]
[    5.407874] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    5.414595] pci 0000:00:16.7: reg 0x10: [mem 0xaff00000-0xaff03fff 64bit]
[    5.422330] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    5.429079] pci 0000:00:1a.0: reg 0x20: [io  0x60c0-0x60df]
[    5.435434] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    5.441799] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    5.448546] pci 0000:00:1a.1: reg 0x20: [io  0x60a0-0x60bf]
[    5.454897] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    5.461262] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    5.468011] pci 0000:00:1a.2: reg 0x20: [io  0x6080-0x609f]
[    5.474364] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    5.480736] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    5.487462] pci 0000:00:1a.7: reg 0x10: [mem 0x95c01000-0x95c013ff]
[    5.494547] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    5.501448] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    5.507804] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    5.514594] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    5.521480] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    5.527847] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    5.534630] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    5.541511] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    5.547876] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    5.554624] pci 0000:00:1d.0: reg 0x20: [io  0x6060-0x607f]
[    5.560976] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    5.567341] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    5.574090] pci 0000:00:1d.1: reg 0x20: [io  0x6040-0x605f]
[    5.580442] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    5.586806] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    5.593556] pci 0000:00:1d.2: reg 0x20: [io  0x6020-0x603f]
[    5.599907] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    5.606279] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    5.613006] pci 0000:00:1d.7: reg 0x10: [mem 0x95c00000-0x95c003ff]
[    5.620086] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    5.626994] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    5.633358] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    5.640184] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    5.646549] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    5.653337] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    5.662184] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    5.670156] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    5.678614] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    5.687071] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0600 (mask 001f)
[    5.695659] pci 0000:00:1f.2: [8086:3a20] type 00 class 0x01018f
[    5.702383] pci 0000:00:1f.2: reg 0x10: [io  0x6138-0x613f]
[    5.708612] pci 0000:00:1f.2: reg 0x14: [io  0x614c-0x614f]
[    5.714842] pci 0000:00:1f.2: reg 0x18: [io  0x6130-0x6137]
[    5.721070] pci 0000:00:1f.2: reg 0x1c: [io  0x6148-0x614b]
[    5.727300] pci 0000:00:1f.2: reg 0x20: [io  0x6110-0x611f]
[    5.733528] pci 0000:00:1f.2: reg 0x24: [io  0x6100-0x610f]
[    5.739885] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    5.746608] pci 0000:00:1f.3: reg 0x10: [mem 0xaff20000-0xaff200ff 64bit]
[    5.754207] pci 0000:00:1f.3: reg 0x20: [io  0x6000-0x601f]
[    5.760551] pci 0000:00:1f.5: [8086:3a26] type 00 class 0x010185
[    5.767275] pci 0000:00:1f.5: reg 0x10: [io  0x6128-0x612f]
[    5.773504] pci 0000:00:1f.5: reg 0x14: [io  0x6144-0x6147]
[    5.779733] pci 0000:00:1f.5: reg 0x18: [io  0x6120-0x6127]
[    5.785963] pci 0000:00:1f.5: reg 0x1c: [io  0x6140-0x6143]
[    5.792191] pci 0000:00:1f.5: reg 0x20: [io  0x60f0-0x60ff]
[    5.798421] pci 0000:00:1f.5: reg 0x24: [io  0x60e0-0x60ef]
[    5.804910] pci 0000:01:00.0: [8086:150a] type 00 class 0x020000
[    5.811637] pci 0000:01:00.0: reg 0x10: [mem 0x95b20000-0x95b3ffff]
[    5.818655] pci 0000:01:00.0: reg 0x18: [io  0x5020-0x503f]
[    5.824880] pci 0000:01:00.0: reg 0x1c: [mem 0x95bc4000-0x95bc7fff]
[    5.831986] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    5.838840] pci 0000:01:00.0: reg 0x184: [mem 0x95b40000-0x95b43fff 64bit]
[    5.846540] pci 0000:01:00.0: reg 0x190: [mem 0x95b60000-0x95b63fff 64bit]
[    5.854311] pci 0000:01:00.1: [8086:150a] type 00 class 0x020000
[    5.861035] pci 0000:01:00.1: reg 0x10: [mem 0x95b00000-0x95b1ffff]
[    5.868054] pci 0000:01:00.1: reg 0x18: [io  0x5000-0x501f]
[    5.874287] pci 0000:01:00.1: reg 0x1c: [mem 0x95bc0000-0x95bc3fff]
[    5.881391] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    5.888239] pci 0000:01:00.1: reg 0x184: [mem 0x95b80000-0x95b83fff 64bit]
[    5.895939] pci 0000:01:00.1: reg 0x190: [mem 0x95ba0000-0x95ba3fff 64bit]
[    5.906762] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    5.912601] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    5.919409] pci 0000:00:01.0:   bridge window [mem 0x95b00000-0x95bfffff]
[    5.927125] pci 0000:04:00.0: [8086:150a] type 00 class 0x020000
[    5.933852] pci 0000:04:00.0: reg 0x10: [mem 0x95a20000-0x95a3ffff]
[    5.940862] pci 0000:04:00.0: reg 0x18: [io  0x4020-0x403f]
[    5.947094] pci 0000:04:00.0: reg 0x1c: [mem 0x95ac4000-0x95ac7fff]
[    5.954198] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    5.961052] pci 0000:04:00.0: reg 0x184: [mem 0x95a40000-0x95a43fff 64bit]
[    5.968752] pci 0000:04:00.0: reg 0x190: [mem 0x95a60000-0x95a63fff 64bit]
[    5.976522] pci 0000:04:00.1: [8086:150a] type 00 class 0x020000
[    5.983247] pci 0000:04:00.1: reg 0x10: [mem 0x95a00000-0x95a1ffff]
[    5.990267] pci 0000:04:00.1: reg 0x18: [io  0x4000-0x401f]
[    5.996500] pci 0000:04:00.1: reg 0x1c: [mem 0x95ac0000-0x95ac3fff]
[    6.003596] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
[    6.010445] pci 0000:04:00.1: reg 0x184: [mem 0x95a80000-0x95a83fff 64bit]
[    6.018145] pci 0000:04:00.1: reg 0x190: [mem 0x95aa0000-0x95aa3fff 64bit]
[    6.029829] pci 0000:00:02.0: PCI bridge to [bus 04-06]
[    6.035668] pci 0000:00:02.0:   bridge window [io  0x4000-0x4fff]
[    6.042476] pci 0000:00:02.0:   bridge window [mem 0x95a00000-0x95afffff]
[    6.050166] pci 0000:07:00.0: [1000:0079] type 00 class 0x010400
[    6.056888] pci 0000:07:00.0: reg 0x10: [io  0x3000-0x30ff]
[    6.063119] pci 0000:07:00.0: reg 0x14: [mem 0x95940000-0x95943fff 64bit]
[    6.070709] pci 0000:07:00.0: reg 0x1c: [mem 0x95900000-0x9593ffff 64bit]
[    6.078302] pci 0000:07:00.0: reg 0x30: [mem 0xfffc0000-0xffffffff pref]
[    6.085836] pci 0000:07:00.0: supports D1 D2
[    6.093860] pci 0000:00:03.0: PCI bridge to [bus 07]
[    6.099409] pci 0000:00:03.0:   bridge window [io  0x3000-0x3fff]
[    6.106216] pci 0000:00:03.0:   bridge window [mem 0x95900000-0x959fffff]
[    6.113802] pci 0000:00:03.0:   bridge window [mem 0x95d00000-0x95dfffff 64bit pref]
[    6.122734] acpiphp: Slot [1] registered
[    6.127141] pci 0000:00:05.0: PCI bridge to [bus 08-0a]
[    6.132980] pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
[    6.139787] pci 0000:00:05.0:   bridge window [mem 0x94900000-0x958fffff]
[    6.147373] pci 0000:00:05.0:   bridge window [mem 0x91900000-0x928fffff 64bit pref]
[    6.156289] acpiphp: Slot [2] registered
[    6.160698] pci 0000:00:07.0: PCI bridge to [bus 0b-0d]
[    6.166535] pci 0000:00:07.0:   bridge window [io  0x1000-0x1fff]
[    6.173343] pci 0000:00:07.0:   bridge window [mem 0x93900000-0x948fffff]
[    6.180929] pci 0000:00:07.0:   bridge window [mem 0x92900000-0x938fffff 64bit pref]
[    6.189845] pci 0000:00:09.0: PCI bridge to [bus 0e]
[    6.195658] pci 0000:00:0a.0: PCI bridge to [bus 0f]
[    6.201332] pci 0000:00:1c.0: PCI bridge to [bus 10]
[    6.206881] pci 0000:00:1c.0:   bridge window [io  0x7000-0x7fff]
[    6.213690] pci 0000:00:1c.0:   bridge window [mem 0x95e00000-0x95ffffff]
[    6.221275] pci 0000:00:1c.0:   bridge window [mem 0xfc000000000-0xfc0001fffff 64bit pref]
[    6.230589] pci 0000:11:00.0: [102b:0522] type 00 class 0x030000
[    6.237323] pci 0000:11:00.0: reg 0x10: [mem 0x90000000-0x90ffffff pref]
[    6.244820] pci 0000:11:00.0: reg 0x14: [mem 0x91800000-0x91803fff]
[    6.251833] pci 0000:11:00.0: reg 0x18: [mem 0x91000000-0x917fffff]
[    6.258882] pci 0000:11:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
[    6.267961] pci 0000:00:1c.4: PCI bridge to [bus 11]
[    6.273513] pci 0000:00:1c.4:   bridge window [mem 0x91000000-0x918fffff]
[    6.281100] pci 0000:00:1c.4:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
[    6.289823] pci 0000:00:1e.0: PCI bridge to [bus 12] (subtractive decode)
[    6.297414] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    6.306257] pci 0000:00:1e.0:   bridge window [io  0x1000-0x9fff] (subtractive decode)
[    6.315102] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    6.324713] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    6.334324] pci 0000:00:1e.0:   bridge window [mem 0x90000000-0xafffffff] (subtractive decode)
[    6.343944] pci 0000:00:1e.0:   bridge window [mem 0xfc000000000-0xfc07fffffff] (subtractive decode)
[    6.354195] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    6.362539] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.372113] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.381683] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.391241] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.400808] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.410375] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.419943] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.429508] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.439053] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    6.448097] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    6.463529] ACPI: PCI Root Bridge [IOH1] (domain 0000 [bus 80-f7])
[    6.470437] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.479772] acpi PNP0A08:01: _OSC: platform does not support [PCIeHotplug AER]
[    6.488033] acpi PNP0A08:01: _OSC: OS now controls [PME PCIeCapability]
[    6.495593] PCI host bridge to bus 0000:80
[    6.500170] pci_bus 0000:80: root bus resource [bus 80-f7]
[    6.506296] pci_bus 0000:80: root bus resource [io  0xa000-0xffff]
[    6.513200] pci_bus 0000:80: root bus resource [mem 0xb0000000-0xfbffffff]
[    6.520871] pci_bus 0000:80: root bus resource [mem 0xfc080000000-0xfc0ffffffff]
[    6.529136] pci 0000:80:00.0: [8086:3420] type 01 class 0x060400
[    6.535909] pci 0000:80:00.0: PME# supported from D0 D3hot D3cold
[    6.542758] pci 0000:80:00.0: System wakeup disabled by ACPI
[    6.549134] pci 0000:80:01.0: [8086:3408] type 01 class 0x060400
[    6.555908] pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
[    6.562753] pci 0000:80:01.0: System wakeup disabled by ACPI
[    6.569123] pci 0000:80:03.0: [8086:340a] type 01 class 0x060400
[    6.575895] pci 0000:80:03.0: PME# supported from D0 D3hot D3cold
[    6.582741] pci 0000:80:03.0: System wakeup disabled by ACPI
[    6.589107] pci 0000:80:07.0: [8086:340e] type 01 class 0x060400
[    6.595870] pci 0000:80:07.0: PME# supported from D0 D3hot D3cold
[    6.602715] pci 0000:80:07.0: System wakeup disabled by ACPI
[    6.609080] pci 0000:80:09.0: [8086:3410] type 01 class 0x060400
[    6.615844] pci 0000:80:09.0: PME# supported from D0 D3hot D3cold
[    6.622689] pci 0000:80:09.0: System wakeup disabled by ACPI
[    6.629054] pci 0000:80:10.0: [8086:3425] type 00 class 0x080000
[    6.635869] pci 0000:80:10.1: [8086:3426] type 00 class 0x080000
[    6.642670] pci 0000:80:11.0: [8086:3427] type 00 class 0x080000
[    6.649479] pci 0000:80:11.1: [8086:3428] type 00 class 0x080000
[    6.656281] pci 0000:80:13.0: [8086:342d] type 00 class 0x080020
[    6.663002] pci 0000:80:13.0: reg 0x10: [mem 0xb4000000-0xb4000fff]
[    6.670050] pci 0000:80:13.0: PME# supported from D0 D3hot D3cold
[    6.676928] pci 0000:80:14.0: [8086:342e] type 00 class 0x080000
[    6.683744] pci 0000:80:14.1: [8086:3422] type 00 class 0x080000
[    6.690563] pci 0000:80:14.2: [8086:3423] type 00 class 0x080000
[    6.697376] pci 0000:80:14.3: [8086:3438] type 00 class 0x080000
[    6.704176] pci 0000:80:15.0: [8086:342f] type 00 class 0x080020
[    6.710981] pci 0000:80:16.0: [8086:3430] type 00 class 0x088000
[    6.717703] pci 0000:80:16.0: reg 0x10: [mem 0xfbf1c000-0xfbf1ffff 64bit]
[    6.725407] pci 0000:80:16.1: [8086:3431] type 00 class 0x088000
[    6.732129] pci 0000:80:16.1: reg 0x10: [mem 0xfbf18000-0xfbf1bfff 64bit]
[    6.739828] pci 0000:80:16.2: [8086:3432] type 00 class 0x088000
[    6.746550] pci 0000:80:16.2: reg 0x10: [mem 0xfbf14000-0xfbf17fff 64bit]
[    6.754251] pci 0000:80:16.3: [8086:3433] type 00 class 0x088000
[    6.760973] pci 0000:80:16.3: reg 0x10: [mem 0xfbf10000-0xfbf13fff 64bit]
[    6.768671] pci 0000:80:16.4: [8086:3429] type 00 class 0x088000
[    6.775392] pci 0000:80:16.4: reg 0x10: [mem 0xfbf0c000-0xfbf0ffff 64bit]
[    6.783092] pci 0000:80:16.5: [8086:342a] type 00 class 0x088000
[    6.789815] pci 0000:80:16.5: reg 0x10: [mem 0xfbf08000-0xfbf0bfff 64bit]
[    6.797512] pci 0000:80:16.6: [8086:342b] type 00 class 0x088000
[    6.804234] pci 0000:80:16.6: reg 0x10: [mem 0xfbf04000-0xfbf07fff 64bit]
[    6.811936] pci 0000:80:16.7: [8086:342c] type 00 class 0x088000
[    6.818658] pci 0000:80:16.7: reg 0x10: [mem 0xfbf00000-0xfbf03fff 64bit]
[    6.826627] pci 0000:80:00.0: PCI bridge to [bus 81]
[    6.832452] pci 0000:80:01.0: PCI bridge to [bus 82]
[    6.838276] pci 0000:80:03.0: PCI bridge to [bus 83]
[    6.844098] acpiphp: Slot [6] registered
[    6.848507] pci 0000:80:07.0: PCI bridge to [bus 84-86]
[    6.854346] pci 0000:80:07.0:   bridge window [io  0xb000-0xbfff]
[    6.861154] pci 0000:80:07.0:   bridge window [mem 0xb3000000-0xb3ffffff]
[    6.868740] pci 0000:80:07.0:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[    6.877657] acpiphp: Slot [7] registered
[    6.882067] pci 0000:80:09.0: PCI bridge to [bus 87-89]
[    6.887906] pci 0000:80:09.0:   bridge window [io  0xa000-0xafff]
[    6.894715] pci 0000:80:09.0:   bridge window [mem 0xb2000000-0xb2ffffff]
[    6.902304] pci 0000:80:09.0:   bridge window [mem 0xb1000000-0xb1ffffff 64bit pref]
[    6.910979] acpi PNP0A08:01: Disabling ASPM (FADT indicates it is unsupported)
[    6.919297] ACPI: PCI Root Bridge [PRB3] (domain 0000 [bus fc])
[    6.925913] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.935051] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    6.942477] PCI host bridge to bus 0000:fc
[    6.947053] pci_bus 0000:fc: root bus resource [bus fc]
[    6.952883] pci 0000:fc:00.0: [8086:2b00] type 00 class 0x060000
[    6.959649] pci 0000:fc:00.2: [8086:2b02] type 00 class 0x060000
[    6.966412] pci 0000:fc:00.4: [8086:2b22] type 00 class 0x060000
[    6.973176] pci 0000:fc:00.6: [8086:2b2a] type 00 class 0x060000
[    6.979940] pci 0000:fc:01.0: [8086:2b04] type 00 class 0x060000
[    6.986704] pci 0000:fc:02.0: [8086:2b08] type 00 class 0x060000
[    6.993469] pci 0000:fc:03.0: [8086:2b0c] type 00 class 0x060000
[    7.000235] pci 0000:fc:04.0: [8086:2b10] type 00 class 0x060000
[    7.007000] pci 0000:fc:05.0: [8086:2b14] type 00 class 0x060000
[    7.013763] pci 0000:fc:05.2: [8086:2b16] type 00 class 0x060000
[    7.020525] pci 0000:fc:05.4: [8086:2b13] type 00 class 0x060000
[    7.027288] pci 0000:fc:05.6: [8086:2b53] type 00 class 0x060000
[    7.034052] pci 0000:fc:06.0: [8086:2b18] type 00 class 0x060000
[    7.040817] pci 0000:fc:07.0: [8086:2b1c] type 00 class 0x060000
[    7.047577] pci 0000:fc:07.2: [8086:2b1e] type 00 class 0x060000
[    7.054340] pci 0000:fc:07.4: [8086:2b1b] type 00 class 0x060000
[    7.061092] pci 0000:fc:07.6: [8086:2b5b] type 00 class 0x060000
[    7.067854] pci 0000:fc:08.0: [8086:2b20] type 00 class 0x060000
[    7.074620] pci 0000:fc:09.0: [8086:2b24] type 00 class 0x060000
[    7.081386] pci 0000:fc:0a.0: [8086:2b28] type 00 class 0x060000
[    7.088151] pci 0000:fc:0b.0: [8086:2b2c] type 00 class 0x060000
[    7.094919] pci 0000:fc:0c.0: [8086:2b30] type 00 class 0x060000
[    7.101684] pci 0000:fc:0d.0: [8086:2b34] type 00 class 0x060000
[    7.108454] pci 0000:fc:0e.0: [8086:2b38] type 00 class 0x060000
[    7.115222] pci 0000:fc:0f.0: [8086:2b3c] type 00 class 0x060000
[    7.121988] pci 0000:fc:10.0: [8086:2b40] type 00 class 0x060000
[    7.128749] pci 0000:fc:10.2: [8086:2b42] type 00 class 0x060000
[    7.135510] pci 0000:fc:10.4: [8086:2b32] type 00 class 0x060000
[    7.142273] pci 0000:fc:10.6: [8086:2b3a] type 00 class 0x060000
[    7.149036] pci 0000:fc:11.0: [8086:2b44] type 00 class 0x060000
[    7.155799] pci 0000:fc:11.2: [8086:2b46] type 00 class 0x060000
[    7.162562] pci 0000:fc:11.4: [8086:2b36] type 00 class 0x060000
[    7.169325] pci 0000:fc:11.6: [8086:2b3e] type 00 class 0x060000
[    7.176087] pci 0000:fc:12.0: [8086:2b48] type 00 class 0x060000
[    7.182852] pci 0000:fc:13.0: [8086:2b4c] type 00 class 0x060000
[    7.189621] pci 0000:fc:14.0: [8086:2b50] type 00 class 0x060000
[    7.196384] pci 0000:fc:14.2: [8086:2b52] type 00 class 0x060000
[    7.203152] pci 0000:fc:15.0: [8086:2b54] type 00 class 0x060000
[    7.209916] pci 0000:fc:15.2: [8086:2b56] type 00 class 0x060000
[    7.216682] pci 0000:fc:16.0: [8086:2b58] type 00 class 0x060000
[    7.223447] pci 0000:fc:16.2: [8086:2b5a] type 00 class 0x060000
[    7.230213] pci 0000:fc:17.0: [8086:2b5c] type 00 class 0x060000
[    7.236976] pci 0000:fc:17.2: [8086:2b5e] type 00 class 0x060000
[    7.243742] pci 0000:fc:18.0: [8086:2b60] type 00 class 0x060000
[    7.250509] pci 0000:fc:18.2: [8086:2b62] type 00 class 0x060000
[    7.257276] pci 0000:fc:19.0: [8086:2b64] type 00 class 0x060000
[    7.264041] pci 0000:fc:19.2: [8086:2b66] type 00 class 0x060000
[    7.270808] pci 0000:fc:1a.0: [8086:2b68] type 00 class 0x060000
[    7.277574] pci 0000:fc:1b.0: [8086:2b6c] type 00 class 0x060000
[    7.284415] ACPI: PCI Root Bridge [PRB2] (domain 0000 [bus fd])
[    7.291031] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    7.300171] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    7.307598] PCI host bridge to bus 0000:fd
[    7.312174] pci_bus 0000:fd: root bus resource [bus fd]
[    7.318006] pci 0000:fd:00.0: [8086:2b00] type 00 class 0x060000
[    7.324772] pci 0000:fd:00.2: [8086:2b02] type 00 class 0x060000
[    7.331533] pci 0000:fd:00.4: [8086:2b22] type 00 class 0x060000
[    7.338297] pci 0000:fd:00.6: [8086:2b2a] type 00 class 0x060000
[    7.345059] pci 0000:fd:01.0: [8086:2b04] type 00 class 0x060000
[    7.351823] pci 0000:fd:02.0: [8086:2b08] type 00 class 0x060000
[    7.358592] pci 0000:fd:03.0: [8086:2b0c] type 00 class 0x060000
[    7.365360] pci 0000:fd:04.0: [8086:2b10] type 00 class 0x060000
[    7.372125] pci 0000:fd:05.0: [8086:2b14] type 00 class 0x060000
[    7.378887] pci 0000:fd:05.2: [8086:2b16] type 00 class 0x060000
[    7.385647] pci 0000:fd:05.4: [8086:2b13] type 00 class 0x060000
[    7.392409] pci 0000:fd:05.6: [8086:2b53] type 00 class 0x060000
[    7.399173] pci 0000:fd:06.0: [8086:2b18] type 00 class 0x060000
[    7.405937] pci 0000:fd:07.0: [8086:2b1c] type 00 class 0x060000
[    7.412697] pci 0000:fd:07.2: [8086:2b1e] type 00 class 0x060000
[    7.419459] pci 0000:fd:07.4: [8086:2b1b] type 00 class 0x060000
[    7.426218] pci 0000:fd:07.6: [8086:2b5b] type 00 class 0x060000
[    7.432984] pci 0000:fd:08.0: [8086:2b20] type 00 class 0x060000
[    7.439750] pci 0000:fd:09.0: [8086:2b24] type 00 class 0x060000
[    7.446517] pci 0000:fd:0a.0: [8086:2b28] type 00 class 0x060000
[    7.453283] pci 0000:fd:0b.0: [8086:2b2c] type 00 class 0x060000
[    7.460051] pci 0000:fd:0c.0: [8086:2b30] type 00 class 0x060000
[    7.466816] pci 0000:fd:0d.0: [8086:2b34] type 00 class 0x060000
[    7.473584] pci 0000:fd:0e.0: [8086:2b38] type 00 class 0x060000
[    7.480350] pci 0000:fd:0f.0: [8086:2b3c] type 00 class 0x060000
[    7.487117] pci 0000:fd:10.0: [8086:2b40] type 00 class 0x060000
[    7.493881] pci 0000:fd:10.2: [8086:2b42] type 00 class 0x060000
[    7.500648] pci 0000:fd:10.4: [8086:2b32] type 00 class 0x060000
[    7.507410] pci 0000:fd:10.6: [8086:2b3a] type 00 class 0x060000
[    7.514163] pci 0000:fd:11.0: [8086:2b44] type 00 class 0x060000
[    7.520918] pci 0000:fd:11.2: [8086:2b46] type 00 class 0x060000
[    7.527683] pci 0000:fd:11.4: [8086:2b36] type 00 class 0x060000
[    7.534447] pci 0000:fd:11.6: [8086:2b3e] type 00 class 0x060000
[    7.541210] pci 0000:fd:12.0: [8086:2b48] type 00 class 0x060000
[    7.547976] pci 0000:fd:13.0: [8086:2b4c] type 00 class 0x060000
[    7.554743] pci 0000:fd:14.0: [8086:2b50] type 00 class 0x060000
[    7.561506] pci 0000:fd:14.2: [8086:2b52] type 00 class 0x060000
[    7.568272] pci 0000:fd:15.0: [8086:2b54] type 00 class 0x060000
[    7.575036] pci 0000:fd:15.2: [8086:2b56] type 00 class 0x060000
[    7.581800] pci 0000:fd:16.0: [8086:2b58] type 00 class 0x060000
[    7.588565] pci 0000:fd:16.2: [8086:2b5a] type 00 class 0x060000
[    7.595331] pci 0000:fd:17.0: [8086:2b5c] type 00 class 0x060000
[    7.602095] pci 0000:fd:17.2: [8086:2b5e] type 00 class 0x060000
[    7.608860] pci 0000:fd:18.0: [8086:2b60] type 00 class 0x060000
[    7.615624] pci 0000:fd:18.2: [8086:2b62] type 00 class 0x060000
[    7.622389] pci 0000:fd:19.0: [8086:2b64] type 00 class 0x060000
[    7.629154] pci 0000:fd:19.2: [8086:2b66] type 00 class 0x060000
[    7.635921] pci 0000:fd:1a.0: [8086:2b68] type 00 class 0x060000
[    7.642686] pci 0000:fd:1b.0: [8086:2b6c] type 00 class 0x060000
[    7.649530] ACPI: PCI Root Bridge [PRB1] (domain 0000 [bus fe])
[    7.656147] acpi PNP0A03:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    7.665285] acpi PNP0A03:02: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    7.672712] PCI host bridge to bus 0000:fe
[    7.677290] pci_bus 0000:fe: root bus resource [bus fe]
[    7.683129] pci 0000:fe:00.0: [8086:2b00] type 00 class 0x060000
[    7.689892] pci 0000:fe:00.2: [8086:2b02] type 00 class 0x060000
[    7.696655] pci 0000:fe:00.4: [8086:2b22] type 00 class 0x060000
[    7.703420] pci 0000:fe:00.6: [8086:2b2a] type 00 class 0x060000
[    7.710181] pci 0000:fe:01.0: [8086:2b04] type 00 class 0x060000
[    7.716946] pci 0000:fe:02.0: [8086:2b08] type 00 class 0x060000
[    7.723711] pci 0000:fe:03.0: [8086:2b0c] type 00 class 0x060000
[    7.730477] pci 0000:fe:04.0: [8086:2b10] type 00 class 0x060000
[    7.737245] pci 0000:fe:05.0: [8086:2b14] type 00 class 0x060000
[    7.744010] pci 0000:fe:05.2: [8086:2b16] type 00 class 0x060000
[    7.750775] pci 0000:fe:05.4: [8086:2b13] type 00 class 0x060000
[    7.757538] pci 0000:fe:05.6: [8086:2b53] type 00 class 0x060000
[    7.764291] pci 0000:fe:06.0: [8086:2b18] type 00 class 0x060000
[    7.771046] pci 0000:fe:07.0: [8086:2b1c] type 00 class 0x060000
[    7.777813] pci 0000:fe:07.2: [8086:2b1e] type 00 class 0x060000
[    7.784574] pci 0000:fe:07.4: [8086:2b1b] type 00 class 0x060000
[    7.791336] pci 0000:fe:07.6: [8086:2b5b] type 00 class 0x060000
[    7.798088] pci 0000:fe:08.0: [8086:2b20] type 00 class 0x060000
[    7.804857] pci 0000:fe:09.0: [8086:2b24] type 00 class 0x060000
[    7.811623] pci 0000:fe:0a.0: [8086:2b28] type 00 class 0x060000
[    7.818387] pci 0000:fe:0b.0: [8086:2b2c] type 00 class 0x060000
[    7.825155] pci 0000:fe:0c.0: [8086:2b30] type 00 class 0x060000
[    7.831918] pci 0000:fe:0d.0: [8086:2b34] type 00 class 0x060000
[    7.838684] pci 0000:fe:0e.0: [8086:2b38] type 00 class 0x060000
[    7.845450] pci 0000:fe:0f.0: [8086:2b3c] type 00 class 0x060000
[    7.852214] pci 0000:fe:10.0: [8086:2b40] type 00 class 0x060000
[    7.858978] pci 0000:fe:10.2: [8086:2b42] type 00 class 0x060000
[    7.865741] pci 0000:fe:10.4: [8086:2b32] type 00 class 0x060000
[    7.872504] pci 0000:fe:10.6: [8086:2b3a] type 00 class 0x060000
[    7.879269] pci 0000:fe:11.0: [8086:2b44] type 00 class 0x060000
[    7.886030] pci 0000:fe:11.2: [8086:2b46] type 00 class 0x060000
[    7.892795] pci 0000:fe:11.4: [8086:2b36] type 00 class 0x060000
[    7.899556] pci 0000:fe:11.6: [8086:2b3e] type 00 class 0x060000
[    7.906316] pci 0000:fe:12.0: [8086:2b48] type 00 class 0x060000
[    7.913083] pci 0000:fe:13.0: [8086:2b4c] type 00 class 0x060000
[    7.919850] pci 0000:fe:14.0: [8086:2b50] type 00 class 0x060000
[    7.926614] pci 0000:fe:14.2: [8086:2b52] type 00 class 0x060000
[    7.933381] pci 0000:fe:15.0: [8086:2b54] type 00 class 0x060000
[    7.940144] pci 0000:fe:15.2: [8086:2b56] type 00 class 0x060000
[    7.946913] pci 0000:fe:16.0: [8086:2b58] type 00 class 0x060000
[    7.953677] pci 0000:fe:16.2: [8086:2b5a] type 00 class 0x060000
[    7.960443] pci 0000:fe:17.0: [8086:2b5c] type 00 class 0x060000
[    7.967211] pci 0000:fe:17.2: [8086:2b5e] type 00 class 0x060000
[    7.973977] pci 0000:fe:18.0: [8086:2b60] type 00 class 0x060000
[    7.980740] pci 0000:fe:18.2: [8086:2b62] type 00 class 0x060000
[    7.987502] pci 0000:fe:19.0: [8086:2b64] type 00 class 0x060000
[    7.994257] pci 0000:fe:19.2: [8086:2b66] type 00 class 0x060000
[    8.001020] pci 0000:fe:1a.0: [8086:2b68] type 00 class 0x060000
[    8.007787] pci 0000:fe:1b.0: [8086:2b6c] type 00 class 0x060000
[    8.014626] ACPI: PCI Root Bridge [PRB0] (domain 0000 [bus ff])
[    8.021235] acpi PNP0A03:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    8.030375] acpi PNP0A03:03: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    8.037804] PCI host bridge to bus 0000:ff
[    8.042381] pci_bus 0000:ff: root bus resource [bus ff]
[    8.048220] pci 0000:ff:00.0: [8086:2b00] type 00 class 0x060000
[    8.054984] pci 0000:ff:00.2: [8086:2b02] type 00 class 0x060000
[    8.061746] pci 0000:ff:00.4: [8086:2b22] type 00 class 0x060000
[    8.068497] pci 0000:ff:00.6: [8086:2b2a] type 00 class 0x060000
[    8.075260] pci 0000:ff:01.0: [8086:2b04] type 00 class 0x060000
[    8.082019] pci 0000:ff:02.0: [8086:2b08] type 00 class 0x060000
[    8.088782] pci 0000:ff:03.0: [8086:2b0c] type 00 class 0x060000
[    8.095543] pci 0000:ff:04.0: [8086:2b10] type 00 class 0x060000
[    8.102306] pci 0000:ff:05.0: [8086:2b14] type 00 class 0x060000
[    8.109065] pci 0000:ff:05.2: [8086:2b16] type 00 class 0x060000
[    8.115824] pci 0000:ff:05.4: [8086:2b13] type 00 class 0x060000
[    8.122582] pci 0000:ff:05.6: [8086:2b53] type 00 class 0x060000
[    8.129347] pci 0000:ff:06.0: [8086:2b18] type 00 class 0x060000
[    8.136107] pci 0000:ff:07.0: [8086:2b1c] type 00 class 0x060000
[    8.142866] pci 0000:ff:07.2: [8086:2b1e] type 00 class 0x060000
[    8.149630] pci 0000:ff:07.4: [8086:2b1b] type 00 class 0x060000
[    8.156391] pci 0000:ff:07.6: [8086:2b5b] type 00 class 0x060000
[    8.163149] pci 0000:ff:08.0: [8086:2b20] type 00 class 0x060000
[    8.169910] pci 0000:ff:09.0: [8086:2b24] type 00 class 0x060000
[    8.176674] pci 0000:ff:0a.0: [8086:2b28] type 00 class 0x060000
[    8.183438] pci 0000:ff:0b.0: [8086:2b2c] type 00 class 0x060000
[    8.190200] pci 0000:ff:0c.0: [8086:2b30] type 00 class 0x060000
[    8.196964] pci 0000:ff:0d.0: [8086:2b34] type 00 class 0x060000
[    8.203729] pci 0000:ff:0e.0: [8086:2b38] type 00 class 0x060000
[    8.210492] pci 0000:ff:0f.0: [8086:2b3c] type 00 class 0x060000
[    8.217254] pci 0000:ff:10.0: [8086:2b40] type 00 class 0x060000
[    8.224005] pci 0000:ff:10.2: [8086:2b42] type 00 class 0x060000
[    8.230766] pci 0000:ff:10.4: [8086:2b32] type 00 class 0x060000
[    8.237526] pci 0000:ff:10.6: [8086:2b3a] type 00 class 0x060000
[    8.244287] pci 0000:ff:11.0: [8086:2b44] type 00 class 0x060000
[    8.251043] pci 0000:ff:11.2: [8086:2b46] type 00 class 0x060000
[    8.257804] pci 0000:ff:11.4: [8086:2b36] type 00 class 0x060000
[    8.264563] pci 0000:ff:11.6: [8086:2b3e] type 00 class 0x060000
[    8.271323] pci 0000:ff:12.0: [8086:2b48] type 00 class 0x060000
[    8.278089] pci 0000:ff:13.0: [8086:2b4c] type 00 class 0x060000
[    8.284853] pci 0000:ff:14.0: [8086:2b50] type 00 class 0x060000
[    8.291617] pci 0000:ff:14.2: [8086:2b52] type 00 class 0x060000
[    8.298377] pci 0000:ff:15.0: [8086:2b54] type 00 class 0x060000
[    8.305136] pci 0000:ff:15.2: [8086:2b56] type 00 class 0x060000
[    8.311900] pci 0000:ff:16.0: [8086:2b58] type 00 class 0x060000
[    8.318659] pci 0000:ff:16.2: [8086:2b5a] type 00 class 0x060000
[    8.325421] pci 0000:ff:17.0: [8086:2b5c] type 00 class 0x060000
[    8.332182] pci 0000:ff:17.2: [8086:2b5e] type 00 class 0x060000
[    8.338944] pci 0000:ff:18.0: [8086:2b60] type 00 class 0x060000
[    8.345696] pci 0000:ff:18.2: [8086:2b62] type 00 class 0x060000
[    8.352459] pci 0000:ff:19.0: [8086:2b64] type 00 class 0x060000
[    8.359211] pci 0000:ff:19.2: [8086:2b66] type 00 class 0x060000
[    8.365973] pci 0000:ff:1a.0: [8086:2b68] type 00 class 0x060000
[    8.372727] pci 0000:ff:1b.0: [8086:2b6c] type 00 class 0x060000
[    8.400114] Section-unaligned hotplug range: start 0x1000000, size 0x7b000000
[    8.490835] ACPI: Enabled 34 GPEs in block 00 to 3F
[    8.496512] vgaarb: setting as boot device: PCI:0000:11:00.0
[    8.502838] vgaarb: device added: PCI:0000:11:00.0,decodes=io+mem,owns=io+mem,locks=none
[    8.511949] vgaarb: loaded
[    8.514972] vgaarb: bridge control possible 0000:11:00.0
[    8.521095] SCSI subsystem initialized
[    8.525320] ACPI: bus type USB registered
[    8.529825] usbcore: registered new interface driver usbfs
[    8.535961] usbcore: registered new interface driver hub
[    8.542213] usbcore: registered new device driver usb
[    8.547882] pps_core: LinuxPPS API ver. 1 registered
[    8.553416] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    8.563626] PTP clock support registered
[    8.568508] PCI: Using ACPI for IRQ routing
[    8.577671] PCI: pci_cache_line_size set to 64 bytes
[    8.583575] e820: reserve RAM buffer [mem 0x0009b400-0x0009ffff]
[    8.590284] e820: reserve RAM buffer [mem 0x7b452000-0x7bffffff]
[    8.597179] NetLabel: Initializing
[    8.600977] NetLabel:  domain hash size = 128
[    8.605842] NetLabel:  protocols = UNLABELED CIPSOv4
[    8.611403] NetLabel:  unlabeled traffic allowed by default
[    8.617783] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    8.623572] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    8.632452] Switched to clocksource hpet
[    8.652098] pnp: PnP ACPI init
[    8.655958] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    8.664816] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    8.679902] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    8.687492] system 00:01: [io  0x0500-0x057f] could not be reserved
[    8.694498] system 00:01: [io  0x0400-0x047f] could not be reserved
[    8.701501] system 00:01: [io  0x0540-0x057f] has been reserved
[    8.708116] system 00:01: [io  0x0600-0x061f] has been reserved
[    8.714731] system 00:01: [io  0x0880-0x0883] has been reserved
[    8.721345] system 00:01: [io  0x0ca4-0x0ca5] has been reserved
[    8.727960] system 00:01: [io  0x0800-0x081f] has been reserved
[    8.734576] system 00:01: [mem 0xfed1c000-0xfed3ffff] could not be reserved
[    8.742356] system 00:01: [mem 0xfed45000-0xfed8bfff] has been reserved
[    8.749749] system 00:01: [mem 0xff000000-0xffffffff] has been reserved
[    8.757142] system 00:01: [mem 0xfee00000-0xfeefffff] has been reserved
[    8.764534] system 00:01: [mem 0xfed12000-0xfed1200f] has been reserved
[    8.771926] system 00:01: [mem 0xfed12010-0xfed1201f] has been reserved
[    8.779318] system 00:01: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    8.786710] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    8.794502] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    8.803356] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    8.818471] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    8.825942] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    8.834797] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    8.849915] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    8.857269] pnp 00:04: Plug and Play ACPI device, IDs PNP0c31 (active)
[    8.864631] pnp 00:05: Plug and Play ACPI device, IDs IPI0001 (active)
[    8.873188] pnp: PnP ACPI: found 6 devices
[    8.884645] pci 0000:07:00.0: can't claim BAR 6 [mem 0xfffc0000-0xffffffff pref]: no compatible bridge window
[    8.895728] pci 0000:11:00.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]: no compatible bridge window
[    8.906891] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    8.912731] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    8.919543] pci 0000:00:01.0:   bridge window [mem 0x95b00000-0x95bfffff]
[    8.927132] pci 0000:00:02.0: PCI bridge to [bus 04-06]
[    8.932973] pci 0000:00:02.0:   bridge window [io  0x4000-0x4fff]
[    8.939784] pci 0000:00:02.0:   bridge window [mem 0x95a00000-0x95afffff]
[    8.947379] pci 0000:07:00.0: BAR 6: assigned [mem 0x95980000-0x959bffff pref]
[    8.955450] pci 0000:00:03.0: PCI bridge to [bus 07]
[    8.961000] pci 0000:00:03.0:   bridge window [io  0x3000-0x3fff]
[    8.967810] pci 0000:00:03.0:   bridge window [mem 0x95900000-0x959fffff]
[    8.975396] pci 0000:00:03.0:   bridge window [mem 0x95d00000-0x95dfffff 64bit pref]
[    8.984053] pci 0000:00:05.0: PCI bridge to [bus 08-0a]
[    8.989891] pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
[    8.996701] pci 0000:00:05.0:   bridge window [mem 0x94900000-0x958fffff]
[    9.004287] pci 0000:00:05.0:   bridge window [mem 0x91900000-0x928fffff 64bit pref]
[    9.012946] pci 0000:00:07.0: PCI bridge to [bus 0b-0d]
[    9.018785] pci 0000:00:07.0:   bridge window [io  0x1000-0x1fff]
[    9.025597] pci 0000:00:07.0:   bridge window [mem 0x93900000-0x948fffff]
[    9.033184] pci 0000:00:07.0:   bridge window [mem 0x92900000-0x938fffff 64bit pref]
[    9.041838] pci 0000:00:09.0: PCI bridge to [bus 0e]
[    9.047393] pci 0000:00:0a.0: PCI bridge to [bus 0f]
[    9.052939] pci 0000:00:1c.0: PCI bridge to [bus 10]
[    9.058478] pci 0000:00:1c.0:   bridge window [io  0x7000-0x7fff]
[    9.065288] pci 0000:00:1c.0:   bridge window [mem 0x95e00000-0x95ffffff]
[    9.072875] pci 0000:00:1c.0:   bridge window [mem 0xfc000000000-0xfc0001fffff 64bit pref]
[    9.082116] pci 0000:11:00.0: BAR 6: assigned [mem 0x91810000-0x9181ffff pref]
[    9.090186] pci 0000:00:1c.4: PCI bridge to [bus 11]
[    9.095735] pci 0000:00:1c.4:   bridge window [mem 0x91000000-0x918fffff]
[    9.103322] pci 0000:00:1c.4:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
[    9.111979] pci 0000:00:1e.0: PCI bridge to [bus 12]
[    9.117536] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    9.123764] pci_bus 0000:00: resource 5 [io  0x1000-0x9fff]
[    9.129990] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    9.136995] pci_bus 0000:00: resource 7 [mem 0xfed40000-0xfedfffff]
[    9.143998] pci_bus 0000:00: resource 8 [mem 0x90000000-0xafffffff]
[    9.151003] pci_bus 0000:00: resource 9 [mem 0xfc000000000-0xfc07fffffff]
[    9.158588] pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
[    9.164816] pci_bus 0000:01: resource 1 [mem 0x95b00000-0x95bfffff]
[    9.171819] pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
[    9.178045] pci_bus 0000:04: resource 1 [mem 0x95a00000-0x95afffff]
[    9.185048] pci_bus 0000:07: resource 0 [io  0x3000-0x3fff]
[    9.191274] pci_bus 0000:07: resource 1 [mem 0x95900000-0x959fffff]
[    9.198276] pci_bus 0000:07: resource 2 [mem 0x95d00000-0x95dfffff 64bit pref]
[    9.206347] pci_bus 0000:08: resource 0 [io  0x2000-0x2fff]
[    9.212574] pci_bus 0000:08: resource 1 [mem 0x94900000-0x958fffff]
[    9.219577] pci_bus 0000:08: resource 2 [mem 0x91900000-0x928fffff 64bit pref]
[    9.227648] pci_bus 0000:0b: resource 0 [io  0x1000-0x1fff]
[    9.233873] pci_bus 0000:0b: resource 1 [mem 0x93900000-0x948fffff]
[    9.240876] pci_bus 0000:0b: resource 2 [mem 0x92900000-0x938fffff 64bit pref]
[    9.248947] pci_bus 0000:10: resource 0 [io  0x7000-0x7fff]
[    9.255172] pci_bus 0000:10: resource 1 [mem 0x95e00000-0x95ffffff]
[    9.262177] pci_bus 0000:10: resource 2 [mem 0xfc000000000-0xfc0001fffff 64bit pref]
[    9.270829] pci_bus 0000:11: resource 1 [mem 0x91000000-0x918fffff]
[    9.277832] pci_bus 0000:11: resource 2 [mem 0x90000000-0x90ffffff 64bit pref]
[    9.285903] pci_bus 0000:12: resource 4 [io  0x0000-0x0cf7]
[    9.292129] pci_bus 0000:12: resource 5 [io  0x1000-0x9fff]
[    9.298357] pci_bus 0000:12: resource 6 [mem 0x000a0000-0x000bffff]
[    9.305359] pci_bus 0000:12: resource 7 [mem 0xfed40000-0xfedfffff]
[    9.312362] pci_bus 0000:12: resource 8 [mem 0x90000000-0xafffffff]
[    9.319364] pci_bus 0000:12: resource 9 [mem 0xfc000000000-0xfc07fffffff]
[    9.326987] pci 0000:80:00.0: PCI bridge to [bus 81]
[    9.332542] pci 0000:80:01.0: PCI bridge to [bus 82]
[    9.338095] pci 0000:80:03.0: PCI bridge to [bus 83]
[    9.343648] pci 0000:80:07.0: PCI bridge to [bus 84-86]
[    9.349487] pci 0000:80:07.0:   bridge window [io  0xb000-0xbfff]
[    9.356297] pci 0000:80:07.0:   bridge window [mem 0xb3000000-0xb3ffffff]
[    9.363884] pci 0000:80:07.0:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[    9.372540] pci 0000:80:09.0: PCI bridge to [bus 87-89]
[    9.378378] pci 0000:80:09.0:   bridge window [io  0xa000-0xafff]
[    9.385187] pci 0000:80:09.0:   bridge window [mem 0xb2000000-0xb2ffffff]
[    9.392773] pci 0000:80:09.0:   bridge window [mem 0xb1000000-0xb1ffffff 64bit pref]
[    9.401428] pci_bus 0000:80: resource 4 [io  0xa000-0xffff]
[    9.407655] pci_bus 0000:80: resource 5 [mem 0xb0000000-0xfbffffff]
[    9.414659] pci_bus 0000:80: resource 6 [mem 0xfc080000000-0xfc0ffffffff]
[    9.422245] pci_bus 0000:84: resource 0 [io  0xb000-0xbfff]
[    9.428470] pci_bus 0000:84: resource 1 [mem 0xb3000000-0xb3ffffff]
[    9.435474] pci_bus 0000:84: resource 2 [mem 0xb0000000-0xb0ffffff 64bit pref]
[    9.443545] pci_bus 0000:87: resource 0 [io  0xa000-0xafff]
[    9.449771] pci_bus 0000:87: resource 1 [mem 0xb2000000-0xb2ffffff]
[    9.456773] pci_bus 0000:87: resource 2 [mem 0xb1000000-0xb1ffffff 64bit pref]
[    9.464949] NET: Registered protocol family 2
[    9.470788] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    9.480308] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    9.488059] TCP: Hash tables configured (established 524288 bind 65536)
[    9.495500] TCP: reno registered
[    9.499301] UDP hash table entries: 65536 (order: 9, 2097152 bytes)
[    9.506974] UDP-Lite hash table entries: 65536 (order: 9, 2097152 bytes)
[    9.515301] NET: Registered protocol family 1
[    9.520454] RPC: Registered named UNIX socket transport module.
[    9.527075] RPC: Registered udp transport module.
[    9.532331] RPC: Registered tcp transport module.
[    9.537591] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    9.548169] IOAPIC[0]: Set routing entry (8-16 -> 0x71 -> IRQ 16 Mode:1 Active:1 Dest:1)
[    9.557227] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:71 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    9.572599] IOAPIC[0]: Set routing entry (8-21 -> 0x81 -> IRQ 21 Mode:1 Active:1 Dest:1)
[    9.581646] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:81 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    9.597001] IOAPIC[0]: Set routing entry (8-19 -> 0x91 -> IRQ 19 Mode:1 Active:1 Dest:1)
[    9.606048] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:91 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    9.621396] IOAPIC[0]: Set routing entry (8-18 -> 0xa1 -> IRQ 18 Mode:1 Active:1 Dest:1)
[    9.630444] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:A1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    9.645807] IOAPIC[0]: Set routing entry (8-23 -> 0xb1 -> IRQ 23 Mode:1 Active:1 Dest:1)
[    9.654855] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    9.670218] IOAPIC[0]: Set routing entry (8-19 -> 0xc1 -> IRQ 19 Mode:1 Active:1 Dest:1)
[    9.679268] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:C1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    9.694623] IOAPIC[0]: Set routing entry (8-18 -> 0xd1 -> IRQ 18 Mode:1 Active:1 Dest:1)
[    9.703672] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:D1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    9.719042] IOAPIC[0]: Set routing entry (8-23 -> 0xe1 -> IRQ 23 Mode:1 Active:1 Dest:1)
[    9.728089] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    9.743316] PCI: CLS mismatch (64 != 32), using 64 bytes
[    9.749264] pci 0000:11:00.0: Video device with shadowed ROM
[    9.755913] Unpacking initramfs...
[   12.467102] Freeing initrd memory: 124540K (ffff882076661000 - ffff88207e000000)
[   12.475677] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   12.482878] software IO TLB [mem 0x77452000-0x7b452000] (64MB) mapped at [ffff880077452000-ffff88007b451fff]
[   12.505318] futex hash table entries: 32768 (order: 9, 2097152 bytes)
[   12.513025] Initialise system trusted keyring
[   12.517928] audit: initializing netlink subsys (disabled)
[   12.523973] audit: type=2000 audit(1415236605.318:1): initialized
[   12.531820] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   12.540704] zpool: loaded
[   12.543626] zbud: loaded
[   12.546725] VFS: Disk quotas dquot_6.5.2
[   12.551213] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   12.559471] SGI XFS with ACLs, security attributes, no debug enabled
[   12.568139] 9p: Installing v9fs 9p2000 file system support
[   12.574326] msgmni has been set to 32768
[   12.578823] Key type big_key registered
[   12.583114] SELinux:  Registering netfilter hooks
[   12.592125] NET: Registered protocol family 38
[   12.597099] Key type asymmetric registered
[   12.601678] Asymmetric key parser 'x509' registered
[   12.607181] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[   12.615665] io scheduler noop registered
[   12.620052] io scheduler deadline registered (default)
[   12.625802] io scheduler cfq registered
[   12.630668] IOAPIC[1]: Set routing entry (9-4 -> 0x22 -> IRQ 24 Mode:1 Active:1 Dest:1)
[   12.639621] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:22 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.654724] pcieport 0000:00:01.0: irq 25 for MSI/MSI-X
[   12.660774] IOAPIC[1]: Set routing entry (9-5 -> 0x52 -> IRQ 26 Mode:1 Active:1 Dest:1)
[   12.669725] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:52 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.684832] pcieport 0000:00:02.0: irq 27 for MSI/MSI-X
[   12.690871] IOAPIC[1]: Set routing entry (9-0 -> 0x72 -> IRQ 28 Mode:1 Active:1 Dest:1)
[   12.699819] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:72 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.714911] pcieport 0000:00:03.0: irq 29 for MSI/MSI-X
[   12.720963] IOAPIC[1]: Set routing entry (9-2 -> 0x92 -> IRQ 30 Mode:1 Active:1 Dest:1)
[   12.729914] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:92 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.744997] pcieport 0000:00:05.0: irq 31 for MSI/MSI-X
[   12.751042] IOAPIC[1]: Set routing entry (9-6 -> 0xb2 -> IRQ 32 Mode:1 Active:1 Dest:1)
[   12.759995] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B2 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.775086] pcieport 0000:00:07.0: irq 33 for MSI/MSI-X
[   12.781138] IOAPIC[1]: Set routing entry (9-8 -> 0xd2 -> IRQ 34 Mode:1 Active:1 Dest:1)
[   12.790082] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:D2 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.805173] pcieport 0000:00:09.0: irq 35 for MSI/MSI-X
[   12.811216] IOAPIC[1]: Set routing entry (9-9 -> 0x23 -> IRQ 36 Mode:1 Active:1 Dest:1)
[   12.820169] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:23 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.835259] pcieport 0000:00:0a.0: irq 37 for MSI/MSI-X
[   12.841307] IOAPIC[0]: Set routing entry (8-16 -> 0x53 -> IRQ 16 Mode:1 Active:1 Dest:1)
[   12.850356] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:53 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[   12.865447] pcieport 0000:00:1c.0: irq 38 for MSI/MSI-X
[   12.871534] pcieport 0000:00:1c.4: irq 39 for MSI/MSI-X
[   12.877613] IOAPIC[2]: Set routing entry (10-23 -> 0x83 -> IRQ 40 Mode:1 Active:1 Dest:1)
[   12.886751] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:83 Dest:00000001 SID:8098 SQ:0 SVT:1)
[   12.901842] pcieport 0000:80:00.0: irq 41 for MSI/MSI-X
[   12.907871] IOAPIC[2]: Set routing entry (10-4 -> 0xa3 -> IRQ 42 Mode:1 Active:1 Dest:1)
[   12.916921] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:A3 Dest:00000001 SID:8098 SQ:0 SVT:1)
[   12.932015] pcieport 0000:80:01.0: irq 43 for MSI/MSI-X
[   12.938037] IOAPIC[2]: Set routing entry (10-0 -> 0xc3 -> IRQ 44 Mode:1 Active:1 Dest:1)
[   12.947084] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:C3 Dest:00000001 SID:8098 SQ:0 SVT:1)
[   12.962173] pcieport 0000:80:03.0: irq 45 for MSI/MSI-X
[   12.968192] IOAPIC[2]: Set routing entry (10-6 -> 0xe3 -> IRQ 46 Mode:1 Active:1 Dest:1)
[   12.977240] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E3 Dest:00000001 SID:8098 SQ:0 SVT:1)
[   12.992329] pcieport 0000:80:07.0: irq 47 for MSI/MSI-X
[   12.998345] IOAPIC[2]: Set routing entry (10-8 -> 0x44 -> IRQ 48 Mode:1 Active:1 Dest:1)
[   13.007392] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:44 Dest:00000001 SID:8098 SQ:0 SVT:1)
[   13.022473] pcieport 0000:80:09.0: irq 49 for MSI/MSI-X
[   13.028453] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[   13.036238] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[   13.043532] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[   13.050829] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[   13.058335] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[   13.066116] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[   13.073412] pci 0000:04:00.1: Signaling PME through PCIe PME interrupt
[   13.080707] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[   13.088211] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[   13.095992] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[   13.103287] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[   13.110792] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[   13.118574] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[   13.126080] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[   13.133861] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[   13.141367] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[   13.149148] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[   13.156652] pcieport 0000:00:0a.0: Signaling PME through PCIe PME interrupt
[   13.164435] pcie_pme 0000:00:0a.0:pcie01: service driver pcie_pme loaded
[   13.171944] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[   13.179727] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[   13.187235] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[   13.195015] pci 0000:11:00.0: Signaling PME through PCIe PME interrupt
[   13.202312] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[   13.209818] pcieport 0000:80:00.0: Signaling PME through PCIe PME interrupt
[   13.217600] pcie_pme 0000:80:00.0:pcie01: service driver pcie_pme loaded
[   13.225104] pcieport 0000:80:01.0: Signaling PME through PCIe PME interrupt
[   13.232887] pcie_pme 0000:80:01.0:pcie01: service driver pcie_pme loaded
[   13.240390] pcieport 0000:80:03.0: Signaling PME through PCIe PME interrupt
[   13.248164] pcie_pme 0000:80:03.0:pcie01: service driver pcie_pme loaded
[   13.255667] pcieport 0000:80:07.0: Signaling PME through PCIe PME interrupt
[   13.263441] pcie_pme 0000:80:07.0:pcie01: service driver pcie_pme loaded
[   13.270946] pcieport 0000:80:09.0: Signaling PME through PCIe PME interrupt
[   13.278728] pcie_pme 0000:80:09.0:pcie01: service driver pcie_pme loaded
[   13.286226] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   13.292472] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   13.299926] intel_idle: MWAIT substates: 0x1120
[   13.304989] intel_idle: v0.4 model 0x2F
[   13.309274] intel_idle: lapic_timer_reliable_states 0xffffffff
[   13.319461] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[   13.328799] ACPI: Sleep Button [SLPB]
[   13.332942] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   13.341209] ACPI: Power Button [PWRF]
[   13.415142] ERST: Error Record Serialization Table (ERST) support is initialized.
[   13.423542] pstore: Registered erst as persistent store backend
[   13.432059] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[   13.440750] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   13.468407] serial 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[   13.496479] tsc: Refined TSC clocksource calibration: 2393.999 MHz
[   13.498258] serial 00:03: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[   13.500700] Non-volatile memory driver v1.3
[   13.500727] Linux agpgart interface v0.103
[   13.501671] tpm_tis 00:04: 1.2 TPM (device-id 0x0, rev-id 78)
[   13.537532] tpm_tis 00:04: TPM is disabled/deactivated (0x6)
[   13.544654] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000428-0x000000000000042f (\GPE0) (20140926/utaddress-258)
[   13.562002] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.573374] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x000000000000052c-0x000000000000052c (\GPIV) (20140926/utaddress-258)
[   13.590695] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000052f (\_SI_.SIOR) (20140926/utaddress-258)
[   13.608491] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.619887] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   13.626952] rdac: device handler registered
[   13.632029] hp_sw: device handler registered
[   13.636815] emc: device handler registered
[   13.641393] alua: device handler registered
[   13.646113] libphy: Fixed MDIO Bus: probed
[   13.650817] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[   13.658695] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   13.665168] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   13.671688] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[   13.678373] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
[   13.686252] igb: Copyright (c) 2007-2014 Intel Corporation.
[   13.692826] igb 0000:01:00.0: irq 50 for MSI/MSI-X
[   13.698201] igb 0000:01:00.0: irq 51 for MSI/MSI-X
[   13.703568] igb 0000:01:00.0: irq 52 for MSI/MSI-X
[   13.708935] igb 0000:01:00.0: irq 53 for MSI/MSI-X
[   13.714303] igb 0000:01:00.0: irq 54 for MSI/MSI-X
[   13.719672] igb 0000:01:00.0: irq 55 for MSI/MSI-X
[   13.725043] igb 0000:01:00.0: irq 56 for MSI/MSI-X
[   13.730411] igb 0000:01:00.0: irq 57 for MSI/MSI-X
[   13.735778] igb 0000:01:00.0: irq 58 for MSI/MSI-X
[   13.904406] igb 0000:01:00.0: irq 50 for MSI/MSI-X
[   13.909775] igb 0000:01:00.0: irq 51 for MSI/MSI-X
[   13.915142] igb 0000:01:00.0: irq 52 for MSI/MSI-X
[   13.920509] igb 0000:01:00.0: irq 53 for MSI/MSI-X
[   13.925877] igb 0000:01:00.0: irq 54 for MSI/MSI-X
[   13.931242] igb 0000:01:00.0: irq 55 for MSI/MSI-X
[   13.936608] igb 0000:01:00.0: irq 56 for MSI/MSI-X
[   13.941975] igb 0000:01:00.0: irq 57 for MSI/MSI-X
[   13.947343] igb 0000:01:00.0: irq 58 for MSI/MSI-X
[   14.143015] igb 0000:01:00.0: added PHC on eth0
[   14.148088] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[   14.155772] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x2) 60:eb:69:82:38:2a
[   14.163746] igb 0000:01:00.0: eth0: PBA No: Unknown
[   14.169196] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   14.177732] IOAPIC[1]: Set routing entry (9-16 -> 0xe6 -> IRQ 59 Mode:1 Active:1 Dest:1)
[   14.186781] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E6 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   14.202113] igb 0000:01:00.1: irq 60 for MSI/MSI-X
[   14.207481] igb 0000:01:00.1: irq 61 for MSI/MSI-X
[   14.212849] igb 0000:01:00.1: irq 62 for MSI/MSI-X
[   14.218218] igb 0000:01:00.1: irq 63 for MSI/MSI-X
[   14.223587] igb 0000:01:00.1: irq 64 for MSI/MSI-X
[   14.228947] igb 0000:01:00.1: irq 65 for MSI/MSI-X
[   14.234308] igb 0000:01:00.1: irq 66 for MSI/MSI-X
[   14.239677] igb 0000:01:00.1: irq 67 for MSI/MSI-X
[   14.245038] igb 0000:01:00.1: irq 68 for MSI/MSI-X
[   14.406842] igb 0000:01:00.1: irq 60 for MSI/MSI-X
[   14.412215] igb 0000:01:00.1: irq 61 for MSI/MSI-X
[   14.417584] igb 0000:01:00.1: irq 62 for MSI/MSI-X
[   14.422944] igb 0000:01:00.1: irq 63 for MSI/MSI-X
[   14.428310] igb 0000:01:00.1: irq 64 for MSI/MSI-X
[   14.433677] igb 0000:01:00.1: irq 65 for MSI/MSI-X
[   14.439045] igb 0000:01:00.1: irq 66 for MSI/MSI-X
[   14.444413] igb 0000:01:00.1: irq 67 for MSI/MSI-X
[   14.449777] igb 0000:01:00.1: irq 68 for MSI/MSI-X
[   14.529506] Switched to clocksource tsc
[   14.636537] igb 0000:01:00.1: added PHC on eth1
[   14.641610] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[   14.649291] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x2) 60:eb:69:82:38:2b
[   14.657264] igb 0000:01:00.1: eth1: PBA No: Unknown
[   14.662714] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   14.671499] igb 0000:04:00.0: irq 69 for MSI/MSI-X
[   14.676879] igb 0000:04:00.0: irq 70 for MSI/MSI-X
[   14.682244] igb 0000:04:00.0: irq 71 for MSI/MSI-X
[   14.687608] igb 0000:04:00.0: irq 74 for MSI/MSI-X
[   14.692975] igb 0000:04:00.0: irq 75 for MSI/MSI-X
[   14.698341] igb 0000:04:00.0: irq 76 for MSI/MSI-X
[   14.703708] igb 0000:04:00.0: irq 77 for MSI/MSI-X
[   14.709073] igb 0000:04:00.0: irq 78 for MSI/MSI-X
[   14.714439] igb 0000:04:00.0: irq 79 for MSI/MSI-X
[   14.876300] igb 0000:04:00.0: irq 69 for MSI/MSI-X
[   14.881671] igb 0000:04:00.0: irq 70 for MSI/MSI-X
[   14.887037] igb 0000:04:00.0: irq 71 for MSI/MSI-X
[   14.892401] igb 0000:04:00.0: irq 74 for MSI/MSI-X
[   14.897767] igb 0000:04:00.0: irq 75 for MSI/MSI-X
[   14.903132] igb 0000:04:00.0: irq 76 for MSI/MSI-X
[   14.908496] igb 0000:04:00.0: irq 77 for MSI/MSI-X
[   14.913863] igb 0000:04:00.0: irq 78 for MSI/MSI-X
[   14.919227] igb 0000:04:00.0: irq 79 for MSI/MSI-X
[   15.106799] igb 0000:04:00.0: added PHC on eth2
[   15.111870] igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network Connection
[   15.119551] igb 0000:04:00.0: eth2: (PCIe:2.5Gb/s:Width x2) 60:eb:69:82:38:2c
[   15.127525] igb 0000:04:00.0: eth2: PBA No: Unknown
[   15.132972] igb 0000:04:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   15.141492] IOAPIC[1]: Set routing entry (9-17 -> 0xe9 -> IRQ 80 Mode:1 Active:1 Dest:1)
[   15.150538] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E9 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   15.165862] igb 0000:04:00.1: irq 81 for MSI/MSI-X
[   15.171231] igb 0000:04:00.1: irq 82 for MSI/MSI-X
[   15.176597] igb 0000:04:00.1: irq 83 for MSI/MSI-X
[   15.181962] igb 0000:04:00.1: irq 84 for MSI/MSI-X
[   15.187328] igb 0000:04:00.1: irq 85 for MSI/MSI-X
[   15.192694] igb 0000:04:00.1: irq 86 for MSI/MSI-X
[   15.198073] igb 0000:04:00.1: irq 87 for MSI/MSI-X
[   15.203437] igb 0000:04:00.1: irq 88 for MSI/MSI-X
[   15.208802] igb 0000:04:00.1: irq 89 for MSI/MSI-X
[   15.370420] igb 0000:04:00.1: irq 81 for MSI/MSI-X
[   15.375789] igb 0000:04:00.1: irq 82 for MSI/MSI-X
[   15.381154] igb 0000:04:00.1: irq 83 for MSI/MSI-X
[   15.386519] igb 0000:04:00.1: irq 84 for MSI/MSI-X
[   15.391883] igb 0000:04:00.1: irq 85 for MSI/MSI-X
[   15.397247] igb 0000:04:00.1: irq 86 for MSI/MSI-X
[   15.402610] igb 0000:04:00.1: irq 87 for MSI/MSI-X
[   15.407973] igb 0000:04:00.1: irq 88 for MSI/MSI-X
[   15.413335] igb 0000:04:00.1: irq 89 for MSI/MSI-X
[   15.600133] igb 0000:04:00.1: added PHC on eth3
[   15.605197] igb 0000:04:00.1: Intel(R) Gigabit Ethernet Network Connection
[   15.612878] igb 0000:04:00.1: eth3: (PCIe:2.5Gb/s:Width x2) 60:eb:69:82:38:2d
[   15.620850] igb 0000:04:00.1: eth3: PBA No: Unknown
[   15.626298] igb 0000:04:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   15.634795] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[   15.643446] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[   15.650042] usbcore: registered new interface driver catc
[   15.656085] usbcore: registered new interface driver kaweth
[   15.662311] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   15.670580] usbcore: registered new interface driver pegasus
[   15.676908] usbcore: registered new interface driver rtl8150
[   15.683241] usbcore: registered new interface driver asix
[   15.689278] usbcore: registered new interface driver cdc_ether
[   15.695804] usbcore: registered new interface driver cdc_eem
[   15.702133] usbcore: registered new interface driver dm9601
[   15.708369] usbcore: registered new interface driver smsc75xx
[   15.714798] usbcore: registered new interface driver smsc95xx
[   15.721226] usbcore: registered new interface driver gl620a
[   15.727462] usbcore: registered new interface driver net1080
[   15.733793] usbcore: registered new interface driver plusb
[   15.739926] usbcore: registered new interface driver rndis_host
[   15.746546] usbcore: registered new interface driver cdc_subset
[   15.753167] usbcore: registered new interface driver zaurus
[   15.759402] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   15.767678] usbcore: registered new interface driver int51x1
[   15.774007] usbcore: registered new interface driver ipheth
[   15.780243] usbcore: registered new interface driver sierra_net
[   15.787196] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   15.794496] ehci-pci: EHCI PCI platform driver
[   15.799636] IOAPIC[0]: Set routing entry (8-18 -> 0x9b -> IRQ 18 Mode:1 Active:1 Dest:1)
[   15.808682] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:9B Dest:00000001 SID:F0FF SQ:0 SVT:1)
[   15.823816] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   15.830003] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   15.838294] ehci-pci 0000:00:1a.7: debug port 1
[   15.847273] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[   15.854874] ehci-pci 0000:00:1a.7: irq 18, io mem 0x95c01000
[   15.867030] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   15.873591] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   15.881271] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.889434] usb usb1: Product: EHCI Host Controller
[   15.894978] usb usb1: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce ehci_hcd
[   15.903039] usb usb1: SerialNumber: 0000:00:1a.7
[   15.908730] hub 1-0:1.0: USB hub found
[   15.912955] hub 1-0:1.0: 6 ports detected
[   15.917893] IOAPIC[0]: Set routing entry (8-23 -> 0xbb -> IRQ 23 Mode:1 Active:1 Dest:1)
[   15.926939] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:BB Dest:00000001 SID:F0FF SQ:0 SVT:1)
[   15.942045] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   15.948170] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   15.956448] ehci-pci 0000:00:1d.7: debug port 1
[   15.965409] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[   15.973007] ehci-pci 0000:00:1d.7: irq 23, io mem 0x95c00000
[   15.985020] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   15.991488] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   15.999123] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   16.007192] usb usb2: Product: EHCI Host Controller
[   16.012639] usb usb2: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce ehci_hcd
[   16.020611] usb usb2: SerialNumber: 0000:00:1d.7
[   16.026534] hub 2-0:1.0: USB hub found
[   16.030754] hub 2-0:1.0: 6 ports detected
[   16.035408] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   16.042337] ohci-pci: OHCI PCI platform driver
[   16.047330] uhci_hcd: USB Universal Host Controller Interface driver
[   16.054602] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   16.060719] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   16.069001] uhci_hcd 0000:00:1a.0: detected 2 ports
[   16.074480] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000060c0
[   16.081052] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   16.088638] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   16.096707] usb usb3: Product: UHCI Host Controller
[   16.102154] usb usb3: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
[   16.110124] usb usb3: SerialNumber: 0000:00:1a.0
[   16.115713] hub 3-0:1.0: USB hub found
[   16.119922] hub 3-0:1.0: 2 ports detected
[   16.124674] IOAPIC[0]: Set routing entry (8-21 -> 0xeb -> IRQ 21 Mode:1 Active:1 Dest:1)
[   16.133722] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:EB Dest:00000001 SID:F0FF SQ:0 SVT:1)
[   16.148819] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   16.154939] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   16.163229] uhci_hcd 0000:00:1a.1: detected 2 ports
[   16.168710] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000060a0
[   16.175178] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   16.182763] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   16.190831] usb usb4: Product: UHCI Host Controller
[   16.196278] usb usb4: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
[   16.204248] usb usb4: SerialNumber: 0000:00:1a.1
[   16.209823] hub 4-0:1.0: USB hub found
[   16.214031] hub 4-0:1.0: 2 ports detected
[   16.218773] IOAPIC[0]: Set routing entry (8-19 -> 0x4c -> IRQ 19 Mode:1 Active:1 Dest:1)
[   16.227872] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:4C Dest:00000001 SID:F0FF SQ:0 SVT:1)
[   16.242932] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   16.249030] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   16.257307] uhci_hcd 0000:00:1a.2: detected 2 ports
[   16.262786] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00006080
[   16.269253] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   16.276838] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   16.284906] usb usb5: Product: UHCI Host Controller
[   16.290353] usb usb5: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
[   16.298324] usb usb5: SerialNumber: 0000:00:1a.2
[   16.304131] hub 5-0:1.0: USB hub found
[   16.308435] hub 5-0:1.0: 2 ports detected
[   16.313291] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   16.319425] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   16.327695] uhci_hcd 0000:00:1d.0: detected 2 ports
[   16.333161] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00006060
[   16.339620] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   16.347204] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   16.355273] usb usb6: Product: UHCI Host Controller
[   16.360720] usb usb6: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
[   16.368690] usb usb6: SerialNumber: 0000:00:1d.0
[   16.374299] hub 6-0:1.0: USB hub found
[   16.378495] hub 6-0:1.0: 2 ports detected
[   16.383244] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   16.389373] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   16.397653] uhci_hcd 0000:00:1d.1: detected 2 ports
[   16.403119] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00006040
[   16.409596] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   16.417212] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   16.425374] usb usb7: Product: UHCI Host Controller
[   16.430910] usb usb7: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
[   16.438977] usb usb7: SerialNumber: 0000:00:1d.1
[   16.444639] hub 7-0:1.0: USB hub found
[   16.448861] hub 7-0:1.0: 2 ports detected
[   16.453714] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   16.459848] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   16.468118] uhci_hcd 0000:00:1d.2: detected 2 ports
[   16.473587] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006020
[   16.480063] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   16.487650] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   16.495721] usb usb8: Product: UHCI Host Controller
[   16.501169] usb usb8: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
[   16.509142] usb usb8: SerialNumber: 0000:00:1d.2
[   16.514731] hub 8-0:1.0: USB hub found
[   16.518935] hub 8-0:1.0: 2 ports detected
[   16.523583] usbcore: registered new interface driver usbserial
[   16.530110] usbcore: registered new interface driver usbserial_generic
[   16.537415] usbserial: USB Serial support registered for generic
[   16.544153] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   16.546253] usb 4-1: new full-speed USB device number 2 using uhci_hcd
[   16.688595] usb 4-1: New USB device found, idVendor=046b, idProduct=ff10
[   16.696187] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   16.704163] usb 4-1: Product: Virtual Keyboard and Mouse
[   16.710097] usb 4-1: Manufacturer: American Megatrends Inc.
[   16.716323] usb 4-1: SerialNumber: serial
[   17.598236] i8042: No controller found
[   17.602807] mousedev: PS/2 mouse device common for all mice
[   17.610108] rtc_cmos 00:00: RTC can wake from S4
[   17.615669] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   17.622519] rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   17.631191] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   17.637428] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   17.652581] iTCO_vendor_support: vendor-support=0
[   17.659653] hidraw: raw HID events driver (C) Jiri Kosina
[   17.670526] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.0/0003:046B:FF10.0001/input/input2
[   17.737731] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.1-1/input0
[   17.759541] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.1/0003:046B:FF10.0002/input/input3
[   17.776116] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.1-1/input1
[   17.792367] usbcore: registered new interface driver usbhid
[   17.798590] usbhid: USB HID core driver
[   17.802954] drop_monitor: Initializing network drop monitor service
[   17.804149] usb 7-2: new full-speed USB device number 2 using uhci_hcd
[   17.817467] TCP: cubic registered
[   17.821176] Initializing XFRM netlink socket
[   17.826178] NET: Registered protocol family 10
[   17.832501] NET: Registered protocol family 17
[   17.837489] 9pnet: Installing 9P2000 support
[   17.845092] 
[   17.845092] printing PIC contents
[   17.850449] ... PIC  IMR: ffff
[   17.853859] ... PIC  IRR: 0c20
[   17.857279] ... PIC  ISR: 0000
[   17.860782] ... PIC ELCR: 0e20
[   17.864302] printing local APIC contents on CPU#0/0:
[   17.869854] ... APIC ID:      00000000 (0)
[   17.874426] ... APIC VERSION: 01060015
[   17.878608] ... APIC TASKPRI: 00000000 (00)
[   17.883277] ... APIC PROCPRI: 00000000
[   17.887459] ... APIC LDR: 00000001
[   17.891255] ... APIC SPIV: 000001ff
[   17.895146] ... APIC ISR field:
[   17.898651] 0000000000000000000000000000000000000000000000000000000000000000
[   17.906601] ... APIC TMR field:
[   17.910104] 0000000000000000000200000002000200020002000200020000000200000000
[   17.918052] ... APIC IRR field:
[   17.921556] 0000000000000000100000000000000000000000000000000000000000000000
[   17.929508] ... APIC ESR: 00000000
[   17.933301] ... APIC ICR: 000008fd
[   17.937095] ... APIC ICR2: 00000020
[   17.940988] ... APIC LVTT: 000000ef
[   17.944880] ... APIC LVTPC: 00000400
[   17.948868] ... APIC LVT0: 00010700
[   17.952759] ... APIC LVT1: 00000400
[   17.956652] ... APIC LVTERR: 000000fe
[   17.960737] ... APIC TMICT: 01c51e06
[   17.964725] ... APIC TMCCT: 01b5e397
[   17.968713] ... APIC TDCR: 00000003
[   17.972605] 
[   17.974267] number of MP IRQ sources: 15.
[   17.978841] number of IO-APIC #8 registers: 24.
[   17.983991] number of IO-APIC #9 registers: 24.
[   17.989144] number of IO-APIC #10 registers: 24.
[   17.994394] testing the IO APIC.......................
[   18.000230] IO APIC #8......
[   18.002751] usb 7-2: New USB device found, idVendor=0557, idProduct=8021
[   18.002753] usb 7-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   18.004782] hub 7-2:1.0: USB hub found
[   18.005858] hub 7-2:1.0: 4 ports detected
[   18.028030] .... register #00: 08000000
[   18.032410] .......    : physical APIC id: 08
[   18.037365] .......    : Delivery Type: 0
[   18.041930] .......    : LTS          : 0
[   18.046497] .... register #01: 00170020
[   18.050876] .......     : max redirection entries: 17
[   18.056610] .......     : PRQ implemented: 0
[   18.061468] .......     : IO APIC version: 20
[   18.066432] .... IRQ redirection table:
[   18.070821] 0   1    0    0   0   0    0     0    00
[   18.076458] 1   0    0    0   0   0    0     0    01
[   18.082098] 1   0    0    0   0   0    0     0    02
[   18.087738] 1   0    0    0   0   0    0     0    03
[   18.093376] 1   0    0    0   0   0    0     0    04
[   18.099021] 1   0    0    0   0   0    0     0    05
[   18.104659] 1   0    0    0   0   0    0     0    06
[   18.110305] 1   0    0    0   0   0    0     0    07
[   18.115947] 1   0    0    0   0   0    0     0    08
[   18.121587] 1   0    1    0   0   0    0     0    09
[   18.127229] 1   0    0    0   0   0    0     0    0A
[   18.132872] 1   0    0    0   0   0    0     0    0B
[   18.138517] 1   0    0    0   0   0    0     0    0C
[   18.144154] 1   0    0    0   0   0    0     0    0D
[   18.149809] 1   0    0    0   0   0    0     0    0E
[   18.155447] 1   0    0    0   0   0    0     0    0F
[   18.161087] 1   0    1    0   1   0    0     0    10
[   18.166730] 0   1    0    0   0   0    0     0    00
[   18.172368] 1   0    1    0   1   0    0     0    12
[   18.178005] 1   0    1    0   1   0    0     0    13
[   18.183644] 0   1    0    0   0   0    0     0    00
[   18.189284] 1   0    1    0   1   0    0     0    15
[   18.194926] 0   1    0    0   0   0    0     0    00
[   18.200563] 1   0    1    0   1   0    0     0    17
[   18.206209] IO APIC #9......
[   18.209524] .... register #00: 09000000
[   18.213898] .......    : physical APIC id: 09
[   18.218856] .......    : Delivery Type: 0
[   18.223426] .......    : LTS          : 0
[   18.228004] .... register #01: 00170020
[   18.232386] .......     : max redirection entries: 17
[   18.238117] .......     : PRQ implemented: 0
[   18.242982] .......     : IO APIC version: 20
[   18.247949] .... register #02: 00000000
[   18.252329] .......     : arbitration: 00
[   18.256891] .... register #03: 00000001
[   18.261269] .......     : Boot DT    : 1
[   18.265739] .... IRQ redirection table:
[   18.270126] 1   1    1    0   1   0    0     0    00
[   18.275763] 0   1    0    0   0   0    0     0    00
[   18.281408] 1   1    1    0   1   0    0     0    02
[   18.282036] usb 7-2.1: new low-speed USB device number 3 using uhci_hcd
[   18.294527] 0   1    0    0   0   0    0     0    00
[   18.300163] 1   1    1    0   1   0    0     0    04
[   18.305809] 1   1    1    0   1   0    0     0    05
[   18.311447] 1   1    1    0   1   0    0     0    06
[   18.317087] 0   1    0    0   0   0    0     0    00
[   18.322720] 1   1    1    0   1   0    0     0    08
[   18.328350] 1   1    1    0   1   0    0     0    09
[   18.333990] 0   1    0    0   0   0    0     0    00
[   18.339628] 0   1    0    0   0   0    0     0    00
[   18.345272] 0   1    0    0   0   0    0     0    00
[   18.350909] 0   1    0    0   0   0    0     0    00
[   18.356547] 0   1    0    0   0   0    0     0    00
[   18.362182] 0   1    0    0   0   0    0     0    00
[   18.367818] 1   1    1    0   1   0    0     0    10
[   18.373456] 1   1    1    0   1   0    0     0    11
[   18.379094] 0   1    0    0   0   0    0     0    00
[   18.384740] 0   1    0    0   0   0    0     0    00
[   18.390387] 0   1    0    0   0   0    0     0    00
[   18.396022] 0   1    0    0   0   0    0     0    00
[   18.401663] 0   1    0    0   0   0    0     0    00
[   18.407308] 0   1    0    0   0   0    0     0    00
[   18.412952] IO APIC #10......
[   18.416356] .... register #00: 0A000000
[   18.420732] .......    : physical APIC id: 0A
[   18.425705] .......    : Delivery Type: 0
[   18.430280] .......    : LTS          : 0
[   18.434849] .... register #01: 00170020
[   18.439226] .......     : max redirection entries: 17
[   18.444963] .......     : PRQ implemented: 0
[   18.449821] .......     : IO APIC version: 20
[   18.454786] .... register #02: 00000000
[   18.457147] usb 7-2.1: New USB device found, idVendor=0557, idProduct=2261
[   18.457149] usb 7-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   18.457150] usb 7-2.1: Product: CS1716A V1.0.098
[   18.457152] usb 7-2.1: Manufacturer: ATEN International Co. Ltd
[   18.487225] .......     : arbitration: 00
[   18.487407] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2.1/7-2.1:1.0/0003:0557:2261.0003/input/input4
[   18.507524] .... register #03: 00000001
[   18.511896] .......     : Boot DT    : 1
[   18.516363] .... IRQ redirection table:
[   18.520745] 1   1    1    0   1   0    0     0    00
[   18.526383] 0   1    0    0   0   0    0     0    00
[   18.532025] 0   1    0    0   0   0    0     0    00
[   18.537660] 0   1    0    0   0   0    0     0    00
[   18.537981] hid-generic 0003:0557:2261.0003: input,hidraw2: USB HID v1.00 Keyboard [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.1-2.1/input0
[   18.559310] 1   1    1    0   1   0    0     0    04
[   18.564956] 0   1    0    0   0   0    0     0    00
[   18.570591] 1   1    1    0   1   0    0     0    06
[   18.573204] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2.1/7-2.1:1.1/0003:0557:2261.0004/input/input5
[   18.591965] 0   1    0    0   0   0    0     0    00
[   18.597607] 1   1    1    0   1   0    0     0    08
[   18.603247] 0   1    0    0   0   0    0     0    00
[   18.608890] 0   1    0    0   0   0    0     0    00
[   18.614527] 0   1    0    0   0   0    0     0    00
[   18.620162] 0   1    0    0   0   0    0     0    00
[   18.624042] hid-generic 0003:0557:2261.0004: input,hidraw3: USB HID v1.00 Device [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.1-2.1/input1
[   18.641622] 0   1    0    0   0   0    0     0    00
[   18.645323] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2.1/7-2.1:1.2/0003:0557:2261.0005/input/input6
[   18.646012] hid-generic 0003:0557:2261.0005: input,hidraw4: USB HID v1.10 Mouse [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.1-2.1/input2
[   18.678716] 0   1    0    0   0   0    0     0    00
[   18.684361] 0   1    0    0   0   0    0     0    00
[   18.690006] 0   1    0    0   0   0    0     0    00
[   18.695650] 0   1    0    0   0   0    0     0    00
[   18.701295] 0   1    0    0   0   0    0     0    00
[   18.706934] 0   1    0    0   0   0    0     0    00
[   18.712584] 0   1    0    0   0   0    0     0    00
[   18.718231] 0   1    0    0   0   0    0     0    00
[   18.723874] 0   1    0    0   0   0    0     0    00
[   18.729513] 1   1    1    0   1   0    0     0    17
[   18.735148] IRQ to pin mappings:
[   18.738845] IRQ0 -> 0:2
[   18.741691] IRQ1 -> 0:1
[   18.744536] IRQ3 -> 0:3
[   18.747387] IRQ4 -> 0:4
[   18.750232] IRQ5 -> 0:5
[   18.753176] IRQ6 -> 0:6
[   18.756021] IRQ7 -> 0:7
[   18.758864] IRQ8 -> 0:8
[   18.761808] IRQ9 -> 0:9
[   18.764655] IRQ10 -> 0:10
[   18.767694] IRQ11 -> 0:11
[   18.770835] IRQ12 -> 0:12
[   18.773879] IRQ13 -> 0:13
[   18.776922] IRQ14 -> 0:14
[   18.780054] IRQ15 -> 0:15
[   18.783099] IRQ16 -> 0:16
[   18.786141] IRQ18 -> 0:18
[   18.789278] IRQ19 -> 0:19
[   18.792324] IRQ21 -> 0:21
[   18.795360] IRQ23 -> 0:23
[   18.798497] IRQ24 -> 1:4
[   18.801441] IRQ26 -> 1:5
[   18.804479] IRQ28 -> 1:0
[   18.807427] IRQ30 -> 1:2
[   18.810384] IRQ32 -> 1:6
[   18.813337] IRQ34 -> 1:8
[   18.816366] IRQ36 -> 1:9
[   18.819315] IRQ40 -> 2:23
[   18.822351] IRQ42 -> 2:4
[   18.825396] IRQ44 -> 2:0
[   18.828434] IRQ46 -> 2:6
[   18.831378] IRQ48 -> 2:8
[   18.834422] IRQ59 -> 1:16
[   18.837469] IRQ80 -> 1:17
[   18.840506] .................................... done.
[   18.847721] Loading compiled-in X.509 certificates
[   18.854511] Loaded X.509 cert 'Magrathea: Glacier signing key: 81618a42096c2ef391193fe6d34296fd923f6030'
[   18.865132] registered taskstats version 1
[   18.875063] Key type trusted registered
[   18.883531] Key type encrypted registered
[   18.897840] tpm_tis 00:04: A TPM error (6) occurred attempting to read a pcr value
[   18.906307] ima: No TPM chip found, activating TPM-bypass!
[   18.912488] evm: HMAC attrs: 0x1
[   18.919710] rtc_cmos 00:00: setting system clock to 2014-11-06 01:17:01 UTC (1415236621)
[   19.171894] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   19.419034] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   19.666191] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
[   19.913383] IPv6: ADDRCONF(NETDEV_UP): eth3: link is not ready
[   22.019299] igb 0000:01:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   22.030859] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   22.041854] Sending DHCP requests .., OK
[   26.550848] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.192
[   27.066481] IP-Config: Complete:
[   27.070185]      device=eth0, hwaddr=60:eb:69:82:38:2a, ipaddr=192.168.1.192, mask=255.255.255.0, gw=192.168.1.1
[   27.081648]      host=lkp-wsx02, domain=lkp.intel.com, nis-domain=(none)
[   27.089228]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   27.096807]      nameserver0=192.168.1.1
[   27.101515] PM: Hibernation image not present or could not be loaded.
[   27.113342] Freeing unused kernel memory: 1844K (ffffffff81e1f000 - ffffffff81fec000)
[   27.535705] ipmi message handler version 39.2
[   27.553101] IPMI System Interface driver.
[   27.557678] ipmi_si: probing via ACPI
[   27.561821] ipmi_si 00:05: [io  0x0ca2] regsize 1 spacing 1 irq 0
[   27.568635] ipmi_si: Adding ACPI-specified kcs state machine
[   27.575092] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   27.600758] megasas: 06.805.06.00-rc1 Thu. Sep. 4 17:00:00 PDT 2014
[   27.607865] megasas: 0x1000:0x0079:0x8086:0x9256: bus 7:slot 0:func 0
[   27.616381] megasas: Waiting for FW to come to ready state
[   27.622624] EDAC MC: Ver: 3.0.0
[   27.624129] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   27.636253] megasas: FW now in Ready state
[   27.640910] megaraid_sas 0000:07:00.0: irq 90 for MSI/MSI-X
[   27.647168] megaraid_sas 0000:07:00.0: [scsi0]: FW supports<0> MSIX vector,Online CPUs: <80>,Current MSIX <1>
[   27.675846] [drm] Initialized drm 1.1.0 20060810
[   27.676666] libata version 3.00 loaded.
[   27.711438] ata_piix 0000:00:1f.2: version 2.13
[   27.716722] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   27.724033] scsi host1: ata_piix
[   27.728554] scsi host2: ata_piix
[   27.732226] ata1: SATA max UDMA/133 cmd 0x6138 ctl 0x614c bmdma 0x6110 irq 19
[   27.740208] ata2: SATA max UDMA/133 cmd 0x6130 ctl 0x6148 bmdma 0x6118 irq 19
[   27.743358] megasas_init_mfi: fw_support_ieee=0
[   27.743358] megasas: INIT adapter done
[   27.757855] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[   27.785272] megaraid_sas 0000:07:00.0: Controller type: MR,Memory size is: 512MB
[   27.793627] scsi host0: LSI SAS based MegaRAID driver
[   27.823071] scsi 0:2:0:0: Direct-Access     INTEL    RS2BL080DE       2.70 PQ: 0 ANSI: 5
[   27.836241] scsi 0:2:2:0: Direct-Access     INTEL    RS2BL080DE       2.70 PQ: 0 ANSI: 5
[   27.851081] [TTM] Zone  kernel: Available graphics memory: 65973992 kiB
[   27.858484] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   27.865777] [TTM] Initializing pool allocator
[   27.870645] [TTM] Initializing DMA pool allocator
[   27.907361] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   27.916142] scsi host3: ata_piix
[   27.920498] scsi host4: ata_piix
[   27.924187] ata3: SATA max UDMA/133 cmd 0x6128 ctl 0x6144 bmdma 0x60f0 irq 21
[   27.932169] ata4: SATA max UDMA/133 cmd 0x6120 ctl 0x6140 bmdma 0x60f8 irq 21
[   27.940281] fbcon: mgadrmfb (fb0) is primary device
[   28.020447] Error: Driver 'pcspkr' is already registered, aborting...
[   28.151617] Console: switching to colour frame buffer device 128x48
[   28.215239] mgag200 0000:11:00.0: fb0: mgadrmfb frame buffer device
[   28.222332] mgag200 0000:11:00.0: registered panic notifier
[   28.234984] [drm] Initialized mgag200 1.0.0 20110418 for 0000:11:00.0 on minor 0
[   28.257621] ata3: SATA link down (SStatus 4 SControl 300)
[   28.379727] ata2.00: SATA link down (SStatus 0 SControl 300)
[   28.386169] ata2.01: SATA link down (SStatus 0 SControl 300)
[   28.403692] ata1.00: SATA link down (SStatus 0 SControl 300)
[   28.410135] ata1.01: SATA link down (SStatus 0 SControl 300)
[   28.414804] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   28.417991] ata4.00: ATAPI: HL-DT-STDVDRAM GT32N, AS00, max UDMA/100
[   28.423988] ata4.00: configured for UDMA/100
[   28.438728] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT32N     AS00 PQ: 0 ANSI: 5
[   28.491549] sd 0:2:0:0: [sda] 583983104 512-byte logical blocks: (298 GB/278 GiB)
[   28.491879] sd 0:2:2:0: [sdb] 57376768 512-byte logical blocks: (29.3 GB/27.3 GiB)
[   28.492189] sd 0:2:2:0: [sdb] Write Protect is off
[   28.492194] sd 0:2:2:0: [sdb] Mode Sense: 1f 00 10 08
[   28.514114] sd 0:2:2:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   28.529690] sd 0:2:0:0: [sda] Write Protect is off
[   28.535130] sd 0:2:0:0: [sda] Mode Sense: 1f 00 10 08
[   28.536044]  sdb: sdb1 sdb9
[   28.544226] sd 0:2:2:0: [sdb] Attached SCSI disk
[   28.544247] sd 0:2:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   28.562677] sr 4:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   28.570009]  sda: sda1
[   28.570009]  sda1: <solaris: [s0] sda5 [s2] sda6 [s8] sda7 >
[   28.572259] sd 0:2:0:0: [sda] Attached SCSI disk
[   28.593260] cdrom: Uniform CD-ROM driver Revision: 3.20
[   28.601268] sr 4:0:0:0: Attached scsi CD-ROM sr0
[   28.617619] sd 0:2:0:0: Attached scsi generic sg0 type 0
[   28.625043] sd 0:2:2:0: Attached scsi generic sg1 type 0
[   28.632272] sr 4:0:0:0: Attached scsi generic sg2 type 5
[   28.884258] random: nonblocking pool is initialized
[   82.825219] ipmi_si: There appears to be no BMC at this location
<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.18.0-rc3-wl-ath-g7c130ce (kbuild@cairo) (gcc version 4.9.1 (Debian 4.9.1-19) ) #1 SMP Thu Nov 6 00:20:08 CST 2014
<6>[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-wsx02/cyclic_aim9-performance-300s-creat-clo-x86_64-rhel-HEAD-7c130ce86d3169fb078ea36d2351a9bc5394f7bf-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/7c130ce86d3169fb078ea36d2351a9bc5394f7bf/vmlinuz-3.18.0-rc3-wl-ath-g7c130ce kconfig=x86_64-rhel commit=7c130ce86d3169fb078ea36d2351a9bc5394f7bf branch=linux-devel/devel-hourly-2014110522 root=/dev/ram0 max_uptime=1393 RESULT_ROOT=/result/lkp-wsx02/aim9/performance-300s-creat-clo/debian-x86_64.cgz/x86_64-rhel/7c130ce86d3169fb078ea36d2351a9bc5394f7bf/0 ip=::::lkp-wsx02::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] e820: BIOS-provided physical RAM map:
<6>[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009b3ff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000000009b400-0x000000000009ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007b451fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000007b452000-0x000000007b454fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000007b455000-0x000000007b68ffff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x000000007b690000-0x000000007b69efff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000007b69f000-0x000000007b6a1fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000007b6a2000-0x000000007b6a6fff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000007b6a7000-0x000000007b7bcfff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000007b7bd000-0x000000007ba3cfff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x000000007ba3d000-0x000000007baa7fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000007baa8000-0x000000007bcfffff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000007bd00000-0x000000007bd16fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000007bd17000-0x000000007bd19fff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000007bd1a000-0x000000007bd49fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000007bd4a000-0x000000007bd5efff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000007bd5f000-0x000000007bdfefff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000007bdff000-0x000000007bdfffff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000007be00000-0x000000007be4efff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x000000007be4f000-0x000000007bf70fff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000007bf71000-0x000000007bfcefff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x000000007bfcf000-0x000000007bffefff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x000000007bfff000-0x000000008fffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
<6>[    0.000000] bootconsole [earlyser0] enabled
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] SMBIOS 2.5 present.
<7>[    0.000000] DMI:  , BIOS QSSC-S4R.QCI.01.00.0030.031120111710 03/11/2011
<7>[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
<7>[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
<6>[    0.000000] AGP: No AGP bridge found
<6>[    0.000000] e820: last_pfn = 0x2080000 max_arch_pfn = 0x400000000
<7>[    0.000000] MTRR default type: write-back
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-BFFFF uncachable
<7>[    0.000000]   C0000-DFFFF write-through
<7>[    0.000000]   E0000-FFFFF write-protect
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 00080000000 mask FFF80000000 uncachable
<7>[    0.000000]   1 base FC000000000 mask FFF00000000 uncachable
<7>[    0.000000]   2 disabled
<7>[    0.000000]   3 disabled
<7>[    0.000000]   4 disabled
<7>[    0.000000]   5 disabled
<7>[    0.000000]   6 disabled
<7>[    0.000000]   7 disabled
<7>[    0.000000]   8 disabled
<7>[    0.000000]   9 disabled
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
<6>[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
<6>[    0.000000] e820: last_pfn = 0x7b452 max_arch_pfn = 0x400000000
<4>[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
<4>[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
<4>[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
<6>[    0.000000] found SMP MP-table at [mem 0x000fd9e0-0x000fd9ef] mapped at [ffff8800000fd9e0]
<4>[    0.000000]   mpc: efc20-eff2c
<7>[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
<6>[    0.000000] Using GB pages for direct mapping
<6>[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
<7>[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
<7>[    0.000000] BRK [0x207f1d0000, 0x207f1d0fff] PGTABLE
<7>[    0.000000] BRK [0x207f1d1000, 0x207f1d1fff] PGTABLE
<7>[    0.000000] BRK [0x207f1d2000, 0x207f1d2fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x207fe00000-0x207fffffff]
<7>[    0.000000]  [mem 0x207fe00000-0x207fffffff] page 1G
<6>[    0.000000] init_memory_mapping: [mem 0x207c000000-0x207fdfffff]
<7>[    0.000000]  [mem 0x207c000000-0x207fdfffff] page 1G
<6>[    0.000000] init_memory_mapping: [mem 0x2000000000-0x207bffffff]
<7>[    0.000000]  [mem 0x2000000000-0x207bffffff] page 1G
<6>[    0.000000] init_memory_mapping: [mem 0x1000000000-0x1fffffffff]
<7>[    0.000000]  [mem 0x1000000000-0x1fffffffff] page 1G
<6>[    0.000000] init_memory_mapping: [mem 0x00100000-0x7b451fff]
<7>[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>[    0.000000]  [mem 0x00200000-0x7b3fffff] page 2M
<7>[    0.000000]  [mem 0x7b400000-0x7b451fff] page 4k
<7>[    0.000000] BRK [0x207f1d3000, 0x207f1d3fff] PGTABLE
<7>[    0.000000] BRK [0x207f1d4000, 0x207f1d4fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
<7>[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
<6>[    0.000000] RAMDISK: [mem 0x2076661000-0x207dffffff]
<6>[    0.000000] ACPI: Early table checksum verification disabled
<4>[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 QUANTA)
<4>[    0.000000] ACPI: XSDT 0x000000007BFFE120 0000BC (v01 QUANTA QSSC-S4R 00000000      01000013)
<4>[    0.000000] ACPI: FACP 0x000000007BFFD000 0000F4 (v04 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
<4>[    0.000000] ACPI: DSDT 0x000000007BFE1000 01B7B5 (v02 QUANTA QSSC-S4R 00000003 MSFT 0100000D)
<4>[    0.000000] ACPI: FACS 0x000000007BF71000 000040
<4>[    0.000000] ACPI: APIC 0x000000007BFE0000 0004C4 (v02 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
<4>[    0.000000] ACPI: MSCT 0x000000007BFDF000 000090 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
<4>[    0.000000] ACPI: MCFG 0x000000007BFDE000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
<4>[    0.000000] ACPI: HPET 0x000000007BFDD000 000038 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
<4>[    0.000000] ACPI: SLIT 0x000000007BFDC000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
<4>[    0.000000] ACPI: SRAT 0x000000007BFDB000 000A30 (v02 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
<4>[    0.000000] ACPI: SPCR 0x000000007BFDA000 000050 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
<4>[    0.000000] ACPI: WDDT 0x000000007BFD9000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
<4>[    0.000000] ACPI: SSDT 0x000000007BF24000 04C744 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
<4>[    0.000000] ACPI: SSDT 0x000000007BFD8000 000174 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
<4>[    0.000000] ACPI: PMCT 0x000000007BFD7000 000060 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
<4>[    0.000000] ACPI: MIGT 0x000000007BFD6000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
<4>[    0.000000] ACPI: TCPA 0x000000007BFD3000 000032 (v00 QUANTA QSSC-S4R 00000000      00000000)
<4>[    0.000000] ACPI: HEST 0x000000007BFD2000 0000A8 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
<4>[    0.000000] ACPI: BERT 0x000000007BFD1000 000030 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
<4>[    0.000000] ACPI: ERST 0x000000007BFD0000 000230 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
<4>[    0.000000] ACPI: EINJ 0x000000007BFCF000 000130 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
<4>[    0.000000] ACPI: DMAR 0x000000007BF23000 0002F8 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] Setting APIC routing to cluster x2apic.
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x20 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x21 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x22 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x23 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x24 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x25 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x30 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x31 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x32 -> Node 0
<6>[    0.000000] SRAT: PXM 0 -> APIC 0x33 -> Node 0
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x40 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x41 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x42 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x43 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x44 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x45 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x50 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x51 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x52 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x53 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x60 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x61 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x62 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x63 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x64 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x65 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x70 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x71 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x72 -> Node 1
<6>[    0.000000] SRAT: PXM 1 -> APIC 0x73 -> Node 1
<6>[    0.000000] SRAT: PXM 2 -> APIC 0x80 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0x81 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0x82 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0x83 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0x84 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0x85 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0x90 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0x91 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0x92 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0x93 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0xa0 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0xa1 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0xa2 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0xa3 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0xa4 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0xa5 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0xb0 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0xb1 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0xb2 -> Node 2
<6>[    0.000000] SRAT: PXM 2 -> APIC 0xb3 -> Node 2
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xc0 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xc1 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xc2 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xc3 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xc4 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xc5 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xd0 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xd1 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xd2 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xd3 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xe0 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xe1 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xe2 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xe3 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xe4 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xe5 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xf0 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xf1 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xf2 -> Node 3
<6>[    0.000000] SRAT: PXM 3 -> APIC 0xf3 -> Node 3
<6>[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
<6>[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x87fffffff]
<6>[    0.000000] SRAT: Node 1 PXM 1 [mem 0x880000000-0x107fffffff]
<6>[    0.000000] SRAT: Node 2 PXM 2 [mem 0x1080000000-0x187fffffff]
<6>[    0.000000] SRAT: Node 3 PXM 3 [mem 0x1880000000-0x207fffffff]
<6>[    0.000000] SRAT: Node 0 PXM 0 [mem 0x2100000000-0x40ffffffff] hotplug
<6>[    0.000000] SRAT: Node 0 PXM 0 [mem 0x4100000000-0x60ffffffff] hotplug
<6>[    0.000000] SRAT: Node 1 PXM 1 [mem 0x6100000000-0x80ffffffff] hotplug
<6>[    0.000000] SRAT: Node 1 PXM 1 [mem 0x8100000000-0xa0ffffffff] hotplug
<6>[    0.000000] SRAT: Node 2 PXM 2 [mem 0xa100000000-0xc0ffffffff] hotplug
<6>[    0.000000] SRAT: Node 2 PXM 2 [mem 0xc100000000-0xe0ffffffff] hotplug
<6>[    0.000000] SRAT: Node 3 PXM 3 [mem 0xe100000000-0x100ffffffff] hotplug
<6>[    0.000000] SRAT: Node 3 PXM 3 [mem 0x10100000000-0x120ffffffff] hotplug
<7>[    0.000000] NUMA: Initialized distance table, cnt=4
<6>[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]
<6>[    0.000000] NODE_DATA(0) allocated [mem 0x87ffda000-0x87fffffff]
<6>[    0.000000] NODE_DATA(1) allocated [mem 0x107ffda000-0x107fffffff]
<6>[    0.000000] NODE_DATA(2) allocated [mem 0x187ffda000-0x187fffffff]
<6>[    0.000000] NODE_DATA(3) allocated [mem 0x207ffd9000-0x207fffefff]
<7>[    0.000000]  [ffffea0000000000-ffffea0021ffffff] PMD -> [ffff88085fe00000-ffff88087fdfffff] on node 0
<7>[    0.000000]  [ffffea0022000000-ffffea0041ffffff] PMD -> [ffff88105fe00000-ffff88107fdfffff] on node 1
<7>[    0.000000]  [ffffea0042000000-ffffea0061ffffff] PMD -> [ffff88185fe00000-ffff88187fdfffff] on node 2
<7>[    0.000000]  [ffffea0062000000-ffffea0081ffffff] PMD -> [ffff882056600000-ffff8820765fffff] on node 3
<4>[    0.000000] Zone ranges:
<4>[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
<4>[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
<4>[    0.000000]   Normal   [mem 0x100000000-0x207fffffff]
<4>[    0.000000] Movable zone start for each node
<4>[    0.000000] Early memory node ranges
<4>[    0.000000]   node   0: [mem 0x00001000-0x0009afff]
<4>[    0.000000]   node   0: [mem 0x00100000-0x7b451fff]
<4>[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
<4>[    0.000000]   node   1: [mem 0x880000000-0x107fffffff]
<4>[    0.000000]   node   2: [mem 0x1080000000-0x187fffffff]
<4>[    0.000000]   node   3: [mem 0x1880000000-0x207fffffff]
<6>[    0.000000] Initmem setup node 0 [mem 0x00001000-0x87fffffff]
<7>[    0.000000] On node 0 totalpages: 8369132
<7>[    0.000000]   DMA zone: 64 pages used for memmap
<7>[    0.000000]   DMA zone: 21 pages reserved
<7>[    0.000000]   DMA zone: 3994 pages, LIFO batch:0
<7>[    0.000000]   DMA32 zone: 7826 pages used for memmap
<7>[    0.000000]   DMA32 zone: 500818 pages, LIFO batch:31
<7>[    0.000000]   Normal zone: 122880 pages used for memmap
<7>[    0.000000]   Normal zone: 7864320 pages, LIFO batch:31
<6>[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107fffffff]
<7>[    0.000000] On node 1 totalpages: 8388608
<7>[    0.000000]   Normal zone: 131072 pages used for memmap
<7>[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
<6>[    0.000000] Initmem setup node 2 [mem 0x1080000000-0x187fffffff]
<7>[    0.000000] On node 2 totalpages: 8388608
<7>[    0.000000]   Normal zone: 131072 pages used for memmap
<7>[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
<6>[    0.000000] Initmem setup node 3 [mem 0x1880000000-0x207fffffff]
<7>[    0.000000] On node 3 totalpages: 8388608
<7>[    0.000000]   Normal zone: 131072 pages used for memmap
<7>[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x408
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x80] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x40] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0xc0] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x20] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0xa0] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x60] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0xe0] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x10] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x90] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x50] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0xd0] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x30] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0xb0] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x70] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0xf0] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x82] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x42] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0xc2] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x22] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0xa2] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x62] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0xe2] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x12] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x92] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x52] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0xd2] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x32] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0xb2] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x72] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0xf2] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x81] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x41] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0xc1] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x21] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0xa1] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x61] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0xe1] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x11] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x91] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x51] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0xd1] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x31] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0xb1] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x71] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0xf1] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x83] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x43] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0xc3] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x23] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0xa3] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x63] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0xe3] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x13] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x93] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x53] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0xd3] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x33] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0xb3] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x73] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0xf3] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x84] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x44] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0xc4] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x24] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0xa4] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x64] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0xe4] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x85] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x45] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0xc5] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x25] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0xa5] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x65] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0xe5] enabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x28] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x29] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2a] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2b] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2c] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2d] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2e] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2f] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x32] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x33] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x34] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x35] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x38] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x39] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3a] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3b] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3c] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3d] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3e] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3f] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x40] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x41] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x42] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x43] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x44] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x45] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x46] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x47] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x48] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x49] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4a] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4b] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4c] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4d] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4e] high level lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4f] high level lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
<6>[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
<6>[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec04000] gsi_base[48])
<6>[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec04000, GSI 48-71
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<4>[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
<7>[    0.000000] ACPI: IRQ0 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
<7>[    0.000000] ACPI: IRQ9 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x8086a401 base: 0xfed00000
<6>[    0.000000] smpboot: Allowing 80 CPUs, 0 hotplug CPUs
<4>[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
<4>[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
<4>[    0.000000] mapped IOAPIC to ffffffffff579000 (fec04000)
<6>[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009bfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7b452000-0x7b454fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7b455000-0x7b68ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7b690000-0x7b69efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7b69f000-0x7b6a1fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7b6a2000-0x7b6a6fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7b6a7000-0x7b7bcfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7b7bd000-0x7ba3cfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7ba3d000-0x7baa7fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7baa8000-0x7bcfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7bd00000-0x7bd16fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7bd17000-0x7bd19fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7bd1a000-0x7bd49fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7bd4a000-0x7bd5efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7bd5f000-0x7bdfefff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7bdff000-0x7bdfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7be00000-0x7be4efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7be4f000-0x7bf70fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7bf71000-0x7bfcefff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7bfcf000-0x7bffefff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x7bfff000-0x8fffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfbffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfcffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfd000000-0xfed1bfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
<6>[    0.000000] e820: [mem 0x90000000-0xfbffffff] available for PCI devices
<6>[    0.000000] Booting paravirtualized kernel on bare hardware
<6>[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:80 nr_cpu_ids:80 nr_node_ids:4
<6>[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88085f800000 s89152 r8192 d29632 u262144
<7>[    0.000000] pcpu-alloc: s89152 r8192 d29632 u262144 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 00 04 08 12 16 20 24 28 [0] 32 36 40 44 48 52 56 60 
<7>[    0.000000] pcpu-alloc: [0] 64 68 72 76 -- -- -- -- [1] 01 05 09 13 17 21 25 29 
<7>[    0.000000] pcpu-alloc: [1] 33 37 41 45 49 53 57 61 [1] 65 69 73 77 -- -- -- -- 
<7>[    0.000000] pcpu-alloc: [2] 02 06 10 14 18 22 26 30 [2] 34 38 42 46 50 54 58 62 
<7>[    0.000000] pcpu-alloc: [2] 66 70 74 78 -- -- -- -- [3] 03 07 11 15 19 23 27 31 
<7>[    0.000000] pcpu-alloc: [3] 35 39 43 47 51 55 59 63 [3] 67 71 75 79 -- -- -- -- 
<4>[    0.000000] Built 4 zonelists in Node order, mobility grouping on.  Total pages: 33010949
<4>[    0.000000] Policy zone: Normal
<5>[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-wsx02/cyclic_aim9-performance-300s-creat-clo-x86_64-rhel-HEAD-7c130ce86d3169fb078ea36d2351a9bc5394f7bf-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/7c130ce86d3169fb078ea36d2351a9bc5394f7bf/vmlinuz-3.18.0-rc3-wl-ath-g7c130ce kconfig=x86_64-rhel commit=7c130ce86d3169fb078ea36d2351a9bc5394f7bf branch=linux-devel/devel-hourly-2014110522 root=/dev/ram0 max_uptime=1393 RESULT_ROOT=/result/lkp-wsx02/aim9/performance-300s-creat-clo/debian-x86_64.cgz/x86_64-rhel/7c130ce86d3169fb078ea36d2351a9bc5394f7bf/0 ip=::::lkp-wsx02::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] sysrq: sysrq always enabled.
<6>[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
<6>[    0.000000] log_buf_len total cpu_extra contributions: 323584 bytes
<6>[    0.000000] log_buf_len min size: 524288 bytes
<6>[    0.000000] log_buf_len: 1048576 bytes
<6>[    0.000000] early log buf free: 489840(93%)
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.000000] AGP: Checking aperture...
<6>[    0.000000] AGP: No AGP bridge found
<4>[    0.000000] Memory: 131821564K/134139824K available (8815K kernel code, 1715K rwdata, 3912K rodata, 1844K init, 1892K bss, 2318260K reserved)
<6>[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=80, Nodes=4
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=80.
<6>[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=80
<6>[    0.000000] NR_IRQS:524544 nr_irqs:1880 0
<6>[    0.000000] 	Offload RCU callbacks from all CPUs
<6>[    0.000000] 	Offload RCU callbacks from CPUs: 0-79.
<6>[    0.000000] Console: colour dummy device 80x25
<6>[    0.000000] console [tty0] enabled
<6>[    0.000000] bootconsole [earlyser0] disabled
<6>[    0.000000] console [ttyS0] enabled
<6>[    0.000000] allocated 536870912 bytes of page_cgroup
<6>[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
<6>[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
<7>[    0.000000] hpet clockevent registered
<6>[    0.000000] tsc: Fast TSC calibration using PIT
<6>[    0.000000] tsc: Detected 2393.748 MHz processor
<6>[    0.000079] Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.49 BogoMIPS (lpj=2393748)
<6>[    0.011940] pid_max: default: 81920 minimum: 640
<6>[    0.017125] ACPI: Core revision 20140926
<4>[    0.121328] ACPI: All ACPI Tables successfully acquired
<6>[    0.127349] Security Framework initialized
<6>[    0.131933] SELinux:  Initializing.
<7>[    0.135837] SELinux:  Starting in permissive mode
<6>[    0.151639] Dentry cache hash table entries: 16777216 (order: 15, 134217728 bytes)
<6>[    0.197652] Inode-cache hash table entries: 8388608 (order: 14, 67108864 bytes)
<6>[    0.222175] Mount-cache hash table entries: 262144 (order: 9, 2097152 bytes)
<6>[    0.230228] Mountpoint-cache hash table entries: 262144 (order: 9, 2097152 bytes)
<6>[    0.239999] Initializing cgroup subsys memory
<6>[    0.244897] Initializing cgroup subsys devices
<6>[    0.249859] Initializing cgroup subsys freezer
<6>[    0.254821] Initializing cgroup subsys net_cls
<6>[    0.259782] Initializing cgroup subsys blkio
<6>[    0.264550] Initializing cgroup subsys perf_event
<6>[    0.269818] Initializing cgroup subsys hugetlb
<6>[    0.274835] CPU: Physical Processor ID: 0
<6>[    0.279309] CPU: Processor Core ID: 0
<6>[    0.283405] mce: CPU supports 24 MCE banks
<7>[    0.287998] CPU0: Thermal LVT vector (0xfa) already installed
<6>[    0.294426] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
<6>[    0.294426] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
<6>[    0.308458] Freeing SMP alternatives memory: 36K (ffffffff81fec000 - ffffffff81ff5000)
<6>[    0.319460] ftrace: allocating 31422 entries in 123 pages
<4>[    0.347911] Getting VERSION: 1060015
<4>[    0.351901] Getting VERSION: 1060015
<4>[    0.355889] Getting ID: 0
<4>[    0.358809] Getting ID: 0
<6>[    0.361744] dmar: Host address width 48
<6>[    0.366025] dmar: DRHD base: 0x000000fd800000 flags: 0x0
<6>[    0.371962] dmar: IOMMU 0: reg_base_addr fd800000 ver 1:0 cap c90780106f0462 ecap f020ff
<6>[    0.380997] dmar: DRHD base: 0x000000fd000000 flags: 0x1
<6>[    0.386931] dmar: IOMMU 1: reg_base_addr fd000000 ver 1:0 cap c90780106f0462 ecap f020ff
<6>[    0.395967] dmar: RMRR base: 0x0000007be27000 end: 0x0000007be29fff
<6>[    0.402963] dmar: RMRR base: 0x0000007be14000 end: 0x0000007be14fff
<6>[    0.409959] dmar: RMRR base: 0x0000007be11000 end: 0x0000007be11fff
<6>[    0.416956] dmar: RMRR base: 0x0000007be0e000 end: 0x0000007be0efff
<6>[    0.423952] dmar: RMRR base: 0x0000007be0b000 end: 0x0000007be0bfff
<6>[    0.430948] dmar: RMRR base: 0x0000007be08000 end: 0x0000007be08fff
<6>[    0.437947] dmar: RMRR base: 0x0000007be05000 end: 0x0000007be05fff
<6>[    0.444944] dmar: RMRR base: 0x0000007be02000 end: 0x0000007be02fff
<6>[    0.451940] dmar: RMRR base: 0x0000007b6a0000 end: 0x0000007b6a0fff
<6>[    0.458936] dmar: ATSR flags: 0x0
<6>[    0.462633] dmar: ATSR flags: 0x0
<6>[    0.466330] dmar: RHSA base: 0x000000fd000000 proximity domain: 0x0
<6>[    0.473326] dmar: RHSA base: 0x000000fd800000 proximity domain: 0x2
<6>[    0.480474] IOAPIC id 10 under DRHD base  0xfd800000 IOMMU 0
<6>[    0.486792] IOAPIC id 8 under DRHD base  0xfd000000 IOMMU 1
<6>[    0.493013] IOAPIC id 9 under DRHD base  0xfd000000 IOMMU 1
<6>[    0.499234] Queued invalidation will be enabled to support x2apic and Intr-remapping.
<6>[    0.508655] Enabled IRQ remapping in x2apic mode
<4>[    0.513818] masked ExtINT on CPU#0
<4>[    0.518198] ENABLING IO-APIC IRQs
<7>[    0.521898] init IO_APIC IRQs
<7>[    0.525208]  apic 8 pin 0 not connected
<7>[    0.529492] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>[    0.538337] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.553392] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.562235] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.577290] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.586149] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.601207] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>[    0.610053] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.625110] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>[    0.633955] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.649012] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>[    0.657856] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:35 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.672911] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>[    0.681757] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:36 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.696815] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>[    0.705661] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:37 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.720717] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>[    0.729561] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.744617] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>[    0.753463] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.768519] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>[    0.777557] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3A Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.792613] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>[    0.801654] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3B Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.816710] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>[    0.825750] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3C Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.840806] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>[    0.849845] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.864902] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>[    0.873941] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3E Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.888998] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>[    0.898038] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3F Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    0.913093]  apic 8 pin 16 not connected
<7>[    0.917471]  apic 8 pin 17 not connected
<7>[    0.921851]  apic 8 pin 18 not connected
<7>[    0.926230]  apic 8 pin 19 not connected
<7>[    0.930609]  apic 8 pin 20 not connected
<7>[    0.934987]  apic 8 pin 21 not connected
<7>[    0.939366]  apic 8 pin 22 not connected
<7>[    0.943743]  apic 8 pin 23 not connected
<7>[    0.948120]  apic 9 pin 0 not connected
<7>[    0.952401]  apic 9 pin 1 not connected
<7>[    0.956683]  apic 9 pin 2 not connected
<7>[    0.960963]  apic 9 pin 3 not connected
<7>[    0.965244]  apic 9 pin 4 not connected
<7>[    0.969524]  apic 9 pin 5 not connected
<7>[    0.973805]  apic 9 pin 6 not connected
<7>[    0.978085]  apic 9 pin 7 not connected
<7>[    0.982366]  apic 9 pin 8 not connected
<7>[    0.986647]  apic 9 pin 9 not connected
<7>[    0.990928]  apic 9 pin 10 not connected
<7>[    0.995306]  apic 9 pin 11 not connected
<7>[    0.999684]  apic 9 pin 12 not connected
<7>[    1.004062]  apic 9 pin 13 not connected
<7>[    1.008440]  apic 9 pin 14 not connected
<7>[    1.012818]  apic 9 pin 15 not connected
<7>[    1.017196]  apic 9 pin 16 not connected
<7>[    1.021574]  apic 9 pin 17 not connected
<7>[    1.025952]  apic 9 pin 18 not connected
<7>[    1.030330]  apic 9 pin 19 not connected
<7>[    1.034709]  apic 9 pin 20 not connected
<7>[    1.039087]  apic 9 pin 21 not connected
<7>[    1.043465]  apic 9 pin 22 not connected
<7>[    1.047843]  apic 9 pin 23 not connected
<7>[    1.052220]  apic 10 pin 0 not connected
<7>[    1.056599]  apic 10 pin 1 not connected
<7>[    1.060977]  apic 10 pin 2 not connected
<7>[    1.065355]  apic 10 pin 3 not connected
<7>[    1.069734]  apic 10 pin 4 not connected
<7>[    1.074112]  apic 10 pin 5 not connected
<7>[    1.078490]  apic 10 pin 6 not connected
<7>[    1.082867]  apic 10 pin 7 not connected
<7>[    1.087245]  apic 10 pin 8 not connected
<7>[    1.091624]  apic 10 pin 9 not connected
<7>[    1.096001]  apic 10 pin 10 not connected
<7>[    1.100477]  apic 10 pin 11 not connected
<7>[    1.104952]  apic 10 pin 12 not connected
<7>[    1.109426]  apic 10 pin 13 not connected
<7>[    1.113901]  apic 10 pin 14 not connected
<7>[    1.118377]  apic 10 pin 15 not connected
<7>[    1.122853]  apic 10 pin 16 not connected
<7>[    1.127329]  apic 10 pin 17 not connected
<7>[    1.131805]  apic 10 pin 18 not connected
<7>[    1.136281]  apic 10 pin 19 not connected
<7>[    1.140757]  apic 10 pin 20 not connected
<7>[    1.145232]  apic 10 pin 21 not connected
<7>[    1.149707]  apic 10 pin 22 not connected
<7>[    1.154183]  apic 10 pin 23 not connected
<6>[    1.158794] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    1.175508] smpboot: CPU0: Intel(R) Xeon(R) CPU E7- 8870  @ 2.40GHz (fam: 06, model: 2f, stepping: 02)
<4>[    1.185937] Using local APIC timer interrupts.
<4>[    1.185937] calibrating APIC timer ...
<4>[    1.297079] ... lapic delta = 831240
<4>[    1.301069] ... PM-Timer delta = 357951
<4>[    1.305348] ... PM-Timer result ok
<4>[    1.309142] ..... delta 831240
<4>[    1.312549] ..... mult: 35701486
<4>[    1.316149] ..... calibration result: 132998
<4>[    1.320914] ..... CPU clock speed is 2393.0976 MHz.
<4>[    1.326358] ..... host bus clock speed is 132.0998 MHz.
<6>[    1.332240] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
<4>[    1.341630] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
<6>[    1.349311] ... version:                3
<6>[    1.353778] ... bit width:              48
<6>[    1.358349] ... generic registers:      4
<6>[    1.362823] ... value mask:             0000ffffffffffff
<6>[    1.368752] ... max period:             000000007fffffff
<6>[    1.374682] ... fixed-purpose events:   3
<6>[    1.379157] ... event mask:             000000070000000f
<6>[    1.388645] x86: Booting SMP configuration:
<6>[    1.393319] .... node  #2, CPUs:        #1
<4>[    1.410251] masked ExtINT on CPU#1
<7>[    1.414303] CPU1: Thermal LVT vector (0xfa) already installed
<6>[    1.502564] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>[    1.511687] 
<6>[    1.513352] .... node  #1, CPUs:    #2
<4>[    1.529886] masked ExtINT on CPU#2
<7>[    1.533942] CPU2: Thermal LVT vector (0xfa) already installed
<4>[    1.620637] 
<6>[    1.622304] .... node  #3, CPUs:    #3
<4>[    1.638828] masked ExtINT on CPU#3
<7>[    1.642880] CPU3: Thermal LVT vector (0xfa) already installed
<4>[    1.728674] 
<6>[    1.730340] .... node  #0, CPUs:    #4
<4>[    1.746683] masked ExtINT on CPU#4
<7>[    1.750745] CPU4: Thermal LVT vector (0xfa) already installed
<4>[    1.759498] 
<6>[    1.761167] .... node  #2, CPUs:    #5
<4>[    1.777699] masked ExtINT on CPU#5
<7>[    1.781753] CPU5: Thermal LVT vector (0xfa) already installed
<4>[    1.790415] 
<6>[    1.792080] .... node  #1, CPUs:    #6
<4>[    1.808611] masked ExtINT on CPU#6
<7>[    1.812669] CPU6: Thermal LVT vector (0xfa) already installed
<4>[    1.821323] 
<6>[    1.822989] .... node  #3, CPUs:    #7
<4>[    1.839524] masked ExtINT on CPU#7
<7>[    1.843577] CPU7: Thermal LVT vector (0xfa) already installed
<4>[    1.852231] 
<6>[    1.853897] .... node  #0, CPUs:    #8
<4>[    1.870241] masked ExtINT on CPU#8
<7>[    1.874304] CPU8: Thermal LVT vector (0xfa) already installed
<4>[    1.883058] 
<6>[    1.884727] .... node  #2, CPUs:    #9
<4>[    1.901263] masked ExtINT on CPU#9
<7>[    1.905320] CPU9: Thermal LVT vector (0xfa) already installed
<4>[    1.913981] 
<6>[    1.915646] .... node  #1, CPUs:   #10
<4>[    1.932181] masked ExtINT on CPU#10
<7>[    1.936330] CPU10: Thermal LVT vector (0xfa) already installed
<4>[    1.945097] 
<6>[    1.946762] .... node  #3, CPUs:   #11
<4>[    1.963298] masked ExtINT on CPU#11
<7>[    1.967455] CPU11: Thermal LVT vector (0xfa) already installed
<4>[    1.976203] 
<6>[    1.977868] .... node  #0, CPUs:   #12
<4>[    1.994208] masked ExtINT on CPU#12
<7>[    1.998365] CPU12: Thermal LVT vector (0xfa) already installed
<4>[    2.007228] 
<6>[    2.008898] .... node  #2, CPUs:   #13
<4>[    2.025434] masked ExtINT on CPU#13
<7>[    2.029583] CPU13: Thermal LVT vector (0xfa) already installed
<4>[    2.038354] 
<6>[    2.040019] .... node  #1, CPUs:   #14
<4>[    2.056551] masked ExtINT on CPU#14
<7>[    2.060705] CPU14: Thermal LVT vector (0xfa) already installed
<4>[    2.069458] 
<6>[    2.071123] .... node  #3, CPUs:   #15
<4>[    2.087655] masked ExtINT on CPU#15
<7>[    2.091803] CPU15: Thermal LVT vector (0xfa) already installed
<4>[    2.100558] 
<6>[    2.102225] .... node  #0, CPUs:   #16
<4>[    2.118558] masked ExtINT on CPU#16
<7>[    2.122712] CPU16: Thermal LVT vector (0xfa) already installed
<4>[    2.131589] 
<6>[    2.133259] .... node  #2, CPUs:   #17
<4>[    2.149793] masked ExtINT on CPU#17
<7>[    2.153940] CPU17: Thermal LVT vector (0xfa) already installed
<4>[    2.162719] 
<6>[    2.164375] .... node  #1, CPUs:   #18
<4>[    2.180907] masked ExtINT on CPU#18
<7>[    2.185055] CPU18: Thermal LVT vector (0xfa) already installed
<4>[    2.193822] 
<6>[    2.195486] .... node  #3, CPUs:   #19
<4>[    2.212019] masked ExtINT on CPU#19
<7>[    2.216169] CPU19: Thermal LVT vector (0xfa) already installed
<4>[    2.224917] 
<6>[    2.226582] .... node  #0, CPUs:   #20
<4>[    2.242918] masked ExtINT on CPU#20
<7>[    2.247071] CPU20: Thermal LVT vector (0xfa) already installed
<4>[    2.255958] 
<6>[    2.257628] .... node  #2, CPUs:   #21
<4>[    2.274161] masked ExtINT on CPU#21
<7>[    2.278307] CPU21: Thermal LVT vector (0xfa) already installed
<4>[    2.287081] 
<6>[    2.288747] .... node  #1, CPUs:   #22
<4>[    2.305281] masked ExtINT on CPU#22
<7>[    2.309416] CPU22: Thermal LVT vector (0xfa) already installed
<4>[    2.318190] 
<6>[    2.319854] .... node  #3, CPUs:   #23
<4>[    2.336388] masked ExtINT on CPU#23
<7>[    2.340531] CPU23: Thermal LVT vector (0xfa) already installed
<4>[    2.349296] 
<6>[    2.350963] .... node  #0, CPUs:   #24
<4>[    2.367308] masked ExtINT on CPU#24
<7>[    2.371457] CPU24: Thermal LVT vector (0xfa) already installed
<4>[    2.380331] 
<6>[    2.382001] .... node  #2, CPUs:   #25
<4>[    2.398537] masked ExtINT on CPU#25
<7>[    2.402691] CPU25: Thermal LVT vector (0xfa) already installed
<4>[    2.411458] 
<6>[    2.413123] .... node  #1, CPUs:   #26
<4>[    2.429658] masked ExtINT on CPU#26
<7>[    2.433798] CPU26: Thermal LVT vector (0xfa) already installed
<4>[    2.442561] 
<6>[    2.444227] .... node  #3, CPUs:   #27
<4>[    2.460761] masked ExtINT on CPU#27
<7>[    2.464938] CPU27: Thermal LVT vector (0xfa) already installed
<4>[    2.473770] 
<6>[    2.475434] .... node  #0, CPUs:   #28
<4>[    2.491774] masked ExtINT on CPU#28
<7>[    2.495927] CPU28: Thermal LVT vector (0xfa) already installed
<4>[    2.504794] 
<6>[    2.506464] .... node  #2, CPUs:   #29
<4>[    2.522996] masked ExtINT on CPU#29
<7>[    2.527148] CPU29: Thermal LVT vector (0xfa) already installed
<4>[    2.535928] 
<6>[    2.537592] .... node  #1, CPUs:   #30
<4>[    2.554123] masked ExtINT on CPU#30
<7>[    2.558291] CPU30: Thermal LVT vector (0xfa) already installed
<4>[    2.567129] 
<6>[    2.568786] .... node  #3, CPUs:   #31
<4>[    2.585319] masked ExtINT on CPU#31
<7>[    2.589465] CPU31: Thermal LVT vector (0xfa) already installed
<4>[    2.598228] 
<6>[    2.599894] .... node  #0, CPUs:   #32
<4>[    2.616972] masked ExtINT on CPU#32
<7>[    2.621129] CPU32: Thermal LVT vector (0xfa) already installed
<4>[    2.630025] 
<6>[    2.631695] .... node  #2, CPUs:   #33
<4>[    2.648230] masked ExtINT on CPU#33
<7>[    2.652379] CPU33: Thermal LVT vector (0xfa) already installed
<4>[    2.661156] 
<6>[    2.662820] .... node  #1, CPUs:   #34
<4>[    2.679352] masked ExtINT on CPU#34
<7>[    2.683497] CPU34: Thermal LVT vector (0xfa) already installed
<4>[    2.692261] 
<6>[    2.693925] .... node  #3, CPUs:   #35
<4>[    2.710459] masked ExtINT on CPU#35
<7>[    2.714614] CPU35: Thermal LVT vector (0xfa) already installed
<4>[    2.723366] 
<6>[    2.725022] .... node  #0, CPUs:   #36
<4>[    2.741360] masked ExtINT on CPU#36
<7>[    2.745504] CPU36: Thermal LVT vector (0xfa) already installed
<4>[    2.754387] 
<6>[    2.756056] .... node  #2, CPUs:   #37
<4>[    2.772592] masked ExtINT on CPU#37
<7>[    2.776734] CPU37: Thermal LVT vector (0xfa) already installed
<4>[    2.785513] 
<6>[    2.787176] .... node  #1, CPUs:   #38
<4>[    2.803711] masked ExtINT on CPU#38
<7>[    2.807854] CPU38: Thermal LVT vector (0xfa) already installed
<4>[    2.816613] 
<6>[    2.818278] .... node  #3, CPUs:   #39
<4>[    2.834813] masked ExtINT on CPU#39
<7>[    2.838961] CPU39: Thermal LVT vector (0xfa) already installed
<4>[    2.847724] 
<6>[    2.849390] .... node  #0, CPUs:   #40
<4>[    2.865734] masked ExtINT on CPU#40
<7>[    2.869887] CPU40: Thermal LVT vector (0xfa) already installed
<4>[    2.878763] 
<6>[    2.880433] .... node  #2, CPUs:   #41
<4>[    2.896972] masked ExtINT on CPU#41
<7>[    2.901118] CPU41: Thermal LVT vector (0xfa) already installed
<4>[    2.909897] 
<6>[    2.911561] .... node  #1, CPUs:   #42
<4>[    2.928096] masked ExtINT on CPU#42
<7>[    2.932249] CPU42: Thermal LVT vector (0xfa) already installed
<4>[    2.941013] 
<6>[    2.942679] .... node  #3, CPUs:   #43
<4>[    2.959211] masked ExtINT on CPU#43
<7>[    2.963361] CPU43: Thermal LVT vector (0xfa) already installed
<4>[    2.972119] 
<6>[    2.973784] .... node  #0, CPUs:   #44
<4>[    2.990121] masked ExtINT on CPU#44
<7>[    2.994270] CPU44: Thermal LVT vector (0xfa) already installed
<4>[    3.003152] 
<6>[    3.004821] .... node  #2, CPUs:   #45
<4>[    3.021358] masked ExtINT on CPU#45
<7>[    3.025512] CPU45: Thermal LVT vector (0xfa) already installed
<4>[    3.034290] 
<6>[    3.035955] .... node  #1, CPUs:   #46
<4>[    3.052488] masked ExtINT on CPU#46
<7>[    3.056632] CPU46: Thermal LVT vector (0xfa) already installed
<4>[    3.065404] 
<6>[    3.067070] .... node  #3, CPUs:   #47
<4>[    3.083603] masked ExtINT on CPU#47
<7>[    3.087747] CPU47: Thermal LVT vector (0xfa) already installed
<4>[    3.096508] 
<6>[    3.098174] .... node  #0, CPUs:   #48
<4>[    3.114511] masked ExtINT on CPU#48
<7>[    3.118659] CPU48: Thermal LVT vector (0xfa) already installed
<4>[    3.127559] 
<6>[    3.129227] .... node  #2, CPUs:   #49
<4>[    3.145765] masked ExtINT on CPU#49
<7>[    3.149921] CPU49: Thermal LVT vector (0xfa) already installed
<4>[    3.158686] 
<6>[    3.160352] .... node  #1, CPUs:   #50
<4>[    3.176888] masked ExtINT on CPU#50
<7>[    3.181036] CPU50: Thermal LVT vector (0xfa) already installed
<4>[    3.189797] 
<6>[    3.191463] .... node  #3, CPUs:   #51
<4>[    3.207998] masked ExtINT on CPU#51
<7>[    3.212143] CPU51: Thermal LVT vector (0xfa) already installed
<4>[    3.220899] 
<6>[    3.222564] .... node  #0, CPUs:   #52
<4>[    3.238903] masked ExtINT on CPU#52
<7>[    3.243047] CPU52: Thermal LVT vector (0xfa) already installed
<4>[    3.251937] 
<6>[    3.253607] .... node  #2, CPUs:   #53
<4>[    3.270144] masked ExtINT on CPU#53
<7>[    3.274291] CPU53: Thermal LVT vector (0xfa) already installed
<4>[    3.283068] 
<6>[    3.284733] .... node  #1, CPUs:   #54
<4>[    3.301266] masked ExtINT on CPU#54
<7>[    3.305420] CPU54: Thermal LVT vector (0xfa) already installed
<4>[    3.314171] 
<6>[    3.315837] .... node  #3, CPUs:   #55
<4>[    3.332371] masked ExtINT on CPU#55
<7>[    3.336526] CPU55: Thermal LVT vector (0xfa) already installed
<4>[    3.345279] 
<6>[    3.346945] .... node  #0, CPUs:   #56
<4>[    3.363278] masked ExtINT on CPU#56
<7>[    3.367435] CPU56: Thermal LVT vector (0xfa) already installed
<4>[    3.376314] 
<6>[    3.377984] .... node  #2, CPUs:   #57
<4>[    3.394520] masked ExtINT on CPU#57
<7>[    3.398661] CPU57: Thermal LVT vector (0xfa) already installed
<4>[    3.407448] 
<6>[    3.409105] .... node  #1, CPUs:   #58
<4>[    3.425640] masked ExtINT on CPU#58
<7>[    3.429788] CPU58: Thermal LVT vector (0xfa) already installed
<4>[    3.438542] 
<6>[    3.440207] .... node  #3, CPUs:   #59
<4>[    3.456742] masked ExtINT on CPU#59
<7>[    3.460888] CPU59: Thermal LVT vector (0xfa) already installed
<4>[    3.469645] 
<6>[    3.471309] .... node  #0, CPUs:   #60
<4>[    3.487647] masked ExtINT on CPU#60
<7>[    3.491791] CPU60: Thermal LVT vector (0xfa) already installed
<4>[    3.500690] 
<6>[    3.502360] .... node  #2, CPUs:   #61
<4>[    3.518895] masked ExtINT on CPU#61
<7>[    3.523052] CPU61: Thermal LVT vector (0xfa) already installed
<4>[    3.531813] 
<6>[    3.533478] .... node  #1, CPUs:   #62
<4>[    3.550014] masked ExtINT on CPU#62
<7>[    3.554156] CPU62: Thermal LVT vector (0xfa) already installed
<4>[    3.562917] 
<6>[    3.564582] .... node  #3, CPUs:   #63
<4>[    3.581118] masked ExtINT on CPU#63
<7>[    3.585272] CPU63: Thermal LVT vector (0xfa) already installed
<4>[    3.594026] 
<6>[    3.595693] .... node  #0, CPUs:   #64
<4>[    3.612031] masked ExtINT on CPU#64
<7>[    3.616180] CPU64: Thermal LVT vector (0xfa) already installed
<4>[    3.625075] 
<6>[    3.626745] .... node  #2, CPUs:   #65
<4>[    3.643282] masked ExtINT on CPU#65
<7>[    3.647438] CPU65: Thermal LVT vector (0xfa) already installed
<4>[    3.656207] 
<6>[    3.657863] .... node  #1, CPUs:   #66
<4>[    3.674399] masked ExtINT on CPU#66
<7>[    3.678560] CPU66: Thermal LVT vector (0xfa) already installed
<4>[    3.687409] 
<6>[    3.689074] .... node  #3, CPUs:   #67
<4>[    3.705607] masked ExtINT on CPU#67
<7>[    3.709751] CPU67: Thermal LVT vector (0xfa) already installed
<4>[    3.718512] 
<6>[    3.720167] .... node  #0, CPUs:   #68
<4>[    3.736507] masked ExtINT on CPU#68
<7>[    3.740661] CPU68: Thermal LVT vector (0xfa) already installed
<4>[    3.749534] 
<6>[    3.751205] .... node  #2, CPUs:   #69
<4>[    3.767744] masked ExtINT on CPU#69
<7>[    3.771889] CPU69: Thermal LVT vector (0xfa) already installed
<4>[    3.780673] 
<6>[    3.782337] .... node  #1, CPUs:   #70
<4>[    3.798874] masked ExtINT on CPU#70
<7>[    3.803024] CPU70: Thermal LVT vector (0xfa) already installed
<4>[    3.811789] 
<6>[    3.813454] .... node  #3, CPUs:   #71
<4>[    3.829990] masked ExtINT on CPU#71
<7>[    3.834138] CPU71: Thermal LVT vector (0xfa) already installed
<4>[    3.842893] 
<6>[    3.844559] .... node  #0, CPUs:   #72
<4>[    3.860904] masked ExtINT on CPU#72
<7>[    3.865054] CPU72: Thermal LVT vector (0xfa) already installed
<4>[    3.873942] 
<6>[    3.875612] .... node  #2, CPUs:   #73
<4>[    3.892151] masked ExtINT on CPU#73
<7>[    3.896293] CPU73: Thermal LVT vector (0xfa) already installed
<4>[    3.905063] 
<6>[    3.906718] .... node  #1, CPUs:   #74
<4>[    3.923254] masked ExtINT on CPU#74
<7>[    3.927404] CPU74: Thermal LVT vector (0xfa) already installed
<4>[    3.936159] 
<6>[    3.937824] .... node  #3, CPUs:   #75
<4>[    3.954360] masked ExtINT on CPU#75
<7>[    3.958507] CPU75: Thermal LVT vector (0xfa) already installed
<4>[    3.967264] 
<6>[    3.968930] .... node  #0, CPUs:   #76
<4>[    3.985271] masked ExtINT on CPU#76
<7>[    3.989429] CPU76: Thermal LVT vector (0xfa) already installed
<4>[    3.998408] 
<6>[    4.000078] .... node  #2, CPUs:   #77
<4>[    4.016616] masked ExtINT on CPU#77
<7>[    4.020764] CPU77: Thermal LVT vector (0xfa) already installed
<4>[    4.029532] 
<6>[    4.031197] .... node  #1, CPUs:   #78
<4>[    4.047736] masked ExtINT on CPU#78
<7>[    4.051891] CPU78: Thermal LVT vector (0xfa) already installed
<4>[    4.060740] 
<6>[    4.062405] .... node  #3, CPUs:   #79
<4>[    4.078941] masked ExtINT on CPU#79
<7>[    4.083088] CPU79: Thermal LVT vector (0xfa) already installed
<6>[    4.091678] x86: Booted up 4 nodes, 80 CPUs
<6>[    4.096352] smpboot: Total of 80 processors activated (383024.00 BogoMIPS)
<6>[    4.594424] devtmpfs: initialized
<6>[    4.598225] Using 2GB memory block size for large-memory system
<6>[    4.607271] evm: security.selinux
<6>[    4.610972] evm: security.ima
<6>[    4.614284] evm: security.capability
<6>[    4.618486] PM: Registering ACPI NVS region [mem 0x7b455000-0x7b68ffff] (2338816 bytes)
<6>[    4.627471] PM: Registering ACPI NVS region [mem 0x7b7bd000-0x7ba3cfff] (2621440 bytes)
<6>[    4.636453] PM: Registering ACPI NVS region [mem 0x7bf71000-0x7bfcefff] (385024 bytes)
<6>[    4.647315] atomic64_test: passed for x86-64 platform with CX8 and with SSE
<6>[    4.655413] NET: Registered protocol family 16
<6>[    4.663827] cpuidle: using governor menu
<6>[    4.668381] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
<6>[    4.676838] ACPI: bus type PCI registered
<6>[    4.681316] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>[    4.688637] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
<6>[    4.699038] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
<6>[    4.707193] PCI: Using configuration type 1 for base access
<6>[    4.721539] ACPI: Added _OSI(Module Device)
<6>[    4.726214] ACPI: Added _OSI(Processor Device)
<6>[    4.731176] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>[    4.736429] ACPI: Added _OSI(Processor Aggregator Device)
<7>[    4.748613] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>[    4.757467] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<6>[    4.889132] ACPI: Interpreter enabled
<4>[    4.893234] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
<4>[    4.903561] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140926/hwxface-580)
<4>[    4.913888] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20140926/hwxface-580)
<6>[    4.924209] ACPI: (supports S0 S1 S5)
<6>[    4.928297] ACPI: Using IOAPIC for interrupt routing
<6>[    4.933900] HEST: Table parsing has been initialized.
<6>[    4.939544] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>[    4.974336] ACPI: PCI Root Bridge [IOH0] (domain 0000 [bus 00-7f])
<6>[    4.981247] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    4.990581] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug AER]
<6>[    4.998842] acpi PNP0A08:00: _OSC: OS now controls [PME PCIeCapability]
<6>[    5.006850] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
<6>[    5.021154] PCI host bridge to bus 0000:00
<6>[    5.025731] pci_bus 0000:00: root bus resource [bus 00-7f]
<6>[    5.031858] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
<6>[    5.038761] pci_bus 0000:00: root bus resource [io  0x1000-0x9fff]
<6>[    5.045665] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>[    5.053345] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
<6>[    5.061025] pci_bus 0000:00: root bus resource [mem 0x90000000-0xafffffff]
<6>[    5.068704] pci_bus 0000:00: root bus resource [mem 0xfc000000000-0xfc07fffffff]
<7>[    5.076969] pci 0000:00:00.0: [8086:3407] type 00 class 0x060000
<7>[    5.083745] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
<7>[    5.090674] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
<7>[    5.097446] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
<6>[    5.104324] pci 0000:00:01.0: System wakeup disabled by ACPI
<7>[    5.110689] pci 0000:00:02.0: [8086:3409] type 01 class 0x060400
<7>[    5.117457] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
<6>[    5.124341] pci 0000:00:02.0: System wakeup disabled by ACPI
<7>[    5.130702] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
<7>[    5.137472] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
<7>[    5.144396] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
<7>[    5.151165] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
<6>[    5.158046] pci 0000:00:05.0: System wakeup disabled by ACPI
<7>[    5.164412] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
<7>[    5.171180] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
<6>[    5.178061] pci 0000:00:07.0: System wakeup disabled by ACPI
<7>[    5.184424] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
<7>[    5.191191] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
<6>[    5.198072] pci 0000:00:09.0: System wakeup disabled by ACPI
<7>[    5.204434] pci 0000:00:0a.0: [8086:3411] type 01 class 0x060400
<7>[    5.211202] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
<6>[    5.218081] pci 0000:00:0a.0: System wakeup disabled by ACPI
<7>[    5.224443] pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
<7>[    5.231288] pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
<7>[    5.238124] pci 0000:00:11.0: [8086:3427] type 00 class 0x080000
<7>[    5.244966] pci 0000:00:11.1: [8086:3428] type 00 class 0x080000
<7>[    5.251801] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
<7>[    5.258523] pci 0000:00:13.0: reg 0x10: [mem 0x95c02000-0x95c02fff]
<7>[    5.265570] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
<7>[    5.272483] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
<7>[    5.279339] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
<7>[    5.286185] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
<7>[    5.293029] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
<7>[    5.299863] pci 0000:00:15.0: [8086:342f] type 00 class 0x080020
<7>[    5.306700] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
<7>[    5.313423] pci 0000:00:16.0: reg 0x10: [mem 0xaff1c000-0xaff1ffff 64bit]
<7>[    5.321155] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
<7>[    5.327878] pci 0000:00:16.1: reg 0x10: [mem 0xaff18000-0xaff1bfff 64bit]
<7>[    5.335609] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
<7>[    5.342332] pci 0000:00:16.2: reg 0x10: [mem 0xaff14000-0xaff17fff 64bit]
<7>[    5.350063] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
<7>[    5.356783] pci 0000:00:16.3: reg 0x10: [mem 0xaff10000-0xaff13fff 64bit]
<7>[    5.364519] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
<7>[    5.371243] pci 0000:00:16.4: reg 0x10: [mem 0xaff0c000-0xaff0ffff 64bit]
<7>[    5.378972] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
<7>[    5.385694] pci 0000:00:16.5: reg 0x10: [mem 0xaff08000-0xaff0bfff 64bit]
<7>[    5.393423] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
<7>[    5.400143] pci 0000:00:16.6: reg 0x10: [mem 0xaff04000-0xaff07fff 64bit]
<7>[    5.407874] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
<7>[    5.414595] pci 0000:00:16.7: reg 0x10: [mem 0xaff00000-0xaff03fff 64bit]
<7>[    5.422330] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
<7>[    5.429079] pci 0000:00:1a.0: reg 0x20: [io  0x60c0-0x60df]
<6>[    5.435434] pci 0000:00:1a.0: System wakeup disabled by ACPI
<7>[    5.441799] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
<7>[    5.448546] pci 0000:00:1a.1: reg 0x20: [io  0x60a0-0x60bf]
<6>[    5.454897] pci 0000:00:1a.1: System wakeup disabled by ACPI
<7>[    5.461262] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
<7>[    5.468011] pci 0000:00:1a.2: reg 0x20: [io  0x6080-0x609f]
<6>[    5.474364] pci 0000:00:1a.2: System wakeup disabled by ACPI
<7>[    5.480736] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
<7>[    5.487462] pci 0000:00:1a.7: reg 0x10: [mem 0x95c01000-0x95c013ff]
<7>[    5.494547] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
<6>[    5.501448] pci 0000:00:1a.7: System wakeup disabled by ACPI
<7>[    5.507804] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
<7>[    5.514594] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<6>[    5.521480] pci 0000:00:1c.0: System wakeup disabled by ACPI
<7>[    5.527847] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
<7>[    5.534630] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
<6>[    5.541511] pci 0000:00:1c.4: System wakeup disabled by ACPI
<7>[    5.547876] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
<7>[    5.554624] pci 0000:00:1d.0: reg 0x20: [io  0x6060-0x607f]
<6>[    5.560976] pci 0000:00:1d.0: System wakeup disabled by ACPI
<7>[    5.567341] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
<7>[    5.574090] pci 0000:00:1d.1: reg 0x20: [io  0x6040-0x605f]
<6>[    5.580442] pci 0000:00:1d.1: System wakeup disabled by ACPI
<7>[    5.586806] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
<7>[    5.593556] pci 0000:00:1d.2: reg 0x20: [io  0x6020-0x603f]
<6>[    5.599907] pci 0000:00:1d.2: System wakeup disabled by ACPI
<7>[    5.606279] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
<7>[    5.613006] pci 0000:00:1d.7: reg 0x10: [mem 0x95c00000-0x95c003ff]
<7>[    5.620086] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
<6>[    5.626994] pci 0000:00:1d.7: System wakeup disabled by ACPI
<7>[    5.633358] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
<6>[    5.640184] pci 0000:00:1e.0: System wakeup disabled by ACPI
<7>[    5.646549] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
<6>[    5.653337] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
<6>[    5.662184] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
<6>[    5.670156] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
<6>[    5.678614] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
<6>[    5.687071] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0600 (mask 001f)
<7>[    5.695659] pci 0000:00:1f.2: [8086:3a20] type 00 class 0x01018f
<7>[    5.702383] pci 0000:00:1f.2: reg 0x10: [io  0x6138-0x613f]
<7>[    5.708612] pci 0000:00:1f.2: reg 0x14: [io  0x614c-0x614f]
<7>[    5.714842] pci 0000:00:1f.2: reg 0x18: [io  0x6130-0x6137]
<7>[    5.721070] pci 0000:00:1f.2: reg 0x1c: [io  0x6148-0x614b]
<7>[    5.727300] pci 0000:00:1f.2: reg 0x20: [io  0x6110-0x611f]
<7>[    5.733528] pci 0000:00:1f.2: reg 0x24: [io  0x6100-0x610f]
<7>[    5.739885] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
<7>[    5.746608] pci 0000:00:1f.3: reg 0x10: [mem 0xaff20000-0xaff200ff 64bit]
<7>[    5.754207] pci 0000:00:1f.3: reg 0x20: [io  0x6000-0x601f]
<7>[    5.760551] pci 0000:00:1f.5: [8086:3a26] type 00 class 0x010185
<7>[    5.767275] pci 0000:00:1f.5: reg 0x10: [io  0x6128-0x612f]
<7>[    5.773504] pci 0000:00:1f.5: reg 0x14: [io  0x6144-0x6147]
<7>[    5.779733] pci 0000:00:1f.5: reg 0x18: [io  0x6120-0x6127]
<7>[    5.785963] pci 0000:00:1f.5: reg 0x1c: [io  0x6140-0x6143]
<7>[    5.792191] pci 0000:00:1f.5: reg 0x20: [io  0x60f0-0x60ff]
<7>[    5.798421] pci 0000:00:1f.5: reg 0x24: [io  0x60e0-0x60ef]
<7>[    5.804910] pci 0000:01:00.0: [8086:150a] type 00 class 0x020000
<7>[    5.811637] pci 0000:01:00.0: reg 0x10: [mem 0x95b20000-0x95b3ffff]
<7>[    5.818655] pci 0000:01:00.0: reg 0x18: [io  0x5020-0x503f]
<7>[    5.824880] pci 0000:01:00.0: reg 0x1c: [mem 0x95bc4000-0x95bc7fff]
<7>[    5.831986] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
<7>[    5.838840] pci 0000:01:00.0: reg 0x184: [mem 0x95b40000-0x95b43fff 64bit]
<7>[    5.846540] pci 0000:01:00.0: reg 0x190: [mem 0x95b60000-0x95b63fff 64bit]
<7>[    5.854311] pci 0000:01:00.1: [8086:150a] type 00 class 0x020000
<7>[    5.861035] pci 0000:01:00.1: reg 0x10: [mem 0x95b00000-0x95b1ffff]
<7>[    5.868054] pci 0000:01:00.1: reg 0x18: [io  0x5000-0x501f]
<7>[    5.874287] pci 0000:01:00.1: reg 0x1c: [mem 0x95bc0000-0x95bc3fff]
<7>[    5.881391] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
<7>[    5.888239] pci 0000:01:00.1: reg 0x184: [mem 0x95b80000-0x95b83fff 64bit]
<7>[    5.895939] pci 0000:01:00.1: reg 0x190: [mem 0x95ba0000-0x95ba3fff 64bit]
<6>[    5.906762] pci 0000:00:01.0: PCI bridge to [bus 01-03]
<7>[    5.912601] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
<7>[    5.919409] pci 0000:00:01.0:   bridge window [mem 0x95b00000-0x95bfffff]
<7>[    5.927125] pci 0000:04:00.0: [8086:150a] type 00 class 0x020000
<7>[    5.933852] pci 0000:04:00.0: reg 0x10: [mem 0x95a20000-0x95a3ffff]
<7>[    5.940862] pci 0000:04:00.0: reg 0x18: [io  0x4020-0x403f]
<7>[    5.947094] pci 0000:04:00.0: reg 0x1c: [mem 0x95ac4000-0x95ac7fff]
<7>[    5.954198] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
<7>[    5.961052] pci 0000:04:00.0: reg 0x184: [mem 0x95a40000-0x95a43fff 64bit]
<7>[    5.968752] pci 0000:04:00.0: reg 0x190: [mem 0x95a60000-0x95a63fff 64bit]
<7>[    5.976522] pci 0000:04:00.1: [8086:150a] type 00 class 0x020000
<7>[    5.983247] pci 0000:04:00.1: reg 0x10: [mem 0x95a00000-0x95a1ffff]
<7>[    5.990267] pci 0000:04:00.1: reg 0x18: [io  0x4000-0x401f]
<7>[    5.996500] pci 0000:04:00.1: reg 0x1c: [mem 0x95ac0000-0x95ac3fff]
<7>[    6.003596] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
<7>[    6.010445] pci 0000:04:00.1: reg 0x184: [mem 0x95a80000-0x95a83fff 64bit]
<7>[    6.018145] pci 0000:04:00.1: reg 0x190: [mem 0x95aa0000-0x95aa3fff 64bit]
<6>[    6.029829] pci 0000:00:02.0: PCI bridge to [bus 04-06]
<7>[    6.035668] pci 0000:00:02.0:   bridge window [io  0x4000-0x4fff]
<7>[    6.042476] pci 0000:00:02.0:   bridge window [mem 0x95a00000-0x95afffff]
<7>[    6.050166] pci 0000:07:00.0: [1000:0079] type 00 class 0x010400
<7>[    6.056888] pci 0000:07:00.0: reg 0x10: [io  0x3000-0x30ff]
<7>[    6.063119] pci 0000:07:00.0: reg 0x14: [mem 0x95940000-0x95943fff 64bit]
<7>[    6.070709] pci 0000:07:00.0: reg 0x1c: [mem 0x95900000-0x9593ffff 64bit]
<7>[    6.078302] pci 0000:07:00.0: reg 0x30: [mem 0xfffc0000-0xffffffff pref]
<7>[    6.085836] pci 0000:07:00.0: supports D1 D2
<6>[    6.093860] pci 0000:00:03.0: PCI bridge to [bus 07]
<7>[    6.099409] pci 0000:00:03.0:   bridge window [io  0x3000-0x3fff]
<7>[    6.106216] pci 0000:00:03.0:   bridge window [mem 0x95900000-0x959fffff]
<7>[    6.113802] pci 0000:00:03.0:   bridge window [mem 0x95d00000-0x95dfffff 64bit pref]
<6>[    6.122734] acpiphp: Slot [1] registered
<6>[    6.127141] pci 0000:00:05.0: PCI bridge to [bus 08-0a]
<7>[    6.132980] pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
<7>[    6.139787] pci 0000:00:05.0:   bridge window [mem 0x94900000-0x958fffff]
<7>[    6.147373] pci 0000:00:05.0:   bridge window [mem 0x91900000-0x928fffff 64bit pref]
<6>[    6.156289] acpiphp: Slot [2] registered
<6>[    6.160698] pci 0000:00:07.0: PCI bridge to [bus 0b-0d]
<7>[    6.166535] pci 0000:00:07.0:   bridge window [io  0x1000-0x1fff]
<7>[    6.173343] pci 0000:00:07.0:   bridge window [mem 0x93900000-0x948fffff]
<7>[    6.180929] pci 0000:00:07.0:   bridge window [mem 0x92900000-0x938fffff 64bit pref]
<6>[    6.189845] pci 0000:00:09.0: PCI bridge to [bus 0e]
<6>[    6.195658] pci 0000:00:0a.0: PCI bridge to [bus 0f]
<6>[    6.201332] pci 0000:00:1c.0: PCI bridge to [bus 10]
<7>[    6.206881] pci 0000:00:1c.0:   bridge window [io  0x7000-0x7fff]
<7>[    6.213690] pci 0000:00:1c.0:   bridge window [mem 0x95e00000-0x95ffffff]
<7>[    6.221275] pci 0000:00:1c.0:   bridge window [mem 0xfc000000000-0xfc0001fffff 64bit pref]
<7>[    6.230589] pci 0000:11:00.0: [102b:0522] type 00 class 0x030000
<7>[    6.237323] pci 0000:11:00.0: reg 0x10: [mem 0x90000000-0x90ffffff pref]
<7>[    6.244820] pci 0000:11:00.0: reg 0x14: [mem 0x91800000-0x91803fff]
<7>[    6.251833] pci 0000:11:00.0: reg 0x18: [mem 0x91000000-0x917fffff]
<7>[    6.258882] pci 0000:11:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
<6>[    6.267961] pci 0000:00:1c.4: PCI bridge to [bus 11]
<7>[    6.273513] pci 0000:00:1c.4:   bridge window [mem 0x91000000-0x918fffff]
<7>[    6.281100] pci 0000:00:1c.4:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
<6>[    6.289823] pci 0000:00:1e.0: PCI bridge to [bus 12] (subtractive decode)
<7>[    6.297414] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
<7>[    6.306257] pci 0000:00:1e.0:   bridge window [io  0x1000-0x9fff] (subtractive decode)
<7>[    6.315102] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>[    6.324713] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
<7>[    6.334324] pci 0000:00:1e.0:   bridge window [mem 0x90000000-0xafffffff] (subtractive decode)
<7>[    6.343944] pci 0000:00:1e.0:   bridge window [mem 0xfc000000000-0xfc07fffffff] (subtractive decode)
<6>[    6.354195] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
<6>[    6.362539] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
<6>[    6.372113] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
<6>[    6.381683] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
<6>[    6.391241] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
<6>[    6.400808] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
<6>[    6.410375] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
<6>[    6.419943] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
<6>[    6.429508] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
<7>[    6.439053] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>[    6.448097] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0FF SQ:0 SVT:1)
<6>[    6.463529] ACPI: PCI Root Bridge [IOH1] (domain 0000 [bus 80-f7])
<6>[    6.470437] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    6.479772] acpi PNP0A08:01: _OSC: platform does not support [PCIeHotplug AER]
<6>[    6.488033] acpi PNP0A08:01: _OSC: OS now controls [PME PCIeCapability]
<6>[    6.495593] PCI host bridge to bus 0000:80
<6>[    6.500170] pci_bus 0000:80: root bus resource [bus 80-f7]
<6>[    6.506296] pci_bus 0000:80: root bus resource [io  0xa000-0xffff]
<6>[    6.513200] pci_bus 0000:80: root bus resource [mem 0xb0000000-0xfbffffff]
<6>[    6.520871] pci_bus 0000:80: root bus resource [mem 0xfc080000000-0xfc0ffffffff]
<7>[    6.529136] pci 0000:80:00.0: [8086:3420] type 01 class 0x060400
<7>[    6.535909] pci 0000:80:00.0: PME# supported from D0 D3hot D3cold
<6>[    6.542758] pci 0000:80:00.0: System wakeup disabled by ACPI
<7>[    6.549134] pci 0000:80:01.0: [8086:3408] type 01 class 0x060400
<7>[    6.555908] pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
<6>[    6.562753] pci 0000:80:01.0: System wakeup disabled by ACPI
<7>[    6.569123] pci 0000:80:03.0: [8086:340a] type 01 class 0x060400
<7>[    6.575895] pci 0000:80:03.0: PME# supported from D0 D3hot D3cold
<6>[    6.582741] pci 0000:80:03.0: System wakeup disabled by ACPI
<7>[    6.589107] pci 0000:80:07.0: [8086:340e] type 01 class 0x060400
<7>[    6.595870] pci 0000:80:07.0: PME# supported from D0 D3hot D3cold
<6>[    6.602715] pci 0000:80:07.0: System wakeup disabled by ACPI
<7>[    6.609080] pci 0000:80:09.0: [8086:3410] type 01 class 0x060400
<7>[    6.615844] pci 0000:80:09.0: PME# supported from D0 D3hot D3cold
<6>[    6.622689] pci 0000:80:09.0: System wakeup disabled by ACPI
<7>[    6.629054] pci 0000:80:10.0: [8086:3425] type 00 class 0x080000
<7>[    6.635869] pci 0000:80:10.1: [8086:3426] type 00 class 0x080000
<7>[    6.642670] pci 0000:80:11.0: [8086:3427] type 00 class 0x080000
<7>[    6.649479] pci 0000:80:11.1: [8086:3428] type 00 class 0x080000
<7>[    6.656281] pci 0000:80:13.0: [8086:342d] type 00 class 0x080020
<7>[    6.663002] pci 0000:80:13.0: reg 0x10: [mem 0xb4000000-0xb4000fff]
<7>[    6.670050] pci 0000:80:13.0: PME# supported from D0 D3hot D3cold
<7>[    6.676928] pci 0000:80:14.0: [8086:342e] type 00 class 0x080000
<7>[    6.683744] pci 0000:80:14.1: [8086:3422] type 00 class 0x080000
<7>[    6.690563] pci 0000:80:14.2: [8086:3423] type 00 class 0x080000
<7>[    6.697376] pci 0000:80:14.3: [8086:3438] type 00 class 0x080000
<7>[    6.704176] pci 0000:80:15.0: [8086:342f] type 00 class 0x080020
<7>[    6.710981] pci 0000:80:16.0: [8086:3430] type 00 class 0x088000
<7>[    6.717703] pci 0000:80:16.0: reg 0x10: [mem 0xfbf1c000-0xfbf1ffff 64bit]
<7>[    6.725407] pci 0000:80:16.1: [8086:3431] type 00 class 0x088000
<7>[    6.732129] pci 0000:80:16.1: reg 0x10: [mem 0xfbf18000-0xfbf1bfff 64bit]
<7>[    6.739828] pci 0000:80:16.2: [8086:3432] type 00 class 0x088000
<7>[    6.746550] pci 0000:80:16.2: reg 0x10: [mem 0xfbf14000-0xfbf17fff 64bit]
<7>[    6.754251] pci 0000:80:16.3: [8086:3433] type 00 class 0x088000
<7>[    6.760973] pci 0000:80:16.3: reg 0x10: [mem 0xfbf10000-0xfbf13fff 64bit]
<7>[    6.768671] pci 0000:80:16.4: [8086:3429] type 00 class 0x088000
<7>[    6.775392] pci 0000:80:16.4: reg 0x10: [mem 0xfbf0c000-0xfbf0ffff 64bit]
<7>[    6.783092] pci 0000:80:16.5: [8086:342a] type 00 class 0x088000
<7>[    6.789815] pci 0000:80:16.5: reg 0x10: [mem 0xfbf08000-0xfbf0bfff 64bit]
<7>[    6.797512] pci 0000:80:16.6: [8086:342b] type 00 class 0x088000
<7>[    6.804234] pci 0000:80:16.6: reg 0x10: [mem 0xfbf04000-0xfbf07fff 64bit]
<7>[    6.811936] pci 0000:80:16.7: [8086:342c] type 00 class 0x088000
<7>[    6.818658] pci 0000:80:16.7: reg 0x10: [mem 0xfbf00000-0xfbf03fff 64bit]
<6>[    6.826627] pci 0000:80:00.0: PCI bridge to [bus 81]
<6>[    6.832452] pci 0000:80:01.0: PCI bridge to [bus 82]
<6>[    6.838276] pci 0000:80:03.0: PCI bridge to [bus 83]
<6>[    6.844098] acpiphp: Slot [6] registered
<6>[    6.848507] pci 0000:80:07.0: PCI bridge to [bus 84-86]
<7>[    6.854346] pci 0000:80:07.0:   bridge window [io  0xb000-0xbfff]
<7>[    6.861154] pci 0000:80:07.0:   bridge window [mem 0xb3000000-0xb3ffffff]
<7>[    6.868740] pci 0000:80:07.0:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
<6>[    6.877657] acpiphp: Slot [7] registered
<6>[    6.882067] pci 0000:80:09.0: PCI bridge to [bus 87-89]
<7>[    6.887906] pci 0000:80:09.0:   bridge window [io  0xa000-0xafff]
<7>[    6.894715] pci 0000:80:09.0:   bridge window [mem 0xb2000000-0xb2ffffff]
<7>[    6.902304] pci 0000:80:09.0:   bridge window [mem 0xb1000000-0xb1ffffff 64bit pref]
<6>[    6.910979] acpi PNP0A08:01: Disabling ASPM (FADT indicates it is unsupported)
<6>[    6.919297] ACPI: PCI Root Bridge [PRB3] (domain 0000 [bus fc])
<6>[    6.925913] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    6.935051] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
<6>[    6.942477] PCI host bridge to bus 0000:fc
<6>[    6.947053] pci_bus 0000:fc: root bus resource [bus fc]
<7>[    6.952883] pci 0000:fc:00.0: [8086:2b00] type 00 class 0x060000
<7>[    6.959649] pci 0000:fc:00.2: [8086:2b02] type 00 class 0x060000
<7>[    6.966412] pci 0000:fc:00.4: [8086:2b22] type 00 class 0x060000
<7>[    6.973176] pci 0000:fc:00.6: [8086:2b2a] type 00 class 0x060000
<7>[    6.979940] pci 0000:fc:01.0: [8086:2b04] type 00 class 0x060000
<7>[    6.986704] pci 0000:fc:02.0: [8086:2b08] type 00 class 0x060000
<7>[    6.993469] pci 0000:fc:03.0: [8086:2b0c] type 00 class 0x060000
<7>[    7.000235] pci 0000:fc:04.0: [8086:2b10] type 00 class 0x060000
<7>[    7.007000] pci 0000:fc:05.0: [8086:2b14] type 00 class 0x060000
<7>[    7.013763] pci 0000:fc:05.2: [8086:2b16] type 00 class 0x060000
<7>[    7.020525] pci 0000:fc:05.4: [8086:2b13] type 00 class 0x060000
<7>[    7.027288] pci 0000:fc:05.6: [8086:2b53] type 00 class 0x060000
<7>[    7.034052] pci 0000:fc:06.0: [8086:2b18] type 00 class 0x060000
<7>[    7.040817] pci 0000:fc:07.0: [8086:2b1c] type 00 class 0x060000
<7>[    7.047577] pci 0000:fc:07.2: [8086:2b1e] type 00 class 0x060000
<7>[    7.054340] pci 0000:fc:07.4: [8086:2b1b] type 00 class 0x060000
<7>[    7.061092] pci 0000:fc:07.6: [8086:2b5b] type 00 class 0x060000
<7>[    7.067854] pci 0000:fc:08.0: [8086:2b20] type 00 class 0x060000
<7>[    7.074620] pci 0000:fc:09.0: [8086:2b24] type 00 class 0x060000
<7>[    7.081386] pci 0000:fc:0a.0: [8086:2b28] type 00 class 0x060000
<7>[    7.088151] pci 0000:fc:0b.0: [8086:2b2c] type 00 class 0x060000
<7>[    7.094919] pci 0000:fc:0c.0: [8086:2b30] type 00 class 0x060000
<7>[    7.101684] pci 0000:fc:0d.0: [8086:2b34] type 00 class 0x060000
<7>[    7.108454] pci 0000:fc:0e.0: [8086:2b38] type 00 class 0x060000
<7>[    7.115222] pci 0000:fc:0f.0: [8086:2b3c] type 00 class 0x060000
<7>[    7.121988] pci 0000:fc:10.0: [8086:2b40] type 00 class 0x060000
<7>[    7.128749] pci 0000:fc:10.2: [8086:2b42] type 00 class 0x060000
<7>[    7.135510] pci 0000:fc:10.4: [8086:2b32] type 00 class 0x060000
<7>[    7.142273] pci 0000:fc:10.6: [8086:2b3a] type 00 class 0x060000
<7>[    7.149036] pci 0000:fc:11.0: [8086:2b44] type 00 class 0x060000
<7>[    7.155799] pci 0000:fc:11.2: [8086:2b46] type 00 class 0x060000
<7>[    7.162562] pci 0000:fc:11.4: [8086:2b36] type 00 class 0x060000
<7>[    7.169325] pci 0000:fc:11.6: [8086:2b3e] type 00 class 0x060000
<7>[    7.176087] pci 0000:fc:12.0: [8086:2b48] type 00 class 0x060000
<7>[    7.182852] pci 0000:fc:13.0: [8086:2b4c] type 00 class 0x060000
<7>[    7.189621] pci 0000:fc:14.0: [8086:2b50] type 00 class 0x060000
<7>[    7.196384] pci 0000:fc:14.2: [8086:2b52] type 00 class 0x060000
<7>[    7.203152] pci 0000:fc:15.0: [8086:2b54] type 00 class 0x060000
<7>[    7.209916] pci 0000:fc:15.2: [8086:2b56] type 00 class 0x060000
<7>[    7.216682] pci 0000:fc:16.0: [8086:2b58] type 00 class 0x060000
<7>[    7.223447] pci 0000:fc:16.2: [8086:2b5a] type 00 class 0x060000
<7>[    7.230213] pci 0000:fc:17.0: [8086:2b5c] type 00 class 0x060000
<7>[    7.236976] pci 0000:fc:17.2: [8086:2b5e] type 00 class 0x060000
<7>[    7.243742] pci 0000:fc:18.0: [8086:2b60] type 00 class 0x060000
<7>[    7.250509] pci 0000:fc:18.2: [8086:2b62] type 00 class 0x060000
<7>[    7.257276] pci 0000:fc:19.0: [8086:2b64] type 00 class 0x060000
<7>[    7.264041] pci 0000:fc:19.2: [8086:2b66] type 00 class 0x060000
<7>[    7.270808] pci 0000:fc:1a.0: [8086:2b68] type 00 class 0x060000
<7>[    7.277574] pci 0000:fc:1b.0: [8086:2b6c] type 00 class 0x060000
<6>[    7.284415] ACPI: PCI Root Bridge [PRB2] (domain 0000 [bus fd])
<6>[    7.291031] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    7.300171] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
<6>[    7.307598] PCI host bridge to bus 0000:fd
<6>[    7.312174] pci_bus 0000:fd: root bus resource [bus fd]
<7>[    7.318006] pci 0000:fd:00.0: [8086:2b00] type 00 class 0x060000
<7>[    7.324772] pci 0000:fd:00.2: [8086:2b02] type 00 class 0x060000
<7>[    7.331533] pci 0000:fd:00.4: [8086:2b22] type 00 class 0x060000
<7>[    7.338297] pci 0000:fd:00.6: [8086:2b2a] type 00 class 0x060000
<7>[    7.345059] pci 0000:fd:01.0: [8086:2b04] type 00 class 0x060000
<7>[    7.351823] pci 0000:fd:02.0: [8086:2b08] type 00 class 0x060000
<7>[    7.358592] pci 0000:fd:03.0: [8086:2b0c] type 00 class 0x060000
<7>[    7.365360] pci 0000:fd:04.0: [8086:2b10] type 00 class 0x060000
<7>[    7.372125] pci 0000:fd:05.0: [8086:2b14] type 00 class 0x060000
<7>[    7.378887] pci 0000:fd:05.2: [8086:2b16] type 00 class 0x060000
<7>[    7.385647] pci 0000:fd:05.4: [8086:2b13] type 00 class 0x060000
<7>[    7.392409] pci 0000:fd:05.6: [8086:2b53] type 00 class 0x060000
<7>[    7.399173] pci 0000:fd:06.0: [8086:2b18] type 00 class 0x060000
<7>[    7.405937] pci 0000:fd:07.0: [8086:2b1c] type 00 class 0x060000
<7>[    7.412697] pci 0000:fd:07.2: [8086:2b1e] type 00 class 0x060000
<7>[    7.419459] pci 0000:fd:07.4: [8086:2b1b] type 00 class 0x060000
<7>[    7.426218] pci 0000:fd:07.6: [8086:2b5b] type 00 class 0x060000
<7>[    7.432984] pci 0000:fd:08.0: [8086:2b20] type 00 class 0x060000
<7>[    7.439750] pci 0000:fd:09.0: [8086:2b24] type 00 class 0x060000
<7>[    7.446517] pci 0000:fd:0a.0: [8086:2b28] type 00 class 0x060000
<7>[    7.453283] pci 0000:fd:0b.0: [8086:2b2c] type 00 class 0x060000
<7>[    7.460051] pci 0000:fd:0c.0: [8086:2b30] type 00 class 0x060000
<7>[    7.466816] pci 0000:fd:0d.0: [8086:2b34] type 00 class 0x060000
<7>[    7.473584] pci 0000:fd:0e.0: [8086:2b38] type 00 class 0x060000
<7>[    7.480350] pci 0000:fd:0f.0: [8086:2b3c] type 00 class 0x060000
<7>[    7.487117] pci 0000:fd:10.0: [8086:2b40] type 00 class 0x060000
<7>[    7.493881] pci 0000:fd:10.2: [8086:2b42] type 00 class 0x060000
<7>[    7.500648] pci 0000:fd:10.4: [8086:2b32] type 00 class 0x060000
<7>[    7.507410] pci 0000:fd:10.6: [8086:2b3a] type 00 class 0x060000
<7>[    7.514163] pci 0000:fd:11.0: [8086:2b44] type 00 class 0x060000
<7>[    7.520918] pci 0000:fd:11.2: [8086:2b46] type 00 class 0x060000
<7>[    7.527683] pci 0000:fd:11.4: [8086:2b36] type 00 class 0x060000
<7>[    7.534447] pci 0000:fd:11.6: [8086:2b3e] type 00 class 0x060000
<7>[    7.541210] pci 0000:fd:12.0: [8086:2b48] type 00 class 0x060000
<7>[    7.547976] pci 0000:fd:13.0: [8086:2b4c] type 00 class 0x060000
<7>[    7.554743] pci 0000:fd:14.0: [8086:2b50] type 00 class 0x060000
<7>[    7.561506] pci 0000:fd:14.2: [8086:2b52] type 00 class 0x060000
<7>[    7.568272] pci 0000:fd:15.0: [8086:2b54] type 00 class 0x060000
<7>[    7.575036] pci 0000:fd:15.2: [8086:2b56] type 00 class 0x060000
<7>[    7.581800] pci 0000:fd:16.0: [8086:2b58] type 00 class 0x060000
<7>[    7.588565] pci 0000:fd:16.2: [8086:2b5a] type 00 class 0x060000
<7>[    7.595331] pci 0000:fd:17.0: [8086:2b5c] type 00 class 0x060000
<7>[    7.602095] pci 0000:fd:17.2: [8086:2b5e] type 00 class 0x060000
<7>[    7.608860] pci 0000:fd:18.0: [8086:2b60] type 00 class 0x060000
<7>[    7.615624] pci 0000:fd:18.2: [8086:2b62] type 00 class 0x060000
<7>[    7.622389] pci 0000:fd:19.0: [8086:2b64] type 00 class 0x060000
<7>[    7.629154] pci 0000:fd:19.2: [8086:2b66] type 00 class 0x060000
<7>[    7.635921] pci 0000:fd:1a.0: [8086:2b68] type 00 class 0x060000
<7>[    7.642686] pci 0000:fd:1b.0: [8086:2b6c] type 00 class 0x060000
<6>[    7.649530] ACPI: PCI Root Bridge [PRB1] (domain 0000 [bus fe])
<6>[    7.656147] acpi PNP0A03:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    7.665285] acpi PNP0A03:02: _OSC failed (AE_NOT_FOUND); disabling ASPM
<6>[    7.672712] PCI host bridge to bus 0000:fe
<6>[    7.677290] pci_bus 0000:fe: root bus resource [bus fe]
<7>[    7.683129] pci 0000:fe:00.0: [8086:2b00] type 00 class 0x060000
<7>[    7.689892] pci 0000:fe:00.2: [8086:2b02] type 00 class 0x060000
<7>[    7.696655] pci 0000:fe:00.4: [8086:2b22] type 00 class 0x060000
<7>[    7.703420] pci 0000:fe:00.6: [8086:2b2a] type 00 class 0x060000
<7>[    7.710181] pci 0000:fe:01.0: [8086:2b04] type 00 class 0x060000
<7>[    7.716946] pci 0000:fe:02.0: [8086:2b08] type 00 class 0x060000
<7>[    7.723711] pci 0000:fe:03.0: [8086:2b0c] type 00 class 0x060000
<7>[    7.730477] pci 0000:fe:04.0: [8086:2b10] type 00 class 0x060000
<7>[    7.737245] pci 0000:fe:05.0: [8086:2b14] type 00 class 0x060000
<7>[    7.744010] pci 0000:fe:05.2: [8086:2b16] type 00 class 0x060000
<7>[    7.750775] pci 0000:fe:05.4: [8086:2b13] type 00 class 0x060000
<7>[    7.757538] pci 0000:fe:05.6: [8086:2b53] type 00 class 0x060000
<7>[    7.764291] pci 0000:fe:06.0: [8086:2b18] type 00 class 0x060000
<7>[    7.771046] pci 0000:fe:07.0: [8086:2b1c] type 00 class 0x060000
<7>[    7.777813] pci 0000:fe:07.2: [8086:2b1e] type 00 class 0x060000
<7>[    7.784574] pci 0000:fe:07.4: [8086:2b1b] type 00 class 0x060000
<7>[    7.791336] pci 0000:fe:07.6: [8086:2b5b] type 00 class 0x060000
<7>[    7.798088] pci 0000:fe:08.0: [8086:2b20] type 00 class 0x060000
<7>[    7.804857] pci 0000:fe:09.0: [8086:2b24] type 00 class 0x060000
<7>[    7.811623] pci 0000:fe:0a.0: [8086:2b28] type 00 class 0x060000
<7>[    7.818387] pci 0000:fe:0b.0: [8086:2b2c] type 00 class 0x060000
<7>[    7.825155] pci 0000:fe:0c.0: [8086:2b30] type 00 class 0x060000
<7>[    7.831918] pci 0000:fe:0d.0: [8086:2b34] type 00 class 0x060000
<7>[    7.838684] pci 0000:fe:0e.0: [8086:2b38] type 00 class 0x060000
<7>[    7.845450] pci 0000:fe:0f.0: [8086:2b3c] type 00 class 0x060000
<7>[    7.852214] pci 0000:fe:10.0: [8086:2b40] type 00 class 0x060000
<7>[    7.858978] pci 0000:fe:10.2: [8086:2b42] type 00 class 0x060000
<7>[    7.865741] pci 0000:fe:10.4: [8086:2b32] type 00 class 0x060000
<7>[    7.872504] pci 0000:fe:10.6: [8086:2b3a] type 00 class 0x060000
<7>[    7.879269] pci 0000:fe:11.0: [8086:2b44] type 00 class 0x060000
<7>[    7.886030] pci 0000:fe:11.2: [8086:2b46] type 00 class 0x060000
<7>[    7.892795] pci 0000:fe:11.4: [8086:2b36] type 00 class 0x060000
<7>[    7.899556] pci 0000:fe:11.6: [8086:2b3e] type 00 class 0x060000
<7>[    7.906316] pci 0000:fe:12.0: [8086:2b48] type 00 class 0x060000
<7>[    7.913083] pci 0000:fe:13.0: [8086:2b4c] type 00 class 0x060000
<7>[    7.919850] pci 0000:fe:14.0: [8086:2b50] type 00 class 0x060000
<7>[    7.926614] pci 0000:fe:14.2: [8086:2b52] type 00 class 0x060000
<7>[    7.933381] pci 0000:fe:15.0: [8086:2b54] type 00 class 0x060000
<7>[    7.940144] pci 0000:fe:15.2: [8086:2b56] type 00 class 0x060000
<7>[    7.946913] pci 0000:fe:16.0: [8086:2b58] type 00 class 0x060000
<7>[    7.953677] pci 0000:fe:16.2: [8086:2b5a] type 00 class 0x060000
<7>[    7.960443] pci 0000:fe:17.0: [8086:2b5c] type 00 class 0x060000
<7>[    7.967211] pci 0000:fe:17.2: [8086:2b5e] type 00 class 0x060000
<7>[    7.973977] pci 0000:fe:18.0: [8086:2b60] type 00 class 0x060000
<7>[    7.980740] pci 0000:fe:18.2: [8086:2b62] type 00 class 0x060000
<7>[    7.987502] pci 0000:fe:19.0: [8086:2b64] type 00 class 0x060000
<7>[    7.994257] pci 0000:fe:19.2: [8086:2b66] type 00 class 0x060000
<7>[    8.001020] pci 0000:fe:1a.0: [8086:2b68] type 00 class 0x060000
<7>[    8.007787] pci 0000:fe:1b.0: [8086:2b6c] type 00 class 0x060000
<6>[    8.014626] ACPI: PCI Root Bridge [PRB0] (domain 0000 [bus ff])
<6>[    8.021235] acpi PNP0A03:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    8.030375] acpi PNP0A03:03: _OSC failed (AE_NOT_FOUND); disabling ASPM
<6>[    8.037804] PCI host bridge to bus 0000:ff
<6>[    8.042381] pci_bus 0000:ff: root bus resource [bus ff]
<7>[    8.048220] pci 0000:ff:00.0: [8086:2b00] type 00 class 0x060000
<7>[    8.054984] pci 0000:ff:00.2: [8086:2b02] type 00 class 0x060000
<7>[    8.061746] pci 0000:ff:00.4: [8086:2b22] type 00 class 0x060000
<7>[    8.068497] pci 0000:ff:00.6: [8086:2b2a] type 00 class 0x060000
<7>[    8.075260] pci 0000:ff:01.0: [8086:2b04] type 00 class 0x060000
<7>[    8.082019] pci 0000:ff:02.0: [8086:2b08] type 00 class 0x060000
<7>[    8.088782] pci 0000:ff:03.0: [8086:2b0c] type 00 class 0x060000
<7>[    8.095543] pci 0000:ff:04.0: [8086:2b10] type 00 class 0x060000
<7>[    8.102306] pci 0000:ff:05.0: [8086:2b14] type 00 class 0x060000
<7>[    8.109065] pci 0000:ff:05.2: [8086:2b16] type 00 class 0x060000
<7>[    8.115824] pci 0000:ff:05.4: [8086:2b13] type 00 class 0x060000
<7>[    8.122582] pci 0000:ff:05.6: [8086:2b53] type 00 class 0x060000
<7>[    8.129347] pci 0000:ff:06.0: [8086:2b18] type 00 class 0x060000
<7>[    8.136107] pci 0000:ff:07.0: [8086:2b1c] type 00 class 0x060000
<7>[    8.142866] pci 0000:ff:07.2: [8086:2b1e] type 00 class 0x060000
<7>[    8.149630] pci 0000:ff:07.4: [8086:2b1b] type 00 class 0x060000
<7>[    8.156391] pci 0000:ff:07.6: [8086:2b5b] type 00 class 0x060000
<7>[    8.163149] pci 0000:ff:08.0: [8086:2b20] type 00 class 0x060000
<7>[    8.169910] pci 0000:ff:09.0: [8086:2b24] type 00 class 0x060000
<7>[    8.176674] pci 0000:ff:0a.0: [8086:2b28] type 00 class 0x060000
<7>[    8.183438] pci 0000:ff:0b.0: [8086:2b2c] type 00 class 0x060000
<7>[    8.190200] pci 0000:ff:0c.0: [8086:2b30] type 00 class 0x060000
<7>[    8.196964] pci 0000:ff:0d.0: [8086:2b34] type 00 class 0x060000
<7>[    8.203729] pci 0000:ff:0e.0: [8086:2b38] type 00 class 0x060000
<7>[    8.210492] pci 0000:ff:0f.0: [8086:2b3c] type 00 class 0x060000
<7>[    8.217254] pci 0000:ff:10.0: [8086:2b40] type 00 class 0x060000
<7>[    8.224005] pci 0000:ff:10.2: [8086:2b42] type 00 class 0x060000
<7>[    8.230766] pci 0000:ff:10.4: [8086:2b32] type 00 class 0x060000
<7>[    8.237526] pci 0000:ff:10.6: [8086:2b3a] type 00 class 0x060000
<7>[    8.244287] pci 0000:ff:11.0: [8086:2b44] type 00 class 0x060000
<7>[    8.251043] pci 0000:ff:11.2: [8086:2b46] type 00 class 0x060000
<7>[    8.257804] pci 0000:ff:11.4: [8086:2b36] type 00 class 0x060000
<7>[    8.264563] pci 0000:ff:11.6: [8086:2b3e] type 00 class 0x060000
<7>[    8.271323] pci 0000:ff:12.0: [8086:2b48] type 00 class 0x060000
<7>[    8.278089] pci 0000:ff:13.0: [8086:2b4c] type 00 class 0x060000
<7>[    8.284853] pci 0000:ff:14.0: [8086:2b50] type 00 class 0x060000
<7>[    8.291617] pci 0000:ff:14.2: [8086:2b52] type 00 class 0x060000
<7>[    8.298377] pci 0000:ff:15.0: [8086:2b54] type 00 class 0x060000
<7>[    8.305136] pci 0000:ff:15.2: [8086:2b56] type 00 class 0x060000
<7>[    8.311900] pci 0000:ff:16.0: [8086:2b58] type 00 class 0x060000
<7>[    8.318659] pci 0000:ff:16.2: [8086:2b5a] type 00 class 0x060000
<7>[    8.325421] pci 0000:ff:17.0: [8086:2b5c] type 00 class 0x060000
<7>[    8.332182] pci 0000:ff:17.2: [8086:2b5e] type 00 class 0x060000
<7>[    8.338944] pci 0000:ff:18.0: [8086:2b60] type 00 class 0x060000
<7>[    8.345696] pci 0000:ff:18.2: [8086:2b62] type 00 class 0x060000
<7>[    8.352459] pci 0000:ff:19.0: [8086:2b64] type 00 class 0x060000
<7>[    8.359211] pci 0000:ff:19.2: [8086:2b66] type 00 class 0x060000
<7>[    8.365973] pci 0000:ff:1a.0: [8086:2b68] type 00 class 0x060000
<7>[    8.372727] pci 0000:ff:1b.0: [8086:2b6c] type 00 class 0x060000
<3>[    8.400114] Section-unaligned hotplug range: start 0x1000000, size 0x7b000000
<4>[    8.490835] ACPI: Enabled 34 GPEs in block 00 to 3F
<6>[    8.496512] vgaarb: setting as boot device: PCI:0000:11:00.0
<6>[    8.502838] vgaarb: device added: PCI:0000:11:00.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    8.511949] vgaarb: loaded
<6>[    8.514972] vgaarb: bridge control possible 0000:11:00.0
<5>[    8.521095] SCSI subsystem initialized
<6>[    8.525320] ACPI: bus type USB registered
<6>[    8.529825] usbcore: registered new interface driver usbfs
<6>[    8.535961] usbcore: registered new interface driver hub
<6>[    8.542213] usbcore: registered new device driver usb
<6>[    8.547882] pps_core: LinuxPPS API ver. 1 registered
<6>[    8.553416] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>[    8.563626] PTP clock support registered
<6>[    8.568508] PCI: Using ACPI for IRQ routing
<7>[    8.577671] PCI: pci_cache_line_size set to 64 bytes
<7>[    8.583575] e820: reserve RAM buffer [mem 0x0009b400-0x0009ffff]
<7>[    8.590284] e820: reserve RAM buffer [mem 0x7b452000-0x7bffffff]
<6>[    8.597179] NetLabel: Initializing
<6>[    8.600977] NetLabel:  domain hash size = 128
<6>[    8.605842] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    8.611403] NetLabel:  unlabeled traffic allowed by default
<6>[    8.617783] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
<6>[    8.623572] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
<6>[    8.632452] Switched to clocksource hpet
<6>[    8.652098] pnp: PnP ACPI init
<7>[    8.655958] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>[    8.664816] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    8.679902] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
<6>[    8.687492] system 00:01: [io  0x0500-0x057f] could not be reserved
<6>[    8.694498] system 00:01: [io  0x0400-0x047f] could not be reserved
<6>[    8.701501] system 00:01: [io  0x0540-0x057f] has been reserved
<6>[    8.708116] system 00:01: [io  0x0600-0x061f] has been reserved
<6>[    8.714731] system 00:01: [io  0x0880-0x0883] has been reserved
<6>[    8.721345] system 00:01: [io  0x0ca4-0x0ca5] has been reserved
<6>[    8.727960] system 00:01: [io  0x0800-0x081f] has been reserved
<6>[    8.734576] system 00:01: [mem 0xfed1c000-0xfed3ffff] could not be reserved
<6>[    8.742356] system 00:01: [mem 0xfed45000-0xfed8bfff] has been reserved
<6>[    8.749749] system 00:01: [mem 0xff000000-0xffffffff] has been reserved
<6>[    8.757142] system 00:01: [mem 0xfee00000-0xfeefffff] has been reserved
<6>[    8.764534] system 00:01: [mem 0xfed12000-0xfed1200f] has been reserved
<6>[    8.771926] system 00:01: [mem 0xfed12010-0xfed1201f] has been reserved
<6>[    8.779318] system 00:01: [mem 0xfed1b000-0xfed1bfff] has been reserved
<7>[    8.786710] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    8.794502] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>[    8.803356] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    8.818471] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
<7>[    8.825942] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>[    8.834797] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    8.849915] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
<7>[    8.857269] pnp 00:04: Plug and Play ACPI device, IDs PNP0c31 (active)
<7>[    8.864631] pnp 00:05: Plug and Play ACPI device, IDs IPI0001 (active)
<6>[    8.873188] pnp: PnP ACPI: found 6 devices
<6>[    8.884645] pci 0000:07:00.0: can't claim BAR 6 [mem 0xfffc0000-0xffffffff pref]: no compatible bridge window
<6>[    8.895728] pci 0000:11:00.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]: no compatible bridge window
<6>[    8.906891] pci 0000:00:01.0: PCI bridge to [bus 01-03]
<6>[    8.912731] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
<6>[    8.919543] pci 0000:00:01.0:   bridge window [mem 0x95b00000-0x95bfffff]
<6>[    8.927132] pci 0000:00:02.0: PCI bridge to [bus 04-06]
<6>[    8.932973] pci 0000:00:02.0:   bridge window [io  0x4000-0x4fff]
<6>[    8.939784] pci 0000:00:02.0:   bridge window [mem 0x95a00000-0x95afffff]
<6>[    8.947379] pci 0000:07:00.0: BAR 6: assigned [mem 0x95980000-0x959bffff pref]
<6>[    8.955450] pci 0000:00:03.0: PCI bridge to [bus 07]
<6>[    8.961000] pci 0000:00:03.0:   bridge window [io  0x3000-0x3fff]
<6>[    8.967810] pci 0000:00:03.0:   bridge window [mem 0x95900000-0x959fffff]
<6>[    8.975396] pci 0000:00:03.0:   bridge window [mem 0x95d00000-0x95dfffff 64bit pref]
<6>[    8.984053] pci 0000:00:05.0: PCI bridge to [bus 08-0a]
<6>[    8.989891] pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
<6>[    8.996701] pci 0000:00:05.0:   bridge window [mem 0x94900000-0x958fffff]
<6>[    9.004287] pci 0000:00:05.0:   bridge window [mem 0x91900000-0x928fffff 64bit pref]
<6>[    9.012946] pci 0000:00:07.0: PCI bridge to [bus 0b-0d]
<6>[    9.018785] pci 0000:00:07.0:   bridge window [io  0x1000-0x1fff]
<6>[    9.025597] pci 0000:00:07.0:   bridge window [mem 0x93900000-0x948fffff]
<6>[    9.033184] pci 0000:00:07.0:   bridge window [mem 0x92900000-0x938fffff 64bit pref]
<6>[    9.041838] pci 0000:00:09.0: PCI bridge to [bus 0e]
<6>[    9.047393] pci 0000:00:0a.0: PCI bridge to [bus 0f]
<6>[    9.052939] pci 0000:00:1c.0: PCI bridge to [bus 10]
<6>[    9.058478] pci 0000:00:1c.0:   bridge window [io  0x7000-0x7fff]
<6>[    9.065288] pci 0000:00:1c.0:   bridge window [mem 0x95e00000-0x95ffffff]
<6>[    9.072875] pci 0000:00:1c.0:   bridge window [mem 0xfc000000000-0xfc0001fffff 64bit pref]
<6>[    9.082116] pci 0000:11:00.0: BAR 6: assigned [mem 0x91810000-0x9181ffff pref]
<6>[    9.090186] pci 0000:00:1c.4: PCI bridge to [bus 11]
<6>[    9.095735] pci 0000:00:1c.4:   bridge window [mem 0x91000000-0x918fffff]
<6>[    9.103322] pci 0000:00:1c.4:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
<6>[    9.111979] pci 0000:00:1e.0: PCI bridge to [bus 12]
<7>[    9.117536] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>[    9.123764] pci_bus 0000:00: resource 5 [io  0x1000-0x9fff]
<7>[    9.129990] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    9.136995] pci_bus 0000:00: resource 7 [mem 0xfed40000-0xfedfffff]
<7>[    9.143998] pci_bus 0000:00: resource 8 [mem 0x90000000-0xafffffff]
<7>[    9.151003] pci_bus 0000:00: resource 9 [mem 0xfc000000000-0xfc07fffffff]
<7>[    9.158588] pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
<7>[    9.164816] pci_bus 0000:01: resource 1 [mem 0x95b00000-0x95bfffff]
<7>[    9.171819] pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
<7>[    9.178045] pci_bus 0000:04: resource 1 [mem 0x95a00000-0x95afffff]
<7>[    9.185048] pci_bus 0000:07: resource 0 [io  0x3000-0x3fff]
<7>[    9.191274] pci_bus 0000:07: resource 1 [mem 0x95900000-0x959fffff]
<7>[    9.198276] pci_bus 0000:07: resource 2 [mem 0x95d00000-0x95dfffff 64bit pref]
<7>[    9.206347] pci_bus 0000:08: resource 0 [io  0x2000-0x2fff]
<7>[    9.212574] pci_bus 0000:08: resource 1 [mem 0x94900000-0x958fffff]
<7>[    9.219577] pci_bus 0000:08: resource 2 [mem 0x91900000-0x928fffff 64bit pref]
<7>[    9.227648] pci_bus 0000:0b: resource 0 [io  0x1000-0x1fff]
<7>[    9.233873] pci_bus 0000:0b: resource 1 [mem 0x93900000-0x948fffff]
<7>[    9.240876] pci_bus 0000:0b: resource 2 [mem 0x92900000-0x938fffff 64bit pref]
<7>[    9.248947] pci_bus 0000:10: resource 0 [io  0x7000-0x7fff]
<7>[    9.255172] pci_bus 0000:10: resource 1 [mem 0x95e00000-0x95ffffff]
<7>[    9.262177] pci_bus 0000:10: resource 2 [mem 0xfc000000000-0xfc0001fffff 64bit pref]
<7>[    9.270829] pci_bus 0000:11: resource 1 [mem 0x91000000-0x918fffff]
<7>[    9.277832] pci_bus 0000:11: resource 2 [mem 0x90000000-0x90ffffff 64bit pref]
<7>[    9.285903] pci_bus 0000:12: resource 4 [io  0x0000-0x0cf7]
<7>[    9.292129] pci_bus 0000:12: resource 5 [io  0x1000-0x9fff]
<7>[    9.298357] pci_bus 0000:12: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    9.305359] pci_bus 0000:12: resource 7 [mem 0xfed40000-0xfedfffff]
<7>[    9.312362] pci_bus 0000:12: resource 8 [mem 0x90000000-0xafffffff]
<7>[    9.319364] pci_bus 0000:12: resource 9 [mem 0xfc000000000-0xfc07fffffff]
<6>[    9.326987] pci 0000:80:00.0: PCI bridge to [bus 81]
<6>[    9.332542] pci 0000:80:01.0: PCI bridge to [bus 82]
<6>[    9.338095] pci 0000:80:03.0: PCI bridge to [bus 83]
<6>[    9.343648] pci 0000:80:07.0: PCI bridge to [bus 84-86]
<6>[    9.349487] pci 0000:80:07.0:   bridge window [io  0xb000-0xbfff]
<6>[    9.356297] pci 0000:80:07.0:   bridge window [mem 0xb3000000-0xb3ffffff]
<6>[    9.363884] pci 0000:80:07.0:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
<6>[    9.372540] pci 0000:80:09.0: PCI bridge to [bus 87-89]
<6>[    9.378378] pci 0000:80:09.0:   bridge window [io  0xa000-0xafff]
<6>[    9.385187] pci 0000:80:09.0:   bridge window [mem 0xb2000000-0xb2ffffff]
<6>[    9.392773] pci 0000:80:09.0:   bridge window [mem 0xb1000000-0xb1ffffff 64bit pref]
<7>[    9.401428] pci_bus 0000:80: resource 4 [io  0xa000-0xffff]
<7>[    9.407655] pci_bus 0000:80: resource 5 [mem 0xb0000000-0xfbffffff]
<7>[    9.414659] pci_bus 0000:80: resource 6 [mem 0xfc080000000-0xfc0ffffffff]
<7>[    9.422245] pci_bus 0000:84: resource 0 [io  0xb000-0xbfff]
<7>[    9.428470] pci_bus 0000:84: resource 1 [mem 0xb3000000-0xb3ffffff]
<7>[    9.435474] pci_bus 0000:84: resource 2 [mem 0xb0000000-0xb0ffffff 64bit pref]
<7>[    9.443545] pci_bus 0000:87: resource 0 [io  0xa000-0xafff]
<7>[    9.449771] pci_bus 0000:87: resource 1 [mem 0xb2000000-0xb2ffffff]
<7>[    9.456773] pci_bus 0000:87: resource 2 [mem 0xb1000000-0xb1ffffff 64bit pref]
<6>[    9.464949] NET: Registered protocol family 2
<6>[    9.470788] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
<6>[    9.480308] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
<6>[    9.488059] TCP: Hash tables configured (established 524288 bind 65536)
<6>[    9.495500] TCP: reno registered
<6>[    9.499301] UDP hash table entries: 65536 (order: 9, 2097152 bytes)
<6>[    9.506974] UDP-Lite hash table entries: 65536 (order: 9, 2097152 bytes)
<6>[    9.515301] NET: Registered protocol family 1
<6>[    9.520454] RPC: Registered named UNIX socket transport module.
<6>[    9.527075] RPC: Registered udp transport module.
<6>[    9.532331] RPC: Registered tcp transport module.
<6>[    9.537591] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    9.548169] IOAPIC[0]: Set routing entry (8-16 -> 0x71 -> IRQ 16 Mode:1 Active:1 Dest:1)
<7>[    9.557227] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:71 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    9.572599] IOAPIC[0]: Set routing entry (8-21 -> 0x81 -> IRQ 21 Mode:1 Active:1 Dest:1)
<7>[    9.581646] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:81 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    9.597001] IOAPIC[0]: Set routing entry (8-19 -> 0x91 -> IRQ 19 Mode:1 Active:1 Dest:1)
<7>[    9.606048] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:91 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    9.621396] IOAPIC[0]: Set routing entry (8-18 -> 0xa1 -> IRQ 18 Mode:1 Active:1 Dest:1)
<7>[    9.630444] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:A1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    9.645807] IOAPIC[0]: Set routing entry (8-23 -> 0xb1 -> IRQ 23 Mode:1 Active:1 Dest:1)
<7>[    9.654855] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    9.670218] IOAPIC[0]: Set routing entry (8-19 -> 0xc1 -> IRQ 19 Mode:1 Active:1 Dest:1)
<7>[    9.679268] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:C1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    9.694623] IOAPIC[0]: Set routing entry (8-18 -> 0xd1 -> IRQ 18 Mode:1 Active:1 Dest:1)
<7>[    9.703672] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:D1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    9.719042] IOAPIC[0]: Set routing entry (8-23 -> 0xe1 -> IRQ 23 Mode:1 Active:1 Dest:1)
<7>[    9.728089] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[    9.743316] PCI: CLS mismatch (64 != 32), using 64 bytes
<7>[    9.749264] pci 0000:11:00.0: Video device with shadowed ROM
<6>[    9.755913] Unpacking initramfs...
<6>[   12.467102] Freeing initrd memory: 124540K (ffff882076661000 - ffff88207e000000)
<6>[   12.475677] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
<6>[   12.482878] software IO TLB [mem 0x77452000-0x7b452000] (64MB) mapped at [ffff880077452000-ffff88007b451fff]
<6>[   12.505318] futex hash table entries: 32768 (order: 9, 2097152 bytes)
<5>[   12.513025] Initialise system trusted keyring
<6>[   12.517928] audit: initializing netlink subsys (disabled)
<5>[   12.523973] audit: type=2000 audit(1415236605.318:1): initialized
<6>[   12.531820] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>[   12.540704] zpool: loaded
<6>[   12.543626] zbud: loaded
<5>[   12.546725] VFS: Disk quotas dquot_6.5.2
<4>[   12.551213] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>[   12.559471] SGI XFS with ACLs, security attributes, no debug enabled
<6>[   12.568139] 9p: Installing v9fs 9p2000 file system support
<6>[   12.574326] msgmni has been set to 32768
<5>[   12.578823] Key type big_key registered
<7>[   12.583114] SELinux:  Registering netfilter hooks
<6>[   12.592125] NET: Registered protocol family 38
<5>[   12.597099] Key type asymmetric registered
<5>[   12.601678] Asymmetric key parser 'x509' registered
<6>[   12.607181] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>[   12.615665] io scheduler noop registered
<6>[   12.620052] io scheduler deadline registered (default)
<6>[   12.625802] io scheduler cfq registered
<7>[   12.630668] IOAPIC[1]: Set routing entry (9-4 -> 0x22 -> IRQ 24 Mode:1 Active:1 Dest:1)
<7>[   12.639621] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:22 Dest:00000001 SID:0098 SQ:0 SVT:1)
<7>[   12.654724] pcieport 0000:00:01.0: irq 25 for MSI/MSI-X
<7>[   12.660774] IOAPIC[1]: Set routing entry (9-5 -> 0x52 -> IRQ 26 Mode:1 Active:1 Dest:1)
<7>[   12.669725] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:52 Dest:00000001 SID:0098 SQ:0 SVT:1)
<7>[   12.684832] pcieport 0000:00:02.0: irq 27 for MSI/MSI-X
<7>[   12.690871] IOAPIC[1]: Set routing entry (9-0 -> 0x72 -> IRQ 28 Mode:1 Active:1 Dest:1)
<7>[   12.699819] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:72 Dest:00000001 SID:0098 SQ:0 SVT:1)
<7>[   12.714911] pcieport 0000:00:03.0: irq 29 for MSI/MSI-X
<7>[   12.720963] IOAPIC[1]: Set routing entry (9-2 -> 0x92 -> IRQ 30 Mode:1 Active:1 Dest:1)
<7>[   12.729914] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:92 Dest:00000001 SID:0098 SQ:0 SVT:1)
<7>[   12.744997] pcieport 0000:00:05.0: irq 31 for MSI/MSI-X
<7>[   12.751042] IOAPIC[1]: Set routing entry (9-6 -> 0xb2 -> IRQ 32 Mode:1 Active:1 Dest:1)
<7>[   12.759995] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B2 Dest:00000001 SID:0098 SQ:0 SVT:1)
<7>[   12.775086] pcieport 0000:00:07.0: irq 33 for MSI/MSI-X
<7>[   12.781138] IOAPIC[1]: Set routing entry (9-8 -> 0xd2 -> IRQ 34 Mode:1 Active:1 Dest:1)
<7>[   12.790082] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:D2 Dest:00000001 SID:0098 SQ:0 SVT:1)
<7>[   12.805173] pcieport 0000:00:09.0: irq 35 for MSI/MSI-X
<7>[   12.811216] IOAPIC[1]: Set routing entry (9-9 -> 0x23 -> IRQ 36 Mode:1 Active:1 Dest:1)
<7>[   12.820169] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:23 Dest:00000001 SID:0098 SQ:0 SVT:1)
<7>[   12.835259] pcieport 0000:00:0a.0: irq 37 for MSI/MSI-X
<7>[   12.841307] IOAPIC[0]: Set routing entry (8-16 -> 0x53 -> IRQ 16 Mode:1 Active:1 Dest:1)
<7>[   12.850356] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:53 Dest:00000001 SID:F0FF SQ:0 SVT:1)
<7>[   12.865447] pcieport 0000:00:1c.0: irq 38 for MSI/MSI-X
<7>[   12.871534] pcieport 0000:00:1c.4: irq 39 for MSI/MSI-X
<7>[   12.877613] IOAPIC[2]: Set routing entry (10-23 -> 0x83 -> IRQ 40 Mode:1 Active:1 Dest:1)
<7>[   12.886751] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:83 Dest:00000001 SID:8098 SQ:0 SVT:1)
<7>[   12.901842] pcieport 0000:80:00.0: irq 41 for MSI/MSI-X
<7>[   12.907871] IOAPIC[2]: Set routing entry (10-4 -> 0xa3 -> IRQ 42 Mode:1 Active:1 Dest:1)
<7>[   12.916921] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:A3 Dest:00000001 SID:8098 SQ:0 SVT:1)
<7>[   12.932015] pcieport 0000:80:01.0: irq 43 for MSI/MSI-X
<7>[   12.938037] IOAPIC[2]: Set routing entry (10-0 -> 0xc3 -> IRQ 44 Mode:1 Active:1 Dest:1)
<7>[   12.947084] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:C3 Dest:00000001 SID:8098 SQ:0 SVT:1)
<7>[   12.962173] pcieport 0000:80:03.0: irq 45 for MSI/MSI-X
<7>[   12.968192] IOAPIC[2]: Set routing entry (10-6 -> 0xe3 -> IRQ 46 Mode:1 Active:1 Dest:1)
<7>[   12.977240] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E3 Dest:00000001 SID:8098 SQ:0 SVT:1)
<7>[   12.992329] pcieport 0000:80:07.0: irq 47 for MSI/MSI-X
<7>[   12.998345] IOAPIC[2]: Set routing entry (10-8 -> 0x44 -> IRQ 48 Mode:1 Active:1 Dest:1)
<7>[   13.007392] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:44 Dest:00000001 SID:8098 SQ:0 SVT:1)
<7>[   13.022473] pcieport 0000:80:09.0: irq 49 for MSI/MSI-X
<6>[   13.028453] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
<6>[   13.036238] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
<6>[   13.043532] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
<7>[   13.050829] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
<6>[   13.058335] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
<6>[   13.066116] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
<6>[   13.073412] pci 0000:04:00.1: Signaling PME through PCIe PME interrupt
<7>[   13.080707] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
<6>[   13.088211] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
<6>[   13.095992] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
<7>[   13.103287] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
<6>[   13.110792] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
<7>[   13.118574] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
<6>[   13.126080] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
<7>[   13.133861] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
<6>[   13.141367] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
<7>[   13.149148] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
<6>[   13.156652] pcieport 0000:00:0a.0: Signaling PME through PCIe PME interrupt
<7>[   13.164435] pcie_pme 0000:00:0a.0:pcie01: service driver pcie_pme loaded
<6>[   13.171944] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
<7>[   13.179727] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
<6>[   13.187235] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
<6>[   13.195015] pci 0000:11:00.0: Signaling PME through PCIe PME interrupt
<7>[   13.202312] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
<6>[   13.209818] pcieport 0000:80:00.0: Signaling PME through PCIe PME interrupt
<7>[   13.217600] pcie_pme 0000:80:00.0:pcie01: service driver pcie_pme loaded
<6>[   13.225104] pcieport 0000:80:01.0: Signaling PME through PCIe PME interrupt
<7>[   13.232887] pcie_pme 0000:80:01.0:pcie01: service driver pcie_pme loaded
<6>[   13.240390] pcieport 0000:80:03.0: Signaling PME through PCIe PME interrupt
<7>[   13.248164] pcie_pme 0000:80:03.0:pcie01: service driver pcie_pme loaded
<6>[   13.255667] pcieport 0000:80:07.0: Signaling PME through PCIe PME interrupt
<7>[   13.263441] pcie_pme 0000:80:07.0:pcie01: service driver pcie_pme loaded
<6>[   13.270946] pcieport 0000:80:09.0: Signaling PME through PCIe PME interrupt
<7>[   13.278728] pcie_pme 0000:80:09.0:pcie01: service driver pcie_pme loaded
<6>[   13.286226] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>[   13.292472] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<7>[   13.299926] intel_idle: MWAIT substates: 0x1120
<7>[   13.304989] intel_idle: v0.4 model 0x2F
<7>[   13.309274] intel_idle: lapic_timer_reliable_states 0xffffffff
<6>[   13.319461] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
<6>[   13.328799] ACPI: Sleep Button [SLPB]
<6>[   13.332942] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
<6>[   13.341209] ACPI: Power Button [PWRF]
<6>[   13.415142] ERST: Error Record Serialization Table (ERST) support is initialized.
<6>[   13.423542] pstore: Registered erst as persistent store backend
<6>[   13.432059] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
<6>[   13.440750] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<6>[   13.468407] serial 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
<6>[   13.496479] tsc: Refined TSC clocksource calibration: 2393.999 MHz
<6>[   13.498258] serial 00:03: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
<6>[   13.500700] Non-volatile memory driver v1.3
<6>[   13.500727] Linux agpgart interface v0.103
<6>[   13.501671] tpm_tis 00:04: 1.2 TPM (device-id 0x0, rev-id 78)
<6>[   13.537532] tpm_tis 00:04: TPM is disabled/deactivated (0x6)
<4>[   13.544654] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000428-0x000000000000042f (\GPE0) (20140926/utaddress-258)
<6>[   13.562002] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[   13.573374] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x000000000000052c-0x000000000000052c (\GPIV) (20140926/utaddress-258)
<4>[   13.590695] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000052f (\_SI_.SIOR) (20140926/utaddress-258)
<6>[   13.608491] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[   13.619887] lpc_ich: Resource conflict(s) found affecting gpio_ich
<6>[   13.626952] rdac: device handler registered
<6>[   13.632029] hp_sw: device handler registered
<6>[   13.636815] emc: device handler registered
<6>[   13.641393] alua: device handler registered
<6>[   13.646113] libphy: Fixed MDIO Bus: probed
<6>[   13.650817] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>[   13.658695] e1000: Copyright (c) 1999-2006 Intel Corporation.
<6>[   13.665168] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>[   13.671688] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
<6>[   13.678373] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
<6>[   13.686252] igb: Copyright (c) 2007-2014 Intel Corporation.
<7>[   13.692826] igb 0000:01:00.0: irq 50 for MSI/MSI-X
<7>[   13.698201] igb 0000:01:00.0: irq 51 for MSI/MSI-X
<7>[   13.703568] igb 0000:01:00.0: irq 52 for MSI/MSI-X
<7>[   13.708935] igb 0000:01:00.0: irq 53 for MSI/MSI-X
<7>[   13.714303] igb 0000:01:00.0: irq 54 for MSI/MSI-X
<7>[   13.719672] igb 0000:01:00.0: irq 55 for MSI/MSI-X
<7>[   13.725043] igb 0000:01:00.0: irq 56 for MSI/MSI-X
<7>[   13.730411] igb 0000:01:00.0: irq 57 for MSI/MSI-X
<7>[   13.735778] igb 0000:01:00.0: irq 58 for MSI/MSI-X
<7>[   13.904406] igb 0000:01:00.0: irq 50 for MSI/MSI-X
<7>[   13.909775] igb 0000:01:00.0: irq 51 for MSI/MSI-X
<7>[   13.915142] igb 0000:01:00.0: irq 52 for MSI/MSI-X
<7>[   13.920509] igb 0000:01:00.0: irq 53 for MSI/MSI-X
<7>[   13.925877] igb 0000:01:00.0: irq 54 for MSI/MSI-X
<7>[   13.931242] igb 0000:01:00.0: irq 55 for MSI/MSI-X
<7>[   13.936608] igb 0000:01:00.0: irq 56 for MSI/MSI-X
<7>[   13.941975] igb 0000:01:00.0: irq 57 for MSI/MSI-X
<7>[   13.947343] igb 0000:01:00.0: irq 58 for MSI/MSI-X
<6>[   14.143015] igb 0000:01:00.0: added PHC on eth0
<6>[   14.148088] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
<6>[   14.155772] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x2) 60:eb:69:82:38:2a
<6>[   14.163746] igb 0000:01:00.0: eth0: PBA No: Unknown
<6>[   14.169196] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
<7>[   14.177732] IOAPIC[1]: Set routing entry (9-16 -> 0xe6 -> IRQ 59 Mode:1 Active:1 Dest:1)
<7>[   14.186781] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E6 Dest:00000001 SID:0098 SQ:0 SVT:1)
<7>[   14.202113] igb 0000:01:00.1: irq 60 for MSI/MSI-X
<7>[   14.207481] igb 0000:01:00.1: irq 61 for MSI/MSI-X
<7>[   14.212849] igb 0000:01:00.1: irq 62 for MSI/MSI-X
<7>[   14.218218] igb 0000:01:00.1: irq 63 for MSI/MSI-X
<7>[   14.223587] igb 0000:01:00.1: irq 64 for MSI/MSI-X
<7>[   14.228947] igb 0000:01:00.1: irq 65 for MSI/MSI-X
<7>[   14.234308] igb 0000:01:00.1: irq 66 for MSI/MSI-X
<7>[   14.239677] igb 0000:01:00.1: irq 67 for MSI/MSI-X
<7>[   14.245038] igb 0000:01:00.1: irq 68 for MSI/MSI-X
<7>[   14.406842] igb 0000:01:00.1: irq 60 for MSI/MSI-X
<7>[   14.412215] igb 0000:01:00.1: irq 61 for MSI/MSI-X
<7>[   14.417584] igb 0000:01:00.1: irq 62 for MSI/MSI-X
<7>[   14.422944] igb 0000:01:00.1: irq 63 for MSI/MSI-X
<7>[   14.428310] igb 0000:01:00.1: irq 64 for MSI/MSI-X
<7>[   14.433677] igb 0000:01:00.1: irq 65 for MSI/MSI-X
<7>[   14.439045] igb 0000:01:00.1: irq 66 for MSI/MSI-X
<7>[   14.444413] igb 0000:01:00.1: irq 67 for MSI/MSI-X
<7>[   14.449777] igb 0000:01:00.1: irq 68 for MSI/MSI-X
<6>[   14.529506] Switched to clocksource tsc
<6>[   14.636537] igb 0000:01:00.1: added PHC on eth1
<6>[   14.641610] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
<6>[   14.649291] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x2) 60:eb:69:82:38:2b
<6>[   14.657264] igb 0000:01:00.1: eth1: PBA No: Unknown
<6>[   14.662714] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
<7>[   14.671499] igb 0000:04:00.0: irq 69 for MSI/MSI-X
<7>[   14.676879] igb 0000:04:00.0: irq 70 for MSI/MSI-X
<7>[   14.682244] igb 0000:04:00.0: irq 71 for MSI/MSI-X
<7>[   14.687608] igb 0000:04:00.0: irq 74 for MSI/MSI-X
<7>[   14.692975] igb 0000:04:00.0: irq 75 for MSI/MSI-X
<7>[   14.698341] igb 0000:04:00.0: irq 76 for MSI/MSI-X
<7>[   14.703708] igb 0000:04:00.0: irq 77 for MSI/MSI-X
<7>[   14.709073] igb 0000:04:00.0: irq 78 for MSI/MSI-X
<7>[   14.714439] igb 0000:04:00.0: irq 79 for MSI/MSI-X
<7>[   14.876300] igb 0000:04:00.0: irq 69 for MSI/MSI-X
<7>[   14.881671] igb 0000:04:00.0: irq 70 for MSI/MSI-X
<7>[   14.887037] igb 0000:04:00.0: irq 71 for MSI/MSI-X
<7>[   14.892401] igb 0000:04:00.0: irq 74 for MSI/MSI-X
<7>[   14.897767] igb 0000:04:00.0: irq 75 for MSI/MSI-X
<7>[   14.903132] igb 0000:04:00.0: irq 76 for MSI/MSI-X
<7>[   14.908496] igb 0000:04:00.0: irq 77 for MSI/MSI-X
<7>[   14.913863] igb 0000:04:00.0: irq 78 for MSI/MSI-X
<7>[   14.919227] igb 0000:04:00.0: irq 79 for MSI/MSI-X
<6>[   15.106799] igb 0000:04:00.0: added PHC on eth2
<6>[   15.111870] igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network Connection
<6>[   15.119551] igb 0000:04:00.0: eth2: (PCIe:2.5Gb/s:Width x2) 60:eb:69:82:38:2c
<6>[   15.127525] igb 0000:04:00.0: eth2: PBA No: Unknown
<6>[   15.132972] igb 0000:04:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
<7>[   15.141492] IOAPIC[1]: Set routing entry (9-17 -> 0xe9 -> IRQ 80 Mode:1 Active:1 Dest:1)
<7>[   15.150538] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:E9 Dest:00000001 SID:0098 SQ:0 SVT:1)
<7>[   15.165862] igb 0000:04:00.1: irq 81 for MSI/MSI-X
<7>[   15.171231] igb 0000:04:00.1: irq 82 for MSI/MSI-X
<7>[   15.176597] igb 0000:04:00.1: irq 83 for MSI/MSI-X
<7>[   15.181962] igb 0000:04:00.1: irq 84 for MSI/MSI-X
<7>[   15.187328] igb 0000:04:00.1: irq 85 for MSI/MSI-X
<7>[   15.192694] igb 0000:04:00.1: irq 86 for MSI/MSI-X
<7>[   15.198073] igb 0000:04:00.1: irq 87 for MSI/MSI-X
<7>[   15.203437] igb 0000:04:00.1: irq 88 for MSI/MSI-X
<7>[   15.208802] igb 0000:04:00.1: irq 89 for MSI/MSI-X
<7>[   15.370420] igb 0000:04:00.1: irq 81 for MSI/MSI-X
<7>[   15.375789] igb 0000:04:00.1: irq 82 for MSI/MSI-X
<7>[   15.381154] igb 0000:04:00.1: irq 83 for MSI/MSI-X
<7>[   15.386519] igb 0000:04:00.1: irq 84 for MSI/MSI-X
<7>[   15.391883] igb 0000:04:00.1: irq 85 for MSI/MSI-X
<7>[   15.397247] igb 0000:04:00.1: irq 86 for MSI/MSI-X
<7>[   15.402610] igb 0000:04:00.1: irq 87 for MSI/MSI-X
<7>[   15.407973] igb 0000:04:00.1: irq 88 for MSI/MSI-X
<7>[   15.413335] igb 0000:04:00.1: irq 89 for MSI/MSI-X
<6>[   15.600133] igb 0000:04:00.1: added PHC on eth3
<6>[   15.605197] igb 0000:04:00.1: Intel(R) Gigabit Ethernet Network Connection
<6>[   15.612878] igb 0000:04:00.1: eth3: (PCIe:2.5Gb/s:Width x2) 60:eb:69:82:38:2d
<6>[   15.620850] igb 0000:04:00.1: eth3: PBA No: Unknown
<6>[   15.626298] igb 0000:04:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
<6>[   15.634795] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>[   15.643446] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
<6>[   15.650042] usbcore: registered new interface driver catc
<6>[   15.656085] usbcore: registered new interface driver kaweth
<6>[   15.662311] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<6>[   15.670580] usbcore: registered new interface driver pegasus
<6>[   15.676908] usbcore: registered new interface driver rtl8150
<6>[   15.683241] usbcore: registered new interface driver asix
<6>[   15.689278] usbcore: registered new interface driver cdc_ether
<6>[   15.695804] usbcore: registered new interface driver cdc_eem
<6>[   15.702133] usbcore: registered new interface driver dm9601
<6>[   15.708369] usbcore: registered new interface driver smsc75xx
<6>[   15.714798] usbcore: registered new interface driver smsc95xx
<6>[   15.721226] usbcore: registered new interface driver gl620a
<6>[   15.727462] usbcore: registered new interface driver net1080
<6>[   15.733793] usbcore: registered new interface driver plusb
<6>[   15.739926] usbcore: registered new interface driver rndis_host
<6>[   15.746546] usbcore: registered new interface driver cdc_subset
<6>[   15.753167] usbcore: registered new interface driver zaurus
<6>[   15.759402] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<6>[   15.767678] usbcore: registered new interface driver int51x1
<6>[   15.774007] usbcore: registered new interface driver ipheth
<6>[   15.780243] usbcore: registered new interface driver sierra_net
<6>[   15.787196] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[   15.794496] ehci-pci: EHCI PCI platform driver
<7>[   15.799636] IOAPIC[0]: Set routing entry (8-18 -> 0x9b -> IRQ 18 Mode:1 Active:1 Dest:1)
<7>[   15.808682] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:9B Dest:00000001 SID:F0FF SQ:0 SVT:1)
<6>[   15.823816] ehci-pci 0000:00:1a.7: EHCI Host Controller
<6>[   15.830003] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
<6>[   15.838294] ehci-pci 0000:00:1a.7: debug port 1
<7>[   15.847273] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
<6>[   15.854874] ehci-pci 0000:00:1a.7: irq 18, io mem 0x95c01000
<6>[   15.867030] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
<6>[   15.873591] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>[   15.881271] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   15.889434] usb usb1: Product: EHCI Host Controller
<6>[   15.894978] usb usb1: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce ehci_hcd
<6>[   15.903039] usb usb1: SerialNumber: 0000:00:1a.7
<6>[   15.908730] hub 1-0:1.0: USB hub found
<6>[   15.912955] hub 1-0:1.0: 6 ports detected
<7>[   15.917893] IOAPIC[0]: Set routing entry (8-23 -> 0xbb -> IRQ 23 Mode:1 Active:1 Dest:1)
<7>[   15.926939] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:BB Dest:00000001 SID:F0FF SQ:0 SVT:1)
<6>[   15.942045] ehci-pci 0000:00:1d.7: EHCI Host Controller
<6>[   15.948170] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
<6>[   15.956448] ehci-pci 0000:00:1d.7: debug port 1
<7>[   15.965409] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
<6>[   15.973007] ehci-pci 0000:00:1d.7: irq 23, io mem 0x95c00000
<6>[   15.985020] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
<6>[   15.991488] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
<6>[   15.999123] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   16.007192] usb usb2: Product: EHCI Host Controller
<6>[   16.012639] usb usb2: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce ehci_hcd
<6>[   16.020611] usb usb2: SerialNumber: 0000:00:1d.7
<6>[   16.026534] hub 2-0:1.0: USB hub found
<6>[   16.030754] hub 2-0:1.0: 6 ports detected
<6>[   16.035408] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[   16.042337] ohci-pci: OHCI PCI platform driver
<6>[   16.047330] uhci_hcd: USB Universal Host Controller Interface driver
<6>[   16.054602] uhci_hcd 0000:00:1a.0: UHCI Host Controller
<6>[   16.060719] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
<6>[   16.069001] uhci_hcd 0000:00:1a.0: detected 2 ports
<6>[   16.074480] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000060c0
<6>[   16.081052] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
<6>[   16.088638] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   16.096707] usb usb3: Product: UHCI Host Controller
<6>[   16.102154] usb usb3: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
<6>[   16.110124] usb usb3: SerialNumber: 0000:00:1a.0
<6>[   16.115713] hub 3-0:1.0: USB hub found
<6>[   16.119922] hub 3-0:1.0: 2 ports detected
<7>[   16.124674] IOAPIC[0]: Set routing entry (8-21 -> 0xeb -> IRQ 21 Mode:1 Active:1 Dest:1)
<7>[   16.133722] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:EB Dest:00000001 SID:F0FF SQ:0 SVT:1)
<6>[   16.148819] uhci_hcd 0000:00:1a.1: UHCI Host Controller
<6>[   16.154939] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
<6>[   16.163229] uhci_hcd 0000:00:1a.1: detected 2 ports
<6>[   16.168710] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000060a0
<6>[   16.175178] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
<6>[   16.182763] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   16.190831] usb usb4: Product: UHCI Host Controller
<6>[   16.196278] usb usb4: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
<6>[   16.204248] usb usb4: SerialNumber: 0000:00:1a.1
<6>[   16.209823] hub 4-0:1.0: USB hub found
<6>[   16.214031] hub 4-0:1.0: 2 ports detected
<7>[   16.218773] IOAPIC[0]: Set routing entry (8-19 -> 0x4c -> IRQ 19 Mode:1 Active:1 Dest:1)
<7>[   16.227872] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:4C Dest:00000001 SID:F0FF SQ:0 SVT:1)
<6>[   16.242932] uhci_hcd 0000:00:1a.2: UHCI Host Controller
<6>[   16.249030] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
<6>[   16.257307] uhci_hcd 0000:00:1a.2: detected 2 ports
<6>[   16.262786] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00006080
<6>[   16.269253] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
<6>[   16.276838] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   16.284906] usb usb5: Product: UHCI Host Controller
<6>[   16.290353] usb usb5: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
<6>[   16.298324] usb usb5: SerialNumber: 0000:00:1a.2
<6>[   16.304131] hub 5-0:1.0: USB hub found
<6>[   16.308435] hub 5-0:1.0: 2 ports detected
<6>[   16.313291] uhci_hcd 0000:00:1d.0: UHCI Host Controller
<6>[   16.319425] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
<6>[   16.327695] uhci_hcd 0000:00:1d.0: detected 2 ports
<6>[   16.333161] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00006060
<6>[   16.339620] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
<6>[   16.347204] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   16.355273] usb usb6: Product: UHCI Host Controller
<6>[   16.360720] usb usb6: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
<6>[   16.368690] usb usb6: SerialNumber: 0000:00:1d.0
<6>[   16.374299] hub 6-0:1.0: USB hub found
<6>[   16.378495] hub 6-0:1.0: 2 ports detected
<6>[   16.383244] uhci_hcd 0000:00:1d.1: UHCI Host Controller
<6>[   16.389373] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
<6>[   16.397653] uhci_hcd 0000:00:1d.1: detected 2 ports
<6>[   16.403119] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00006040
<6>[   16.409596] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
<6>[   16.417212] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   16.425374] usb usb7: Product: UHCI Host Controller
<6>[   16.430910] usb usb7: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
<6>[   16.438977] usb usb7: SerialNumber: 0000:00:1d.1
<6>[   16.444639] hub 7-0:1.0: USB hub found
<6>[   16.448861] hub 7-0:1.0: 2 ports detected
<6>[   16.453714] uhci_hcd 0000:00:1d.2: UHCI Host Controller
<6>[   16.459848] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
<6>[   16.468118] uhci_hcd 0000:00:1d.2: detected 2 ports
<6>[   16.473587] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006020
<6>[   16.480063] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
<6>[   16.487650] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   16.495721] usb usb8: Product: UHCI Host Controller
<6>[   16.501169] usb usb8: Manufacturer: Linux 3.18.0-rc3-wl-ath-g7c130ce uhci_hcd
<6>[   16.509142] usb usb8: SerialNumber: 0000:00:1d.2
<6>[   16.514731] hub 8-0:1.0: USB hub found
<6>[   16.518935] hub 8-0:1.0: 2 ports detected
<6>[   16.523583] usbcore: registered new interface driver usbserial
<6>[   16.530110] usbcore: registered new interface driver usbserial_generic
<6>[   16.537415] usbserial: USB Serial support registered for generic
<6>[   16.544153] i8042: PNP: No PS/2 controller found. Probing ports directly.
<6>[   16.546253] usb 4-1: new full-speed USB device number 2 using uhci_hcd
<6>[   16.688595] usb 4-1: New USB device found, idVendor=046b, idProduct=ff10
<6>[   16.696187] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
<6>[   16.704163] usb 4-1: Product: Virtual Keyboard and Mouse
<6>[   16.710097] usb 4-1: Manufacturer: American Megatrends Inc.
<6>[   16.716323] usb 4-1: SerialNumber: serial
<3>[   17.598236] i8042: No controller found
<6>[   17.602807] mousedev: PS/2 mouse device common for all mice
<6>[   17.610108] rtc_cmos 00:00: RTC can wake from S4
<6>[   17.615669] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
<6>[   17.622519] rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
<6>[   17.631191] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
<6>[   17.637428] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
<6>[   17.652581] iTCO_vendor_support: vendor-support=0
<6>[   17.659653] hidraw: raw HID events driver (C) Jiri Kosina
<6>[   17.670526] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.0/0003:046B:FF10.0001/input/input2
<6>[   17.737731] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.1-1/input0
<6>[   17.759541] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.1/0003:046B:FF10.0002/input/input3
<6>[   17.776116] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.1-1/input1
<6>[   17.792367] usbcore: registered new interface driver usbhid
<6>[   17.798590] usbhid: USB HID core driver
<6>[   17.802954] drop_monitor: Initializing network drop monitor service
<6>[   17.804149] usb 7-2: new full-speed USB device number 2 using uhci_hcd
<6>[   17.817467] TCP: cubic registered
<6>[   17.821176] Initializing XFRM netlink socket
<6>[   17.826178] NET: Registered protocol family 10
<6>[   17.832501] NET: Registered protocol family 17
<6>[   17.837489] 9pnet: Installing 9P2000 support
<7>[   17.845092] 
<7>[   17.845092] printing PIC contents
<7>[   17.850449] ... PIC  IMR: ffff
<7>[   17.853859] ... PIC  IRR: 0c20
<7>[   17.857279] ... PIC  ISR: 0000
<7>[   17.860782] ... PIC ELCR: 0e20
<7>[   17.864302] printing local APIC contents on CPU#0/0:
<6>[   17.869854] ... APIC ID:      00000000 (0)
<6>[   17.874426] ... APIC VERSION: 01060015
<7>[   17.878608] ... APIC TASKPRI: 00000000 (00)
<7>[   17.883277] ... APIC PROCPRI: 00000000
<7>[   17.887459] ... APIC LDR: 00000001
<7>[   17.891255] ... APIC SPIV: 000001ff
<7>[   17.895146] ... APIC ISR field:
<4>[   17.898651] 0000000000000000000000000000000000000000000000000000000000000000
<7>[   17.906601] ... APIC TMR field:
<4>[   17.910104] 0000000000000000000200000002000200020002000200020000000200000000
<7>[   17.918052] ... APIC IRR field:
<4>[   17.921556] 0000000000000000100000000000000000000000000000000000000000000000
<7>[   17.929508] ... APIC ESR: 00000000
<7>[   17.933301] ... APIC ICR: 000008fd
<7>[   17.937095] ... APIC ICR2: 00000020
<7>[   17.940988] ... APIC LVTT: 000000ef
<7>[   17.944880] ... APIC LVTPC: 00000400
<7>[   17.948868] ... APIC LVT0: 00010700
<7>[   17.952759] ... APIC LVT1: 00000400
<7>[   17.956652] ... APIC LVTERR: 000000fe
<7>[   17.960737] ... APIC TMICT: 01c51e06
<7>[   17.964725] ... APIC TMCCT: 01b5e397
<7>[   17.968713] ... APIC TDCR: 00000003
<4>[   17.972605] 
<7>[   17.974267] number of MP IRQ sources: 15.
<7>[   17.978841] number of IO-APIC #8 registers: 24.
<7>[   17.983991] number of IO-APIC #9 registers: 24.
<7>[   17.989144] number of IO-APIC #10 registers: 24.
<6>[   17.994394] testing the IO APIC.......................
<7>[   18.000230] IO APIC #8......
<6>[   18.002751] usb 7-2: New USB device found, idVendor=0557, idProduct=8021
<6>[   18.002753] usb 7-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>[   18.004782] hub 7-2:1.0: USB hub found
<6>[   18.005858] hub 7-2:1.0: 4 ports detected
<7>[   18.028030] .... register #00: 08000000
<7>[   18.032410] .......    : physical APIC id: 08
<7>[   18.037365] .......    : Delivery Type: 0
<7>[   18.041930] .......    : LTS          : 0
<7>[   18.046497] .... register #01: 00170020
<7>[   18.050876] .......     : max redirection entries: 17
<7>[   18.056610] .......     : PRQ implemented: 0
<7>[   18.061468] .......     : IO APIC version: 20
<7>[   18.066432] .... IRQ redirection table:
<4>[   18.070821] 0   1    0    0   0   0    0     0    00
<4>[   18.076458] 1   0    0    0   0   0    0     0    01
<4>[   18.082098] 1   0    0    0   0   0    0     0    02
<4>[   18.087738] 1   0    0    0   0   0    0     0    03
<4>[   18.093376] 1   0    0    0   0   0    0     0    04
<4>[   18.099021] 1   0    0    0   0   0    0     0    05
<4>[   18.104659] 1   0    0    0   0   0    0     0    06
<4>[   18.110305] 1   0    0    0   0   0    0     0    07
<4>[   18.115947] 1   0    0    0   0   0    0     0    08
<4>[   18.121587] 1   0    1    0   0   0    0     0    09
<4>[   18.127229] 1   0    0    0   0   0    0     0    0A
<4>[   18.132872] 1   0    0    0   0   0    0     0    0B
<4>[   18.138517] 1   0    0    0   0   0    0     0    0C
<4>[   18.144154] 1   0    0    0   0   0    0     0    0D
<4>[   18.149809] 1   0    0    0   0   0    0     0    0E
<4>[   18.155447] 1   0    0    0   0   0    0     0    0F
<4>[   18.161087] 1   0    1    0   1   0    0     0    10
<4>[   18.166730] 0   1    0    0   0   0    0     0    00
<4>[   18.172368] 1   0    1    0   1   0    0     0    12
<4>[   18.178005] 1   0    1    0   1   0    0     0    13
<4>[   18.183644] 0   1    0    0   0   0    0     0    00
<4>[   18.189284] 1   0    1    0   1   0    0     0    15
<4>[   18.194926] 0   1    0    0   0   0    0     0    00
<4>[   18.200563] 1   0    1    0   1   0    0     0    17
<7>[   18.206209] IO APIC #9......
<7>[   18.209524] .... register #00: 09000000
<7>[   18.213898] .......    : physical APIC id: 09
<7>[   18.218856] .......    : Delivery Type: 0
<7>[   18.223426] .......    : LTS          : 0
<7>[   18.228004] .... register #01: 00170020
<7>[   18.232386] .......     : max redirection entries: 17
<7>[   18.238117] .......     : PRQ implemented: 0
<7>[   18.242982] .......     : IO APIC version: 20
<7>[   18.247949] .... register #02: 00000000
<7>[   18.252329] .......     : arbitration: 00
<7>[   18.256891] .... register #03: 00000001
<7>[   18.261269] .......     : Boot DT    : 1
<7>[   18.265739] .... IRQ redirection table:
<4>[   18.270126] 1   1    1    0   1   0    0     0    00
<4>[   18.275763] 0   1    0    0   0   0    0     0    00
<4>[   18.281408] 1   1    1    0   1   0    0     0    02
<6>[   18.282036] usb 7-2.1: new low-speed USB device number 3 using uhci_hcd
<4>[   18.294527] 0   1    0    0   0   0    0     0    00
<4>[   18.300163] 1   1    1    0   1   0    0     0    04
<4>[   18.305809] 1   1    1    0   1   0    0     0    05
<4>[   18.311447] 1   1    1    0   1   0    0     0    06
<4>[   18.317087] 0   1    0    0   0   0    0     0    00
<4>[   18.322720] 1   1    1    0   1   0    0     0    08
<4>[   18.328350] 1   1    1    0   1   0    0     0    09
<4>[   18.333990] 0   1    0    0   0   0    0     0    00
<4>[   18.339628] 0   1    0    0   0   0    0     0    00
<4>[   18.345272] 0   1    0    0   0   0    0     0    00
<4>[   18.350909] 0   1    0    0   0   0    0     0    00
<4>[   18.356547] 0   1    0    0   0   0    0     0    00
<4>[   18.362182] 0   1    0    0   0   0    0     0    00
<4>[   18.367818] 1   1    1    0   1   0    0     0    10
<4>[   18.373456] 1   1    1    0   1   0    0     0    11
<4>[   18.379094] 0   1    0    0   0   0    0     0    00
<4>[   18.384740] 0   1    0    0   0   0    0     0    00
<4>[   18.390387] 0   1    0    0   0   0    0     0    00
<4>[   18.396022] 0   1    0    0   0   0    0     0    00
<4>[   18.401663] 0   1    0    0   0   0    0     0    00
<4>[   18.407308] 0   1    0    0   0   0    0     0    00
<7>[   18.412952] IO APIC #10......
<7>[   18.416356] .... register #00: 0A000000
<7>[   18.420732] .......    : physical APIC id: 0A
<7>[   18.425705] .......    : Delivery Type: 0
<7>[   18.430280] .......    : LTS          : 0
<7>[   18.434849] .... register #01: 00170020
<7>[   18.439226] .......     : max redirection entries: 17
<7>[   18.444963] .......     : PRQ implemented: 0
<7>[   18.449821] .......     : IO APIC version: 20
<7>[   18.454786] .... register #02: 00000000
<6>[   18.457147] usb 7-2.1: New USB device found, idVendor=0557, idProduct=2261
<6>[   18.457149] usb 7-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[   18.457150] usb 7-2.1: Product: CS1716A V1.0.098
<6>[   18.457152] usb 7-2.1: Manufacturer: ATEN International Co. Ltd
<7>[   18.487225] .......     : arbitration: 00
<6>[   18.487407] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2.1/7-2.1:1.0/0003:0557:2261.0003/input/input4
<7>[   18.507524] .... register #03: 00000001
<7>[   18.511896] .......     : Boot DT    : 1
<7>[   18.516363] .... IRQ redirection table:
<4>[   18.520745] 1   1    1    0   1   0    0     0    00
<4>[   18.526383] 0   1    0    0   0   0    0     0    00
<4>[   18.532025] 0   1    0    0   0   0    0     0    00
<4>[   18.537660] 0   1    0    0   0   0    0     0    00
<6>[   18.537981] hid-generic 0003:0557:2261.0003: input,hidraw2: USB HID v1.00 Keyboard [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.1-2.1/input0
<4>[   18.559310] 1   1    1    0   1   0    0     0    04
<4>[   18.564956] 0   1    0    0   0   0    0     0    00
<4>[   18.570591] 1   1    1    0   1   0    0     0    06
<6>[   18.573204] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2.1/7-2.1:1.1/0003:0557:2261.0004/input/input5
<4>[   18.591965] 0   1    0    0   0   0    0     0    00
<4>[   18.597607] 1   1    1    0   1   0    0     0    08
<4>[   18.603247] 0   1    0    0   0   0    0     0    00
<4>[   18.608890] 0   1    0    0   0   0    0     0    00
<4>[   18.614527] 0   1    0    0   0   0    0     0    00
<4>[   18.620162] 0   1    0    0   0   0    0     0    00
<6>[   18.624042] hid-generic 0003:0557:2261.0004: input,hidraw3: USB HID v1.00 Device [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.1-2.1/input1
<4>[   18.641622] 0   1    0    0   0   0    0     0    00
<6>[   18.645323] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2.1/7-2.1:1.2/0003:0557:2261.0005/input/input6
<6>[   18.646012] hid-generic 0003:0557:2261.0005: input,hidraw4: USB HID v1.10 Mouse [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.1-2.1/input2
<4>[   18.678716] 0   1    0    0   0   0    0     0    00
<4>[   18.684361] 0   1    0    0   0   0    0     0    00
<4>[   18.690006] 0   1    0    0   0   0    0     0    00
<4>[   18.695650] 0   1    0    0   0   0    0     0    00
<4>[   18.701295] 0   1    0    0   0   0    0     0    00
<4>[   18.706934] 0   1    0    0   0   0    0     0    00
<4>[   18.712584] 0   1    0    0   0   0    0     0    00
<4>[   18.718231] 0   1    0    0   0   0    0     0    00
<4>[   18.723874] 0   1    0    0   0   0    0     0    00
<4>[   18.729513] 1   1    1    0   1   0    0     0    17
<7>[   18.735148] IRQ to pin mappings:
<7>[   18.738845] IRQ0 -> 0:2
<7>[   18.741691] IRQ1 -> 0:1
<7>[   18.744536] IRQ3 -> 0:3
<7>[   18.747387] IRQ4 -> 0:4
<7>[   18.750232] IRQ5 -> 0:5
<7>[   18.753176] IRQ6 -> 0:6
<7>[   18.756021] IRQ7 -> 0:7
<7>[   18.758864] IRQ8 -> 0:8
<7>[   18.761808] IRQ9 -> 0:9
<7>[   18.764655] IRQ10 -> 0:10
<7>[   18.767694] IRQ11 -> 0:11
<7>[   18.770835] IRQ12 -> 0:12
<7>[   18.773879] IRQ13 -> 0:13
<7>[   18.776922] IRQ14 -> 0:14
<7>[   18.780054] IRQ15 -> 0:15
<7>[   18.783099] IRQ16 -> 0:16
<7>[   18.786141] IRQ18 -> 0:18
<7>[   18.789278] IRQ19 -> 0:19
<7>[   18.792324] IRQ21 -> 0:21
<7>[   18.795360] IRQ23 -> 0:23
<7>[   18.798497] IRQ24 -> 1:4
<7>[   18.801441] IRQ26 -> 1:5
<7>[   18.804479] IRQ28 -> 1:0
<7>[   18.807427] IRQ30 -> 1:2
<7>[   18.810384] IRQ32 -> 1:6
<7>[   18.813337] IRQ34 -> 1:8
<7>[   18.816366] IRQ36 -> 1:9
<7>[   18.819315] IRQ40 -> 2:23
<7>[   18.822351] IRQ42 -> 2:4
<7>[   18.825396] IRQ44 -> 2:0
<7>[   18.828434] IRQ46 -> 2:6
<7>[   18.831378] IRQ48 -> 2:8
<7>[   18.834422] IRQ59 -> 1:16
<7>[   18.837469] IRQ80 -> 1:17
<6>[   18.840506] .................................... done.
<5>[   18.847721] Loading compiled-in X.509 certificates
<5>[   18.854511] Loaded X.509 cert 'Magrathea: Glacier signing key: 81618a42096c2ef391193fe6d34296fd923f6030'
<6>[   18.865132] registered taskstats version 1
<5>[   18.875063] Key type trusted registered
<5>[   18.883531] Key type encrypted registered
<3>[   18.897840] tpm_tis 00:04: A TPM error (6) occurred attempting to read a pcr value
<6>[   18.906307] ima: No TPM chip found, activating TPM-bypass!
<6>[   18.912488] evm: HMAC attrs: 0x1
<6>[   18.919710] rtc_cmos 00:00: setting system clock to 2014-11-06 01:17:01 UTC (1415236621)
<6>[   19.171894] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>[   19.419034] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>[   19.666191] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
<6>[   19.913383] IPv6: ADDRCONF(NETDEV_UP): eth3: link is not ready
<6>[   22.019299] igb 0000:01:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
<6>[   22.030859] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>[   22.041854] Sending DHCP requests .., OK
<4>[   26.550848] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.192
<6>[   27.066481] IP-Config: Complete:
<6>[   27.070185]      device=eth0, hwaddr=60:eb:69:82:38:2a, ipaddr=192.168.1.192, mask=255.255.255.0, gw=192.168.1.1
<6>[   27.081648]      host=lkp-wsx02, domain=lkp.intel.com, nis-domain=(none)
<6>[   27.089228]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>[   27.096807]      nameserver0=192.168.1.1
<7>[   27.101515] PM: Hibernation image not present or could not be loaded.
<6>[   27.113342] Freeing unused kernel memory: 1844K (ffffffff81e1f000 - ffffffff81fec000)
<6>[   27.535705] ipmi message handler version 39.2
<6>[   27.553101] IPMI System Interface driver.
<6>[   27.557678] ipmi_si: probing via ACPI
<6>[   27.561821] ipmi_si 00:05: [io  0x0ca2] regsize 1 spacing 1 irq 0
<6>[   27.568635] ipmi_si: Adding ACPI-specified kcs state machine
<6>[   27.575092] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
<6>[   27.600758] megasas: 06.805.06.00-rc1 Thu. Sep. 4 17:00:00 PDT 2014
<6>[   27.607865] megasas: 0x1000:0x0079:0x8086:0x9256: bus 7:slot 0:func 0
<6>[   27.616381] megasas: Waiting for FW to come to ready state
<6>[   27.622624] EDAC MC: Ver: 3.0.0
<6>[   27.624129] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
<6>[   27.636253] megasas: FW now in Ready state
<7>[   27.640910] megaraid_sas 0000:07:00.0: irq 90 for MSI/MSI-X
<6>[   27.647168] megaraid_sas 0000:07:00.0: [scsi0]: FW supports<0> MSIX vector,Online CPUs: <80>,Current MSIX <1>
<6>[   27.675846] [drm] Initialized drm 1.1.0 20060810
<7>[   27.676666] libata version 3.00 loaded.
<7>[   27.711438] ata_piix 0000:00:1f.2: version 2.13
<6>[   27.716722] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
<6>[   27.724033] scsi host1: ata_piix
<6>[   27.728554] scsi host2: ata_piix
<6>[   27.732226] ata1: SATA max UDMA/133 cmd 0x6138 ctl 0x614c bmdma 0x6110 irq 19
<6>[   27.740208] ata2: SATA max UDMA/133 cmd 0x6130 ctl 0x6148 bmdma 0x6118 irq 19
<5>[   27.743358] megasas_init_mfi: fw_support_ieee=0
<3>[   27.743358] megasas: INIT adapter done
<6>[   27.757855] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
<6>[   27.785272] megaraid_sas 0000:07:00.0: Controller type: MR,Memory size is: 512MB
<6>[   27.793627] scsi host0: LSI SAS based MegaRAID driver
<5>[   27.823071] scsi 0:2:0:0: Direct-Access     INTEL    RS2BL080DE       2.70 PQ: 0 ANSI: 5
<5>[   27.836241] scsi 0:2:2:0: Direct-Access     INTEL    RS2BL080DE       2.70 PQ: 0 ANSI: 5
<6>[   27.851081] [TTM] Zone  kernel: Available graphics memory: 65973992 kiB
<6>[   27.858484] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
<6>[   27.865777] [TTM] Initializing pool allocator
<6>[   27.870645] [TTM] Initializing DMA pool allocator
<6>[   27.907361] input: PC Speaker as /devices/platform/pcspkr/input/input7
<6>[   27.916142] scsi host3: ata_piix
<6>[   27.920498] scsi host4: ata_piix
<6>[   27.924187] ata3: SATA max UDMA/133 cmd 0x6128 ctl 0x6144 bmdma 0x60f0 irq 21
<6>[   27.932169] ata4: SATA max UDMA/133 cmd 0x6120 ctl 0x6140 bmdma 0x60f8 irq 21
<6>[   27.940281] fbcon: mgadrmfb (fb0) is primary device
<3>[   28.020447] Error: Driver 'pcspkr' is already registered, aborting...
<6>[   28.151617] Console: switching to colour frame buffer device 128x48
<6>[   28.215239] mgag200 0000:11:00.0: fb0: mgadrmfb frame buffer device
<6>[   28.222332] mgag200 0000:11:00.0: registered panic notifier
<6>[   28.234984] [drm] Initialized mgag200 1.0.0 20110418 for 0000:11:00.0 on minor 0
<6>[   28.257621] ata3: SATA link down (SStatus 4 SControl 300)
<6>[   28.379727] ata2.00: SATA link down (SStatus 0 SControl 300)
<6>[   28.386169] ata2.01: SATA link down (SStatus 0 SControl 300)
<6>[   28.403692] ata1.00: SATA link down (SStatus 0 SControl 300)
<6>[   28.410135] ata1.01: SATA link down (SStatus 0 SControl 300)
<6>[   28.414804] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<6>[   28.417991] ata4.00: ATAPI: HL-DT-STDVDRAM GT32N, AS00, max UDMA/100
<6>[   28.423988] ata4.00: configured for UDMA/100
<5>[   28.438728] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT32N     AS00 PQ: 0 ANSI: 5
<5>[   28.491549] sd 0:2:0:0: [sda] 583983104 512-byte logical blocks: (298 GB/278 GiB)
<5>[   28.491879] sd 0:2:2:0: [sdb] 57376768 512-byte logical blocks: (29.3 GB/27.3 GiB)
<5>[   28.492189] sd 0:2:2:0: [sdb] Write Protect is off
<7>[   28.492194] sd 0:2:2:0: [sdb] Mode Sense: 1f 00 10 08
<5>[   28.514114] sd 0:2:2:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
<5>[   28.529690] sd 0:2:0:0: [sda] Write Protect is off
<7>[   28.535130] sd 0:2:0:0: [sda] Mode Sense: 1f 00 10 08
<6>[   28.536044]  sdb: sdb1 sdb9
<5>[   28.544226] sd 0:2:2:0: [sdb] Attached SCSI disk
<5>[   28.544247] sd 0:2:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
<6>[   28.562677] sr 4:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
<6>[   28.570009]  sda: sda1
<6>[   28.570009]  sda1: <solaris: [s0] sda5 [s2] sda6 [s8] sda7 >
<5>[   28.572259] sd 0:2:0:0: [sda] Attached SCSI disk
<6>[   28.593260] cdrom: Uniform CD-ROM driver Revision: 3.20
<7>[   28.601268] sr 4:0:0:0: Attached scsi CD-ROM sr0
<5>[   28.617619] sd 0:2:0:0: Attached scsi generic sg0 type 0
<5>[   28.625043] sd 0:2:2:0: Attached scsi generic sg1 type 0
<5>[   28.632272] sr 4:0:0:0: Attached scsi generic sg2 type 5
<5>[   28.884258] random: nonblocking pool is initialized
<6>[   82.825219] ipmi_si: There appears to be no BMC at this location
<6>[   91.852688] IPMI Watchdog: driver initialized

--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.18.0-rc3-wl-ath-g7c130ce"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.18.0-rc3 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
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
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
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
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
# CONFIG_NO_HZ_FULL_SYSIDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TASKS_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=19
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_BPF_SYSCALL is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
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
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
# CONFIG_MODULE_COMPRESS is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_IOSF_MBI is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
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
CONFIG_MOVABLE_NODE=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_EFI_MIXED is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
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
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
# CONFIG_NET_FOU is not set
# CONFIG_GENEVE is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_TCP_CONG_DCTCP is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_QUEUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
# CONFIG_NF_TABLES_INET is not set
CONFIG_NFT_EXTHDR=m
CONFIG_NFT_META=m
CONFIG_NFT_CT=m
CONFIG_NFT_RBTREE=m
CONFIG_NFT_HASH=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
# CONFIG_NFT_MASQ is not set
CONFIG_NFT_NAT=m
# CONFIG_NFT_QUEUE is not set
# CONFIG_NFT_REJECT is not set
CONFIG_NFT_COMPAT=m
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
# CONFIG_NETFILTER_XT_NAT is not set
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
# CONFIG_IP_SET_HASH_IPMARK is not set
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
# CONFIG_IP_SET_HASH_MAC is not set
# CONFIG_IP_SET_HASH_NETPORTNET is not set
CONFIG_IP_SET_HASH_NET=m
# CONFIG_IP_SET_HASH_NETNET is not set
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
# CONFIG_IP_VS_FO is not set
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_NF_LOG_ARP is not set
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_TABLES_IPV4=m
CONFIG_NFT_CHAIN_ROUTE_IPV4=m
CONFIG_NF_REJECT_IPV4=m
# CONFIG_NFT_REJECT_IPV4 is not set
# CONFIG_NF_TABLES_ARP is not set
CONFIG_NF_NAT_IPV4=m
CONFIG_NFT_CHAIN_NAT_IPV4=m
# CONFIG_NF_NAT_MASQUERADE_IPV4 is not set
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
# CONFIG_IP_NF_NAT is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_NF_TABLES_IPV6=m
CONFIG_NFT_CHAIN_ROUTE_IPV6=m
CONFIG_NF_REJECT_IPV6=m
# CONFIG_NFT_REJECT_IPV6 is not set
CONFIG_NF_LOG_IPV6=m
CONFIG_NF_NAT_IPV6=m
CONFIG_NFT_CHAIN_NAT_IPV6=m
# CONFIG_NF_NAT_MASQUERADE_IPV6 is not set
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
# CONFIG_IP6_NF_NAT is not set
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
# CONFIG_NF_LOG_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=m
CONFIG_NET_SCTPPROBE=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
CONFIG_IEEE802154=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
# CONFIG_NET_SCH_FQ is not set
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_CLS_BPF is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_VSOCKETS=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=m
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_DEVTMPFS_SAFE is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
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
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_NVME=m
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_OSD=m
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=m
# CONFIG_XEN_BLKDEV_BACKEND is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=m

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_BMP085_I2C is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=m

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_CXL_BASE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_MQ_DEFAULT is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=m
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=m
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_UFSHCD_PCI=m
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=m
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_STEX=m
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=m
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
CONFIG_SCSI_CHELSIO_FCOE=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=m
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_TOSHIBA=m
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_MQ=m
CONFIG_DM_CACHE_CLEANER=m
# CONFIG_DM_ERA is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
CONFIG_DM_SWITCH=m
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
# CONFIG_TCM_USER is not set
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
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
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_VXLAN=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_NTB_NETDEV=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_VIRTIO_NET=y
CONFIG_NLMON=m
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_NET_DSA_MV88E6171 is not set
# CONFIG_NET_DSA_MV88E6352 is not set
# CONFIG_NET_DSA_BCM_SF2 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_XGENE is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=m
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4_DCB is not set
CONFIG_CHELSIO_T4VF=m
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
# CONFIG_CX_ECAT is not set
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_VXLAN=y
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=m
CONFIG_IXGB=m
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_I40E=m
# CONFIG_I40E_VXLAN is not set
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_FM10K is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_IP1000=m
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=m
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=m
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_EN_VXLAN=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
# CONFIG_MLX5_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=m
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLCNIC_DCB=y
# CONFIG_QLCNIC_VXLAN is not set
CONFIG_QLCNIC_HWMON=y
CONFIG_QLGE=m
CONFIG_NETXEN_NIC=m
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=m
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=m
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=m
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=m
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=m
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=m
CONFIG_WLAN=y
# CONFIG_PRISM54 is not set
# CONFIG_HOSTAP is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKELB=m
CONFIG_XEN_NETDEV_FRONTEND=m
# CONFIG_XEN_NETDEV_BACKEND is not set
CONFIG_VMXNET3=m
CONFIG_HYPERV_NET=m
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_ISDN_CAPI=m
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPIDRV=m
# CONFIG_ISDN_CAPI_CAPIDRV_VERBOSE is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_I4L is not set
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
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
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_SERIAL_WACOM4 is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_FINTEK is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=m
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_TPS40422 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INT340X_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_MFD_JANZ_CMODIO is not set
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
# CONFIG_MFD_MENF21BMC is not set
CONFIG_MFD_VIPERBOARD=m
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RTSX_PCI=m
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_RN5T618 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
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
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
CONFIG_VIDEOBUF2_DVB=m
CONFIG_DVB_CORE=m
CONFIG_DVB_NET=y
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_XMP_DECODER=m
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
CONFIG_IR_ENE=m
# CONFIG_IR_HIX5HD2 is not set
CONFIG_IR_IMON=m
CONFIG_IR_MCEUSB=m
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
CONFIG_IR_IGUANA=m
CONFIG_IR_TTUSBIR=m
# CONFIG_IR_IMG is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_GPIO_CIR=m
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_VIDEO_CPIA2 is not set
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
# CONFIG_VIDEO_USBTV is not set

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_TLG2300=m
CONFIG_VIDEO_USBVISION=m
# CONFIG_VIDEO_STK1160_COMMON is not set
# CONFIG_VIDEO_GO7007 is not set

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_AU0828_V4L2=y
# CONFIG_VIDEO_AU0828_RC is not set
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_FRIIO=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_AF9035=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_AZ6007=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_USB_RTL28XXU=m
# CONFIG_DVB_USB_DVBSKY is not set
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_USB_DRV=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set
# CONFIG_DVB_AS102 is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_V4L2 is not set
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_EM28XX_RC=m
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_VIDEO_MEYE is not set

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=m
# CONFIG_VIDEO_IVTV_ALSA is not set
CONFIG_VIDEO_FB_IVTV=m
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_SOLO6X10 is not set
# CONFIG_VIDEO_TW68 is not set

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_ENABLE_VP3054=y
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_BT848=m
CONFIG_DVB_BT8XX=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_SAA7164=m

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110_IR=y
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=m
CONFIG_DVB_DM1105=m
CONFIG_DVB_PT1=m
# CONFIG_DVB_PT3 is not set
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m
# CONFIG_DVB_SMIPCIE is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_SMS_SIANO_MDTV=m
CONFIG_SMS_SIANO_RC=y
# CONFIG_SMS_SIANO_DEBUGFS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=m
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
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m

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
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_SI2168=m
# CONFIG_DVB_AS102_FE is not set

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
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#

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
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y

#
# Direct Rendering Manager
#
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
# CONFIG_DRM_PTN3460 is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
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
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_ES1968_RADIO=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_PREALLOC_SIZE=512
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
# CONFIG_SND_USB_HIFACE is not set
# CONFIG_SND_BCD2000 is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
# CONFIG_SND_DICE is not set
CONFIG_SND_FIREWIRE_SPEAKERS=m
CONFIG_SND_ISIGHT=m
CONFIG_SND_SCS1X=m
# CONFIG_SND_FIREWORKS is not set
# CONFIG_SND_BEBOB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_GT683R is not set
# CONFIG_HID_HUION is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_FSM is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PCI=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=m
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_LINK_LAYER_TEST is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set
# CONFIG_USB_LED_TRIG is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_REALTEK_PCI=m
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_PCI=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_DELL_NETBOOKS=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
# CONFIG_EDAC_IE31200 is not set
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=m
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=m
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF85063 is not set
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_XGENE is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=m
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_PCI is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO=m
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_SELFBALLOONING is not set
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=m
CONFIG_XEN_BACKEND=y
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=m
CONFIG_XEN_PCIDEV_BACKEND=m
# CONFIG_XEN_SCSI_BACKEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_ACPI_PROCESSOR=m
# CONFIG_XEN_MCE_LOG is not set
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_EFI=y
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_COMEDI is not set
# CONFIG_PANEL is not set
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
CONFIG_RTLLIB_CRYPTO_WEP=m
CONFIG_RTL8192E=m
CONFIG_R8712U=m
# CONFIG_R8188EU is not set
# CONFIG_R8723AU is not set
# CONFIG_RTS5208 is not set
# CONFIG_LINE6_USB is not set
# CONFIG_VT6655 is not set
# CONFIG_FB_XGI is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_LTE_GDM724X is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
# CONFIG_LUSTRE_FS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_CRYPTO_SKEIN is not set
# CONFIG_CRYPTO_THREEFISH is not set
# CONFIG_UNISYSSPAR is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=m
# CONFIG_ALIENWARE_WMI is not set
CONFIG_ASUS_LAPTOP=m
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_AIO=m
# CONFIG_DELL_SMO8800 is not set
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
CONFIG_HP_ACCEL=m
# CONFIG_HP_WIRELESS is not set
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_WMI=m
CONFIG_ACPI_WMI=m
CONFIG_MSI_WMI=m
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_IPS=m
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
CONFIG_SAMSUNG_Q10=m
CONFIG_APPLE_GMUX=m
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#
# CONFIG_SOC_TI is not set

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set
CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_OVERLAYFS_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EXOFS_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_EFIVAR_FS=y
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_OBJLAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_V4_SECURITY_LABEL=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_SUNRPC_DEBUG=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_SMB2=y
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
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
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=m
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_TEST_RHASHTABLE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_EFI is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
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
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_MNTRESTRICT is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_TRUSTED_KEYRING=y
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_MCRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

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
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256_SSSE3=m
CONFIG_CRYPTO_SHA512_SSSE3=m
# CONFIG_CRYPTO_SHA1_MB is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_DRBG_MENU is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS7_MESSAGE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_MMU_AUDIT=y
# CONFIG_KVM_DEVICE_ASSIGNMENT is not set
CONFIG_BINARY_PRINTF=y

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
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--yrj/dFKFPuw6o+aM--
