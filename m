Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaKJFkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:40:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:52529 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbaKJFj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:39:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,350,1413270000"; 
   d="scan'208";a="629345033"
Date: Mon, 10 Nov 2014 13:40:26 +0800
From: lkp@01.org
To: Jeff Layton <jlayton@primarydata.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [sunrpc] WARNING: CPU: 1 PID: 1890 at lib/list_debug.c:36
 __list_add+0xcb/0xd0()
Message-ID: <20141110054026.GD1705@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="q9KOos5vDmpwPx9o"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q9KOos5vDmpwPx9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed a wraning changes on

git://git.samba.org/jlayton/linux svc-pool-lock
commit 3a41085d37f2374f6ae6539f5dca3d1d53e50431 ("sunrpc: search for a thread under RCU")

<5>[   21.635477] Key type id_legacy registered
<4>[   21.638149] ------------[ cut here ]------------
<4>[   21.638359] ------------[ cut here ]------------
<4>[   21.638363] WARNING: CPU: 1 PID: 1890 at lib/list_debug.c:36 __list_add+0xcb/0xd0()
<4>[   21.638364] list_add double add: new=ffff88007be38000, prev=ffff88007e835088, next=ffff88007be38000.
<4>[   21.638376] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver nfsd auth_rpcgss ipmi_watchdog ipmi_msghandler sg sr_mod sd_mod cdrom ata_generic pata_acpi mxm_wmi pcspkr pata_marvell serio_raw firewire_ohci firewire_core ahci libahci crc_itu_t i2c_i801 libata parport_pc winbond_cir parport rc_core snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd wmi i7core_edac soundcore edac_core acpi_cpufreq
<4>[   21.638377] CPU: 1 PID: 1890 Comm: nfsv4.0-svc Tainted: G          I    3.18.0-rc3-ga798bc5 #1
<4>[   21.638378] Hardware name:                  /DX58SO, BIOS SOX5810J.86A.4196.2009.0715.1958 07/15/2009
<4>[   21.638380]  0000000000000009 ffff88007bd03d48 ffffffff8188f71f 0000000025a825a8
<4>[   21.638381]  ffff88007bd03d98 ffff88007bd03d88 ffffffff8106b3c1 ffff8800bf7c1b00
<4>[   21.638381]  ffff88007be38000 ffff88007be38000 ffff88007e835088 ffff88007e835098
<4>[   21.638382] Call Trace:
<4>[   21.638385]  [<ffffffff8188f71f>] dump_stack+0x4e/0x68
<4>[   21.638388]  [<ffffffff8106b3c1>] warn_slowpath_common+0x81/0xa0
<4>[   21.638389]  [<ffffffff8106b426>] warn_slowpath_fmt+0x46/0x50
<4>[   21.638390]  [<ffffffff8141932b>] __list_add+0xcb/0xd0
<4>[   21.638392]  [<ffffffff8186c0da>] svc_recv+0x69a/0xa30
<4>[   21.638399]  [<ffffffffa0270580>] ? nfs_callback_authenticate+0x50/0x50 [nfsv4]
<4>[   21.638406]  [<ffffffffa0270580>] ? nfs_callback_authenticate+0x50/0x50 [nfsv4]
<4>[   21.638412]  [<ffffffffa02705bb>] nfs4_callback_svc+0x3b/0x60 [nfsv4]
<4>[   21.638414]  [<ffffffff8108ac0b>] kthread+0xdb/0x100
<4>[   21.638415]  [<ffffffff8108ab30>] ? kthread_create_on_node+0x180/0x180
<4>[   21.638417]  [<ffffffff81897afc>] ret_from_fork+0x7c/0xb0
<4>[   21.638418]  [<ffffffff8108ab30>] ? kthread_create_on_node+0x180/0x180
<4>[   21.638419] ---[ end trace a8ecfce57c7c54ab ]---
<4>[   21.646613] WARNING: CPU: 2 PID: 1876 at lib/list_debug.c:36 __list_add+0xcb/0xd0()

