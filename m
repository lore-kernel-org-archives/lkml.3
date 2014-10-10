Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaJJC1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 22:27:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:5732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaJJC1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 22:27:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,689,1406617200"; 
   d="scan'208";a="616186584"
Date: Fri, 10 Oct 2014 10:27:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Chris Mason <clm@fb.com>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [Btrfs] kernel BUG at fs/btrfs/inode.c:3123!
Message-ID: <20141010022733.GA4188@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Josef,

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 47ab2a6c689913db23ccae38349714edf8365e0a ("Btrfs: remove empty block groups automatically")


testbox/testcase/testparams: lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-10dd

8407f553268a4611  47ab2a6c689913db23ccae3834  
----------------  --------------------------  
       fail:runs  %reproduction    fail:runs
           |            |              |
           :1           80%           4:5     dmesg.kernel_BUG_at_fs/btrfs/inode.c
           :1           80%           4:5     dmesg.invalid_opcode
           :1           80%           4:5     dmesg.Kernel_panic-not_syncing:Fatal_exception
           :1           20%           1:5     last_state.booting
           :1           60%           3:5     last_state.is_incomplete_run
           :1           40%           2:5     last_state.running

kexecing...
kexec -l /tmp//kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/vmlinuz-3.17.0-ga308edf --initrd=/tmp/initrd-6217 --append="user=lkp job=/lkp/scheduled/lkp-st02/cyclic_dd-write-5m-11HDD-RAID5-cfq-btrfs-100dd-x86_64-rhel-HEAD-a308edf16c35a3667e85e8545a530812915a71bf-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/vmlinuz-3.17.0-ga308edf kconfig=x86_64-rhel commit=a308edf16c35a3667e85e8545a530812915a71bf branch=linux-devel/devel-hourly-2014100822 root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd/debian-x86_64.cgz/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/0 ip=::::lkp-st02:eth1:dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw"
[  373.673403] ------------[ cut here ]------------
[  373.674366] kernel BUG at fs/btrfs/inode.c:3123!
[  373.674366] invalid opcode: 0000 [#1] SMP 
[  373.674366] Modules linked in: btrfs raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq ipmi_watchdog ipmi_msghandler ses enclosure sg sd_mod crc_t10dif crct10dif_generic crct10dif_common ata_generic pata_acpi snd_pcm snd_timer ata_piix parport_pc floppy snd i5400_edac parport soundcore libata i2c_i801 serio_raw mptsas pcspkr edac_core mptscsih tpm_infineon mptbase i5k_amb shpchp scsi_transport_sas
[  373.674366] CPU: 7 PID: 2172 Comm: btrfs-cleaner Not tainted 3.17.0-ga308edf #1
[  373.674366] Hardware name: Supermicro X7DW3/X7DWN, BIOS 6.00 09/28/2007
[  373.674366] task: ffff8800bd720000 ti: ffff8800bd728000 task.ti: ffff8800bd728000
[  373.674366] RIP: 0010:[<ffffffffa02257c0>]  [<ffffffffa02257c0>] btrfs_orphan_add+0x1c0/0x1e0 [btrfs]
[  373.674366] RSP: 0018:ffff8800bd72bca0  EFLAGS: 00010286
[  373.674366] RAX: 00000000ffffffe4 RBX: ffff88022da60800 RCX: ffff88022b8fe000
[  373.674366] RDX: 00000000000007d0 RSI: 0000000000040000 RDI: ffff88022b8fe138
[  373.674366] RBP: ffff8800bd72bcd0 R08: 000060fdd0002340 R09: ffff8801219343f0
[  373.674366] R10: ffffe8ffffdc2380 R11: ffffea0003004300 R12: ffff88010071ac98
[  373.674366] R13: ffff8800a7f90aa0 R14: ffff88022da60c58 R15: 0000000000000001
[  373.674366] FS:  0000000000000000(0000) GS:ffff88022fdc0000(0000) knlGS:0000000000000000
[  373.674366] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  373.674366] CR2: 00007f6bad137148 CR3: 000000022ec3c000 CR4: 00000000000007e0
[  373.674366] Stack:
[  373.674366]  ffffffffa0263691 ffff88021ad60000 ffff8801219343f0 0000000000000001
[  373.674366]  ffff88010071ac98 ffff880094ca1600 ffff8800bd72bd48 ffffffffa020f796
[  373.674366]  ffff8801219343f0 ffff880121934470 ffff880000000004 ffff88022da60800
[  373.674366] Call Trace:
[  373.674366]  [<ffffffffa0263691>] ? lookup_free_space_inode+0x41/0xf0 [btrfs]
[  373.674366]  [<ffffffffa020f796>] btrfs_remove_block_group+0x136/0x510 [btrfs]
[  373.674366]  [<ffffffffa0248e9a>] btrfs_remove_chunk+0x66a/0x7f0 [btrfs]
[  373.674366]  [<ffffffffa020fd8e>] btrfs_delete_unused_bgs+0x21e/0x250 [btrfs]
[  373.674366]  [<ffffffffa0218344>] cleaner_kthread+0x164/0x1e0 [btrfs]
[  373.674366]  [<ffffffffa02181e0>] ? write_all_supers+0xb70/0xb70 [btrfs]
[  373.674366]  [<ffffffff8108d19b>] kthread+0xdb/0x100
[  373.674366]  [<ffffffff8108d0c0>] ? kthread_create_on_node+0x180/0x180
[  373.674366]  [<ffffffff818600fc>] ret_from_fork+0x7c/0xb0
[  373.674366]  [<ffffffff8108d0c0>] ? kthread_create_on_node+0x180/0x180
[  373.674366] Code: 60 04 00 00 e9 b0 fe ff ff 66 90 89 45 d0 f0 41 80 64 24 80 fd 4c 89 e7 e8 3e 2a fe ff 8b 45 d0 e9 1b ff ff ff 66 0f 1f 44 00 00 <0f> 0b b8 f4 ff ff ff e9 10 ff ff ff 4c 89 f7 45 31 f6 e8 99 a2 
[  373.674366] RIP  [<ffffffffa02257c0>] btrfs_orphan_add+0x1c0/0x1e0 [btrfs]
[  373.674366]  RSP <ffff8800bd72bca0>
[  373.952497] ---[ end trace c0d0f39b387c06ce ]---
[  373.957232] Kernel panic - not syncing: Fatal exception


