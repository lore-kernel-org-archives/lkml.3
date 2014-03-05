Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbaCENce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:32:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:50433 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbaCENcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:32:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,593,1389772800"; 
   d="scan'208";a="486450170"
Date: Wed, 5 Mar 2014 21:31:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [x86, kaslr] Initramfs unpacking failed: junk in compressed archive
Message-ID: <20140305133157.GC10880@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 82fa9637a2ba285bcc7c5050c73010b2c1b3d803
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu Oct 10 17:18:16 2013 -0700
Commit:     H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun Oct 13 03:12:19 2013 -0700

    x86, kaslr: Select random position from e820 maps
    
    Counts available alignment positions across all e820 maps, and chooses
    one randomly for the new kernel base address, making sure not to collide
    with unsafe memory areas.
    
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Link: http://lkml.kernel.org/r/1381450698-28710-5-git-send-email-keescook@chromium.org
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

+--------------------------------------------------------------------------+--------------+--------------+
|                                                                          | 5bfce5ef55cb | bcf1647d0899 |
+--------------------------------------------------------------------------+--------------+--------------+
| boot_successes                                                           | 3954         | 20767        |
| boot_failures                                                            | 46           | 784          |
| Kernel_panic-not_syncing:No_init_found.Try_passing_init=option_to_kernel.| 39           |              |
| backtrace:panic                                                          | 39           | 91           |
| INFO:rcu_sched_self-detected_stall_on_CPU                                | 34           | 44           |
| EIP_is_at__default_send_IPI_dest_field                                   | 38           | 52           |
| EIP_is_at_native_safe_halt                                               | 33           | 25           |
| INFO:rcu_sched_detected_stalls_on_CPUs/tasks                             | 24           | 32           |
| backtrace:apic_timer_interrupt                                           | 17           | 19           |
| backtrace:rbtree_test_init                                               | 31           | 34           |
| backtrace:kernel_init_freeable                                           | 38           | 304          |
| backtrace:cpu_startup_entry                                              | 25           | 33           |
| backtrace:erase_augmented                                                | 13           | 6            |
| EIP_is_at_graph_lock                                                     | 1            |              |
| backtrace:lock_acquire                                                   | 1            |              |
| backtrace:devtmpfsd                                                      | 1            |              |
| EIP_is_at_do_raw_spin_lock                                               | 1            |              |
| backtrace:schedule_timeout                                               | 2            | 10           |
| EIP_is_at_slob_page_alloc                                                | 1            | 13           |
| BUG:soft_lockup-CPU_stuck_for_s                                          | 7            | 210          |
| EIP_is_at_augment_callbacks_propagate                                    | 2            |              |
| Kernel_panic-not_syncing:softlockup:hung_tasks                           | 7            | 210          |
| backtrace:__kmalloc                                                      | 1            | 210          |
| backtrace:dma_debug_init                                                 | 1            | 211          |
| backtrace:pci_iommu_init                                                 | 1            | 211          |
| backtrace:check_augmented                                                | 3            | 8            |
| backtrace:insert_augmented                                               | 8            | 5            |
| EIP_is_at_mcount                                                         | 1            | 5            |
| EIP_is_at_erase_augmented                                                | 1            |              |
| EIP_is_at__delay                                                         | 1            | 1            |
| EIP_is_at__rb_rotate_set_parents                                         | 1            |              |
| EIP_is_at__rb_erase_color                                                | 2            |              |
| EIP_is_at_augment_callbacks_rotate                                       | 1            |              |
| EIP_is_at_insert_augmented                                               | 1            | 1            |
| backtrace:check                                                          | 1            |              |
| EIP_is_at_augment_recompute                                              | 1            |              |
| EIP_is_at_arch_local_irq_save                                            | 1            | 1            |
| backtrace:acpi_processor_get_power_info                                  | 1            |              |
| backtrace:acpi_processor_power_init                                      | 1            |              |
| backtrace:driver_register                                                | 1            |              |
| backtrace:acpi_processor_driver_init                                     | 1            |              |
| BUG:kernel_boot_hang                                                     | 0            | 187          |
| BUG:kernel_boot_crashed                                                  | 0            | 171          |
| EIP_is_at_arch_local_irq_restore                                         | 0            | 193          |
| EIP_is_at_native_apic_mem_write                                          | 0            | 4            |
| EIP_is_at_io_serial_in                                                   | 0            | 1            |
| Kernel_panic-not_syncing:No_working_init_found                           | 0            | 91           |
| BUG:kernel_test_crashed                                                  | 0            | 1            |
| EIP_is_at_native_load_tls                                                | 0            | 1            |
| EIP_is_at_slob_alloc                                                     | 0            | 4            |
| backtrace:smpboot_thread_fn                                              | 0            | 2            |
| backtrace:event_create_dir                                               | 0            | 12           |
| backtrace:event_trace_init                                               | 0            | 12           |
| BUG:kernel_early_hang_without_any_printk_output                          | 0            | 7            |
| EIP_is_at_raw_spin_lock                                                  | 0            | 2            |
| backtrace:SYSC_symlinkat                                                 | 0            | 2            |
| backtrace:SyS_symlink                                                    | 0            | 2            |
| backtrace:populate_rootfs                                                | 0            | 57           |
| EIP_is_at__lock_acquire                                                  | 0            | 54           |
| EIP_is_at_arch_local_irq_enable                                          | 0            | 5            |
| EIP_is_at_arch_local_save_flags                                          | 0            | 1            |
| EIP_is_at_ftrace_likely_update                                           | 0            | 3            |
| EIP_is_at_ftrace_stub                                                    | 0            | 1            |
| backtrace:prepare_to_wait_event                                          | 0            | 2            |
| EIP_is_at_slob_next                                                      | 0            | 3            |
| EIP_is_at_do_path_lookup                                                 | 0            | 1            |
| EIP_is_at_run_timer_softirq                                              | 0            | 1            |
| backtrace:free_reserved_area                                             | 0            | 53           |
| backtrace:free_init_pages                                                | 0            | 53           |
| BUG:unable_to_handle_kernel                                              | 0            | 54           |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference                     | 0            | 2            |
| Oops                                                                     | 0            | 54           |
| Oops:SMP_SMP                                                             | 0            | 54           |
| EIP_is_at__queue_work                                                    | 0            | 2            |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt                    | 0            | 2            |
| EIP_is_at_lock_release                                                   | 0            | 2            |
| backtrace:vfs_lstat                                                      | 0            | 1            |
| backtrace:SyS_newlstat                                                   | 0            | 1            |
| backtrace:__pci_register_driver                                          | 0            | 3            |
| backtrace:virtio_pci_driver_init                                         | 0            | 3            |
| EIP_is_at_mark_held_locks                                                | 0            | 1            |
| EIP_is_at_serial_in                                                      | 0            | 1            |
| BUG:unable_to_handle_kernel_paging_request                               | 0            | 56           |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=                | 0            | 52           |
| BUG:Int_CR2(null)                                                        | 0            | 53           |
| backtrace:kvm_get_tsc_khz                                                | 0            | 53           |
| backtrace:kvmclock_init                                                  | 0            | 53           |
| backtrace:debug_check_no_locks_freed                                     | 0            | 2            |
| backtrace:__raw_spin_lock_init                                           | 0            | 2            |
| EIP_is_at_raw_spin_lock_irqsave                                          | 0            | 1            |
| EIP_is_at__might_sleep                                                   | 0            | 1            |
| backtrace:force_qs_rnp                                                   | 0            | 3            |
| EIP_is_at_rb_insert_color                                                | 0            | 1            |
| backtrace:insert                                                         | 0            | 1            |
| WARNING:CPU:PID:at_lib/list_debug.c:__list_del_entry()                   | 0            | 1            |
| backtrace:platform_device_register_full                                  | 0            | 1            |
| backtrace:ibwdt_init                                                     | 0            | 1            |
| EIP_is_at_trace_create_file                                              | 0            | 1            |
| backtrace:address_space_init_once                                        | 0            | 1            |
| backtrace:inode_init_once                                                | 0            | 1            |
| backtrace:init_once                                                      | 0            | 1            |
| EIP_is_at_raw_spin_unlock_irqrestore                                     | 0            | 1            |
| EIP_is_at__kmalloc                                                       | 0            | 1            |
| EIP_is_at_sched_clock_local                                              | 0            | 1            |
| EIP_is_at_inode_sb_list_add                                              | 0            | 1            |
| EIP_is_at_sched_clock_cpu                                                | 0            | 1            |
| EIP_is_at_lock_is_held                                                   | 0            | 1            |
| Oops:SMP                                                                 | 0            | 4            |
| EIP_is_at__insert_resource                                               | 0            | 4            |
| Kernel_panic-not_syncing:Attempted_to_kill_the_idle_task                 | 0            | 4            |
| EIP_is_at_update_curr                                                    | 0            | 1            |
| EIP_is_at_hlock_class                                                    | 0            | 1            |
| EIP_is_at_delay_tsc                                                      | 0            | 1            |
| EIP_is_at_trace_softirqs_on                                              | 0            | 1            |
| EIP_is_at_pick_next_task_fair                                            | 0            | 1            |
| INFO:rcu_sched_self-detected_stall_on_CPU_INFO:rcu_sched_self-detected_st| 0            | 1            |
| EIP_is_at_serial_port_out                                                | 0            | 1            |
| EIP_is_at_rcu_implicit_dynticks_qs                                       | 0            | 1            |
| EIP_is_at_raw_spin_trylock                                               | 0            | 1            |
| EIP_is_at__rb_insert_augmented                                           | 0            | 1            |
+--------------------------------------------------------------------------+--------------+--------------+