--q9KOos5vDmpwPx9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc3-ga798bc5 (kbuild@cairo) (gcc versio=
n 4.9.1 (Debian 4.9.1-19) ) #1 SMP Fri Nov 7 06:36:39 CST 2014
[    0.000000] Command line: BOOT_IMAGE=3D/kernel/x86_64-rhel/a798bc55fde39=
28d93b1624b6f40382446e8ccc4/vmlinuz-3.18.0-rc3-ga798bc5 user=3Dlkp job=3D/l=
kp/scheduled/nhm4/cyclic_fsmark-performance-1x-32t-1HDD-xfs-nfsv4-8K-400M-f=
syncBeforeClose-16d-256fpd-x86_64-rhel-HEAD-a798bc55fde3928d93b1624b6f40382=
446e8ccc4-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/a798bc55fde=
3928d93b1624b6f40382446e8ccc4/vmlinuz-3.18.0-rc3-ga798bc5 kconfig=3Dx86_64-=
rhel commit=3Da798bc55fde3928d93b1624b6f40382446e8ccc4 branch=3Dlinux-devel=
/devel-hourly-2014110706 root=3D/dev/ram0 max_uptime=3D3600 RESULT_ROOT=3D/=
result/nhm4/fsmark/performance-1x-32t-1HDD-xfs-nfsv4-8K-400M-fsyncBeforeClo=
se-16d-256fpd/debian-x86_64.cgz/x86_64-rhel/a798bc55fde3928d93b1624b6f40382=
446e8ccc4/0 ip=3D::::nhm4::dhcp libata.force=3D1.5Gbps earlyprintk=3DttyS0,=
115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeo=
ut=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic =
load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 v=
ga<6>
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bcadafff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bcadb000-0x00000000bcd2bfff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000bcd2c000-0x00000000bf6bcfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf6bd000-0x00000000bf6befff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000bf6bf000-0x00000000bf713fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf714000-0x00000000bf7befff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf7bf000-0x00000000bf7e5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf7e6000-0x00000000bf7fefff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x00000000bf7ff000-0x00000000bf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf800000-0x00000000bfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fcffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI:                  /DX58SO, BIOS SOX5810J.86A.4196.2009.0=
715.1958 07/15/2009
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0xbf800 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   3 base 0FFE00000 mask FFFFF0000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009d000-0x0009d3ff]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x021c6000, 0x021c6fff] PGTABLE
[    0.000000] BRK [0x021c7000, 0x021c7fff] PGTABLE
[    0.000000] BRK [0x021c8000, 0x021c8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbf400000-0xbf5fffff]
[    0.000000]  [mem 0xbf400000-0xbf5fffff] page 2M
[    0.000000] BRK [0x021c9000, 0x021c9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbc000000-0xbcadafff]
[    0.000000]  [mem 0xbc000000-0xbc9fffff] page 2M
[    0.000000]  [mem 0xbca00000-0xbcadafff] page 4k
[    0.000000] BRK [0x021ca000, 0x021cafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbcd2c000-0xbf3fffff]
[    0.000000]  [mem 0xbcd2c000-0xbcdfffff] page 4k
[    0.000000]  [mem 0xbce00000-0xbf3fffff] page 2M
[    0.000000] BRK [0x021cb000, 0x021cbfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x80000000-0xbbffffff]
[    0.000000]  [mem 0x80000000-0xbbffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0xbf600000-0xbf6bcfff]
[    0.000000]  [mem 0xbf600000-0xbf6bcfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf6bf000-0xbf713fff]
[    0.000000]  [mem 0xbf6bf000-0xbf713fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf7bf000-0xbf7e5fff]
[    0.000000]  [mem 0xbf7bf000-0xbf7e5fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf7ff000-0xbf7fffff]
[    0.000000]  [mem 0xbf7ff000-0xbf7fffff] page 4k
[    0.000000] RAMDISK: [mem 0x782d7000-0x7fff4fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FE020 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000BF7FE120 000074 (v01 INTEL  DX58SO   00=
001064      01000013)
[    0.000000] ACPI: FACP 0x00000000BF7FD000 0000F4 (v03 INTEL  DX58SO   00=
001064 MSFT 0100000D)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1a=
EventBlock: 32/16 (20140926/tbfadt-618)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock=
 has zero address or length: 0x0000000000000450/0x0 (20140926/tbfadt-649)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/PmTi=
merBlock: 32/24 (20140926/tbfadt-618)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aEventBl=
ock: 16, using default 32 (20140926/tbfadt-699)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm2ControlB=
lock: 0, using default 8 (20140926/tbfadt-699)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/PmTimerBloc=
k: 24, using default 32 (20140926/tbfadt-699)
[    0.000000] ACPI: DSDT 0x00000000BF7F8000 0045D9 (v02 INTEL  DX58SO   00=
001064 MSFT 0100000D)
[    0.000000] ACPI: FACS 0x00000000BF725000 000040
[    0.000000] ACPI: APIC 0x00000000BF7F7000 000138 (v02 INTEL  DX58SO   00=
001064 MSFT 0100000D)
[    0.000000] ACPI: WDDT 0x00000000BF7F6000 000040 (v01 INTEL  DX58SO   00=
001064 MSFT 0100000D)
[    0.000000] ACPI: MCFG 0x00000000BF7F5000 00003C (v01 INTEL  DX58SO   00=
001064 MSFT 0100000D)
[    0.000000] ACPI: ASF! 0x00000000BF7F4000 0000AC (v32 INTEL  DX58SO   00=
001064 MSFT 0100000D)
[    0.000000] ACPI: HPET 0x00000000BF7F3000 000038 (v01 INTEL  DX58SO   00=
001064 MSFT 0100000D)
[    0.000000] ACPI: SSDT 0x00000000BF7E9000 0070AC (v01 INTEL  SSDT  PM 00=
001064 MSFT 0100000D)
[    0.000000] ACPI: DMAR 0x00000000BF7E6000 000140 (v01 INTEL  DX58SO   00=
001064 MSFT 0100000D)
[    0.000000] ACPI: WDTT 0x00000000BF7F1000 00020C (v02 INTEL  DX58SO   00=
001064 MSFT 0100000D)
[    0.000000] ACPI: ASPT 0x00000000BF7F2000 000034 (v04 INTEL  PerfTune 00=
001064 MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000bf7fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0xbf7c0000-0xbf7e5fff]
[    0.000000]  [ffffea0000000000-ffffea0002ffffff] PMD -> [ffff8800b9a0000=
0-ffff8800bc9fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008efff]
[    0.000000]   node   0: [mem 0x00090000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xbcadafff]
[    0.000000]   node   0: [mem 0xbcd2c000-0xbf6bcfff]
[    0.000000]   node   0: [mem 0xbf6bf000-0xbf713fff]
[    0.000000]   node   0: [mem 0xbf7bf000-0xbf7e5fff]
[    0.000000]   node   0: [mem 0xbf7ff000-0xbf7fffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0xbf7fffff]
[    0.000000] On node 0 totalpages: 783492
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12192 pages used for memmap
[    0.000000]   DMA32 zone: 779497 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] disabled)
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
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC =
INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC =
INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC =
INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC =
INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC =
INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0008f000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbcadb000-0xbcd2bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf6bd000-0xbf6befff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf714000-0xbf7befff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf7e6000-0xbf7fefff]
[    0.000000] e820: [mem 0xc0000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:16 nr_cpu_ids:16 =
nr_node_ids:1
[    0.000000] PERCPU: Embedded 33 pages/cpu @ffff8800bf000000 s97408 r8192=
 d29568 u262144
[    0.000000] pcpu-alloc: s97408 r8192 d29568 u262144 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11 12 1=
3 14 15=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 771214
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=3D/kernel/x86_64-rhel/a798bc=
55fde3928d93b1624b6f40382446e8ccc4/vmlinuz-3.18.0-rc3-ga798bc5 user=3Dlkp j=
ob=3D/lkp/scheduled/nhm4/cyclic_fsmark-performance-1x-32t-1HDD-xfs-nfsv4-8K=
-400M-fsyncBeforeClose-16d-256fpd-x86_64-rhel-HEAD-a798bc55fde3928d93b1624b=
6f40382446e8ccc4-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-rhel/a798=
bc55fde3928d93b1624b6f40382446e8ccc4/vmlinuz-3.18.0-rc3-ga798bc5 kconfig=3D=
x86_64-rhel commit=3Da798bc55fde3928d93b1624b6f40382446e8ccc4 branch=3Dlinu=
x-devel/devel-hourly-2014110706 root=3D/dev/ram0 max_uptime=3D3600 RESULT_R=
OOT=3D/result/nhm4/fsmark/performance-1x-32t-1HDD-xfs-nfsv4-8K-400M-fsyncBe=
foreClose-16d-256fpd/debian-x86_64.cgz/x86_64-rhel/a798bc55fde3928d93b1624b=
6f40382446e8ccc4/0 ip=3D::::nhm4::dhcp libata.force=3D1.5Gbps earlyprintk=
=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_st=
all_timeout=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=
=3Dpanic load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=
=3Dt<6>
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 2935852K/3133968K available (8819K kernel code, 1677=
K rwdata, 3904K rodata, 1848K init, 1888K bss, 198116K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D16, =
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_ids=3D16.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D16
[    0.000000] NR_IRQS:524544 nr_irqs:552 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-15.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 12582912 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3200.186 MHz processor
[    0.000027] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6400.37 BogoMIPS (lpj=3D3200186)
[    0.000466] pid_max: default: 32768 minimum: 301
[    0.000666] ACPI: Core revision 20140926
[    0.008594] ACPI: All ACPI Tables successfully acquired
[    0.008904] Security Framework initialized
[    0.009086] SELinux:  Initializing.
[    0.009245] SELinux:  Starting in permissive mode
[    0.009687] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.011252] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.012118] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.012416] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 b=
ytes)
[    0.012925] Initializing cgroup subsys memory
[    0.013141] Initializing cgroup subsys devices
[    0.013356] Initializing cgroup subsys freezer
[    0.013571] Initializing cgroup subsys net_cls
[    0.013785] Initializing cgroup subsys blkio
[    0.013993] Initializing cgroup subsys perf_event
[    0.014217] Initializing cgroup subsys hugetlb
[    0.014446] CPU: Physical Processor ID: 0
[    0.014644] CPU: Processor Core ID: 0
[    0.014832] mce: CPU supports 9 MCE banks
[    0.015036] CPU0: Thermal monitoring enabled (TM1)
[    0.015269] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.015269] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.015835] Freeing SMP alternatives memory: 36K (ffffffff81fe3000 - fff=
fffff81fec000)
[    0.017037] ftrace: allocating 31309 entries in 123 pages
[    0.029217] Getting VERSION: 60015
[    0.029395] Getting VERSION: 60015
[    0.029571] Getting ID: 0
[    0.029720] Getting ID: 0
[    0.029875] dmar: Host address width 39
[    0.030067] dmar: DRHD base: 0x000000fe711000 flags: 0x0
[    0.030315] dmar: IOMMU 0: reg_base_addr fe711000 ver 1:0 cap c9008010e6=
0262 ecap f0207a
[    0.030682] dmar: DRHD base: 0x000000fe710000 flags: 0x1
[    0.030929] dmar: IOMMU 1: reg_base_addr fe710000 ver 1:0 cap c90780106f=
0462 ecap f0207a
[    0.031297] dmar: RMRR base: 0x000000000e9000 end: 0x000000000e9fff
[    0.031574] dmar: RMRR base: 0x000000000ea000 end: 0x000000000eafff
[    0.031852] dmar: RMRR base: 0x000000000eb000 end: 0x000000000ebfff
[    0.032130] dmar: RMRR base: 0x000000000e6000 end: 0x000000000e6fff
[    0.032408] dmar: RMRR base: 0x000000000e7000 end: 0x000000000e7fff
[    0.032685] dmar: RMRR base: 0x000000000e8000 end: 0x000000000e8fff
[    0.032962] dmar: RMRR base: 0x000000000ec000 end: 0x000000000eefff
[    0.033300] This system BIOS has enabled interrupt remapping
[    0.033300] on a chipset that contains an erratum making that
[    0.033300] feature unstable.  To maintain system stability
[    0.033300] interrupt remapping is being disabled.  Please
[    0.033300] contact your BIOS vendor for an update
[    0.034444] Switched APIC routing to physical flat.
[    0.034674] masked ExtINT on CPU#0
[    0.035050] ENABLING IO-APIC IRQs
[    0.035224] init IO_APIC IRQs
[    0.035385]  apic 8 pin 0 not connected
[    0.035579] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:0)
[    0.035943] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:0)
[    0.036306] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:0)
[    0.036676] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:0)
[    0.037039] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:0)
[    0.037403] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Ac=
tive:0 Dest:0)
[    0.037768] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:0)
[    0.038131] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:0)
[    0.038496] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:0)
[    0.038860] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:0)
[    0.039223] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 =
Active:0 Dest:0)
[    0.039594] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 =
Active:0 Dest:0)
[    0.039964] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:0)
[    0.040333] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:0)
[    0.040704] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:0)
[    0.041074] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:0)
[    0.041444]  apic 8 pin 16 not connected
[    0.041639]  apic 8 pin 17 not connected
[    0.041833]  apic 8 pin 18 not connected
[    0.042028]  apic 8 pin 19 not connected
[    0.042223]  apic 8 pin 20 not connected
[    0.042418]  apic 8 pin 21 not connected
[    0.042613]  apic 8 pin 22 not connected
[    0.042807]  apic 8 pin 23 not connected
[    0.043137] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.053407] smpboot: CPU0: Genuine Intel(R) CPU             000  @ 3.20G=
Hz (fam: 06, model: 1a, stepping: 04)
[    0.053934] Using local APIC timer interrupts.
[    0.053934] calibrating APIC timer ...
[    0.155414] ... lapic delta =3D 833353
[    0.155596] ... PM-Timer delta =3D 357950
[    0.155788] ... PM-Timer result ok
[    0.155964] ..... delta 833353
[    0.156128] ..... mult: 35792238
[    0.156298] ..... calibration result: 133336
[    0.156505] ..... CPU clock speed is 3200.0072 MHz.
[    0.156734] ..... host bus clock speed is 133.0336 MHz.
[    0.156996] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events,=
 Intel PMU driver.
