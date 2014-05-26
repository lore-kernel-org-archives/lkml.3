Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaEZDM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 23:12:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:55248 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaEZDMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 23:12:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,909,1392192000"; 
   d="scan'208";a="544833789"
Message-ID: <5382B12A.8020200@intel.com>
Date: Mon, 26 May 2014 11:12:42 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Jet Chen <jet.chen@intel.com>
Subject: [perf] BUG: unable to handle kernel NULL pointer dereference at 00000000000000eb
Content-Type: multipart/mixed;
 boundary="------------040100080500030400020608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040100080500030400020608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Jiri,

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git perf/fd_master_1
commit 93b6a1f2384ec43677bc555a7d5508710f1068d5 ("perf: Add fd_master interface")


test case: lkp-ws02/hackbench/1600%-process-pipe

8210dbfcf40bb8a  93b6a1f2384ec43677bc555a7
---------------  -------------------------
         0           +Inf%          1 ~ 0%  TOTAL dmesg.BUG:unable_to_handle_kernel_NULL_pointer_dereference
         0           +Inf%          1 ~ 0%  TOTAL dmesg.Oops
         0           +Inf%          1 ~ 0%  TOTAL dmesg.RIP:SYSC_perf_event_open
         0           +Inf%          1 ~ 0%  TOTAL dmesg.Kernel_panic-not_syncing:Fatal_exception

Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


[  165.001824] BUG: unable to handle kernel NULL pointer dereference at 00000000000000eb
[  165.009126] IP: [<ffffffff811404d3>] SYSC_perf_event_open+0x313/0xc00
[  165.015062] PGD 3cbb7f067 PUD 3a215e067 PMD 0
[  165.018631] Oops: 0000 [#1] SMP
[  165.024064] Modules linked in: dm_mod fuse btrfs raid6_pq xor ses enclosure sg sd_mod crct10dif_generic crct10dif_pclmul sr_mod crc_t10dif ata_generic cdrom crct10dif_common pata_acpi snd_pcm snd_timer snd mptsas ahci soundcore mptscsih pata_jmicron libahci pcspkr serio_raw ipmi_si mptbase libata i2c_i801 i7core_edac parport_pc scsi_transport_sas ipmi_msghandler parport edac_core shpchp acpi_cpufreq
[  165.058119] CPU: 22 PID: 1110 Comm: perf_3.14 Not tainted 3.15.0-rc5-wl-02776-geec4f9d #1
[  165.067936] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[  165.078069] task: ffff88007fd63b00 ti: ffff8801d96f8000 task.ti: ffff8801d96f8000
[  165.084172] RIP: 0010:[<ffffffff811404d3>]  [<ffffffff811404d3>] SYSC_perf_event_open+0x313/0xc00
[  165.084172] RSP: 0018:ffff8801d96f9ea0  EFLAGS: 00010246
[  165.096386] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  165.096386] RDX: 00000000000000a7 RSI: 00000000013d07a0 RDI: ffff8801d96f9f40
[  165.096386] RBP: ffff8801d96f9f68 R08: 0000000000000000 R09: 0000000000000000
[  165.122926] R10: 00000000ffffffff R11: 0000000000000202 R12: 0000000000000000
[  165.129153] R13: 0000000000000002 R14: 00000000013e50e0 R15: 0000000000000000
[  165.137074] FS:  00007f7a8741b740(0000) GS:ffff88043fd40000(0000) knlGS:0000000000000000
[  165.137074] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  165.137074] CR2: 00000000000000eb CR3: 00000003fa5f4000 CR4: 00000000000007e0
[  165.157185] Stack:
[  165.157185]  ffff8801d96f9ee8 ffffffff811bc023 0000000000000000 0000000000000000
[  165.164467]  0000000000000000 ffffffff00000000 ffff8800ffffffff ffff880000000000
[  165.175111]  0000006000000000 0000000000000000 0000000000000320 00000000000001a7
[  165.175111] Call Trace:
[  165.175111]  [<ffffffff811bc023>] ? __fput+0x1a3/0x230
[  165.192139]  [<ffffffff81141179>] SyS_perf_event_open+0x9/0x10
[  165.192139]  [<ffffffff81760069>] system_call_fastpath+0x16/0x1b
[  165.202110] Code: 48 c7 c0 ea ff ff ff eb 85 0f 1f 80 00 00 00 00 c7 85 70 ff ff ff 00 00 00 00 45 31 e4 48 c7 85 48 ff ff ff 00 00 00 00 45 31 ff <41> f6 87 eb 00 00 00 01 0f 84 67 02 00 00 f6 45 a3 01 74 39 48
[  165.225103] RIP  [<ffffffff811404d3>] SYSC_perf_event_open+0x313/0xc00
[  165.229113]  RSP <ffff8801d96f9ea0>
[  165.229113] CR2: 00000000000000eb
[  165.242082] ---[ end trace e56e4b305beca08e ]---
[  165.246822] Kernel panic - not syncing: Fatal exception

Append full dmesg file and kconfig as attachments

Thanks,
Jet


--------------040100080500030400020608
Content-Type: text/plain; charset=UTF-8;
 name="reproduce"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproduce"

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu12/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu13/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu14/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu15/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu16/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu17/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu18/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu19/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu20/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu21/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu22/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu23/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
/usr/bin/hackbench -g 384 --process --pipe -l 1875
/usr/bin/hackbench -g 384 --process --pipe -l 1875
/usr/bin/hackbench -g 384 --process --pipe -l 1875
/usr/bin/hackbench -g 384 --process --pipe -l 1875


--------------040100080500030400020608
Content-Type: text/plain; charset=UTF-8;
 name=".dmesg"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=".dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc5-wl-02776-geec4f9d (kbuild@xian) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Thu May 22 06:28:10 CST 2014=

[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/lkp-ws02/cyc=
lic_hackbench-1600%-process-pipe-HEAD-eec4f9d2bbf0a0902dc1ddc2f3864e655bd=
a3e34.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/eec4f9d2bbf0a09=
02dc1ddc2f3864e655bda3e34/vmlinuz-3.15.0-rc5-wl-02776-geec4f9d kconfig=3D=
x86_64-rhel commit=3Deec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34 initrd=3D/k=
ernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 modules_initrd=3D/kern=
el/x86_64-rhel/eec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34/modules.cgz max_u=
ptime=3D1200 RESULT_ROOT=3D/result/lkp-ws02/hackbench/1600%-process-pipe/=
x86_64-rhel/eec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34/0 ip=3D::::lkp-ws02:=
:dhcp oops=3Dpanic ipmi_watchdog.start_now=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D=
100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2=
 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009c3ff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf30afff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000bf30b000-0x00000000bf38afff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf38b000-0x00000000bf3a0fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000bf3a1000-0x00000000bf3a1fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3a2000-0x00000000bf3b2fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000bf3b3000-0x00000000bf3b5fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3b6000-0x00000000bf3dcfff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000bf3dd000-0x00000000bf3ddfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000bf3de000-0x00000000bf3defff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3df000-0x00000000bf413fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000bf414000-0x00000000bf415fff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000bf416000-0x00000000bf417fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf418000-0x00000000bf41ffff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000bf420000-0x00000000bf420fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf421000-0x00000000bf422fff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000bf423000-0x00000000bf42afff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf42b000-0x00000000bf453fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000bf454000-0x00000000bf656fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf657000-0x00000000bf7fffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000cfffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000043fffffff] usa=