[    0.824047] Initramfs unpacking failed: junk in compressed archive
[    0.824047] Initramfs unpacking failed: junk in compressed archive

git bisect start bcf1647d0899666f0fb90d176abf63bae22abb7c v3.13 --
git bisect  bad 903a9f77d1d00c8621bc37afd959ac45a4b3ebec  # 17:29     65-      1  Merge tag 'boards-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect  bad ec513b16c480c6cdda1e3d597e611eafca05227b  # 17:45     96-      2  Merge tag 'usb-3.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect good 4cd4156994d1e66759a86446feb82d932f63f5c8  # 19:47    980+      4  Merge branch 'x86-asm-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good fab5669d556200c4dd119af705bff14085845d1e  # 23:13    980+     11  Merge branch 'x86-ras-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 82b51734b4f228c76b6064b6e899d9d3d4c17c1a  # 23:23     39-      2  Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
git bisect  bad f4bcd8ccddb02833340652e9f46f5127828eb79d  # 23:34    125-      2  Merge branch 'x86-kaslr-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 7fe67a1180db49d41a3f764c379a08f8e31580ec  # 00:39   1000+     14  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 6145cfe394a7f138f6b64491c5663f97dba12450  # 01:02     80-      2  x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64
git bisect good 8ab3820fd5b2896d66da7bb2a906bc382e63e7bc  # 04:38   1000+      8  x86, kaslr: Return location from decompress_kernel
git bisect  bad 82fa9637a2ba285bcc7c5050c73010b2c1b3d803  # 05:02    137-      4  x86, kaslr: Select random position from e820 maps
git bisect good 5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3  # 06:56   1000+     16  x86, kaslr: Provide randomness functions
# first bad commit: [82fa9637a2ba285bcc7c5050c73010b2c1b3d803] x86, kaslr: Select random position from e820 maps
git bisect good 5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3  # 09:10   3000+     46  x86, kaslr: Provide randomness functions
git bisect  bad 12f1d94f0c8b256c04cb9b6b5dd989c32e44f11b  # 09:10      0-     29  Add linux-next specific files for 20140220
git bisect good ca60d29925602b4f54a1ec9ee3424aaa490b9c0f  # 14:23   3000+   1065  Revert "x86, kaslr: Select random position from e820 maps"
git bisect  bad 8427defd087ae6c5eaea9d609dfe7f165568accd  # 14:46     69-      3  MAINTAINERS: add maintainer entry for Armada DRM driver
git bisect  bad b148a42ba7823e34971cd4e5b05a5c74fa3311ed  # 15:16    127-      6  Add linux-next specific files for 20140228