[    0.157506] perf_event_intel: CPU erratum AAJ80 worked around
[    0.157765] ... version:                3
[    0.157962] ... bit width:              48
[    0.158165] ... generic registers:      4
[    0.158363] ... value mask:             0000ffffffffffff
[    0.158606] ... max period:             000000007fffffff
[    0.158850] ... fixed-purpose events:   3
[    0.159048] ... event mask:             000000070000000f
[    0.160584] x86: Booting SMP configuration:
[    0.160790] .... node  #0, CPUs:        #1
[    0.172139] masked ExtINT on CPU#1
[    0.174478] NMI watchdog: enabled on all CPUs, permanently consumes one =
hw-PMU counter.
[    0.174931]   #2
[    0.186139] masked ExtINT on CPU#2
[    0.188450]   #3
[    0.199654] masked ExtINT on CPU#3
[    0.201955]   #4
[    0.213162] masked ExtINT on CPU#4
[    0.215482]   #5
[    0.226686] masked ExtINT on CPU#5
[    0.228992]   #6
[    0.240221] masked ExtINT on CPU#6
[    0.242524]   #7
[    0.253728] masked ExtINT on CPU#7
[    0.255952] x86: Booted up 1 node, 8 CPUs
[    0.256154] smpboot: Total of 8 processors activated (51202.97 BogoMIPS)
[    0.261458] devtmpfs: initialized
[    0.263734] evm: security.selinux
[    0.263908] evm: security.ima
[    0.264071] evm: security.capability
[    0.264387] PM: Registering ACPI NVS region [mem 0xbcadb000-0xbcd2bfff] =
(2428928 bytes)
[    0.264781] PM: Registering ACPI NVS region [mem 0xbf714000-0xbf7befff] =
(700416 bytes)
[    0.266061] atomic64_test: passed for x86-64 platform with CX8 and with =
SSE
[    0.266458] NET: Registered protocol family 16
[    0.268976] cpuidle: using governor menu
[    0.269307] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.269657] ACPI: bus type PCI registered
[    0.269856] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.270200] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.270611] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.271013] PCI: Using configuration type 1 for base access
[    0.275272] ACPI: Added _OSI(Module Device)
[    0.275477] ACPI: Added _OSI(Processor Device)
[    0.275690] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.275913] ACPI: Added _OSI(Processor Aggregator Device)
[    0.276976] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:0)
[    0.285351] ACPI: Interpreter enabled
[    0.285544] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140926/hwxface-580)
[    0.286027] ACPI: (supports S0 S1 S3 S4 S5)
[    0.286232] ACPI: Using IOAPIC for interrupt routing
[    0.286483] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.291345] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3d])
[    0.291626] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cloc=
kPM Segments MSI]
[    0.292246] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER =
PCIeCapability]
[    0.293105] acpi PNP0A08:00: host bridge window [0x0-0x0] (ignored, not =
CPU addressable)
[    0.293669] PCI host bridge to bus 0000:00
[    0.293873] pci_bus 0000:00: root bus resource [bus 00-3d]
[    0.294126] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.294402] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.294676] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.294977] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000cbff=
f]
[    0.295276] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedffff=
f]
[    0.295575] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xf7fffff=
f]
[    0.295882] pci 0000:00:00.0: [8086:3405] type 00 class 0x060000
[    0.296260] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    0.296579] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.296899] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.297190] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    0.297508] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.297827] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.298119] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    0.298434] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.298754] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.299045] pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
[    0.299411] pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
[    0.299773] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    0.300143] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    0.300509] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    0.300873] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    0.301241] pci 0000:00:19.0: [8086:10cc] type 00 class 0x020000
[    0.301525] pci 0000:00:19.0: reg 0x10: [mem 0xd0400000-0xd041ffff]
[    0.302362] pci 0000:00:19.0: reg 0x14: [mem 0xd0423000-0xd0423fff]
[    0.302646] pci 0000:00:19.0: reg 0x18: [io  0x4100-0x411f]
[    0.302953] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.303275] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.303563] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.303866] pci 0000:00:1a.0: reg 0x20: [io  0x40e0-0x40ff]
[    0.304217] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.304506] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    0.304809] pci 0000:00:1a.1: reg 0x20: [io  0x40c0-0x40df]
[    0.305159] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    0.305448] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.305751] pci 0000:00:1a.2: reg 0x20: [io  0x40a0-0x40bf]
[    0.306100] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    0.306398] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.306684] pci 0000:00:1a.7: reg 0x10: [mem 0xd0422000-0xd04223ff]
[    0.307044] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.307387] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.307678] pci 0000:00:1b.0: [8086:3a3e] type 00 class 0x040300
[    0.307960] pci 0000:00:1b.0: reg 0x10: [mem 0xf0000000-0xf0003fff 64bit]
[    0.308323] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.308663] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.308952] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.309284] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.309607] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.309894] pci 0000:00:1c.1: [8086:3a42] type 01 class 0x060400
[    0.310225] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.310547] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.310835] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    0.311170] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.311494] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.311783] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.312089] pci 0000:00:1d.0: reg 0x20: [io  0x4080-0x409f]
[    0.312438] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.312726] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.313032] pci 0000:00:1d.1: reg 0x20: [io  0x4060-0x407f]
[    0.313381] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.313669] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.313975] pci 0000:00:1d.2: reg 0x20: [io  0x4040-0x405f]
[    0.314325] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.314621] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.314907] pci 0000:00:1d.7: reg 0x10: [mem 0xd0421000-0xd04213ff]
[    0.315266] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.315609] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.315896] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.316252] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.316542] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    0.316880] pci 0000:00:1f.0: can't claim BAR 13 [io  0x0400-0x047f]: ad=
dress conflict with ACPI CPU throttle [io  0x0410-0x0415]
[    0.317378] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6=
 GPIO