Thanks,
Fengguang

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-ga308edf (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Wed Oct 8 22:54:52 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-st02/cyclic_dd-write-5m-11HDD-RAID5-cfq-btrfs-10dd-x86_64-rhel-HEAD-a308edf16c35a3667e85e8545a530812915a71bf-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/vmlinuz-3.17.0-ga308edf kconfig=x86_64-rhel commit=a308edf16c35a3667e85e8545a530812915a71bf branch=linux-devel/devel-hourly-2014100822 root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-10dd/debian-x86_64.cgz/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/0 ip=::::lkp-st02:eth1:dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009c7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000cc000-0x00000000000d7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfefffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cff00000-0x00000000cff0bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cff0c000-0x00000000cff0cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cff0d000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Supermicro X7DW3/X7DWN, BIOS 6.00 09/28/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x230000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00D0000000 mask 3FF0000000 uncachable
[    0.000000]   1 base 00E0000000 mask 3FE0000000 uncachable
[    0.000000]   2 base 0000000000 mask 3E00000000 write-back
[    0.000000]   3 base 0200000000 mask 3FE0000000 write-back
[    0.000000]   4 base 0220000000 mask 3FF0000000 write-back
[    0.000000]   5 base 00CFF80000 mask 3FFFF80000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xcff80000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcff00 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f65f0-0x000f65ff] mapped at [ffff8800000f65f0]
[    0.000000]   mpc: 9d071-9d2a5
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x22f178000, 0x22f178fff] PGTABLE
[    0.000000] BRK [0x22f179000, 0x22f179fff] PGTABLE
[    0.000000] BRK [0x22f17a000, 0x22f17afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x22fe00000-0x22fffffff]
[    0.000000]  [mem 0x22fe00000-0x22fffffff] page 2M
[    0.000000] BRK [0x22f17b000, 0x22f17bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x22c000000-0x22fdfffff]
[    0.000000]  [mem 0x22c000000-0x22fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x22bffffff]
[    0.000000]  [mem 0x200000000-0x22bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xcfefffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcfefffff] page 4k
[    0.000000] BRK [0x22f17c000, 0x22f17cfff] PGTABLE
[    0.000000] BRK [0x22f17d000, 0x22f17dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x2266d3000-0x22dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F65C0 000024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 0x00000000CFF05D50 000074 (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 0x00000000CFF0BD22 0000F4 (v03 INTEL  STOAKLEY 06040000 PTL  00000003)
[    0.000000] ACPI: DSDT 0x00000000CFF074CE 0047E0 (v01 Intel  SEABURG  06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 0x00000000CFF0CFC0 000040
[    0.000000] ACPI: TCPA 0x00000000CFF0BE16 000032 (v01 Intel  STOAKLEY 06040000 LOHR 0000005A)
[    0.000000] ACPI: _MAR 0x00000000CFF0BE48 000030 (v01 Intel  OEMDMAR  06040000 LOHR 00000001)
[    0.000000] ACPI: APIC 0x00000000CFF0BE78 0000D4 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 0x00000000CFF0BF4C 00003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 0x00000000CFF0BF88 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 0x00000000CFF0BFB0 000050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 0x00000000CFF0726F 00025F (v01 PmRef  Cpu0Tst  00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 0x00000000CFF071C9 0000A6 (v01 PmRef  Cpu1Tst  00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 0x00000000CFF05DC4 001405 (v01 PmRef  CpuPm    00003000 INTL 20050228)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000022fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x22fffffff]
[    0.000000]   NODE_DATA [mem 0x22ffd4000-0x22fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0008bfffff] PMD -> [ffff88021e600000-ffff8802265fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x22fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xcfefffff]
[    0.000000]   node   0: [mem 0x100000000-0x22fffffff]
[    0.000000] On node 0 totalpages: 2096795
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13244 pages used for memmap
[    0.000000]   DMA32 zone: 847616 pages, LIFO batch:31
[    0.000000]   Normal zone: 19456 pages used for memmap
[    0.000000]   Normal zone: 1245184 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec86000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec86000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec89000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec89000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 8, APIC INT 02
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
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec86000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec89000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000cbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x000cc000-0x000d7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000d8000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcff00000-0xcff0bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcff0c000-0xcff0cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcff0d000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88022fc00000 s88960 r8192 d21632 u262144
[    0.000000] pcpu-alloc: s88960 r8192 d21632 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2064010
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-st02/cyclic_dd-write-5m-11HDD-RAID5-cfq-btrfs-10dd-x86_64-rhel-HEAD-a308edf16c35a3667e85e8545a530812915a71bf-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/vmlinuz-3.17.0-ga308edf kconfig=x86_64-rhel commit=a308edf16c35a3667e85e8545a530812915a71bf branch=linux-devel/devel-hourly-2014100822 root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-10dd/debian-x86_64.cgz/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/0 ip=::::lkp-st02:eth1:dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 8046616K/8387180K available (8596K kernel code, 1703K rwdata, 3832K rodata, 1808K init, 1888K bss, 340564K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:524544 nr_irqs:1304 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-ga308edf (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Wed Oct 8 22:54:52 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-st02/cyclic_dd-write-5m-11HDD-RAID5-cfq-btrfs-10dd-x86_64-rhel-HEAD-a308edf16c35a3667e85e8545a530812915a71bf-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/vmlinuz-3.17.0-ga308edf kconfig=x86_64-rhel commit=a308edf16c35a3667e85e8545a530812915a71bf branch=linux-devel/devel-hourly-2014100822 root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-10dd/debian-x86_64.cgz/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/0 ip=::::lkp-st02:eth1:dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009c7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000cc000-0x00000000000d7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfefffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cff00000-0x00000000cff0bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cff0c000-0x00000000cff0cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cff0d000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Supermicro X7DW3/X7DWN, BIOS 6.00 09/28/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x230000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00D0000000 mask 3FF0000000 uncachable
[    0.000000]   1 base 00E0000000 mask 3FE0000000 uncachable
[    0.000000]   2 base 0000000000 mask 3E00000000 write-back
[    0.000000]   3 base 0200000000 mask 3FE0000000 write-back
[    0.000000]   4 base 0220000000 mask 3FF0000000 write-back
[    0.000000]   5 base 00CFF80000 mask 3FFFF80000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xcff80000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcff00 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f65f0-0x000f65ff] mapped at [ffff8800000f65f0]
[    0.000000]   mpc: 9d071-9d2a5
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x22f178000, 0x22f178fff] PGTABLE
[    0.000000] BRK [0x22f179000, 0x22f179fff] PGTABLE
[    0.000000] BRK [0x22f17a000, 0x22f17afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x22fe00000-0x22fffffff]
[    0.000000]  [mem 0x22fe00000-0x22fffffff] page 2M
[    0.000000] BRK [0x22f17b000, 0x22f17bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x22c000000-0x22fdfffff]
[    0.000000]  [mem 0x22c000000-0x22fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x22bffffff]
[    0.000000]  [mem 0x200000000-0x22bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xcfefffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcfefffff] page 4k
[    0.000000] BRK [0x22f17c000, 0x22f17cfff] PGTABLE
[    0.000000] BRK [0x22f17d000, 0x22f17dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x2266d3000-0x22dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F65C0 000024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 0x00000000CFF05D50 000074 (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 0x00000000CFF0BD22 0000F4 (v03 INTEL  STOAKLEY 06040000 PTL  00000003)
[    0.000000] ACPI: DSDT 0x00000000CFF074CE 0047E0 (v01 Intel  SEABURG  06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 0x00000000CFF0CFC0 000040
[    0.000000] ACPI: TCPA 0x00000000CFF0BE16 000032 (v01 Intel  STOAKLEY 06040000 LOHR 0000005A)
[    0.000000] ACPI: _MAR 0x00000000CFF0BE48 000030 (v01 Intel  OEMDMAR  06040000 LOHR 00000001)
[    0.000000] ACPI: APIC 0x00000000CFF0BE78 0000D4 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: MCFG 0x00000000CFF0BF4C 00003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 0x00000000CFF0BF88 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SPCR 0x00000000CFF0BFB0 000050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: SSDT 0x00000000CFF0726F 00025F (v01 PmRef  Cpu0Tst  00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 0x00000000CFF071C9 0000A6 (v01 PmRef  Cpu1Tst  00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 0x00000000CFF05DC4 001405 (v01 PmRef  CpuPm    00003000 INTL 20050228)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000022fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x22fffffff]
[    0.000000]   NODE_DATA [mem 0x22ffd4000-0x22fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0008bfffff] PMD -> [ffff88021e600000-ffff8802265fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x22fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xcfefffff]
[    0.000000]   node   0: [mem 0x100000000-0x22fffffff]
[    0.000000] On node 0 totalpages: 2096795
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13244 pages used for memmap
[    0.000000]   DMA32 zone: 847616 pages, LIFO batch:31
[    0.000000]   Normal zone: 19456 pages used for memmap
[    0.000000]   Normal zone: 1245184 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec86000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec86000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec89000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec89000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 00, APIC ID 8, APIC INT 02
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
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec86000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec89000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000cbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x000cc000-0x000d7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000d8000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcff00000-0xcff0bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcff0c000-0xcff0cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcff0d000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88022fc00000 s88960 r8192 d21632 u262144
[    0.000000] pcpu-alloc: s88960 r8192 d21632 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2064010
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-st02/cyclic_dd-write-5m-11HDD-RAID5-cfq-btrfs-10dd-x86_64-rhel-HEAD-a308edf16c35a3667e85e8545a530812915a71bf-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/vmlinuz-3.17.0-ga308edf kconfig=x86_64-rhel commit=a308edf16c35a3667e85e8545a530812915a71bf branch=linux-devel/devel-hourly-2014100822 root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-10dd/debian-x86_64.cgz/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/0 ip=::::lkp-st02:eth1:dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 8046616K/8387180K available (8596K kernel code, 1703K rwdata, 3832K rodata, 1808K init, 1888K bss, 340564K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:524544 nr_irqs:1304 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2666.750 MHz processor
[    0.000016] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.50 BogoMIPS (lpj=2666750)
[    0.001000] pid_max: default: 32768 minimum: 301
[    0.001000] ACPI: Core revision 20140724
[    0.001000] ACPI: All ACPI Tables successfully acquired
[    0.001000] Security Framework initialized
[    0.001000] SELinux:  Initializing.
[    0.001000] SELinux:  Starting in permissive mode
[    0.001000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.001000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001000] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.001000] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.001000] Initializing cgroup subsys memory
[    0.001000] Initializing cgroup subsys devices
[    0.001000] Initializing cgroup subsys freezer
[    0.001000] Initializing cgroup subsys net_cls
[    0.001000] Initializing cgroup subsys blkio
[    0.001000] Initializing cgroup subsys perf_event
[    0.001000] Initializing cgroup subsys hugetlb
[    0.001000] CPU: Physical Processor ID: 0
[    0.001000] CPU: Processor Core ID: 0
[    0.001000] mce: CPU supports 6 MCE banks
[    0.001000] CPU0: Thermal LVT vector (0xfa) already installed
[    0.001000] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.001000] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
[    0.001000] Freeing SMP alternatives memory: 36K (ffffffff81f95000 - ffffffff81f9e000)
[    0.001000] ftrace: allocating 31108 entries in 122 pages
[    0.001000] Getting VERSION: 50014
[    0.001000] Getting VERSION: 50014
[    0.001000] Getting ID: 0
[    0.001000] Getting ID: 0
[    0.001000] masked ExtINT on CPU#0
[    0.001000] ENABLING IO-APIC IRQs
[    0.001000] init IO_APIC IRQs
[    0.001000]  apic 8 pin 0 not connected
[    0.001000] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.001000] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.001000] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.001012] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.002005] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.003004] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.004004] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.005004] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.006004] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.007004] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.008005] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.009004] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.010004] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.011004] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.012005] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.013005] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.014003]  apic 8 pin 16 not connected
[    0.015001]  apic 8 pin 17 not connected
[    0.016001]  apic 8 pin 18 not connected
[    0.017001]  apic 8 pin 19 not connected
[    0.018001]  apic 8 pin 20 not connected
[    0.019001]  apic 8 pin 21 not connected
[    0.020001]  apic 8 pin 22 not connected
[    0.021001]  apic 8 pin 23 not connected
[    0.022001]  apic 9 pin 0 not connected
[    0.023001]  apic 9 pin 1 not connected
[    0.024001]  apic 9 pin 2 not connected
[    0.025001]  apic 9 pin 3 not connected
[    0.026001]  apic 9 pin 4 not connected
[    0.027001]  apic 9 pin 5 not connected
[    0.028001]  apic 9 pin 6 not connected
[    0.029001]  apic 9 pin 7 not connected
[    0.030001]  apic 9 pin 8 not connected
[    0.031001]  apic 9 pin 9 not connected
[    0.032001]  apic 9 pin 10 not connected
[    0.033001]  apic 9 pin 11 not connected
[    0.034001]  apic 9 pin 12 not connected
[    0.035001]  apic 9 pin 13 not connected
[    0.036001]  apic 9 pin 14 not connected
[    0.037001]  apic 9 pin 15 not connected
[    0.038001]  apic 9 pin 16 not connected
[    0.039001]  apic 9 pin 17 not connected
[    0.040001]  apic 9 pin 18 not connected
[    0.041001]  apic 9 pin 19 not connected
[    0.042001]  apic 9 pin 20 not connected
[    0.043001]  apic 9 pin 21 not connected
[    0.044001]  apic 9 pin 22 not connected
[    0.045001]  apic 9 pin 23 not connected
[    0.046001]  apic 10 pin 0 not connected
[    0.047001]  apic 10 pin 1 not connected
[    0.048001]  apic 10 pin 2 not connected
[    0.049001]  apic 10 pin 3 not connected
[    0.050001]  apic 10 pin 4 not connected
[    0.051001]  apic 10 pin 5 not connected
[    0.052001]  apic 10 pin 6 not connected
[    0.053001]  apic 10 pin 7 not connected
[    0.054001]  apic 10 pin 8 not connected
[    0.055001]  apic 10 pin 9 not connected
[    0.056001]  apic 10 pin 10 not connected
[    0.057001]  apic 10 pin 11 not connected
[    0.058001]  apic 10 pin 12 not connected
[    0.059001]  apic 10 pin 13 not connected
[    0.060001]  apic 10 pin 14 not connected
[    0.061001]  apic 10 pin 15 not connected
[    0.062001]  apic 10 pin 16 not connected
[    0.063001]  apic 10 pin 17 not connected
[    0.064001]  apic 10 pin 18 not connected
[    0.065001]  apic 10 pin 19 not connected
[    0.066001]  apic 10 pin 20 not connected
[    0.067001]  apic 10 pin 21 not connected
[    0.068001]  apic 10 pin 22 not connected
[    0.069001]  apic 10 pin 23 not connected
[    0.070135] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.081595] smpboot: CPU0: Genuine Intel(R) CPU                  @ 2.66GHz (fam: 06, model: 0f, stepping: 0b)
[    0.085001] Using local APIC timer interrupts.
[    0.085001] calibrating APIC timer ...
[    0.087000] ... lapic delta = 2083095
[    0.087000] ... PM-Timer delta = 357901
[    0.087000] ... PM-Timer result ok
[    0.087000] ..... delta 2083095
[    0.087000] ..... mult: 89468248
[    0.087000] ..... calibration result: 333295
[    0.087000] ..... CPU clock speed is 2666.0362 MHz.
[    0.087000] ..... host bus clock speed is 333.0295 MHz.
[    0.087038] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.092001] perf_event_intel: PEBS disabled due to CPU errata
[    0.093002] ... version:                2
[    0.094001] ... bit width:              40
[    0.095001] ... generic registers:      2
[    0.096001] ... value mask:             000000ffffffffff
[    0.097001] ... max period:             000000007fffffff
[    0.098001] ... fixed-purpose events:   3
[    0.099001] ... event mask:             0000000700000003
[    0.102690] x86: Booting SMP configuration:
[    0.103002] .... node  #0, CPUs:      #1
[    0.102580] masked ExtINT on CPU#1
[    0.102580] CPU1: Thermal LVT vector (0xfa) already installed
[    0.186200] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.187120]  #2
[    0.187019] masked ExtINT on CPU#2
[    0.187019] CPU2: Thermal LVT vector (0xfa) already installed
[    0.209184]  #3
[    0.209042] masked ExtINT on CPU#3
[    0.209042] CPU3: Thermal LVT vector (0xfa) already installed
[    0.232078]  #4
[    0.231013] masked ExtINT on CPU#4
[    0.231013] CPU4: Thermal LVT vector (0xfa) already installed
[    0.255125]  #5
[    0.255014] masked ExtINT on CPU#5
[    0.255014] CPU5: Thermal LVT vector (0xfa) already installed
[    0.278112]  #6
[    0.278013] masked ExtINT on CPU#6
[    0.278013] CPU6: Thermal LVT vector (0xfa) already installed
[    0.300122]  #7
[    0.300014] masked ExtINT on CPU#7
[    0.300014] CPU7: Thermal LVT vector (0xfa) already installed
[    0.322012] x86: Booted up 1 node, 8 CPUs
[    0.323003] smpboot: Total of 8 processors activated (42664.37 BogoMIPS)
[    0.325361] devtmpfs: initialized
[    0.329865] evm: security.selinux
[    0.330001] evm: security.ima
[    0.331001] evm: security.capability
[    0.332119] PM: Registering ACPI NVS region [mem 0xcff0c000-0xcff0cfff] (4096 bytes)
[    0.334591] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.335130] NET: Registered protocol family 16
[    0.336240] cpuidle: using governor menu
[    0.337136] ACPI: bus type PCI registered
[    0.338002] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.339076] PCI: MMCONFIG for domain 0000 [bus 00-09] at [mem 0xe0000000-0xe09fffff] (base 0xe0000000)
[    0.340003] PCI: MMCONFIG at [mem 0xe0000000-0xe09fffff] reserved in E820
[    0.341030] PCI: Using configuration type 1 for base access
[    0.347081] ACPI: Added _OSI(Module Device)
[    0.351004] ACPI: Added _OSI(Processor Device)
[    0.355001] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.360002] ACPI: Added _OSI(Processor Aggregator Device)
[    0.366472] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:255)
[    0.376981] ACPI: Interpreter enabled
[    0.381010] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.390002] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140724/hwxface-580)
[    0.400008] ACPI: (supports S0 S1 S4 S5)
[    0.404001] ACPI: Using IOAPIC for interrupt routing
[    0.409024] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.422227] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.428006] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.437005] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.444335] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.451002] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.459002] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.468002] acpi PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.476005] acpi PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff] (ignored)
[    0.484002] acpi PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff] (ignored)
[    0.492002] PCI: root bus 00: using default resources
[    0.497003] acpi PNP0A03:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-09] only partially covers this bridge
[    0.508116] PCI host bridge to bus 0000:00
[    0.513003] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.518002] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.524002] pci_bus 0000:00: root bus resource [mem 0x00000000-0x3fffffffff]
[    0.532013] pci 0000:00:00.0: [8086:4003] type 00 class 0x060000
[    0.538049] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.544072] pci 0000:00:01.0: [8086:4021] type 01 class 0x060400
[    0.550048] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.556033] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.562047] pci 0000:00:03.0: [8086:4023] type 01 class 0x060400
[    0.568047] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.575075] pci 0000:00:05.0: [8086:4025] type 01 class 0x060400
[    0.581047] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.587031] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.593047] pci 0000:00:07.0: [8086:4027] type 01 class 0x060400
[    0.599046] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.605074] pci 0000:00:09.0: [8086:4029] type 01 class 0x060400
[    0.612047] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.618030] pci 0000:00:09.0: System wakeup disabled by ACPI
[    0.624048] pci 0000:00:0f.0: [8086:402f] type 00 class 0x088000
[    0.630010] pci 0000:00:0f.0: reg 0x10: [mem 0xfe700000-0xfe703fff 64bit]
[    0.637087] pci 0000:00:10.0: [8086:4030] type 00 class 0x060000
[    0.643070] pci 0000:00:10.1: [8086:4030] type 00 class 0x060000
[    0.649070] pci 0000:00:10.2: [8086:4030] type 00 class 0x060000
[    0.655069] pci 0000:00:10.3: [8086:4030] type 00 class 0x060000
[    0.661070] pci 0000:00:10.4: [8086:4030] type 00 class 0x060000
[    0.668073] pci 0000:00:11.0: [8086:4031] type 00 class 0x060000
[    0.674070] pci 0000:00:15.0: [8086:4035] type 00 class 0x060000
[    0.680073] pci 0000:00:15.1: [8086:4035] type 00 class 0x060000
[    0.686078] pci 0000:00:16.0: [8086:4036] type 00 class 0x060000
[    0.692069] pci 0000:00:16.1: [8086:4036] type 00 class 0x060000
[    0.699086] pci 0000:00:1c.0: [8086:2690] type 01 class 0x060400
[    0.705072] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.711035] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.717050] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[    0.723038] pci 0000:00:1d.0: reg 0x20: [io  0x1800-0x181f]
[    0.729051] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.735045] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[    0.741036] pci 0000:00:1d.1: reg 0x20: [io  0x1820-0x183f]
[    0.747061] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.752045] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[    0.759039] pci 0000:00:1d.2: reg 0x20: [io  0x1840-0x185f]
[    0.764058] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.770052] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[    0.776019] pci 0000:00:1d.7: reg 0x10: [mem 0xd8704000-0xd87043ff]
[    0.783079] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.789033] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.795044] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.801072] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.807044] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[    0.813073] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.819070] pci 0000:00:1f.2: [8086:2680] type 00 class 0x01018a
[    0.825014] pci 0000:00:1f.2: reg 0x10: [io  0x0000-0x0007]
[    0.831008] pci 0000:00:1f.2: reg 0x14: [io  0x0000-0x0003]
[    0.837008] pci 0000:00:1f.2: reg 0x18: [io  0x0000-0x0007]
[    0.842008] pci 0000:00:1f.2: reg 0x1c: [io  0x0000-0x0003]
[    0.848008] pci 0000:00:1f.2: reg 0x20: [io  0x1880-0x188f]
[    0.854009] pci 0000:00:1f.2: reg 0x24: [mem 0xd8700000-0xd87003ff]
[    0.860011] pci 0000:00:1f.2: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.867003] pci 0000:00:1f.2: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.874002] pci 0000:00:1f.2: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.881002] pci 0000:00:1f.2: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.888020] pci 0000:00:1f.2: PME# supported from D3hot
[    0.893066] pci 0000:00:1f.3: [8086:269b] type 00 class 0x0c0500
[    0.899049] pci 0000:00:1f.3: reg 0x20: [io  0x1100-0x111f]
[    0.905135] pci 0000:01:00.0: [1000:0058] type 00 class 0x010000
[    0.911013] pci 0000:01:00.0: reg 0x10: [io  0x2000-0x20ff]
[    0.917012] pci 0000:01:00.0: reg 0x14: [mem 0xd8510000-0xd8513fff 64bit]
[    0.924012] pci 0000:01:00.0: reg 0x1c: [mem 0xd8500000-0xd850ffff 64bit]
[    0.931014] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x001fffff pref]
[    0.938041] pci 0000:01:00.0: supports D1 D2
[    0.942043] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.952008] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.957003] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    0.964003] pci 0000:00:01.0:   bridge window [mem 0xd8500000-0xd85fffff]
[    0.971005] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xd81fffff 64bit pref]
[    0.979041] pci 0000:00:03.0: PCI bridge to [bus 02]
[    0.984045] pci 0000:00:05.0: PCI bridge to [bus 03]
[    0.989067] pci 0000:04:00.0: [8086:3500] type 01 class 0x060400
[    0.995062] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    1.001065] pci 0000:04:00.3: [8086:350c] type 01 class 0x060400
[    1.007058] pci 0000:04:00.3: PME# supported from D0 D3hot D3cold
[    1.014022] pci 0000:04:00.3: System wakeup disabled by ACPI
[    1.019041] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.030008] pci 0000:00:07.0: PCI bridge to [bus 04-07]
[    1.035003] pci 0000:00:07.0:   bridge window [io  0x3000-0x3fff]
[    1.041003] pci 0000:00:07.0:   bridge window [mem 0xd8200000-0xd83fffff]
[    1.048004] pci 0000:00:07.0:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.056063] pci 0000:05:00.0: [8086:3510] type 01 class 0x060400
[    1.062066] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.069022] pci 0000:05:00.0: System wakeup disabled by ACPI
[    1.074038] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.085027] pci 0000:04:00.0: PCI bridge to [bus 05-06]
[    1.090055] pci 0000:05:00.0: PCI bridge to [bus 06]
[    1.095070] pci 0000:07:01.0: [8086:107c] type 00 class 0x020000
[    1.101017] pci 0000:07:01.0: reg 0x10: [mem 0xd8220000-0xd823ffff]
[    1.108009] pci 0000:07:01.0: reg 0x14: [mem 0xd8200000-0xd821ffff]
[    1.114009] pci 0000:07:01.0: reg 0x18: [io  0x3000-0x303f]
[    1.120028] pci 0000:07:01.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.127032] pci 0000:07:01.0: PME# supported from D0 D3hot D3cold
[    1.133074] pci 0000:04:00.3: PCI bridge to [bus 07]
[    1.138003] pci 0000:04:00.3:   bridge window [io  0x3000-0x3fff]
[    1.144004] pci 0000:04:00.3:   bridge window [mem 0xd8200000-0xd82fffff]
[    1.151005] pci 0000:04:00.3:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.159063] pci 0000:08:00.0: [8086:10a7] type 00 class 0x020000
[    1.165015] pci 0000:08:00.0: reg 0x10: [mem 0xd8420000-0xd843ffff]
[    1.172009] pci 0000:08:00.0: reg 0x14: [mem 0xd8400000-0xd841ffff]
[    1.178009] pci 0000:08:00.0: reg 0x18: [io  0x4000-0x401f]
[    1.184009] pci 0000:08:00.0: reg 0x1c: [mem 0xd8480000-0xd8483fff]
[    1.190023] pci 0000:08:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.197049] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    1.203070] pci 0000:08:00.1: [8086:10a7] type 00 class 0x020000
[    1.209014] pci 0000:08:00.1: reg 0x10: [mem 0xd8460000-0xd847ffff]
[    1.216009] pci 0000:08:00.1: reg 0x14: [mem 0xd8440000-0xd845ffff]
[    1.222010] pci 0000:08:00.1: reg 0x18: [io  0x4020-0x403f]
[    1.228009] pci 0000:08:00.1: reg 0x1c: [mem 0xd8484000-0xd8487fff]
[    1.234023] pci 0000:08:00.1: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.241049] pci 0000:08:00.1: PME# supported from D0 D3hot D3cold
[    1.249014] pci 0000:00:09.0: PCI bridge to [bus 08]
[    1.254004] pci 0000:00:09.0:   bridge window [io  0x4000-0x4fff]
[    1.260003] pci 0000:00:09.0:   bridge window [mem 0xd8400000-0xd84fffff]
[    1.267004] pci 0000:00:09.0:   bridge window [mem 0xd8900000-0xd89fffff 64bit pref]
[    1.275056] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    1.280004] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    1.286004] pci 0000:00:1c.0:   bridge window [mem 0xd8a00000-0xd8bfffff]
[    1.293006] pci 0000:00:1c.0:   bridge window [mem 0x230000000-0x2301fffff 64bit pref]
[    1.301046] pci 0000:0a:01.0: [1002:515e] type 00 class 0x030000
[    1.308018] pci 0000:0a:01.0: reg 0x10: [mem 0xd0000000-0xd7ffffff pref]
[    1.314010] pci 0000:0a:01.0: reg 0x14: [io  0x5000-0x50ff]
[    1.320010] pci 0000:0a:01.0: reg 0x18: [mem 0xd8600000-0xd860ffff]
[    1.326034] pci 0000:0a:01.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.333029] pci 0000:0a:01.0: supports D1 D2
[    1.338074] pci 0000:00:1e.0: PCI bridge to [bus 0a] (subtractive decode)
[    1.345004] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    1.351004] pci 0000:00:1e.0:   bridge window [mem 0xd8600000-0xd86fffff]
[    1.358006] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.366003] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    1.374002] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0x3fffffffff] (subtractive decode)
[    1.383030] pci 0000:04:00.3: Max Payload Size 256, but upstream 0000:00:07.0 set to 128; if necessary, use "pci=pcie_bus_safe" and report a bug
[    1.396051] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:255)
[    1.404111] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:255)
[    1.413087] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 14 15), disabled.
[    1.421346] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15), disabled.
[    1.430344] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15), disabled.
[    1.439043] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    1.448042] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 14 15), disabled.
[    1.456344] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 *11 14 15), disabled.
[    1.465352] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 14 15), disabled.
[    1.474043] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *9, disabled.
[    1.485054] vgaarb: setting as boot device: PCI:0000:0a:01.0
[    1.486000] vgaarb: device added: PCI:0000:0a:01.0,decodes=io+mem,owns=io+mem,locks=none
[    1.499003] vgaarb: loaded
[    1.502002] vgaarb: bridge control possible 0000:0a:01.0
[    1.507150] SCSI subsystem initialized
[    1.511037] ACPI: bus type USB registered
[    1.515029] usbcore: registered new interface driver usbfs
[    1.521011] usbcore: registered new interface driver hub
[    1.526018] usbcore: registered new device driver usb
[    1.531029] pps_core: LinuxPPS API ver. 1 registered
[    1.537001] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.546010] PTP clock support registered
[    1.550045] PCI: Using ACPI for IRQ routing
[    1.554005] PCI: pci_cache_line_size set to 64 bytes
[    1.559073] e820: reserve RAM buffer [mem 0x0009c800-0x0009ffff]
[    1.566003] e820: reserve RAM buffer [mem 0xcff00000-0xcfffffff]
[    1.572141] NetLabel: Initializing
[    1.575002] NetLabel:  domain hash size = 128
[    1.580001] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.585016] NetLabel:  unlabeled traffic allowed by default
[    1.591223] hpet clockevent registered
[    1.595003] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.602004] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.607305] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.616050] Switched to clocksource hpet
[    1.633750] pnp: PnP ACPI init
[    1.637235] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    1.643276] system 00:00: [io  0x0295-0x0296] has been reserved
[    1.649314] system 00:00: [io  0x0ca2-0x0ca3] has been reserved
[    1.655355] system 00:00: [io  0x0ca8-0x0caf] has been reserved
[    1.661394] system 00:00: [io  0x0800-0x080f] has been reserved
[    1.667437] system 00:00: [io  0x1000-0x107f] could not be reserved
[    1.673822] system 00:00: [io  0x1180-0x11bf] has been reserved
[    1.679864] system 00:00: [io  0xfe00] has been reserved
[    1.685297] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    1.692033] system 00:00: [mem 0xfee00000-0xfee0ffff] could not be reserved
[    1.699112] system 00:00: [mem 0xfec86000-0xfec86fff] could not be reserved
[    1.706192] system 00:00: [mem 0xfec89000-0xfec89fff] could not be reserved
[    1.713274] system 00:00: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.720006] system 00:00: [mem 0xfe000000-0xfe01ffff] has been reserved
[    1.726741] system 00:00: [mem 0xfe600000-0xfe6fffff] has been reserved
[    1.733477] system 00:00: [mem 0xfed20000-0xfed44fff] has been reserved
[    1.740215] system 00:00: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.746946] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.753911] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.760671] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:255)
[    1.768969] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    1.776397] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:255)
[    1.784860] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.791647] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:255)
[    1.799976] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.806756] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:255)
[    1.815076] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.821897] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:255)
[    1.830174] pnp 00:06: [dma 2]
[    1.833382] pnp 00:06: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.840101] pnp: PnP ACPI: found 7 devices
[    1.851202] pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd81fffff pref]
[    1.858606] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.863692] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    1.869910] pci 0000:00:01.0:   bridge window [mem 0xd8500000-0xd85fffff]
[    1.876815] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xd81fffff 64bit pref]
[    1.884747] pci 0000:00:03.0: PCI bridge to [bus 02]
[    1.889835] pci 0000:00:05.0: PCI bridge to [bus 03]
[    1.894923] pci 0000:05:00.0: PCI bridge to [bus 06]
[    1.900013] pci 0000:04:00.0: PCI bridge to [bus 05-06]
[    1.905361] pci 0000:07:01.0: BAR 6: assigned [mem 0xd8240000-0xd825ffff pref]
[    1.912762] pci 0000:04:00.3: PCI bridge to [bus 07]
[    1.917841] pci 0000:04:00.3:   bridge window [io  0x3000-0x3fff]
[    1.924057] pci 0000:04:00.3:   bridge window [mem 0xd8200000-0xd82fffff]
[    1.930965] pci 0000:04:00.3:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.938897] pci 0000:00:07.0: PCI bridge to [bus 04-07]
[    1.944241] pci 0000:00:07.0:   bridge window [io  0x3000-0x3fff]
[    1.950456] pci 0000:00:07.0:   bridge window [mem 0xd8200000-0xd83fffff]
[    1.957361] pci 0000:00:07.0:   bridge window [mem 0xd8800000-0xd88fffff 64bit pref]
[    1.965286] pci 0000:08:00.0: BAR 6: assigned [mem 0xd84a0000-0xd84bffff pref]
[    1.972693] pci 0000:08:00.1: BAR 6: assigned [mem 0xd84c0000-0xd84dffff pref]
[    1.980102] pci 0000:00:09.0: PCI bridge to [bus 08]
[    1.985183] pci 0000:00:09.0:   bridge window [io  0x4000-0x4fff]
[    1.991398] pci 0000:00:09.0:   bridge window [mem 0xd8400000-0xd84fffff]
[    1.998304] pci 0000:00:09.0:   bridge window [mem 0xd8900000-0xd89fffff 64bit pref]
[    2.006236] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    2.011322] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    2.017536] pci 0000:00:1c.0:   bridge window [mem 0xd8a00000-0xd8bfffff]
[    2.024444] pci 0000:00:1c.0:   bridge window [mem 0x230000000-0x2301fffff 64bit pref]
[    2.032548] pci 0000:0a:01.0: BAR 6: assigned [mem 0xd8620000-0xd863ffff pref]
[    2.039956] pci 0000:00:1e.0: PCI bridge to [bus 0a]
[    2.045042] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    2.051258] pci 0000:00:1e.0:   bridge window [mem 0xd8600000-0xd86fffff]
[    2.058166] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    2.066098] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    2.071786] pci_bus 0000:00: resource 5 [mem 0x00000000-0x3fffffffff]
[    2.078348] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    2.084033] pci_bus 0000:01: resource 1 [mem 0xd8500000-0xd85fffff]
[    2.090421] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xd81fffff 64bit pref]
[    2.097822] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    2.103517] pci_bus 0000:04: resource 1 [mem 0xd8200000-0xd83fffff]
[    2.109904] pci_bus 0000:04: resource 2 [mem 0xd8800000-0xd88fffff 64bit pref]
[    2.117304] pci_bus 0000:07: resource 0 [io  0x3000-0x3fff]
[    2.122990] pci_bus 0000:07: resource 1 [mem 0xd8200000-0xd82fffff]
[    2.129378] pci_bus 0000:07: resource 2 [mem 0xd8800000-0xd88fffff 64bit pref]
[    2.136786] pci_bus 0000:08: resource 0 [io  0x4000-0x4fff]
[    2.142472] pci_bus 0000:08: resource 1 [mem 0xd8400000-0xd84fffff]
[    2.148859] pci_bus 0000:08: resource 2 [mem 0xd8900000-0xd89fffff 64bit pref]
[    2.156260] pci_bus 0000:09: resource 0 [io  0x6000-0x6fff]
[    2.161945] pci_bus 0000:09: resource 1 [mem 0xd8a00000-0xd8bfffff]
[    2.168333] pci_bus 0000:09: resource 2 [mem 0x230000000-0x2301fffff 64bit pref]
[    2.175910] pci_bus 0000:0a: resource 0 [io  0x5000-0x5fff]
[    2.181602] pci_bus 0000:0a: resource 1 [mem 0xd8600000-0xd86fffff]
[    2.187990] pci_bus 0000:0a: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    2.195391] pci_bus 0000:0a: resource 4 [io  0x0000-0xffff]
[    2.201086] pci_bus 0000:0a: resource 5 [mem 0x00000000-0x3fffffffff]
[    2.207677] NET: Registered protocol family 2
[    2.212422] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    2.220117] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.227353] TCP: Hash tables configured (established 65536 bind 65536)
[    2.234054] TCP: reno registered
[    2.237411] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    2.243687] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    2.250474] NET: Registered protocol family 1
[    2.255106] RPC: Registered named UNIX socket transport module.
[    2.261149] RPC: Registered udp transport module.
[    2.265972] RPC: Registered tcp transport module.
[    2.270791] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.277545] IOAPIC[0]: Set routing entry (8-20 -> 0x41 -> IRQ 20 Mode:1 Active:1 Dest:255)
[    2.286173] IOAPIC[0]: Set routing entry (8-21 -> 0x51 -> IRQ 21 Mode:1 Active:1 Dest:255)
[    2.294781] IOAPIC[0]: Set routing entry (8-22 -> 0x61 -> IRQ 22 Mode:1 Active:1 Dest:255)
[    2.303396] IOAPIC[0]: Set routing entry (8-23 -> 0x71 -> IRQ 23 Mode:1 Active:1 Dest:255)
[    2.311950] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
[    2.318264] PCI: CLS mismatch (32 != 64), using 64 bytes
[    2.323696] pci 0000:08:00.0: Disabling L0s
[    2.327999] pci 0000:08:00.0: can't disable ASPM; OS doesn't have ASPM control
[    2.335410] pci 0000:08:00.1: Disabling L0s
[    2.339709] pci 0000:08:00.1: can't disable ASPM; OS doesn't have ASPM control
[    2.347116] pci 0000:0a:01.0: Video device with shadowed ROM
[    2.352976] Unpacking initramfs...
[    4.838289] Freeing initrd memory: 124084K (ffff8802266d3000 - ffff88022e000000)
[    4.845895] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.852460] software IO TLB [mem 0xcbf00000-0xcff00000] (64MB) mapped at [ffff8800cbf00000-ffff8800cfefffff]
[    4.862621] Simple Boot Flag at 0x41 set to 0x1
[    4.868419] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    4.874870] Initialise system trusted keyring
[    4.879372] audit: initializing netlink subsys (disabled)
[    4.884924] audit: type=2000 audit(1412815329.883:1): initialized
[    4.891492] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.901630] zpool: loaded
[    4.904368] zbud: loaded
[    4.907182] VFS: Disk quotas dquot_6.5.2
[    4.911275] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.918478] SGI XFS with ACLs, security attributes, no debug enabled
[    4.925475] 9p: Installing v9fs 9p2000 file system support
[    4.931122] msgmni has been set to 15958
[    4.935242] Key type big_key registered
[    4.939201] SELinux:  Registering netfilter hooks
[    4.944989] NET: Registered protocol family 38
[    4.949563] Key type asymmetric registered
[    4.953777] Asymmetric key parser 'x509' registered
[    4.958823] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    4.966472] io scheduler noop registered
[    4.970515] io scheduler deadline registered (default)
[    4.975780] io scheduler cfq registered
[    4.979984] IOAPIC[2]: Set routing entry (10-0 -> 0x81 -> IRQ 24 Mode:1 Active:1 Dest:255)
[    4.988552] IOAPIC[2]: Set routing entry (10-2 -> 0x91 -> IRQ 25 Mode:1 Active:1 Dest:255)
[    4.997108] IOAPIC[2]: Set routing entry (10-4 -> 0xa1 -> IRQ 26 Mode:1 Active:1 Dest:255)
[    5.005666] IOAPIC[2]: Set routing entry (10-6 -> 0xb1 -> IRQ 27 Mode:1 Active:1 Dest:255)
[    5.014220] IOAPIC[2]: Set routing entry (10-8 -> 0xc1 -> IRQ 28 Mode:1 Active:1 Dest:255)
[    5.022776] IOAPIC[0]: Set routing entry (8-16 -> 0xd1 -> IRQ 16 Mode:1 Active:1 Dest:255)
[    5.031245] pcieport 0000:00:1c.0: irq 29 for MSI/MSI-X
[    5.036800] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.042507] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.049288] intel_idle: does not run on family 6 model 15
[    5.054897] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/PNP0C0C:00/input/input0
[    5.064392] ACPI: Power Button [PWRB]
[    5.068219] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    5.075803] ACPI: Power Button [PWRF]
[    5.082737] GHES: HEST is not enabled!
[    5.086755] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.113671] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    5.141707] 00:05: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    5.149726] Non-volatile memory driver v1.3
[    5.154054] Linux agpgart interface v0.103
[    5.159067] rdac: device handler registered
[    5.163416] hp_sw: device handler registered
[    5.167811] emc: device handler registered
[    5.172029] alua: device handler registered
[    5.176367] libphy: Fixed MDIO Bus: probed
[    5.180632] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    5.187801] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    5.193741] IOAPIC[1]: Set routing entry (9-0 -> 0x22 -> IRQ 30 Mode:1 Active:1 Dest:255)
[    5.608048] e1000 0000:07:01.0 eth0: (PCI:66MHz:32-bit) 00:0e:0c:c3:8f:a8
[    5.614959] e1000 0000:07:01.0 eth0: Intel(R) PRO/1000 Network Connection
[    5.621882] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    5.627835] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    5.633897] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.13-k
[    5.641059] igb: Copyright (c) 2007-2014 Intel Corporation.
[    5.647015] igb 0000:08:00.0: irq 31 for MSI/MSI-X
[    5.651932] igb 0000:08:00.0: irq 32 for MSI/MSI-X
[    5.656847] igb 0000:08:00.0: irq 33 for MSI/MSI-X
[    5.661764] igb 0000:08:00.0: irq 34 for MSI/MSI-X
[    5.666674] igb 0000:08:00.0: irq 35 for MSI/MSI-X
[    5.671587] igb 0000:08:00.0: irq 36 for MSI/MSI-X
[    5.676501] igb 0000:08:00.0: irq 37 for MSI/MSI-X
[    5.681415] igb 0000:08:00.0: irq 38 for MSI/MSI-X
[    5.686329] igb 0000:08:00.0: irq 39 for MSI/MSI-X
[    5.862087] igb 0000:08:00.0: irq 31 for MSI/MSI-X
[    5.867011] igb 0000:08:00.0: irq 32 for MSI/MSI-X
[    5.871926] tsc: Refined TSC clocksource calibration: 2666.760 MHz
[    5.878237] igb 0000:08:00.0: irq 33 for MSI/MSI-X
[    5.883151] igb 0000:08:00.0: irq 34 for MSI/MSI-X
[    5.888062] igb 0000:08:00.0: irq 35 for MSI/MSI-X
[    5.892978] igb 0000:08:00.0: irq 36 for MSI/MSI-X
[    5.897892] igb 0000:08:00.0: irq 37 for MSI/MSI-X
[    5.902805] igb 0000:08:00.0: irq 38 for MSI/MSI-X
[    5.907718] igb 0000:08:00.0: irq 39 for MSI/MSI-X
[    6.095697] igb 0000:08:00.0: Intel(R) Gigabit Ethernet Network Connection
[    6.102692] igb 0000:08:00.0: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:7c:cf:72
[    6.109945] igb 0000:08:00.0: eth1: PBA No: Unknown
[    6.114944] igb 0000:08:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    6.122727] IOAPIC[2]: Set routing entry (10-22 -> 0xa3 -> IRQ 40 Mode:1 Active:1 Dest:255)
[    6.131477] igb 0000:08:00.1: irq 41 for MSI/MSI-X
[    6.136390] igb 0000:08:00.1: irq 42 for MSI/MSI-X
[    6.141304] igb 0000:08:00.1: irq 43 for MSI/MSI-X
[    6.146218] igb 0000:08:00.1: irq 44 for MSI/MSI-X
[    6.151132] igb 0000:08:00.1: irq 45 for MSI/MSI-X
[    6.156046] igb 0000:08:00.1: irq 46 for MSI/MSI-X
[    6.160960] igb 0000:08:00.1: irq 47 for MSI/MSI-X
[    6.165874] igb 0000:08:00.1: irq 48 for MSI/MSI-X
[    6.170791] igb 0000:08:00.1: irq 49 for MSI/MSI-X
[    6.333418] igb 0000:08:00.1: irq 41 for MSI/MSI-X
[    6.338333] igb 0000:08:00.1: irq 42 for MSI/MSI-X
[    6.343246] igb 0000:08:00.1: irq 43 for MSI/MSI-X
[    6.348159] igb 0000:08:00.1: irq 44 for MSI/MSI-X
[    6.353074] igb 0000:08:00.1: irq 45 for MSI/MSI-X
[    6.357987] igb 0000:08:00.1: irq 46 for MSI/MSI-X
[    6.362902] igb 0000:08:00.1: irq 47 for MSI/MSI-X
[    6.367816] igb 0000:08:00.1: irq 48 for MSI/MSI-X
[    6.372729] igb 0000:08:00.1: irq 49 for MSI/MSI-X
[    6.560686] igb 0000:08:00.1: Intel(R) Gigabit Ethernet Network Connection
[    6.567685] igb 0000:08:00.1: eth2: (PCIe:2.5Gb/s:Width x4) 00:30:48:7c:cf:73
[    6.574937] igb 0000:08:00.1: eth2: PBA No: Unknown
[    6.579937] igb 0000:08:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    6.587700] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    6.595622] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    6.601565] usbcore: registered new interface driver catc
[    6.607089] usbcore: registered new interface driver kaweth
[    6.612776] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    6.620364] usbcore: registered new interface driver pegasus
[    6.626152] usbcore: registered new interface driver rtl8150
[    6.631942] usbcore: registered new interface driver asix
[    6.637468] usbcore: registered new interface driver cdc_ether
[    6.643428] usbcore: registered new interface driver cdc_eem
[    6.649208] usbcore: registered new interface driver dm9601
[    6.654905] usbcore: registered new interface driver smsc75xx
[    6.660784] usbcore: registered new interface driver smsc95xx
[    6.666654] usbcore: registered new interface driver gl620a
[    6.672348] usbcore: registered new interface driver net1080
[    6.678128] usbcore: registered new interface driver plusb
[    6.683736] usbcore: registered new interface driver rndis_host
[    6.689781] usbcore: registered new interface driver cdc_subset
[    6.695834] usbcore: registered new interface driver zaurus
[    6.701531] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    6.709128] usbcore: registered new interface driver int51x1
[    6.714911] usbcore: registered new interface driver ipheth
[    6.720617] usbcore: registered new interface driver sierra_net
[    6.726712] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.733358] ehci-pci: EHCI PCI platform driver
[    6.738022] IOAPIC[0]: Set routing entry (8-23 -> 0x55 -> IRQ 23 Mode:1 Active:1 Dest:255)
[    6.746495] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    6.751886] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    6.759483] ehci-pci 0000:00:1d.7: debug port 1
[    6.768022] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    6.774947] ehci-pci 0000:00:1d.7: irq 23, io mem 0xd8704000
[    6.786013] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.791941] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.798849] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.806257] usb usb1: Product: EHCI Host Controller
[    6.811251] usb usb1: Manufacturer: Linux 3.17.0-ga308edf ehci_hcd
[    6.817552] usb usb1: SerialNumber: 0000:00:1d.7
[    6.822404] hub 1-0:1.0: USB hub found
[    6.826279] hub 1-0:1.0: 6 ports detected
[    6.830556] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.836854] ohci-pci: OHCI PCI platform driver
[    6.841432] uhci_hcd: USB Universal Host Controller Interface driver
[    6.848000] IOAPIC[0]: Set routing entry (8-20 -> 0x65 -> IRQ 20 Mode:1 Active:1 Dest:255)
[    6.856465] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.861853] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    6.869435] uhci_hcd 0000:00:1d.0: detected 2 ports
[    6.874458] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001800
[    6.880340] Switched to clocksource tsc
[    6.880388] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    6.880389] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.880391] usb usb2: Product: UHCI Host Controller
[    6.880392] usb usb2: Manufacturer: Linux 3.17.0-ga308edf uhci_hcd
[    6.880393] usb usb2: SerialNumber: 0000:00:1d.0
[    6.880498] hub 2-0:1.0: USB hub found
[    6.880504] hub 2-0:1.0: 2 ports detected
[    6.880680] IOAPIC[0]: Set routing entry (8-21 -> 0x75 -> IRQ 21 Mode:1 Active:1 Dest:255)
[    6.880691] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.880730] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    6.880736] uhci_hcd 0000:00:1d.1: detected 2 ports
[    6.880765] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001820
[    6.880814] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.880815] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.880817] usb usb3: Product: UHCI Host Controller
[    6.880818] usb usb3: Manufacturer: Linux 3.17.0-ga308edf uhci_hcd
[    6.880819] usb usb3: SerialNumber: 0000:00:1d.1
[    6.880914] hub 3-0:1.0: USB hub found
[    6.880919] hub 3-0:1.0: 2 ports detected
[    6.881099] IOAPIC[0]: Set routing entry (8-22 -> 0x85 -> IRQ 22 Mode:1 Active:1 Dest:255)
[    6.881110] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.881146] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    6.881154] uhci_hcd 0000:00:1d.2: detected 2 ports
[    6.881182] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001840
[    6.881228] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.881230] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.881231] usb usb4: Product: UHCI Host Controller
[    6.881232] usb usb4: Manufacturer: Linux 3.17.0-ga308edf uhci_hcd
[    6.881233] usb usb4: SerialNumber: 0000:00:1d.2
[    6.881327] hub 4-0:1.0: USB hub found
[    6.881332] hub 4-0:1.0: 2 ports detected
[    6.881491] usbcore: registered new interface driver usbserial
[    6.881499] usbcore: registered new interface driver usbserial_generic
[    6.881507] usbserial: USB Serial support registered for generic
[    6.881541] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    6.882036] i8042: Warning: Keylock active
[    7.132297] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.137468] mousedev: PS/2 mouse device common for all mice
[    7.143334] rtc_cmos 00:01: RTC can wake from S4
[    7.148204] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    7.154438] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    7.162300] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    7.168005] iTCO_wdt: Found a 631xESB/632xESB TCO device (Version=2, TCOBASE=0x1060)
[    7.176020] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.182156] iTCO_vendor_support: vendor-support=0
[    7.187410] hidraw: raw HID events driver (C) Jiri Kosina
[    7.193073] usbcore: registered new interface driver usbhid
[    7.198762] usbhid: USB HID core driver
[    7.202751] drop_monitor: Initializing network drop monitor service
[    7.209223] TCP: cubic registered
[    7.212658] Initializing XFRM netlink socket
[    7.217221] NET: Registered protocol family 10
[    7.222137] NET: Registered protocol family 17
[    7.226706] 9pnet: Installing 9P2000 support
[    7.231468] 
[    7.231468] printing PIC contents
[    7.236446] ... PIC  IMR: ffff
[    7.237441] ... PIC  IRR: 0ca0
[    7.242793] ... PIC  ISR: 0000
[    7.245961] ... PIC ELCR: 0ea0
[    7.249134] printing local APIC contents on CPU#0/0:
[    7.250131] ... APIC ID:      00000000 (0)
[    7.250131] ... APIC VERSION: 00050014
[    7.250131] ... APIC TASKPRI: 00000000 (00)
[    7.250131] ... APIC PROCPRI: 00000000
[    7.250131] ... APIC LDR: 01000000
[    7.250131] ... APIC DFR: ffffffff
[    7.250131] ... APIC SPIV: 000001ff
[    7.250131] ... APIC ISR field:
[    7.250131] 0000000000000000000000000000000000000000000000000000000000000000
[    7.250131] ... APIC TMR field:
[    7.250131] 0000000000000000000000000000000000000002000200020000000200000000
[    7.250131] ... APIC IRR field:
[    7.250131] 0000000000000000000000000000000000000000000000000000000000000000
[    7.250131] ... APIC ESR: 00000000
[    7.250131] ... APIC ICR: 000008fd
[    7.250131] ... APIC ICR2: 04000000
[    7.250131] ... APIC LVTT: 000000ef
[    7.250131] ... APIC LVTPC: 00000400
[    7.250131] ... APIC LVT0: 00010700
[    7.250131] ... APIC LVT1: 00000400
[    7.250131] ... APIC LVTERR: 000000fe
[    7.250131] ... APIC TMICT: 0132c189
[    7.250131] ... APIC TMCCT: 010b3004
[    7.250131] ... APIC TDCR: 00000003
[    7.250131] 
[    7.355270] number of MP IRQ sources: 15.
[    7.359398] number of IO-APIC #8 registers: 24.
[    7.364041] number of IO-APIC #9 registers: 24.
[    7.368686] number of IO-APIC #10 registers: 24.
[    7.373419] testing the IO APIC.......................
[    7.378676] IO APIC #8......
[    7.381670] .... register #00: 08000000
[    7.385621] .......    : physical APIC id: 08
[    7.390093] .......    : Delivery Type: 0
[    7.394220] .......    : LTS          : 0
[    7.398344] .... register #01: 00170020
[    7.402297] .......     : max redirection entries: 17
[    7.407462] .......     : PRQ implemented: 0
[    7.411847] .......     : IO APIC version: 20
[    7.416319] .... IRQ redirection table:
[    7.420276] 1    0    0   0   0    0    0    00
[    7.424919] 0    0    0   0   0    1    1    31
[    7.429565] 0    0    0   0   0    1    1    30
[    7.434210] 0    0    0   0   0    1    1    33
[    7.438856] 0    0    0   0   0    1    1    34
[    7.443501] 0    0    0   0   0    1    1    35
[    7.448147] 0    0    0   0   0    1    1    36
[    7.452790] 0    0    0   0   0    1    1    37
[    7.457436] 0    0    0   0   0    1    1    38
[    7.462082] 0    1    0   0   0    1    1    39
[    7.466727] 0    0    0   0   0    1    1    3A
[    7.471373] 0    0    0   0   0    1    1    3B
[    7.476018] 1    0    0   0   0    1    1    3C
[    7.480664] 0    0    0   0   0    1    1    3D
[    7.485309] 0    0    0   0   0    1    1    3E
[    7.489955] 0    0    0   0   0    1    1    3F
[    7.494598] 1    1    0   1   0    1    1    D1
[    7.499244] 1    0    0   0   0    0    0    00
[    7.503890] 1    0    0   0   0    0    0    00
[    7.508536] 1    0    0   0   0    0    0    00
[    7.513182] 0    1    0   1   0    1    1    65
[    7.517825] 0    1    0   1   0    1    1    75
[    7.522471] 0    1    0   1   0    1    1    85
[    7.527116] 0    1    0   1   0    1    1    55
[    7.531761] IO APIC #9......
[    7.534757] .... register #00: 09000000
[    7.538711] .......    : physical APIC id: 09
[    7.543183] .......    : Delivery Type: 0
[    7.547307] .......    : LTS          : 0
[    7.551433] .... register #01: 00178020
[    7.555384] .......     : max redirection entries: 17
[    7.560550] .......     : PRQ implemented: 1
[    7.564934] .......     : IO APIC version: 20
[    7.569406] .... register #02: 09000000
[    7.573358] .......     : arbitration: 09
[    7.577485] .... register #03: 00000001
[    7.581435] .......     : Boot DT    : 1
[    7.585476] .... IRQ redirection table:
[    7.589428] 1    1    0   1   0    1    1    22
[    7.594073] 1    0    0   0   0    0    0    00
[    7.598719] 1    0    0   0   0    0    0    00
[    7.603364] 1    0    0   0   0    0    0    00
[    7.608011] 1    0    0   0   0    0    0    00
[    7.612655] 1    0    0   0   0    0    0    00
[    7.617300] 1    0    0   0   0    0    0    00
[    7.621946] 1    0    0   0   0    0    0    00
[    7.626591] 1    0    0   0   0    0    0    00
[    7.631238] 1    0    0   0   0    0    0    00
[    7.635882] 1    0    0   0   0    0    0    00
[    7.640527] 1    0    0   0   0    0    0    00
[    7.645173] 1    0    0   0   0    0    0    00
[    7.649818] 1    0    0   0   0    0    0    00
[    7.654463] 1    0    0   0   0    0    0    00
[    7.659110] 1    0    0   0   0    0    0    00
[    7.663754] 1    0    0   0   0    0    0    00
[    7.668400] 1    0    0   0   0    0    0    00
[    7.673045] 1    0    0   0   0    0    0    00
[    7.677691] 1    0    0   0   0    0    0    00
[    7.682336] 1    0    0   0   0    0    0    00
[    7.686980] 1    0    0   0   0    0    0    00
[    7.691626] 1    0    0   0   0    0    0    00
[    7.696273] 1    0    0   0   0    0    0    00
[    7.700919] IO APIC #10......
[    7.704004] .... register #00: 0A000000
[    7.707954] .......    : physical APIC id: 0A
[    7.712427] .......    : Delivery Type: 0
[    7.716553] .......    : LTS          : 0
[    7.720677] .... register #01: 00170020
[    7.724629] .......     : max redirection entries: 17
[    7.729794] .......     : PRQ implemented: 0
[    7.734180] .......     : IO APIC version: 20
[    7.738651] .... register #02: 00000000
[    7.742603] .......     : arbitration: 00
[    7.746729] .... register #03: 00000001
[    7.750681] .......     : Boot DT    : 1
[    7.754720] .... IRQ redirection table:
[    7.758673] 1    1    0   1   0    1    1    81
[    7.763319] 1    0    0   0   0    0    0    00
[    7.767963] 1    1    0   1   0    1    1    91
[    7.772608] 1    0    0   0   0    0    0    00
[    7.777254] 1    1    0   1   0    1    1    A1
[    7.781901] 1    0    0   0   0    0    0    00
[    7.788131] 1    1    0   1   0    1    1    B1
[    7.792776] 1    0    0   0   0    0    0    00
[    7.797423] 1    1    0   1   0    1    1    C1
[    7.802075] 1    0    0   0   0    0    0    00
[    7.806721] 1    0    0   0   0    0    0    00
[    7.811367] 1    0    0   0   0    0    0    00
[    7.816012] 1    0    0   0   0    0    0    00
[    7.820658] 1    0    0   0   0    0    0    00
[    7.825301] 1    0    0   0   0    0    0    00
[    7.829947] 1    0    0   0   0    0    0    00
[    7.834592] 1    0    0   0   0    0    0    00
[    7.839238] 1    0    0   0   0    0    0    00
[    7.843884] 1    0    0   0   0    0    0    00
[    7.848529] 1    0    0   0   0    0    0    00
[    7.853174] 1    0    0   0   0    0    0    00
[    7.857820] 1    0    0   0   0    0    0    00
[    7.862465] 1    1    0   1   0    1    1    A3
[    7.867111] 1    0    0   0   0    0    0    00
[    7.871753] IRQ to pin mappings:
[    7.875100] IRQ0 -> 0:2
[    7.877792] IRQ1 -> 0:1
[    7.880488] IRQ3 -> 0:3
[    7.883186] IRQ4 -> 0:4
[    7.885879] IRQ5 -> 0:5
[    7.888573] IRQ6 -> 0:6
[    7.891272] IRQ7 -> 0:7
[    7.893962] IRQ8 -> 0:8
[    7.896658] IRQ9 -> 0:9
[    7.899355] IRQ10 -> 0:10
[    7.902227] IRQ11 -> 0:11
[    7.905095] IRQ12 -> 0:12
[    7.907961] IRQ13 -> 0:13
[    7.910830] IRQ14 -> 0:14
[    7.913699] IRQ15 -> 0:15
[    7.916566] IRQ16 -> 0:16
[    7.919436] IRQ20 -> 0:20
[    7.922304] IRQ21 -> 0:21
[    7.925176] IRQ22 -> 0:22
[    7.928045] IRQ23 -> 0:23
[    7.930909] IRQ24 -> 2:0
[    7.933690] IRQ25 -> 2:2
[    7.936474] IRQ26 -> 2:4
[    7.939259] IRQ27 -> 2:6
[    7.942040] IRQ28 -> 2:8
[    7.944819] IRQ30 -> 1:0
[    7.947602] IRQ40 -> 2:22
[    7.950471] .................................... done.
[    7.955849] Loading compiled-in X.509 certificates
[    7.961850] Loaded X.509 cert 'Magrathea: Glacier signing key: 6990ce77d486d7df29fa939ec308d249aa0cb557'
[    7.971539] registered taskstats version 1
[    7.977570] Key type trusted registered
[    7.982788] Key type encrypted registered
[    7.988163] ima: No TPM chip found, activating TPM-bypass!
[    7.993801] evm: HMAC attrs: 0x1
[    7.997565] rtc_cmos 00:01: setting system clock to 2014-10-09 00:42:15 UTC (1412815335)
[    8.211876] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   10.349476] igb 0000:08:00.0 eth1: igb: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   10.360025] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   10.371006] Sending DHCP requests .., OK
[   12.582025] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.90
[   12.590035] IP-Config: Complete:
[   12.593385]      device=eth1, hwaddr=00:30:48:7c:cf:72, ipaddr=192.168.1.90, mask=255.255.255.0, gw=192.168.1.1
[   12.603652]      host=lkp-st02, domain=lkp.intel.com, nis-domain=(none)
[   12.610377]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   12.617128]      nameserver0=192.168.1.1
[   12.621536] PM: Hibernation image not present or could not be loaded.
[   12.629552] Freeing unused kernel memory: 1808K (ffffffff81dd1000 - ffffffff81f95000)
[   12.752760] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   12.760299] Fusion MPT base driver 3.04.20
[   12.764545] Copyright (c) 1999-2008 LSI Corporation
[   12.772383] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   12.779905] IOAPIC[0]: Set routing entry (8-18 -> 0x95 -> IRQ 18 Mode:1 Active:1 Dest:255)
[   12.779978] EDAC MC: Ver: 3.0.0
[   12.792329] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   12.792410] Fusion MPT SAS Host driver 3.04.20
[   12.794055] libata version 3.00 loaded.
[   12.808674] EDAC MC0: Giving out device to module i5400_edac.c controller I5400: DEV 0000:00:10.0 (POLLED)
[   12.809306] mptbase: ioc0: Initiating bringup
[   12.822957] EDAC PCI0: Giving out device to module i5400_edac controller EDAC PCI controller: DEV 0000:00:10.0 (POLLED)
[   12.834915] Floppy drive(s): fd0 is 1.44M
[   12.839304] ata_piix 0000:00:1f.2: version 2.13
[   12.844176] IOAPIC[0]: Set routing entry (8-17 -> 0xa5 -> IRQ 17 Mode:1 Active:1 Dest:255)
[   12.853014] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   12.853704] FDC 0 is a post-1991 82077
[   12.862624] scsi host0: ata_piix
[   12.866180] scsi host1: ata_piix
[   12.869627] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1880 irq 14
[   12.869659] Error: Driver 'pcspkr' is already registered, aborting...
[   12.883284] ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x1888 irq 15
[   13.054332] ata1.00: ATA-7: Hitachi HDS721616PLA380, P22OAB3A, max UDMA/133
[   13.061427] ata1.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   13.074317] ata1.00: configured for UDMA/133
[   13.078863] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72161 AB3A PQ: 0 ANSI: 5
[   13.093015] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[   13.112908] sd 0:0:0:0: [sda] 321672960 512-byte logical blocks: (164 GB/153 GiB)
[   13.120620] sd 0:0:0:0: [sda] Write Protect is off
[   13.125529] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   13.130717] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.175031]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   13.180436] sd 0:0:0:0: [sda] Attached SCSI disk
[   13.188465] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   13.662021] random: nonblocking pool is initialized
[   27.192986] scsi host2: ioc0: LSISAS1068E B3, FwRev=011a0000h, Ports=1, MaxQ=478, IRQ=24
[   27.236779] mptsas: ioc0: add expander: num_phys 25, sas_addr (0x50000d102db8057f)
[   27.344725] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 19, phy 4, sas_addr 0x5000c50005811519
[   27.355630] scsi 2:0:0:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.367918] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   27.376730] sd 2:0:0:0: [sdb] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.377460] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 20, phy 5, sas_addr 0x5000c500064a81a1
[   27.378516] scsi 2:0:1:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.386357] sd 2:0:1:0: Attached scsi generic sg2 type 0
[   27.388447] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 21, phy 6, sas_addr 0x5000c500064a80a9
[   27.394751] sd 2:0:1:0: [sdc] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.394855] scsi 2:0:2:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.397190] sd 2:0:1:0: [sdc] Write Protect is off
[   27.397192] sd 2:0:1:0: [sdc] Mode Sense: b3 00 10 08
[   27.403509] sd 2:0:1:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.403964] sd 2:0:2:0: Attached scsi generic sg3 type 0
[   27.410459] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 22, phy 7, sas_addr 0x5000c500064a8145
[   27.412910] sd 2:0:2:0: [sdd] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.413432] scsi 2:0:3:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.419427] sd 2:0:2:0: [sdd] Write Protect is off
[   27.419429] sd 2:0:2:0: [sdd] Mode Sense: b3 00 10 08
[   27.425869] sd 2:0:2:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.426163] sd 2:0:3:0: Attached scsi generic sg4 type 0
[   27.430136] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 23, phy 8, sas_addr 0x5000c500064a3b79
[   27.434175] sd 2:0:3:0: [sde] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.434691] scsi 2:0:4:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.437501]  sdc: sdc1
[   27.439108] sd 2:0:3:0: [sde] Write Protect is off
[   27.439110] sd 2:0:3:0: [sde] Mode Sense: b3 00 10 08
[   27.444295] sd 2:0:3:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.447437] sd 2:0:4:0: Attached scsi generic sg5 type 0
[   27.454243] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 25, phy 9, sas_addr 0x5000c500058131f9
[   27.456694] sd 2:0:4:0: [sdf] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.457024]  sdd: sdd1
[   27.458494] scsi 2:0:5:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.461589] sd 2:0:1:0: [sdc] Attached SCSI disk
[   27.470110] sd 2:0:5:0: Attached scsi generic sg6 type 0
[   27.472221] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 26, phy 10, sas_addr 0x5000c5000647bd39
[   27.476200] sd 2:0:4:0: [sdf] Write Protect is off
[   27.476202] sd 2:0:4:0: [sdf] Mode Sense: b3 00 10 08
[   27.476531] sd 2:0:5:0: [sdg] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.476719] scsi 2:0:6:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.486980] sd 2:0:6:0: Attached scsi generic sg7 type 0
[   27.489420] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 27, phy 11, sas_addr 0x5000c50005813305
[   27.489438] sd 2:0:4:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.489446] sd 2:0:5:0: [sdg] Write Protect is off
[   27.489448] sd 2:0:5:0: [sdg] Mode Sense: b3 00 10 08
[   27.493928] sd 2:0:6:0: [sdh] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.503340]  sde: sde1
[   27.508766] sd 2:0:5:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.508786] scsi 2:0:7:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.526486] sd 2:0:2:0: [sdd] Attached SCSI disk
[   27.526506] sd 2:0:6:0: [sdh] Write Protect is off
[   27.526508] sd 2:0:6:0: [sdh] Mode Sense: b3 00 10 08
[   27.528519] sd 2:0:3:0: [sde] Attached SCSI disk
[   27.537272] sd 2:0:6:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.541037] sd 2:0:7:0: Attached scsi generic sg8 type 0
[   27.548809] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 28, phy 12, sas_addr 0x5000c500064abf99
[   27.553476] sd 2:0:7:0: [sdi] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.559478]  sdf: sdf1
[   27.561538] scsi 2:0:8:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.579233] sd 2:0:7:0: [sdi] Write Protect is off
[   27.579237] sd 2:0:7:0: [sdi] Mode Sense: b3 00 10 08
[   27.581600] sd 2:0:7:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.590012]  sdg: sdg1
[   27.602970]  sdh: sdh1
[   27.611971] sd 2:0:8:0: Attached scsi generic sg9 type 0
[   27.621807] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 29, phy 13, sas_addr 0x5000c500064a7f1d
[   27.622849] scsi 2:0:9:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.629672] sd 2:0:5:0: [sdg] Attached SCSI disk
[   27.629681] sd 2:0:4:0: [sdf] Attached SCSI disk
[   27.629868] sd 2:0:9:0: Attached scsi generic sg10 type 0
[   27.629975] sd 2:0:8:0: [sdj] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.630301] sd 2:0:6:0: [sdh] Attached SCSI disk
[   27.638713] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 30, phy 14, sas_addr 0x5000c5000647ecd9
[   27.639765] scsi 2:0:10:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.643726] sd 2:0:9:0: [sdk] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.644177] sd 2:0:10:0: Attached scsi generic sg11 type 0
[   27.644410] sd 2:0:8:0: [sdj] Write Protect is off
[   27.644412] sd 2:0:8:0: [sdj] Mode Sense: b3 00 10 08
[   27.662076] sd 2:0:9:0: [sdk] Write Protect is off
[   27.662078] sd 2:0:9:0: [sdk] Mode Sense: b3 00 10 08
[   27.663439] sd 2:0:10:0: [sdl] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.663444] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 31, phy 15, sas_addr 0x5000c500064a7935
[   27.663446] sd 2:0:8:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.666276] sd 2:0:9:0: [sdk] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.672168]  sdi: sdi1
[   27.680061] scsi 2:0:11:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
[   27.683176] sd 2:0:10:0: [sdl] Write Protect is off
[   27.683177] sd 2:0:10:0: [sdl] Mode Sense: b3 00 10 08
[   27.692964] sd 2:0:11:0: Attached scsi generic sg12 type 0
[   27.695067] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 32, phy 24, sas_addr 0x50000d102db8057e
[   27.699493] sd 2:0:7:0: [sdi] Attached SCSI disk
[   27.699834] sd 2:0:11:0: [sdm] 143374744 512-byte logical blocks: (73.4 GB/68.3 GiB)
[   27.700365] sd 2:0:10:0: [sdl] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.709199] scsi 2:0:12:0: Enclosure         ADAPTEC  SANbloc S50      T016 PQ: 0 ANSI: 5
[   27.710182] sd 2:0:11:0: [sdm] Write Protect is off
[   27.710184] sd 2:0:11:0: [sdm] Mode Sense: b3 00 10 08
[   27.725331] scsi 2:0:12:0: Attached scsi generic sg13 type 13
[   27.727846] sd 2:0:11:0: [sdm] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   27.733946]  sdj: sdj1
[   27.753568] sd 2:0:8:0: [sdj] Attached SCSI disk
[   27.753582]  sdk: sdk1
[   27.761863]  sdl: sdl1
[   27.781983] sd 2:0:10:0: [sdl] Attached SCSI disk
[   27.782813] sd 2:0:9:0: [sdk] Attached SCSI disk
[   27.786167]  sdm: sdm1
[   27.805514] sd 2:0:11:0: [sdm] Attached SCSI disk
[   28.046235] sd 2:0:0:0: [sdb] Write Protect is off
[   28.051151] sd 2:0:0:0: [sdb] Mode Sense: b3 00 10 08
[   28.057946] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   28.082689]  sdb: sdb1
[   28.092976] sd 2:0:0:0: [sdb] Attached SCSI disk
[   37.373216] ses 2:0:12:0: Attached Enclosure device

