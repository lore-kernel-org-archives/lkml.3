Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3COJWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:22:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3COJWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:22:08 -0400
Message-ID: <5142E839.9020101@yahoo.co.uk>
Date: Fri, 15 Mar 2013 09:22:01 +0000
From: Sam Tygier <samtygier@yahoo.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130122 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: pointer dereference on remove gma500_gfx module 3.8.2
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:oOzEOg68g6j8vEje6ETHIdG7aQ3itW1gsaM9c94fdT/
 FGaNENXKC+og0VrUom+sycqd2u8loKXm5ezbuT0n/va+jsUpZw
 84bMTPZ2Js0cbrb+EVGLA/UNT0Xg3Aa0OwlmgJU4mTT88fTQN6
 iQtJTXhH1NCnYqvUH3I+IYg4NaSz1LtYFoV0bfywBqjTikWHGA
 NJCnLBRH+wSx0Nk/B+AxPr53E0DkcWj8Mj8BTF4QDwVdbpZXdJ
 3rnsZT5W+0gyZeMersAf2v2bAy7p0ybyAM/Gdjiu205qaoOhV3
 Qksl6LFE45ZqJ0GUaap25TCX1iXzIVXZB6eWb+dC3HZdXhEFQ=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On debian 3.8-trunk-amd64 3.8.2-1~experimental.1 on Atom D2550 board Jetway NF9I-2550. When I run
modprobe -r gma500_gfx
i get the following oops.

[  117.598660] BUG: unable to handle kernel NULL pointer dereference at 00000000000003a8
[  117.606591] IP: [<ffffffff813805a6>] mutex_lock+0x10/0x2d
[  117.612052] PGD 0 
[  117.614126] Oops: 0002 [#1] SMP 
[  117.617453] Modules linked in: nfsd auth_rpcgss nfs_acl nfs lockd dns_resolver fscache sunrpc nls_utf8 nls_cp437 vfat fat lm78 hwmon_vid loop iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek snd_hda_codec_hdmi evdev mperf coretemp ir_lirc_codec lirc_dev ir_mce_kbd_decoder pcspkr psmouse serio_raw i2c_i801 ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder lpc_ich mfd_core snd_hda_intel snd_hda_codec snd_hwdep snd_pcm ir_nec_decoder snd_page_alloc snd_timer snd soundcore parport_pc parport rc_rc6_mce fintek_cir rc_core gma500_gfx(-) video drm_kms_helper drm i2c_algo_bit i2c_core button processor ext4 crc16 jbd2 mbcache btrfs zlib_deflate crc32c libcrc32c sg sd_mod crc_t10dif ahci libahci microcode libata scsi_mod e1000e thermal thermal_sys ehci_pci uhci_hcd ehci_hcd usbcore usb_common
[  117.692524] CPU 2 
[  117.694388] Pid: 3013, comm: modprobe Not tainted 3.8-trunk-amd64 #1 Debian 3.8.2-1~experimental.1    / 
[  117.704088] RIP: 0010:[<ffffffff813805a6>]  [<ffffffff813805a6>] mutex_lock+0x10/0x2d
[  117.711970] RSP: 0018:ffff8802144fbd48  EFLAGS: 00010246
[  117.717305] RAX: 0000000000000000 RBX: 00000000000003a8 RCX: 0000000000000078
[  117.724461] RDX: 0000000000000000 RSI: ffff880216b6bcd0 RDI: 00000000000003a8
[  117.731616] RBP: 0000000000000000 R08: ffff880213ed4e01 R09: 000000000000000e
[  117.738771] R10: 0000000000000000 R11: 0000000000000009 R12: ffff880216b6bcd0
[  117.745924] R13: ffff880216592000 R14: ffff880213f4d820 R15: 0000000000000000
[  117.753080] FS:  00007f0292aad700(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
[  117.761196] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  117.766966] CR2: 00000000000003a8 CR3: 00000002159dd000 CR4: 00000000000007e0
[  117.774123] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  117.781278] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  117.788436] Process modprobe (pid: 3013, threadinfo ffff8802144fa000, task ffff8802140e7040)
[  117.796900] Stack:
[  117.798944]  ffff880216592000 0000000000000286 00000000000003a8 ffffffffa023fc56
[  117.806530]  0000000000000000 ffff880216b6bcb0 0000000000000000 ffffffffa02400cd
[  117.814109]  0000000000000009 ffff880213f4d800 ffff880216b6bc00 ffffffffa02a6217
[  117.821700] Call Trace:
[  117.824207]  [<ffffffffa023fc56>] ? drm_mode_object_put.isra.3+0x19/0x35 [drm]
[  117.831478]  [<ffffffffa02400cd>] ? drm_framebuffer_cleanup+0x15/0x28 [drm]
[  117.838477]  [<ffffffffa02a6217>] ? psb_modeset_cleanup+0x8b/0xd8 [gma500_gfx]
[  117.845751]  [<ffffffffa02a9d5a>] ? psb_driver_unload+0x32/0x15a [gma500_gfx]
[  117.852927]  [<ffffffffa023b356>] ? drm_put_dev+0xd2/0x1c2 [drm]
[  117.858964]  [<ffffffff811e3890>] ? pci_device_remove+0x38/0x83
[  117.864915]  [<ffffffff81279f60>] ? __device_release_driver+0x7f/0xd5
[  117.871383]  [<ffffffff8127a6c1>] ? driver_detach+0x70/0x9b
[  117.876982]  [<ffffffff81279e2a>] ? bus_remove_driver+0x68/0xaa
[  117.882933]  [<ffffffff811e35ce>] ? pci_unregister_driver+0x17/0x78
[  117.889243]  [<ffffffffa023cb0c>] ? drm_pci_exit+0x3b/0x72 [drm]
[  117.895282]  [<ffffffff81082b77>] ? sys_delete_module+0x1ca/0x24e
[  117.901404]  [<ffffffff81061412>] ? should_resched+0x5/0x23
[  117.907002]  [<ffffffff81054fdf>] ? task_work_run+0x80/0x91
[  117.912600]  [<ffffffff81054ef5>] ? task_work_add+0x41/0x4d
[  117.918202]  [<ffffffff813872a2>] ? int_signal+0x12/0x17
[  117.923543]  [<ffffffff81386fe9>] ? system_call_fastpath+0x16/0x1b
[  117.929747] Code: 83 c4 50 5b 5d 41 5c c3 48 c7 47 18 00 00 00 00 f0 ff 07 7f 05 e8 20 02 00 00 c3 53 48 89 fb 48 83 ec 10 e8 49 0c 00 00 48 89 df <f0> ff 0f 79 05 e8 35 02 00 00 65 48 8b 04 25 80 c7 00 00 48 89 
[  117.951144] RIP  [<ffffffff813805a6>] mutex_lock+0x10/0x2d
[  117.956695]  RSP <ffff8802144fbd48>
[  117.960213] CR2: 00000000000003a8
[  117.963611] ---[ end trace 73b215e9c7722359 ]---