[    0.317688] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (=
mask 007f)
[    0.318040] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (=
mask 007f)
[    0.318488] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    0.318772] pci 0000:00:1f.2: reg 0x10: [io  0x4128-0x412f]
[    0.319033] pci 0000:00:1f.2: reg 0x14: [io  0x4134-0x4137]
[    0.319291] pci 0000:00:1f.2: reg 0x18: [io  0x4120-0x4127]
[    0.319549] pci 0000:00:1f.2: reg 0x1c: [io  0x4130-0x4133]
[    0.319807] pci 0000:00:1f.2: reg 0x20: [io  0x4020-0x403f]
[    0.320067] pci 0000:00:1f.2: reg 0x24: [mem 0xd0420000-0xd04207ff]
[    0.320385] pci 0000:00:1f.2: PME# supported from D3hot
[    0.320699] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.320982] pci 0000:00:1f.3: reg 0x10: [mem 0xf0004000-0xf00040ff 64bit]
[    0.321294] pci 0000:00:1f.3: reg 0x20: [io  0x4000-0x401f]
[    0.321677] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    0.321962] pci 0000:01:00.0: reg 0x10: [io  0x3000-0x30ff]
[    0.322236] pci 0000:01:00.0: reg 0x18: [mem 0xd0300000-0xd0300fff 64bit]
[    0.322557] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.322922] pci 0000:01:00.0: supports D1 D2
[    0.323131] pci 0000:01:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.324979] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.325218] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.325490] pci 0000:00:01.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    0.325789] pci 0000:00:01.0:   bridge window [mem 0xd0500000-0xd05fffff=
 64bit pref]