==> /lkp/lkp/src/tmp/stdout <==

==> /lkp/lkp/src/tmp/stderr <==

==> /lkp/lkp/src/tmp/stdout <==
 9 Oct 00:42:51 ntpdate[1668]: step time server 192.168.1.1 offset -0.217132 sec
Kernel tests: Boot OK!
LKP: HOSTNAME lkp-st02, MAC 00:30:48:7c:cf:72, kernel 3.17.0-ga308edf 1, serial console /dev/ttyS0
/lkp/lkp/src/bin/run-lkp
RESULT_ROOT=/result/lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-10dd/debian-x86_64.cgz/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/0
job=/lkp/scheduled/lkp-st02/cyclic_dd-write-5m-11HDD-RAID5-cfq-btrfs-10dd-x86_64-rhel-HEAD-a308edf16c35a3667e85e8545a530812915a71bf-0.yaml
run-job /lkp/scheduled/lkp-st02/cyclic_dd-write-5m-11HDD-RAID5-cfq-btrfs-10dd-x86_64-rhel-HEAD-a308edf16c35a3667e85e8545a530812915a71bf-0.yaml
run: /lkp/lkp/src/setup/cpufreq_governor	{}
run: /lkp/lkp/src/setup/runtime 5m	{}
run: /lkp/lkp/src/setup/disk	{"nr_hdd"=>"11"}
run: /lkp/lkp/src/setup/md	{"raid_level"=>"raid5"}
run: /lkp/lkp/src/monitors/event/wait pre-test	{}
run: /lkp/lkp/src/monitors/wrapper watch-oom	{}
run: /lkp/lkp/src/monitors/wrapper perf-stat	{}
run: /lkp/lkp/src/monitors/wrapper watchdog	{}
run: /lkp/lkp/src/monitors/no-stdout/wrapper perf-profile	{}
[   44.982081] ipmi message handler version 39.2
[   44.988387] IPMI Watchdog: driver initialized
run: /lkp/lkp/src/monitors/wrapper ftrace	{"events"=>"balance_dirty_pages bdi_dirty_ratelimit global_dirty_state writeback_single_inode"}
2014-
[   45.015473] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
10-09 00:42:52 m
[   45.027358] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
dadm -q --create
[   45.040206] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
 /dev/md0 --chun