rest of dmesg at end.

I have no monitor attached. I can reproduce this.

Thanks,
Sam
Please CC replies

============
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8-trunk-amd64 (debian-kernel@lists.debian.org) (gcc version 4.7.2 (Debian 4.7.2-5) ) #1 SMP Debian 3.8.2-1~experimental.1
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8-trunk-amd64 root=UUID=6b50a003-7b71-4579-86a4-43badfa0bc00 ro quiet console=ttyS0,115200n8 console=tty0
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000df1edfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000df1ee000-0x00000000df233fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000df234000-0x00000000df25bfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000df25c000-0x00000000df25cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000df25d000-0x00000000df270fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000df271000-0x00000000df276fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000df277000-0x00000000df27efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000df27f000-0x00000000df286fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000df287000-0x00000000df2affff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000df2b0000-0x00000000df2f2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000df2f3000-0x00000000df58afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000df58b000-0x00000000df6e5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000df6e6000-0x00000000df6effff] usable
[    0.000000] BIOS-e820: [mem 0x00000000df6f0000-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI:    / , BIOS 4.6.5 12/11/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x220000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FE0000000 write-back
[    0.000000]   2 base 0DF6F0000 mask FFFFF0000 uncachable
[    0.000000]   3 base 0DF700000 mask FFFF00000 write-through
[    0.000000]   4 base 0DF800000 mask FFF800000 uncachable
[    0.000000]   5 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xdf6f0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd600-0x000fd60f] mapped at [ffff8800000fd600]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xdf6effff]
[    0.000000]  [mem 0x00000000-0xdf5fffff] page 2M
[    0.000000]  [mem 0xdf600000-0xdf6effff] page 4k
[    0.000000] kernel direct mapping tables up to 0xdf6effff @ [mem 0x1fffa000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x21fffffff]
[    0.000000]  [mem 0x100000000-0x21fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x21fffffff @ [mem 0xdf6ea000-0xdf6effff]
[    0.000000] RAMDISK: [mem 0x36a7c000-0x37535fff]
[    0.000000] ACPI: RSDP 00000000000f0490 00024 (v02      _)
[    0.000000] ACPI: XSDT 00000000df277060 00044 (v01      _        _ 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000df27e508 000F4 (v04      _        _ 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000df277138 073C9 (v02      _        _ 00000A01 INTL 20051117)
[    0.000000] ACPI: FACS 00000000df284f80 00040
[    0.000000] ACPI: APIC 00000000df27e600 00072 (v03      _        _ 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000df27e678 0003C (v01 A M I  ITL 945. 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000df27e6b8 00038 (v01 A M I  ICH7HPET 01072009 AMI. 00000005)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21fffffff]
[    0.000000]   NODE_DATA [mem 0x21fffc000-0x21fffffff]
[    0.000000]  [ffffea0000000000-ffffea00077fffff] PMD -> [ffff880217600000-ffff88021e7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xdf1edfff]
[    0.000000]   node   0: [mem 0xdf2f3000-0xdf58afff]
[    0.000000]   node   0: [mem 0xdf6e6000-0xdf6effff]
[    0.000000]   node   0: [mem 0x100000000-0x21fffffff]
[    0.000000] On node 0 totalpages: 2094110
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3920 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12448 pages used for memmap
[    0.000000]   DMA32 zone: 898032 pages, LIFO batch:31
[    0.000000]   Normal zone: 16128 pages used for memmap
[    0.000000]   Normal zone: 1163520 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df1ee000 - 00000000df234000
[    0.000000] PM: Registered nosave memory: 00000000df234000 - 00000000df25c000
[    0.000000] PM: Registered nosave memory: 00000000df25c000 - 00000000df25d000
[    0.000000] PM: Registered nosave memory: 00000000df25d000 - 00000000df271000
[    0.000000] PM: Registered nosave memory: 00000000df271000 - 00000000df277000
[    0.000000] PM: Registered nosave memory: 00000000df277000 - 00000000df27f000
[    0.000000] PM: Registered nosave memory: 00000000df27f000 - 00000000df287000
[    0.000000] PM: Registered nosave memory: 00000000df287000 - 00000000df2b0000
[    0.000000] PM: Registered nosave memory: 00000000df2b0000 - 00000000df2f3000
[    0.000000] PM: Registered nosave memory: 00000000df58b000 - 00000000df6e6000
[    0.000000] PM: Registered nosave memory: 00000000df6f0000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] e820: [mem 0xe0000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88021fc00000 s84032 r8192 d22464 u524288
[    0.000000] pcpu-alloc: s84032 r8192 d22464 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065472
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8-trunk-amd64 root=UUID=6b50a003-7b71-4579-86a4-43badfa0bc00 ro quiet console=ttyS0,115200n8 console=tty0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8173632k/8912896k available (3626k kernel code, 536456k absent, 202808k reserved, 3112k data, 616k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 1862.325 MHz processor
[    0.000005] Calibrating delay loop (skipped), value calculated using timer frequency.. 3724.65 BogoMIPS (lpj=7449300)
[    0.000013] pid_max: default: 32768 minimum: 301
[    0.000121] Security Framework initialized
[    0.000129] AppArmor: AppArmor disabled by boot time parameter
[    0.001721] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.008582] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.011689] Mount-cache hash table entries: 256
[    0.012156] Initializing cgroup subsys cpuacct
[    0.012164] Initializing cgroup subsys memory
[    0.012201] Initializing cgroup subsys devices
[    0.012206] Initializing cgroup subsys freezer
[    0.012211] Initializing cgroup subsys net_cls
[    0.012216] Initializing cgroup subsys blkio
[    0.012220] Initializing cgroup subsys perf_event
[    0.012282] Disabled fast string operations
[    0.012291] CPU: Physical Processor ID: 0
[    0.012294] CPU: Processor Core ID: 0
[    0.012298] mce: CPU supports 5 MCE banks
[    0.012314] CPU0: Thermal monitoring enabled (TM2)
[    0.012322] process: using mwait in idle threads
[    0.012334] Last level iTLB entries: 4KB 32, 2MB 0, 4MB 0
[    0.012334] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 8
[    0.012334] tlb_flushall_shift: 6
[    0.012470] Freeing SMP alternatives: 12k freed
[    0.013078] ACPI: Core revision 20121018
[    0.024006] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.063636] smpboot: CPU0: Intel(R) Atom(TM) CPU D2550   @ 1.86GHz (fam: 06, model: 36, stepping: 01)
[    0.170355] Performance Events: PEBS fmt0+, 8-deep LBR, Atom events, Intel PMU driver.
[    0.170368] ... version:                3
[    0.170372] ... bit width:              40
[    0.170375] ... generic registers:      2
[    0.170378] ... value mask:             000000ffffffffff
[    0.170381] ... max period:             000000007fffffff
[    0.170384] ... fixed-purpose events:   3
[    0.170388] ... event mask:             0000000700000003
[    0.182241] Disabled fast string operations
[    0.184926] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.196254] Disabled fast string operations
[    0.171305] smpboot: Booting Node   0, Processors  #1 #2 #3 OK
[    0.209655] Disabled fast string operations
[    0.211770] Brought up 4 CPUs
[    0.211781] smpboot: Total of 4 processors activated (14898.60 BogoMIPS)
[    0.213158] devtmpfs: initialized
[    0.220899] PM: Registering ACPI NVS region [mem 0xdf1ee000-0xdf233fff] (286720 bytes)
[    0.220933] PM: Registering ACPI NVS region [mem 0xdf25c000-0xdf25cfff] (4096 bytes)
[    0.220938] PM: Registering ACPI NVS region [mem 0xdf271000-0xdf276fff] (24576 bytes)
[    0.220945] PM: Registering ACPI NVS region [mem 0xdf27f000-0xdf286fff] (32768 bytes)
[    0.220955] PM: Registering ACPI NVS region [mem 0xdf2b0000-0xdf2f2fff] (274432 bytes)
[    0.221328] regulator-dummy: no parameters
[    0.221511] NET: Registered protocol family 16
[    0.221931] ACPI: bus type pci registered
[    0.222089] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.222097] PCI: not using MMCONFIG
[    0.222101] PCI: Using configuration type 1 for base access
[    0.224744] bio: create slab <bio-0> at 0
[    0.225009] ACPI: Added _OSI(Module Device)
[    0.225015] ACPI: Added _OSI(Processor Device)
[    0.225020] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.225025] ACPI: Added _OSI(Processor Aggregator Device)
[    0.227702] ACPI: EC: Look up EC in DSDT
[    0.230915] ACPI: Executed 1 blocks of module-level executable AML code
[    0.238327] ACPI: Interpreter enabled
[    0.238338] ACPI: (supports S0 S3 S4 S5)
[    0.238390] ACPI: Using IOAPIC for interrupt routing
[    0.238456] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.238573] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.301353] ACPI: No dock devices found.
[    0.301366] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.302252] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.302260] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.303124] pci_root PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.303700] pci_root PNP0A08:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0d
[    0.305008] PCI host bridge to bus 0000:00
[    0.305016] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.305023] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.305030] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.305036] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.305042] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.305048] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.305054] pci_bus 0000:00: root bus resource [mem 0xdf800000-0xdfffffff]
[    0.305060] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.305066] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
[    0.305087] pci 0000:00:00.0: [8086:0bf3] type 00 class 0x060000
[    0.305157] pci 0000:00:02.0: [8086:0be2] type 00 class 0x030000
[    0.305174] pci 0000:00:02.0: reg 10: [mem 0xfe900000-0xfe9fffff]
[    0.305184] pci 0000:00:02.0: reg 14: [io  0xf120-0xf127]
[    0.305287] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.305347] pci 0000:00:1a.0: reg 20: [io  0xf0c0-0xf0df]
[    0.305429] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    0.305489] pci 0000:00:1a.1: reg 20: [io  0xf0a0-0xf0bf]
[    0.305571] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.305630] pci 0000:00:1a.2: reg 20: [io  0xf080-0xf09f]
[    0.305724] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.305756] pci 0000:00:1a.7: reg 10: [mem 0xfeb06000-0xfeb063ff]
[    0.305879] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.305926] pci 0000:00:1b.0: [8086:3a3e] type 00 class 0x040300
[    0.305951] pci 0000:00:1b.0: reg 10: [mem 0xfeb00000-0xfeb03fff 64bit]
[    0.306047] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.306091] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.306196] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.306245] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    0.306345] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.306392] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.306452] pci 0000:00:1d.0: reg 20: [io  0xf060-0xf07f]
[    0.306535] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.306594] pci 0000:00:1d.1: reg 20: [io  0xf040-0xf05f]
[    0.306676] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.306736] pci 0000:00:1d.2: reg 20: [io  0xf020-0xf03f]
[    0.306834] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.306865] pci 0000:00:1d.7: reg 10: [mem 0xfeb05000-0xfeb053ff]
[    0.306988] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.307028] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.307127] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    0.307234] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0280 (mask 00ff)
[    0.307242] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 04e0 (mask 001f)
[    0.307320] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    0.307349] pci 0000:00:1f.2: reg 10: [io  0xf110-0xf117]
[    0.307363] pci 0000:00:1f.2: reg 14: [io  0xf100-0xf103]
[    0.307377] pci 0000:00:1f.2: reg 18: [io  0xf0f0-0xf0f7]
[    0.307391] pci 0000:00:1f.2: reg 1c: [io  0xf0e0-0xf0e3]
[    0.307405] pci 0000:00:1f.2: reg 20: [io  0xf000-0xf01f]
[    0.307419] pci 0000:00:1f.2: reg 24: [mem 0xfeb04000-0xfeb047ff]
[    0.307487] pci 0000:00:1f.2: PME# supported from D3hot
[    0.307524] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.307548] pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff 64bit]
[    0.307579] pci 0000:00:1f.3: reg 20: [io  0x1180-0x119f]
[    0.307678] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.307787] pci 0000:02:00.0: [8086:10d3] type 00 class 0x020000
[    0.307819] pci 0000:02:00.0: reg 10: [mem 0xfea00000-0xfea1ffff]
[    0.307861] pci 0000:02:00.0: reg 18: [io  0xe000-0xe01f]
[    0.307884] pci 0000:02:00.0: reg 1c: [mem 0xfea20000-0xfea23fff]
[    0.308051] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.316185] pci 0000:00:1c.4: PCI bridge to [bus 02]
[    0.316193] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.316202] pci 0000:00:1c.4:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.316297] pci 0000:00:1e.0: PCI bridge to [bus 03] (subtractive decode)
[    0.316314] pci 0000:00:1e.0:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.316320] pci 0000:00:1e.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.316326] pci 0000:00:1e.0:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.316332] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.316338] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.316345] pci 0000:00:1e.0:   bridge window [mem 0xdf800000-0xdfffffff] (subtractive decode)
[    0.316351] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.316357] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.316402] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.316672] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.316787] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.316917] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.334200] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.334343] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.334484] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.334620] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.334756] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.334893] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.335030] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.335167] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.335452] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.335463] vgaarb: loaded
[    0.335467] vgaarb: bridge control possible 0000:00:02.0
[    0.335613] PCI: Using ACPI for IRQ routing
[    0.343911] PCI: pci_cache_line_size set to 64 bytes
[    0.344004] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
[    0.344011] e820: reserve RAM buffer [mem 0xdf1ee000-0xdfffffff]
[    0.344017] e820: reserve RAM buffer [mem 0xdf58b000-0xdfffffff]
[    0.344022] e820: reserve RAM buffer [mem 0xdf6f0000-0xdfffffff]
[    0.344364] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.344375] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.346394] Switching to clocksource hpet
[    0.352166] pnp: PnP ACPI init
[    0.352208] ACPI: bus type pnp registered
[    0.352477] system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
[    0.352487] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.353077] system 00:01: [io  0x0a00-0x0a1f] has been reserved
[    0.353085] system 00:01: [io  0x0a30-0x0a3f] has been reserved
[    0.353093] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.353266] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.353459] pnp 00:03: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    0.354530] pnp 00:04: [dma 3]
[    0.354606] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.355342] pnp 00:05: [dma 0 disabled]
[    0.355416] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.356140] pnp 00:06: [dma 0 disabled]
[    0.356209] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.356955] pnp 00:07: [dma 0 disabled]
[    0.357072] pnp 00:07: Plug and Play ACPI device, IDs FIT0002 (active)
[    0.357111] pnp 00:08: [dma 4]
[    0.357183] pnp 00:08: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.357287] pnp 00:09: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.357376] pnp 00:0a: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.357565] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.357575] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.357675] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.357856] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.359486] system 00:0e: [io  0x0400-0x047f] has been reserved
[    0.359496] system 00:0e: [io  0x1180-0x119f] has been reserved
[    0.359503] system 00:0e: [io  0x0500-0x057f] has been reserved
[    0.359511] system 00:0e: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.359519] system 00:0e: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.359526] system 00:0e: [mem 0xff000000-0xffffffff] has been reserved
[    0.359535] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.359808] pnp 00:0f: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.360261] pnp: PnP ACPI: found 16 devices
[    0.360266] ACPI: ACPI bus type pnp unregistered
[    0.371532] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    0.371543] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
[    0.371550] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 01] add_size 200000
[    0.371567] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.371604] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.371611] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.371618] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.371625] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.371638] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf0000000-0xf01fffff]
[    0.371648] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.371658] pci 0000:00:1c.4: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.371667] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.371677] pci 0000:00:1f.3: BAR 0: assigned [mem 0xf0600000-0xf06000ff 64bit]
[    0.371697] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.371704] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.371713] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff]
[    0.371722] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.371733] pci 0000:00:1c.4: PCI bridge to [bus 02]
[    0.371739] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.371749] pci 0000:00:1c.4:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.371757] pci 0000:00:1c.4:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.371768] pci 0000:00:1e.0: PCI bridge to [bus 03]
[    0.371829] pci 0000:00:1e.0: setting latency timer to 64
[    0.371838] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.371844] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.371850] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.371855] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.371861] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.371867] pci_bus 0000:00: resource 9 [mem 0xdf800000-0xdfffffff]
[    0.371873] pci_bus 0000:00: resource 10 [mem 0x000c0000-0x000dffff]
[    0.371878] pci_bus 0000:00: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.371884] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.371890] pci_bus 0000:01: resource 1 [mem 0xf0000000-0xf01fffff]
[    0.371896] pci_bus 0000:01: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
[    0.371902] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.371908] pci_bus 0000:02: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.371914] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.371920] pci_bus 0000:03: resource 4 [io  0x0000-0x03af]
[    0.371926] pci_bus 0000:03: resource 5 [io  0x03e0-0x0cf7]
[    0.371931] pci_bus 0000:03: resource 6 [io  0x03b0-0x03df]
[    0.371937] pci_bus 0000:03: resource 7 [io  0x0d00-0xffff]
[    0.371942] pci_bus 0000:03: resource 8 [mem 0x000a0000-0x000bffff]
[    0.371948] pci_bus 0000:03: resource 9 [mem 0xdf800000-0xdfffffff]
[    0.371954] pci_bus 0000:03: resource 10 [mem 0x000c0000-0x000dffff]
[    0.371960] pci_bus 0000:03: resource 11 [mem 0xf0000000-0xfebfffff]
[    0.372110] NET: Registered protocol family 2
[    0.372742] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.373636] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.374373] TCP: Hash tables configured (established 65536 bind 65536)
[    0.374614] TCP: reno registered
[    0.374660] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.374792] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.375135] NET: Registered protocol family 1
[    0.375176] pci 0000:00:02.0: Boot video device
[    1.971829] pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    3.569255] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    3.569398] PCI: CLS 64 bytes, default 64
[    3.569512] Unpacking initramfs...
[    4.070932] Freeing initrd memory: 10984k freed
[    4.080129] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.080144] software IO TLB [mem 0xdb1ee000-0xdf1ee000] (64MB) mapped at [ffff8800db1ee000-ffff8800df1edfff]
[    4.081245] audit: initializing netlink socket (disabled)
[    4.081278] type=2000 audit(1363338999.980:1): initialized
[    4.109550] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.111048] VFS: Disk quotas dquot_6.5.2
[    4.111111] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.111332] msgmni has been set to 15985
[    4.111893] alg: No test for stdrng (krng)
[    4.111997] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    4.112080] io scheduler noop registered
[    4.112085] io scheduler deadline registered
[    4.112129] io scheduler cfq registered (default)
[    4.112426] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    4.112712] pcieport 0000:00:1c.4: irq 41 for MSI/MSI-X
[    4.112902] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.112955] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.112959] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    4.113720] intel_idle: does not run on family 6 model 54
[    4.113771] GHES: HEST is not enabled!
[    4.113938] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.134517] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.155153] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.156192] Linux agpgart interface v0.103
[    4.156616] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    4.157106] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.157123] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.157511] mousedev: PS/2 mouse device common for all mice
[    4.157597] rtc_cmos 00:09: RTC can wake from S4
[    4.157857] rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
[    4.157903] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.157930] cpuidle: using governor ladder
[    4.157934] cpuidle: using governor menu
[    4.158033] drop_monitor: Initializing network drop monitor service
[    4.158191] TCP: cubic registered
[    4.158295] NET: Registered protocol family 10
[    4.158755] mip6: Mobile IPv6
[    4.158761] NET: Registered protocol family 17
[    4.159538] PM: Hibernation image not present or could not be loaded.
[    4.159571] registered taskstats version 1
[    4.161194] rtc_cmos 00:09: setting system clock to 2013-03-15 09:16:40 UTC (1363339000)
[    4.164185] Freeing unused kernel memory: 616k freed
[    4.164508] Write protecting the kernel read-only data: 6144k
[    4.169436] Freeing unused kernel memory: 460k freed
[    4.175029] Freeing unused kernel memory: 520k freed
[    4.205520] udevd[68]: starting version 175
[    4.269013] ACPI: bus type usb registered
[    4.269154] usbcore: registered new interface driver usbfs
[    4.269223] usbcore: registered new interface driver hub
[    4.269433] usbcore: registered new device driver usb
[    4.276297] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.277415] uhci_hcd: USB Universal Host Controller Interface driver
[    4.277541] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.277553] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.277576] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.277678] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0c0
[    4.277830] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.277839] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.277848] usb usb1: Product: UHCI Host Controller
[    4.277856] usb usb1: Manufacturer: Linux 3.8-trunk-amd64 uhci_hcd
[    4.277863] usb usb1: SerialNumber: 0000:00:1a.0
[    4.278347] hub 1-0:1.0: USB hub found
[    4.278369] hub 1-0:1.0: 2 ports detected
[    4.278733] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.278746] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.278769] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.278875] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000f0a0
[    4.279032] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.279042] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.279050] usb usb2: Product: UHCI Host Controller
[    4.279058] usb usb2: Manufacturer: Linux 3.8-trunk-amd64 uhci_hcd
[    4.279066] usb usb2: SerialNumber: 0000:00:1a.1
[    4.279559] hub 2-0:1.0: USB hub found
[    4.279582] hub 2-0:1.0: 2 ports detected
[    4.279955] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.279967] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.279990] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    4.280145] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000f080
[    4.280294] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.280303] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.280311] usb usb3: Product: UHCI Host Controller
[    4.280318] usb usb3: Manufacturer: Linux 3.8-trunk-amd64 uhci_hcd
[    4.280325] usb usb3: SerialNumber: 0000:00:1a.2
[    4.280785] hub 3-0:1.0: USB hub found
[    4.280807] hub 3-0:1.0: 2 ports detected
[    4.281173] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.281188] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.281209] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    4.281315] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f060
[    4.281459] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.281469] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.281477] usb usb4: Product: UHCI Host Controller
[    4.281485] usb usb4: Manufacturer: Linux 3.8-trunk-amd64 uhci_hcd
[    4.281492] usb usb4: SerialNumber: 0000:00:1d.0
[    4.281941] hub 4-0:1.0: USB hub found
[    4.281959] hub 4-0:1.0: 2 ports detected
[    4.282307] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.282320] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.282339] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    4.282438] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f040
[    4.282571] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.282581] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.282588] usb usb5: Product: UHCI Host Controller
[    4.282595] usb usb5: Manufacturer: Linux 3.8-trunk-amd64 uhci_hcd
[    4.282602] usb usb5: SerialNumber: 0000:00:1d.1
[    4.283056] hub 5-0:1.0: USB hub found
[    4.283077] hub 5-0:1.0: 2 ports detected
[    4.283438] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.283449] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.283474] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    4.283543] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f020
[    4.283677] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.283686] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.283694] usb usb6: Product: UHCI Host Controller
[    4.283702] usb usb6: Manufacturer: Linux 3.8-trunk-amd64 uhci_hcd
[    4.283709] usb usb6: SerialNumber: 0000:00:1d.2
[    4.284229] hub 6-0:1.0: USB hub found
[    4.284253] hub 6-0:1.0: 2 ports detected
[    4.288310] ehci-pci: EHCI PCI platform driver
[    4.288433] ehci-pci 0000:00:1a.7: setting latency timer to 64
[    4.288444] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    4.288468] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 7
[    4.288511] ehci-pci 0000:00:1a.7: debug port 1
[    4.292467] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[    4.301036] ehci-pci 0000:00:1a.7: irq 18, io mem 0xfeb06000
[    4.312107] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.312201] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    4.312212] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.312219] usb usb7: Product: EHCI Host Controller
[    4.312227] usb usb7: Manufacturer: Linux 3.8-trunk-amd64 ehci_hcd
[    4.312234] usb usb7: SerialNumber: 0000:00:1a.7
[    4.312674] hub 7-0:1.0: USB hub found
[    4.312695] hub 7-0:1.0: 6 ports detected
[    4.313178] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    4.313187] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    4.313204] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    4.313233] ehci-pci 0000:00:1d.7: debug port 1
[    4.314467] thermal LNXTHERM:00: registered as thermal_zone0
[    4.314474] ACPI: Thermal Zone [THRM] (38 C)
[    4.317169] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    4.317659] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfeb05000
[    4.328522] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.328611] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    4.328621] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.328629] usb usb8: Product: EHCI Host Controller
[    4.328636] usb usb8: Manufacturer: Linux 3.8-trunk-amd64 ehci_hcd
[    4.328644] usb usb8: SerialNumber: 0000:00:1d.7
[    4.329124] hub 8-0:1.0: USB hub found
[    4.329147] hub 8-0:1.0: 6 ports detected
[    4.360208] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    4.360216] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    4.360289] e1000e 0000:02:00.0: Disabling ASPM L0s L1
[    4.360530] e1000e 0000:02:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.360678] e1000e 0000:02:00.0: irq 42 for MSI/MSI-X
[    4.360701] e1000e 0000:02:00.0: irq 43 for MSI/MSI-X
[    4.360722] e1000e 0000:02:00.0: irq 44 for MSI/MSI-X
[    4.373068] SCSI subsystem initialized
[    4.377994] microcode: CPU0 sig=0x30661, pf=0x4, revision=0x10d
[    4.378044] ACPI: bus type scsi registered
[    4.382773] libata version 3.00 loaded.
[    4.384962] ahci 0000:00:1f.2: version 3.0
[    4.385065] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    4.385230] ahci: SSS flag set, parallel bus scan disabled
[    4.385296] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    4.385305] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag led clo pmp pio slum part ccc ems sxs 
[    4.385313] ahci 0000:00:1f.2: setting latency timer to 64
[    4.427420] scsi0 : ahci
[    4.427836] scsi1 : ahci
[    4.428657] scsi2 : ahci
[    4.429080] scsi3 : ahci
[    4.429421] scsi4 : ahci
[    4.429735] scsi5 : ahci
[    4.429955] ata1: SATA max UDMA/133 abar m2048@0xfeb04000 port 0xfeb04100 irq 45
[    4.429965] ata2: SATA max UDMA/133 abar m2048@0xfeb04000 port 0xfeb04180 irq 45
[    4.429974] ata3: SATA max UDMA/133 abar m2048@0xfeb04000 port 0xfeb04200 irq 45
[    4.429983] ata4: SATA max UDMA/133 abar m2048@0xfeb04000 port 0xfeb04280 irq 45
[    4.429991] ata5: SATA max UDMA/133 abar m2048@0xfeb04000 port 0xfeb04300 irq 45
[    4.430002] ata6: SATA max UDMA/133 abar m2048@0xfeb04000 port 0xfeb04380 irq 45
[    4.438002] platform microcode: firmware: agent aborted loading intel-ucode/06-36-01 (not found?)
[    4.447047] microcode: CPU1 sig=0x30661, pf=0x4, revision=0x10d
[    4.453066] platform microcode: firmware: agent aborted loading intel-ucode/06-36-01 (not found?)
[    4.462100] microcode: CPU2 sig=0x30661, pf=0x4, revision=0x10d
[    4.467843] e1000e 0000:02:00.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:30:18:ab:1c:cf
[    4.467851] e1000e 0000:02:00.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.467949] e1000e 0000:02:00.0 eth0: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[    4.470081] platform microcode: firmware: agent aborted loading intel-ucode/06-36-01 (not found?)
[    4.479112] microcode: CPU3 sig=0x30661, pf=0x4, revision=0x10d
[    4.485397] platform microcode: firmware: agent aborted loading intel-ucode/06-36-01 (not found?)
[    4.494584] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.919099] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.964507] ata1.00: ATA-7: ST3500830AS, 3.AFD, max UDMA/133
[    4.964516] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    5.022714] ata1.00: configured for UDMA/133
[    5.023022] scsi 0:0:0:0: Direct-Access     ATA      ST3500830AS      3.AF PQ: 0 ANSI: 5
[    5.074898] tsc: Refined TSC clocksource calibration: 1862.209 MHz
[    5.074907] Switching to clocksource tsc
[    5.342406] ata2: SATA link down (SStatus 0 SControl 300)
[    5.833610] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.835141] ata3.00: ATA-9: WDC WD30EFRX-68AX9N0, 80.00A80, max UDMA/133
[    5.835147] ata3.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    5.835789] ata3.00: configured for UDMA/133
[    5.836041] scsi 2:0:0:0: Direct-Access     ATA      WDC WD30EFRX-68A 80.0 PQ: 0 ANSI: 5
[    6.153101] ata4: SATA link down (SStatus 0 SControl 300)
[    6.644306] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.648587] ata5.00: ATA-8: WDC WD30EZRX-00MMMB0, 80.00A80, max UDMA/133
[    6.648594] ata5.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    6.670388] ata5.00: configured for UDMA/133
[    6.670618] scsi 4:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00M 80.0 PQ: 0 ANSI: 5
[    7.159478] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.159907] ata6.00: ATA-9: M4-CT032M4SSD3, 04MH, max UDMA/100
[    7.159915] ata6.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.160361] ata6.00: configured for UDMA/100
[    7.160607] scsi 5:0:0:0: Direct-Access     ATA      M4-CT032M4SSD3   04MH PQ: 0 ANSI: 5
[    7.174616] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    7.174830] sd 2:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    7.174841] sd 4:0:0:0: [sdc] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    7.174843] sd 2:0:0:0: [sdb] 4096-byte physical blocks
[    7.174854] sd 4:0:0:0: [sdc] 4096-byte physical blocks
[    7.174862] sd 0:0:0:0: [sda] Write Protect is off
[    7.174872] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.174985] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.175043] sd 5:0:0:0: [sdd] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    7.175077] sd 4:0:0:0: [sdc] Write Protect is off
[    7.175087] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    7.175174] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.175399] sd 5:0:0:0: [sdd] Write Protect is off
[    7.175409] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    7.175557] sd 2:0:0:0: [sdb] Write Protect is off
[    7.175566] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.175727] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.175894] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.177765]  sdd: sdd1 sdd2
[    7.178628] sd 5:0:0:0: [sdd] Attached SCSI disk
[    7.191320]  sda: sda1
[    7.192147] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.226013]  sdc: sdc1 sdc2
[    7.226987] sd 4:0:0:0: [sdc] Attached SCSI disk
[    7.236961]  sdb: sdb1 sdb2
[    7.237908] sd 2:0:0:0: [sdb] Attached SCSI disk
[    7.243504] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.243694] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    7.243874] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    7.244060] sd 5:0:0:0: Attached scsi generic sg3 type 0
[    7.628907] Btrfs loaded
[    7.731977] device label bdata devid 1 transid 54742 /dev/sdc2
[    7.796359] device label bdata devid 3 transid 54742 /dev/sdb2
[    7.800172] PM: Starting manual resume from disk
[    7.800181] PM: Hibernation image partition 8:49 present
[    7.800184] PM: Looking for hibernation image.
[    7.800530] PM: Image not found (code -22)
[    7.800534] PM: Hibernation image not present or could not be loaded.
[    7.827670] EXT4-fs (sdd2): mounted filesystem with ordered data mode. Opts: (null)
[    8.189177] udevd[427]: starting version 175
[    8.314330] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    8.314351] ACPI: Power Button [PWRB]
[    8.314596] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    8.314608] ACPI: Power Button [PWRF]
[    8.342537] [drm] Initialized drm 1.1.0 20060810
[    8.358713] gma500 0000:00:02.0: setting latency timer to 64
[    8.359046] gma500 0000:00:02.0: irq 46 for MSI/MSI-X
[    8.359187] gma500 0000:00:02.0: GPU: power management timed out.
[    8.405158] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    8.405404] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    8.405538] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    8.405545] [drm] No driver support for vblank timestamp query.
[    8.367261] fintek_cir: first portsel read was bunk, trying alt
[    8.409672] Registered IR keymap rc-rc6-mce
[    8.409964] input: Fintek LPC SuperIO Consumer IR Transceiver as /devices/pnp0/00:07/rc/rc0/input3
[    8.409996] rc0: Fintek LPC SuperIO Consumer IR Transceiver as /devices/pnp0/00:07/rc/rc0
[    8.410158] fintek_cir: driver has been successfully loaded
[    8.410691] parport_pc 00:04: reported by Plug and Play ACPI
[    8.410760] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    8.415244] IR NEC protocol handler initialized
[    8.442810] IR RC5(x) protocol handler initialized
[    8.448101] IR RC6 protocol handler initialized
[    8.454664] IR JVC protocol handler initialized
[    8.461171] IR Sony protocol handler initialized
[    8.469040] IR SANYO protocol handler initialized
[    8.523563] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    8.527139] input: MCE IR Keyboard/Mouse (fintek-cir) as /devices/virtual/input/input5
[    8.527929] IR MCE Keyboard/mouse protocol handler initialized
[    8.530806] Error: Driver 'pcspkr' is already registered, aborting...
[    8.534279] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
[    8.534288] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
[    8.576302] lirc_dev: IR Remote Control driver registered, major 251 
[    8.578680] coretemp coretemp.0: Unable to read TjMax from CPU 0
[    8.578721] coretemp coretemp.0: Unable to read TjMax from CPU 2
[    8.584911] rc rc0: lirc_dev: driver ir-lirc-codec (fintek-cir) registered at minor = 0
[    8.584922] IR LIRC bridge handler initialized
[    8.725541] device label bdata devid 3 transid 54742 /dev/sdb2
[    8.731368] device label bdata devid 1 transid 54742 /dev/sdc2
[    8.741057] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
[    8.741332] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[    8.768027] input: HDA Intel HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    8.769642] i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
[    8.769664] ACPI Warning: 0x0000000000001180-0x000000000000119f SystemIO conflicts with Region \_SB_.PCI0.SMB_.SMIO 1 (20121018/utaddress-251)
[    8.769681] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    8.778741] iTCO_vendor_support: vendor-support=0
[    8.779769] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    8.779854] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[    8.780172] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    9.385742] Adding 1951740k swap on /dev/sdd1.  Priority:-1 extents:1 across:1951740k SS
[    9.419435] EXT4-fs (sdd2): re-mounted. Opts: (null)
[    9.534771] EXT4-fs (sdd2): re-mounted. Opts: discard,errors=remount-ro
[    9.598625] loop: module loaded
[    9.681085] f71882fg: Found f71869a chip at 0x290, revision 32
[    9.681180] ACPI Warning: 0x0000000000000290-0x0000000000000297 SystemIO conflicts with Region \_TZ_.IP__ 1 (20121018/utaddress-251)
[    9.681199] ACPI Warning: 0x0000000000000290-0x0000000000000297 SystemIO conflicts with Region \_SB_.PCI0.SBRG.SIO1.RNTR 2 (20121018/utaddress-251)
[    9.681213] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.593802] FAT-fs (sda1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[   10.615477] device label bdata devid 1 transid 54742 /dev/sdc2
[   10.616444] btrfs: disk space caching is enabled
[   18.116260] RPC: Registered named UNIX socket transport module.
[   18.116269] RPC: Registered udp transport module.
[   18.116274] RPC: Registered tcp transport module.
[   18.116280] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   18.124294] FS-Cache: Loaded
[   18.125397] Key type dns_resolver registered
[   18.136375] FS-Cache: Netfs 'nfs' registered for caching
[   18.149910] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   18.716363] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   21.804925] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   21.805141] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  117.598660] BUG: unable to handle kernel NULL pointer dereference at 00000000000003a8