Thanks,
Fengguang

--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-inn-18:20140225174615:i386-randconfig-c1-02202022::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.13.0-10237-gbcf1647 (wfg@bee) (gcc version 4=
=2E8.1 (Debian 4.8.1-3) ) #435 SMP Sat Feb 22 10:02:15 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x0effffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0d400000-0x0d7fffff]
[    0.000000]  [mem 0x0d400000-0x0d7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0d3fffff]
[    0.000000]  [mem 0x08000000-0x0d3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0d800000-0x0fffdfff]
[    0.000000]  [mem 0x0d800000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 198f000, base 00000000=
, limit 00000000)
[    0.000000] cma: CMA: reserved 28 MiB at 0b800000
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x0e966000, 0x0e966fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 8e0c0f00, node_mem_map 8d=
5ff020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @8b564000 s1344392 r0 d23672 =
u1368064
[    0.000000] pcpu-alloc: s1344392 r0 d23672 u1368064 alloc=3D334*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr b566780
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-c1-02202022/next:master:bcf1647d0899666f0fb90d176abf63ba=
e22abb7c:bisect-usb/.vmlinuz-bcf1647d0899666f0fb90d176abf63bae22abb7c-20140=
222192759-1277-inn branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfi=
g-c1-02202022/bcf1647d0899666f0fb90d176abf63bae22abb7c/vmlinuz-3.13.0-10237=
-gbcf1647
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 187156K/261744K available (5627K kernel code, 727K r=
wdata, 2932K rodata, 1840K init, 6428K bss, 74588K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff14000 - 0xfffff000   ( 940 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff7fe000   (1776 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x8e113000 - 0x8e2df000   (1840 kB)
[    0.000000]       .data : 0x8dd7f21a - 0x8e112f00   (3663 kB)
[    0.000000]       .text : 0x8d800000 - 0x8dd7f21a   (5628 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D8b004000 soft=3D8b006000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.13.0-10237-gbcf1647 (wfg@bee) (gcc version 4=
=2E8.1 (Debian 4.8.1-3) ) #435 SMP Sat Feb 22 10:02:15 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x0effffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0d400000-0x0d7fffff]
[    0.000000]  [mem 0x0d400000-0x0d7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0d3fffff]
[    0.000000]  [mem 0x08000000-0x0d3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0d800000-0x0fffdfff]
[    0.000000]  [mem 0x0d800000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 198f000, base 00000000=
, limit 00000000)
[    0.000000] cma: CMA: reserved 28 MiB at 0b800000
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x0e966000, 0x0e966fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 8e0c0f00, node_mem_map 8d=
5ff020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @8b564000 s1344392 r0 d23672 =
u1368064
[    0.000000] pcpu-alloc: s1344392 r0 d23672 u1368064 alloc=3D334*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr b566780
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-c1-02202022/next:master:bcf1647d0899666f0fb90d176abf63ba=
e22abb7c:bisect-usb/.vmlinuz-bcf1647d0899666f0fb90d176abf63bae22abb7c-20140=
222192759-1277-inn branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfi=
g-c1-02202022/bcf1647d0899666f0fb90d176abf63bae22abb7c/vmlinuz-3.13.0-10237=
-gbcf1647
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 187156K/261744K available (5627K kernel code, 727K r=
wdata, 2932K rodata, 1840K init, 6428K bss, 74588K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff14000 - 0xfffff000   ( 940 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff7fe000   (1776 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x8e113000 - 0x8e2df000   (1840 kB)
[    0.000000]       .data : 0x8dd7f21a - 0x8e112f00   (3663 kB)
[    0.000000]       .text : 0x8d800000 - 0x8dd7f21a   (5628 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D8b004000 soft=3D8b006000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
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
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.328 MHz processor
[    0.000000] tsc: Detected 2693.328 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value..=20
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.65 Bogo=
MIPS (lpj=3D10773312)
5386.65 BogoMIPS (lpj=3D10773312)
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008103] Security Framework initialized
[    0.008103] Security Framework initialized
[    0.008859] AppArmor: AppArmor disabled by boot time parameter
[    0.008859] AppArmor: AppArmor disabled by boot time parameter
[    0.009821] Yama: becoming mindful.
[    0.009821] Yama: becoming mindful.
[    0.010461] Mount-cache hash table entries: 512
[    0.010461] Mount-cache hash table entries: 512
[    0.012749] Initializing cgroup subsys debug
[    0.012749] Initializing cgroup subsys debug
[    0.013555] Initializing cgroup subsys net_cls
[    0.013555] Initializing cgroup subsys net_cls
[    0.014444] mce: CPU supports 10 MCE banks
[    0.014444] mce: CPU supports 10 MCE banks
[    0.015178] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015178] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.015178] tlb_flushall_shift: 6
[    0.015178] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015178] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.015178] tlb_flushall_shift: 6
[    0.016395] Freeing SMP alternatives memory: 12K (8e2df000 - 8e2e2000)
[    0.016395] Freeing SMP alternatives memory: 12K (8e2df000 - 8e2e2000)
[    0.020794] Getting VERSION: 50014
[    0.020794] Getting VERSION: 50014
[    0.021426] Getting VERSION: 50014
[    0.021426] Getting VERSION: 50014
[    0.022184] Getting ID: 0
[    0.022184] Getting ID: 0
[    0.022638] Getting ID: f000000
[    0.022638] Getting ID: f000000
[    0.023162] Getting LVT0: 8700
[    0.023162] Getting LVT0: 8700
[    0.023718] Getting LVT1: 8400
[    0.023718] Getting LVT1: 8400
[    0.024017] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.024017] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.024975] enabled ExtINT on CPU#0
[    0.024975] enabled ExtINT on CPU#0
[    0.026402] ENABLING IO-APIC IRQs
[    0.026402] ENABLING IO-APIC IRQs
[    0.026975] init IO_APIC IRQs
[    0.026975] init IO_APIC IRQs
[    0.027463]  apic 0 pin 0 not connected
[    0.027463]  apic 0 pin 0 not connected
[    0.028043] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.028043] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.029417] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.029417] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.030714] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.030714] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.032034] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.032034] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.033382] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.033382] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.036028] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.036028] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.037344] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.037344] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.038635] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.038635] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.040031] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.040031] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.041335] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.041335] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.042685] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.042685] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.044029] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.044029] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.045384] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.045384] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.046713] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.046713] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.048028] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.048028] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.049418]  apic 0 pin 16 not connected
[    0.049418]  apic 0 pin 16 not connected
[    0.050256]  apic 0 pin 17 not connected
[    0.050256]  apic 0 pin 17 not connected
[    0.051115]  apic 0 pin 18 not connected
[    0.051115]  apic 0 pin 18 not connected
[    0.052011]  apic 0 pin 19 not connected
[    0.052011]  apic 0 pin 19 not connected
[    0.052891]  apic 0 pin 20 not connected
[    0.052891]  apic 0 pin 20 not connected
[    0.053787]  apic 0 pin 21 not connected
[    0.053787]  apic 0 pin 21 not connected
[    0.054420]  apic 0 pin 22 not connected
[    0.054420]  apic 0 pin 22 not connected
[    0.055056]  apic 0 pin 23 not connected
[    0.055056]  apic 0 pin 23 not connected
[    0.056157] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.056157] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.057736] smpboot: CPU0:=20
[    0.057736] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.059314] Using local APIC timer interrupts.
[    0.059314] calibrating APIC timer ...
[    0.059314] Using local APIC timer interrupts.
[    0.059314] calibrating APIC timer ...
[    0.064000] ... lapic delta =3D 6250556
[    0.064000] ... lapic delta =3D 6250556
[    0.064000] ... PM-Timer delta =3D 357995
[    0.064000] ... PM-Timer delta =3D 357995
[    0.064000] ... PM-Timer result ok
[    0.064000] ... PM-Timer result ok
[    0.064000] ..... delta 6250556
[    0.064000] ..... delta 6250556
[    0.064000] ..... mult: 268459336
[    0.064000] ..... mult: 268459336
[    0.064000] ..... calibration result: 4000355
[    0.064000] ..... calibration result: 4000355
[    0.064000] ..... CPU clock speed is 2693.3185 MHz.
[    0.064000] ..... CPU clock speed is 2693.3185 MHz.
[    0.064000] ..... host bus clock speed is 1000.0355 MHz.
[    0.064000] ..... host bus clock speed is 1000.0355 MHz.
[    0.064104] Performance Events:=20
[    0.064104] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.069593] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.069593] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.072539] CPU 1 irqstacks, hard=3D8b088000 soft=3D8b08a000
[    0.072539] CPU 1 irqstacks, hard=3D8b088000 soft=3D8b08a000
[    0.074161] x86: Booting SMP configuration:
[    0.074161] x86: Booting SMP configuration:
[    0.075360] .... node  #0, CPUs: =20
[    0.075360] .... node  #0, CPUs:         #1 #1
[    0.004000] Initializing CPU#1
[    0.008000] kvm-clock: cpu 1, msr 0:fffd021, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.096081] x86: Booted up 1 node, 2 CPUs
[    0.096081] x86: Booted up 1 node, 2 CPUs
[    0.097137] smpboot: Total of 2 processors activated (10773.31 BogoMIPS)
[    0.097137] smpboot: Total of 2 processors activated (10773.31 BogoMIPS)
[    0.100011] KVM setup async PF for cpu 1
[    0.100011] KVM setup async PF for cpu 1
[    0.100011] kvm-stealtime: cpu 1, msr b6b4780
[    0.100011] kvm-stealtime: cpu 1, msr b6b4780
[    0.104134] devtmpfs: initialized
[    0.104134] devtmpfs: initialized
[    0.108251] EVM: security.SMACK64
[    0.108251] EVM: security.SMACK64
[    0.109077] EVM: security.capability
[    0.109077] EVM: security.capability
[    0.112041] prandom: seed boundary self test passed
[    0.112041] prandom: seed boundary self test passed
[    0.113994] prandom: 100 self tests passed
[    0.113994] prandom: 100 self tests passed
[    0.115027] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.115027] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.116067] pinctrl core: initialized pinctrl subsystem
[    0.116067] pinctrl core: initialized pinctrl subsystem
[    0.118922] regulator-dummy: no parameters
[    0.118922] regulator-dummy: no parameters
[    0.127126] RTC time: 17:33:00, date: 02/25/14
[    0.127126] RTC time: 17:33:00, date: 02/25/14
[    0.128476] NET: Registered protocol family 16
[    0.128476] NET: Registered protocol family 16
[    0.130566] cpuidle: using governor menu
[    0.130566] cpuidle: using governor menu
[    0.164845] ACPI: bus type PCI registered
[    0.164845] ACPI: bus type PCI registered
[    0.166228] dca service started, version 1.12.1
[    0.166228] dca service started, version 1.12.1
[    0.167341] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.167341] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.168013] PCI: Using configuration type 1 for base access
[    0.168013] PCI: Using configuration type 1 for base access
[    0.185739] bio: create slab <bio-0> at 0
[    0.185739] bio: create slab <bio-0> at 0
[    0.188447] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.188447] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.190843] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.190843] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.192325] ACPI: Added _OSI(Module Device)
[    0.192325] ACPI: Added _OSI(Module Device)
[    0.193878] ACPI: Added _OSI(Processor Device)
[    0.193878] ACPI: Added _OSI(Processor Device)
[    0.196013] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.196013] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.197620] ACPI: Added _OSI(Processor Aggregator Device)
[    0.197620] ACPI: Added _OSI(Processor Aggregator Device)
[    0.221459] ACPI: Interpreter enabled
[    0.221459] ACPI: Interpreter enabled
[    0.222567] ACPI Exception: AE_NOT_FOUND,=20
[    0.222567] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    0.224569] ACPI Exception: AE_NOT_FOUND,=20
[    0.224569] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    0.226585] ACPI: (supports S0 S3 S5)
[    0.226585] ACPI: (supports S0 S3 S5)
[    0.227315] ACPI: Using IOAPIC for interrupt routing
[    0.227315] ACPI: Using IOAPIC for interrupt routing
[    0.228136] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.228136] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.267004] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.267004] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.268025] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.268025] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.269655] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.269655] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.273579] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.273579] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.276471] PCI host bridge to bus 0000:00
[    0.276471] PCI host bridge to bus 0000:00
[    0.277487] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.277487] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.278911] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.278911] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.280017] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.280017] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.281641] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.281641] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.284016] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.284016] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.285833] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.285833] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.288811] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.288811] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.292054] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.292054] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.297146] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.297146] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.301293] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.301293] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.303383] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.303383] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.304031] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.304031] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.308258] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.308258] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.312914] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.312914] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.316969] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.316969] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.328101] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.328101] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.332240] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.332240] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.335158] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.335158] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.337482] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.337482] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.347006] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.347006] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.348901] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.348901] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.352766] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.352766] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.355590] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.355590] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.365101] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.365101] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.367462] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.367462] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.369334] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.369334] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.378148] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.378148] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.380634] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.380634] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.382964] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.382964] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.392297] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.392297] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.395409] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.395409] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.397419] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.397419] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.408563] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.408563] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.411711] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.411711] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.413416] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.413416] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.424613] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.424613] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.427720] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.427720] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.429488] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.429488] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.440749] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.440749] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.443103] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.443103] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.450498] pci_bus 0000:00: on NUMA node 0
[    0.450498] pci_bus 0000:00: on NUMA node 0
[    0.453927] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.453927] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.456128] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.456128] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.458254] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.458254] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.460504] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.460504] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.462336] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.462336] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.465971] ACPI:=20
[    0.465971] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.468726] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.468726] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.470705] vgaarb: loaded
[    0.470705] vgaarb: loaded
[    0.470705] vgaarb: bridge control possible 0000:00:02.0
[    0.470705] vgaarb: bridge control possible 0000:00:02.0
[    0.473923] SCSI subsystem initialized
[    0.473923] SCSI subsystem initialized
[    0.474025] pps_core: LinuxPPS API ver. 1 registered
[    0.474025] pps_core: LinuxPPS API ver. 1 registered
[    0.476019] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.476019] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.479528] wmi: Mapper loaded
[    0.479528] wmi: Mapper loaded
[    0.482172] PCI: Using ACPI for IRQ routing
[    0.482172] PCI: Using ACPI for IRQ routing
[    0.482172] PCI: pci_cache_line_size set to 64 bytes
[    0.482172] PCI: pci_cache_line_size set to 64 bytes
[    0.484311] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.484311] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.485952] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.485952] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.490092] NET: Registered protocol family 8
[    0.490092] NET: Registered protocol family 8
[    0.491399] NET: Registered protocol family 20
[    0.491399] NET: Registered protocol family 20
[    0.492150] NetLabel: Initializing
[    0.492150] NetLabel: Initializing
[    0.493013] NetLabel:  domain hash size =3D 128
[    0.493013] NetLabel:  domain hash size =3D 128
[    0.494125] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.494125] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.496426] NetLabel:  unlabeled traffic allowed by default
[    0.496426] NetLabel:  unlabeled traffic allowed by default
[    0.500099] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.500099] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.500099] hpet0: at MMIO 0xfed00000, IRQs
[    0.500099] hpet0: at MMIO 0xfed00000, IRQs 2 2, 8, 8, 0, 0