[   45.052090] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
k=256 --level=raid5 --raid-devic
[   45.064968] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
es=11 --force --
[   45.078290] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
assume-clean /de
[   45.091175] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
v/sdb1 /dev/sdj1
[   45.103126] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
 /dev/sdi1 /dev/
[   45.115984] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
sdf1 /dev/sdk1 /
[   45.127962] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
dev/sdl1 /dev/sd
[   45.141086] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
g1 /dev/sdm1 /de
[   45.152810] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
v/sdh1 /dev/sde1
[   45.165680] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
 /dev/sdc1
[   45.177623] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.190139] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.201391] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.213103] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.224358] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.236110] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.247396] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.259482] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.270756] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.282498] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.293750] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.305489] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.316777] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.328527] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.339808] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.351590] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.362860] bmc-watchdog:2045 map pfn expected mapping type uncached-minus for [mem 0xcff05000-0xcff05fff], got write-back
[   45.396057] md: bind<sdb1>
[   45.399127] md: bind<sdj1>
[   45.402180] md: bind<sdi1>
[   45.405212] md: bind<sdf1>
[   45.408299] md: bind<sdk1>
[   45.411336] md: bind<sdl1>
[   45.414363] md: bind<sdg1>
[   45.417391] md: bind<sdm1>
[   45.420427] md: bind<sdh1>
[   45.423472] md: bind<sde1>
[   45.426517] md: bind<sdc1>
[   45.449005] raid6: sse2x1    3925 MB/s
[   45.469005] raid6: sse2x2    7238 MB/s
[   45.489003] raid6: sse2x4    8175 MB/s
[   45.492877] raid6: using algorithm sse2x4 (8175 MB/s)
[   45.498056] raid6: using ssse3x2 recovery algorithm
[   45.504368] async_tx: api initialized (async)
[   45.510212] xor: measuring software checksum speed
[   45.525004]    prefetch64-sse: 10884.000 MB/sec
[   45.539003]    generic_sse:  9632.000 MB/sec
[   45.543395] xor: using function: prefetch64-sse (10884.000 MB/sec)
[   45.557750] md: raid6 personality registered for level 6
[   45.563207] md: raid5 personality registered for level 5
[   45.568655] md: raid4 personality registered for level 4
[   45.574374] md/raid:md0: device sdc1 operational as raid disk 10
[   45.580511] md/raid:md0: device sde1 operational as raid disk 9
[   45.586568] md/raid:md0: device sdh1 operational as raid disk 8
[   45.592613] md/raid:md0: device sdm1 operational as raid disk 7
[   45.598656] md/raid:md0: device sdg1 operational as raid disk 6
[   45.604693] md/raid:md0: device sdl1 operational as raid disk 5
[   45.610737] md/raid:md0: device sdk1 operational as raid disk 4
[   45.616778] md/raid:md0: device sdf1 operational as raid disk 3
[   45.622820] md/raid:md0: device sdi1 operational as raid disk 2
[   45.628868] md/raid:md0: device sdj1 operational as raid disk 1
[   45.634909] md/raid:md0: device sdb1 operational as raid disk 0
[   45.641986] md/raid:md0: allocated 0kB
[   45.645913] md/raid:md0: raid level 5 active with 11 out of 11 devices, algorithm 2
[   45.653763] RAID conf printout:
[   45.657024]  --- level:5 rd:11 wd:11
[   45.660725]  disk 0, o:1, dev:sdb1
[   45.664254]  disk 1, o:1, dev:sdj1
[   45.667781]  disk 2, o:1, dev:sdi1
[   45.671309]  disk 3, o:1, dev:sdf1
[   45.674835]  disk 4, o:1, dev:sdk1
[   45.678370]  disk 5, o:1, dev:sdl1
[   45.681900]  disk 6, o:1, dev:sdg1
[   45.685427]  disk 7, o:1, dev:sdm1
[   45.688957]  disk 8, o:1, dev:sdh1
[   45.692482]  disk 9, o:1, dev:sde1
[   45.696011]  disk 10, o:1, dev:sdc1
[   45.699679] md0: detected capacity change from 0 to 733350461440
[   45.715687]  md0: unknown partition table
run: /lkp/lkp/src/setup/iosched	{"scheduler"=>"cfq"}
[   45.767071] Btrfs loaded
[   45.771668] BTRFS: device fsid e85bb9af-4258-4e3a-a712-ac750d018065 devid 1 transid 17 /dev/md0
run: /lkp/lkp/src/setup/fs	{"fs"=>"btrfs"}
2014-10-09 00:42:53 mkfs -t btrfs /dev/md0
Btrfs v3.16
See http://btrfs.wiki.kernel.org for more information.

Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
fs created label (null) on /dev/md0
	nodesize 16384 leafsize 16384 sec