ble
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x440000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 0100000000 mask FF00000000 write-back
[    0.000000]   3 base 0200000000 mask FE00000000 write-back
[    0.000000]   4 base 0400000000 mask FFC0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600=
070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable =3D=3D> re=
served
[    0.000000] e820: last_pfn =3D 0xbf800 max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fcf20-0x000fcf2f] mapped a=
t [ffff8800000fcf20]
[    0.000000]   mpc: fc9f0-fcea4
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24=
576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0202b000, 0x0202bfff] PGTABLE
[    0.000000] BRK [0x0202c000, 0x0202cfff] PGTABLE
[    0.000000] BRK [0x0202d000, 0x0202dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x43fe00000-0x43fffffff]
[    0.000000]  [mem 0x43fe00000-0x43fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x43c000000-0x43fdfffff]
[    0.000000]  [mem 0x43c000000-0x43fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x400000000-0x43bffffff]
[    0.000000]  [mem 0x400000000-0x43bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf30afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbf1fffff] page 2M
[    0.000000]  [mem 0xbf200000-0xbf30afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]  [mem 0xbf3dd000-0xbf3ddfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf657000-0xbf7fffff]
[    0.000000]  [mem 0xbf657000-0xbf7fffff] page 4k
[    0.000000] BRK [0x0202e000, 0x0202efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x7178c000-0x7fff2fff]
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 A M I )
[    0.000000] ACPI: XSDT 0x00000000BF421E18 00008C (v01 A M I  ALASKA   =
01072009 MSFT 00010013)
[    0.000000] ACPI: FACP 0x00000000BF41FD98 0000F4 (v04 A M I  ALASKA   =
01072009 MSFT 00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in F=
ADT: 0xBF420F40/0x00000000BF420E40, using 64-bit address (20140424/tbfadt=
-283)
[    0.000000] ACPI: DSDT 0x00000000BF418018 00601B (v01 A M I  ALASKA   =
00000001 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BF420E40 000040
[    0.000000] ACPI: APIC 0x00000000BF41FC18 000130 (v02 A M I  ALASKA   =
01072009 MSFT 00010013)
[    0.000000] ACPI: SSDT 0x00000000BF415798 0006EE (v01 AMICPU PROC     =
00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 0x00000000BF422F18 00003C (v01 A M I  OEMMCFG  =
01072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x00000000BF414C98 000228 (v01 A M I  AMI SRAT =
00000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 0x00000000BF422E98 000030 (v01 A M I  AMI SLIT =
00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 0x00000000BF422E18 000038 (v01 A M I  ICH7HPET =
01072009 AMI. 00000003)
[    0.000000] ACPI: SPMI 0x00000000BF422D98 000040 (v05 A M I  OEMSPMI  =
00000000 AMI. 00000000)
[    0.000000] ACPI: EINJ 0x00000000BF41FA98 000130 (v01 AMI    AMI EINJ =
00000000      00000000)
[    0.000000] ACPI: ERST 0x00000000BF414A18 000210 (v01 AMIER  AMI ERST =
00000000      00000000)
[    0.000000] ACPI: HEST 0x00000000BF414F18 0000A8 (v01 AMI    AMI HEST =
00000000      00000000)
[    0.000000] ACPI: BERT 0x00000000BF422D18 000030 (v01 AMI    AMI BERT =
00000000      00000000)
[    0.000000] ACPI: DMAR 0x00000000BF415F18 0000D4 (v01 A M I  OEMDMAR  =
00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
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
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x23fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x240000000-0x43fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=3D2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x10000000=
0-0x23fffffff] -> [mem 0x00000000-0x23fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23fffffff]
[    0.000000]   NODE_DATA [mem 0x23ffd9000-0x23fffffff]
[    0.000000] Initmem setup node 1 [mem 0x240000000-0x43fffffff]
[    0.000000]   NODE_DATA [mem 0x43ffd6000-0x43fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237e00=
000-ffff88023fdfffff] on node 0
[    0.000000]  [ffffea0009000000-ffffea0010ffffff] PMD -> [ffff880437600=
000-ffff88043f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf30afff]
[    0.000000]   node   0: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]   node   0: [mem 0xbf657000-0xbf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[    0.000000]   node   1: [mem 0x240000000-0x43fffffff]
[    0.000000] On node 0 totalpages: 2094160
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12179 pages used for memmap
[    0.000000]   DMA32 zone: 779445 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x35] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI =
24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI =
48-71
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec90000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 4, version 32, address 0xfec90000, GSI =
72-95
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec02000)
[    0.000000] mapped IOAPIC to ffffffffff578000 (fec90000)
[    0.000000] nr_irqs_gsi: 112
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf30b000-0xbf38afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf38b000-0xbf3a0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a1000-0xbf3a1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a2000-0xbf3b2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b3000-0xbf3b5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b6000-0xbf3dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3de000-0xbf3defff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3df000-0xbf413fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf414000-0xbf415fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf416000-0xbf417fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf418000-0xbf41ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf420000-0xbf420fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf421000-0xbf422fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf423000-0xbf42afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf42b000-0xbf453fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf454000-0xbf656fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf800000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfed1bfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:24 nr_cpu_ids:2=
4 nr_node_ids:2
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880237c00000 s87360 r81=
92 d23232 u131072
[    0.000000] pcpu-alloc: s87360 r8192 d23232 u131072 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 12 13 14 15 16 17 -- -- =
-- --=20
[    0.000000] pcpu-alloc: [1] 06 07 08 09 10 11 18 19 20 21 22 23 -- -- =
-- --=20
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  To=
tal pages: 4125800
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/lkp-w=
s02/cyclic_hackbench-1600%-process-pipe-HEAD-eec4f9d2bbf0a0902dc1ddc2f386=
4e655bda3e34.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/eec4f9d2=
bbf0a0902dc1ddc2f3864e655bda3e34/vmlinuz-3.15.0-rc5-wl-02776-geec4f9d kco=
nfig=3Dx86_64-rhel commit=3Deec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34 init=
rd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 modules_initrd=3D=
/kernel/x86_64-rhel/eec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34/modules.cgz =
max_uptime=3D1200 RESULT_ROOT=3D/result/lkp-ws02/hackbench/1600%-process-=
pipe/x86_64-rhel/eec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34/0 ip=3D::::lkp-=
ws02::dhcp oops=3Dpanic ipmi_watchdog.start_now=3D1 earlyprintk=3DttyS0,1=
15200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdi=
sk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnor=
mal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 16178944K/16765248K available (7569K kernel code, =
1501K rwdata, 3520K rodata, 1724K init, 2184K bss, 586304K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D24=
, Nodes=3D2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_ids=3D=
24.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-23.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D24
[    0.000000] NR_IRQS:524544 nr_irqs:2096 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc5-wl-02776-geec4f9d (kbuild@xian) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Thu May 22 06:28:10 CST 2014=

[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/lkp-ws02/cyc=
lic_hackbench-1600%-process-pipe-HEAD-eec4f9d2bbf0a0902dc1ddc2f3864e655bd=
a3e34.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/eec4f9d2bbf0a09=
02dc1ddc2f3864e655bda3e34/vmlinuz-3.15.0-rc5-wl-02776-geec4f9d kconfig=3D=
x86_64-rhel commit=3Deec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34 initrd=3D/k=
ernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 modules_initrd=3D/kern=
el/x86_64-rhel/eec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34/modules.cgz max_u=
ptime=3D1200 RESULT_ROOT=3D/result/lkp-ws02/hackbench/1600%-process-pipe/=
x86_64-rhel/eec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34/0 ip=3D::::lkp-ws02:=
:dhcp oops=3Dpanic ipmi_watchdog.start_now=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D=
100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2=
 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009c3ff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf30afff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000bf30b000-0x00000000bf38afff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf38b000-0x00000000bf3a0fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000bf3a1000-0x00000000bf3a1fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3a2000-0x00000000bf3b2fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000bf3b3000-0x00000000bf3b5fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3b6000-0x00000000bf3dcfff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000bf3dd000-0x00000000bf3ddfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000bf3de000-0x00000000bf3defff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3df000-0x00000000bf413fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000bf414000-0x00000000bf415fff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000bf416000-0x00000000bf417fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf418000-0x00000000bf41ffff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000bf420000-0x00000000bf420fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf421000-0x00000000bf422fff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000bf423000-0x00000000bf42afff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf42b000-0x00000000bf453fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000bf454000-0x00000000bf656fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf657000-0x00000000bf7fffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000cfffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000043fffffff] usa=
ble
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x440000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 0100000000 mask FF00000000 write-back
[    0.000000]   3 base 0200000000 mask FE00000000 write-back
[    0.000000]   4 base 0400000000 mask FFC0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600=
070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable =3D=3D> re=
served
[    0.000000] e820: last_pfn =3D 0xbf800 max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fcf20-0x000fcf2f] mapped a=
t [ffff8800000fcf20]
[    0.000000]   mpc: fc9f0-fcea4
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24=
576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0202b000, 0x0202bfff] PGTABLE
[    0.000000] BRK [0x0202c000, 0x0202cfff] PGTABLE
[    0.000000] BRK [0x0202d000, 0x0202dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x43fe00000-0x43fffffff]
[    0.000000]  [mem 0x43fe00000-0x43fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x43c000000-0x43fdfffff]
[    0.000000]  [mem 0x43c000000-0x43fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x400000000-0x43bffffff]
[    0.000000]  [mem 0x400000000-0x43bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf30afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbf1fffff] page 2M
[    0.000000]  [mem 0xbf200000-0xbf30afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]  [mem 0xbf3dd000-0xbf3ddfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf657000-0xbf7fffff]
[    0.000000]  [mem 0xbf657000-0xbf7fffff] page 4k
[    0.000000] BRK [0x0202e000, 0x0202efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x7178c000-0x7fff2fff]
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 A M I )
[    0.000000] ACPI: XSDT 0x00000000BF421E18 00008C (v01 A M I  ALASKA   =
01072009 MSFT 00010013)
[    0.000000] ACPI: FACP 0x00000000BF41FD98 0000F4 (v04 A M I  ALASKA   =
01072009 MSFT 00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in F=
ADT: 0xBF420F40/0x00000000BF420E40, using 64-bit address (20140424/tbfadt=
-283)
[    0.000000] ACPI: DSDT 0x00000000BF418018 00601B (v01 A M I  ALASKA   =
00000001 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BF420E40 000040
[    0.000000] ACPI: APIC 0x00000000BF41FC18 000130 (v02 A M I  ALASKA   =
01072009 MSFT 00010013)
[    0.000000] ACPI: SSDT 0x00000000BF415798 0006EE (v01 AMICPU PROC     =
00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 0x00000000BF422F18 00003C (v01 A M I  OEMMCFG  =
01072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x00000000BF414C98 000228 (v01 A M I  AMI SRAT =
00000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 0x00000000BF422E98 000030 (v01 A M I  AMI SLIT =
00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 0x00000000BF422E18 000038 (v01 A M I  ICH7HPET =
01072009 AMI. 00000003)
[    0.000000] ACPI: SPMI 0x00000000BF422D98 000040 (v05 A M I  OEMSPMI  =
00000000 AMI. 00000000)
[    0.000000] ACPI: EINJ 0x00000000BF41FA98 000130 (v01 AMI    AMI EINJ =
00000000      00000000)
[    0.000000] ACPI: ERST 0x00000000BF414A18 000210 (v01 AMIER  AMI ERST =
00000000      00000000)
[    0.000000] ACPI: HEST 0x00000000BF414F18 0000A8 (v01 AMI    AMI HEST =
00000000      00000000)
[    0.000000] ACPI: BERT 0x00000000BF422D18 000030 (v01 AMI    AMI BERT =
00000000      00000000)
[    0.000000] ACPI: DMAR 0x00000000BF415F18 0000D4 (v01 A M I  OEMDMAR  =
00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
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
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x23fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x240000000-0x43fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=3D2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x10000000=
0-0x23fffffff] -> [mem 0x00000000-0x23fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23fffffff]
[    0.000000]   NODE_DATA [mem 0x23ffd9000-0x23fffffff]
[    0.000000] Initmem setup node 1 [mem 0x240000000-0x43fffffff]
[    0.000000]   NODE_DATA [mem 0x43ffd6000-0x43fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237e00=
000-ffff88023fdfffff] on node 0
[    0.000000]  [ffffea0009000000-ffffea0010ffffff] PMD -> [ffff880437600=
000-ffff88043f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf30afff]
[    0.000000]   node   0: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]   node   0: [mem 0xbf657000-0xbf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[    0.000000]   node   1: [mem 0x240000000-0x43fffffff]
[    0.000000] On node 0 totalpages: 2094160
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12179 pages used for memmap
[    0.000000]   DMA32 zone: 779445 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x35] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI =
24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI =
48-71
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec90000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 4, version 32, address 0xfec90000, GSI =
72-95
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec02000)
[    0.000000] mapped IOAPIC to ffffffffff578000 (fec90000)
[    0.000000] nr_irqs_gsi: 112
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf30b000-0xbf38afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf38b000-0xbf3a0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a1000-0xbf3a1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a2000-0xbf3b2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b3000-0xbf3b5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b6000-0xbf3dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3de000-0xbf3defff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3df000-0xbf413fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf414000-0xbf415fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf416000-0xbf417fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf418000-0xbf41ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf420000-0xbf420fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf421000-0xbf422fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf423000-0xbf42afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf42b000-0xbf453fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf454000-0xbf656fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf800000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfed1bfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:24 nr_cpu_ids:2=
4 nr_node_ids:2
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880237c00000 s87360 r81=
92 d23232 u131072
[    0.000000] pcpu-alloc: s87360 r8192 d23232 u131072 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 12 13 14 15 16 17 -- -- =
-- --=20
[    0.000000] pcpu-alloc: [1] 06 07 08 09 10 11 18 19 20 21 22 23 -- -- =
-- --=20
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  To=
tal pages: 4125800
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/lkp-w=
s02/cyclic_hackbench-1600%-process-pipe-HEAD-eec4f9d2bbf0a0902dc1ddc2f386=
4e655bda3e34.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/eec4f9d2=
bbf0a0902dc1ddc2f3864e655bda3e34/vmlinuz-3.15.0-rc5-wl-02776-geec4f9d kco=
nfig=3Dx86_64-rhel commit=3Deec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34 init=
rd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 modules_initrd=3D=
/kernel/x86_64-rhel/eec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34/modules.cgz =
max_uptime=3D1200 RESULT_ROOT=3D/result/lkp-ws02/hackbench/1600%-process-=
pipe/x86_64-rhel/eec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34/0 ip=3D::::lkp-=
ws02::dhcp oops=3Dpanic ipmi_watchdog.start_now=3D1 earlyprintk=3DttyS0,1=
15200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdi=
sk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnor=
mal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 16178944K/16765248K available (7569K kernel code, =
1501K rwdata, 3520K rodata, 1724K init, 2184K bss, 586304K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D24=
, Nodes=3D2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_ids=3D=
24.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-23.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D24
[    0.000000] NR_IRQS:524544 nr_irqs:2096 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] Enabling automatic NUMA balancing. Configure with numa_bal=
ancing=3D or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2800.240 MHz processor
[    0.000029] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 5600.48 BogoMIPS (lpj=3D2800240)
[    0.010756] pid_max: default: 32768 minimum: 301
[    0.015433] ACPI: Core revision 20140424
[    0.023223] ACPI: All ACPI Tables successfully acquired
[    0.028667] Security Framework initialized
[    0.032818] SELinux:  Initializing.
[    0.036356] SELinux:  Starting in permissive mode
[    0.042128] Dentry cache hash table entries: 2097152 (order: 12, 16777=
216 bytes)
[    0.053290] Inode-cache hash table entries: 1048576 (order: 11, 838860=
8 bytes)
[    0.062206] Mount-cache hash table entries: 32768 (order: 6, 262144 by=
tes)
[    0.069215] Mountpoint-cache hash table entries: 32768 (order: 6, 2621=
44 bytes)
[    0.076995] Initializing cgroup subsys memory
[    0.081473] Initializing cgroup subsys devices
[    0.086035] Initializing cgroup subsys freezer
[    0.090597] Initializing cgroup subsys net_cls
[    0.095152] Initializing cgroup subsys blkio
[    0.099539] Initializing cgroup subsys perf_event
[    0.104363] Initializing cgroup subsys hugetlb
[    0.108944] CPU: Physical Processor ID: 0
[    0.113070] CPU: Processor Core ID: 0
[    0.116851] mce: CPU supports 9 MCE banks
[    0.120978] CPU0: Thermal LVT vector (0xfa) already installed
[    0.126842] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.126842] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.126842] tlb_flushall_shift: 6
[    0.142198] Freeing SMP alternatives memory: 32K (ffffffff81dff000 - f=
fffffff81e07000)
[    0.151186] ftrace: allocating 28388 entries in 111 pages
[    0.167829] Getting VERSION: 1060015
[    0.171523] Getting VERSION: 1060015
[    0.175211] Getting ID: 0
[    0.177943] Getting ID: 0
[    0.180676] dmar: Host address width 40
[    0.184631] dmar: DRHD base: 0x000000fe710000 flags: 0x1
[    0.190067] dmar: IOMMU 0: reg_base_addr fe710000 ver 1:0 cap c9078010=
6f0462 ecap f0207e
[    0.198342] dmar: RMRR base: 0x000000bf3b6000 end: 0x000000bf3c9fff
[    0.204727] dmar: ATSR flags: 0x0
[    0.208303] IOAPIC id 3 under DRHD base  0xfe710000 IOMMU 0
[    0.213991] IOAPIC id 2 under DRHD base  0xfe710000 IOMMU 0
[    0.219681] IOAPIC id 0 under DRHD base  0xfe710000 IOMMU 0
[    0.225371] [Firmware Bug]: ioapic 4 has no mapping iommu, interrupt r=
emapping will be disabled
[    0.234252] Not enable interrupt remapping
[    0.238543] Switched APIC routing to physical flat.
[    0.243534] masked ExtINT on CPU#0
[    0.247561] ENABLING IO-APIC IRQs
[    0.250991] init IO_APIC IRQs
[    0.254071]  apic 0 pin 0 not connected
[    0.258021] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:0)
[    0.266121] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:0)
[    0.274223] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:0)
[    0.282330] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:0)
[    0.290436] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 =
Active:0 Dest:0)
[    0.298536] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:0)
[    0.306638] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:0)
[    0.314740] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:0)
[    0.322839] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:0)
[    0.330941] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
0 Active:0 Dest:0)
[    0.339217] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
0 Active:0 Dest:0)
[    0.347491] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:0)
[    0.355767] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:0)
[    0.364040] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:0)
[    0.372314] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:0)
[    0.380590]  apic 0 pin 16 not connected
[    0.384629]  apic 0 pin 17 not connected
[    0.388663]  apic 0 pin 18 not connected
[    0.392705]  apic 0 pin 19 not connected
[    0.396747]  apic 0 pin 20 not connected
[    0.400789]  apic 0 pin 21 not connected
[    0.404830]  apic 0 pin 22 not connected
[    0.408864]  apic 0 pin 23 not connected
[    0.412906]  apic 2 pin 0 not connected
[    0.416851]  apic 2 pin 1 not connected
[    0.420800]  apic 2 pin 2 not connected
[    0.424754]  apic 2 pin 3 not connected
[    0.428700]  apic 2 pin 4 not connected
[    0.432648]  apic 2 pin 5 not connected
[    0.436603]  apic 2 pin 6 not connected
[    0.440559]  apic 2 pin 7 not connected
[    0.444514]  apic 2 pin 8 not connected
[    0.448469]  apic 2 pin 9 not connected
[    0.452422]  apic 2 pin 10 not connected
[    0.456456]  apic 2 pin 11 not connected
[    0.460490]  apic 2 pin 12 not connected
[    0.464524]  apic 2 pin 13 not connected
[    0.468565]  apic 2 pin 14 not connected
[    0.472599]  apic 2 pin 15 not connected
[    0.476641]  apic 2 pin 16 not connected
[    0.480674]  apic 2 pin 17 not connected
[    0.484715]  apic 2 pin 18 not connected
[    0.488750]  apic 2 pin 19 not connected
[    0.492791]  apic 2 pin 20 not connected
[    0.496833]  apic 2 pin 21 not connected
[    0.500867]  apic 2 pin 22 not connected
[    0.504908]  apic 2 pin 23 not connected
[    0.508942]  apic 3 pin 0 not connected
[    0.512897]  apic 3 pin 1 not connected
[    0.516852]  apic 3 pin 2 not connected
[    0.520808]  apic 3 pin 3 not connected
[    0.524763]  apic 3 pin 4 not connected
[    0.528718]  apic 3 pin 5 not connected
[    0.532673]  apic 3 pin 6 not connected
[    0.536629]  apic 3 pin 7 not connected
[    0.540574]  apic 3 pin 8 not connected
[    0.544520]  apic 3 pin 9 not connected
[    0.548469]  apic 3 pin 10 not connected
[    0.552510]  apic 3 pin 11 not connected
[    0.556551]  apic 3 pin 12 not connected
[    0.560585]  apic 3 pin 13 not connected
[    0.564619]  apic 3 pin 14 not connected
[    0.568660]  apic 3 pin 15 not connected
[    0.572694]  apic 3 pin 16 not connected
[    0.576735]  apic 3 pin 17 not connected
[    0.580769]  apic 3 pin 18 not connected
[    0.584811]  apic 3 pin 19 not connected
[    0.588852]  apic 3 pin 20 not connected
[    0.592886]  apic 3 pin 21 not connected
[    0.596920]  apic 3 pin 22 not connected
[    0.600961]  apic 3 pin 23 not connected
[    0.604995]  apic 4 pin 0 not connected
[    0.608951]  apic 4 pin 1 not connected
[    0.612906]  apic 4 pin 2 not connected
[    0.616861]  apic 4 pin 3 not connected
[    0.620814]  apic 4 pin 4 not connected
[    0.624762]  apic 4 pin 5 not connected
[    0.628708]  apic 4 pin 6 not connected
[    0.632656]  apic 4 pin 7 not connected
[    0.636611]  apic 4 pin 8 not connected
[    0.640567]  apic 4 pin 9 not connected
[    0.644522]  apic 4 pin 10 not connected
[    0.648563]  apic 4 pin 11 not connected
[    0.652596]  apic 4 pin 12 not connected
[    0.656630]  apic 4 pin 13 not connected
[    0.660671]  apic 4 pin 14 not connected
[    0.664705]  apic 4 pin 15 not connected
[    0.668746]  apic 4 pin 16 not connected
[    0.672780]  apic 4 pin 17 not connected
[    0.676821]  apic 4 pin 18 not connected
[    0.680856]  apic 4 pin 19 not connected
[    0.684897]  apic 4 pin 20 not connected
[    0.688938]  apic 4 pin 21 not connected
[    0.692973]  apic 4 pin 22 not connected
[    0.697014]  apic 4 pin 23 not connected
[    0.701178] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.717312] smpboot: CPU0: Intel(R) Xeon(R) CPU           X5660  @ 2.8=
0GHz (fam: 06, model: 2c, stepping: 01)
[    0.727598] Using local APIC timer interrupts.
[    0.727598] calibrating APIC timer ...
[    0.837361] ... lapic delta =3D 833352
[    0.841048] ... PM-Timer delta =3D 357949
[    0.844996] ... PM-Timer result ok
[    0.848510] ..... delta 833352
[    0.851675] ..... mult: 35792195
[    0.855014] ..... calibration result: 133336
[    0.859395] ..... CPU clock speed is 2800.0055 MHz.
[    0.864392] ..... host bus clock speed is 133.0336 MHz.
[    0.869744] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere even=
ts, Intel PMU driver.
[    0.878530] perf_event_intel: CPUID marked event: 'bus cycles' unavail=
able
[    0.885522] ... version:                3
[    0.889649] ... bit width:              48
[    0.893865] ... generic registers:      4
[    0.897984] ... value mask:             0000ffffffffffff
[    0.903415] ... max period:             000000007fffffff
[    0.908844] ... fixed-purpose events:   3
[    0.912965] ... event mask:             000000070000000f
[    0.920268] x86: Booting SMP configuration:
[    0.924573] .... node  #0, CPUs:        #1
[    0.939781] masked ExtINT on CPU#1
[    0.943396] CPU1: Thermal LVT vector (0xfa) already installed
[    0.951541] NMI watchdog: enabled on all CPUs, permanently consumes on=
e hw-PMU counter.
[    0.961416]   #2
[    0.974253] masked ExtINT on CPU#2
[    0.977867] CPU2: Thermal LVT vector (0xfa) already installed
[    0.985795]   #3
[    0.998633] masked ExtINT on CPU#3
[    1.002249] CPU3: Thermal LVT vector (0xfa) already installed
[    1.010176]   #4
[    1.023006] masked ExtINT on CPU#4
[    1.026618] CPU4: Thermal LVT vector (0xfa) already installed
[    1.034547]   #5
[    1.047383] masked ExtINT on CPU#5
[    1.050999] CPU5: Thermal LVT vector (0xfa) already installed
[    1.058940]=20
[    1.060611] .... node  #1, CPUs:    #6
[    1.075411] masked ExtINT on CPU#6
[    1.079029] CPU6: Thermal LVT vector (0xfa) already installed
[    1.163972] TSC synchronization [CPU#0 -> CPU#6]:
[    1.168858] Measured 69 cycles TSC warp between CPUs, turning off TSC =
clock.
[    1.176024] tsc: Marking TSC unstable due to check_tsc_sync_source fai=
led
[    1.183053]   #7
[    1.195884] masked ExtINT on CPU#7
[    1.199501] CPU7: Thermal LVT vector (0xfa) already installed
[    0.001000]   #8
[    0.001000] masked ExtINT on CPU#8
[    0.001000] CPU8: Thermal LVT vector (0xfa) already installed
[    0.367840]   #9
[    0.367763] masked ExtINT on CPU#9
[    0.367763] CPU9: Thermal LVT vector (0xfa) already installed
[    0.389162]  #10
[    0.389093] masked ExtINT on CPU#10
[    0.389093] CPU10: Thermal LVT vector (0xfa) already installed
[    0.411693]  #11
[    0.411616] masked ExtINT on CPU#11
[    0.411616] CPU11: Thermal LVT vector (0xfa) already installed
[    0.433289]=20
[    0.434001] .... node  #0, CPUs:   #12
[    0.433211] masked ExtINT on CPU#12
[    0.433211] CPU12: Thermal LVT vector (0xfa) already installed
[    0.456436]  #13
[    0.456340] masked ExtINT on CPU#13
[    0.456340] CPU13: Thermal LVT vector (0xfa) already installed
[    0.478007]  #14
[    0.477908] masked ExtINT on CPU#14
[    0.477908] CPU14: Thermal LVT vector (0xfa) already installed
[    0.500560]  #15
[    0.500475] masked ExtINT on CPU#15
[    0.500475] CPU15: Thermal LVT vector (0xfa) already installed
[    0.522183]  #16
[    0.522096] masked ExtINT on CPU#16
[    0.522096] CPU16: Thermal LVT vector (0xfa) already installed
[    0.544741]  #17
[    0.544653] masked ExtINT on CPU#17
[    0.544653] CPU17: Thermal LVT vector (0xfa) already installed
[    0.566321]=20
[    0.567001] .... node  #1, CPUs:   #18
[    0.566210] masked ExtINT on CPU#18
[    0.566210] CPU18: Thermal LVT vector (0xfa) already installed
[    0.589423]  #19
[    0.589350] masked ExtINT on CPU#19
[    0.589350] CPU19: Thermal LVT vector (0xfa) already installed
[    0.610954]  #20
[    0.610881] masked ExtINT on CPU#20
[    0.610881] CPU20: Thermal LVT vector (0xfa) already installed
[    0.632479]  #21
[    0.632407] masked ExtINT on CPU#21
[    0.632407] CPU21: Thermal LVT vector (0xfa) already installed
[    0.654081]  #22
[    0.654004] masked ExtINT on CPU#22
[    0.654004] CPU22: Thermal LVT vector (0xfa) already installed
[    0.676612]  #23
[    0.676536] masked ExtINT on CPU#23
[    0.676536] CPU23: Thermal LVT vector (0xfa) already installed
[    0.698063] x86: Booted up 2 nodes, 24 CPUs
[    0.699002] smpboot: Total of 24 processors activated (134403.91 BogoM=
IPS)
[    0.702331] devtmpfs: initialized
[    0.707107] evm: security.selinux
[    0.708001] evm: security.ima
[    0.709000] evm: security.capability
[    0.710105] PM: Registering ACPI NVS region [mem 0xbf30b000-0xbf38afff=
] (524288 bytes)
[    0.711010] PM: Registering ACPI NVS region [mem 0xbf3a1000-0xbf3a1fff=
] (4096 bytes)
[    0.712001] PM: Registering ACPI NVS region [mem 0xbf3b3000-0xbf3b5fff=
] (12288 bytes)
[    0.713001] PM: Registering ACPI NVS region [mem 0xbf3de000-0xbf3defff=
] (4096 bytes)
[    0.714001] PM: Registering ACPI NVS region [mem 0xbf416000-0xbf417fff=
] (8192 bytes)
[    0.715001] PM: Registering ACPI NVS region [mem 0xbf420000-0xbf420fff=
] (4096 bytes)
[    0.716001] PM: Registering ACPI NVS region [mem 0xbf423000-0xbf42afff=
] (32768 bytes)
[    0.717002] PM: Registering ACPI NVS region [mem 0xbf454000-0xbf656fff=
] (2109440 bytes)
[    0.719369] atomic64 test passed for x86-64 platform with CX8 and with=
 SSE
[    0.720052] NET: Registered protocol family 16
[    0.722149] cpuidle: using governor menu
[    0.723112] ACPI: bus type PCI registered
[    0.724001] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.726032] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc00000=
00-0xcfffffff] (base 0xc0000000)
[    0.727002] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E=
820
[    0.753165] PCI: Using configuration type 1 for base access
[    0.756483] ACPI: Added _OSI(Module Device)
[    0.757001] ACPI: Added _OSI(Processor Device)
[    0.758001] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.759001] ACPI: Added _OSI(Processor Aggregator Device)
[    0.761618] ACPI: Executed 1 blocks of module-level executable AML cod=
e
[    0.765045] \_SB_:_OSC evaluation returned wrong type
[    0.766001] _OSC request data:1 1f=20
[    0.770029] ACPI: Dynamic OEM Table Load:
[    0.772307] ACPI: SSDT 0xFFFF8804348A2000 001494 (v01 AMI    IST      =
00000001 MSFT 03000001)
[    0.777799] ACPI: Interpreter enabled
[    0.778006] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_] (20140424/hwxface-580)
[    0.781008] ACPI: (supports S0 S1 S3 S4 S5)
[    0.782001] ACPI: Using IOAPIC for interrupt routing
[    0.783047] HEST: Table parsing has been initialized.
[    0.784002] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.785513] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.790845] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.791004] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cl=
ockPM Segments MSI]
[    0.792148] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AE=
R PCIeCapability]
[    0.794033] PCI host bridge to bus 0000:00
[    0.795002] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.796001] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.797001] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.798001] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.799001] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfffff=
fff]
[    0.800010] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
[    0.801048] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.802067] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    0.804015] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.805070] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    0.806045] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.807067] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    0.808044] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.809067] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    0.810045] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.811067] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    0.812047] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.814044] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    0.815009] pci 0000:00:13.0: reg 0x10: [mem 0xfbe24000-0xfbe24fff]
[    0.816038] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    0.817061] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    0.819069] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    0.820089] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    0.821085] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    0.822079] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    0.823010] pci 0000:00:16.0: reg 0x10: [mem 0xfbe1c000-0xfbe1ffff 64b=
it]
[    0.824099] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    0.825010] pci 0000:00:16.1: reg 0x10: [mem 0xfbe18000-0xfbe1bfff 64b=
it]
[    0.826099] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    0.827010] pci 0000:00:16.2: reg 0x10: [mem 0xfbe14000-0xfbe17fff 64b=
it]
[    0.829065] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    0.830010] pci 0000:00:16.3: reg 0x10: [mem 0xfbe10000-0xfbe13fff 64b=
it]
[    0.831099] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    0.832010] pci 0000:00:16.4: reg 0x10: [mem 0xfbe0c000-0xfbe0ffff 64b=
it]
[    0.833097] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    0.834010] pci 0000:00:16.5: reg 0x10: [mem 0xfbe08000-0xfbe0bfff 64b=
it]
[    0.835103] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    0.836010] pci 0000:00:16.6: reg 0x10: [mem 0xfbe04000-0xfbe07fff 64b=
it]
[    0.837099] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    0.838010] pci 0000:00:16.7: reg 0x10: [mem 0xfbe00000-0xfbe03fff 64b=
it]
[    0.839102] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.840036] pci 0000:00:1a.0: reg 0x20: [io  0xf0c0-0xf0df]
[    0.841076] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.842036] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.843036] pci 0000:00:1a.2: reg 0x20: [io  0xf0a0-0xf0bf]
[    0.844074] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    0.845042] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.846018] pci 0000:00:1a.7: reg 0x10: [mem 0xfbe23000-0xfbe233ff]
[    0.847078] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.848039] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.849036] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.850063] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.851040] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.853033] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    0.854063] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.855039] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.856037] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.857036] pci 0000:00:1d.0: reg 0x20: [io  0xf080-0xf09f]
[    0.858077] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.859034] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.860036] pci 0000:00:1d.1: reg 0x20: [io  0xf060-0xf07f]
[    0.861074] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.862034] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.863036] pci 0000:00:1d.2: reg 0x20: [io  0xf040-0xf05f]
[    0.864074] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.865042] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.866018] pci 0000:00:1d.7: reg 0x10: [mem 0xfbe22000-0xfbe223ff]
[    0.868027] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.869040] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.870033] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.871072] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.872035] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    0.873069] pci 0000:00:1f.0: can't claim BAR 13 [io  0x0400-0x047f]: =
address conflict with ACPI CPU throttle [io  0x0410-0x0415]
[    0.874004] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by IC=
H6 GPIO
[    0.875003] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600=
 (mask 00ff)