[    0.326191] pci 0000:02:00.0: [1002:6898] type 00 class 0x030000
[    0.326471] pci 0000:02:00.0: reg 0x10: [mem 0xe0000000-0xefffffff 64bit=
 pref]
[    0.326816] pci 0000:02:00.0: reg 0x18: [mem 0xd0200000-0xd021ffff 64bit]
[    0.327119] pci 0000:02:00.0: reg 0x20: [io  0x2000-0x20ff]
[    0.327382] pci 0000:02:00.0: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
[    0.327707] pci 0000:02:00.0: supports D1 D2
[    0.327953] pci 0000:02:00.1: [1002:aa50] type 00 class 0x040300
[    0.328236] pci 0000:02:00.1: reg 0x10: [mem 0xd0220000-0xd0223fff 64bit]
[    0.328586] pci 0000:02:00.1: supports D1 D2
[    0.329981] pci 0000:00:03.0: PCI bridge to [bus 02]
[    0.330220] pci 0000:00:03.0:   bridge window [io  0x2000-0x2fff]
[    0.330493] pci 0000:00:03.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    0.330792] pci 0000:00:03.0:   bridge window [mem 0xe0000000-0xefffffff=
 64bit pref]
[    0.331187] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.331466] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.331745] pci 0000:00:1c.1: PCI bridge to [bus 05]
[    0.332040] pci 0000:06:00.0: [11ab:6121] type 00 class 0x01018f
[    0.332325] pci 0000:06:00.0: reg 0x10: [io  0x1018-0x101f]
[    0.332588] pci 0000:06:00.0: reg 0x14: [io  0x1024-0x1027]
[    0.332850] pci 0000:06:00.0: reg 0x18: [io  0x1010-0x1017]
[    0.333115] pci 0000:06:00.0: reg 0x1c: [io  0x1020-0x1023]
[    0.333378] pci 0000:06:00.0: reg 0x20: [io  0x1000-0x100f]
[    0.333641] pci 0000:06:00.0: reg 0x24: [mem 0xd0100000-0xd01003ff]
[    0.333984] pci 0000:06:00.0: supports D1
[    0.334182] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
[    0.335985] pci 0000:00:1c.4: PCI bridge to [bus 06]
[    0.336224] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.336498] pci 0000:00:1c.4:   bridge window [mem 0xd0100000-0xd01fffff]
[    0.336836] pci 0000:07:03.0: [104c:8023] type 00 class 0x0c0010
[    0.337121] pci 0000:07:03.0: reg 0x10: [mem 0xd0004000-0xd00047ff]
[    0.337407] pci 0000:07:03.0: reg 0x14: [mem 0xd0000000-0xd0003fff]
[    0.337748] pci 0000:07:03.0: supports D1 D2
[    0.337956] pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
[    0.338288] pci 0000:00:1e.0: PCI bridge to [bus 07] (subtractive decode)
[    0.338588] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd00fffff]
[    0.338888] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtr=
active decode)
[    0.339252] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtr=
active decode)
[    0.339614] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff=
] (subtractive decode)
[    0.340001] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000cbfff=
] (subtractive decode)
[    0.340388] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff=
] (subtractive decode)
[    0.340774] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xf7ffffff=
] (subtractive decode)
[    0.341197] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupp=
orted)
[    0.341613] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 1=
4 15) *0, disabled.
[    0.342525] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 1=
4 15) *0, disabled.
[    0.343436] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 1=
4 15) *0, disabled.
[    0.344346] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 1=
4 15) *0, disabled.
[    0.345254] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 1=
4 15) *0, disabled.
[    0.346164] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 1=
4 15) *0, disabled.
[    0.347071] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 1=
4 15) *0, disabled.
[    0.347980] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 1=
4 15) *0, disabled.
[    0.348864] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:0)
[    0.349721] ACPI: Enabled 2 GPEs in block 00 to 3F
[    0.350089] vgaarb: setting as boot device: PCI:0000:02:00.0
[    0.350347] vgaarb: device added: PCI:0000:02:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.350715] vgaarb: loaded
[    0.350866] vgaarb: bridge control possible 0000:02:00.0
[    0.351163] SCSI subsystem initialized
[    0.351373] ACPI: bus type USB registered
[    0.351585] usbcore: registered new interface driver usbfs
[    0.351841] usbcore: registered new interface driver hub
[    0.352108] usbcore: registered new device driver usb
[    0.352359] pps_core: LinuxPPS API ver. 1 registered
[    0.352590] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.352999] PTP clock support registered
[    0.353263] PCI: Using ACPI for IRQ routing
[    0.354589] PCI: Discovered peer bus 3f
[    0.354781] PCI: root bus 3f: using default resources
[    0.355017] PCI: Probing PCI hardware (bus 3f)
[    0.355246] PCI host bridge to bus 0000:3f
[    0.355448] pci_bus 0000:3f: root bus resource [io  0x0000-0xffff]
[    0.355722] pci_bus 0000:3f: root bus resource [mem 0x00000000-0xfffffff=
ff]
[    0.356026] pci_bus 0000:3f: No busn resource found for root bus, will u=
se [bus 3f-ff]
[    0.356390] pci 0000:3f:00.0: [8086:2c41] type 00 class 0x060000
[    0.356692] pci 0000:3f:00.1: [8086:2c01] type 00 class 0x060000
[    0.356995] pci 0000:3f:02.0: [8086:2c10] type 00 class 0x060000
[    0.357293] pci 0000:3f:02.1: [8086:2c11] type 00 class 0x060000
[    0.357594] pci 0000:3f:03.0: [8086:2c18] type 00 class 0x060000
[    0.357893] pci 0000:3f:03.1: [8086:2c19] type 00 class 0x060000
[    0.358193] pci 0000:3f:03.4: [8086:2c1c] type 00 class 0x060000
[    0.358492] pci 0000:3f:04.0: [8086:2c20] type 00 class 0x060000
[    0.358791] pci 0000:3f:04.1: [8086:2c21] type 00 class 0x060000
[    0.359091] pci 0000:3f:04.2: [8086:2c22] type 00 class 0x060000
[    0.359391] pci 0000:3f:04.3: [8086:2c23] type 00 class 0x060000
[    0.359690] pci 0000:3f:05.0: [8086:2c28] type 00 class 0x060000
[    0.360544] pci 0000:3f:05.1: [8086:2c29] type 00 class 0x060000
[    0.360843] pci 0000:3f:05.2: [8086:2c2a] type 00 class 0x060000
[    0.361143] pci 0000:3f:05.3: [8086:2c2b] type 00 class 0x060000
[    0.361443] pci 0000:3f:06.0: [8086:2c30] type 00 class 0x060000
[    0.361740] pci 0000:3f:06.1: [8086:2c31] type 00 class 0x060000
[    0.362040] pci 0000:3f:06.2: [8086:2c32] type 00 class 0x060000
[    0.362338] pci 0000:3f:06.3: [8086:2c33] type 00 class 0x060000
[    0.362646] pci_bus 0000:3f: busn_res: [bus 3f-ff] end is updated to 3f
[    0.362938] PCI: pci_cache_line_size set to 64 bytes
[    0.363238] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.363507] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
[    0.363775] e820: reserve RAM buffer [mem 0xbcadb000-0xbfffffff]
[    0.364045] e820: reserve RAM buffer [mem 0xbf6bd000-0xbfffffff]
[    0.364313] e820: reserve RAM buffer [mem 0xbf714000-0xbfffffff]
[    0.364582] e820: reserve RAM buffer [mem 0xbf7e6000-0xbfffffff]
[    0.364850] e820: reserve RAM buffer [mem 0xbf800000-0xbfffffff]
[    0.365202] NetLabel: Initializing
[    0.365380] NetLabel:  domain hash size =3D 128
[    0.365589] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.365830] NetLabel:  unlabeled traffic allowed by default
[    0.366199] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.366508] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.366901] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.369363] Switched to clocksource hpet
[    0.377003] pnp: PnP ACPI init
[    0.377354] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:0)
[    0.377739] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.378092] system 00:01: [io  0x0500-0x053f] has been reserved
[    0.378359] system 00:01: [io  0x0400-0x047f] could not be reserved
[    0.378641] system 00:01: [io  0x0680-0x06ff] has been reserved
[    0.378908] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.379278] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.379906] pnp: PnP ACPI: found 3 devices
[    0.386130] pci 0000:02:00.0: can't claim BAR 6 [mem 0xfffe0000-0xffffff=
ff pref]: no compatible bridge window
[    0.386604] pci 0000:00:1f.0: BAR 13: [io  0x0400-0x047f] has bogus alig=
nment
[    0.386916] pci 0000:01:00.0: BAR 6: assigned [mem 0xd0320000-0xd033ffff=
 pref]