[    0.501355] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.501355] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.508928] Switched to clocksource kvm-clock
[    0.508928] Switched to clocksource kvm-clock
[    0.513685] Warning: could not register annotated branches stats
[    0.513685] Warning: could not register annotated branches stats
[    0.704187] FS-Cache: Loaded
[    0.704187] FS-Cache: Loaded
[    0.705668] CacheFiles: Loaded
[    0.705668] CacheFiles: Loaded
[    0.706771] pnp: PnP ACPI init
[    0.706771] pnp: PnP ACPI init
[    0.711156] ACPI: bus type PNP registered
[    0.711156] ACPI: bus type PNP registered
[    0.712449] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.712449] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.718314] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.718314] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.720244] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.720244] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.725693] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.725693] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.728466] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.728466] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.731105] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.731105] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.732794] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.732794] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.735798] pnp 00:03: [dma 2]
[    0.735798] pnp 00:03: [dma 2]
[    0.736653] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.736653] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.738578] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.738578] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.740601] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.740601] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.743489] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.743489] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.745728] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.745728] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.748594] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.748594] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.751973] pnp: PnP ACPI: found 7 devices
[    0.751973] pnp: PnP ACPI: found 7 devices
[    0.752935] ACPI: bus type PNP unregistered
[    0.752935] ACPI: bus type PNP unregistered
[    0.793536] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.793536] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.795212] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.795212] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.796503] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.796503] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.798163] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.798163] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.799879] NET: Registered protocol family 2
[    0.799879] NET: Registered protocol family 2
[    0.801753] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    0.801753] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    0.803875] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.803875] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.805691] TCP: Hash tables configured (established 2048 bind 2048)
[    0.805691] TCP: Hash tables configured (established 2048 bind 2048)
[    0.807530] TCP: reno registered
[    0.807530] TCP: reno registered
[    0.808283] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    0.808283] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    0.809689] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    0.809689] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    0.812067] NET: Registered protocol family 1
[    0.812067] NET: Registered protocol family 1
[    0.813106] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.813106] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.814580] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.814580] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.816239] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.816239] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.817700] pci 0000:00:02.0: Boot video device
[    0.817700] pci 0000:00:02.0: Boot video device
[    0.819229] PCI: CLS 0 bytes, default 64
[    0.819229] PCI: CLS 0 bytes, default 64
[    0.820963] Unpacking initramfs...
[    0.820963] Unpacking initramfs...
[    0.824047] Initramfs unpacking failed: junk in compressed archive
[    0.824047] Initramfs unpacking failed: junk in compressed archive

