Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab3IHQxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 12:53:36 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:52186 "EHLO
	mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3IHQxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 12:53:33 -0400
Message-ID: <522CAB88.4020907@mni.thm.de>
Date: Sun, 08 Sep 2013 18:53:28 +0200
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:26.0) Gecko/20100101 Thunderbird/26.0a1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: nouveau@lists.freedesktop.org
Subject: 3.12rc1-pre Nouveau? oops
Content-Type: multipart/mixed;
 boundary="------------000004000804080705080105"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000004000804080705080105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi there,
with the latest snapshot of linus tree, i see a stack trace and my 
system does not start X! Maybe someone finds this useful! (3.11 is 
working like a charm)

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<          (null)>]           (null)
PGD 24eaa0067 PUD 24e7ac067 PMD 0
Oops: 0010 [#1] PREEMPT SMP
Modules linked in: bnep snd_hda_codec_hdmi snd_hda_codec_realtek fuse 
x86_pkg_temp_thermal coretemp snd_hda_intel kvm_intel snd_hda_codec 
snd_hwdep kvm snd_pcm uvcvideo snd_seq videobuf2_core snd_timer 
crct10dif_pclmul crc32_pclmul arc4 crc32c_intel snd_seq_device 
ghash_clmulni_intel ath9k videodev snd sdhci_pci sdhci aesni_intel 
iTCO_wdt iTCO_vendor_support mac80211 ablk_helper acer_wmi ath9k_common 
ath3k ath9k_hw sr_mod lpc_ich cryptd mmc_core joydev btusb sg ath 
cfg80211 tg3 acpi_cpufreq ptp pps_core ipheth cdrom videobuf2_vmalloc 
mfd_core sparse_keymap soundcore serio_raw bluetooth videobuf2_memops 
shpchp rfkill i2c_i801 pcspkr snd_page_alloc lrw gf128mul glue_helper 
aes_x86_64 microcode battery ac autofs4 nouveau i915 ttm drm_kms_helper 
drm xhci_hcd mxm_wmi i2c_algo_bit wmi video button processor thermal_sys 
scsi_dh_emc scsi_dh_alua scsi_dh_rdac scsi_dh_hp_sw scsi_dh
CPU: 0 PID: 792 Comm: Xorg Not tainted 3.11.0-desktop+ #1
Hardware name: Acer Aspire V3-571G/VA50_HC_CR, BIOS V1.13 10/09/2012
task: ffff880253031040 ti: ffff880253256000 task.ti: ffff880253256000
RIP: 0010:[<0000000000000000>]  [< (null)>]           (null)
RSP: 0018:ffff8802532579a0  EFLAGS: 00010246
RAX: ffff88024fabb000 RBX: ffff88024f3e2800 RCX: ffff88024eacf5c0
RDX: ffff88024fabb000 RSI: ffff88024f7fe760 RDI: ffff88024f3e2800
RBP: ffff88024ea2f480 R08: 0000000000000004 R09: 0000000000000000
R10: ffff88025f1e1f80 R11: 000000000000000f R12: ffff88024f3e2800
R13: ffff88024f3e2800 R14: 0000000000000004 R15: ffff880253257ab8
FS:  00007fe73cdd8880(0000) GS:ffff88025f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000025022c000 CR4: 00000000001407f0
Stack:
  ffffffffa021e4a2 ffff88024f234000 ffff88024f3e2800 ffff88024f3e2c38
  0000000000000000 ffff88024f3e2800 ffffffffa021eda5 ffff88025401d000
  ffff88024fabb000 ffff88025401d000 ffffffffa020e7cb ffff880253257ab8
Call Trace:
  [<ffffffffa021e4a2>] ? nouveau_display_init+0x42/0xd0 [nouveau]
  [<ffffffffa021eda5>] ? nouveau_display_resume+0x15/0xa0 [nouveau]
  [<ffffffffa020e7cb>] ? nouveau_pmops_runtime_resume+0x9b/0x100 [nouveau]
  [<ffffffff812ac745>] ? pci_pm_runtime_resume+0x85/0xc0
  [<ffffffff812ac6c0>] ? pci_restore_standard_config+0x30/0x30
  [<ffffffff8137b6f6>] ? __rpm_callback+0x36/0x80
  [<ffffffff8137b768>] ? rpm_callback+0x28/0x90
  [<ffffffff8137c48d>] ? rpm_resume+0x39d/0x570
  [<ffffffff81071483>] ? __wake_up+0x43/0x70
  [<ffffffff8137c8f8>] ? __pm_runtime_resume+0x48/0x70
  [<ffffffffa020e5a2>] ? nouveau_drm_open+0x42/0x1d0 [nouveau]
  [<ffffffff811bb858>] ? ext4_da_write_end+0xa8/0x2b0
  [<ffffffff811ef559>] ? jbd2_journal_stop+0x1d9/0x2c0
  [<ffffffff8124a56f>] ? apparmor_capable+0x1f/0x90
  [<ffffffffa00c5cab>] ? drm_open+0x28b/0x6e0 [drm]
  [<ffffffffa00c6206>] ? drm_stub_open+0x106/0x1a0 [drm]
  [<ffffffff81143bc0>] ? cdev_put+0x30/0x30
  [<ffffffff81143c56>] ? chrdev_open+0x96/0x1d0
  [<ffffffff81143bc0>] ? cdev_put+0x30/0x30
  [<ffffffff8113d186>] ? do_dentry_open+0x216/0x2a0
  [<ffffffff8113d238>] ? finish_open+0x28/0x40
  [<ffffffff8114e5e9>] ? do_last+0x709/0xe70
  [<ffffffff8114a9e8>] ? link_path_walk+0x68/0x860
  [<ffffffff81124b24>] ? kmem_cache_alloc+0x1b4/0x1d0
  [<ffffffff8114ee21>] ? path_openat+0xd1/0x660
  [<ffffffff8114f755>] ? do_filp_open+0x45/0xb0
  [<ffffffff8115bb65>] ? __alloc_fd+0xc5/0x120
  [<ffffffff8113e5f0>] ? do_sys_open+0x140/0x230
  [<ffffffff8156c5ed>] ? system_call_fastpath+0x1a/0x1f
Code:  Bad RIP value.
RIP  [<          (null)>]           (null)
  RSP <ffff8802532579a0>
CR2: 0000000000000000
---[ end trace b6ce5041151511a5 ]---

Thanks,
Tobias Klausmann


--------------000004000804080705080105
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Initializing cgroup subsys cpuacct
Linux version 3.11.0-desktop+ (tobi@s.klausmann.lan) (gcc version 4.7.2 20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #1 SMP PREEMPT Sun Sep 8 16:00:20 CEST 2013
Command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0-desktop+ root=UUID=85846622-26cb-4096-9ed4-b07b01dd3f92 resume=/dev/disk/by-id/ata-TOSHIBA_MK5059GSXP_32A4C6F1T-part3 splash=silent quiet showopts
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
BIOS-e820: [mem 0x0000000040005000-0x0000000096abefff] usable
BIOS-e820: [mem 0x0000000096abf000-0x0000000096ebefff] reserved
BIOS-e820: [mem 0x0000000096ebf000-0x0000000096fbefff] ACPI NVS
BIOS-e820: [mem 0x0000000096fbf000-0x0000000096ffefff] ACPI data
BIOS-e820: [mem 0x0000000096fff000-0x0000000096ffffff] usable
BIOS-e820: [mem 0x0000000097000000-0x000000009f9fffff] reserved
BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
BIOS-e820: [mem 0x00000000feb00000-0x00000000feb03fff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ffc80000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000025f5fffff] usable
NX (Execute Disable) protection: active
SMBIOS 2.7 present.
DMI: Acer Aspire V3-571G/VA50_HC_CR, BIOS V1.13 10/09/2012
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
No AGP bridge found
e820: last_pfn = 0x25f600 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-E7FFF write-protect
  E8000-EFFFF write-combining
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 080000000 mask FE0000000 write-back
  2 base 097000000 mask FFF000000 uncachable
  3 base 098000000 mask FF8000000 uncachable
  4 base 0FFC00000 mask FFFC00000 write-protect
  5 base 100000000 mask F00000000 write-back
  6 base 200000000 mask FC0000000 write-back
  7 base 240000000 mask FE0000000 write-back
  8 base 25F600000 mask FFFE00000 uncachable
  9 base 25F800000 mask FFF800000 uncachable
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820: last_pfn = 0x97000 max_arch_pfn = 0x400000000
found SMP MP-table at [mem 0x000fe1b0-0x000fe1bf] mapped at [ffff8800000fe1b0]
Scanning 1 areas for low memory corruption
Base memory trampoline at [ffff880000097000] 97000 size 24576
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
BRK [0x019ba000, 0x019bafff] PGTABLE
BRK [0x019bb000, 0x019bbfff] PGTABLE
BRK [0x019bc000, 0x019bcfff] PGTABLE
init_memory_mapping: [mem 0x25f400000-0x25f5fffff]
 [mem 0x25f400000-0x25f5fffff] page 2M
BRK [0x019bd000, 0x019bdfff] PGTABLE
init_memory_mapping: [mem 0x25c000000-0x25f3fffff]
 [mem 0x25c000000-0x25f3fffff] page 2M
init_memory_mapping: [mem 0x200000000-0x25bffffff]
 [mem 0x200000000-0x25bffffff] page 2M
BRK [0x019be000, 0x019befff] PGTABLE
init_memory_mapping: [mem 0x00100000-0x1fffffff]
 [mem 0x00100000-0x001fffff] page 4k
 [mem 0x00200000-0x1fffffff] page 2M
init_memory_mapping: [mem 0x20200000-0x40003fff]
 [mem 0x20200000-0x3fffffff] page 2M
 [mem 0x40000000-0x40003fff] page 4k
BRK [0x019bf000, 0x019bffff] PGTABLE
init_memory_mapping: [mem 0x40005000-0x96abefff]
 [mem 0x40005000-0x401fffff] page 4k
 [mem 0x40200000-0x969fffff] page 2M
 [mem 0x96a00000-0x96abefff] page 4k
init_memory_mapping: [mem 0x96fff000-0x96ffffff]
 [mem 0x96fff000-0x96ffffff] page 4k
init_memory_mapping: [mem 0x100000000-0x1ffffffff]
 [mem 0x100000000-0x1ffffffff] page 2M
RAMDISK: [mem 0x34030000-0x3600ffff]
ACPI: RSDP 00000000000fe020 00024 (v02 ACRSYS)
ACPI: XSDT 0000000096ffe210 00094 (v01 ACRSYS ACRPRDCT 00000001      01000013)
ACPI: FACP 0000000096ffb000 000F4 (v04 ACRSYS ACRPRDCT 00000001 1025 00040000)
ACPI: DSDT 0000000096fec000 0B781 (v01 ACRSYS ACRPRDCT 00000000 1025 00040000)
ACPI: FACS 0000000096fbb000 00040
ACPI: UEFI 0000000096ffd000 00236 (v01 ACRSYS ACRPRDCT 00000001 1025 00040000)
ACPI: ASF! 0000000096ffc000 000A5 (v32 ACRSYS ACRPRDCT 00000001 1025 00040000)
ACPI: HPET 0000000096ffa000 00038 (v01 ACRSYS ACRPRDCT 00000001 1025 00040000)
ACPI: APIC 0000000096ff9000 0008C (v02 ACRSYS ACRPRDCT 00000001 1025 00040000)
ACPI: MCFG 0000000096ff8000 0003C (v01 ACRSYS ACRPRDCT 00000001 1025 00040000)
ACPI: SLIC 0000000096feb000 00176 (v01 ACRSYS ACRPRDCT 00000001 1025 00040000)
ACPI: SSDT 0000000096fea000 006FE (v01 ACRSYS ACRPRDCT 00001000 1025 00040000)
ACPI: BOOT 0000000096fe8000 00028 (v01 ACRSYS ACRPRDCT 00000001 1025 00040000)
ACPI: ASPT 0000000096fe3000 00034 (v07 ACRSYS ACRPRDCT 00000001 1025 00040000)
ACPI: FPDT 0000000096fe1000 00044 (v01 ACRSYS ACRPRDCT 00000001 1025 00040000)
ACPI: SSDT 0000000096fe0000 008E4 (v01 ACRSYS ACRPRDCT 00003000 1025 00040000)
ACPI: SSDT 0000000096fdf000 00A92 (v01 ACRSYS ACRPRDCT 00003000 1025 00040000)
ACPI: SSDT 0000000096fdc000 0217A (v01 ACRSYS ACRPRDCT 00001000 1025 00040000)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at [mem 0x0000000000000000-0x000000025f5fffff]
Initmem setup node 0 [mem 0x00000000-0x25f5fffff]
  NODE_DATA [mem 0x25f5e3000-0x25f5f7fff]
 [ffffea0000000000-ffffea00085fffff] PMD -> [ffff880256e00000-ffff88025ddfffff] on node 0
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   [mem 0x100000000-0x25f5fffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0009cfff]
  node   0: [mem 0x00100000-0x1fffffff]
  node   0: [mem 0x20200000-0x40003fff]
  node   0: [mem 0x40005000-0x96abefff]
  node   0: [mem 0x96fff000-0x96ffffff]
  node   0: [mem 0x100000000-0x25f5fffff]
On node 0 totalpages: 2055771
  DMA zone: 56 pages used for memmap
  DMA zone: 21 pages reserved
  DMA zone: 3996 pages, LIFO batch:0
  DMA32 zone: 8375 pages used for memmap
  DMA32 zone: 612543 pages, LIFO batch:31
  Normal zone: 19677 pages used for memmap
  Normal zone: 1439232 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 8 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
PM: Registered nosave memory: [mem 0x96abf000-0x96ebefff]
PM: Registered nosave memory: [mem 0x96ebf000-0x96fbefff]
PM: Registered nosave memory: [mem 0x96fbf000-0x96ffefff]
PM: Registered nosave memory: [mem 0x97000000-0x9f9fffff]
PM: Registered nosave memory: [mem 0x9fa00000-0xdfffffff]
PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
PM: Registered nosave memory: [mem 0xf0000000-0xfeafffff]
PM: Registered nosave memory: [mem 0xfeb00000-0xfeb03fff]
PM: Registered nosave memory: [mem 0xfeb04000-0xfebfffff]
PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
PM: Registered nosave memory: [mem 0xfec01000-0xfed0ffff]
PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
PM: Registered nosave memory: [mem 0xfee01000-0xffc7ffff]
PM: Registered nosave memory: [mem 0xffc80000-0xffffffff]
e820: [mem 0x9fa00000-0xdfffffff] available for PCI devices
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff88025f200000 s77504 r8192 d20800 u262144
pcpu-alloc: s77504 r8192 d20800 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2027642
Policy zone: Normal
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0-desktop+ root=UUID=85846622-26cb-4096-9ed4-b07b01dd3f92 resume=/dev/disk/by-id/ata-TOSHIBA_MK5059GSXP_32A4C6F1T-part3 splash=silent quiet showopts
PID hash table entries: 4096 (order: 3, 32768 bytes)
xsave: enabled xstate_bv 0x7, cntxt size 0x340
Checking aperture...
No AGP bridge found
Memory: 7998436K/8223084K available (5568K kernel code, 579K rwdata, 1752K rodata, 1196K init, 816K bss, 224648K reserved)
Preemptible hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
NR_IRQS:4352 nr_irqs:744 16
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 33030144 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 2294.818 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 4589.63 BogoMIPS (lpj=2294818)
pid_max: default: 32768 minimum: 301
Security Framework initialized
AppArmor: AppArmor initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
Initializing cgroup subsys hugetlb
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 1
Freeing SMP alternatives memory: 24K (ffffffff818e6000 - ffffffff818ec000)
ACPI: Core revision 20130725
ACPI: All ACPI Tables successfully acquired
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz (fam: 06, model: 3a, stepping: 09)
TSC deadline timer enabled
Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             0000ffffffffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 OK
Brought up 8 CPUs
smpboot: Total of 8 processors activated (36717.08 BogoMIPS)
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0x96ebf000-0x96fbefff] (1048576 bytes)
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type PCI registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 0000000096df8018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20100121)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20100121)
ACPI: SSDT 0000000096df9a98 00303 (v01  PmRef    ApIst 00003000 INTL 20100121)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20100121)
ACPI: SSDT 0000000096df7d98 00119 (v01  PmRef    ApCst 00003000 INTL 20100121)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20100121)
ACPI: Interpreter enabled
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130725/hwxface-571)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 8 0 
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 1f 0 
acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
acpi PNP0A08:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-fe]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x9fa00000-0xfeafffff]
pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: System wakeup disabled by ACPI
pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
pci 0000:00:02.0: reg 0x10: [mem 0xb3000000-0xb33fffff 64bit]
pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
pci 0000:00:14.0: reg 0x10: [mem 0xb3600000-0xb360ffff 64bit]
pci 0000:00:14.0: PME# supported from D3hot D3cold
pci 0000:00:14.0: System wakeup disabled by ACPI
pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
pci 0000:00:16.0: reg 0x10: [mem 0xb3614000-0xb361400f 64bit]
pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
pci 0000:00:1a.0: reg 0x10: [mem 0xb3619000-0xb36193ff]
pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: System wakeup disabled by ACPI
pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
pci 0000:00:1b.0: reg 0x10: [mem 0xb3610000-0xb3613fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: System wakeup disabled by ACPI
pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: System wakeup disabled by ACPI
pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: System wakeup disabled by ACPI
pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
pci 0000:00:1d.0: reg 0x10: [mem 0xb3618000-0xb36183ff]
pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: System wakeup disabled by ACPI
pci 0000:00:1f.0: [8086:1e57] type 00 class 0x060100
pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
pci 0000:00:1f.2: reg 0x10: [io  0x3088-0x308f]
pci 0000:00:1f.2: reg 0x14: [io  0x3094-0x3097]
pci 0000:00:1f.2: reg 0x18: [io  0x3080-0x3087]
pci 0000:00:1f.2: reg 0x1c: [io  0x3090-0x3093]
pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
pci 0000:00:1f.2: reg 0x24: [mem 0xb3617000-0xb36177ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 0x10: [mem 0xb3615000-0xb36150ff 64bit]
pci 0000:00:1f.3: reg 0x20: [io  0x3040-0x305f]
pci 0000:01:00.0: [10de:0fd2] type 00 class 0x030000
pci 0000:01:00.0: reg 0x10: [mem 0xb2000000-0xb2ffffff]
pci 0000:01:00.0: reg 0x14: [mem 0xa0000000-0xafffffff 64bit pref]
pci 0000:01:00.0: reg 0x1c: [mem 0xb0000000-0xb1ffffff 64bit pref]
pci 0000:01:00.0: reg 0x24: [io  0x2000-0x207f]
pci 0000:01:00.0: reg 0x30: [mem 0xfff80000-0xffffffff pref]
pci 0000:01:00.0: System wakeup disabled by ACPI
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:01.0:   bridge window [mem 0xb2000000-0xb2ffffff]
pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xb1ffffff 64bit pref]
pci 0000:02:00.0: [14e4:16b5] type 00 class 0x020000
pci 0000:02:00.0: reg 0x10: [mem 0xb3430000-0xb343ffff 64bit pref]
pci 0000:02:00.0: reg 0x18: [mem 0xb3440000-0xb344ffff 64bit pref]
pci 0000:02:00.0: reg 0x30: [mem 0xfffff800-0xffffffff pref]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: System wakeup disabled by ACPI
pci 0000:02:00.1: [14e4:16bc] type 00 class 0x080501
pci 0000:02:00.1: reg 0x10: [mem 0xb3400000-0xb340ffff 64bit pref]
pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
pci 0000:02:00.2: [14e4:16be] type 00 class 0x088000
pci 0000:02:00.2: reg 0x10: [mem 0xb3410000-0xb341ffff 64bit pref]
pci 0000:02:00.2: PME# supported from D0 D3hot D3cold
pci 0000:02:00.3: [14e4:16bf] type 00 class 0x088000
pci 0000:02:00.3: reg 0x10: [mem 0xb3420000-0xb342ffff 64bit pref]
pci 0000:02:00.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [mem 0xb3400000-0xb34fffff 64bit pref]
pci 0000:03:00.0: [168c:0034] type 00 class 0x028000
pci 0000:03:00.0: reg 0x10: [mem 0xb3500000-0xb357ffff 64bit]
pci 0000:03:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: System wakeup disabled by ACPI
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [mem 0xb3500000-0xb35fffff]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 11 12 14 15) *7
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *7
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 *11 12 14 15)
ACPI: Enabled 6 GPEs in block 00 to 3F
ACPI: \_SB_.PCI0: notify handler is installed
Found 1 acpi root devices
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:01:00.0
vgaarb: no bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
e820: reserve RAM buffer [mem 0x96abf000-0x97ffffff]
e820: reserve RAM buffer [mem 0x97000000-0x97ffffff]
e820: reserve RAM buffer [mem 0x25f600000-0x25fffffff]
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Switched to clocksource hpet
AppArmor: AppArmor Filesystem Enabled
pnp: PnP ACPI init
ACPI: bus type PNP registered
pnp 00:00: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:01: Plug and Play ACPI device, IDs ETD0500 PNP0f13 (active)
pnp 00:02: [dma 4]
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
system 00:06: [io  0x0680-0x069f] has been reserved
system 00:06: [io  0xfd60-0xfd63] has been reserved
system 00:06: [io  0x1000-0x100f] has been reserved
system 00:06: [io  0xffff] has been reserved
system 00:06: [io  0xffff] has been reserved
system 00:06: [io  0x0400-0x0453] could not be reserved
system 00:06: [io  0x0458-0x047f] has been reserved
system 00:06: [io  0x0500-0x057f] has been reserved
system 00:06: [io  0x164e-0x164f] has been reserved
system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
system 00:08: [io  0x0454-0x0457] has been reserved
system 00:08: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
system 00:09: [mem 0xff000000-0xff000fff] has been reserved
system 00:09: [mem 0xff010000-0xffffffff] could not be reserved
system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
system 00:09: [mem 0x9fa00000-0x9fa00fff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:0a: [mem 0x20000000-0x201fffff] has been reserved
system 00:0a: [mem 0x40004000-0x40004fff] has been reserved
system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 11 devices
ACPI: bus type PNP unregistered
pci 0000:01:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]
pci 0000:02:00.0: no compatible bridge window for [mem 0xfffff800-0xffffffff pref]
pci 0000:03:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
pci 0000:00:1c.0: BAR 14: assigned [mem 0x9fb00000-0x9fbfffff]
pci 0000:00:1c.1: BAR 15: assigned [mem 0x9fc00000-0x9fcfffff pref]
pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x80000)
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:01.0:   bridge window [mem 0xb2000000-0xb2ffffff]
pci 0000:00:01.0:   bridge window [mem 0xa0000000-0xb1ffffff 64bit pref]
pci 0000:02:00.0: BAR 6: assigned [mem 0xb3450000-0xb34507ff pref]
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [mem 0x9fb00000-0x9fbfffff]
pci 0000:00:1c.0:   bridge window [mem 0xb3400000-0xb34fffff 64bit pref]
pci 0000:03:00.0: BAR 6: assigned [mem 0x9fc00000-0x9fc0ffff pref]
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [mem 0xb3500000-0xb35fffff]
pci 0000:00:1c.1:   bridge window [mem 0x9fc00000-0x9fcfffff pref]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x9fa00000-0xfeafffff]
pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:01: resource 1 [mem 0xb2000000-0xb2ffffff]
pci_bus 0000:01: resource 2 [mem 0xa0000000-0xb1ffffff 64bit pref]
pci_bus 0000:02: resource 1 [mem 0x9fb00000-0x9fbfffff]
pci_bus 0000:02: resource 2 [mem 0xb3400000-0xb34fffff 64bit pref]
pci_bus 0000:03: resource 1 [mem 0xb3500000-0xb35fffff]
pci_bus 0000:03: resource 2 [mem 0x9fc00000-0x9fcfffff pref]
NET: Registered protocol family 2
TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP: reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Unpacking initramfs...
Freeing initrd memory: 32640K (ffff880034030000 - ffff880036010000)
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB [mem 0x92abf000-0x96abf000] (64MB) mapped at [ffff880092abf000-ffff880096abefff]
Simple Boot Flag at 0x44 set to 0x1
Scanning for low memory corruption every 60 seconds
audit: initializing netlink socket (disabled)
type=2000 audit(1378655786.415:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 15685
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
intel_idle: MWAIT substates: 0x21120
intel_idle: v0.4 model 0x3A
intel_idle: lapic_timer_reliable_states 0xffffffff
GHES: HEST is not enabled!
Serial: 8250/16550 driver, 32 ports, IRQ sharing disabled
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x5 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part ems apst 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xb3617000 port 0xb3617100 irq 41
ata2: DUMMY
ata3: SATA max UDMA/133 abar m2048@0xb3617000 port 0xb3617200 irq 41
ata4: DUMMY
ata5: DUMMY
ata6: DUMMY
libphy: Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:1a.0: setting latency timer to 64
ehci-pci 0000:00:1a.0: EHCI Host Controller
ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci-pci 0000:00:1a.0: debug port 2
ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
ehci-pci 0000:00:1a.0: irq 16, io mem 0xb3619000
ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.11.0-desktop+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci-pci 0000:00:1d.0: setting latency timer to 64
ehci-pci 0000:00:1d.0: EHCI Host Controller
ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
ehci-pci 0000:00:1d.0: debug port 2
ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
ehci-pci 0000:00:1d.0: irq 23, io mem 0xb3618000
ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.11.0-desktop+ ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ehci-platform: EHCI generic platform driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
ohci-platform: OHCI generic platform driver
uhci_hcd: USB Universal Host Controller Interface driver
i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc_cmos 00:07: alarms up to one month, 242 bytes nvram, hpet irqs
ledtrig-cpu: registered to indicate activity on CPUs
hidraw: raw HID events driver (C) Jiri Kosina
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP: cubic registered
NET: Registered protocol family 10
Key type dns_resolver registered
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
usb 1-1: new high-speed USB device number 2 using ehci-pci
ata1.00: ATA-8: TOSHIBA MK5059GSXP, GN003J, max UDMA/100
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK5059GS GN00 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: [sda] 4096-byte physical blocks
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
usb 1-1: New USB device found, idVendor=8087, idProduct=0024
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
usb 2-1: new high-speed USB device number 2 using ehci-pci
usb 2-1: New USB device found, idVendor=8087, idProduct=0024
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATAPI: MATSHITADVD-RAM UJ8B0AW, 1.00, max UDMA/100
ata3.00: configured for UDMA/100
scsi 2:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ8B0AW  1.00 PQ: 0 ANSI: 5
usb 1-1.1: new full-speed USB device number 3 using ehci-pci
usb 1-1.1: string descriptor 0 read error: -22
usb 1-1.1: New USB device found, idVendor=04ca, idProduct=3006
usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1.3: new high-speed USB device number 4 using ehci-pci
tsc: Refined TSC clocksource calibration: 2294.787 MHz
psmouse serio1: elantech: assuming hardware version 3 (with firmware version 0x550f01)
psmouse serio1: elantech: Synaptics capabilities query result 0x79, 0x18, 0x0b.
usb 1-1.3: New USB device found, idVendor=04f2, idProduct=b2dc
usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1.3: Product: 1.3M HD WebCam
usb 1-1.3: Manufacturer: Chicony Electronics Co., Ltd.
usb 1-1.3: SerialNumber: SN0001
input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input1
registered taskstats version 1
AppArmor: AppArmor sha1 policy hashing enabled
rtc_cmos 00:07: setting system clock to 2013-09-08 15:56:31 UTC (1378655791)
Freeing unused kernel memory: 1196K (ffffffff817bb000 - ffffffff818e6000)
hp_sw: device handler registered
rdac: device handler registered
alua: device handler registered
emc: device handler registered
systemd-udevd[136]: starting version 195
ACPI: Requesting acpi_cpufreq
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/PNP0C0C:00/input/input2
ACPI: Power Button [PWRB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/PNP0C0D:00/input/input3
ACPI: Lid Switch [LID0]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/PNP0C0E:00/input/input4
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
ACPI: Power Button [PWRF]
wmi: Mapper loaded
xhci_hcd 0000:00:14.0: setting latency timer to 64
xhci_hcd 0000:00:14.0: xHCI Host Controller
xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
xhci_hcd 0000:00:14.0: irq 42 for MSI/MSI-X
usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: xHCI Host Controller
usb usb3: Manufacturer: Linux 3.11.0-desktop+ xhci_hcd
usb usb3: SerialNumber: 0000:00:14.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
[drm] Initialized drm 1.1.0 20060810
xhci_hcd 0000:00:14.0: xHCI Host Controller
xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: xHCI Host Controller
usb usb4: Manufacturer: Linux 3.11.0-desktop+ xhci_hcd
usb usb4: SerialNumber: 0000:00:14.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 4 ports detected
ACPI Warning: \_SB_.PCI0.PEG0.PEGP._DSM: Argument #4 type mismatch - Found [Integer], ACPI requires [Package] (20130725/nsarguments-95)
ACPI Warning: \_SB_.PCI0.PEG0.PEGP._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20130725/nsarguments-95)
ACPI Warning: \_SB_.PCI0.PEG0.PEGP._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20130725/nsarguments-95)
pci 0000:01:00.0: optimus capabilities: enabled, status dynamic power, hda bios codec supported
VGA switcheroo: detected Optimus DSM method \_SB_.PCI0.PEG0.PEGP handle
nouveau 0000:01:00.0: enabling device (0006 -> 0007)
[drm] hdmi device  not found 1 0 1
nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0e7120a2
nouveau  [  DEVICE][0000:01:00.0] Chipset: GK107 (NVE7)
nouveau  [  DEVICE][0000:01:00.0] Family : NVE0
nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
nouveau  [   VBIOS][0000:01:00.0] ... signature not found
nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
nouveau  [   VBIOS][0000:01:00.0] ... signature not found
nouveau  [   VBIOS][0000:01:00.0] checking ACPI for image...
usb 3-1: new high-speed USB device number 2 using xhci_hcd
usb 3-1: New USB device found, idVendor=05ac, idProduct=1297
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 3-1: Product: iPhone
usb 3-1: Manufacturer: Apple Inc.
usb 3-1: SerialNumber: f36a487159fbd43719eb3b3bfd09ca6ab345059e
usb 3-1: ep 0x2 - rounding interval to 8 microframes, ep desc says 10 microframes
usb 3-1: ep 0x81 - rounding interval to 8 microframes, ep desc says 10 microframes
Switched to clocksource tsc
usb 3-2: new full-speed USB device number 3 using xhci_hcd
usb 3-2: New USB device found, idVendor=1532, idProduct=0101
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: Razer Copperhead Laser Mouse
usb 3-2: Manufacturer: Razer
input: Razer Razer Copperhead Laser Mouse as /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0/input/input6
hid-generic 0003:1532:0101.0001: input,hidraw0: USB HID v10.01 Mouse [Razer Razer Copperhead Laser Mouse] on usb-0000:00:14.0-2/input0
input: Razer Razer Copperhead Laser Mouse as /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.1/input/input7
hid-generic 0003:1532:0101.0002: input,hidraw1: USB HID v10.01 Keyboard [Razer Razer Copperhead Laser Mouse] on usb-0000:00:14.0-2/input1
usb 3-3: new low-speed USB device number 4 using xhci_hcd
usb 3-3: New USB device found, idVendor=046d, idProduct=c30e
usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-3: Product: HID compliant keyboard
usb 3-3: Manufacturer: Logitech
usb 3-3: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
usb 3-3: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3:1.0/input/input8
hid-generic 0003:046D:C30E.0003: input,hidraw2: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:14.0-3/input0
input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3:1.1/input/input9
hid-generic 0003:046D:C30E.0004: input,hidraw3: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:14.0-3/input1
nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
nouveau  [   VBIOS][0000:01:00.0] using image from ACPI
nouveau  [   VBIOS][0000:01:00.0] BIT signature found
nouveau  [   VBIOS][0000:01:00.0] version 80.07.40.00.18
nouveau  [ DEVINIT][0000:01:00.0] adaptor not initialised
nouveau 0000:01:00.0: irq 43 for MSI/MSI-X
nouveau  [     PMC][0000:01:00.0] MSI interrupts enabled
nouveau  [     PFB][0000:01:00.0] RAM type: DDR3
nouveau  [     PFB][0000:01:00.0] RAM size: 2048 MiB
nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
nouveau  [  PTHERM][0000:01:00.0] FAN control: none / external
nouveau  [  PTHERM][0000:01:00.0] fan management: disabled
nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
[TTM] Zone  kernel: Available graphics memory: 4016148 kiB
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
nouveau  [     DRM] VRAM: 2048 MiB
nouveau  [     DRM] GART: 1048576 MiB
nouveau  [     DRM] TMDS table version 2.0
nouveau  [     DRM] DCB version 4.0
nouveau  [     DRM] ACPI backlight interface available, not registering our own
nouveau W[     DRM] voltage table 0x50 unknown
nouveau  [     DRM] 2 available performance level(s)
nouveau  [     DRM] 1: core 202MHz shader 405MHz memory 405MHz voltage 490mV
nouveau  [     DRM] 3: core 450MHz shader 900MHz memory 1080MHz voltage 560mV
nouveau  [     DRM] c:
nouveau  [     DRM] MM: using COPY for buffer copies
[drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00.0 on minor 0
[drm] Memory usable by graphics device = 2048M
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 44 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vga_switcheroo: enabled
vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=none
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[drm] failed to retrieve link info, disabling eDP
[drm] Wrong MCH_SSKPD value: 0x20100406
[drm] This can cause pipe underruns and display issues.
[drm] Please upgrade your BIOS to fix this.
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 170x48
i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
i915 0000:00:02.0: registered panic notifier
[Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
acpi device:38: registered as cooling_device8
ACPI: Video Device [PEGP] (multi-head: yes  rom: yes  post: no)
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:36/LNXVIDEO:00/input/input10
acpi device:44: registered as cooling_device9
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input11
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 1
[drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
video LNXVIDEO:00: Restoring backlight state
video LNXVIDEO:01: Restoring backlight state
PM: Starting manual resume from disk
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr
systemd[1]: systemd 195 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ; suse)
systemd[1]: Inserted module 'autofs4'
systemd[1]: Set hostname to <s.klausmann.lan>.
systemd[1]: Starting Collect Read-Ahead Data...
systemd[1]: Starting Replay Read-Ahead Data...
systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
systemd[1]: Started Forward Password Requests to Wall Directory Watch.
systemd[1]: Starting Syslog Socket.
systemd[1]: Listening on Syslog Socket.
systemd[1]: Starting Remote File Systems.
systemd[1]: Reached target Remote File Systems.
systemd[1]: Starting Delayed Shutdown Socket.
systemd[1]: Listening on Delayed Shutdown Socket.
systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
systemd[1]: Starting Encrypted Volumes.
systemd[1]: Reached target Encrypted Volumes.
systemd[1]: Starting udev Kernel Socket.
systemd[1]: Listening on udev Kernel Socket.
systemd[1]: Starting udev Control Socket.
systemd[1]: Listening on udev Control Socket.
systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
systemd[1]: Expecting device dev-disk-by\x2did-ata\x2dTOSHIBA_MK5059GSXP_32A4C6F1T\x2dpart3.device...
systemd[1]: Expecting device dev-disk-by\x2did-ata\x2dTOSHIBA_MK5059GSXP_32A4C6F1T\x2dpart4.device...
systemd[1]: Starting Journal Socket.
systemd[1]: Listening on Journal Socket.
systemd[1]: Mounting POSIX Message Queue File System...
systemd[1]: Mounting Huge Pages File System...
systemd[1]: Starting Create dynamic rule for /dev/root link...
systemd[1]: Starting Journal Service...
systemd[1]: Started Journal Service.
systemd[1]: Starting LSB: Set default boot entry if called...
systemd-readahead[288]: Bumped block_nr parameter of 8:0 to 20480. This is a temporary hack and should be removed one day.
EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr
BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
EDD information not available.
systemd-udevd[327]: starting version 195
ACPI Warning: \_SB_.PCI0.PEG0.PEGP._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20130725/nsarguments-95)
ACPI Warning: \_SB_.PCI0.PEG0.PEGP._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20130725/nsarguments-95)
usb 3-1: ep 0x2 - rounding interval to 8 microframes, ep desc says 10 microframes
usb 3-1: ep 0x81 - rounding interval to 8 microframes, ep desc says 10 microframes
ACPI: AC Adapter [ACAD] (on-line)
microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU0 updated to revision 0x17, date = 2013-01-09
microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU1 updated to revision 0x17, date = 2013-01-09
microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU2 updated to revision 0x17, date = 2013-01-09
microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU3 updated to revision 0x17, date = 2013-01-09
microcode: CPU4 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU4 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU4 updated to revision 0x17, date = 2013-01-09
microcode: CPU5 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU5 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU5 updated to revision 0x17, date = 2013-01-09
microcode: CPU6 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU6 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU6 updated to revision 0x17, date = 2013-01-09
microcode: CPU7 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU7 sig=0x306a9, pf=0x10, revision=0x15
microcode: CPU7 updated to revision 0x17, date = 2013-01-09
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
ACPI: Battery Slot [BAT1] (battery absent)
input: PC Speaker as /devices/platform/pcspkr/input/input12
ACPI Warning: 0x0000000000003040-0x000000000000305f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20130725/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
ipheth 3-1:4.2: Apple iPhone USB Ethernet device attached
usbcore: registered new interface driver ipheth
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
tg3.c:v3.133 (Jul 29, 2013)
tg3 0000:02:00.0 eth1: Tigon3 [partno(BCM57785) rev 57785100] (PCI Express) MAC address dc:0e:a1:a5:56:a8
tg3 0000:02:00.0 eth1: attached PHY is 57765 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
tg3 0000:02:00.0 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:02:00.0 eth1: dma_rwctrl[00000001] dma_mask[64-bit]
cfg80211: Calling CRDA to update world regulatory domain
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 2:0:0:0: Attached scsi generic sg1 type 5
usbcore: registered new interface driver btusb
ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130725/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_SB_.PCI0.PEG0.PEGP.GPIO 2 (20130725/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_SB_.PCI0.PEG0.PEGP.GPIO 2 (20130725/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
lpc_ich: Resource conflict(s) found affecting gpio_ich
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
Bluetooth: Patch file not found ar3k/AthrBT_0x11020000.dfu
Bluetooth: Loading patch file failed
ath3k: probe of 1-1.1:1.0 failed with error -2
usbcore: registered new interface driver ath3k
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
acer_wmi: Acer Laptop ACPI-WMI Extras
acer_wmi: Function bitmap for Communication Button: 0x801
acer_wmi: Brightness must be controlled by acpi video driver
input: Acer WMI hotkeys as /devices/virtual/input/input13
input: Acer BMA150 accelerometer as /devices/virtual/input/input14
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:02:00.1: SDHCI controller found [14e4:16bc] (rev 10)
mmc0: SDHCI controller on PCI [0000:02:00.1] using ADMA
Linux video capture interface: v2.00
ath: phy0: ASPM enabled: 0x42
ath: EEPROM regdomain: 0x6a
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: 00
ath: Regpair used: 0x6a
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
ieee80211 phy0: Atheros AR9462 Rev:2 mem=0xffffc90025080000, irq=17
uvcvideo: Found UVC 1.00 device 1.3M HD WebCam (04f2:b2dc)
input: 1.3M HD WebCam as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input15
usbcore: registered new interface driver uvcvideo
USB Video Class driver (1.1.1)
snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
fuse init (API version 7.22)
hda_codec: ALC269VB: SKU not ready 0x598301f0
ALSA sound/pci/hda/hda_auto_parser.c:393 autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
ALSA sound/pci/hda/hda_auto_parser.c:397    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_auto_parser.c:401    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_auto_parser.c:402    mono: mono_out=0x0
ALSA sound/pci/hda/hda_auto_parser.c:406    inputs:
ALSA sound/pci/hda/hda_auto_parser.c:410      Internal Mic=0x1b
ALSA sound/pci/hda/hda_auto_parser.c:410      Mic=0x18
ALSA sound/pci/hda/patch_realtek.c:491 realtek: No valid SSID, checking pincfg 0x598301f0 for NID 0x1d
ALSA sound/pci/hda/patch_realtek.c:574 realtek: Enable default setup for auto mode as fallback
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input16
Adding 1052668k swap on /dev/sda3.  Priority:-1 extents:1 across:1052668k FS
input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input17
input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input18
input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input19
systemd-journald[292]: Received SIGUSR1
IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
tg3 0000:02:00.0: irq 46 for MSI/MSI-X
tg3 0000:02:00.0: irq 47 for MSI/MSI-X
tg3 0000:02:00.0: irq 48 for MSI/MSI-X
tg3 0000:02:00.0: irq 49 for MSI/MSI-X
tg3 0000:02:00.0: irq 50 for MSI/MSI-X
IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<          (null)>]           (null)
PGD 24eaa0067 PUD 24e7ac067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP 
Modules linked in: bnep snd_hda_codec_hdmi snd_hda_codec_realtek fuse x86_pkg_temp_thermal coretemp snd_hda_intel kvm_intel snd_hda_codec snd_hwdep kvm snd_pcm uvcvideo snd_seq videobuf2_core snd_timer crct10dif_pclmul crc32_pclmul arc4 crc32c_intel snd_seq_device ghash_clmulni_intel ath9k videodev snd sdhci_pci sdhci aesni_intel iTCO_wdt iTCO_vendor_support mac80211 ablk_helper acer_wmi ath9k_common ath3k ath9k_hw sr_mod lpc_ich cryptd mmc_core joydev btusb sg ath cfg80211 tg3 acpi_cpufreq ptp pps_core ipheth cdrom videobuf2_vmalloc mfd_core sparse_keymap soundcore serio_raw bluetooth videobuf2_memops shpchp rfkill i2c_i801 pcspkr snd_page_alloc lrw gf128mul glue_helper aes_x86_64 microcode battery ac autofs4 nouveau i915 ttm drm_kms_helper drm xhci_hcd mxm_wmi i2c_algo_bit wmi video button processor thermal_sys scsi_dh_emc scsi_dh_alua scsi_dh_rdac scsi_dh_hp_sw scsi_dh
CPU: 0 PID: 792 Comm: Xorg Not tainted 3.11.0-desktop+ #1
Hardware name: Acer Aspire V3-571G/VA50_HC_CR, BIOS V1.13 10/09/2012
task: ffff880253031040 ti: ffff880253256000 task.ti: ffff880253256000
RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
RSP: 0018:ffff8802532579a0  EFLAGS: 00010246
RAX: ffff88024fabb000 RBX: ffff88024f3e2800 RCX: ffff88024eacf5c0
RDX: ffff88024fabb000 RSI: ffff88024f7fe760 RDI: ffff88024f3e2800
RBP: ffff88024ea2f480 R08: 0000000000000004 R09: 0000000000000000
R10: ffff88025f1e1f80 R11: 000000000000000f R12: ffff88024f3e2800
R13: ffff88024f3e2800 R14: 0000000000000004 R15: ffff880253257ab8
FS:  00007fe73cdd8880(0000) GS:ffff88025f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000025022c000 CR4: 00000000001407f0
Stack:
 ffffffffa021e4a2 ffff88024f234000 ffff88024f3e2800 ffff88024f3e2c38
 0000000000000000 ffff88024f3e2800 ffffffffa021eda5 ffff88025401d000
 ffff88024fabb000 ffff88025401d000 ffffffffa020e7cb ffff880253257ab8
Call Trace:
 [<ffffffffa021e4a2>] ? nouveau_display_init+0x42/0xd0 [nouveau]
 [<ffffffffa021eda5>] ? nouveau_display_resume+0x15/0xa0 [nouveau]
 [<ffffffffa020e7cb>] ? nouveau_pmops_runtime_resume+0x9b/0x100 [nouveau]
 [<ffffffff812ac745>] ? pci_pm_runtime_resume+0x85/0xc0
 [<ffffffff812ac6c0>] ? pci_restore_standard_config+0x30/0x30
 [<ffffffff8137b6f6>] ? __rpm_callback+0x36/0x80
 [<ffffffff8137b768>] ? rpm_callback+0x28/0x90
 [<ffffffff8137c48d>] ? rpm_resume+0x39d/0x570
 [<ffffffff81071483>] ? __wake_up+0x43/0x70
 [<ffffffff8137c8f8>] ? __pm_runtime_resume+0x48/0x70
 [<ffffffffa020e5a2>] ? nouveau_drm_open+0x42/0x1d0 [nouveau]
 [<ffffffff811bb858>] ? ext4_da_write_end+0xa8/0x2b0
 [<ffffffff811ef559>] ? jbd2_journal_stop+0x1d9/0x2c0
 [<ffffffff8124a56f>] ? apparmor_capable+0x1f/0x90
 [<ffffffffa00c5cab>] ? drm_open+0x28b/0x6e0 [drm]
 [<ffffffffa00c6206>] ? drm_stub_open+0x106/0x1a0 [drm]
 [<ffffffff81143bc0>] ? cdev_put+0x30/0x30
 [<ffffffff81143c56>] ? chrdev_open+0x96/0x1d0
 [<ffffffff81143bc0>] ? cdev_put+0x30/0x30
 [<ffffffff8113d186>] ? do_dentry_open+0x216/0x2a0
 [<ffffffff8113d238>] ? finish_open+0x28/0x40
 [<ffffffff8114e5e9>] ? do_last+0x709/0xe70
 [<ffffffff8114a9e8>] ? link_path_walk+0x68/0x860
 [<ffffffff81124b24>] ? kmem_cache_alloc+0x1b4/0x1d0
 [<ffffffff8114ee21>] ? path_openat+0xd1/0x660
 [<ffffffff8114f755>] ? do_filp_open+0x45/0xb0
 [<ffffffff8115bb65>] ? __alloc_fd+0xc5/0x120
 [<ffffffff8113e5f0>] ? do_sys_open+0x140/0x230
 [<ffffffff8156c5ed>] ? system_call_fastpath+0x1a/0x1f
Code:  Bad RIP value.
RIP  [<          (null)>]           (null)
 RSP <ffff8802532579a0>
CR2: 0000000000000000
---[ end trace b6ce5041151511a5 ]---
tg3 0000:02:00.0 eth1: Link is up at 100 Mbps, full duplex
tg3 0000:02:00.0 eth1: Flow control is on for TX and on for RX
tg3 0000:02:00.0 eth1: EEE is disabled
IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
NET: Registered protocol family 17

--------------000004000804080705080105--