[    0.387253] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.387489] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.387763] pci 0000:00:01.0:   bridge window [mem 0xd0300000-0xd03fffff]
[    0.388059] pci 0000:00:01.0:   bridge window [mem 0xd0500000-0xd05fffff=
 64bit pref]
[    0.388420] pci 0000:02:00.0: BAR 6: assigned [mem 0xd0240000-0xd025ffff=
 pref]
[    0.388757] pci 0000:00:03.0: PCI bridge to [bus 02]
[    0.388989] pci 0000:00:03.0:   bridge window [io  0x2000-0x2fff]
[    0.389262] pci 0000:00:03.0:   bridge window [mem 0xd0200000-0xd02fffff]
[    0.389562] pci 0000:00:03.0:   bridge window [mem 0xe0000000-0xefffffff=
 64bit pref]
[    0.389919] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.390156] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.390397] pci 0000:00:1c.1: PCI bridge to [bus 05]
[    0.390636] pci 0000:00:1c.4: PCI bridge to [bus 06]
[    0.390868] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.391141] pci 0000:00:1c.4:   bridge window [mem 0xd0100000-0xd01fffff]
[    0.391445] pci 0000:00:1e.0: PCI bridge to [bus 07]
[    0.391678] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd00fffff]
[    0.391979] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.392232] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.392489] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.392766] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.393044] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.393321] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.393602] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.393855] pci_bus 0000:01: resource 1 [mem 0xd0300000-0xd03fffff]
[    0.394133] pci_bus 0000:01: resource 2 [mem 0xd0500000-0xd05fffff 64bit=
 pref]