BUG: kernel boot hang
Elapsed time: 610
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
1-02202022/bcf1647d0899666f0fb90d176abf63bae22abb7c/vmlinuz-3.13.0-10237-gb=
cf1647 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchdog=
=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dno=
rmal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfi=
g-c1-02202022/next:master:bcf1647d0899666f0fb90d176abf63bae22abb7c:bisect-u=
sb/.vmlinuz-bcf1647d0899666f0fb90d176abf63bae22abb7c-20140222192759-1277-in=
n branch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-c1-02202022/bcf=
1647d0899666f0fb90d176abf63bae22abb7c/vmlinuz-3.13.0-10237-gbcf1647'  -init=
rd /kernel-tests/initrd/quantal-core-i386.cgz -m 256 -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::12972-:22 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs=
/LABEL=3DKVM/disk0-quantal-inn-18,media=3Ddisk,if=3Dvirtio -drive file=3D/f=
s/LABEL=3DKVM/disk1-quantal-inn-18,media=3Ddisk,if=3Dvirtio -drive file=3D/=
fs/LABEL=3DKVM/disk2-quantal-inn-18,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/LABEL=3DKVM/disk3-quantal-inn-18,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/disk4-quantal-inn-18,media=3Ddisk,if=3Dvirtio -drive fil=
e=3D/fs/LABEL=3DKVM/disk5-quantal-inn-18,media=3Ddisk,if=3Dvirtio -pidfile =
/dev/shm/kboot/pid-quantal-inn-18 -serial file:/dev/shm/kboot/serial-quanta=
l-inn-18 -daemonize -display none -monitor null=20