[    0.876002] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0=
 (mask 000f)
[    0.877002] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290=
 (mask 001f)
[    0.878002] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0=
 (mask 000f)
[    0.879090] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    0.880016] pci 0000:00:1f.2: reg 0x10: [io  0xf110-0xf117]
[    0.881006] pci 0000:00:1f.2: reg 0x14: [io  0xf100-0xf103]
[    0.882006] pci 0000:00:1f.2: reg 0x18: [io  0xf0f0-0xf0f7]
[    0.883006] pci 0000:00:1f.2: reg 0x1c: [io  0xf0e0-0xf0e3]
[    0.884006] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    0.885006] pci 0000:00:1f.2: reg 0x24: [mem 0xfbe21000-0xfbe217ff]
[    0.886039] pci 0000:00:1f.2: PME# supported from D3hot
[    0.887065] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.888013] pci 0000:00:1f.3: reg 0x10: [mem 0xfbe20000-0xfbe200ff 64b=
it]
[    0.889017] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    0.890115] pci 0000:01:00.0: [8086:10c9] type 00 class 0x020000
[    0.891011] pci 0000:01:00.0: reg 0x10: [mem 0xfbaa0000-0xfbabffff]
[    0.892008] pci 0000:01:00.0: reg 0x14: [mem 0xfba80000-0xfba9ffff]
[    0.893008] pci 0000:01:00.0: reg 0x18: [io  0xe020-0xe03f]
[    0.894007] pci 0000:01:00.0: reg 0x1c: [mem 0xfbb44000-0xfbb47fff]
[    0.895020] pci 0000:01:00.0: reg 0x30: [mem 0xfba60000-0xfba7ffff pre=
f]
[    0.896048] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.897034] pci 0000:01:00.0: reg 0x184: [mem 0xfbb20000-0xfbb23fff 64=
bit]
[    0.898015] pci 0000:01:00.0: reg 0x190: [mem 0xfbb00000-0xfbb03fff 64=
bit]
[    0.899052] pci 0000:01:00.1: [8086:10c9] type 00 class 0x020000
[    0.900011] pci 0000:01:00.1: reg 0x10: [mem 0xfba40000-0xfba5ffff]
[    0.901007] pci 0000:01:00.1: reg 0x14: [mem 0xfba20000-0xfba3ffff]
[    0.902007] pci 0000:01:00.1: reg 0x18: [io  0xe000-0xe01f]
[    0.903007] pci 0000:01:00.1: reg 0x1c: [mem 0xfbb40000-0xfbb43fff]
[    0.904020] pci 0000:01:00.1: reg 0x30: [mem 0xfba00000-0xfba1ffff pre=
f]
[    0.905048] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    0.906030] pci 0000:01:00.1: reg 0x184: [mem 0xfbae0000-0xfbae3fff 64=
bit]
[    0.907015] pci 0000:01:00.1: reg 0x190: [mem 0xfbac0000-0xfbac3fff 64=
bit]
[    0.910011] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.911003] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.912002] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfff=
ff]
[    0.913042] pci 0000:00:03.0: PCI bridge to [bus 03]
[    0.914039] pci 0000:00:05.0: PCI bridge to [bus 04]
[    0.915041] pci 0000:00:07.0: PCI bridge to [bus 05]
[    0.916054] pci 0000:06:00.0: [8086:0329] type 01 class 0x060400
[    0.917013] pci 0000:06:00.0: PXH quirk detected; SHPC device MSI disa=
bled
[    0.919028] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.920051] pci 0000:06:00.2: [8086:032a] type 01 class 0x060400
[    0.921012] pci 0000:06:00.2: PXH quirk detected; SHPC device MSI disa=
bled
[    0.922048] pci 0000:06:00.2: PME# supported from D0 D3hot D3cold
[    0.923043] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.924006] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    0.925002] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    0.926002] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fff=
ff]
[    0.927067] pci 0000:06:00.0: PCI bridge to [bus 07]
[    0.928048] pci 0000:08:01.0: [8086:1229] type 00 class 0x020000
[    0.929014] pci 0000:08:01.0: reg 0x10: [mem 0xfb900000-0xfb900fff]
[    0.930008] pci 0000:08:01.0: reg 0x14: [io  0xd000-0xd03f]
[    0.931008] pci 0000:08:01.0: reg 0x18: [mem 0xfb800000-0xfb8fffff]
[    0.932027] pci 0000:08:01.0: reg 0x30: [mem 0xfb700000-0xfb7fffff pre=
f]
[    0.933022] pci 0000:08:01.0: supports D1 D2
[    0.934001] pci 0000:08:01.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.935062] pci 0000:06:00.2: PCI bridge to [bus 08]
[    0.936003] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    0.937002] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fff=
ff]
[    0.938067] pci 0000:09:00.0: [1000:0058] type 00 class 0x010000
[    0.939013] pci 0000:09:00.0: reg 0x10: [io  0xc000-0xc0ff]
[    0.940014] pci 0000:09:00.0: reg 0x14: [mem 0xfb610000-0xfb613fff 64b=
it]
[    0.941014] pci 0000:09:00.0: reg 0x1c: [mem 0xfb600000-0xfb60ffff 64b=
it]
[    0.942017] pci 0000:09:00.0: reg 0x30: [mem 0xfb400000-0xfb5fffff pre=
f]
[    0.943052] pci 0000:09:00.0: supports D1 D2
[    0.944035] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.945007] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    0.946003] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.947003] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fff=
ff]
[    0.948004] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fff=
ff 64bit pref]
[    0.949062] pci 0000:0a:00.0: [197b:2368] type 00 class 0x010185
[    0.950027] pci 0000:0a:00.0: reg 0x10: [io  0xb040-0xb047]
[    0.951012] pci 0000:0a:00.0: reg 0x14: [io  0xb030-0xb033]
[    0.952012] pci 0000:0a:00.0: reg 0x18: [io  0xb020-0xb027]
[    0.953012] pci 0000:0a:00.0: reg 0x1c: [io  0xb010-0xb013]
[    0.954012] pci 0000:0a:00.0: reg 0x20: [io  0xb000-0xb00f]
[    0.955023] pci 0000:0a:00.0: reg 0x30: [mem 0xfbd00000-0xfbd0ffff pre=
f]
[    0.956104] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  =
You can enable it with 'pcie_aspm=3Dforce'
[    0.957010] pci 0000:00:1c.4: PCI bridge to [bus 0a]
[    0.958003] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    0.959002] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfff=
ff]
[    0.960004] pci 0000:00:1c.4:   bridge window [mem 0xd0200000-0xd03fff=
ff 64bit pref]
[    0.961036] pci 0000:0b:01.0: [1002:515e] type 00 class 0x030000
[    0.962015] pci 0000:0b:01.0: reg 0x10: [mem 0xf0000000-0xf7ffffff pre=
f]
[    0.963008] pci 0000:0b:01.0: reg 0x14: [io  0xa000-0xa0ff]
[    0.964008] pci 0000:0b:01.0: reg 0x18: [mem 0xfbc20000-0xfbc2ffff]
[    0.965029] pci 0000:0b:01.0: reg 0x30: [mem 0xfbc00000-0xfbc1ffff pre=
f]
[    0.966025] pci 0000:0b:01.0: supports D1 D2
[    0.967059] pci 0000:00:1e.0: PCI bridge to [bus 0b] (subtractive deco=
de)
[    0.968003] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    0.969003] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfff=
ff]
[    0.970004] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffff=
ff 64bit pref]
[    0.971001] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (sub=
tractive decode)
[    0.972001] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
[    0.973001] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
[    0.974001] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xffffff=
ff] (subtractive decode)
[    0.976027] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14=
 15), disabled.
[    0.981339] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14=
 15), disabled.
[    0.986338] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14=
 15), disabled.
[    0.990337] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14=
 15), disabled.
[    0.996035] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 =
15) *0, disabled.
[    1.002035] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 =
15) *0, disabled.
[    1.008035] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 =
15) *0, disabled.
[    1.014035] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14=
 15), disabled.
[    1.019346] ACPI: Enabled 2 GPEs in block 00 to 3F
[    1.021053] vgaarb: device added: PCI:0000:0b:01.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    1.029001] vgaarb: loaded
[    1.032000] vgaarb: bridge control possible 0000:0b:01.0
[    1.037094] SCSI subsystem initialized
[    1.041023] ACPI: bus type USB registered
[    1.045021] usbcore: registered new interface driver usbfs
[    1.051008] usbcore: registered new interface driver hub
[    1.056012] usbcore: registered new device driver usb
[    1.061015] pps_core: LinuxPPS API ver. 1 registered
[    1.067001] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    1.076003] PTP clock support registered
[    1.080059] PCI: Using ACPI for IRQ routing
[    1.089206] PCI: Discovered peer bus fe
[    1.093001] PCI: root bus fe: using default resources
[    1.099001] PCI: Probing PCI hardware (bus fe)
[    1.103023] PCI host bridge to bus 0000:fe
[    1.107003] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]
[    1.114001] pci_bus 0000:fe: root bus resource [mem 0x00000000-0xfffff=
fffff]
[    1.121001] pci_bus 0000:fe: No busn resource found for root bus, will=
 use [bus fe-ff]