[    0.394473] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.394726] pci_bus 0000:02: resource 1 [mem 0xd0200000-0xd02fffff]
[    0.395003] pci_bus 0000:02: resource 2 [mem 0xe0000000-0xefffffff 64bit=
 pref]
[    0.395340] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    0.395597] pci_bus 0000:06: resource 1 [mem 0xd0100000-0xd01fffff]
[    0.395875] pci_bus 0000:07: resource 1 [mem 0xd0000000-0xd00fffff]
[    0.396152] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.396408] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.396661] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.396939] pci_bus 0000:07: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.397216] pci_bus 0000:07: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.397496] pci_bus 0000:07: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.397775] pci_bus 0000:3f: resource 4 [io  0x0000-0xffff]
[    0.398028] pci_bus 0000:3f: resource 5 [mem 0x00000000-0xfffffffff]
[    0.398333] NET: Registered protocol family 2
[    0.398702] TCP established hash table entries: 32768 (order: 6, 262144 =
bytes)
[    0.399144] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.399581] TCP: Hash tables configured (established 32768 bind 32768)
[    0.399892] TCP: reno registered
[    0.400067] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.400360] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.400713] NET: Registered protocol family 1
[    0.401020] RPC: Registered named UNIX socket transport module.
[    0.401285] RPC: Registered udp transport module.
[    0.401513] RPC: Registered tcp transport module.
[    0.401735] RPC: Registered tcp NFSv4.1 backchannel transport module
--q9KOos5vDmpwPx9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--q9KOos5vDmpwPx9o--