--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.13.0-10237-gbcf1647"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.13.0 Kernel Configuration
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
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
CONFIG_IRQ_DOMAIN_DEBUG=y
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
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
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
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
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
CONFIG_HAVE_CLK=y
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
CONFIG_SECCOMP_FILTER=y
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
CONFIG_GCOV_FORMAT_3_4=y
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
# CONFIG_MODULE_SIG_ALL is not set

#
# Do not forget to sign required modules with scripts/sign-file
#
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
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
CONFIG_MEMTEST=y
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
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_APEI is not set
CONFIG_ACPI_EXTLOG=m
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
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
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

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
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
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
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=m
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_ENUM_BASIC is not set

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=m
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=m
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=m
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_LOG=m
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NF_TABLES is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
# CONFIG_IP_SET_HASH_IPPORTNET is not set
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
# CONFIG_IP_SET_LIST_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=m
# CONFIG_IP_NF_TARGET_REJECT is not set
CONFIG_IP_NF_TARGET_ULOG=y
# CONFIG_IP_NF_MANGLE is not set
CONFIG_IP_NF_RAW=m

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_IP6_NF_IPTABLES is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
# CONFIG_BRIDGE_EBT_802_3 is not set
CONFIG_BRIDGE_EBT_AMONG=m
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
# CONFIG_BRIDGE_EBT_STP is not set
# CONFIG_BRIDGE_EBT_VLAN is not set
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
# CONFIG_BRIDGE_EBT_MARK_T is not set
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_ULOG is not set
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=y
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=m
# CONFIG_IEEE802154 is not set
CONFIG_6LOWPAN_IPHC=m
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=m
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=m
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=m
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
# CONFIG_MAC80211_MLME_DEBUG is not set
CONFIG_MAC80211_STA_DEBUG=y
# CONFIG_MAC80211_HT_DEBUG is not set
CONFIG_MAC80211_IBSS_DEBUG=y
# CONFIG_MAC80211_PS_DEBUG is not set
CONFIG_MAC80211_TDLS_DEBUG=y
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_RFKILL_GPIO=m
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=m
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=m
# CONFIG_NFC_DIGITAL is not set
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=m
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_MEI_PHY=m
CONFIG_NFC_SIM=m
# CONFIG_NFC_PN544 is not set
CONFIG_NFC_MICROREAD=m
CONFIG_NFC_MICROREAD_MEI=m

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
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=m
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

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
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=m
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
# CONFIG_PARIDE_PT is not set
# CONFIG_PARIDE_PG is not set