[    1.129002] pci_bus 0000:fe: busn_res: can not insert [bus fe-ff] unde=
r domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    1.140005] pci 0000:fe:00.0: [8086:2c70] type 00 class 0x060000
[    1.147043] pci 0000:fe:00.1: [8086:2d81] type 00 class 0x060000
[    1.153036] pci 0000:fe:02.0: [8086:2d90] type 00 class 0x060000
[    1.159033] pci 0000:fe:02.1: [8086:2d91] type 00 class 0x060000
[    1.165031] pci 0000:fe:02.2: [8086:2d92] type 00 class 0x060000
[    1.171013] pci 0000:fe:02.3: [8086:2d93] type 00 class 0x060000
[    1.177034] pci 0000:fe:02.4: [8086:2d94] type 00 class 0x060000
[    1.183033] pci 0000:fe:02.5: [8086:2d95] type 00 class 0x060000
[    1.190033] pci 0000:fe:03.0: [8086:2d98] type 00 class 0x060000
[    1.196032] pci 0000:fe:03.1: [8086:2d99] type 00 class 0x060000
[    1.202033] pci 0000:fe:03.2: [8086:2d9a] type 00 class 0x060000
[    1.208033] pci 0000:fe:03.4: [8086:2d9c] type 00 class 0x060000
[    1.214034] pci 0000:fe:04.0: [8086:2da0] type 00 class 0x060000
[    1.220033] pci 0000:fe:04.1: [8086:2da1] type 00 class 0x060000
[    1.227032] pci 0000:fe:04.2: [8086:2da2] type 00 class 0x060000
[    1.233033] pci 0000:fe:04.3: [8086:2da3] type 00 class 0x060000
[    1.239034] pci 0000:fe:05.0: [8086:2da8] type 00 class 0x060000
[    1.245033] pci 0000:fe:05.1: [8086:2da9] type 00 class 0x060000
[    1.251011] pci 0000:fe:05.2: [8086:2daa] type 00 class 0x060000
[    1.257031] pci 0000:fe:05.3: [8086:2dab] type 00 class 0x060000
[    1.263035] pci 0000:fe:06.0: [8086:2db0] type 00 class 0x060000
[    1.270033] pci 0000:fe:06.1: [8086:2db1] type 00 class 0x060000
[    1.276035] pci 0000:fe:06.2: [8086:2db2] type 00 class 0x060000
[    1.282033] pci 0000:fe:06.3: [8086:2db3] type 00 class 0x060000
[    1.288041] pci_bus 0000:fe: busn_res: [bus fe-ff] end is updated to f=
e
[    1.295002] pci_bus 0000:fe: busn_res: can not insert [bus fe] under d=
omain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    1.306004] PCI: Discovered peer bus ff
[    1.310001] PCI: root bus ff: using default resources
[    1.315001] PCI: Probing PCI hardware (bus ff)
[    1.320022] PCI host bridge to bus 0000:ff
[    1.324001] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    1.330002] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xfffff=
fffff]
[    1.338001] pci_bus 0000:ff: No busn resource found for root bus, will=
 use [bus ff-ff]
[    1.346002] pci_bus 0000:ff: busn_res: can not insert [bus ff] under d=
omain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    1.357004] pci 0000:ff:00.0: [8086:2c70] type 00 class 0x060000
[    1.363036] pci 0000:ff:00.1: [8086:2d81] type 00 class 0x060000
[    1.369040] pci 0000:ff:02.0: [8086:2d90] type 00 class 0x060000
[    1.375036] pci 0000:ff:02.1: [8086:2d91] type 00 class 0x060000
[    1.382033] pci 0000:ff:02.2: [8086:2d92] type 00 class 0x060000
[    1.388045] pci 0000:ff:02.3: [8086:2d93] type 00 class 0x060000
[    1.394038] pci 0000:ff:02.4: [8086:2d94] type 00 class 0x060000
[    1.400036] pci 0000:ff:02.5: [8086:2d95] type 00 class 0x060000
[    1.406037] pci 0000:ff:03.0: [8086:2d98] type 00 class 0x060000
[    1.412033] pci 0000:ff:03.1: [8086:2d99] type 00 class 0x060000
[    1.418036] pci 0000:ff:03.2: [8086:2d9a] type 00 class 0x060000
[    1.425037] pci 0000:ff:03.4: [8086:2d9c] type 00 class 0x060000
[    1.431037] pci 0000:ff:04.0: [8086:2da0] type 00 class 0x060000
[    1.437036] pci 0000:ff:04.1: [8086:2da1] type 00 class 0x060000
[    1.443035] pci 0000:ff:04.2: [8086:2da2] type 00 class 0x060000
[    1.449036] pci 0000:ff:04.3: [8086:2da3] type 00 class 0x060000
[    1.455037] pci 0000:ff:05.0: [8086:2da8] type 00 class 0x060000
[    1.462036] pci 0000:ff:05.1: [8086:2da9] type 00 class 0x060000
[    1.468036] pci 0000:ff:05.2: [8086:2daa] type 00 class 0x060000
[    1.474033] pci 0000:ff:05.3: [8086:2dab] type 00 class 0x060000
[    1.480038] pci 0000:ff:06.0: [8086:2db0] type 00 class 0x060000
[    1.486036] pci 0000:ff:06.1: [8086:2db1] type 00 class 0x060000
[    1.492038] pci 0000:ff:06.2: [8086:2db2] type 00 class 0x060000
[    1.498037] pci 0000:ff:06.3: [8086:2db3] type 00 class 0x060000
[    1.505045] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[    1.511002] pci_bus 0000:ff: busn_res: can not insert [bus ff] under d=
omain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    1.522004] PCI: pci_cache_line_size set to 64 bytes
[    1.529008] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    1.535002] e820: reserve RAM buffer [mem 0xbf30b000-0xbfffffff]
[    1.541002] e820: reserve RAM buffer [mem 0xbf3de000-0xbfffffff]
[    1.548001] e820: reserve RAM buffer [mem 0xbf800000-0xbfffffff]
[    1.554093] NetLabel: Initializing
[    1.557001] NetLabel:  domain hash size =3D 128
[    1.562000] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.567012] NetLabel:  unlabeled traffic allowed by default
[    1.573107] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.577946] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.586042] Switched to clocksource hpet
[    1.596267] pnp: PnP ACPI init
[    1.599448] ACPI: bus type PNP registered
[    1.603641] system 00:00: [mem 0xfc000000-0xfcffffff] has been reserve=
d
[    1.610370] system 00:00: [mem 0xfd000000-0xfdffffff] has been reserve=
d
[    1.617103] system 00:00: [mem 0xfe000000-0xfe9fffff] could not be res=
erved
[    1.624186] system 00:00: [mem 0xfea00000-0xfea0001f] has been reserve=
d
[    1.630918] system 00:00: [mem 0xfeb00000-0xfebfffff] has been reserve=
d
[    1.637653] system 00:00: [mem 0xfed00400-0xfed3ffff] could not be res=
erved
[    1.644733] system 00:00: [mem 0xfed45000-0xfedfffff] has been reserve=
d
[    1.651469] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    1.658519] system 00:01: [io  0x0290-0x029f] has been reserved
[    1.664555] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    1.671485] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:0)
[    1.679607] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 PNP030b =
(active)
[    1.687033] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:0)
[    1.695326] pnp 00:03: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 =
(active)
[    1.702940] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:0)
[    1.711045] pnp 00:04: [dma 0 disabled]
[    1.715033] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)=

[    1.721822] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:0)
[    1.729931] pnp 00:05: [dma 0 disabled]
[    1.733925] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)=

[    1.740641] pnp 00:06: [dma 4]
[    1.743827] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)=

[    1.750484] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:0)
[    1.758599] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    1.765261] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)=

[    1.771968] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    1.778010] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    1.784924] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:0)
[    1.793213] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)=

[    1.800007] system 00:0b: [io  0x0400-0x047f] could not be reserved
[    1.806392] system 00:0b: [io  0x1180-0x119f] has been reserved
[    1.812431] system 00:0b: [io  0x0500-0x057f] could not be reserved
[    1.818812] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserve=
d
[    1.825544] system 00:0b: [mem 0xfec00000-0xfecfffff] could not be res=
erved
[    1.832625] system 00:0b: [mem 0xff000000-0xffffffff] has been reserve=
d
[    1.839352] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    1.846351] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)=

[    1.853106] pnp: PnP ACPI: found 13 devices
[    1.857404] ACPI: bus type PNP unregistered
[    1.868010] pci 0000:00:1f.0: BAR 13: [io  0x0400-0x047f] has bogus al=
ignment
[    1.875267] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    1.880607] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.886820] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfff=
ff]
[    1.893729] pci 0000:00:03.0: PCI bridge to [bus 03]
[    1.898818] pci 0000:00:05.0: PCI bridge to [bus 04]
[    1.903906] pci 0000:00:07.0: PCI bridge to [bus 05]
[    1.908992] pci 0000:06:00.0: PCI bridge to [bus 07]
[    1.914081] pci 0000:06:00.2: PCI bridge to [bus 08]
[    1.919162] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    1.925370] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fff=
ff]
[    1.932279] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    1.937623] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    1.943829] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fff=
ff]
[    1.950738] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    1.955822] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    1.962029] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fff=
ff]
[    1.968936] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fff=
ff 64bit pref]
[    1.976859] pci 0000:00:1c.4: PCI bridge to [bus 0a]
[    1.981935] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    1.988143] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfff=
ff]
[    1.995049] pci 0000:00:1c.4:   bridge window [mem 0xd0200000-0xd03fff=
ff 64bit pref]
[    2.002971] pci 0000:00:1e.0: PCI bridge to [bus 0b]
[    2.008048] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    2.014256] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfff=
ff]
[    2.021162] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffff=
ff 64bit pref]
[    2.029086] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.034776] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.040462] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.046847] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
[    2.053227] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    2.058913] pci_bus 0000:01: resource 1 [mem 0xfba00000-0xfbbfffff]
[    2.065292] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    2.070977] pci_bus 0000:06: resource 1 [mem 0xfb700000-0xfb9fffff]
[    2.077355] pci_bus 0000:08: resource 0 [io  0xd000-0xdfff]
[    2.083041] pci_bus 0000:08: resource 1 [mem 0xfb700000-0xfb9fffff]
[    2.089427] pci_bus 0000:09: resource 0 [io  0xc000-0xcfff]
[    2.095113] pci_bus 0000:09: resource 1 [mem 0xfb400000-0xfb6fffff]
[    2.101500] pci_bus 0000:09: resource 2 [mem 0xd0000000-0xd01fffff 64b=
it pref]
[    2.108901] pci_bus 0000:0a: resource 0 [io  0xb000-0xbfff]
[    2.114587] pci_bus 0000:0a: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    2.120966] pci_bus 0000:0a: resource 2 [mem 0xd0200000-0xd03fffff 64b=
it pref]
[    2.128367] pci_bus 0000:0b: resource 0 [io  0xa000-0xafff]
[    2.134053] pci_bus 0000:0b: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    2.140432] pci_bus 0000:0b: resource 2 [mem 0xf0000000-0xf7ffffff 64b=
it pref]
[    2.147833] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    2.153517] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    2.159202] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    2.165581] pci_bus 0000:0b: resource 7 [mem 0xc0000000-0xffffffff]
[    2.171960] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]
[    2.177647] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xffffffffff]
[    2.184206] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    2.189891] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[    2.196475] NET: Registered protocol family 2
[    2.201200] TCP established hash table entries: 131072 (order: 8, 1048=
576 bytes)
[    2.209028] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s)
[    2.216008] TCP: Hash tables configured (established 131072 bind 65536=
)
[    2.222793] TCP: reno registered
[    2.226167] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    2.232431] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)=

[    2.239222] NET: Registered protocol family 1
[    2.243843] RPC: Registered named UNIX socket transport module.
[    2.249886] RPC: Registered udp transport module.
[    2.254711] RPC: Registered tcp transport module.
[    2.259529] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.266238] IOAPIC[0]: Set routing entry (0-16 -> 0x41 -> IRQ 16 Mode:=
1 Active:1 Dest:0)
[    2.274687] IOAPIC[0]: Set routing entry (0-19 -> 0x51 -> IRQ 19 Mode:=
1 Active:1 Dest:0)
[    2.283126] IOAPIC[0]: Set routing entry (0-18 -> 0x61 -> IRQ 18 Mode:=
1 Active:1 Dest:0)
[    2.291568] IOAPIC[0]: Set routing entry (0-23 -> 0x71 -> IRQ 23 Mode:=
1 Active:1 Dest:0)
[    2.300420] pci 0000:06:00.0: rerouting interrupts for [8086:0329]
[    2.306721] pci 0000:06:00.2: rerouting interrupts for [8086:032a]
[    2.313035] pci 0000:0b:01.0: Boot video device
[    2.317729] PCI: CLS 64 bytes, default 64
[    2.321903] Unpacking initramfs...
[    6.162558] Freeing initrd memory: 237980K (ffff88007178c000 - ffff880=
07fff3000)
[    6.170196] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    6.176753] software IO TLB [mem 0xbb30b000-0xbf30b000] (64MB) mapped =
at [ffff8800bb30b000-ffff8800bf30afff]
[    6.189405] futex hash table entries: 8192 (order: 7, 524288 bytes)
[    6.195890] Initialise system trusted keyring
[    6.200392] audit: initializing netlink subsys (disabled)
[    6.205928] audit: type=3D2000 audit(1400751626.204:1): initialized
[    6.232818] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    6.240595] zbud: loaded
[    6.243401] VFS: Disk quotas dquot_6.5.2
[    6.247480] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    6.254349] 9p: Installing v9fs 9p2000 file system support
[    6.259982] msgmni has been set to 32064
[    6.264072] Key type big_key registered
[    6.268029] SELinux:  Registering netfilter hooks
[    8.610386] alg: No test for stdrng (krng)
[    8.614663] NET: Registered protocol family 38
[    8.619235] Key type asymmetric registered
[    8.623446] Asymmetric key parser 'x509' registered
[    8.628482] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 250)
[    8.636145] io scheduler noop registered
[    8.640188] io scheduler deadline registered (default)
[    8.645471] io scheduler cfq registered
[    8.649680] IOAPIC[3]: Set routing entry (4-4 -> 0x81 -> IRQ 76 Mode:1=
 Active:1 Dest:0)
[    8.657899] pcieport 0000:00:01.0: irq 112 for MSI/MSI-X
[    8.663464] IOAPIC[3]: Set routing entry (4-0 -> 0xa1 -> IRQ 72 Mode:1=
 Active:1 Dest:0)
[    8.671672] pcieport 0000:00:03.0: irq 113 for MSI/MSI-X
[    8.677235] IOAPIC[3]: Set routing entry (4-2 -> 0xc1 -> IRQ 74 Mode:1=
 Active:1 Dest:0)
[    8.685440] pcieport 0000:00:05.0: irq 114 for MSI/MSI-X
[    8.692592] IOAPIC[3]: Set routing entry (4-6 -> 0xe1 -> IRQ 78 Mode:1=
 Active:1 Dest:0)
[    8.700798] pcieport 0000:00:07.0: irq 115 for MSI/MSI-X
[    8.706357] IOAPIC[3]: Set routing entry (4-8 -> 0x42 -> IRQ 80 Mode:1=
 Active:1 Dest:0)
[    8.714562] pcieport 0000:00:09.0: irq 116 for MSI/MSI-X
[    8.720132] IOAPIC[0]: Set routing entry (0-17 -> 0x62 -> IRQ 17 Mode:=
1 Active:1 Dest:0)
[    8.728429] pcieport 0000:00:1c.0: irq 117 for MSI/MSI-X
[    8.734034] pcieport 0000:00:1c.4: irq 118 for MSI/MSI-X
[    8.739571] aer 0000:00:01.0:pcie02: service driver aer loaded
[    8.745540] aer 0000:00:03.0:pcie02: service driver aer loaded
[    8.751504] aer 0000:00:05.0:pcie02: service driver aer loaded
[    8.757471] aer 0000:00:07.0:pcie02: service driver aer loaded
[    8.763436] aer 0000:00:09.0:pcie02: service driver aer loaded
[    8.769394] pcieport 0000:00:01.0: Signaling PME through PCIe PME inte=
rrupt
[    8.776474] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt=

[    8.783121] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt=

[    8.789768] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme load=
ed
[    8.796594] pcieport 0000:00:03.0: Signaling PME through PCIe PME inte=
rrupt
[    8.803679] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme load=
ed
[    8.810504] pcieport 0000:00:05.0: Signaling PME through PCIe PME inte=
rrupt
[    8.817578] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme load=
ed
[    8.824405] pcieport 0000:00:07.0: Signaling PME through PCIe PME inte=
rrupt
[    8.831482] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme load=
ed
[    8.838305] pcieport 0000:00:09.0: Signaling PME through PCIe PME inte=
rrupt
[    8.845381] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt=