[   46.168389] BTRFS: device fsid a68fbfb4-12c1-425f-8a53-9b654d4a669d torsize 4096 sizdevid 1 transid 4 /dev/md0
e 682.99GiB
201
[   46.180254] BTRFS info (device md0): disk space caching is enabled
4-10-09 00:42:53
[   46.187082] BTRFS: flagging fs with big metadata feature
 mount -t btrfs /dev/md0 /fs/md0
[   46.196636] BTRFS: creating UUID tree
run: /lkp/lkp/src/setup/nr_threads 10dd	{}
run: pre-test
run: /lkp/lkp/src/monitors/wrapper uptime	{}
run: /lkp/lkp/src/monitors/wrapper iostat	{}
run: /lkp/lkp/src/monitors/wrapper vmstat	{}
run: /lkp/lkp/src/monitors/wrapper numa-numastat	{}
run: /lkp/lkp/src/monitors/wrapper numa-vmstat	{}
run: /lkp/lkp/src/monitors/wrapper numa-meminfo	{}
run: /lkp/lkp/src/monitors/wrapper proc-vmstat	{}
run: /lkp/lkp/src/monitors/wrapper proc-stat	{}
run: /lkp/lkp/src/monitors/wrapper meminfo	{}
run: /lkp/lkp/src/monitors/wrapper slabinfo	{}
run: /lkp/lkp/src/monitors/wrapper interrupts	{}
run: /lkp/lkp/src/monitors/wrapper lock_stat	{}
run: /lkp/lkp/src/monitors/wrapper latency_stats	{}
run: /lkp/lkp/src/monitors/wrapper softirqs	{}
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping	{}
run: /lkp/lkp/src/monitors/wrapper diskstats	{}
run: /lkp/lkp/src/monitors/wrapper energy	{}
run: /lkp/lkp/src/monitors/wrapper cpuidle	{}
run: /lkp/lkp/src/monitors/wrapper cpufreq	{}
run: /lkp/lkp/src/monitors/wrapper turbostat	{}
run: /lkp/lkp/src/monitors/wrapper sched_debug	{"interval"=>"10"}
run: /usr/bin/time -v -o /lkp/lkp/src/tmp/time /lkp/lkp/src/tests/wrapper dd	{}
2014-10-09 00:42:54 dd  if=/dev/zero of=/fs/md0/zero-1 status=noxfer &
2014-10-09 00:42:54 dd  if=/dev/zero of=/fs/md0/zero-2 status=noxfer &
2014-10-09 00:42:54 dd  if=/dev/zero of=/fs/md0/zero-3 status=noxfer &
2014-10-09 00:42:54 dd  if=/dev/zero of=/fs/md0/zero-4 status=noxfer &
2014-10-09 00:42:54 dd  if=/dev/zero of=/fs/md0/zero-5 status=noxfer &
2014-10-09 00:42:54 dd  if=/dev/zero of=/fs/md0/zero-6 status=noxfer &
run: /lkp/lkp/src/monitors/wrapper pmeter	{}
2014-10-09 00:42:54 dd  if=/dev/zero of=/fs/md0/zero-7 status=noxfer &
2014-10-09 00:42:54 dd  if=/dev/zero of=/fs/md0/zero-8 status=noxfer &
2014-10-09 00:42:54 dd  if=/dev/zero of=/fs/md0/zero-9 status=noxfer &
2014-10-09 00:42:54 dd  if=/dev/zero of=/fs/md0/zero-10 status=noxfer &
root         2  0.0  0.0      0     0 ?        S    00:42   0:00 [kthreadd]
root       106  0.0  0.0      0     0 ?        S<   00:42   0:00 [ipv6_addrconf]
root      1712  6.6  0.1  64512 14044 ?        Sl   00:42   0:00 /usr/bin/ruby /lkp/lkp/src/bin/run-job --pid-file /lkp/lkp/src/tmp/run-job.pid /lkp/scheduled/lkp-st02/cyclic_dd-write-5m-11HDD-RAID5-cfq-btrfs-10dd-x86_64-rhel-HEAD-a308edf16c35a3667e85e8545a530812915a71bf-0.yaml
root      1908  0.0  0.0  55876  5036 ?        S    00:42   0:00 perf stat -a -x  -e cpu-cycles -e instructions -e cache-references -e cache-misses -e branch-instructions -e branch-misses -e bus-cycles -e ref-cycles -e L1-dcache-loads -e L1-dcache-load-misses -e L1-dcache-stores -e L1-dcache-store-misses -e L1-dcache-prefetches -e L1-icache-loads -e L1-icache-load-misses -e LLC-loads -e LLC-load-misses -e LLC-stores -e LLC-store-misses -e dTLB-loads -e dTLB-load-misses -e dTLB-stores -e dTLB-store-misses -e iTLB-loads -e iTLB-load-misses -e branch-loads -e branch-load-misses -e cpu-clock -e task-clock -e page-faults -e context-switches -e cpu-migrations -e minor-faults -e major-faults -e alignment-faults -e emulation-faults -e dummy -o /result/lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-10dd/debian-x86_64.cgz/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/0/perf-stat -- /lkp/lkp/src/monitors/event/wait post-test
root      2815  0.0  0.0   4208   628 ?        S    00:42   0:00 /usr/bin/time -v -o /lkp/lkp/src/tmp/time /lkp/lkp/src/tests/wrapper dd
root      2818  0.0  0.0   9448  2648 ?        S    00:42   0:00 /bin/bash /lkp/lkp/src/tests/dd
root      2826  0.0  0.0   4224  1188 ?        S    00:42   0:00 tee-dd -a /lkp/lkp/src/tmp/result/dd
root      2836  0.0  0.0   8492   788 ?        S    00:42   0:00 timeout -s KILL 300 dd if=/dev/zero of=/fs/md0/zero-1 status=noxfer
root      2838  0.0  0.0   9448  1788 ?        S    00:42   0:00 /bin/bash /lkp/lkp/src/tests/dd
root      2840  0.0  0.0   4252   688 ?        R    00:42   0:00 dd if=/dev/zero of=/fs/md0/zero-1 status=noxfer
root      2845  0.0  0.0   8492   772 ?        S    00:42   0:00 timeout -s KILL 300 dd if=/dev/zero of=/fs/md0/zero-2 status=noxfer
root      2847  0.0  0.0   9448  1788 ?        S    00:42   0:00 /bin/bash /lkp/lkp/src/tests/dd
root      2851  0.0  0.0   4252   728 ?        R    00:42   0:00 dd if=/dev/zero of=/fs/md0/zero-2 status=noxfer
root      2854  0.0  0.0   8492   820 ?        S    00:42   0:00 timeout -s KILL 300 dd if=/dev/zero of=/fs/md0/zero-3 status=noxfer
root      2856  0.0  0.0   9448  1788 ?        S    00:42   0:00 /bin/bash /lkp/lkp/src/tests/dd
root      2859  0.0  0.0   4252   724 ?        R    00:42   0:00 dd if=/dev/zero of=/fs/md0/zero-3 status=noxfer
root      2862  0.0  0.0   8492   816 ?        S    00:42   0:00 timeout -s KILL 300 dd if=/dev/zero of=/fs/md0/zero-4 status=noxfer
root      2865  0.0  0.0   9448  1788 ?        S    00:42   0:00 /bin/bash /lkp/lkp/src/tests/dd
root      2868  0.0  0.0   4252   696 ?        R    00:42   0:00 dd if=/dev/zero of=/fs/md0/zero-4 status=noxfer
root      2872  0.0  0.0   8492   768 ?        S    00:42   0:00 timeout -s KILL 300 dd if=/dev/zero of=/fs/md0/zero-5 status=noxfer
root      2874  0.0  0.0   9448  1788 ?        S    00:42   0:00 /bin/bash /lkp/lkp/src/tests/dd
root      2878  0.0  0.0   4252   704 ?        R    00:42   0:00 dd if=/dev/zero of=/fs/md0/zero-5 status=noxfer
root      2882  0.0  0.0   8492   768 ?        S    00:42   0:00 timeout -s KILL 300 dd if=/dev/zero of=/fs/md0/zero-6 status=noxfer
root      2885  0.0  0.0   9448  1788 ?        S    00:42   0:00 /bin/bash /lkp/lkp/src/tests/dd
root      2888  0.0  0.0   4252   712 ?        R    00:42   0:00 dd if=/dev/zero of=/fs/md0/zero-6 status=noxfer
root      2893  0.0  0.0   8492   844 ?        S    00:42   0:00 timeout -s KILL 300 dd if=/dev/zero of=/fs/md0/zero-7 status=noxfer
root      2898  0.0  0.0   9448  1788 ?        S    00:42   0:00 /bin/bash /lkp/lkp/src/tests/dd
root      2900  0.0  0.0   4252   736 ?        R    00:42   0:00 dd if=/dev/zero of=/fs/md0/zero-7 status=noxfer
root      2903  0.0  0.0   8492   888 ?        S    00:42   0:00 timeout -s KILL 300 dd if=/dev/zero of=/fs/md0/zero-8 status=noxfer
root      2906  0.0  0.0   9448  1788 ?        S    00:42   0:00 /bin/bash /lkp/lkp/src/tests/dd
root      2908  0.0  0.0   4252   708 ?        R    00:42   0:00 dd if=/dev/zero of=/fs/md0/zero-8 status=noxfer
root      2912  0.0  0.0   8492   772 ?        S    00:42   0:00 timeout -s KILL 300 dd if=/dev/zero of=/fs/md0/zero-9 status=noxfer
root      2914  0.0  0.0   9448  1788 ?        S    00:42   0:00 /bin/bash /lkp/lkp/src/tests/dd
root      2915  0.0  0.0   4252   688 ?        R    00:42   0:00 dd if=/dev/zero of=/fs/md0/zero-9 status=noxfer
root      2919  0.0  0.0   8492   828 ?        S    00:42   0:00 timeout -s KILL 300 dd if=/dev/zero of=/fs/md0/zero-10 status=noxfer
root      2921  0.0  0.0  11116   972 ?        S    00:42   0:00 grep dd
root      2922  0.0  0.0   9448  1788 ?        S    00:42   0:00 /bin/bash /lkp/lkp/src/tests/dd
root      2923  0.0  0.0   4252   684 ?        R    00:42   0:00 dd if=/dev/zero of=/fs/md0/zero-10 status=noxfer
startup_time: 0
2014-10-09 00:42:54 sleep 300
[  145.130433] perf interrupt took too long (2540 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[  146.027433] perf interrupt took too long (5103 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
2014-10-09 00:47:54 killall -9 dd
kill_time: 0
rm_time: 10
geting new job...

==> /lkp/lkp/src/tmp/stderr <==
2014-10-09 00:48:13 URL:http://inn/~lkp/cgi-bin/gpxelinux.cgi?hostname=lkp-st02&lkp_wtmp [1128] -> "/tmp/next-job-lkp" [1]

==> /lkp/lkp/src/tmp/stdout <==
downloading kernel image ...

==> /lkp/lkp/src/tmp/stderr <==
2014-10-09 00:48:13 URL:http://inn/~lkp//kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/vmlinuz-3.17.0-ga308edf [6580528/6580528] -> "/tmp//kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/vmlinuz-3.17.0-ga308edf" [1]

==> /lkp/lkp/src/tmp/stdout <==
downloading initrds ...

==> /lkp/lkp/src/tmp/stderr <==
2014-10-09 00:48:14 URL:http://inn/~lkp//kernel-tests/initrd/debian-x86_64.cgz [102650917/102650917] -> "/tmp//kernel-tests/initrd/debian-x86_64.cgz" [1]
2014-10-09 00:48:14 URL:http://inn/~lkp//lkp/lkp/lkp-x86_64.cgz [624734/624734] -> "/tmp//lkp/lkp/lkp-x86_64.cgz" [1]
2014-10-09 00:48:14 URL:http://inn/~lkp//kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/modules.cgz [23783517/23783517] -> "/tmp//kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/modules.cgz" [1]

==> /lkp/lkp/src/tmp/stdout <==
kexecing...
kexec -l /tmp//kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/vmlinuz-3.17.0-ga308edf --initrd=/tmp/initrd-6217 --append="user=lkp job=/lkp/scheduled/lkp-st02/cyclic_dd-write-5m-11HDD-RAID5-cfq-btrfs-100dd-x86_64-rhel-HEAD-a308edf16c35a3667e85e8545a530812915a71bf-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/vmlinuz-3.17.0-ga308edf kconfig=x86_64-rhel commit=a308edf16c35a3667e85e8545a530812915a71bf branch=linux-devel/devel-hourly-2014100822 root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd/debian-x86_64.cgz/x86_64-rhel/a308edf16c35a3667e85e8545a530812915a71bf/0 ip=::::lkp-st02:eth1:dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw"
[  373.673403] ------------[ cut here ]------------
[  373.674366] kernel BUG at fs/btrfs/inode.c:3123!
[  373.674366] invalid opcode: 0000 [#1] SMP 
[  373.674366] Modules linked in: btrfs raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq ipmi_watchdog ipmi_msghandler ses enclosure sg sd_mod crc_t10dif crct10dif_generic crct10dif_common ata_generic pata_acpi snd_pcm snd_timer ata_piix parport_pc floppy snd i5400_edac parport soundcore libata i2c_i801 serio_raw mptsas pcspkr edac_core mptscsih tpm_infineon mptbase i5k_amb shpchp scsi_transport_sas
[  373.674366] CPU: 7 PID: 2172 Comm: btrfs-cleaner Not tainted 3.17.0-ga308edf #1
[  373.674366] Hardware name: Supermicro X7DW3/X7DWN, BIOS 6.00 09/28/2007
[  373.674366] task: ffff8800bd720000 ti: ffff8800bd728000 task.ti: ffff8800bd728000
[  373.674366] RIP: 0010:[<ffffffffa02257c0>]  [<ffffffffa02257c0>] btrfs_orphan_add+0x1c0/0x1e0 [btrfs]
[  373.674366] RSP: 0018:ffff8800bd72bca0  EFLAGS: 00010286
[  373.674366] RAX: 00000000ffffffe4 RBX: ffff88022da60800 RCX: ffff88022b8fe000
[  373.674366] RDX: 00000000000007d0 RSI: 0000000000040000 RDI: ffff88022b8fe138
[  373.674366] RBP: ffff8800bd72bcd0 R08: 000060fdd0002340 R09: ffff8801219343f0
[  373.674366] R10: ffffe8ffffdc2380 R11: ffffea0003004300 R12: ffff88010071ac98
[  373.674366] R13: ffff8800a7f90aa0 R14: ffff88022da60c58 R15: 0000000000000001
[  373.674366] FS:  0000000000000000(0000) GS:ffff88022fdc0000(0000) knlGS:0000000000000000
[  373.674366] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  373.674366] CR2: 00007f6bad137148 CR3: 000000022ec3c000 CR4: 00000000000007e0
[  373.674366] Stack:
[  373.674366]  ffffffffa0263691 ffff88021ad60000 ffff8801219343f0 0000000000000001
[  373.674366]  ffff88010071ac98 ffff880094ca1600 ffff8800bd72bd48 ffffffffa020f796
[  373.674366]  ffff8801219343f0 ffff880121934470 ffff880000000004 ffff88022da60800
[  373.674366] Call Trace:
[  373.674366]  [<ffffffffa0263691>] ? lookup_free_space_inode+0x41/0xf0 [btrfs]
[  373.674366]  [<ffffffffa020f796>] btrfs_remove_block_group+0x136/0x510 [btrfs]
[  373.674366]  [<ffffffffa0248e9a>] btrfs_remove_chunk+0x66a/0x7f0 [btrfs]
[  373.674366]  [<ffffffffa020fd8e>] btrfs_delete_unused_bgs+0x21e/0x250 [btrfs]
[  373.674366]  [<ffffffffa0218344>] cleaner_kthread+0x164/0x1e0 [btrfs]
[  373.674366]  [<ffffffffa02181e0>] ? write_all_supers+0xb70/0xb70 [btrfs]
[  373.674366]  [<ffffffff8108d19b>] kthread+0xdb/0x100
[  373.674366]  [<ffffffff8108d0c0>] ? kthread_create_on_node+0x180/0x180
[  373.674366]  [<ffffffff818600fc>] ret_from_fork+0x7c/0xb0
[  373.674366]  [<ffffffff8108d0c0>] ? kthread_create_on_node+0x180/0x180
[  373.674366] Code: 60 04 00 00 e9 b0 fe ff ff 66 90 89 45 d0 f0 41 80 64 24 80 fd 4c 89 e7 e8 3e 2a fe ff 8b 45 d0 e9 1b ff ff ff 66 0f 1f 44 00 00 <0f> 0b b8 f4 ff ff ff e9 10 ff ff ff 4c 89 f7 45 31 f6 e8 99 a2 
[  373.674366] RIP  [<ffffffffa02257c0>] btrfs_orphan_add+0x1c0/0x1e0 [btrfs]
[  373.674366]  RSP <ffff8800bd72bca0>
[  373.952497] ---[ end trace c0d0f39b387c06ce ]---
[  373.957232] Kernel panic - not syncing: Fatal exception
[  373.958229] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

--CE+1k2dSO48ffgeK--