#
# Parallel IDE protocol modules
#
# CONFIG_PARIDE_ATEN is not set
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_BPCK6=m
CONFIG_PARIDE_COMM=m
# CONFIG_PARIDE_DSTR is not set
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
# CONFIG_PARIDE_EPAT is not set
CONFIG_PARIDE_EPIA=m
# CONFIG_PARIDE_FRIQ is not set
CONFIG_PARIDE_FRPW=m
# CONFIG_PARIDE_KBIC is not set
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_CISS_DA=m
# CONFIG_CISS_SCSI_TAPE is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_NVME=m
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_ATMEL_PWM=m
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=m
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_PCH_PHUB=m
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
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
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_DELKIN=m
CONFIG_BLK_DEV_IDECD=m
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=m
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
CONFIG_BLK_DEV_ALI15X3=m
CONFIG_BLK_DEV_AMD74XX=m
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_CS5535=m
CONFIG_BLK_DEV_CS5536=y
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=m
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=y
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=m
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=m
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=m
CONFIG_BLK_DEV_SIS5513=m
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=y
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=m
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
# CONFIG_SCSI_OSD_ULD is not set
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
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=m
CONFIG_SATA_ACARD_AHCI=m
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=m
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_ISCSI_TARGET=m
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
# CONFIG_FIREWIRE_NET is not set
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=m
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_TCA6416=m
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
# CONFIG_KEYBOARD_SAMSUNG is not set
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_SH_KEYSC=m
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_CROS_EC=m
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=m
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_PIXCIR=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_W90X900 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_TPS6507X=m
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_BMA150=m
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_IDEAPAD_SLIDEBAR=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=m
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
# CONFIG_SERIAL_CLPS711X is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
# CONFIG_SERIAL_SH_SCI is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_ATMEL=m
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=m
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_EXYNOS=m
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m
CONFIG_SONYPI=m
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_MUX_PINCTRL is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=m
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=m
CONFIG_I2C_SH_MOBILE=m
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
CONFIG_I2C_RCAR=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_ACB=m
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=m
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_PINMUX=y
# CONFIG_PINCONF is not set
CONFIG_DEBUG_PINCTRL=y
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=m
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=m
CONFIG_GPIO_VX855=m
CONFIG_GPIO_LYNXPOINT=m