[    8.852028] pci 0000:06:00.2: Signaling PME through PCIe PME interrupt=

[    8.858668] pci 0000:08:01.0: Signaling PME through PCIe PME interrupt=

[    8.865316] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme load=
ed
[    8.872152] pcieport 0000:00:1c.0: Signaling PME through PCIe PME inte=
rrupt
[    8.879233] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt=

[    8.885881] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme load=
ed
[    8.892713] pcieport 0000:00:1c.4: Signaling PME through PCIe PME inte=
rrupt
[    8.899790] pci 0000:0a:00.0: Signaling PME through PCIe PME interrupt=

[    8.906439] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme load=
ed
[    8.913266] ioapic: probe of 0000:00:13.0 failed with error -22
[    8.919307] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    8.925024] pciehp 0000:00:1c.0:pcie04: Slot #0 AttnBtn- AttnInd- PwrI=
nd- PwrCtrl- MRL- Interlock- NoCompl- LLActRep+
[    8.935868] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    8.942345] pciehp 0000:00:1c.4:pcie04: Slot #0 AttnBtn- AttnInd- PwrI=
nd- PwrCtrl- MRL- Interlock- NoCompl- LLActRep+
[    8.953187] pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
[    8.959666] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    8.966433] intel_idle: MWAIT substates: 0x1120
[    8.971082] intel_idle: v0.4 model 0x2C
[    8.975035] intel_idle: lapic_timer_reliable_states 0xffffffff
[    8.981807] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0C0E:00/input/input0
[    8.990342] ACPI: Sleep Button [SLPB]
[    8.994148] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0C0C:00/input/input1
[    9.002683] ACPI: Power Button [PWRB]
[    9.006489] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input2
[    9.014069] ACPI: Power Button [PWRF]
[    9.020482] ERST: Can not request [mem 0xbf3b303f-0xbf3b503e] for ERST=
=2E
[    9.031107] [Firmware Warn]: GHES: Poll interval is 0 for generic hard=
ware error source: 1, disabled.
[    9.040555] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[    9.047035] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    9.073951] 00:04: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200=
) is a 16550A
[    9.102026] 00:05: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 115200=
) is a 16550A
[    9.110218] Non-volatile memory driver v1.3
[    9.114540] Linux agpgart interface v0.103
[    9.119161] rdac: device handler registered
[    9.123730] hp_sw: device handler registered
[    9.128123] emc: device handler registered
[    9.132332] alua: device handler registered
[    9.136658] libphy: Fixed MDIO Bus: probed
[    9.140918] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k=
8-NAPI
[    9.148081] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    9.153958] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    9.159911] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    9.165965] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.=
0.5-k
[    9.173042] igb: Copyright (c) 2007-2014 Intel Corporation.
[    9.179053] igb 0000:01:00.0: irq 119 for MSI/MSI-X
[    9.184052] igb 0000:01:00.0: irq 120 for MSI/MSI-X
[    9.189051] igb 0000:01:00.0: irq 121 for MSI/MSI-X
[    9.194045] igb 0000:01:00.0: irq 122 for MSI/MSI-X
[    9.199044] igb 0000:01:00.0: irq 123 for MSI/MSI-X
[    9.204049] igb 0000:01:00.0: irq 124 for MSI/MSI-X
[    9.209047] igb 0000:01:00.0: irq 125 for MSI/MSI-X
[    9.214047] igb 0000:01:00.0: irq 126 for MSI/MSI-X
[    9.219048] igb 0000:01:00.0: irq 127 for MSI/MSI-X
[    9.224098] igb 0000:01:00.0: irq 128 for MSI/MSI-X
[    9.229102] igb 0000:01:00.0: irq 129 for MSI/MSI-X
[    9.234103] igb 0000:01:00.0: irq 130 for MSI/MSI-X
[    9.239101] igb 0000:01:00.0: irq 131 for MSI/MSI-X
[    9.244103] igb 0000:01:00.0: irq 132 for MSI/MSI-X
[    9.249103] igb 0000:01:00.0: irq 133 for MSI/MSI-X
[    9.254102] igb 0000:01:00.0: irq 134 for MSI/MSI-X
[    9.259096] igb 0000:01:00.0: irq 135 for MSI/MSI-X
[    9.264096] igb 0000:01:00.0: irq 136 for MSI/MSI-X
[    9.442488] igb 0000:01:00.0: added PHC on eth0
[    9.447136] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connec=
tion
[    9.454127] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:30:48:c=
f:17:26
[    9.461381] igb 0000:01:00.0: eth0: PBA No: Unknown
[    9.466374] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8=
 tx queue(s)
[    9.474214] IOAPIC[3]: Set routing entry (4-16 -> 0x24 -> IRQ 88 Mode:=
1 Active:1 Dest:0)
[    9.482717] igb 0000:01:00.1: irq 137 for MSI/MSI-X
[    9.487715] igb 0000:01:00.1: irq 138 for MSI/MSI-X
[    9.492715] igb 0000:01:00.1: irq 139 for MSI/MSI-X
[    9.497717] igb 0000:01:00.1: irq 140 for MSI/MSI-X
[    9.502716] igb 0000:01:00.1: irq 141 for MSI/MSI-X
[    9.507718] igb 0000:01:00.1: irq 142 for MSI/MSI-X
[    9.512723] igb 0000:01:00.1: irq 143 for MSI/MSI-X
[    9.517718] igb 0000:01:00.1: irq 144 for MSI/MSI-X
[    9.522720] igb 0000:01:00.1: irq 145 for MSI/MSI-X
[    9.527766] igb 0000:01:00.1: irq 146 for MSI/MSI-X
[    9.532766] igb 0000:01:00.1: irq 147 for MSI/MSI-X
[    9.537765] igb 0000:01:00.1: irq 148 for MSI/MSI-X
[    9.542766] igb 0000:01:00.1: irq 149 for MSI/MSI-X
[    9.547766] igb 0000:01:00.1: irq 150 for MSI/MSI-X
[    9.552768] igb 0000:01:00.1: irq 151 for MSI/MSI-X
[    9.557767] igb 0000:01:00.1: irq 152 for MSI/MSI-X
[    9.562766] igb 0000:01:00.1: irq 153 for MSI/MSI-X
[    9.567760] igb 0000:01:00.1: irq 154 for MSI/MSI-X
[    9.733464] igb 0000:01:00.1: added PHC on eth1
[    9.738110] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connec=
tion
[    9.745102] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:c=
f:17:27
[    9.752356] igb 0000:01:00.1: eth1: PBA No: Unknown
[    9.757348] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8=
 tx queue(s)
[    9.765110] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - ve=
rsion 3.19.1-k
[    9.773034] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    9.778961] usbcore: registered new interface driver catc
[    9.784478] usbcore: registered new interface driver kaweth
[    9.790168] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ether=
net driver
[    9.797750] usbcore: registered new interface driver pegasus
[    9.803528] usbcore: registered new interface driver rtl8150
[    9.809310] usbcore: registered new interface driver asix
[    9.814829] usbcore: registered new interface driver cdc_ether
[    9.820783] usbcore: registered new interface driver cdc_eem
[    9.826564] usbcore: registered new interface driver dm9601
[    9.832263] usbcore: registered new interface driver smsc75xx
[    9.838127] usbcore: registered new interface driver smsc95xx
[    9.843993] usbcore: registered new interface driver gl620a
[    9.849687] usbcore: registered new interface driver net1080
[    9.855467] usbcore: registered new interface driver plusb
[    9.861079] usbcore: registered new interface driver rndis_host
[    9.867117] usbcore: registered new interface driver cdc_subset
[    9.873155] usbcore: registered new interface driver zaurus
[    9.878850] usbcore: registered new interface driver MOSCHIP usb-ether=
net driver
[    9.886436] usbcore: registered new interface driver int51x1
[    9.892214] usbcore: registered new interface driver ipheth
[    9.897914] usbcore: registered new interface driver sierra_net
[    9.904090] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    9.910737] ehci-pci: EHCI PCI platform driver
[    9.915416] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    9.920894] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bu=
s number 1
[    9.928486] ehci-pci 0000:00:1a.7: debug port 1
[    9.937026] ehci-pci 0000:00:1a.7: cache line size of 64 is not suppor=
ted
[    9.943943] ehci-pci 0000:00:1a.7: irq 18, io mem 0xfbe23000
[    9.955082] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    9.960987] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    9.967897] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    9.975297] usb usb1: Product: EHCI Host Controller
[    9.980289] usb usb1: Manufacturer: Linux 3.15.0-rc5-wl-02776-geec4f9d=
 ehci_hcd
[    9.987777] usb usb1: SerialNumber: 0000:00:1a.7
[    9.992752] hub 1-0:1.0: USB hub found
[    9.996626] hub 1-0:1.0: 6 ports detected
[   10.000972] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   10.006504] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bu=
s number 2
[   10.014091] ehci-pci 0000:00:1d.7: debug port 1
[   10.022625] ehci-pci 0000:00:1d.7: cache line size of 64 is not suppor=
ted
[   10.029534] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfbe22000
[   10.041060] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   10.048542] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   10.055465] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[   10.062865] usb usb2: Product: EHCI Host Controller
[   10.067857] usb usb2: Manufacturer: Linux 3.15.0-rc5-wl-02776-geec4f9d=
 ehci_hcd
[   10.075345] usb usb2: SerialNumber: 0000:00:1d.7
[   10.080320] hub 2-0:1.0: USB hub found
[   10.084201] hub 2-0:1.0: 6 ports detected
[   10.088445] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   10.094745] ohci-pci: OHCI PCI platform driver
[   10.099318] uhci_hcd: USB Universal Host Controller Interface driver
[   10.105923] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   10.111463] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bu=
s number 3
[   10.119049] uhci_hcd 0000:00:1a.0: detected 2 ports
[   10.124067] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0c0
[   10.129966] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   10.136871] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[   10.144271] usb usb3: Product: UHCI Host Controller
[   10.149264] usb usb3: Manufacturer: Linux 3.15.0-rc5-wl-02776-geec4f9d=
 uhci_hcd
[   10.156751] usb usb3: SerialNumber: 0000:00:1a.0
[   10.161723] hub 3-0:1.0: USB hub found
[   10.165600] hub 3-0:1.0: 2 ports detected
[   10.169893] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   10.175347] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bu=
s number 4
[   10.182930] uhci_hcd 0000:00:1a.2: detected 2 ports
[   10.187948] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000f0a0
[   10.193868] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   10.200769] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[   10.208176] usb usb4: Product: UHCI Host Controller
[   10.213172] usb usb4: Manufacturer: Linux 3.15.0-rc5-wl-02776-geec4f9d=
 uhci_hcd
[   10.220660] usb usb4: SerialNumber: 0000:00:1a.2
[   10.225539] hub 4-0:1.0: USB hub found
[   10.229409] hub 4-0:1.0: 2 ports detected
[   10.233693] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   10.239151] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bu=
s number 5
[   10.246733] uhci_hcd 0000:00:1d.0: detected 2 ports
[   10.251744] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[   10.257640] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   10.264548] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[   10.271948] usb usb5: Product: UHCI Host Controller
[   10.276980] usb usb5: Manufacturer: Linux 3.15.0-rc5-wl-02776-geec4f9d=
 uhci_hcd
[   10.284510] usb usb5: SerialNumber: 0000:00:1d.0
[   10.289439] hub 5-0:1.0: USB hub found
[   10.293318] hub 5-0:1.0: 2 ports detected
[   10.297642] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   10.303093] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bu=
s number 6
[   10.310678] uhci_hcd 0000:00:1d.1: detected 2 ports
[   10.315686] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[   10.321585] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   10.328491] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[   10.335893] usb usb6: Product: UHCI Host Controller
[   10.340920] usb usb6: Manufacturer: Linux 3.15.0-rc5-wl-02776-geec4f9d=
 uhci_hcd
[   10.348453] usb usb6: SerialNumber: 0000:00:1d.1
[   10.353387] hub 6-0:1.0: USB hub found
[   10.357260] hub 6-0:1.0: 2 ports detected
[   10.361551] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   10.366997] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bu=
s number 7
[   10.374583] uhci_hcd 0000:00:1d.2: detected 2 ports
[   10.379595] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[   10.385486] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[   10.392390] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[   10.399790] usb usb7: Product: UHCI Host Controller
[   10.404818] usb usb7: Manufacturer: Linux 3.15.0-rc5-wl-02776-geec4f9d=
 uhci_hcd
[   10.412340] usb usb7: SerialNumber: 0000:00:1d.2
[   10.417264] hub 7-0:1.0: USB hub found
[   10.421134] hub 7-0:1.0: 2 ports detected
[   10.425393] usbcore: registered new interface driver usbserial
[   10.431353] usbcore: registered new interface driver usbserial_generic=

[   10.437998] usbserial: USB Serial support registered for generic
[   10.444147] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at=
 0x60,0x64 irq 1,12
[   10.454809] serio: i8042 KBD port at 0x60,0x64 irq 1
[   10.459913] serio: i8042 AUX port at 0x60,0x64 irq 12
[   10.465327] mousedev: PS/2 mouse device common for all mice
[   10.471901] rtc_cmos 00:07: RTC can wake from S4
[   10.476947] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   10.483190] rtc_cmos 00:07: alarms up to one year, y3k, 114 bytes nvra=
m, hpet irqs
[   10.490963] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   10.496668] iTCO_wdt: Found a ICH10R TCO device (Version=3D2, TCOBASE=3D=
0x0460)
[   10.504048] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   10.510177] iTCO_vendor_support: vendor-support=3D0
[   10.515364] hidraw: raw HID events driver (C) Jiri Kosina
[   10.520975] usbcore: registered new interface driver usbhid
[   10.526672] usbhid: USB HID core driver
[   10.530645] drop_monitor: Initializing network drop monitor service
[   10.537095] TCP: cubic registered
[   10.540530] Initializing XFRM netlink socket
[   10.545037] NET: Registered protocol family 10
[   10.550398] NET: Registered protocol family 17
[   10.554981] 9pnet: Installing 9P2000 support
[   10.560106]=20
[   10.560106] printing PIC contents
[   10.565084] ... PIC  IMR: ffff
[   10.566079] ... PIC  IRR: 0c20
[   10.571431] ... PIC  ISR: 0000
[   10.574608] ... PIC ELCR: 0e20
[   10.577781] printing local APIC contents on CPU#0/0:
[   10.578779] ... APIC ID:      00000000 (0)
[   10.578779] ... APIC VERSION: 01060015
[   10.578779] ... APIC TASKPRI: 00000000 (00)
[   10.578779] ... APIC PROCPRI: 00000000
[   10.578779] ... APIC LDR: 01000000
[   10.578779] ... APIC DFR: ffffffff
[   10.578779] ... APIC SPIV: 000001ff
[   10.578779] ... APIC ISR field:
[   10.578779] 0000000000000000000000000000000000000000000000000000000000=
000000
[   10.578779] ... APIC TMR field:
[   10.578779] 0000000000000000000000020002000000000000000000000000000000=
000000
[   10.578779] ... APIC IRR field:
[   10.578779] 0000000000000000000000000000000000000000000000000000000000=
000000
[   10.578779] ... APIC ESR: 00000000
[   10.578779] ... APIC ICR: 000000fd
[   10.578779] ... APIC ICR2: 23000000
[   10.578779] ... APIC LVTT: 000000ef
[   10.578779] ... APIC LVTPC: 00000400
[   10.578779] ... APIC LVT0: 00010700
[   10.578779] ... APIC LVT1: 00000400
[   10.578779] ... APIC LVTERR: 000000fe
[   10.578779] ... APIC TMICT: 0018b09c
[   10.578779] ... APIC TMCCT: 000a0e94
[   10.578779] ... APIC TDCR: 00000003
[   10.578779]=20
[   10.683794] number of MP IRQ sources: 15.
[   10.687968] number of IO-APIC #0 registers: 24.
[   10.692647] number of IO-APIC #2 registers: 24.
[   10.697328] number of IO-APIC #3 registers: 24.
[   10.702019] number of IO-APIC #4 registers: 24.
[   10.706706] testing the IO APIC.......................
[   10.712007] IO APIC #0......
[   10.715041] .... register #00: 00000000
[   10.719033] .......    : physical APIC id: 00
[   10.723544] .......    : Delivery Type: 0
[   10.727705] .......    : LTS          : 0
[   10.731872] .... register #01: 00170020
[   10.735856] .......     : max redirection entries: 17
[   10.741059] .......     : PRQ implemented: 0
[   10.745478] .......     : IO APIC version: 20
[   10.749986] .... IRQ redirection table:
[   10.753976] 1    0    0   0   0    0    0    00
[   10.758169] usb 5-2: new full-speed USB device number 2 using uhci_hcd=