#
# I2C GPIO expanders:
#
CONFIG_GPIO_LP3943=m
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

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

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=m
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_I5K_AMB=m
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_HTU21=m
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_RCAR_THERMAL=m
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=y
CONFIG_ACPI_INT3403_THERMAL=m

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DW_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=y
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=m
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_CROS_EC=m
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=m
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=m
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=m
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_ABX500_CORE=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=m
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS65912 is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
CONFIG_MFD_TIMBERDALE=m
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=m
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PCF50633=m
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_TPS65217 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=m
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=m
CONFIG_AGP_AMD=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_NVIDIA=m
CONFIG_AGP_SIS=m
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
CONFIG_AGP_EFFICEON=m
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_I810=m
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
# CONFIG_DRM_BOCHS is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=m
CONFIG_FB_CYBER2000_DDC=y
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=m
# CONFIG_FB_I810 is not set
CONFIG_FB_LE80578=m
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
# CONFIG_FB_INTEL_I2C is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=m
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=m
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
# CONFIG_FB_GEODE_GX is not set
# CONFIG_FB_GEODE_GX1 is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_ATMEL_PWM=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_PCF50633=m
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=m
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_GPIO=m
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=m
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
# CONFIG_SND_PCI is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
CONFIG_SND_DICE=m
CONFIG_SND_FIREWIRE_SPEAKERS=m
CONFIG_SND_ISIGHT=m
# CONFIG_SND_SCS1X is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_OSS=m
# CONFIG_SOUND_TRACEINIT is not set
CONFIG_SOUND_DMAP=y
# CONFIG_SOUND_VMIDI is not set
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=m
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
# CONFIG_SOUND_PSS is not set
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
CONFIG_SOUND_AEDSP16=m
CONFIG_SC6600=y
CONFIG_SC6600_JOY=y
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
CONFIG_SOUND_KAHLUA=m

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=m
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=m
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=m

#
# I2C HID support
#
CONFIG_I2C_HID=m
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
# CONFIG_KEYSTONE_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=m
# CONFIG_UWB_WHCI is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_SDHCI_PXAV3=y
CONFIG_MMC_SDHCI_PXAV2=y
# CONFIG_MMC_OMAP_HS is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_CB710=m
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_REALTEK_PCI=m
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
# CONFIG_MEMSTICK_R592 is not set
CONFIG_MEMSTICK_REALTEK_PCI=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_ATMEL_PWM=m
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_PWM=m
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_DELL_NETBOOKS=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=m
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_ACCESSIBILITY=y
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
CONFIG_INFINIBAND_ISER=m
CONFIG_INFINIBAND_ISERT=m
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD76X=m
CONFIG_EDAC_E7XXX=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82875P=m
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=m
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I7CORE=m
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
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
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=m
CONFIG_ASUS_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_AIO=m
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WIRELESS=m
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_COMPAL_LAPTOP=m
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
CONFIG_INTEL_MENLOW=y
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_ACPI_CMPC=m
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
CONFIG_XO15_EBOOK=m
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=m
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=m
CONFIG_PVPANIC=m
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=m
CONFIG_CHROMEOS_PSTORE=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_SI5351 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_INTEL_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=m
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=m
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LP3943 is not set
# CONFIG_PWM_RENESAS_TPU is not set
CONFIG_IPACK_BUS=m
CONFIG_BOARD_TPCI200=m
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=m
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=m
# CONFIG_EFI_VARS_PSTORE is not set
# CONFIG_EFI_RUNTIME_MAP is not set
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_LOGFS=m
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
CONFIG_SQUASHFS_DECOMP_MULTI=y
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_F2FS_FS=m
# CONFIG_F2FS_STAT_FS is not set
# CONFIG_F2FS_FS_XATTR is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_EFIVAR_FS=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

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
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
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
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
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
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DMA_API_DEBUG=y
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_EFI=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SELINUX is not set
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_INTEGRITY_AUDIT=y
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=y

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
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_GEODE is not set
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

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
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--32u276st3Jlj2kUU--