[   10.765301] 0    0    0   0   0    0    0    31
[   10.769992] 0    0    0   0   0    0    0    30
[   10.774682] 0    0    0   0   0    0    0    33
[   10.779368] 0    0    0   0   0    0    0    34
[   10.784057] 0    0    0   0   0    0    0    35
[   10.788745] 0    0    0   0   0    0    0    36
[   10.793433] 0    0    0   0   0    0    0    37
[   10.798123] 0    0    0   0   0    0    0    38
[   10.802813] 0    1    0   0   0    0    0    39
[   10.807502] 0    0    0   0   0    0    0    3A
[   10.812193] 0    0    0   0   0    0    0    3B
[   10.816879] 0    0    0   0   0    0    0    3C
[   10.821567] 0    0    0   0   0    0    0    3D
[   10.826257] 0    0    0   0   0    0    0    3E
[   10.830945] 0    0    0   0   0    0    0    3F
[   10.835632] 0    1    0   1   0    0    0    41
[   10.840322] 1    1    0   1   0    0    0    62
[   10.845015] 0    1    0   1   0    0    0    61
[   10.849663] 0    1    0   1   0    0    0    51
[   10.854352] 1    0    0   0   0    0    0    00
[   10.859044] 1    0    0   0   0    0    2    FB
[   10.863729] 1    0    0   0   0    1    2    AC
[   10.868418] 0    1    0   1   0    0    0    71
[   10.874719] IO APIC #2......
[   10.877752] .... register #00: 02000000
[   10.881735] .......    : physical APIC id: 02
[   10.886242] .......    : Delivery Type: 0
[   10.890400] .......    : LTS          : 0
[   10.894563] .... register #01: 00178020
[   10.895703] usb 5-2: New USB device found, idVendor=3D0557, idProduct=3D=
8021
[   10.895706] usb 5-2: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[   10.897746] hub 5-2:1.0: USB hub found
[   10.899704] hub 5-2:1.0: 4 ports detected
[   10.920616] .......     : max redirection entries: 17
[   10.925824] .......     : PRQ implemented: 1
[   10.930242] .......     : IO APIC version: 20
[   10.934749] .... register #02: 02000000
[   10.938739] .......     : arbitration: 02
[   10.942901] .... register #03: 00000001
[   10.946894] .......     : Boot DT    : 1
[   10.950967] .... IRQ redirection table:
[   10.954952] 1    0    0   0   0    0    0    00
[   10.959635] 1    0    0   0   0    0    0    00
[   10.964321] 1    0    0   0   0    0    0    00
[   10.969005] 1    0    0   0   0    0    0    00
[   10.973691] 1    0    0   0   0    0    0    00
[   10.978372] 1    0    0   0   0    0    0    00
[   10.983057] 1    0    0   0   0    0    0    00
[   10.987739] 1    0    0   0   0    0    0    00
[   10.992420] 1    0    0   0   0    0    0    00
[   10.997106] 1    0    0   0   0    0    0    00
[   11.001790] 1    0    0   0   0    0    0    00
[   11.006480] 1    0    0   0   0    0    0    00
[   11.011166] 1    0    0   0   0    0    0    00
[   11.015851] 1    0    0   0   0    0    0    00
[   11.020533] 1    0    0   0   0    0    0    00
[   11.025217] 1    0    0   0   0    0    0    00
[   11.029909] 1    0    0   0   0    0    0    00
[   11.034593] 1    0    0   0   0    0    0    00
[   11.039282] 1    0    0   0   0    0    0    00
[   11.043971] 1    0    0   0   0    0    0    00
[   11.048658] 1    0    0   0   0    0    0    00
[   11.053347] 1    0    0   0   0    0    0    00
[   11.058038] 1    0    0   0   0    0    0    00
[   11.062724] 1    0    0   0   0    0    0    00
[   11.067415] IO APIC #3......
[   11.070446] .... register #00: 03000000
[   11.074429] .......    : physical APIC id: 03
[   11.078938] .......    : Delivery Type: 0
[   11.083099] .......    : LTS          : 0
[   11.087260] .... register #01: 00178020
[   11.091243] .......     : max redirection entries: 17
[   11.096443] .......     : PRQ implemented: 1
[   11.100864] .......     : IO APIC version: 20
[   11.105374] .... register #02: 03000000
[   11.109366] .......     : arbitration: 03
[   11.113526] .... register #03: 00000001
[   11.117557] .......     : Boot DT    : 1
[   11.121630] .... IRQ redirection table:
[   11.125617] 1    0    0   0   0    0    0    00
[   11.130308] 1    0    0   0   0    0    0    00
[   11.134995] 1    0    0   0   0    0    0    00
[   11.139674] 1    0    0   0   0    0    0    00
[   11.144357] 1    0    0   0   0    0    0    00
[   11.149044] 1    0    0   0   0    0    0    00
[   11.153734] 1    0    0   0   0    0    0    00
[   11.158420] 1    0    0   0   0    0    0    00
[   11.163100] 1    0    0   0   0    0    0    00
[   11.167779] 1    0    0   0   0    0    0    00
[   11.172462] 1    0    0   0   0    0    0    00
[   11.176697] usb 5-2.1: new low-speed USB device number 3 using uhci_hc=
d
[   11.183875] 1    0    0   0   0    0    0    00
[   11.188555] 1    0    0   0   0    0    0    00
[   11.193245] 1    0    0   0   0    0    0    00
[   11.197935] 1    0    0   0   0    0    0    00
[   11.202624] 1    0    0   0   0    0    0    00
[   11.207310] 1    0    0   0   0    0    0    00
[   11.211997] 1    0    0   0   0    0    0    00
[   11.216679] 1    0    0   0   0    0    0    00
[   11.221365] 1    0    0   0   0    0    0    00
[   11.226049] 1    0    0   0   0    0    0    00
[   11.230739] 1    0    0   0   0    0    0    00
[   11.235425] 1    0    0   0   0    0    0    00
[   11.240113] 1    0    0   0   0    0    0    00
[   11.244803] IO APIC #4......
[   11.247834] .... register #00: 04000000
[   11.251820] .......    : physical APIC id: 04
[   11.256327] .......    : Delivery Type: 0
[   11.260488] .......    : LTS          : 0
[   11.264645] .... register #01: 00170020
[   11.268634] .......     : max redirection entries: 17
[   11.273841] .......     : PRQ implemented: 0
[   11.278262] .......     : IO APIC version: 20
[   11.282771] .... register #02: 00000000
[   11.286720] .......     : arbitration: 00
[   11.290879] .... register #03: 00000001
[   11.294867] .......     : Boot DT    : 1
[   11.298943] .... IRQ redirection table:
[   11.302929] 1    1    0   1   0    0    0    A1
[   11.307618] 1    0    0   0   0    0    0    00
[   11.312307] 1    1    0   1   0    0    0    C1
[   11.316994] 1    0    0   0   0    0    0    00
[   11.321673] 1    1    0   1   0    0    0    81
[   11.326359] 1    0    0   0   0    0    0    00
[   11.331046] 1    1    0   1   0    0    0    E1
[   11.335738] 1    0    0   0   0    0    0    00
[   11.340423] 1    1    0   1   0    0    0    42
[   11.345113] 1    0    0   0   0    0    0    00
[   11.349801] 1    0    0   0   0    0    0    00
[   11.351698] usb 5-2.1: New USB device found, idVendor=3D0557, idProduc=
t=3D2261
[   11.351700] usb 5-2.1: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[   11.351702] usb 5-2.1: Product: CS1716A V1.0.098
[   11.351704] usb 5-2.1: Manufacturer: ATEN International Co. Ltd
[   11.379727] 1    0    0   0   0    0    0    00
[   11.384413] 1    0    0   0   0    0    0    00
[   11.385922] input: ATEN International Co. Ltd CS1716A V1.0.098 as /dev=
ices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.0/0003:0557:2261.0001=
/input/input6
[   11.386198] hid-generic 0003:0557:2261.0001: input,hidraw0: USB HID v1=
=2E00 Keyboard [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:=
00:1d.0-2.1/input0
[   11.417765] 1    0    0   0   0    0    0    00
[   11.422452] 1    0    0   0   0    0    0    00
[   11.424798] input: ATEN International Co. Ltd CS1716A V1.0.098 as /dev=
ices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.1/0003:0557:2261.0002=
/input/input7
[   11.425094] hid-generic 0003:0557:2261.0002: input,hidraw1: USB HID v1=
=2E00 Device [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00=
:1d.0-2.1/input1
[   11.445895] input: ATEN International Co. Ltd CS1716A V1.0.098 as /dev=
ices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.2/0003:0557:2261.0003=
/input/input8
[   11.446327] hid-generic 0003:0557:2261.0003: input,hidraw2: USB HID v1=
=2E10 Mouse [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:=
1d.0-2.1/input2
[   11.483911] 1    0    0   0   0    0    0    00
[   11.488596] 1    1    0   1   0    0    0    24
[   11.493284] 1    0    0   0   0    0    0    00
[   11.497971] 1    0    0   0   0    0    0    00
[   11.502656] 1    0    0   0   0    0    0    00
[   11.507339] 1    0    0   0   0    0    0    00
[   11.512025] 1    0    0   0   0    0    0    00
[   11.516711] 1    0    0   0   0    0    0    00
[   11.521400] 1    0    0   0   0    0    0    00
[   11.526087] IRQ to pin mappings:
[   11.529466] IRQ0 -> 0:2
[   11.532234] IRQ1 -> 0:1
[   11.534965] IRQ3 -> 0:3
[   11.537737] IRQ4 -> 0:4
[   11.540502] IRQ5 -> 0:5
[   11.543271] IRQ6 -> 0:6
[   11.545997] IRQ7 -> 0:7
[   11.548761] IRQ8 -> 0:8
[   11.551525] IRQ9 -> 0:9
[   11.554295] IRQ10 -> 0:10
[   11.557229] IRQ11 -> 0:11
[   11.560175] IRQ12 -> 0:12
[   11.563121] IRQ13 -> 0:13
[   11.566065] IRQ14 -> 0:14
[   11.568998] IRQ15 -> 0:15
[   11.571944] IRQ16 -> 0:16
[   11.574881] IRQ17 -> 0:17
[   11.577812] IRQ18 -> 0:18
[   11.580751] IRQ19 -> 0:19
[   11.583688] IRQ23 -> 0:23
[   11.586635] IRQ72 -> 3:0
[   11.589487] IRQ74 -> 3:2
[   11.592344] IRQ76 -> 3:4
[   11.595201] IRQ78 -> 3:6
[   11.598052] IRQ80 -> 3:8
[   11.600900] IRQ88 -> 3:16
[   11.603846] .................................... done.
[   11.609624] Loading compiled-in X.509 certificates
[   11.615445] Loaded X.509 cert 'Magrathea: Glacier signing key: 9cf8f03=
36be3f4af4d3c86fadacad78d73c74d93'
[   11.625121] registered taskstats version 1
[   11.632315] Key type trusted registered
[   11.638950] Key type encrypted registered
[   11.645578] ima: No TPM chip found, activating TPM-bypass!
[   11.651228] evm: HMAC attrs: 0x1
[   11.656456] rtc_cmos 00:07: setting system clock to 2014-05-22 09:40:3=
5 UTC (1400751635)
[   11.774067] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   11.889067] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   20.044614] igb: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contro=
l: RX/TX
[   20.052136] igb 0000:01:00.0 eth0: Link Speed was downgraded by SmartS=
peed
[   20.062143] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.073073] Sending DHCP requests ., OK
[   20.113230] IP-Config: Got DHCP answer from 192.168.1.1, my address is=
 192.168.1.67
[   20.278590] IP-Config: Complete:
[   20.281942]      device=3Deth0, hwaddr=3D00:30:48:cf:17:26, ipaddr=3D1=
92.168.1.67, mask=3D255.255.255.0, gw=3D192.168.1.1
[   20.292212]      host=3Dlkp-ws02, domain=3Dlkp.intel.com, nis-domain=3D=
(none)
[   20.298945]      bootserver=3D192.168.1.1, rootserver=3D192.168.1.1, r=
ootpath=3D
[   20.305696]      nameserver0=3D192.168.1.1
[   20.310100] PM: Hibernation image not present or could not be loaded.
[   20.319266] Freeing unused kernel memory: 1724K (ffffffff81c50000 - ff=
ffffff81dff000)
[   20.498519] EDAC MC: Ver: 3.0.0
[   20.498566] shpchp: Standard Hot Plug PCI Controller Driver version: 0=
=2E4
[   20.509894] ipmi message handler version 39.2
[   20.516902] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   20.523235] EDAC MC1: Giving out device to module i7core_edac.c contro=
ller i7 core #1: DEV 0000:fe:03.0 (POLLED)
[   20.533729] EDAC PCI0: Giving out device to module i7core_edac control=
ler EDAC PCI controller: DEV 0000:fe:03.0 (POLLED)
[   20.544927] EDAC MC0: Giving out device to module i7core_edac.c contro=
ller i7 core #0: DEV 0000:ff:03.0 (POLLED)
[   20.555369] EDAC PCI1: Giving out device to module i7core_edac control=
ler EDAC PCI controller: DEV 0000:ff:03.0 (POLLED)
[   20.566442] EDAC i7core: Driver loaded, 2 memory controller(s) found.
[   20.575234] IPMI System Interface driver.
[   20.575475] libata version 3.00 loaded.
[   20.583452] ipmi_si: probing via SMBIOS
[   20.587419] Fusion MPT base driver 3.04.20
[   20.587420] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   20.587422] ipmi_si: Adding SMBIOS-specified kcs state machine
[   20.587423] ipmi_si: probing via SPMI
[   20.587424] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
[   20.587425] ipmi_si: Adding SPMI-specified kcs state machine duplicate=
 interface
[   20.587426] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o =
address 0xca2, slave address 0x20, irq 0
[   20.587432] ipmi_si: Interface detection failed
[   20.635641] Copyright (c) 1999-2008 LSI Corporation
[   20.635776] input: PC Speaker as /devices/platform/pcspkr/input/input9=

[   20.659698] scsi0 : pata_jmicron
[   20.663973] scsi1 : pata_jmicron
[   20.667393] ata1: PATA max UDMA/100 cmd 0xb040 ctl 0xb030 bmdma 0xb000=
 irq 16
[   20.674649] ata2: PATA max UDMA/100 cmd 0xb020 ctl 0xb010 bmdma 0xb008=
 irq 16
[   20.687962] Fusion MPT SAS Host driver 3.04.20
[   20.687993] ahci 0000:00:1f.2: version 3.0
[   20.688170] ahci 0000:00:1f.2: irq 155 for MSI/MSI-X
[   20.688247] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps =
0x3f impl SATA mode
[   20.688249] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum =
part ccc ems sxs=20
[   20.698996] scsi2 : ahci
[   20.699474] scsi3 : ahci
[   20.699933] scsi4 : ahci
[   20.700333] scsi5 : ahci
[   20.700680] scsi6 : ahci
[   20.701069] scsi7 : ahci
[   20.701123] ata3: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21=
100 irq 155
[   20.701125] ata4: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21=
180 irq 155
[   20.701127] ata5: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21=
200 irq 155
[   20.701129] ata6: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21=
280 irq 155
[   20.701131] ata7: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21=
300 irq 155
[   20.701132] ata8: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21=
380 irq 155
[   20.780671] mptbase: ioc0: Initiating bringup
[   20.810419] Error: Driver 'pcspkr' is already registered, aborting...
[   21.006107] ata7: SATA link down (SStatus 0 SControl 300)
[   21.011657] ata5: SATA link down (SStatus 0 SControl 300)
[   21.017253] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   21.023637] ata6: SATA link down (SStatus 0 SControl 300)
[   21.029241] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   21.035646] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   21.042106] ata8.00: ATAPI: Slimtype DVD A  DS8A2S, 6P5D, max UDMA/100=

[   21.049059] ata3.00: ATA-8: WDC WD1002FAEX-00Z3A0, 05.01D05, max UDMA/=
133
[   21.055984] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31=
/32), AA
[   21.062117] ioc0: LSISAS1068E B2: Capabilities=3D{Initiator}
[   21.071309] ata3.00: configured for UDMA/133
[   21.075775] ata8.00: configured for UDMA/100
[   21.076084] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 =
1D05 PQ: 0 ANSI: 5
[   21.088492] ata4.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[   21.094321] ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/=
32)
[   21.144185] ata4.00: configured for UDMA/133
[   21.148736] scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      =
E    PQ: 0 ANSI: 5
[   21.160329] scsi 7:0:0:0: CD-ROM            Slimtype DVD A  DS8A2S    =
6P5D PQ: 0 ANSI: 5
[   21.223530] sr0: scsi3-mmc drive: 24x/6x writer dvd-ram cd/rw xa/form2=
 cdda pop-up
[   21.231302] cdrom: Uniform CD-ROM driver Revision: 3.20
[   21.236931] sr 7:0:0:0: Attached scsi CD-ROM sr0
[   21.243586] sd 3:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 =
GB/298 GiB)
[   21.243665] sd 2:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.0=
0 TB/931 GiB)
[   21.243996] sd 2:0:0:0: [sda] Write Protect is off
[   21.243999] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   21.244178] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[   21.278517] sd 3:0:0:0: [sdb] Write Protect is off
[   21.282411]  sda: sda1 sda2 sda3
[   21.283756] sd 2:0:0:0: [sda] Attached SCSI disk
[   21.291522] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   21.296793] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[   21.308085] sd 2:0:0:0: Attached scsi generic sg0 type 0
[   21.313702] sd 3:0:0:0: Attached scsi generic sg1 type 0
[   21.319297] sr 7:0:0:0: Attached scsi generic sg2 type 5
[   21.325554]  sdb: sdb1 sdb2
[   21.329039] sd 3:0:0:0: [sdb] Attached SCSI disk
[   21.515850] random: nonblocking pool is initialized
[   23.527211] floppy0: no floppy controllers found
[   39.895296] scsi8 : ioc0: LSISAS1068E B2, FwRev=3D01120000h, Ports=3D1=
, MaxQ=3D511, IRQ=3D16
[   39.932764] mptsas: ioc0: add expander: num_phys 25, sas_addr (0x50001=
55d25e3423f)
[   40.032065] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 3=
6, phy 0, sas_addr 0x5000155d25e34200
[   40.044906] scsi 8:0:0:0: Direct-Access     ATA      ST31000528AS     =
CC35 PQ: 0 ANSI: 5
[   40.058183] sd 8:0:0:0: Attached scsi generic sg3 type 0
[   40.058607] sd 8:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.0=
0 TB/931 GiB)
[   40.072857] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 28=
, phy 1, sas_addr 0x5000c500022c41a5
[   40.083869] scsi 8:0:1:0: Direct-Access     SEAGATE  ST3300555SS      =
XRT0 PQ: 0 ANSI: 5
[   40.095836] sd 8:0:1:0: Attached scsi generic sg4 type 0
[   40.101351] sd 8:0:0:0: [sdc] Write Protect is off
[   40.106280] sd 8:0:0:0: [sdc] Mode Sense: 73 00 00 08
[   40.124289] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 32=
, phy 2, sas_addr 0x5000c50013005f59
[   40.124334] sd 8:0:1:0: [sdd] 585937500 512-byte logical blocks: (300 =
GB/279 GiB)
[   40.141877] sd 8:0:0:0: [sdc] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[   40.142944] scsi 8:0:2:0: Direct-Access     SEAGATE  ST3300656SS      =
HS09 PQ: 0 ANSI: 5
[   40.143324] sd 8:0:1:0: [sdd] Write Protect is off
[   40.143326] sd 8:0:1:0: [sdd] Mode Sense: b3 00 10 08
[   40.145738] sd 8:0:1:0: [sdd] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   40.167525] sd 8:0:2:0: Attached scsi generic sg5 type 0
[   40.168000] sd 8:0:2:0: [sde] 585937500 512-byte logical blocks: (300 =
GB/279 GiB)
[   40.190599] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 30=
, phy 3, sas_addr 0x5000c500130fe681
[   40.191481] sd 8:0:2:0: [sde] Write Protect is off
[   40.191483] sd 8:0:2:0: [sde] Mode Sense: b3 00 10 08
[   40.191776] scsi 8:0:3:0: Direct-Access     SEAGATE  ST3300656SS      =
HS09 PQ: 0 ANSI: 5
[   40.193166] sd 8:0:2:0: [sde] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   40.216080] sd 8:0:3:0: Attached scsi generic sg6 type 0
[   40.216114]  sdd: sdd1 sdd2
[   40.216559] sd 8:0:3:0: [sdf] 585937500 512-byte logical blocks: (300 =
GB/279 GiB)
[   40.237089] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 15=
, phy 4, sas_addr 0x5000c500022d25dd
[   40.240029] scsi 8:0:4:0: Direct-Access     SEAGATE  ST3300555SS      =
XRT0 PQ: 0 ANSI: 5
[   40.240497] sd 8:0:3:0: [sdf] Write Protect is off
[   40.240499] sd 8:0:3:0: [sdf] Mode Sense: b3 00 10 08
[   40.242825] sd 8:0:3:0: [sdf] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   40.243001]  sde: sde1 sde2
[   40.264830] sd 8:0:4:0: Attached scsi generic sg7 type 0
[   40.265080] sd 8:0:1:0: [sdd] Attached SCSI disk
[   40.285656] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 14=
, phy 5, sas_addr 0x5000c500022d09b5
[   40.288048] sd 8:0:4:0: [sdg] 585937500 512-byte logical blocks: (300 =
GB/279 GiB)
[   40.288645] scsi 8:0:5:0: Direct-Access     SEAGATE  ST3300555SS      =
XRT0 PQ: 0 ANSI: 5
[   40.290174] sd 8:0:4:0: [sdg] Write Protect is off
[   40.290177] sd 8:0:4:0: [sdg] Mode Sense: b3 00 10 08
[   40.291131] sd 8:0:2:0: [sde] Attached SCSI disk
[   40.292414] sd 8:0:5:0: Attached scsi generic sg8 type 0
[   40.292456] sd 8:0:4:0: [sdg] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   40.292463]  sdf: sdf1 sdf2
[   40.336151] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 19=
, phy 6, sas_addr 0x5000c500022c3f65
[   40.336429] sd 8:0:5:0: [sdh] 585937500 512-byte logical blocks: (300 =
GB/279 GiB)
[   40.358214] scsi 8:0:6:0: Direct-Access     SEAGATE  ST3300555SS      =
XRT0 PQ: 0 ANSI: 5
[   40.359700] sd 8:0:5:0: [sdh] Write Protect is off
[   40.359703] sd 8:0:5:0: [sdh] Mode Sense: b3 00 10 08
[   40.361435] sd 8:0:3:0: [sdf] Attached SCSI disk
[   40.361846] sd 8:0:6:0: Attached scsi generic sg9 type 0
[   40.361925] sd 8:0:5:0: [sdh] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   40.405608] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 17=
, phy 7, sas_addr 0x5000c500022d2a0d
[   40.405877] sd 8:0:6:0: [sdi] 585937500 512-byte logical blocks: (300 =
GB/279 GiB)
[   40.425509]  sdg: sdg1 sdg2
[   40.425599] scsi 8:0:7:0: Direct-Access     SEAGATE  ST3300555SS      =
XRT0 PQ: 0 ANSI: 5
[   40.447515] sd 8:0:6:0: [sdi] Write Protect is off
[   40.452309] sd 8:0:7:0: Attached scsi generic sg10 type 0
[   40.457970] sd 8:0:6:0: [sdi] Mode Sense: b3 00 10 08
[   40.473080] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 16=
, phy 8, sas_addr 0x5000c500022d0f35
[   40.483389] sd 8:0:7:0: [sdj] 585937500 512-byte logical blocks: (300 =
GB/279 GiB)
[   40.491188] sd 8:0:6:0: [sdi] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   40.491574]  sdh: sdh1 sdh2
[   40.491736] sd 8:0:4:0: [sdg] Attached SCSI disk
[   40.491744] scsi 8:0:8:0: Direct-Access     SEAGATE  ST3300555SS      =
XRT0 PQ: 0 ANSI: 5
[   40.514229] sd 8:0:7:0: [sdj] Write Protect is off
[   40.514232] sd 8:0:7:0: [sdj] Mode Sense: b3 00 10 08
[   40.516420] sd 8:0:7:0: [sdj] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   40.516512] sd 8:0:8:0: Attached scsi generic sg11 type 0
[   40.560180] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 33=
, phy 9, sas_addr 0x5000c500130e21cd
[   40.581747] sd 8:0:8:0: [sdk] 585937500 512-byte logical blocks: (300 =
GB/279 GiB)
[   40.603327] scsi 8:0:9:0: Direct-Access     SEAGATE  ST3300656SS      =
HS09 PQ: 0 ANSI: 5
[   40.603825] sd 8:0:5:0: [sdh] Attached SCSI disk
[   40.623333] sd 8:0:8:0: [sdk] Write Protect is off
[   40.628260] sd 8:0:8:0: [sdk] Mode Sense: b3 00 10 08
[   40.635767] sd 8:0:8:0: [sdk] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   40.645047] sd 8:0:9:0: Attached scsi generic sg12 type 0
[   40.666090]  sdc: sdc1 sdc2 sdc3
[   40.669565] sd 8:0:9:0: [sdl] 585937500 512-byte logical blocks: (300 =
GB/279 GiB)
[   40.670247] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 31=
, phy 10, sas_addr 0x5000c500130f4f4d
[   40.670525]  sdj: sdj1 sdj2
[   40.713459] scsi 8:0:10:0: Direct-Access     SEAGATE  ST3300656SS     =
 HS09 PQ: 0 ANSI: 5
[   40.721993]  sdi: sdi1 sdi2
[   40.723339] sd 8:0:9:0: [sdl] Write Protect is off
[   40.723342] sd 8:0:9:0: [sdl] Mode Sense: b3 00 10 08
[   40.725591] sd 8:0:9:0: [sdl] Write cache: disabled, read cache: enabl=
ed, supports DPO and FUA
[   40.725817] sd 8:0:10:0: Attached scsi generic sg13 type 0
[   40.747274] sd 8:0:10:0: [sdm] 585937500 512-byte logical blocks: (300=
 GB/279 GiB)
[   40.747772] sd 8:0:7:0: [sdj] Attached SCSI disk
[   40.748389] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 35=
, phy 11, sas_addr 0x5000c50017cc2595
[   40.748438]  sdk: sdk1 sdk2
[   40.768692] scsi 8:0:11:0: Direct-Access     SEAGATE  ST3300657SS     =
 0006 PQ: 0 ANSI: 5
[   40.770730] sd 8:0:10:0: [sdm] Write Protect is off
[   40.770732] sd 8:0:10:0: [sdm] Mode Sense: b3 00 10 08
[   40.773258] sd 8:0:10:0: [sdm] Write cache: disabled, read cache: enab=
led, supports DPO and FUA
[   40.773882] sd 8:0:11:0: Attached scsi generic sg14 type 0
[   40.796257] sd 8:0:11:0: [sdn] 585937500 512-byte logical blocks: (300=
 GB/279 GiB)
[   40.796895] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 34=
, phy 24, sas_addr 0x5000155d25e3423e
[   40.797268]  sdl: sdl1 sdl2
[   40.798335] sd 8:0:8:0: [sdk] Attached SCSI disk
[   40.798535] sd 8:0:11:0: [sdn] Write Protect is off
[   40.798538] sd 8:0:11:0: [sdn] Mode Sense: bb 00 10 08
[   40.800024] sd 8:0:11:0: [sdn] Write cache: enabled, read cache: enabl=
ed, supports DPO and FUA
[   40.800426] scsi 8:0:12:0: Enclosure         PROMISE  2U-SAS-12-S BP  =
 0301 PQ: 0 ANSI: 5
[   40.800482] sd 8:0:0:0: [sdc] Attached SCSI disk
[   40.820492]  sdm: sdm1 sdm2
[   40.824315] sd 8:0:9:0: [sdl] Attached SCSI disk
[   40.827659] sd 8:0:10:0: [sdm] Attached SCSI disk
[   40.828174]  sdn: sdn1 sdn2
[   40.830194] scsi 8:0:12:0: Attached scsi generic sg15 type 13
[   40.834032] sd 8:0:11:0: [sdn] Attached SCSI disk
[   40.917967] sd 8:0:6:0: [sdi] Attached SCSI disk
[   41.337358] ses 8:0:12:0: Attached Enclosure device
[   41.350362] xor: measuring software checksum speed
[   41.365017]    prefetch64-sse:  6560.000 MB/sec
[   41.379018]    generic_sse:  5780.000 MB/sec
[   41.383416] xor: using function: prefetch64-sse (6560.000 MB/sec)
[   41.417039] raid6: sse2x1    6652 MB/s
[   41.437046] raid6: sse2x2    7839 MB/s
[   41.457030] raid6: sse2x4    8617 MB/s
[   41.460917] raid6: using algorithm sse2x4 (8617 MB/s)
[   41.466111] raid6: using ssse3x2 recovery algorithm
[   41.493612] Btrfs loaded
[   41.500543] BTRFS: device fsid f3082e2d-7b16-4b16-8027-d9ef0ff805ff de=
vid 1 transid 44 /dev/sdc1
[   41.541820] fuse init (API version 7.23)
[   41.974487] device-mapper: uevent: version 1.0.3
[   41.979465] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialise=
d: dm-devel@redhat.com

=3D=3D> /lkp/lkp/src/tmp/run_log <=3D=3D
Kernel tests: Boot OK!
PATH=3D/sbin:/usr/sbin:/bin:/usr/bin

=3D=3D> /lkp/lkp/src/tmp/err_log <=3D=3D

=3D=3D> /lkp/lkp/src/tmp/run_log <=3D=3D
downloading latest lkp src code
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=3D/lkp/lkp/src
RESULT_ROOT=3D/result/lkp-ws02/hackbench/1600%-process-pipe/x86_64-rhel/e=
ec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34/0
job=3D/lkp/scheduled/lkp-ws02/cyclic_hackbench-1600%-process-pipe-HEAD-ee=
c4f9d2bbf0a0902dc1ddc2f3864e655bda3e34.yaml
run-job /lkp/scheduled/lkp-ws02/cyclic_hackbench-1600%-process-pipe-HEAD-=
eec4f9d2bbf0a0902dc1ddc2f3864e655bda3e34.yaml
run: /lkp/lkp/src/setup/cpufreq_governor	{}
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu0/cpufr=
eq/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu1/cpufr=
eq/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu10/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu11/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu12/cpuf=
req/scaling_governor
run: /lkp/lkp/src/monitors/event/wait pre-test	{}
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu13/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu14/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu15/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu16/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu17/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu18/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu19/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu2/cpufr=
eq/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu20/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu21/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu22/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu23/cpuf=
req/scaling_governor
2014-05-22 09:41:28 echo performance > /sys/devices/system/cpu/cpu3/cpufr=
eq/scaling_governor
2014-05-22 09:41:29 echo performance > /sys/devices/system/cpu/cpu4/cpufr=
eq/scaling_governor
2014-05-22 09:41:29 echo performance > /sys/devices/system/cpu/cpu5/cpufr=
eq/scaling_governor
2014-05-22 09:41:29 echo performance > /sys/devices/system/cpu/cpu6/cpufr=
eq/scaling_governor
2014-05-22 09:41:29 echo performance > /sys/devices/system/cpu/cpu7/cpufr=
eq/scaling_governor
2014-05-22 09:41:29 echo performance > /sys/devices/system/cpu/cpu8/cpufr=
eq/scaling_governor
2014-05-22 09:41:29 echo performance > /sys/devices/system/cpu/cpu9/cpufr=
eq/scaling_governor
run: /lkp/lkp/src/setup/nr_threads 1600%	{}
run: /lkp/lkp/src/monitors/no-stdout/wrapper perf-profile	{"freq"=3D>"800=
"}
run: pre-test
run: /lkp/lkp/src/monitors/wrapper uptime	{}
run: /lkp/lkp/src/monitors/wrapper iostat	{}
run: /lkp/lkp/src/monitors/wrapper vmstat	{}
run: /lkp/lkp/src/monitors/wrapper numa-numastat	{}
run: /lkp/lkp/src/monitors/wrapper numa-vmstat	{}
run: /lkp/lkp/src/monitors/wrapper numa-meminfo	{}
run: /lkp/lkp/src/monitors/wrapper proc-vmstat	{}
run: /lkp/lkp/src/monitors/wrapper meminfo	{}
run: /lkp/lkp/src/monitors/wrapper slabinfo	{}
run: /lkp/lkp/src/monitors/wrapper interrupts	{}
run: /lkp/lkp/src/monitors/wrapper lock_stat	{}
run: /lkp/lkp/src/monitors/wrapper latency_stats	{}
run: /lkp/lkp/src/monitors/wrapper softirqs	{}
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping	{}
run: /lkp/lkp/src/monitors/wrapper diskstats	{}
run: /lkp/lkp/src/monitors/wrapper zoneinfo	{}
run: /lkp/lkp/src/monitors/wrapper energy	{}
run: /lkp/lkp/src/monitors/wrapper cpuidle	{}
run: /lkp/lkp/src/monitors/wrapper turbostat	{}
run: /usr/bin/time -v -o /lkp/lkp/src/tmp/time /lkp/lkp/src/tests/wrapper=
 hackbench	{"mode"=3D>"process", "ipc"=3D>"pipe"}
[  165.001824] BUG: unable to handle kernel NULL pointer dereference at 0=
0000000000000eb
[  165.009126] IP: [<ffffffff811404d3>] SYSC_perf_event_open+0x313/0xc00
[  165.015062] PGD 3cbb7f067 PUD 3a215e067 PMD 0=20
[  165.018631] Oops: 0000 [#1] SMP=20
[  165.024064] Modules linked in: dm_mod fuse btrfs raid6_pq xor ses encl=
osure sg sd_mod crct10dif_generic crct10dif_pclmul sr_mod crc_t10dif ata_=
generic cdrom crct10dif_common pata_acpi snd_pcm snd_timer snd mptsas ahc=
i soundcore mptscsih pata_jmicron libahci pcspkr serio_raw ipmi_si mptbas=
e libata i2c_i801 i7core_edac parport_pc scsi_transport_sas ipmi_msghandl=
er parport edac_core shpchp acpi_cpufreq
[  165.058119] CPU: 22 PID: 1110 Comm: perf_3.14 Not tainted 3.15.0-rc5-w=
l-02776-geec4f9d #1
[  165.067936] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/20=
10
[  165.078069] task: ffff88007fd63b00 ti: ffff8801d96f8000 task.ti: ffff8=
801d96f8000
[  165.084172] RIP: 0010:[<ffffffff811404d3>]  [<ffffffff811404d3>] SYSC_=
perf_event_open+0x313/0xc00
[  165.084172] RSP: 0018:ffff8801d96f9ea0  EFLAGS: 00010246
[  165.096386] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000=
0000000
[  165.096386] RDX: 00000000000000a7 RSI: 00000000013d07a0 RDI: ffff8801d=
96f9f40
[  165.096386] RBP: ffff8801d96f9f68 R08: 0000000000000000 R09: 000000000=
0000000
[  165.122926] R10: 00000000ffffffff R11: 0000000000000202 R12: 000000000=
0000000
[  165.129153] R13: 0000000000000002 R14: 00000000013e50e0 R15: 000000000=
0000000
[  165.137074] FS:  00007f7a8741b740(0000) GS:ffff88043fd40000(0000) knlG=
S:0000000000000000
[  165.137074] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  165.137074] CR2: 00000000000000eb CR3: 00000003fa5f4000 CR4: 000000000=
00007e0
[  165.157185] Stack:
[  165.157185]  ffff8801d96f9ee8 ffffffff811bc023 0000000000000000 000000=
0000000000
[  165.164467]  0000000000000000 ffffffff00000000 ffff8800ffffffff ffff88=
0000000000
[  165.175111]  0000006000000000 0000000000000000 0000000000000320 000000=
00000001a7
[  165.175111] Call Trace:
[  165.175111]  [<ffffffff811bc023>] ? __fput+0x1a3/0x230
[  165.192139]  [<ffffffff81141179>] SyS_perf_event_open+0x9/0x10
[  165.192139]  [<ffffffff81760069>] system_call_fastpath+0x16/0x1b
[  165.202110] Code: 48 c7 c0 ea ff ff ff eb 85 0f 1f 80 00 00 00 00 c7 8=
5 70 ff ff ff 00 00 00 00 45 31 e4 48 c7 85 48 ff ff ff 00 00 00 00 45 31=
 ff <41> f6 87 eb 00 00 00 01 0f 84 67 02 00 00 f6 45 a3 01 74 39 48=20
[  165.225103] RIP  [<ffffffff811404d3>] SYSC_perf_event_open+0x313/0xc00=

[  165.229113]  RSP <ffff8801d96f9ea0>
[  165.229113] CR2: 00000000000000eb
[  165.242082] ---[ end trace e56e4b305beca08e ]---
[  165.246822] Kernel panic - not syncing: Fatal exception
[  165.252178] ------------[ cut here ]------------
[  165.253043] WARNING: CPU: 14 PID: 32178 at arch/x86/kernel/smp.c:124 n=
ative_smp_send_reschedule+0x5d/0x60()
[  165.253043] Modules linked in: dm_mod fuse btrfs raid6_pq xor ses encl=
osure sg sd_mod crct10dif_generic crct10dif_pclmul sr_mod crc_t10dif ata_=
generic cdrom crct10dif_common pata_acpi snd_pcm snd_timer snd mptsas ahc=
i soundcore mptscsih pata_jmicron libahci pcspkr serio_raw ipmi_si mptbas=
e libata i2c_i801 i7core_edac parport_pc scsi_transport_sas ipmi_msghandl=
er parport edac_core shpchp acpi_cpufreq
[  165.253043] CPU: 14 PID: 32178 Comm: hackbench Tainted: G      D      =
 3.15.0-rc5-wl-02776-geec4f9d #1
[  165.253043] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/20=
10
[  165.253043]  0000000000000009 ffff8800991a3c98 ffffffff8174e784 000000=
0000000000
[  165.253043]  ffff8800991a3cd0 ffffffff8106840d ffff880099120000 ffff88=
043fcf47c0
[  165.253043]  ffff880099120b3c 0000000000000005 0000000000000013 ffff88=
00991a3ce0
[  165.253043] Call Trace:
[  165.253043]  [<ffffffff8174e784>] dump_stack+0x4d/0x66
[  165.253043]  [<ffffffff8106840d>] warn_slowpath_common+0x7d/0xa0
[  165.253043]  [<ffffffff810684ea>] warn_slowpath_null+0x1a/0x20
[  165.253043]  [<ffffffff81041d9d>] native_smp_send_reschedule+0x5d/0x60=

[  165.253043]  [<ffffffff8109c6f9>] try_to_wake_up+0x259/0x2c0
[  165.253043]  [<ffffffff8109c7d2>] default_wake_function+0x12/0x20
[  165.253043]  [<ffffffff810b08d8>] autoremove_wake_function+0x18/0x40
[  165.253043]  [<ffffffff810b01f8>] __wake_up_common+0x58/0x90
[  165.253043]  [<ffffffff810b0675>] __wake_up_sync_key+0x45/0x60
[  165.253043]  [<ffffffff811c2b60>] pipe_write+0x3e0/0x5b0
[  165.253043]  [<ffffffff811b9cea>] do_sync_write+0x5a/0x90
[  165.253043]  [<ffffffff811ba49a>] vfs_write+0xba/0x1e0
[  165.253043]  [<ffffffff81752b3d>] ? __schedule+0x35d/0x7c0
[  165.253043]  [<ffffffff811bafe6>] SyS_write+0x46/0xb0
[  165.253043]  [<ffffffff81760069>] system_call_fastpath+0x16/0x1b
[  165.253043] ---[ end trace e56e4b305beca08f ]---
[  165.248308] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation ran=
ge: 0xffffffff80000000-0xffffffff9fffffff)
Rebooting in 10 seconds..


--------------040100080500030400020608
Content-Type: text/plain; charset=UTF-8;
 name="x86_64-rhel"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x86_64-rhel"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.13.0 Kernel Configuration
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
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
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
# CONFIG_LOCALVERSION_AUTO is not set
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
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

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
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=19
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
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
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
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
# CONFIG_EXPERT is not set
CONFIG_UID16=y
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
CONFIG_SHMEM=y
CONFIG_AIO=y
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
CONFIG_SYSTEM_TRUSTED_KEYRING=y
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
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
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
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
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
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
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
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
CONFIG_ZBUD=y
CONFIG_ZSWAP=y
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
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
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
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
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
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=y
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
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
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
CONFIG_PCI_IOAPIC=y
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
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
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
CONFIG_NFT_EXTHDR=m
CONFIG_NFT_META=m
CONFIG_NFT_CT=m
CONFIG_NFT_RBTREE=m
CONFIG_NFT_HASH=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_NAT=m
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
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
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
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
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
CONFIG_NF_TABLES_IPV4=m
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_CHAIN_ROUTE_IPV4=m
CONFIG_NFT_CHAIN_NAT_IPV4=m
# CONFIG_NF_TABLES_ARP is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT_IPV4=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
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
CONFIG_NFT_CHAIN_NAT_IPV6=m
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
CONFIG_NF_NAT_IPV6=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
# CONFIG_IP6_NF_TARGET_NPT is not set
CONFIG_NF_TABLES_BRIDGE=m
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
CONFIG_BRIDGE_EBT_ULOG=m
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
CONFIG_IEEE802154=m
CONFIG_IEEE802154_6LOWPAN=m
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
CONFIG_OPENVSWITCH_GRE=y
CONFIG_OPENVSWITCH_VXLAN=y
CONFIG_VSOCKETS=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=m
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
# CONFIG_WIRELESS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_RDMA is not set
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
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_DMA_SHARED_BUFFER=y

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
# CONFIG_MTD_TS5500 is not set
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
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
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
# CONFIG_ATMEL_SSC is not set
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
CONFIG_PCH_PHUB=m
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
CONFIG_VMWARE_VMCI=m

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
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
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
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
# CONFIG_SCSI_AIC7XXX_OLD is not set
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
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
CONFIG_SCSI_SRP=m
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
# CONFIG_SATA_HIGHBANK is not set
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
# CONFIG_SATA_RCAR is not set
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
CONFIG_PATA_ARASAN_CF=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
CONFIG_PATA_CS5536=m
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
# CONFIG_PATA_SC1200 is not set
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
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_MQ=m
CONFIG_DM_CACHE_CLEANER=m
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
CONFIG_NETPOLL_TRAP=y
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
CONFIG_ETHERNET=y
CONFIG_MDIO=m
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=m
CONFIG_NET_CADENCE=m
CONFIG_ARM_AT91_ETHER=m
CONFIG_MACB=m
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
CONFIG_NET_CALXEDA_XGMAC=m
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
CONFIG_CHELSIO_T4VF=m
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
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
CONFIG_IXGBE_DCA=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_I40E=m
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
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_MLX5_CORE=m
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=m
CONFIG_ETHOC=m
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLCNIC_DCB=y
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
# CONFIG_SH_ETH is not set
# CONFIG_NET_VENDOR_RDC is not set
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
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
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

#
# USB Network Adapters
#
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
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
CONFIG_MWL8K=m
CONFIG_ATH_COMMON=m
CONFIG_ATH_CARDS=m
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=m
CONFIG_ATH9K_PCI=y
CONFIG_ATH9K_AHB=y
CONFIG_ATH9K_DEBUGFS=y
# CONFIG_ATH9K_LEGACY_RATE_CONTROL is not set
CONFIG_ATH9K_RFKILL=y
CONFIG_ATH9K_HTC=m
# CONFIG_ATH9K_HTC_DEBUGFS is not set
CONFIG_CARL9170=m
CONFIG_CARL9170_LEDS=y
# CONFIG_CARL9170_DEBUGFS is not set
CONFIG_CARL9170_WPC=y
# CONFIG_CARL9170_HWRNG is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
CONFIG_WIL6210=m
CONFIG_WIL6210_ISR_COR=y
CONFIG_WIL6210_TRACING=y
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMSMAC=m
CONFIG_BRCMFMAC=m
CONFIG_BRCMFMAC_SDIO=y
CONFIG_BRCMFMAC_USB=y
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=m
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
CONFIG_IWLWIFI_OPMODE_MODULAR=y

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLWIFI_DEBUGFS=y
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLEGACY=m
CONFIG_IWL4965=m
CONFIG_IWL3945=m

#
# iwl3945 / iwl4965 Debugging Options
#
CONFIG_IWLEGACY_DEBUG=y
CONFIG_IWLEGACY_DEBUGFS=y
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
CONFIG_RT2X00=m
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
CONFIG_RT61PCI=m
CONFIG_RT2800PCI=m
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
CONFIG_RT2800PCI_RT53XX=y
CONFIG_RT2800PCI_RT3290=y
# CONFIG_RT2500USB is not set
CONFIG_RT73USB=m
CONFIG_RT2800USB=m
CONFIG_RT2800USB_RT33XX=y
CONFIG_RT2800USB_RT35XX=y
# CONFIG_RT2800USB_RT3573 is not set
CONFIG_RT2800USB_RT53XX=y
CONFIG_RT2800USB_RT55XX=y
CONFIG_RT2800USB_UNKNOWN=y
CONFIG_RT2800_LIB=m
CONFIG_RT2800_LIB_MMIO=m
CONFIG_RT2X00_LIB_MMIO=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_RTL_CARDS=m
CONFIG_RTL8192CE=m
CONFIG_RTL8192SE=m
CONFIG_RTL8192DE=m
CONFIG_RTL8723AE=m
CONFIG_RTL8188EE=m
CONFIG_RTL8192CU=m
CONFIG_RTLWIFI=m
CONFIG_RTLWIFI_PCI=m
CONFIG_RTLWIFI_USB=m
# CONFIG_RTLWIFI_DEBUG is not set
CONFIG_RTL8192C_COMMON=m
# CONFIG_WL_TI is not set
# CONFIG_ZD1211RW is not set
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
CONFIG_MWIFIEX_PCIE=m
CONFIG_MWIFIEX_USB=m
# CONFIG_CW1200 is not set

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
CONFIG_IEEE802154_FAKEHARD=m
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
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIDRV=m

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
CONFIG_TABLET_USB_WACOM=m
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

#
# Hardware I/O ports
#
CONFIG_SERIO=y
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
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
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
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
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

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_KGDB_NMI is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
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
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
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
# CONFIG_I2C_EG20T is not set
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
CONFIG_PTP_1588_CLOCK_PCH=m
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
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
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
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
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
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
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
CONFIG_SENSORS_APPLESMC=m

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
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m

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
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
# CONFIG_SC520_WDT is not set
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
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=m
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
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=m
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=m
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RTSX_PCI=m
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
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
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
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
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
CONFIG_IR_ENE=m
CONFIG_IR_IMON=m
CONFIG_IR_MCEUSB=m
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_WINBOND_CIR=m
CONFIG_IR_IGUANA=m
CONFIG_IR_TTUSBIR=m
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
# CONFIG_USB_SN9C102 is not set
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

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_AU0828_V4L2=y
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
CONFIG_DVB_USB_IT913X=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_USB_RTL28XXU=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_USB_DRV=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
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
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m
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
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_I2C_SI4713 is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_KEENE is not set
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
CONFIG_VIDEO_TVP5150=m

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
CONFIG_VIDEO_MT9V011=m

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

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
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

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
CONFIG_DVB_IT913X_FE=m
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
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_USB=m
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
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
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
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
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
CONFIG_FB_BACKLIGHT=y
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
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set

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
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
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
CONFIG_SND_CS5530=m
CONFIG_SND_CS5535AUDIO=m
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
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_PREALLOC_SIZE=512
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
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
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
# CONFIG_SND_USB_HIFACE is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
# CONFIG_SND_DICE is not set
CONFIG_SND_FIREWIRE_SPEAKERS=m
CONFIG_SND_ISIGHT=m
CONFIG_SND_SCS1X=m
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
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
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
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
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
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
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

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USB_DWC3 is not set
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
# CONFIG_USB_SERIAL_ZTE is not set
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
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
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
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_DELL_NETBOOKS=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
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
CONFIG_RTC_DRV_X1205=m
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=m
CONFIG_RTC_DRV_PCF8563=m
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
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_DS2404=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MOXART is not set

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
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=m
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=m
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
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_ACPI_PROCESSOR=m
# CONFIG_XEN_MCE_LOG is not set
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_COMEDI is not set
# CONFIG_PANEL is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
CONFIG_RTLLIB_CRYPTO_WEP=m
CONFIG_RTL8192E=m
CONFIG_R8712U=m
# CONFIG_R8188EU is not set
# CONFIG_RTS5139 is not set
# CONFIG_TRANZPORT is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_DX_SEP is not set
CONFIG_ZSMALLOC=y
CONFIG_ZRAM=m
CONFIG_ZRAM_DEBUG=y
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
# CONFIG_USB_ENESTORAGE is not set
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
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
CONFIG_FIREWIRE_SERIAL=m
# CONFIG_USB_DWC2 is not set
# CONFIG_LUSTRE_FS is not set
# CONFIG_USB_BTMTK is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=m
CONFIG_ASUS_LAPTOP=m
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_AIO=m
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
CONFIG_HP_ACCEL=m
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
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_IPS=m
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
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
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
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
# CONFIG_PM_DEVFREQ is not set
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
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_POWERCAP is not set

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
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
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
CONFIG_GENERIC_ACL=y

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
# CONFIG_F2FS_FS is not set
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
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_SUNRPC_XPRT_RDMA=m
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
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
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
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
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
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
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
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y
CONFIG_KDB_CONTINUE_CATASTROPHIC=0
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
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
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_AUDIT=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
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
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
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
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
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
CONFIG_CRYPTO_CRCT10DIF=m
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
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
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
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
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
CONFIG_ASSOCIATIVE_ARRAY=y
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

--------------040100080500030400020608--
