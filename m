Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3JFIYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 04:24:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:31805 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab3JFIX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 04:23:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1043,1371106800"; 
   d="log'?scan'208";a="406038386"
Date: Sun, 6 Oct 2013 16:23:40 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: xen-devel@lists.xenproject.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131006082340.GA24568@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit cf39c8e5352b4fb9efedfe7e9acb566a85ed847c
Merge: 3398d25 23b7eaf
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Sep 4 17:45:39 2013 -0700

    Merge tag 'stable/for-linus-3.12-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
    
    Pull Xen updates from Konrad Rzeszutek Wilk:
     "A couple of features and a ton of bug-fixes.  There is also some
      maintership changes.  Jeremy is enjoying the full-time work at the
      startup and as much as he would love to help - he can't find the time.
      I have a bunch of other things that I promised to work on - paravirt
      diet, get SWIOTLB working everywhere, etc, but haven't been able to
      find the time.
    
      As such both David Vrabel and Boris Ostrovsky have graciously
      volunteered to help with the maintership role.  They will keep the lid
      on regressions, bug-fixes, etc.  I will be in the background to help -
      but eventually there will be less of me doing the Xen GIT pulls and
      more of them.  Stefano is still doing the ARM/ARM64 and will continue
      on doing so.
    
      Features:
       - Xen Trusted Platform Module (TPM) frontend driver - with the
         backend in MiniOS.
       - Scalability improvements in event channel.
       - Two extra Xen co-maintainers (David, Boris) and one going away (Jeremy)
    
      Bug-fixes:
       - Make the 1:1 mapping work during early bootup on selective regions.
       - Add scratch page to balloon driver to deal with unexpected code
         still holding on stale pages.
       - Allow NMIs on PV guests (64-bit only)
       - Remove unnecessary TLB flush in M2P code.
       - Fixes duplicate callbacks in Xen granttable code.
       - Fixes in PRIVCMD_MMAPBATCH ioctls to allow retries
       - Fix for events being lost due to rescheduling on different VCPUs.
       - More documentation"
    
    * tag 'stable/for-linus-3.12-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip: (23 commits)
      hvc_xen: Remove unnecessary __GFP_ZERO from kzalloc
      drivers/xen-tpmfront: Fix compile issue with missing option.
      xen/balloon: don't set P2M entry for auto translated guest
      xen/evtchn: double free on error
      Xen: Fix retry calls into PRIVCMD_MMAPBATCH*.
      xen/pvhvm: Initialize xen panic handler for PVHVM guests
      xen/m2p: use GNTTABOP_unmap_and_replace to reinstate the original mapping
      xen: fix ARM build after 6efa20e4
      MAINTAINERS: Remove Jeremy from the Xen subsystem.
      xen/events: document behaviour when scanning the start word for events
      x86/xen: during early setup, only 1:1 map the ISA region
      x86/xen: disable premption when enabling local irqs
      swiotlb-xen: replace dma_length with sg_dma_len() macro
      swiotlb: replace dma_length with sg_dma_len() macro
      xen/balloon: set a mapping for ballooned out pages
      xen/evtchn: improve scalability by using per-user locks
      xen/p2m: avoid unneccesary TLB flush in m2p_remove_override()
      MAINTAINERS: Add in two extra co-maintainers of the Xen tree.
      MAINTAINERS: Update the Xen subsystem's with proper mailing list.
      xen: replace strict_strtoul() with kstrtoul()
      ...


grep: /proc/filesystems: No such file or directory
Starting Bootlog daemon: 
[    4.136137] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    4.137521] CPU: 0 PID: 132 Comm: bootlogd Not tainted 3.12.0-rc2-00153-g14951f2 #129
[    4.139156] task: ffff88000c9a6580 ti: ffff88000c9ba000 task.ti: ffff88000c9ba000
[    4.140042] RIP: 0010:[<ffffffff81f31c7e>]  [<ffffffff81f31c7e>] boot_tvec_bases+0x1fe/0x2080
[    4.140042] RSP: 0018:0000000088000cd8  EFLAGS: 00010212
[    4.140042] RAX: 000000000000004f RBX: 0000000000000100 RCX: 0000000000000000
[    4.140042] RDX: 0000000000000f1e RSI: ffffffff81f746a8 RDI: ffffffff81f31c48
[    4.140042] RBP: ffff88000f003ee0 R08: 0000000000000000 R09: 0000000000000000
[    4.140042] R10: 0000000000000001 R11: ffff88000f00a000 R12: ffff88000c9bbfd8
[    4.140042] R13: ffffffff81f31c48 R14: ffffffff81f31c48 R15: ffffffff81f31c48
[    4.140042] FS:  00007fb1f9662700(0000) GS:ffff88000f000000(0000) knlGS:0000000000000000
[    4.140042] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.140042] CR2: 0000000088000cc8 CR3: 000000000c9cd000 CR4: 00000000000006b0
[    4.140042] Stack:
[    4.140042] BUG: unable to handle kernel paging request at 0000000088000cd8
[    4.140042] IP: [<ffffffff8102bf55>] show_stack_log_lvl+0xc3/0x137
[    4.140042] PGD c9e6067 PUD 0 
[    4.140042] Oops: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[    4.140042] CPU: 0 PID: 132 Comm: bootlogd Not tainted 3.12.0-rc2-00153-g14951f2 #129
[    4.140042] task: ffff88000c9a6580 ti: ffff88000c9ba000 task.ti: ffff88000c9ba000
[    4.140042] RIP: 0010:[<ffffffff8102bf55>]  [<ffffffff8102bf55>] show_stack_log_lvl+0xc3/0x137
[    4.140042] RSP: 0018:ffff88000f005e20  EFLAGS: 00010046
[    4.140042] RAX: ffff88000effffc0 RBX: 0000000000000000 RCX: 0000000000000000
[    4.140042] RDX: 000000000000ba18 RSI: ffff88000f005f58 RDI: 0000000000000001
[    4.140042] RBP: ffff88000f005e70 R08: ffffffff81b6a095 R09: 0000000000000000
[    4.140042] R10: ffffffff810bb62b R11: 0000000000000000 R12: 0000000000000000
[    4.140042] R13: ffff88000f003fc0 R14: 0000000088000cd8 R15: 0000000000000040
[    4.140042] FS:  00007fb1f9662700(0000) GS:ffff88000f000000(0000) knlGS:0000000000000000
[    4.140042] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.140042] CR2: 0000000088000cd8 CR3: 000000000c9cd000 CR4: 00000000000006b0
[    4.140042] Stack:
[    4.140042]  ffffffff81b6a095 0000000000000000 ffff88000f005f58 ffff88000effffc0
[    4.140042]  0000000088000cd8 ffff88000f005f58 0000000000000ac0 0000000088000cd8
[    4.140042]  0000000000000000 0000000000000040 ffff88000f005ec8 ffffffff8102c039
[    4.140042] Call Trace:
[    4.140042]  <#DF> 
[    4.140042]  [<ffffffff8102c039>] show_regs+0x70/0x1d8
[    4.140042]  [<ffffffff810aa597>] ? atomic_notifier_call_chain+0xf/0x11
[    4.140042]  [<ffffffff8102cf01>] __die+0xaa/0xe9
[    4.140042]  [<ffffffff8102cf82>] die+0x42/0x5e
[    4.140042]  [<ffffffff8102aadb>] do_double_fault+0x5f/0x61
[    4.140042]  [<ffffffff8185a39d>] double_fault+0x2d/0x40
[    4.140042]  <<EOE>> 
[    4.140042] Code: 4d 8b 76 f8 e8 e4 f9 81 00 eb 09 41 f7 c6 ff 1f 00 00 74 33 85 db 74 13 f6 c3 03 75 0e 48 c7 c7 12 4a b8 81 31 c0 e8 c2 f9 81 00 <49> 8b 36 4d 8d 7e 08 48 c7 c7 8d a0 b6 81 31 c0 ff c3 4d 89 fe 
[    4.140042] RIP  [<ffffffff8102bf55>] show_stack_log_lvl+0xc3/0x137
[    4.140042]  RSP <ffff88000f005e20>
[    4.140042] CR2: 0000000088000cd8
[    4.140042] ---[ end trace d11a7e59f46ac8e0 ]---

git bisect start 9b565a8051b389e046209a5f68c93eade8de58bd v3.11 --
git bisect  bad 57d730924d5cc2c3e280af16a9306587c3a511db  # 07:29    130-  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good a9238741987386bb549d61572973c7e62b2a4145  # 17:32   3555+  Merge tag 'pci-v3.12-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
git bisect  bad cf39c8e5352b4fb9efedfe7e9acb566a85ed847c  # 18:34    727-  Merge tag 'stable/for-linus-3.12-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
git bisect good 816434ec4a674fcdb3c2221a6dffdc8f34020550  # 05:43   5000+  Merge branch 'x86-spinlocks-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 43bcb402f84fe459102120b4e2d28d7117f16cd0  # 14:25   5000+  Merge remote-tracking branch 'asoc/topic/wm8994' into asoc-next
git bisect good b054087dbacee30a9dddaef2c9a96312146be04e  # 10:02   5000+  ALSA: hda - Re-setup HDMI pin and audio infoframe on stream switches
git bisect good 1cb95395870d68f9ff679db42fa15ea03201fc08  # 16:21   5000+  pinctrl: rockchip: Simplify for loop iteration
git bisect good ae67d9a888a000a9df43de10eb9950075e93508c  # 17:12   5000+  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
git bisect good 3398d252a4da80c47fe9b802184fa0a792387732  # 18:13   5000+  Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
git bisect good fb58e30091c74967f6b8e98b3c1f292782f92b41  # 19:10   5000+  x86/xen: disable premption when enabling local irqs
git bisect good 669b0ae961e87c824233475e987b2d39996d4849  # 23:09   5000+  xen/pvhvm: Initialize xen panic handler for PVHVM guests
git bisect good 04660bb5d0e4104e01a8fc34e5d51de1d84c09bf  # 23:53   5000+  xen/balloon: don't set P2M entry for auto translated guest
git bisect good 23b7eaf8220721892975610dd0ae5c846a34dcb4  # 03:19   5000+  hvc_xen: Remove unnecessary __GFP_ZERO from kzalloc
git bisect good 3398d252a4da80c47fe9b802184fa0a792387732  # 13:35  10000+  Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
git bisect good 23b7eaf8220721892975610dd0ae5c846a34dcb4  # 14:55  10000+  hvc_xen: Remove unnecessary __GFP_ZERO from kzalloc
git bisect  bad 14951f22f1cc8375ead345d2ca08455e91f2152b  # 14:55      0-  Revert "perf symbols: Demangle cloned functions"
git bisect  bad e62063d69911886a5a92c719d262a2a87e1e5b60  # 15:28   1444-  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect  bad a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 15:28      0-  Add linux-next specific files for 20130927
git bisect  bad b3180196661164e208fe2677fc938f07732c622d  # 15:56    728-  Merge branch 'tools/kvm'

Thanks,
Fengguang

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-tt02-6:20130929132932:3.12.0-rc2-00153-g14951f2:129"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc2-00153-g14951f2 (kbuild@xian) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #129 SMP PREEMPT Sun Sep 29 23:02:12 CST 20=
13
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-x1-0928/tip:perf:urgent/.vmlinuz=
-14951f22f1cc8375ead345d2ca08455e91f2152b-20130929230242-9-lkp-tt02 branch=
=3Dtip/perf/urgent BOOT_IMAGE=3D/kernel/x86_64-randconfig-x1-0928/14951f22f=
1cc8375ead345d2ca08455e91f2152b/vmlinuz-3.12.0-rc2-00153-g14951f2
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
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbec
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x028bc000, 0x028bcfff] PGTABLE
[    0.000000] BRK [0x028bd000, 0x028bdfff] PGTABLE
[    0.000000] BRK [0x028be000, 0x028befff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fa00000-0x0fbfffff]
[    0.000000]  [mem 0x0fa00000-0x0fbfffff] page 4k
[    0.000000] BRK [0x028bf000, 0x028bffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0f9fffff]
[    0.000000]  [mem 0x0c000000-0x0f9fffff] page 4k
[    0.000000] BRK [0x028c0000, 0x028c0fff] PGTABLE
[    0.000000] BRK [0x028c1000, 0x028c1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fffdfff]
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127996(97%)
[    0.000000] RAMDISK: [mem 0x0fd03000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fcc3001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5ba000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr=
_node_ids:1
[    0.000000] PERCPU: Embedded 24 pages/cpu @ffff88000f000000 s77520 r0 d2=
0784 u1048576
[    0.000000] pcpu-alloc: s77520 r0 d20784 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fcc3001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr f00ccc0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-x1-0928/tip:perf:urgent/.v=
mlinuz-14951f22f1cc8375ead345d2ca08455e91f2152b-20130929230242-9-lkp-tt02 b=
ranch=3Dtip/perf/urgent BOOT_IMAGE=3D/kernel/x86_64-randconfig-x1-0928/1495=
1f22f1cc8375ead345d2ca08455e91f2152b/vmlinuz-3.12.0-rc2-00153-g14951f2
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 219648K/261744K available (8554K kernel code, 1777K =
rwdata, 4052K rodata, 848K init, 10068K bss, 42096K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 3 of 3 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2393.914 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 4787.82 Bogo=
MIPS (lpj=3D9575656)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008866] Mount-cache hash table entries: 256
[    0.010846] Initializing cgroup subsys devices
[    0.012032] Initializing cgroup subsys perf_event
[    0.013041] Initializing cgroup subsys net_prio
[    0.014290] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014290] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014290] tlb_flushall_shift: 6
[    0.016046] debug: unmapping init [mem 0xffffffff81ee3000-0xffffffff81ee=
6fff]
[    0.021334] ACPI: Core revision 20130725
[    0.025239] ACPI: All ACPI Tables successfully acquired
[    0.026996] Getting VERSION: 50014
[    0.027752] Getting VERSION: 50014
[    0.028016] Getting ID: 0
[    0.028598] Getting ID: ff000000
[    0.029322] Getting LVT0: 8700
[    0.029992] Getting LVT1: 8400
[    0.030735] enabled ExtINT on CPU#0
[    0.033454] ENABLING IO-APIC IRQs
[    0.034167] init IO_APIC IRQs
[    0.034827]  apic 0 pin 0 not connected
[    0.035666] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.036034] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.037728] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.040030] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.041715] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.044030] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.045697] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.047373] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.048030] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.049697] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.052030] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.053747] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.056030] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.057740] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.060029] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.061746]  apic 0 pin 16 not connected
[    0.062584]  apic 0 pin 17 not connected
[    0.063417]  apic 0 pin 18 not connected
[    0.064004]  apic 0 pin 19 not connected
[    0.064826]  apic 0 pin 20 not connected
[    0.065660]  apic 0 pin 21 not connected
[    0.066489]  apic 0 pin 22 not connected
[    0.067323]  apic 0 pin 23 not connected
[    0.068162] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.069604] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.072405] Using local APIC timer interrupts.
[    0.072405] calibrating APIC timer ...
[    0.076000] ... lapic delta =3D 6249911
[    0.076000] ... PM-Timer delta =3D 357891
[    0.076000] ... PM-Timer result ok
[    0.076000] ..... delta 6249911
[    0.076000] ..... mult: 268431633
[    0.076000] ..... calibration result: 3999943
[    0.076000] ..... CPU clock speed is 2393.1782 MHz.
[    0.076000] ..... host bus clock speed is 999.3943 MHz.
[    0.076172] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.101634] SMP alternatives: lockdep: fixing up alternatives
[    0.103027] smpboot: Booting Node   0, Processors  #   1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:fcc3041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.120000] TSC synchronization [CPU#0 -> CPU#1]:
[    0.120000] Measured 23548 cycles TSC warp between CPUs, turning off TSC=
 clock.
[    0.120000] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.124150] Brought up 2 CPUs
[    0.124088] KVM setup async PF for cpu 1
[    0.124088] kvm-stealtime: cpu 1, msr f10ccc0
[    0.126513] smpboot: Total of 2 processors activated (9575.65 BogoMIPS)
[    0.129723] devtmpfs: initialized
[    0.134051] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.136882] regulator-dummy: no parameters
[    0.138474] NET: Registered protocol family 16
[    0.141080] cpuidle: using governor ladder
[    0.141942] cpuidle: using governor menu
[    0.143479] ACPI: bus type PCI registered
[    0.144098] PCI: Using configuration type 1 for base access
[    0.157300] ACPI: Added _OSI(Module Device)
[    0.157876] ACPI: Added _OSI(Processor Device)
[    0.160005] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.160992] ACPI: Added _OSI(Processor Aggregator Device)
[    0.164259] ACPI: EC: Look up EC in DSDT
[    0.171504] ACPI: Interpreter enabled
[    0.172019] ACPI: (supports S0 S5)
[    0.172742] ACPI: Using IOAPIC for interrupt routing
[    0.173800] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.189507] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.190800] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    0.192006] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.194252] PCI host bridge to bus 0000:00
[    0.195116] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.196013] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.197289] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.198559] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.200005] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.201507] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.204511] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.207020] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.210980] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.213671] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.216082] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.217594] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.219708] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.222219] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.225377] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.233943] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.236382] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.238699] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.240530] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.246971] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.248824] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.251131] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.253024] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.260006] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.261960] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.263778] pci 0000:00:05.0: reg 0x10: [mem 0xfebe2000-0xfebe200f]
[    0.269444] pci_bus 0000:00: on NUMA node 0
[    0.271621] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.272628] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.274210] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.276386] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.277829] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.280000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.280014] ACPI: \_SB_.PCI0: notify handler is installed
[    0.281255] Found 1 acpi root devices
[    0.284317] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.285781] vgaarb: loaded
[    0.286357] vgaarb: bridge control possible 0000:00:02.0
[    0.288843] ACPI: bus type USB registered
[    0.289767] usbcore: registered new interface driver usbfs
[    0.290966] usbcore: registered new interface driver hub
[    0.292164] usbcore: registered new device driver usb
[    0.293383] pps_core: LinuxPPS API ver. 1 registered
[    0.294417] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.296053] PTP clock support registered
[    0.297281] wmi: Mapper loaded
[    0.298052] PCI: Using ACPI for IRQ routing
[    0.298938] PCI: pci_cache_line_size set to 64 bytes
[    0.300273] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.301527] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.304481] NET: Registered protocol family 23
[    0.306226] cfg80211: Calling CRDA to update world regulatory domain
[    0.307696] nfc: nfc_init: NFC Core ver 0.1
[    0.308054] NET: Registered protocol family 39
[    0.309679] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.312203] Switched to clocksource kvm-clock
[    0.313586] pnp: PnP ACPI init
[    0.314337] ACPI: bus type PNP registered
[    0.315305] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.317088] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.318682] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.320457] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.321846] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.323631] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.325125] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.326770] pnp 00:03: [dma 2]
[    0.327480] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.328948] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.330685] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.332201] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.333911] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.335698] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.337355] pnp: PnP ACPI: found 7 devices
[    0.338235] ACPI: bus type PNP unregistered
[    0.345385] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.346550] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.347708] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.349045] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.350886] NET: Registered protocol family 2
[    0.353075] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    0.354663] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.356274] TCP: Hash tables configured (established 2048 bind 2048)
[    0.357747] TCP: reno registered
[    0.358730] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.360345] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.362082] NET: Registered protocol family 1
[    0.364302] RPC: Registered named UNIX socket transport module.
[    0.365536] RPC: Registered udp transport module.
[    0.366515] RPC: Registered tcp transport module.
[    0.367497] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.368878] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.370141] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.371384] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.372794] pci 0000:00:02.0: Boot video device
[    0.373810] PCI: CLS 0 bytes, default 64
[    0.375019] Unpacking initramfs...
[    0.665423] debug: unmapping init [mem 0xffff88000fd03000-0xffff88000ffe=
ffff]
[    0.668031] has_svm: not amd
[    0.668710] kvm: no hardware support
[    0.670202] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    0.672124] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    0.676077] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    0.678126] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.679407] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.680773] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.680820] cryptomgr_test (24) used greatest stack depth: 6504 bytes le=
ft
[    0.683516] AVX or AES-NI instructions are not detected.
[    0.684676] AVX instructions are not detected.
[    0.686277] AVX instructions are not detected.
[    0.687233] AVX instructions are not detected.
[    0.692289] Initializing RT-Tester: OK
[    0.693118] audit: initializing netlink socket (disabled)
[    0.694380] type=3D2000 audit(1380432562.711:1): initialized
[    0.701268] DLM installed
[    0.704367] NFS: Registering the id_resolver key type
[    0.705594] Key type id_resolver registered
[    0.706490] Key type id_legacy registered
[    0.707345] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.710070] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.711046] fuse init (API version 7.22)
[    0.712632] ceph: loaded (mds proto 32)
[    0.716482] cryptomgr_test (43) used greatest stack depth: 5904 bytes le=
ft
[    0.720098] cryptomgr_test (44) used greatest stack depth: 5752 bytes le=
ft
[    0.728370] cryptomgr_test (48) used greatest stack depth: 5648 bytes le=
ft
[    0.765970] cryptomgr_test (72) used greatest stack depth: 5440 bytes le=
ft
[    0.779500] alg: No test for crc32 (crc32-table)
[    0.782635] alg: No test for lz4hc (lz4hc-generic)
[    0.783779] alg: No test for stdrng (krng)
[    0.786623] NET: Registered protocol family 38
[    0.787589] Key type asymmetric registered
[    0.788505] Asymmetric key parser 'x509' registered
[    0.789530] test_string_helpers: Running tests...
[    0.791185] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    0.792290] crc32: self tests passed, processed 225944 bytes in 251828 n=
sec
[    0.794002] crc32c: CRC_LE_BITS =3D 32
[    0.794753] crc32c: self tests passed, processed 225944 bytes in 138437 =
nsec
[    0.796530] rbtree testing -> 18782 cycles
[    1.632699] augmented rbtree testing -> 29249 cycles
[    2.930558] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.931730] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.933573] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.935239] vmlfb: initializing
[    2.935948] Could not find Carillo Ranch MCH device.
[    2.937122] no IO addresses supplied
[    2.938028] hgafb: HGA card not detected.
[    2.938868] hgafb: probe of hgafb.0 failed with error -22
[    2.940151] usbcore: registered new interface driver udlfb
[    2.941316] usbcore: registered new interface driver smscufx
[    2.950247] uvesafb: VGABIOS Cirrus extension, VGABIOS Cirrus extension,=
 1.0, OEM: VGABIOS Cirrus extension, VBE v2.0
[    2.955973] uvesafb: no monitor limits have been set, default refresh ra=
te will be used
[    2.957820] uvesafb: VBE state buffer size cannot be determined (eax=3D0=
x14f, err=3D0)
[    2.959448] uvesafb: scrolling: redraw
[    2.961139] uvesafb: framebuffer at 0xfc000000, mapped to 0xffffc9000008=
0000, using 4096k, total 4096k
[    2.963061] fb0: VESA VGA frame buffer device
[    2.964199] ipmi message handler version 39.2
[    2.965117] ipmi device interface
[    2.965941] IPMI System Interface driver.
[    2.966834] ipmi_si: Adding default-specified kcs state machine
[    2.968159] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    2.970228] ipmi_si: Interface detection failed
[    2.984125] ipmi_si: Adding default-specified smic state machine
[    2.985454] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    2.987547] ipmi_si: Interface detection failed
[    3.000084] ipmi_si: Adding default-specified bt state machine
[    3.001394] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.003431] ipmi_si: Interface detection failed
[    3.016271] ipmi_si: Unable to find any System Interface(s)
[    3.017436] IPMI Watchdog: driver initialized
[    3.018346] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    3.020303] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.021846] ACPI: Power Button [PWRF]
[    3.094730] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.120869] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.124230] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    3.125705] ac.o: No PCI boards found.
[    3.126494] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    3.128147] Non-volatile memory driver v1.3
[    3.129025] Linux agpgart interface v0.103
[    3.130466] [drm] Initialized drm 1.1.0 20060810
[    3.131563] [drm] radeon kernel modesetting enabled.
[    3.134340] [drm:cirrus_vram_init] *ERROR* can't reserve VRAM
[    3.135545] cirrus 0000:00:02.0: Fatal error during GPU init: -6
[    3.136828] Trying to free nonexistent resource <00000000febe0000-000000=
00febe0fff>
[    3.139527] usbcore: registered new interface driver udl
[    3.142232] parport_pc 00:04: reported by Plug and Play ACPI
[    3.143510] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    3.145768] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.147164] dummy-irq: no IRQ given.  Use irq=3DN
[    3.148378] Phantom Linux Driver, version n0.9.8, init OK
[    3.149841] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.151562] c2port c2port0: C2 port uc added
[    3.152513] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    3.154379] Guest personality initialized and is inactive
[    3.155704] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D56)
[    3.157115] Initialized host personality
[    3.158477] usbcore: registered new interface driver viperboard
[    3.159800] usbcore: registered new interface driver pn533
[    3.161575] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    3.162935] device id =3D 2440
[    3.163540] device id =3D 2480
[    3.164182] device id =3D 24c0
[    3.164787] device id =3D 24d0
[    3.165404] device id =3D 25a1
[    3.166038] device id =3D 2670
[    3.166733] platform physmap-flash.0: failed to claim resource 0
[    3.168026] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    3.169362] Could not find PAR responsible for SC520CDP Flash Bank #0
[    3.170687] Trying default address 0x8400000
[    3.171579] Could not find PAR responsible for SC520CDP Flash Bank #1
[    3.172945] Trying default address 0x8c00000
[    3.173827] Could not find PAR responsible for SC520CDP DIL Flash
[    3.175090] Trying default address 0x9400000
[    3.176048] SC520 CDP flash device: 0x800000 at 0x8400000
[    3.177164] Failed to ioremap_nocache
[    3.177939] Failed to ioremap_nocache
[    3.178722] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.180097] slram: not enough parameters.
[    3.187587] No valid DiskOnChip devices found
[    3.188571] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.190491] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.192446] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.194365] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.196317] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.198237] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    3.200194] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba N=
AND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    3.202770] flash size: 128 MiB
[    3.203440] page size: 512 bytes
[    3.204157] OOB area size: 16 bytes
[    3.204887] sector size: 16 KiB
[    3.205557] pages number: 262144
[    3.206241] pages per sector: 32
[    3.206925] bus width: 8
[    3.207458] bits in sector size: 14
[    3.208220] bits in page size: 9
[    3.208905] bits in OOB size: 4
[    3.209560] flash size with OOB: 135168 KiB
[    3.210434] page address bytes: 4
[    3.211136] sector address bytes: 3
[    3.211864] options: 0x42
[    3.221573] Scanning device for bad blocks
[    3.263637] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.264990] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.267334] parport0: powerup/reset Butterfly
[    3.384420] parport_pc 00:04: registered master spi42
[    3.385839] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    3.386960] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    3.388431] parport_pc 00:04: registered child spi42.1
[    3.389499] parport0: dataflash at spi42.1
[    3.390359] parport0: AVR Butterfly
[    3.391254] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    3.392699] spi-lm70llp: spi_lm70llp probe fail, status -12
[    3.394209] usbcore: registered new interface driver irda-usb
[    3.395415] usbcore: registered new interface driver stir4200
[    3.396667] usbcore: registered new interface driver mcs7780
[    3.397877] usbcore: registered new interface driver kingsun-sir
[    3.399154] usbcore: registered new interface driver ksdazzle-sir
[    3.400504] usbcore: registered new interface driver ks959-sir
[    3.402070] usbcore: registered new interface driver hwa-rc
[    3.403349] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.404658] ohci-pci: OHCI PCI platform driver
[    3.405611] ohci-platform: OHCI generic platform driver
[    3.406713] uhci_hcd: USB Universal Host Controller Interface driver
[    3.408320] driver u132_hcd
[    3.409479] usbcore: registered new interface driver hwa-hc
[    3.410693] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.411950] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    3.414064] usbcore: registered new interface driver cdc_wdm
[    3.415257] usbcore: registered new interface driver usbtmc
[    3.416676] usbcore: registered new interface driver appledisplay
[    3.417986] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    3.419476] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    3.420971] driver ftdi-elan
[    3.422126] usbcore: registered new interface driver ftdi-elan
[    3.423355] usbcore: registered new interface driver idmouse
[    3.424568] usbcore: registered new interface driver usblcd
[    3.425741] usbcore: registered new interface driver ldusb
[    3.426930] usbcore: registered new interface driver usbled
[    3.428136] usbcore: registered new interface driver legousbtower
[    3.429407] usbcore: registered new interface driver rio500
[    3.430609] usbcore: registered new interface driver usbtest
[    3.431828] usbcore: registered new interface driver usb_ehset_test
[    3.433180] usbcore: registered new interface driver trancevibrator
[    3.434480] usbcore: registered new interface driver uss720
[    3.435627] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    3.437565] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    3.439079] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    3.440584] uss720: If you just want to connect to a printer, use usblp =
instead
[    3.442145] usbcore: registered new interface driver yurex
[    3.443514] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.446585] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.447940] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.449174] parport0: cannot grant exclusive access for device parkbd
[    3.562188] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    3.564568] usbcore: registered new interface driver bcm5974
[    3.566860] usbcore: registered new interface driver synaptics_usb
[    3.570256] usbcore: registered new interface driver iforce
[    3.571667] parport0: cannot grant exclusive access for device walkera07=
01
[    3.573375] walkera0701: failed to register parport device
[    3.576175] usbcore: registered new interface driver usbtouchscreen
[    3.577692] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    3.579023] usbcore: registered new interface driver ati_remote2
[    3.580324] cm109: Keymap for Komunikate KIP1000 phone loaded
[    3.581540] usbcore: registered new interface driver cm109
[    3.582687] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    3.584122] usbcore: registered new interface driver keyspan_remote
[    3.585773] usbcore: registered new interface driver yealink
[    3.586970] I2O subsystem v1.325
[    3.587645] i2o: max drivers =3D 8
[    3.588635] I2O Configuration OSM v1.323
[    3.589480] I2O ProcFS OSM v1.316
[    3.591598] rtc rtc0: test: dev (254:0)
[    3.592463] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    3.594033] rtc rtc1: test: dev (254:1)
[    3.594839] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    3.596255] i2c /dev entries driver
[    3.597481] usbcore: registered new interface driver i2c-diolan-u2c
[    3.598786] i2c-parport: adapter type unspecified
[    3.599780] i2c-parport-light: adapter type unspecified
[    3.601113] pps pps0: new PPS source ktimer
[    3.602004] pps pps0: ktimer PPS source registered
[    3.603010] pps_parport: parallel port PPS client
[    3.604027] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    3.605454] pps_parport: couldn't register with parport0
[    3.606670] Driver for 1-wire Dallas network protocol.
[    3.607834] usbcore: registered new interface driver DS9490R
[    3.609108] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.610612] power_supply test_ac: uevent
[    3.611462] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.612703] power_supply test_ac: prop ONLINE=3D1
[    3.613728] power_supply test_ac: power_supply_changed
[    3.614873] power_supply test_ac: power_supply_changed_work
[    3.616097] power_supply test_ac: power_supply_update_gen_leds 1
[    3.616205] power_supply test_battery: uevent
[    3.616207] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.616238] power_supply test_battery: prop STATUS=3DDischarging
[    3.616242] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.616245] power_supply test_battery: prop HEALTH=3DGood
[    3.616247] power_supply test_battery: prop PRESENT=3D1
[    3.616250] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.616253] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.616256] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.616258] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.616261] power_supply test_battery: prop CAPACITY=3D50
[    3.616264] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.616267] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.616270] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.616272] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.616275] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.616278] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-rc2-0=
0153-g14951f2
[    3.616281] power_supply test_battery: prop TEMP=3D26
[    3.616284] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.616541] power_supply test_battery: power_supply_changed
[    3.616553] power_supply test_battery: power_supply_changed_work
[    3.616557] power_supply test_battery: power_supply_update_bat_leds 2
[    3.616566] power_supply test_battery: uevent
[    3.616568] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    3.616600] power_supply test_battery: prop STATUS=3DDischarging
[    3.616604] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    3.616607] power_supply test_battery: prop HEALTH=3DGood
[    3.616610] power_supply test_battery: prop PRESENT=3D1
[    3.616613] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    3.616616] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    3.616619] power_supply test_battery: prop CHARGE_FULL=3D100
[    3.616622] power_supply test_battery: prop CHARGE_NOW=3D50
[    3.616624] power_supply test_battery: prop CAPACITY=3D50
[    3.616627] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    3.616630] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    3.616633] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    3.616636] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    3.616639] power_supply test_battery: prop MANUFACTURER=3DLinux
[    3.616642] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-rc2-0=
0153-g14951f2
[    3.616645] power_supply test_battery: prop TEMP=3D26
[    3.616648] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    3.616712] power_supply test_usb: uevent
[    3.616714] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.616746] power_supply test_usb: prop ONLINE=3D1
[    3.616777] power_supply test_usb: power_supply_changed
[    3.616794] power_supply test_usb: power_supply_changed_work
[    3.616798] power_supply test_usb: power_supply_update_gen_leds 1
[    3.616803] power_supply test_usb: uevent
[    3.616805] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    3.616836] power_supply test_usb: prop ONLINE=3D1
[    3.617744] applesmc: supported laptop not found!
[    3.617745] applesmc: driver init failed (ret=3D-19)!
[    3.618167] f71882fg: Not a Fintek device
[    3.618253] f71882fg: Not a Fintek device
[    3.619509] pc87360: PC8736x not detected, module not inserted
[    3.620413] sdhci: Secure Digital Host Controller Interface driver
[    3.620414] sdhci: Copyright(c) Pierre Ossman
[    3.620953] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    3.620953] usbcore: registered new interface driver vub300
[    3.620969] usbcore: registered new interface driver ushc
[    3.620970] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.621748] ledtrig-cpu: registered to indicate activity on CPUs
[    3.622105] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.623862] usbcore: registered new interface driver usbhid
[    3.623863] usbhid: USB HID core driver
[    3.623956] usbip_core: usbip_core_init:805: USB/IP Core v1.0.0
[    3.624103] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    3.624159] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    3.624210] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 1
[    3.624219] vhci_hcd: vhci_start:884: enter vhci_start
[    3.625516] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    3.625519] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.625521] usb usb1: Product: USB/IP Virtual Host Controller
[    3.625523] usb usb1: Manufacturer: Linux 3.12.0-rc2-00153-g14951f2 vhci=
_hcd
[    3.625524] usb usb1: SerialNumber: vhci_hcd
[    3.707087] power_supply test_ac: uevent
[    3.707601] hub 1-0:1.0: USB hub found
[    3.707669] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIn=
dex 0
[    3.707704] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    3.707705] vhci_hcd: vhci_hub_control:398: port -1
[    3.707706] vhci_hcd: vhci_hub_control:405:  bye
[    3.707748] hub 1-0:1.0: 8 ports detected
[    3.707815] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex=
 0
[    3.707826] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    3.707828] vhci_hcd: vhci_hub_control:398: port -1
[    3.707829] vhci_hcd: vhci_hub_control:405:  bye
[    3.708606] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 1
[    3.708608] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.708609] vhci_hcd: vhci_hub_control:398: port 0
[    3.708610] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.708612] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.708613] vhci_hcd: dump_port_status_diff:119:=20
[    3.708614] vhci_hcd: vhci_hub_control:405:  bye
[    3.708631] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 2
[    3.708633] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.708634] vhci_hcd: vhci_hub_control:398: port 1
[    3.708635] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.708637] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.708646] vhci_hcd: dump_port_status_diff:119:=20
[    3.708648] vhci_hcd: vhci_hub_control:405:  bye
[    3.708663] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 3
[    3.708665] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.708666] vhci_hcd: vhci_hub_control:398: port 2
[    3.708668] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.708669] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.708670] vhci_hcd: dump_port_status_diff:119:=20
[    3.708671] vhci_hcd: vhci_hub_control:405:  bye
[    3.708685] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 4
[    3.708687] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.708688] vhci_hcd: vhci_hub_control:398: port 3
[    3.708689] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.708690] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.708692] vhci_hcd: dump_port_status_diff:119:=20
[    3.708693] vhci_hcd: vhci_hub_control:405:  bye
[    3.708707] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 5
[    3.708708] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.708709] vhci_hcd: vhci_hub_control:398: port 4
[    3.708711] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.708712] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.708713] vhci_hcd: dump_port_status_diff:119:=20
[    3.708714] vhci_hcd: vhci_hub_control:405:  bye
[    3.708728] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 6
[    3.708730] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.708731] vhci_hcd: vhci_hub_control:398: port 5
[    3.708732] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.708734] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.708735] vhci_hcd: dump_port_status_diff:119:=20
[    3.708736] vhci_hcd: vhci_hub_control:405:  bye
[    3.708750] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 7
[    3.708753] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.708754] vhci_hcd: vhci_hub_control:398: port 6
[    3.708755] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.708756] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.708758] vhci_hcd: dump_port_status_diff:119:=20
[    3.708759] vhci_hcd: vhci_hub_control:405:  bye
[    3.708773] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex=
 8
[    3.708774] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.708775] vhci_hcd: vhci_hub_control:398: port 7
[    3.708777] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    3.708778] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.708779] vhci_hcd: dump_port_status_diff:119:=20
[    3.708780] vhci_hcd: vhci_hub_control:405:  bye
[    3.709039] vhci_hcd: vhci_hcd_probe:1034: bye
[    3.709045] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controll=
er (VHCI) Driver v1.0.0
[    3.790072] usbcore: registered new interface driver usbip-host
[    3.790148] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    3.790192] power_supply test_ac: prop ONLINE=3D1
[    3.793567] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    3.795104] usbcore: registered new interface driver tranzport
[    3.796483] usbcore: registered new interface driver alphatrack
[    3.797996] vme_user: VME User Space Access Driver
[    3.799076] vme_user: No cards, skipping registration
[    3.801696] Loading crystalhd 0.9.27
[    3.802525] usbcore: registered new interface driver ft1000usb
[    3.803903] usbcore: registered new interface driver gdm_wimax
[    3.805248] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 1
[    3.806662] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    3.807935] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.809286] vhci_hcd: vhci_hub_control:398: port 0
[    3.809329] usbcore: registered new interface driver cedusb
[    3.811482] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.811649] ipip: IPv4 over IPv4 tunneling driver
[    3.812193] gre: GRE over IPv4 demultiplexor driver
[    3.812195] IPv4 over IPSec tunneling driver
[    3.812739] TCP: cubic registered
[    3.812743] NET: Registered protocol family 17
[    3.817748] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.817749] NET: Registered protocol family 9
[    3.817752] X.25 for Linux Version 0.2
[    3.820590] vhci_hcd: dump_port_status_diff:119:=20
[    3.821590] vhci_hcd: vhci_hub_control:405:  bye
[    3.821590] NET: Registered protocol family 33
[    3.821592] Key type rxrpc registered
[    3.821593] Key type rxrpc_s registered
[    3.825347] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 2
[    3.826974] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    3.827093] RxRPC: Registered security type 2 'rxkad'
[    3.827179] l2tp_core: L2TP core driver, V2.0
[    3.827180] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    3.831877] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.833240] vhci_hcd: vhci_hub_control:398: port 1
[    3.833350] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    3.835578] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.835640] NET: Registered protocol family 12
[    3.838245] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.839350] vhci_hcd: dump_port_status_diff:119:=20
[    3.840357] vhci_hcd: vhci_hub_control:405:  bye
[    3.841349] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 3
[    3.842754] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    3.844065] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.845369] vhci_hcd: vhci_hub_control:398: port 2
[    3.846380] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.848096] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.849220] vhci_hcd: dump_port_status_diff:119:=20
[    3.849240] 8021q: 802.1Q VLAN Support v1.8
[    3.851095] vhci_hcd: vhci_hub_control:405:  bye
[    3.852134] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 4
[    3.852502] sctp: Hash tables configured (established 1024 bind 1024)
[    3.854923] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    3.856233] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.857557] vhci_hcd: vhci_hub_control:398: port 3
[    3.858551] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.860276] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.860279] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[    3.860281] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[    3.860365] NET: Registered protocol family 37
[    3.864740] vhci_hcd: dump_port_status_diff:119:=20
[    3.865731] vhci_hcd: vhci_hub_control:405:  bye
[    3.865732] NET: Registered protocol family 36
[    3.865826] Key type dns_resolver registered
[    3.865841] Key type ceph registered
[    3.869338] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 5
[    3.870783] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    3.872085] libceph: loaded (mon/osd proto 15/24)
[    3.872100] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.872102] vhci_hcd: vhci_hub_control:398: port 4
[    3.872103] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.872105] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.872106] vhci_hcd: dump_port_status_diff:119:=20
[    3.872107] vhci_hcd: vhci_hub_control:405:  bye
[    3.872126] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 6
[    3.872128] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    3.872129] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.872131] vhci_hcd: vhci_hub_control:398: port 5
[    3.872132] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.872133] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.872135] vhci_hcd: dump_port_status_diff:119:=20
[    3.872136] vhci_hcd: vhci_hub_control:405:  bye
[    3.872148] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 7
[    3.872150] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    3.872151] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.872152] vhci_hcd: vhci_hub_control:398: port 6
[    3.872154] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.872155] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.872156] vhci_hcd: dump_port_status_diff:119:=20
[    3.872157] vhci_hcd: vhci_hub_control:405:  bye
[    3.872170] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex=
 8
[    3.872171] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    3.872173] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.872174] vhci_hcd: vhci_hub_control:398: port 7
[    3.872175] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    3.872177] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.872178] vhci_hcd: dump_port_status_diff:119:=20
[    3.872179] vhci_hcd: vhci_hub_control:405:  bye
[    3.909645] mpls_gso: MPLS GSO support
[    3.909828] usb usb1: vhci_bus_suspend
[    3.909838] vhci_hcd: vhci_hub_status:208: changed 0
[    3.912952]=20
[    3.912952] printing PIC contents
[    3.913967] ... PIC  IMR: ffff
[    3.914611] ... PIC  IRR: 1013
[    3.915275] ... PIC  ISR: 0000
[    3.915940] ... PIC ELCR: 0c00
[    3.916627] printing local APIC contents on CPU#0/0:
[    3.917671] ... APIC ID:      00000000 (0)
[    3.918534] ... APIC VERSION: 00050014
[    3.919326] ... APIC TASKPRI: 00000000 (00)
[    3.920219] ... APIC PROCPRI: 00000000
[    3.920591] ... APIC LDR: 01000000
[    3.920591] ... APIC DFR: ffffffff
[    3.920591] ... APIC SPIV: 000001ff
[    3.920591] ... APIC ISR field:
[    3.920591] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.920591] ... APIC TMR field:
[    3.920591] 000000000200000000000000000000000000000000000000000000000000=
0000
[    3.920591] ... APIC IRR field:
[    3.920591] 000000000000000000000000000000000000000000000000000000000000=
8000
[    3.920591] ... APIC ESR: 00000000
[    3.920591] ... APIC ICR: 000008fd
[    3.920591] ... APIC ICR2: 02000000
[    3.920591] ... APIC LVTT: 000000ef
[    3.920591] ... APIC LVTPC: 00010000
[    3.920591] ... APIC LVT0: 00010700
[    3.920591] ... APIC LVT1: 00000400
[    3.920591] ... APIC LVTERR: 000000fe
[    3.920591] ... APIC TMICT: 00033f8c
[    3.920591] ... APIC TMCCT: 00000000
[    3.920591] ... APIC TDCR: 00000003
[    3.920591]=20
[    3.939047] number of MP IRQ sources: 15.
[    3.939876] number of IO-APIC #0 registers: 24.
[    3.940870] testing the IO APIC.......................
[    3.941974] IO APIC #0......
[    3.942574] .... register #00: 00000000
[    3.943375] .......    : physical APIC id: 00
[    3.944306] .......    : Delivery Type: 0
[    3.945146] .......    : LTS          : 0
[    3.945986] .... register #01: 00170011
[    3.946776] .......     : max redirection entries: 17
[    3.947818] .......     : PRQ implemented: 0
[    3.948753] .......     : IO APIC version: 11
[    3.949669] .... register #02: 00000000
[    3.950477] .......     : arbitration: 00
[    3.951325] .... IRQ redirection table:
[    3.952174] 1    0    0   0   0    0    0    00
[    3.953137] 0    0    0   0   0    1    1    31
[    3.954101] 0    0    0   0   0    1    1    30
[    3.955064] 0    0    0   0   0    1    1    33
[    3.956053] 1    0    0   0   0    1    1    34
[    3.957014] 1    1    0   0   0    1    1    35
[    3.957979] 0    0    0   0   0    1    1    36
[    3.958941] 0    0    0   0   0    1    1    37
[    3.959904] 0    0    0   0   0    1    1    38
[    3.960885] 0    1    0   0   0    1    1    39
[    3.961846] 1    1    0   0   0    1    1    3A
[    3.962811] 1    1    0   0   0    1    1    3B
[    3.963775] 0    0    0   0   0    1    1    3C
[    3.964763] 0    0    0   0   0    1    1    3D
[    3.965722] 0    0    0   0   0    1    1    3E
[    3.966681] 0    0    0   0   0    1    1    3F
[    3.967638] 1    0    0   0   0    0    0    00
[    3.968623] 1    0    0   0   0    0    0    00
[    3.969584] 1    0    0   0   0    0    0    00
[    3.970539] 1    0    0   0   0    0    0    00
[    3.971505] 1    0    0   0   0    0    0    00
[    3.972493] 1    0    0   0   0    0    0    00
[    3.973456] 1    0    0   0   0    0    0    00
[    3.974415] 1    0    0   0   0    0    0    00
[    3.975355] IRQ to pin mappings:
[    3.976064] IRQ0 -> 0:2
[    3.976643] IRQ1 -> 0:1
[    3.977234] IRQ3 -> 0:3
[    3.977810] IRQ4 -> 0:4
[    3.978397] IRQ5 -> 0:5
[    3.978983] IRQ6 -> 0:6
[    3.979558] IRQ7 -> 0:7
[    3.980169] IRQ8 -> 0:8
[    3.980749] IRQ9 -> 0:9
[    3.981344] IRQ10 -> 0:10
[    3.981968] IRQ11 -> 0:11
[    3.982578] IRQ12 -> 0:12
[    3.983201] IRQ13 -> 0:13
[    3.983812] IRQ14 -> 0:14
[    3.984460] IRQ15 -> 0:15
[    3.985083] .................................... done.
[    3.986786] registered taskstats version 1
[    3.988583] rtc-test rtc-test.0: setting system clock to 2013-09-29 05:2=
9:26 UTC (1380432566)
[    3.992123] debug: unmapping init [mem 0xffffffff81e0f000-0xffffffff81ee=
2fff]

mount: mounting proc on /proc failed: No such device
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
Starting Bootlog daemon:=20
[    4.136137] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    4.137521] CPU: 0 PID: 132 Comm: bootlogd Not tainted 3.12.0-rc2-00153-=
g14951f2 #129
[    4.139156] task: ffff88000c9a6580 ti: ffff88000c9ba000 task.ti: ffff880=
00c9ba000
[    4.140042] RIP: 0010:[<ffffffff81f31c7e>]  [<ffffffff81f31c7e>] boot_tv=
ec_bases+0x1fe/0x2080
[    4.140042] RSP: 0018:0000000088000cd8  EFLAGS: 00010212
[    4.140042] RAX: 000000000000004f RBX: 0000000000000100 RCX: 00000000000=
00000
[    4.140042] RDX: 0000000000000f1e RSI: ffffffff81f746a8 RDI: ffffffff81f=
31c48
[    4.140042] RBP: ffff88000f003ee0 R08: 0000000000000000 R09: 00000000000=
00000
[    4.140042] R10: 0000000000000001 R11: ffff88000f00a000 R12: ffff88000c9=
bbfd8
[    4.140042] R13: ffffffff81f31c48 R14: ffffffff81f31c48 R15: ffffffff81f=
31c48
[    4.140042] FS:  00007fb1f9662700(0000) GS:ffff88000f000000(0000) knlGS:=
0000000000000000
[    4.140042] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.140042] CR2: 0000000088000cc8 CR3: 000000000c9cd000 CR4: 00000000000=
006b0
[    4.140042] Stack:
[    4.140042] BUG: unable to handle kernel paging request at 0000000088000=
cd8
[    4.140042] IP: [<ffffffff8102bf55>] show_stack_log_lvl+0xc3/0x137
[    4.140042] PGD c9e6067 PUD 0=20
[    4.140042] Oops: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[    4.140042] CPU: 0 PID: 132 Comm: bootlogd Not tainted 3.12.0-rc2-00153-=
g14951f2 #129
[    4.140042] task: ffff88000c9a6580 ti: ffff88000c9ba000 task.ti: ffff880=
00c9ba000
[    4.140042] RIP: 0010:[<ffffffff8102bf55>]  [<ffffffff8102bf55>] show_st=
ack_log_lvl+0xc3/0x137
[    4.140042] RSP: 0018:ffff88000f005e20  EFLAGS: 00010046
[    4.140042] RAX: ffff88000effffc0 RBX: 0000000000000000 RCX: 00000000000=
00000
[    4.140042] RDX: 000000000000ba18 RSI: ffff88000f005f58 RDI: 00000000000=
00001
[    4.140042] RBP: ffff88000f005e70 R08: ffffffff81b6a095 R09: 00000000000=
00000
[    4.140042] R10: ffffffff810bb62b R11: 0000000000000000 R12: 00000000000=
00000
[    4.140042] R13: ffff88000f003fc0 R14: 0000000088000cd8 R15: 00000000000=
00040
[    4.140042] FS:  00007fb1f9662700(0000) GS:ffff88000f000000(0000) knlGS:=
0000000000000000
[    4.140042] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.140042] CR2: 0000000088000cd8 CR3: 000000000c9cd000 CR4: 00000000000=
006b0
[    4.140042] Stack:
[    4.140042]  ffffffff81b6a095 0000000000000000 ffff88000f005f58 ffff8800=
0effffc0
[    4.140042]  0000000088000cd8 ffff88000f005f58 0000000000000ac0 00000000=
88000cd8
[    4.140042]  0000000000000000 0000000000000040 ffff88000f005ec8 ffffffff=
8102c039
[    4.140042] Call Trace:
[    4.140042]  <#DF>=20
[    4.140042]  [<ffffffff8102c039>] show_regs+0x70/0x1d8
[    4.140042]  [<ffffffff810aa597>] ? atomic_notifier_call_chain+0xf/0x11
[    4.140042]  [<ffffffff8102cf01>] __die+0xaa/0xe9
[    4.140042]  [<ffffffff8102cf82>] die+0x42/0x5e
[    4.140042]  [<ffffffff8102aadb>] do_double_fault+0x5f/0x61
[    4.140042]  [<ffffffff8185a39d>] double_fault+0x2d/0x40
[    4.140042]  <<EOE>>=20
[    4.140042] Code: 4d 8b 76 f8 e8 e4 f9 81 00 eb 09 41 f7 c6 ff 1f 00 00 =
74 33 85 db 74 13 f6 c3 03 75 0e 48 c7 c7 12 4a b8 81 31 c0 e8 c2 f9 81 00 =
<49> 8b 36 4d 8d 7e 08 48 c7 c7 8d a0 b6 81 31 c0 ff c3 4d 89 fe=20
[    4.140042] RIP  [<ffffffff8102bf55>] show_stack_log_lvl+0xc3/0x137
[    4.140042]  RSP <ffff88000f005e20>
[    4.140042] CR2: 0000000088000cd8
[    4.140042] ---[ end trace d11a7e59f46ac8e0 ]---
[    4.140042] Kernel panic - not syncing: Fatal exception in interrupt
[    4.140042] Rebooting in 10 seconds..
BUG: kernel test oops
Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-x1-0928/14951f22f1cc8375ead345d2ca08455e91f2152b/vmlinuz-3.12.0-rc2-00153-=
g14951f2 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 l=
og_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_prin=
tk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1152=
00 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/ru=
n-queue/kvm/x86_64-randconfig-x1-0928/tip:perf:urgent/.vmlinuz-14951f22f1cc=
8375ead345d2ca08455e91f2152b-20130929230242-9-lkp-tt02 branch=3Dtip/perf/ur=
gent BOOT_IMAGE=3D/kernel/x86_64-randconfig-x1-0928/14951f22f1cc8375ead345d=
2ca08455e91f2152b/vmlinuz-3.12.0-rc2-00153-g14951f2'  -initrd /kernel-tests=
/initrd/yocto-minimal-x86_64.cgz -m 256M -smp 2 -net nic,vlan=3D0,macaddr=
=3D00:00:00:00:00:00,model=3Dvirtio -net user,vlan=3D0,hostfwd=3Dtcp::20318=
-:22 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -n=
o-reboot -watchdog i6300esb -pidfile /dev/shm/kboot/pid-lkp-tt02-lkp-16222 =
-serial file:/dev/shm/kboot/serial-lkp-tt02-lkp-16222 -daemonize -display n=
one -monitor null=20

--xHFwDpU9dbj6ez1V
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-14951f22f1cc8375ead345d2ca08455e91f2152b-x86_64-randconfig-x1-0928-double-fault:-35683.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDliNTY1YTgwNTFiMzg5ZTA0NjIwOWE1ZjY4YzkzZWFkZThkZTU4YmQK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMTQ5NTFmMi4uLiBSZXZlcnQgInBlcmYgc3lt
Ym9sczogRGVtYW5nbGUgY2xvbmVkIGZ1bmN0aW9ucyIKSEVBRCBpcyBub3cgYXQgOWI1NjVh
OC4uLiBNZXJnZSBicmFuY2ggJ3BlcmYtdXJnZW50LWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvdGlw
OnBlcmY6dXJnZW50OjliNTY1YTgwNTFiMzg5ZTA0NjIwOWE1ZjY4YzkzZWFkZThkZTU4YmQ6
YmlzZWN0LWRybQoKMjAxMy0xMC0wMi0yMjozNzozNiA5YjU2NWE4MDUxYjM4OWUwNDYyMDlh
NWY2OGM5M2VhZGU4ZGU1OGJkIHJldXNlIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEt
MDkyOC85YjU2NWE4MDUxYjM4OWUwNDYyMDlhNWY2OGM5M2VhZGU4ZGU1OGJkL3ZtbGludXot
My4xMi4wLXJjMi0wMDE1Mi1nOWI1NjVhOAoKMjAxMy0xMC0wMi0yMjozNzozNiBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuCTEuCTgJMTUJMjcJNDMJNjcJNzcJODEJOTAJMTAyCTEwOAkxMjEJ
MTI3CTEzNgkxNDQJMTU2CTE2NwkxNzEJMTkxCTIwMgkyMTEJMjIxCTIzOAkyNTkJMjcyCTI4
NQkzMDEJMzE1CTMyNQkzNDQJMzU1CTM1NwkzNjgJMzY5CTM3MQkzNzIJMzc2CTM3OS4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTM4MAkzODEuLi4uCTM4Mi4u
Li4uLgkzODMuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19y
dW5fcXVldWUgMhtbMG0KLi4uCTM4NSBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDli
NTY1YTgwNTFiMzg5ZTA0NjIwOWE1ZjY4YzkzZWFkZThkZTU4YmQKZ2l0IGJpc2VjdCBzdGFy
dCAxNDk1MWYyMmYxY2M4Mzc1ZWFkMzQ1ZDJjYTA4NDU1ZTkxZjIxNTJiIDliNTY1YTgwNTFi
Mzg5ZTA0NjIwOWE1ZjY4YzkzZWFkZThkZTU4YmQgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlv
biB3YXMgOWI1NjVhOC4uLiBNZXJnZSBicmFuY2ggJ3BlcmYtdXJnZW50LWZvci1saW51cycg
b2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90
aXAKSEVBRCBpcyBub3cgYXQgYzFiZTVhNS4uLiBMaW51eCAzLjkKMTQ5NTFmMjJmMWNjODM3
NWVhZDM0NWQyY2EwODQ1NWU5MWYyMTUyYiBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21t
aXQgMTQ5NTFmMjJmMWNjODM3NWVhZDM0NWQyY2EwODQ1NWU5MWYyMTUyYgpBdXRob3I6IElu
Z28gTW9sbmFyIDxtaW5nb0BrZXJuZWwub3JnPgpEYXRlOiAgIFN1biBTZXAgMjkgMTY6MTI6
NTQgMjAxMyArMDIwMAoKICAgIFJldmVydCAicGVyZiBzeW1ib2xzOiBEZW1hbmdsZSBjbG9u
ZWQgZnVuY3Rpb25zIgogICAgCiAgICBUaGlzIHJldmVydHMgY29tbWl0IGRlOTVhYjUzNjQ1
YTJmMDAxNWUwZjY4ZWU3MjNmMThkY2UyYjhiNTEuCiAgICAKICAgIE1hcmt1cyBUcmlwcGVs
c2RvcmYgcmVwb3J0ZWQgdGhhdCB0aGlzIGNvbW1pdCBicm9rZSAncGVyZiB0b3AnOgogICAg
CiAgICAgPiBJIGp1c3Qgc2VlIGEgZ3JheSBzY3JlZW4gd2l0aCBubyB0ZXh0IGF0IGFsbC4g
U29tZXRpbWVzIHRoZQogICAgID4gZm9sbG93aW5nIGVycm9yIG1lc3NhZ2VzIGFyZSBwcmlu
dGVkOgogICAgID4KICAgICA+ICAqKiogRXJyb3IgaW4gYHBlcmYnOiBpbnZhbGlkIGZhc3Ri
aW4gZW50cnkgKGZyZWUpOiAweDAwMDAwMDAwMDI5YjE4YzAKICAgICA+ICAqKioKICAgICA+
ICAqKiogRXJyb3IgaW4gYHBlcmYnOiBtYWxsb2MoKTogbWVtb3J5IGNvcnJ1cHRpb24gKGZh
c3QpOiAweDAwMDAwMDAwMDBlZTBiMTAgKioqCiAgICAKICAgIFdoaWxlIHRoaXMgY29kZSBp
cyBmaXhhYmxlLCB0aGUgY29tbWl0IGl0c2VsZiBmYWlscyBvbiBzZXZlcmFsIGxldmVsczoK
ICAgIAogICAgIC0gaXQgc2hvdWxkIGhhdmUgYmVlbiBhIHNlcGFyYXRlIGhlbHBlciBmdW5j
dGlvbgogICAgIC0gd2h5IHRoZSBoZWNrIGRvZXMgaXQgZG8gc3RyY2hyKCkgdHdpY2UKICAg
ICAtIGl0IGNhc3RzIGEgY29uc3QgY2hhciAqIG92ZXIgaW50byBjaGFyICoKICAgICAtIHNs
b3BweSBzdHlsZQogICAgIC0gaXQncyBub3QgZXZlbiBhIHJlZ3Jlc3Npb24gZml4IQogICAg
CiAgICBTbyBsZXRzIHJldmVydCBpdCBhbmQgcmUtdHJ5IHRoZSBwYXRjaCBpbiB2My4xMy4K
ICAgIAogICAgUmVwb3J0ZWQtYnk6IE1hcmt1cyBUcmlwcGVsc2RvcmYgPG1hcmt1c0B0cmlw
cGVsc2RvcmYuZGU+CiAgICBDYzogQW5kaSBLbGVlbiA8YWtAbGludXguaW50ZWwuY29tPgog
ICAgQ2M6IFBldGVyIFppamxzdHJhIDxhLnAuemlqbHN0cmFAY2hlbGxvLm5sPgogICAgQ2M6
IEFybmFsZG8gQ2FydmFsaG8gZGUgTWVsbyA8YWNtZUByZWRoYXQuY29tPgogICAgQ2M6IExp
bnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4KICAgIFNpZ25l
ZC1vZmYtYnk6IEluZ28gTW9sbmFyIDxtaW5nb0BrZXJuZWwub3JnPgoKOjA0MDAwMCAwNDAw
MDAgMjMzMTA1YTQwZDIyZTAzNjBkMTYwYWE1N2E5OGEyMGQzZGQ1MTUxYyBjNTk5OGMwYmU1
MThiOWQwYzYyNGUyODEwZDcyOWNiODA3YjFmZjlmIE0JdG9vbHMKZ2l0IGJpc2VjdCBydW4g
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
ZHJtL29iai1iaXNlY3QKWW91IG5lZWQgdG8gc3RhcnQgYnkgImdpdCBiaXNlY3Qgc3RhcnQi
LgpZb3UgdGhlbiBuZWVkIHRvIGdpdmUgbWUgYXQgbGVhc3Qgb25lIGdvb2QgYW5kIG9uZSBi
YWQgcmV2aXNpb25zLgooWW91IGNhbiB1c2UgImdpdCBiaXNlY3QgYmFkIiBhbmQgImdpdCBi
aXNlY3QgZ29vZCIgZm9yIHRoYXQuKQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC90aXA6cGVyZjp1cmdlbnQ6OWI1NjVhODA1
MWIzODllMDQ2MjA5YTVmNjhjOTNlYWRlOGRlNThiZDpiaXNlY3QtZHJtCgoyMDEzLTEwLTAz
LTAyOjI1OjIwIDliNTY1YTgwNTFiMzg5ZTA0NjIwOWE1ZjY4YzkzZWFkZThkZTU4YmQgcmV1
c2UgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4LzliNTY1YTgwNTFiMzg5ZTA0
NjIwOWE1ZjY4YzkzZWFkZThkZTU4YmQvdm1saW51ei0zLjEyLjAtcmMyLTAwMTUyLWc5YjU2
NWE4CgoyMDEzLTEwLTAzLTAyOjI1OjIyIGRldGVjdGluZyBib290IHN0YXRlIC4JMS4JNAkx
MwkxNQkyNQkzMAkzMwk0MQk0OAk2MQk2NQk2OQk3Nwk4Ngk4OQk5Mwk5NAk5Ni4JMTA4CTEx
MgkxMjMJMTI1CTEyOQkxMzkJMTQ1CTE1MAkxNTMJMTU3CTE2MgkxNjQJMTY3CTE3MQkxNzgJ
MTgxCTE4NgkxODkuCTE5MAkxOTEJMTk2CTIwMAkyMDMJMjExCTIxMgkyMjIJMjMxCTIzNgky
NDIJMjUxCTI1MgkyNjEJMjY3CTI3NAkyNzkJMjgzCTI4NwkyOTIJMjk0CTI5OAkzMDIJMzA1
CTMwOQkzMTMJMzE1CTMxOAkzMjEJMzI2CTMyNy4JMzI5Li4uCTMzOAkzNTMJMzU3CTM2NAkz
NzAJMzcyCTM4NQkzOTQJNDAyCTQxOAk0MjMJNDMzCTQzOQk0NDMJNDUzCTQ2MAk0NjYJNDcx
IFRFU1QgRkFJTFVSRQobWzE7MzVtSW5jcmVhc2luZyByZXBlYXQgY291bnQgZnJvbSAxMTU1
IHRvIDM1NTUbWzBtClsgICA5NS41OTI3ODZdIFNjYW5uaW5nIGRldmljZSBmb3IgYmFkIGJs
b2NrcwpbICAgOTYuMzEyODA5XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0t
LS0KWyAgIDk2LjMxNTA5Nl0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCBrZXJuZWwvd29y
a3F1ZXVlLmM6NTkzIHNldF93b3JrX2RhdGErMHgzMy8weDUwKCkKWyAgIDk2LjMxNjM3M10g
Q1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMi4wLXJjMi0w
MDE1Mi1nOWI1NjVhOCAjMTMwClsgICA5Ni4zMTYzNzNdICAwMDAwMDAwMDAwMDAwMDAwIGZm
ZmY4ODAwMGYwMDNkODAgZmZmZmZmZmY4MTg0ZDVmZSAwMDAwMDAwMDAwMDAwMDAwClsgICA5
Ni4zMTYzNzNdICBmZmZmODgwMDBmMDAzZGI4IGZmZmZmZmZmODEwOGZhNjYgZmZmZmZmZmY4
MTA5ZTQxMSBmZmZmODgwMDBjYzdmODYwClsgICA5Ni4zMTYzNzNdICBmZmZmODgwMDBmMDEz
NDAwIDAwMDAwMDAwMDAwMDAwMDUgZmZmZjg4MDAwZjAxMTY0MCBmZmZmODgwMDBmMDAzZGM4
ClsgICA5Ni4zMTYzNzNdIENhbGwgVHJhY2U6ClsgICA5Ni4zMTYzNzNdICA8SVJRPiAgWzxm
ZmZmZmZmZjgxODRkNWZlPl0gZHVtcF9zdGFjaysweDRlLzB4ODIKWyAgIDk2LjMxNjM3M10g
IFs8ZmZmZmZmZmY4MTA4ZmE2Nj5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NzAvMHg4OQpb
ICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxMDllNDExPl0gPyBzZXRfd29ya19kYXRhKzB4
MzMvMHg1MApbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxMDhmYjQxPl0gd2Fybl9zbG93
cGF0aF9udWxsKzB4MTUvMHgxNwpbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxMDllNDEx
Pl0gc2V0X3dvcmtfZGF0YSsweDMzLzB4NTAKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4
MTA5ZjEyNz5dIGluc2VydF93b3JrKzB4MjcvMHg2NQpbICAgOTYuMzE2MzczXSAgWzxmZmZm
ZmZmZjgxMDlmMzM0Pl0gX19xdWV1ZV93b3JrKzB4MWNmLzB4MWVlClsgICA5Ni4zMTYzNzNd
ICBbPGZmZmZmZmZmODEwOWYzNTM+XSA/IF9fcXVldWVfd29yaysweDFlZS8weDFlZQpbICAg
OTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxMDlmMzZjPl0gZGVsYXllZF93b3JrX3RpbWVyX2Zu
KzB4MTkvMHgxYgpbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxMDk2NWI4Pl0gY2FsbF90
aW1lcl9mbisweDZjLzB4ZGYKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTA5NjU0Yz5d
ID8gcHJvY2Vzc190aW1lb3V0KzB4Yi8weGIKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4
MTA5ZjM1Mz5dID8gX19xdWV1ZV93b3JrKzB4MWVlLzB4MWVlClsgICA5Ni4zMTYzNzNdICBb
PGZmZmZmZmZmODEwOTZjYzc+XSBydW5fdGltZXJfc29mdGlycSsweDE3MC8weDFiOApbICAg
OTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxMDkzMGNhPl0gX19kb19zb2Z0aXJxKzB4YzgvMHgx
OGQKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTA5MzJhND5dIGlycV9leGl0KzB4NTYv
MHg5NwpbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxMDJiODMxPl0gZG9fSVJRKzB4ODgv
MHg5ZgpbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxODU4OTMyPl0gY29tbW9uX2ludGVy
cnVwdCsweDcyLzB4NzIKWyAgIDk2LjMxNjM3M10gIDxFT0k+ICBbPGZmZmZmZmZmODEwYWYy
ZDk+XSA/IF9fd2FrZV91cCsweDFkLzB4NDYKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4
MTBkMWI4ZD5dID8gYXJjaF9sb2NhbF9pcnFfcmVzdG9yZSsweDYvMHhkClsgICA5Ni4zMTYz
NzNdICBbPGZmZmZmZmZmODE4NTdlMzg+XSBfcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUr
MHg0OC8weDc1ClsgICA5Ni4zMTYzNzNdICBbPGZmZmZmZmZmODEwYWYyZmI+XSBfX3dha2Vf
dXArMHgzZi8weDQ2ClsgICA5Ni4zMTYzNzNdICBbPGZmZmZmZmZmODE0ZGNkMzg+XSBuYW5k
X3JlbGVhc2VfZGV2aWNlLmlzcmEuMTYrMHg0OS8weDU4ClsgICA5Ni4zMTYzNzNdICBbPGZm
ZmZmZmZmODE0ZGRhYTk+XSBuYW5kX3JlYWRfb29iKzB4MjU3LzB4MjcwClsgICA5Ni4zMTYz
NzNdICBbPGZmZmZmZmZmODEwYWYyZDk+XSA/IF9fd2FrZV91cCsweDFkLzB4NDYKWyAgIDk2
LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTRjNjk2OD5dIG10ZF9yZWFkX29vYisweDI2LzB4NGMK
WyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTRlMDRkND5dIGNyZWF0ZV9iYnQrMHgyMGYv
MHgyOWEKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTRlMDVkZT5dIG5hbmRfc2Nhbl9i
YnQrMHg3Zi8weDRkZApbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxMDhmYzcyPl0gPyBw
dXRfb25saW5lX2NwdXMrMHgyNC8weDZiClsgICA5Ni4zMTYzNzNdICBbPGZmZmZmZmZmODE0
ZTBiMWI+XSBuYW5kX2RlZmF1bHRfYmJ0KzB4ZGYvMHhlNApbICAgOTYuMzE2MzczXSAgWzxm
ZmZmZmZmZjgxZTRjODVjPl0gbnNfaW5pdF9tb2R1bGUrMHg1NjkvMHhjZjMKWyAgIDk2LjMx
NjM3M10gIFs8ZmZmZmZmZmY4MTIyNjFhMT5dID8gZnJlZV9ycysweDc1LzB4NzgKWyAgIDk2
LjMxNjM3M10gIFs8ZmZmZmZmZmY4MWU0YzJmMz5dID8gbmZ0bF9zY2FuX2JidCsweDMxMi8w
eDMxMgpbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxZTIyZGQ0Pl0gZG9fb25lX2luaXRj
YWxsKzB4OGUvMHgxMzIKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTBiYjYwMD5dID8g
Y29uc29sZV91bmxvY2srMHgyZTcvMHgzNWIKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4
MTBiYjYyYj5dID8gY29uc29sZV91bmxvY2srMHgzMTIvMHgzNWIKWyAgIDk2LjMxNjM3M10g
IFs8ZmZmZmZmZmY4MWUyMmZjYz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTU0LzB4MWQw
ClsgICA5Ni4zMTYzNzNdICBbPGZmZmZmZmZmODFlMjI2ZGE+XSA/IGRvX2Vhcmx5X3BhcmFt
KzB4ODgvMHg4OApbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxODQ3MzA5Pl0gPyByZXN0
X2luaXQrMHhiZC8weGJkClsgICA5Ni4zMTYzNzNdICBbPGZmZmZmZmZmODE4NDczMTI+XSBr
ZXJuZWxfaW5pdCsweDkvMHhjYwpbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxODU5MTRj
Pl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4
MTg0NzMwOT5dID8gcmVzdF9pbml0KzB4YmQvMHhiZApbICAgOTYuMzE2MzczXSAtLS1bIGVu
ZCB0cmFjZSBjMmVjYTU1NjFlOTIzZTYwIF0tLS0KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy14MS0wOTI4LzliNTY1YTgwNTFiMzg5ZTA0NjIwOWE1ZjY4YzkzZWFkZThkZTU4YmQvZG1l
c2cteW9jdG8td2FpbWVhLTQ6MjAxMzEwMDMxMTA4MTc6My4xMi4wLXJjMi0wMDE1Mi1nOWI1
NjVhODoxMzAKChtbMTszNW1iYWQgYmlzZWN0LCByZXRyeSB3aXRoIGluY3JlYXNlZCByZXBl
YXQgY291bnQgMTE1NRtbMG0KZ2l0IGNoZWNrb3V0IDliNTY1YTgwNTFiMzg5ZTA0NjIwOWE1
ZjY4YzkzZWFkZThkZTU4YmQKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMTQ5NTFmMi4u
LiBSZXZlcnQgInBlcmYgc3ltYm9sczogRGVtYW5nbGUgY2xvbmVkIGZ1bmN0aW9ucyIKSEVB
RCBpcyBub3cgYXQgOWI1NjVhOC4uLiBNZXJnZSBicmFuY2ggJ3BlcmYtdXJnZW50LWZvci1s
aW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L3RpcC90aXAKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLXgxLTA5MjgvdGlwOnBlcmY6dXJnZW50OjliNTY1YTgwNTFiMzg5ZTA0NjIwOWE1
ZjY4YzkzZWFkZThkZTU4YmQ6YmlzZWN0LWRybQogVEVTVCBGQUlMVVJFClsgICA5NS41OTI3
ODZdIFNjYW5uaW5nIGRldmljZSBmb3IgYmFkIGJsb2NrcwpbICAgOTYuMzEyODA5XSAtLS0t
LS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgIDk2LjMxNTA5Nl0gV0FSTklO
RzogQ1BVOiAwIFBJRDogMSBhdCBrZXJuZWwvd29ya3F1ZXVlLmM6NTkzIHNldF93b3JrX2Rh
dGErMHgzMy8weDUwKCkKWyAgIDk2LjMxNjM3M10gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2Fw
cGVyLzAgTm90IHRhaW50ZWQgMy4xMi4wLXJjMi0wMDE1Mi1nOWI1NjVhOCAjMTMwClsgICA5
Ni4zMTYzNzNdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGYwMDNkODAgZmZmZmZmZmY4
MTg0ZDVmZSAwMDAwMDAwMDAwMDAwMDAwClsgICA5Ni4zMTYzNzNdICBmZmZmODgwMDBmMDAz
ZGI4IGZmZmZmZmZmODEwOGZhNjYgZmZmZmZmZmY4MTA5ZTQxMSBmZmZmODgwMDBjYzdmODYw
ClsgICA5Ni4zMTYzNzNdICBmZmZmODgwMDBmMDEzNDAwIDAwMDAwMDAwMDAwMDAwMDUgZmZm
Zjg4MDAwZjAxMTY0MCBmZmZmODgwMDBmMDAzZGM4ClsgICA5Ni4zMTYzNzNdIENhbGwgVHJh
Y2U6ClsgICA5Ni4zMTYzNzNdICA8SVJRPiAgWzxmZmZmZmZmZjgxODRkNWZlPl0gZHVtcF9z
dGFjaysweDRlLzB4ODIKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTA4ZmE2Nj5dIHdh
cm5fc2xvd3BhdGhfY29tbW9uKzB4NzAvMHg4OQpbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZm
ZjgxMDllNDExPl0gPyBzZXRfd29ya19kYXRhKzB4MzMvMHg1MApbICAgOTYuMzE2MzczXSAg
WzxmZmZmZmZmZjgxMDhmYjQxPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MTUvMHgxNwpbICAg
OTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxMDllNDExPl0gc2V0X3dvcmtfZGF0YSsweDMzLzB4
NTAKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTA5ZjEyNz5dIGluc2VydF93b3JrKzB4
MjcvMHg2NQpbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxMDlmMzM0Pl0gX19xdWV1ZV93
b3JrKzB4MWNmLzB4MWVlClsgICA5Ni4zMTYzNzNdICBbPGZmZmZmZmZmODEwOWYzNTM+XSA/
IF9fcXVldWVfd29yaysweDFlZS8weDFlZQpbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgx
MDlmMzZjPl0gZGVsYXllZF93b3JrX3RpbWVyX2ZuKzB4MTkvMHgxYgpbICAgOTYuMzE2Mzcz
XSAgWzxmZmZmZmZmZjgxMDk2NWI4Pl0gY2FsbF90aW1lcl9mbisweDZjLzB4ZGYKWyAgIDk2
LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTA5NjU0Yz5dID8gcHJvY2Vzc190aW1lb3V0KzB4Yi8w
eGIKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTA5ZjM1Mz5dID8gX19xdWV1ZV93b3Jr
KzB4MWVlLzB4MWVlClsgICA5Ni4zMTYzNzNdICBbPGZmZmZmZmZmODEwOTZjYzc+XSBydW5f
dGltZXJfc29mdGlycSsweDE3MC8weDFiOApbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgx
MDkzMGNhPl0gX19kb19zb2Z0aXJxKzB4YzgvMHgxOGQKWyAgIDk2LjMxNjM3M10gIFs8ZmZm
ZmZmZmY4MTA5MzJhND5dIGlycV9leGl0KzB4NTYvMHg5NwpbICAgOTYuMzE2MzczXSAgWzxm
ZmZmZmZmZjgxMDJiODMxPl0gZG9fSVJRKzB4ODgvMHg5ZgpbICAgOTYuMzE2MzczXSAgWzxm
ZmZmZmZmZjgxODU4OTMyPl0gY29tbW9uX2ludGVycnVwdCsweDcyLzB4NzIKWyAgIDk2LjMx
NjM3M10gIDxFT0k+ICBbPGZmZmZmZmZmODEwYWYyZDk+XSA/IF9fd2FrZV91cCsweDFkLzB4
NDYKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTBkMWI4ZD5dID8gYXJjaF9sb2NhbF9p
cnFfcmVzdG9yZSsweDYvMHhkClsgICA5Ni4zMTYzNzNdICBbPGZmZmZmZmZmODE4NTdlMzg+
XSBfcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUrMHg0OC8weDc1ClsgICA5Ni4zMTYzNzNd
ICBbPGZmZmZmZmZmODEwYWYyZmI+XSBfX3dha2VfdXArMHgzZi8weDQ2ClsgICA5Ni4zMTYz
NzNdICBbPGZmZmZmZmZmODE0ZGNkMzg+XSBuYW5kX3JlbGVhc2VfZGV2aWNlLmlzcmEuMTYr
MHg0OS8weDU4ClsgICA5Ni4zMTYzNzNdICBbPGZmZmZmZmZmODE0ZGRhYTk+XSBuYW5kX3Jl
YWRfb29iKzB4MjU3LzB4MjcwClsgICA5Ni4zMTYzNzNdICBbPGZmZmZmZmZmODEwYWYyZDk+
XSA/IF9fd2FrZV91cCsweDFkLzB4NDYKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTRj
Njk2OD5dIG10ZF9yZWFkX29vYisweDI2LzB4NGMKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZm
ZmY4MTRlMDRkND5dIGNyZWF0ZV9iYnQrMHgyMGYvMHgyOWEKWyAgIDk2LjMxNjM3M10gIFs8
ZmZmZmZmZmY4MTRlMDVkZT5dIG5hbmRfc2Nhbl9iYnQrMHg3Zi8weDRkZApbICAgOTYuMzE2
MzczXSAgWzxmZmZmZmZmZjgxMDhmYzcyPl0gPyBwdXRfb25saW5lX2NwdXMrMHgyNC8weDZi
ClsgICA5Ni4zMTYzNzNdICBbPGZmZmZmZmZmODE0ZTBiMWI+XSBuYW5kX2RlZmF1bHRfYmJ0
KzB4ZGYvMHhlNApbICAgOTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxZTRjODVjPl0gbnNfaW5p
dF9tb2R1bGUrMHg1NjkvMHhjZjMKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTIyNjFh
MT5dID8gZnJlZV9ycysweDc1LzB4NzgKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MWU0
YzJmMz5dID8gbmZ0bF9zY2FuX2JidCsweDMxMi8weDMxMgpbICAgOTYuMzE2MzczXSAgWzxm
ZmZmZmZmZjgxZTIyZGQ0Pl0gZG9fb25lX2luaXRjYWxsKzB4OGUvMHgxMzIKWyAgIDk2LjMx
NjM3M10gIFs8ZmZmZmZmZmY4MTBiYjYwMD5dID8gY29uc29sZV91bmxvY2srMHgyZTcvMHgz
NWIKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTBiYjYyYj5dID8gY29uc29sZV91bmxv
Y2srMHgzMTIvMHgzNWIKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MWUyMmZjYz5dIGtl
cm5lbF9pbml0X2ZyZWVhYmxlKzB4MTU0LzB4MWQwClsgICA5Ni4zMTYzNzNdICBbPGZmZmZm
ZmZmODFlMjI2ZGE+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgOTYuMzE2Mzcz
XSAgWzxmZmZmZmZmZjgxODQ3MzA5Pl0gPyByZXN0X2luaXQrMHhiZC8weGJkClsgICA5Ni4z
MTYzNzNdICBbPGZmZmZmZmZmODE4NDczMTI+XSBrZXJuZWxfaW5pdCsweDkvMHhjYwpbICAg
OTYuMzE2MzczXSAgWzxmZmZmZmZmZjgxODU5MTRjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4
YjAKWyAgIDk2LjMxNjM3M10gIFs8ZmZmZmZmZmY4MTg0NzMwOT5dID8gcmVzdF9pbml0KzB4
YmQvMHhiZApbICAgOTYuMzE2MzczXSAtLS1bIGVuZCB0cmFjZSBjMmVjYTU1NjFlOTIzZTYw
IF0tLS0KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4LzliNTY1YTgwNTFiMzg5
ZTA0NjIwOWE1ZjY4YzkzZWFkZThkZTU4YmQvZG1lc2cteW9jdG8td2FpbWVhLTQ6MjAxMzEw
MDMxMTA4MTc6My4xMi4wLXJjMi0wMDE1Mi1nOWI1NjVhODoxMzAKCmJpc2VjdDogYmFkIGNv
bW1pdCA5YjU2NWE4MDUxYjM4OWUwNDYyMDlhNWY2OGM5M2VhZGU4ZGU1OGJkCmdpdCBjaGVj
a291dCB2My4xMQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA5YjU2NWE4Li4uIE1lcmdl
IGJyYW5jaCAncGVyZi11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApIRUFEIGlzIG5vdyBhdCA2ZTQ2
NjQ1Li4uIExpbnV4IDMuMTEKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvdGlwOnBlcmY6dXJnZW50OjZlNDY2NDUyNWIxZGIy
OGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2U6YmlzZWN0LWRybQoKMjAxMy0xMC0wMy0wMzox
MjozNiA2ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlIHJldXNlIC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTEx
MzA5NTdmNzBhOTRjMTkyMTNlL3ZtbGludXotMy4xMS4wCgoyMDEzLTEwLTAzLTAzOjEyOjQx
IGRldGVjdGluZyBib290IHN0YXRlIC4uCTEwMQkxMDkJMTE1CTEyMwkxMjUJMTMwCTEzNQkx
NDMJMTUxCTE1NAkxNTYJMTYyCTE2NAkxNjcJMTcxCTE3NAkxNzkJMTgyCTE5MwkyMDEJMjA0
CTIwOAkyMTMJMjE1CTIxOAkyMjAJMjIzCTIyOQkyMzIJMjMzCTIzNQkyNDAJMjQ2CTI0OAky
NDkJMjUxCTI1MgkyNTgJMjY3CTI4MgkyOTUJMzEyCTMxNgkzMzgJMzUwCTM3NQk0MDAJNDEw
CTQxMwk0NTcJNDU5CTQ3OAk0ODYJNTIwCTUzNgk1NDgJNTYzCTU2NQk1OTAJNTk3CTYyMQk2
MzgJNjQ2CTY0Nwk2NjgJNjg1CTY5Ngk3MDUJNzE0CTcxNwk3MjQJNzU2CTc5Mwk3OTgJODQ0
CTg3Mgk5MjAJOTM2CTk3MgkxMDAzCTEwNDUJMTA2MQkxMDc0CTExMTIJMTExOQkxMTM3CTEx
NzMJMTE3NwkxMjQzCTEyODUJMTMxOAkxMzU4CTEzODYJMTQxMQkxNDQ4CTE0NjQuCTE0NjgJ
MTQ5OQkxNTAyCTE1MDcJMTY1MAkxNjcyCTE2OTEJMTczMgkxNzYzCTE3OTgJMTgyNAkxODM0
CTE4NDYJMTg2MQkxODg3CTE4OTUJMTkyNAkxOTI3CTE5NzkJMTk5OQkyMDMyCTIwOTYJMjEx
MQkyMTY2CTIxOTIJMjE5OQkyMjMxCTIyNTgJMjI4NwkyMzUxCTIzNjUJMjM5MwkyNDQ0CTI0
NzAJMjQ3NQkyNTEwCTI1NDMJMjU3NQkyNjIwCTI2NTAJMjY3MgkyNzE2CTI3NzQJMjgwNAky
ODM4CTI4OTIJMjkzMAkyOTQ5CTI5ODQJMzAwNwkzMDQzCTMwNDgJMzA3NAkzMTUxCTMxODEJ
MzIyNQkzMjQ1CTMyOTQJMzMxNAkzMzQyCTMzOTgJMzQzNwkzNDk2CTM1MDYJMzUxMC4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA0NRtb
MG0KLi4uCTM1MTMJMzUxNAkzNTIxCTM1MjYJMzUzNAkzNTQwCTM1NDUJMzU1MQkzNTU1IFNV
Q0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgdjMuMTEKZ2l0IGJpc2VjdCBzdGFydCA5YjU2
NWE4MDUxYjM4OWUwNDYyMDlhNWY2OGM5M2VhZGU4ZGU1OGJkIHYzLjExIC0tCkJpc2VjdGlu
ZzogNTYzOSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIg
c3RlcHMpCls1N2Q3MzA5MjRkNWNjMmMzZTI4MGFmMTZhOTMwNjU4N2MzYTUxMWRiXSBNZXJn
ZSBicmFuY2ggJ3RpbWVycy11cmdlbnQtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApnaXQgYmlzZWN0IHJ1biAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9k
cm0vb2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L3RpcDpwZXJmOnVy
Z2VudDo1N2Q3MzA5MjRkNWNjMmMzZTI4MGFmMTZhOTMwNjU4N2MzYTUxMWRiOmJpc2VjdC1k
cm0KCjIwMTMtMTAtMDMtMDc6MTE6MjIgNTdkNzMwOTI0ZDVjYzJjM2UyODBhZjE2YTkzMDY1
ODdjM2E1MTFkYiBjb21waWxpbmcKMzM4IHJlYWwgIDE4NDIgdXNlciAgNTAxIHN5cyAgNjky
Ljc4JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgKCjIwMTMtMTAtMDMtMDc6MTg6
MDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLTA1MDU4LWc1N2Q3MzA5LgkxCTUJOQkx
MAkxNwkxOAkxOQkyMgkyNAkyOAkzNQk0Nwk1Mwk1OAk2Mwk3MQk4Mwk5Mwk5NwkxMTIJMTE3
CTEzMCBURVNUIEZBSUxVUkUKWyAgIDE4LjE1ODY2MV0gU2Nhbm5pbmcgZGV2aWNlIGZvciBi
YWQgYmxvY2tzClsgICAxOC42MzEzNjFdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0t
LS0tLS0tLQpbICAgMTguNjM0OTQwXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IC9jL3dm
Zy9saW51eC1kcm0va2VybmVsL3dvcmtxdWV1ZS5jOjU5MSBzZXRfd29ya19kYXRhKzB4MzMv
MHg1MCgpClsgICAxOC42MzQ5NDBdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5v
dCB0YWludGVkIDMuMTEuMC0wNTA1OC1nNTdkNzMwOSAjMTQ2ClsgICAxOC42MzQ5NDBdICAw
MDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGYwMDNkODAgZmZmZmZmZmY4MTg0MzkwMyAwMDAw
MDAwMDAwMDAwMDAwClsgICAxOC42MzQ5NDBdICBmZmZmODgwMDBmMDAzZGI4IGZmZmZmZmZm
ODEwOGZhNTMgZmZmZmZmZmY4MTA5ZTM3OSBmZmZmODgwMDBjYzgwODYwClsgICAxOC42MzQ5
NDBdICBmZmZmODgwMDBmMDEzNDAwIDAwMDAwMDAwMDAwMDAwMDUgZmZmZjg4MDAwZjAxMTYw
MCBmZmZmODgwMDBmMDAzZGM4ClsgICAxOC42MzQ5NDBdIENhbGwgVHJhY2U6ClsgICAxOC42
MzQ5NDBdICA8SVJRPiAgWzxmZmZmZmZmZjgxODQzOTAzPl0gZHVtcF9zdGFjaysweDRlLzB4
ODIKWyAgIDE4LjYzNDk0MF0gIFs8ZmZmZmZmZmY4MTA4ZmE1Mz5dIHdhcm5fc2xvd3BhdGhf
Y29tbW9uKzB4NzAvMHg4OQpbICAgMTguNjM0OTQwXSAgWzxmZmZmZmZmZjgxMDllMzc5Pl0g
PyBzZXRfd29ya19kYXRhKzB4MzMvMHg1MApbICAgMTguNjM0OTQwXSAgWzxmZmZmZmZmZjgx
MDhmYjJlPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MTUvMHgxNwpbICAgMTguNjM0OTQwXSAg
WzxmZmZmZmZmZjgxMDllMzc5Pl0gc2V0X3dvcmtfZGF0YSsweDMzLzB4NTAKWyAgIDE4LjYz
NDk0MF0gIFs8ZmZmZmZmZmY4MTA5ZjA4Zj5dIGluc2VydF93b3JrKzB4MjcvMHg2NQpbICAg
MTguNjM0OTQwXSAgWzxmZmZmZmZmZjgxMDlmMjljPl0gX19xdWV1ZV93b3JrKzB4MWNmLzB4
MWVlClsgICAxOC42MzQ5NDBdICBbPGZmZmZmZmZmODEwOWYyYmI+XSA/IF9fcXVldWVfd29y
aysweDFlZS8weDFlZQpbICAgMTguNjM0OTQwXSAgWzxmZmZmZmZmZjgxMDlmMmQ0Pl0gZGVs
YXllZF93b3JrX3RpbWVyX2ZuKzB4MTkvMHgxYgpbICAgMTguNjM0OTQwXSAgWzxmZmZmZmZm
ZjgxMDk2NTkzPl0gY2FsbF90aW1lcl9mbisweDZjLzB4ZGYKWyAgIDE4LjYzNDk0MF0gIFs8
ZmZmZmZmZmY4MTA5NjUyNz5dID8gcHJvY2Vzc190aW1lb3V0KzB4Yi8weGIKWyAgIDE4LjYz
NDk0MF0gIFs8ZmZmZmZmZmY4MTA5ZjJiYj5dID8gX19xdWV1ZV93b3JrKzB4MWVlLzB4MWVl
ClsgICAxOC42MzQ5NDBdICBbPGZmZmZmZmZmODEwOTZjYTI+XSBydW5fdGltZXJfc29mdGly
cSsweDE3MC8weDFiOApbICAgMTguNjM0OTQwXSAgWzxmZmZmZmZmZjgxMDkzMGFhPl0gX19k
b19zb2Z0aXJxKzB4YzgvMHgxOGQKWyAgIDE4LjYzNDk0MF0gIFs8ZmZmZmZmZmY4MTA5MzI4
ND5dIGlycV9leGl0KzB4NTYvMHg5NwpbICAgMTguNjM0OTQwXSAgWzxmZmZmZmZmZjgxMDJi
N2VjPl0gZG9fSVJRKzB4ODgvMHg5ZgpbICAgMTguNjM0OTQwXSAgWzxmZmZmZmZmZjgxODRl
NzcyPl0gY29tbW9uX2ludGVycnVwdCsweDcyLzB4NzIKWyAgIDE4LjYzNDk0MF0gIDxFT0k+
ICBbPGZmZmZmZmZmODEwYWYyNDQ+XSA/IF9fd2FrZV91cCsweDFkLzB4NDYKWyAgIDE4LjYz
NDk0MF0gIFs8ZmZmZmZmZmY4MTBjY2Q3Nj5dID8gYXJjaF9sb2NhbF9pcnFfcmVzdG9yZSsw
eDYvMHhkClsgICAxOC42MzQ5NDBdICBbPGZmZmZmZmZmODE4NGRjNzg+XSBfcmF3X3NwaW5f
dW5sb2NrX2lycXJlc3RvcmUrMHg0OC8weDc1ClsgICAxOC42MzQ5NDBdICBbPGZmZmZmZmZm
ODEwYWYyNjY+XSBfX3dha2VfdXArMHgzZi8weDQ2ClsgICAxOC42MzQ5NDBdICBbPGZmZmZm
ZmZmODE0ZDczNGI+XSBuYW5kX3JlbGVhc2VfZGV2aWNlLmlzcmEuMTMrMHg0OS8weDU4Clsg
ICAxOC42MzQ5NDBdICBbPGZmZmZmZmZmODE0ZDgwODQ+XSBuYW5kX3JlYWRfb29iKzB4MjU3
LzB4MjcwClsgICAxOC42MzQ5NDBdICBbPGZmZmZmZmZmODE0YzEwMzc+XSBtdGRfcmVhZF9v
b2IrMHgyNi8weDRjClsgICAxOC42MzQ5NDBdICBbPGZmZmZmZmZmODE0ZGE2MTE+XSBjcmVh
dGVfYmJ0KzB4MjI1LzB4MmQ0ClsgICAxOC42MzQ5NDBdICBbPGZmZmZmZmZmODE0ZGFiY2I+
XSBuYW5kX3NjYW5fYmJ0KzB4ODUvMHg0ZTMKWyAgIDE4LjYzNDk0MF0gIFs8ZmZmZmZmZmY4
MTExOTRjMj5dID8gX19rbWFsbG9jKzB4OTAvMHhiYgpbICAgMTguNjM0OTQwXSAgWzxmZmZm
ZmZmZjgxNGRiMTA4Pl0gbmFuZF9kZWZhdWx0X2JidCsweGRmLzB4ZTQKWyAgIDE4LjYzNDk0
MF0gIFs8ZmZmZmZmZmY4MWUzODQ0Yz5dIG5zX2luaXRfbW9kdWxlKzB4NTc2LzB4ZDYxClsg
ICAxOC42MzQ5NDBdICBbPGZmZmZmZmZmODE4NGMwNzk+XSA/IG11dGV4X3VubG9jaysweDkv
MHhiClsgICAxOC42MzQ5NDBdICBbPGZmZmZmZmZmODFlMzdlZDY+XSA/IGluaXRfbmFuZGRv
YysweGM4LzB4YzgKWyAgIDE4LjYzNDk0MF0gIFs8ZmZmZmZmZmY4MWUwZWRkND5dIGRvX29u
ZV9pbml0Y2FsbCsweDhlLzB4MTMyClsgICAxOC42MzQ5NDBdICBbPGZmZmZmZmZmODEwYmI1
MDA+XSA/IGNvbnNvbGVfdW5sb2NrKzB4MjY1LzB4MzViClsgICAxOC42MzQ5NDBdICBbPGZm
ZmZmZmZmODEwYmI1YWQ+XSA/IGNvbnNvbGVfdW5sb2NrKzB4MzEyLzB4MzViClsgICAxOC42
MzQ5NDBdICBbPGZmZmZmZmZmODFlMGVmY2M+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDE1
NC8weDFkMApbICAgMTguNjM0OTQwXSAgWzxmZmZmZmZmZjgxZTBlNmRhPl0gPyBkb19lYXJs
eV9wYXJhbSsweDg4LzB4ODgKWyAgIDE4LjYzNDk0MF0gIFs8ZmZmZmZmZmY4MTgzZDY3OT5d
ID8gcmVzdF9pbml0KzB4YmQvMHhiZApbICAgMTguNjM0OTQwXSAgWzxmZmZmZmZmZjgxODNk
NjgyPl0ga2VybmVsX2luaXQrMHg5LzB4Y2MKWyAgIDE4LjYzNDk0MF0gIFs8ZmZmZmZmZmY4
MTg0ZWZmYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICAxOC42MzQ5NDBdICBbPGZm
ZmZmZmZmODE4M2Q2Nzk+XSA/IHJlc3RfaW5pdCsweGJkLzB4YmQKWyAgIDE4LjYzNDk0MF0g
LS0tWyBlbmQgdHJhY2UgZGY3OTgxY2E5NTJkNWI3ZSBdLS0tCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWcteDEtMDkyOC81N2Q3MzA5MjRkNWNjMmMzZTI4MGFmMTZhOTMwNjU4N2MzYTUx
MWRiL2RtZXNnLXlvY3RvLXdhaW1lYS01OjIwMTMxMDAzMTUyNTA2OjMuMTEuMC0wNTA1OC1n
NTdkNzMwOToxNDYKCkJpc2VjdGluZzogMjUyOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpClthOTIzODc0MTk4NzM4NmJiNTQ5ZDYxNTcy
OTczYzdlNjJiMmE0MTQ1XSBNZXJnZSB0YWcgJ3BjaS12My4xMi1jaGFuZ2VzJyBvZiBnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvaGVsZ2Fhcy9wY2kK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9o
b21lL3dmZy9kcm0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC90aXA6cGVyZjp1cmdlbnQ6YTkyMzg3NDE5
ODczODZiYjU0OWQ2MTU3Mjk3M2M3ZTYyYjJhNDE0NTpiaXNlY3QtZHJtCgoyMDEzLTEwLTAz
LTA3OjI5OjM3IGE5MjM4NzQxOTg3Mzg2YmI1NDlkNjE1NzI5NzNjN2U2MmIyYTQxNDUgY29t
cGlsaW5nCjI3MyByZWFsICAxODg0IHVzZXIgIDUyMiBzeXMgIDg3OS42OSUgY3B1IAl4ODZf
NjQtcmFuZGNvbmZpZy14MS0wOTI4CgoyMDEzLTEwLTAzLTA3OjM0OjQ5IGRldGVjdGluZyBi
b290IHN0YXRlIDMuMTEuMC0wMjUyOS1nYTkyMzg3NC4JNQkxMQkxOQkzOQk0Mwk0NQk0Nwk1
NQk1Ni4uCTU4Lgk2NAk2OAk3MAk3Mgk4Mgk5MwkxMDUJMTE1CTExNwkxMzMJMTQ0CTE1NQkx
NTkJMTYyCTE3NgkxODYJMjAxCTIwNy4JMjIzCTIzNQkyNTMJMjY5CTI3MwkyOTcJMzA3CTMx
NQkzMzAJMzY5CTM3NgkzODEJMzk0CTQxNwk0MjQJNDI5CTQ1MAk0NTUJNDY3Lgk0NzkJNDg3
CTQ5Mgk1MDIJNTA4CTUxNAk1MTcJNTI1CTUzNQk1NDIJNTQ3CTU1OAk1NjIJNTY4CTU3Mwk1
ODIJNTk0CTU5OAk2MTIJNjE1CTYyMAk2MjMJNjMxCTYzNgk2NDAJNjU4CTY2OQk2OTAJNjkx
CTcwNwk3MTMJNzM5CTc0Nwk3NjkJNzc1CTc4Mgk4MTIJODE5CTg0Mwk4NTIJODYwCTg2Mgk4
ODIJODg5CTkxMAk5MzMJOTUwCTk2OQk5OTAJMTAxMQkxMDI3CTEwNTAJMTA2MgkxMDgyCTEw
OTcJMTEwNgkxMTIxCTExMjYJMTEzNwkxMTUwCTExNjIJMTE3NQkxMTg5CTEyMDEJMTIxNgkx
MjIyCTEyMjYJMTIzMgkxMjM2CTEyNTEJMTI1NwkxMjc0CTEyODkJMTMwNwkxMzE2CTEzNDAJ
MTM1NwkxMzYzCTEzNzIJMTM5MgkxNDA4CTE0MjUJMTQzOQkxNDU3CTE0ODQJMTUwMQkxNTA5
CTE1MjQJMTUyNgkxNTMzCTE1MzUJMTU0OQkxNTU4CTE1NjUJMTU2OQkxNTcxCTE1NzUJMTU4
MAkxNTgxCTE1ODIJMTU4NAkxNTg1CTE1OTAJMTU5MwkxNjA1CTE2MTgJMTYyNgkxNjM0CTE2
NDUJMTY1NgkxNjcwCTE2NzcJMTY4MwkxNjk0CTE3MDQJMTcxOAkxNzM1CTE3NDAuLgkxNzQx
Li4uCTE3NDQuCTE3NDcuCTE3NDgJMTc3NQkxNzgyCTE3ODcuCTE3OTMJMTc5NgkxODAzCTE4
MTEJMTgxNwkxODIzCTE4MjYJMTgyOQkxODMyCTE4MzQJMTgzNQkxODQwLgkxODQ4CTE4NTAJ
MTg1NAkxODU4CTE4NjMuLgkxODY2CTE4NzMJMTg3OQkxODkyCTE4OTgJMTkwMwkxOTEyCTE5
MzAJMTk1MgkxOTYzCTE5NzQJMTk4MgkxOTg5CTIwMDMJMjAxMwkyMDE5CTIwMjcJMjAzNgky
MDQ1CTIwNTUJMjEwMgkyMTM3CTIxNTcJMjE4NwkyMjEzCTIyMzQJMjIzNwkyMjM5CTIyNzYJ
MjI4MwkyMjk4CTIzMDkJMjMyNwkyMzQ5CTIzNTgJMjM2NQkyMzg4CTIzOTkJMjQwNAkyNDIw
CTI0MzAJMjQzMQkyNDMzCTI0MzYuCTI0NDAJMjQ0NAkyNDQ1CTI0NDgJMjQ1MwkyNDcxCTI0
ODQJMjQ5MAkyNTAwCTI1MTcJMjUyNgkyNTM4CTI1NTEJMjU3OAkyNTg0CTI1OTkJMjYxMAky
NjE5CTI2MzcJMjY0OQkyNjU4CTI2NjAJMjY2NwkyNjcwCTI2NzMJMjY3Ni4JMjY4MC4JMjY4
MwkyNjg2CTI2ODcJMjY4OC4JMjY4OQkyNjkwCTI2OTEJMjY5MgkyNjk0CTI2OTcJMjY5OQky
NzAwLi4JMjcwNQkyNzA3CTI3MDkuCTI3MTEuCTI3MTIuCTI3MTQJMjcxNS4uLgkyNzE5CTI3
MjAJMjcyMgkyNzI2CTI3MzMJMjczNwkyNzQxCTI3NDYJMjc0NwkyNzQ4CTI3NTEuCTI3NTQJ
Mjc1NwkyNzYwCTI3NjIJMjc2MwkyNzY1CTI3NjkJMjc3NQkyNzc2CTI3NzcJMjc4MQkyNzgy
LgkyNzg3CTI3ODkJMjc5NAkyNzk1CTI3OTcJMjc5OAkyODAwLgkyODA2CTI4MDkJMjgxMQky
ODE2CTI4MTgJMjgyMgkyODI1CTI4MjkJMjgzNQkyODQyCTI4NDMJMjg0NgkyODQ5CTI4NTMJ
Mjg1OQkyODYwCTI4NjIJMjg2NQkyODc0CTI4NzkJMjg4OAkyODkzCTI4OTcJMjkwMwkyOTA4
CTI5MTYJMjkyNgkyOTMzCTI5MzcJMjk0MQkyOTQ3CTI5NTEJMjk1NgkyOTYzCTI5NzIJMjk3
OAkyOTgxCTI5ODYJMjk4OQkyOTkzCTI5OTcJMzAwMwkzMDA2CTMwMDcJMzAxMAkzMDEyCTMw
MTUJMzAxOS4JMzAyNAkzMDM1CTMwNDAJMzA0MQkzMDQyCTMwNTAJMzA1NwkzMDY4CTMwNzYJ
MzA4MwkzMDg0CTMwOTEJMzEwMQkzMTEwCTMxMTgJMzEyNAkzMTMzCTMxNDQJMzE1NAkzMTU4
CTMxNjguLgkzMTc1CTMxNzYJMzE5My4uCTMyMTEJMzIxOQkzMjMyCTMyNDIJMzI1MwkzMjU4
CTMyNjkJMzI4NQkzMzA1CTMzMTUJMzMyOQkzMzU5CTMzOTIJMzQzMAkzNDM5CTM0NDIJMzQ0
NgkzNDQ4CTM0NTEJMzQ1My4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVt
YWRkX3RvX3J1bl9xdWV1ZSAxMDIbWzBtCi4uLi4uLi4uLi4uLgkzNDU1Li4JMzQ1Ni4uLgkz
NDU4CTM0NTkJMzQ2MC4uLi4uLi4uLi4uLi4JMzQ2MS4uLi4uLi4uLi4uLgkzNDYzCTM0NjUJ
MzQ2Ni4JMzQ2OS4JMzQ3MC4JMzQ3MgkzNDczLgkzNDc0CTM0NzYJMzQ3Ny4JMzQ3OAkzNDc5
CTM0ODEJMzQ4NC4uLi4JMzQ4NS4JMzQ4Ni4uLi4JMzQ4NwkzNDkwCTM0OTMuLi4JMzQ5NQkz
NDk2LgkzNDk4CTM0OTkuLgkzNTAwLgkzNTA2Li4JMzUwNwkzNTEwCTM1MTIJMzUxMy4JMzUx
NgkzNTE3CTM1MTkJMzUyMgkzNTIzLgkzNTI0CTM1MjYJMzUyNwkzNTI4Li4JMzUzMi4JMzUz
NAkzNTM1CTM1MzYJMzUzOC4JMzUzOQkzNTQwCTM1NDEJMzU0Mi4JMzU0My4uLi4uCTM1NDQJ
MzU0NS4uLgkzNTQ3Li4JMzU0OAkzNTQ5Li4JMzU1MC4uLi4JMzU1MS4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA0G1swbQouCTM1NTIJ
MzU1NC4JMzU1NSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEyNTkgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbY2YzOWM4ZTUzNTJiNGZiOWVm
ZWRmZTdlOWFjYjU2NmE4NWVkODQ3Y10gTWVyZ2UgdGFnICdzdGFibGUvZm9yLWxpbnVzLTMu
MTItcmMwLXRhZycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3hlbi90aXAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy9kcm0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC90aXA6cGVyZjp1
cmdlbnQ6Y2YzOWM4ZTUzNTJiNGZiOWVmZWRmZTdlOWFjYjU2NmE4NWVkODQ3YzpiaXNlY3Qt
ZHJtCgoyMDEzLTEwLTAzLTE3OjMyOjEzIGNmMzljOGU1MzUyYjRmYjllZmVkZmU3ZTlhY2I1
NjZhODVlZDg0N2MgY29tcGlsaW5nCjQwMiByZWFsICAxOTIwIHVzZXIgIDQwNiBzeXMgIDU3
Ny44OSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4CgoyMDEzLTEwLTAzLTE3OjQw
OjA4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC0wMzc5OC1nY2YzOWM4ZQkxCTMJNgkx
MAkyMAkzMAkzMgkzNQkzNwkzOQk0Mgk0NQk0Nwk1Mgk1NAk1Ngk1OQk2Ny4JNjkJNzYuCTc5
CTg1CTg3CTkwCTEwOQkxMjMJMTQ4CTE3OAkxODIuCTE4NAkxOTEJMTkyCTE5NQkxOTkJMjAy
CTIwNgkyMDkJMjE0CTIxNQkyMTguLi4uLi4JMjIwLgkyMjEJMjIyCTIyMwkyMjQJMjI1CTIy
Ni4JMjMwCTIzMi4JMjM0CTI0MgkyNDQJMjQ3CTI0OQkyNTMuCTI1NQkyNjEJMjYyCTI2NAky
NjcuCTI2OAkyNjkJMjcyCTI3NwkyODMJMjk0CTI5NwkyOTgJMjk5CTMwMgkzMDQJMzI0CTM0
MAkzNTAJMzYyCTM5Mgk0MDkJNDEyCTQxNAk0MjAJNDM1CTQ0MQk0ODQJNTA0CTU0Nwk2MzgJ
NjQ2CTY1Mgk2NjcJNjc5CTY5NAk3MDEJNzA5CTcyNyBURVNUIEZBSUxVUkUKG1sxOzM1bUlu
Y3JlYXNpbmcgcmVwZWF0IGNvdW50IGZyb20gMzU1NSB0byA1MDAwG1swbQpbICAgNjEuOTk4
MzUxXSBTY2FubmluZyBkZXZpY2UgZm9yIGJhZCBibG9ja3MKWyAgIDYyLjY5MjkwN10gLS0t
LS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICA2Mi42OTUyNjZdIFdBUk5J
Tkc6IENQVTogMCBQSUQ6IDEgYXQgL2Mvd2ZnL2xpbnV4LWRybS9rZXJuZWwvd29ya3F1ZXVl
LmM6NTkxIHNldF93b3JrX2RhdGErMHgzMy8weDUwKCkKWyAgIDYyLjY5NjQwMV0gQ1BVOiAw
IFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMS4wLTAzNzk4LWdjZjM5
YzhlICMxNDgKWyAgIDYyLjY5NjQwMV0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZGMw
M2Q4MCBmZmZmZmZmZjgxODM3MGYzIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDYyLjY5NjQwMV0g
IGZmZmY4ODAwMGRjMDNkYjggZmZmZmZmZmY4MTA4ZTYxMyBmZmZmZmZmZjgxMDljZjM5IGZm
ZmY4ODAwMDZjYmUwNjAKWyAgIDYyLjY5NjQwMV0gIGZmZmY4ODAwMGRjMTM0MDAgMDAwMDAw
MDAwMDAwMDAwNSBmZmZmODgwMDBkYzExNjAwIGZmZmY4ODAwMGRjMDNkYzgKWyAgIDYyLjY5
NjQwMV0gQ2FsbCBUcmFjZToKWyAgIDYyLjY5NjQwMV0gIDxJUlE+ICBbPGZmZmZmZmZmODE4
MzcwZjM+XSBkdW1wX3N0YWNrKzB4NGUvMHg4MgpbICAgNjIuNjk2NDAxXSAgWzxmZmZmZmZm
ZjgxMDhlNjEzPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3MC8weDg5ClsgICA2Mi42OTY0
MDFdICBbPGZmZmZmZmZmODEwOWNmMzk+XSA/IHNldF93b3JrX2RhdGErMHgzMy8weDUwClsg
ICA2Mi42OTY0MDFdICBbPGZmZmZmZmZmODEwOGU2ZWU+XSB3YXJuX3Nsb3dwYXRoX251bGwr
MHgxNS8weDE3ClsgICA2Mi42OTY0MDFdICBbPGZmZmZmZmZmODEwOWNmMzk+XSBzZXRfd29y
a19kYXRhKzB4MzMvMHg1MApbICAgNjIuNjk2NDAxXSAgWzxmZmZmZmZmZjgxMDlkYzRmPl0g
aW5zZXJ0X3dvcmsrMHgyNy8weDY1ClsgICA2Mi42OTY0MDFdICBbPGZmZmZmZmZmODEwOWRl
NWM+XSBfX3F1ZXVlX3dvcmsrMHgxY2YvMHgxZWUKWyAgIDYyLjY5NjQwMV0gIFs8ZmZmZmZm
ZmY4MTA5ZGU3Yj5dID8gX19xdWV1ZV93b3JrKzB4MWVlLzB4MWVlClsgICA2Mi42OTY0MDFd
ICBbPGZmZmZmZmZmODEwOWRlOTQ+XSBkZWxheWVkX3dvcmtfdGltZXJfZm4rMHgxOS8weDFi
ClsgICA2Mi42OTY0MDFdICBbPGZmZmZmZmZmODEwOTUxNTM+XSBjYWxsX3RpbWVyX2ZuKzB4
NmMvMHhkZgpbICAgNjIuNjk2NDAxXSAgWzxmZmZmZmZmZjgxMDk1MGU3Pl0gPyBwcm9jZXNz
X3RpbWVvdXQrMHhiLzB4YgpbICAgNjIuNjk2NDAxXSAgWzxmZmZmZmZmZjgxMDlkZTdiPl0g
PyBfX3F1ZXVlX3dvcmsrMHgxZWUvMHgxZWUKWyAgIDYyLjY5NjQwMV0gIFs8ZmZmZmZmZmY4
MTA5NTg2Mj5dIHJ1bl90aW1lcl9zb2Z0aXJxKzB4MTcwLzB4MWI4ClsgICA2Mi42OTY0MDFd
ICBbPGZmZmZmZmZmODEwOTFjNmE+XSBfX2RvX3NvZnRpcnErMHhjOC8weDE4ZApbICAgNjIu
Njk2NDAxXSAgWzxmZmZmZmZmZjgxMDkxZTQ0Pl0gaXJxX2V4aXQrMHg1Ni8weDk3ClsgICA2
Mi42OTY0MDFdICBbPGZmZmZmZmZmODEwMmEzNzA+XSBkb19JUlErMHg4OC8weDlmClsgICA2
Mi42OTY0MDFdICBbPGZmZmZmZmZmODE4NDExZjI+XSBjb21tb25faW50ZXJydXB0KzB4NzIv
MHg3MgpbICAgNjIuNjk2NDAxXSAgPEVPST4gIFs8ZmZmZmZmZmY4MTY0OGRhMj5dID8gbGVk
X3RyaWdnZXJfZXZlbnQrMHgyNi8weDU0ClsgICA2Mi42OTY0MDFdICBbPGZmZmZmZmZmODEw
YzM3ZTA+XSA/IGFyY2hfbG9jYWxfaXJxX3Jlc3RvcmUrMHg2LzB4ZApbICAgNjIuNjk2NDAx
XSAgWzxmZmZmZmZmZjgxMGM2ZThhPl0gbG9ja19hY3F1aXJlKzB4OTQvMHg5ZApbICAgNjIu
Njk2NDAxXSAgWzxmZmZmZmZmZjgxNjQ4ZGEyPl0gPyBsZWRfdHJpZ2dlcl9ldmVudCsweDI2
LzB4NTQKWyAgIDYyLjY5NjQwMV0gIFs8ZmZmZmZmZmY4MTg0MDg2ZT5dIF9yYXdfcmVhZF9s
b2NrKzB4MzYvMHg0MgpbICAgNjIuNjk2NDAxXSAgWzxmZmZmZmZmZjgxNjQ4ZGEyPl0gPyBs
ZWRfdHJpZ2dlcl9ldmVudCsweDI2LzB4NTQKWyAgIDYyLjY5NjQwMV0gIFs8ZmZmZmZmZmY4
MTY0OGRhMj5dIGxlZF90cmlnZ2VyX2V2ZW50KzB4MjYvMHg1NApbICAgNjIuNjk2NDAxXSAg
WzxmZmZmZmZmZjgxNGNhZmRhPl0gbmFuZF93YWl0X3JlYWR5KzB4YTkvMHhiMgpbICAgNjIu
Njk2NDAxXSAgWzxmZmZmZmZmZjgxNGNiODM4Pl0gbmFuZF9yZWFkX29vYisweDFhOC8weDI3
MApbICAgNjIuNjk2NDAxXSAgWzxmZmZmZmZmZjgxNGI0ODlhPl0gbXRkX3JlYWRfb29iKzB4
MjYvMHg0YwpbICAgNjIuNjk2NDAxXSAgWzxmZmZmZmZmZjgxNGNkZTc0Pl0gY3JlYXRlX2Ji
dCsweDIyNS8weDJkNApbICAgNjIuNjk2NDAxXSAgWzxmZmZmZmZmZjgxNGNlNDJlPl0gbmFu
ZF9zY2FuX2JidCsweDg1LzB4NGUzClsgICA2Mi42OTY0MDFdICBbPGZmZmZmZmZmODExMTgw
ZDU+XSA/IF9fa21hbGxvYysweDkwLzB4YmIKWyAgIDYyLjY5NjQwMV0gIFs8ZmZmZmZmZmY4
MTRjZTk2Yj5dIG5hbmRfZGVmYXVsdF9iYnQrMHhkZi8weGU0ClsgICA2Mi42OTY0MDFdICBb
PGZmZmZmZmZmODFlMjc0MzQ+XSBuc19pbml0X21vZHVsZSsweDU3Ni8weGQ2MQpbICAgNjIu
Njk2NDAxXSAgWzxmZmZmZmZmZjgxODNlYjAxPl0gPyBtdXRleF91bmxvY2srMHg5LzB4Ygpb
ICAgNjIuNjk2NDAxXSAgWzxmZmZmZmZmZjgxZTI2ZWJlPl0gPyBpbml0X25hbmRkb2MrMHhj
OC8weGM4ClsgICA2Mi42OTY0MDFdICBbPGZmZmZmZmZmODFkZmRkZDQ+XSBkb19vbmVfaW5p
dGNhbGwrMHg4ZS8weDEzMgpbICAgNjIuNjk2NDAxXSAgWzxmZmZmZmZmZjgxZGZkZmNjPl0g
a2VybmVsX2luaXRfZnJlZWFibGUrMHgxNTQvMHgxZDAKWyAgIDYyLjY5NjQwMV0gIFs8ZmZm
ZmZmZmY4MWRmZDZkYT5dID8gZG9fZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgICA2Mi42OTY0
MDFdICBbPGZmZmZmZmZmODE4MzBlYTk+XSA/IHJlc3RfaW5pdCsweGJkLzB4YmQKWyAgIDYy
LjY5NjQwMV0gIFs8ZmZmZmZmZmY4MTgzMGViMj5dIGtlcm5lbF9pbml0KzB4OS8weGNjClsg
ICA2Mi42OTY0MDFdICBbPGZmZmZmZmZmODE4NDFhN2M+XSByZXRfZnJvbV9mb3JrKzB4N2Mv
MHhiMApbICAgNjIuNjk2NDAxXSAgWzxmZmZmZmZmZjgxODMwZWE5Pl0gPyByZXN0X2luaXQr
MHhiZC8weGJkClsgICA2Mi42OTY0MDFdIC0tLVsgZW5kIHRyYWNlIDdkZTI2MjJhNGI2NWI1
Y2IgXS0tLQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvY2YzOWM4ZTUzNTJi
NGZiOWVmZWRmZTdlOWFjYjU2NmE4NWVkODQ3Yy9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTIw
OjIwMTMxMDAzMDkwMTI5OjMuMTEuMC0wMzc5OC1nY2YzOWM4ZToxNDgKCkJpc2VjdGluZzog
Njc3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBz
KQpbODE2NDM0ZWM0YTY3NGZjZGIzYzIyMjFhNmRmZmRjOGYzNDAyMDU1MF0gTWVyZ2UgYnJh
bmNoICd4ODYtc3BpbmxvY2tzLWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9kcm0vb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
eDEtMDkyOC90aXA6cGVyZjp1cmdlbnQ6ODE2NDM0ZWM0YTY3NGZjZGIzYzIyMjFhNmRmZmRj
OGYzNDAyMDU1MDpiaXNlY3QtZHJtCgoyMDEzLTEwLTAzLTE4OjM0OjMyIDgxNjQzNGVjNGE2
NzRmY2RiM2MyMjIxYTZkZmZkYzhmMzQwMjA1NTAgcmV1c2UgL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy14MS0wOTI4LzgxNjQzNGVjNGE2NzRmY2RiM2MyMjIxYTZkZmZkYzhmMzQwMjA1
NTAvdm1saW51ei0zLjExLjAtMDMxMjAtZzgxNjQzNGUKCjIwMTMtMTAtMDMtMTg6MzQ6NDIg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkzCTQJOQkxMgkyMAkyNAkyOQk0MAk0Nwk1MAk1NAk1
Ngk1OQk2MAk2MQk2Mgk2Mwk3MQk3OQk4Ngk5MQkxMDAJMTA1CTEwOQkxMTEJMTE4CTEyNwkx
MzUJMTQzCTE0NgkxNDkJMTUwCTE1MwkxNjUJMTc0CTE4MQkxOTMJMjA0CTIyMAkyMjIJMjMz
CTI0NwkyNTkJMjYwCTI2NQkyNzIJMjc4CTI4NQkyODkJMjk0LgkyOTcJMzAyCTMwNAkzMDgJ
MzA5CTMxNAkzMTgJMzI1CTMyNwkzMjkJMzMzCTMzOS4JMzQwCTM0MS4JMzQzLgkzNDcJMzUx
CTM1NgkzNTgJMzU5CTM2MQkzNjQuCTM2OAkzNzAJMzc1CTM3NgkzNzkuCTM4NAkzODcuCTM4
OQkzOTAuCTM5MQkzOTQJMzk1CTM5Ni4uCTM5Ny4uCTM5OAkzOTkuLi4JNDAwLi4uLi4uCTQw
Mgk0MDMJNDA0Li4uLgk0MDUuLgk0MDYJNDA3CTQwOAk0MDkuLi4JNDEwCTQxMS4JNDEyLgk0
MTMJNDE0Lgk0MTYuLi4JNDE3Lgk0MTkuCTQyMC4uLi4JNDIxLi4uCTQyMgk0MjMJNDI0CTQy
NQk0MjYuLgk0MjgJNDI5Lgk0MzAJNDMxCTQzMgk0MzMuLgk0MzQJNDM2CTQzOQk0NDEJNDQz
CTQ0NC4JNDQ1Li4JNDUwCTQ1Mgk0NTMJNDU2Lgk0NTgJNDYxCTQ2Ni4JNDczCTQ4MS4JNDg0
CTQ5MAk0OTcJNTAwCTUwNQk1MDkJNTEyCTUxMwk1MTUJNTE5CTUyNAk1MjcuCTUzMgk1MzgJ
NTQyCTU0Mwk1NDUJNTQ4CTU1MQk1NTcJNTYzCTU2NQk1NjgJNTcyCTU3Mwk1NzYuCTU3Ny4J
NTg5Lgk1OTIJNTk4CTYwMAk2MDEJNjAyCTYxNwk2MjQJNjI3CTYzMwk2NDEJNjQ2CTY0Nwk2
NDgJNjUxCTY1Mwk2NTUJNjU3CTY2MQk2NjcJNjY5CTY3NQk2NzYJNjc4CTY4NAk2ODUJNjg2
Lgk2ODguCTY4OQk2OTAJNjkxCTY5Mi4JNjk0CTY5Ngk2OTguCTY5OQk3MDAuCTcwMQk3MDIJ
NzA1Lgk3MDkJNzExCTcxNgk3MTcJNzE5Lgk3MjEJNzI0CTcyNgk3MzAJNzMyCTczOAk3NDMJ
NzQ1CTc0Ni4JNzQ3CTc0OAk3NTMJNzYwCTc2NQk3NjcuCTc2OC4uCTc3MC4JNzcyCTc3NAk3
NzUuCTc3Nwk3NzkJNzgwCTc4MS4JNzgzCTc4NQk3ODgJNzkyLgk3OTUJNzk3CTgwMQk4MDgJ
ODEwCTgxNgk4MTcJODI2CTgzMAk4MzUJODQ0CTg0Ngk4NTEJODU1CTg3MAk4NzQJODg0CTg5
MAk4OTgJOTA1CTkxNQk5MTgJOTI2CTkzMgk5MzQJOTM4CTk0Nwk5NTMJOTYwCTk3MQk5ODEJ
OTg0CTk5MQkxMDA3CTEwMTUJMTAyNAkxMDM0CTEwMzkJMTA0NQkxMDUxCTEwNTYJMTA2Mwkx
MDcwCTEwNzYJMTA4MAkxMDgyCTEwODUJMTA5MwkxMTAwCTExMDQJMTExMAkxMTEyCTExMTcJ
MTEyMAkxMTIxCTExMjgJMTEzMgkxMTM0LgkxMTM1LgkxMTM2CTExNDEJMTE0MwkxMTQ3CTEx
NTIJMTE2NAkxMTY4CTExNjkJMTE3My4JMTE3NwkxMTgxCTExODYJMTE5NQkxMjA0CTEyMDYJ
MTIwNwkxMjA4CTEyMTMJMTIxNgkxMjIyCTEyMjcJMTIzNwkxMjQyCTEyNTIJMTI2MwkxMjY1
CTEyNzYJMTI4MAkxMjg4CTEyOTUJMTMwNAkxMzE2CTEzMjYJMTMzMAkxMzQwCTEzNDgJMTM1
NAkxMzYxLgkxMzYyCTEzNjMuLi4uLi4JMTM3MQkxMzc3CTEzODcJMTM4OS4uCTE0MDMuCTE0
MDYJMTQxOAkxNDIwCTE0MjcJMTQyOAkxNDM0CTE0MzUJMTQ1MQkxNDYzCTE0NzgJMTQ4NAkx
NDk4CTE1MTAJMTUxNgkxNTE5CTE1MjIJMTUyNQkxNTMwCTE1NDAJMTU0NwkxNTQ5CTE1NTcJ
MTU1OAkxNTczCTE1ODIJMTU5MAkxNjAzCTE2MTMJMTYyOAkxNjM1LgkxNjQ4CTE2NTgJMTY3
NwkxNjg0CTE2OTYJMTcwOQkxNzE4CTE3MjcJMTczNAkxNzQ0CTE3NTEJMTc1OQkxNzgxCTE3
ODkJMTc5MAkxNzkzCTE3OTcJMTgwNC4JMTgyNwkxODM0CTE4MzkJMTg1OAkxODc3CTE4OTcJ
MTkwNwkxOTM4CTE5NTQJMTk3OQkxOTk2CTIwMTcJMjA0MQkyMDc4CTIxMTcJMjE0MAkyMTQ0
CTIxNTcJMjE3OAkyMTkwCTIyMDAJMjIyOQkyMjcyCTIyOTEJMjMxNgkyMzM3CTIzNTcJMjM3
MQkyMzgxCTIzODcJMjQxNAkyNDI5CTI0NjYJMjQ4OAkyNTE2CTI1NDYJMjU1MAkyNTU0CTI1
NjgJMjU3OAkyNjAyCTI2MjUJMjYzOQkyNjU0CTI2ODgJMjY5MAkyNzE4CTI3MzMJMjc3NAky
ODAzCTI4MzkJMjg2NAkyOTE4CTI5NDkJMjk1NwkyOTgzCTMwNTQJMzA4NgkzMDkyCTMwOTcJ
MzExMgkzMTE0CTMxMjYJMzEzMAkzMTUwCTMxNjEJMzE3NgkzMTg2CTMxOTgJMzIxMgkzMjMy
CTMyNzIJMzI4NQkzMjkyCTMzMDEJMzM0MQkzMzc0CTM0MTEJMzQzMwkzNDY0CTM0ODMJMzQ5
OQkzNTA4CTM1MTYJMzUyNAkzNTMzCTM1MzQJMzU0NgkzNTYyLgkzNTk5CTM2MDAJMzYwNAkz
NjE4CTM2MzIJMzY0MAkzNjQ2CTM2NDcJMzY2OAkzNjcxCTM2ODEJMzY4OQkzNjkxCTM2OTMJ
MzY5NQkzNjk4CTM3MDUJMzcxOQkzNzQ2CTM3NTgJMzc2MgkzNzYzCTM3NzMJMzc4MwkzNzk5
CTM4MjkJMzg0NwkzODYyCTM4NjQJMzg4MAkzODkyCTM4OTMJMzk0MwkzOTQ0CTM5NTEJMzk3
NAkzOTk2CTQwMDkJNDAzMQk0MDQzCTQwNjAJNDA3Mwk0MDg2CTQwOTkJNDEyMQk0MTM0CTQx
NTMJNDE2MAk0MTY4CTQxOTkJNDIwOQk0MjE4CTQyMjkJNDIzNQk0MjQxCTQyNTMJNDI1OAk0
MjYxCTQyNjIJNDI2My4JNDI2NAk0MjY1CTQyNzUJNDI5OQk0MzI4CTQzNjEJNDQwMQk0NDMw
CTQ0NDkJNDQ2NQk0NDk0CTQ0OTcJNDUwMAk0NTAyCTQ1MDcJNDUzNAk0NTY4CTQ1NzIJNDU3
OAk0NTgzLgk0NTg0CTQ1ODUuLi4uCTQ1OTkJNDYwMAk0NjAyLgk0NjAzLgk0NjIwCTQ2NzUJ
NDY4NAk0Njk1CTQ2OTgJNDcwMAk0NzA3CTQ3MzUJNDczOQk0NzU1CTQ3NTgJNDc2MQk0Nzc4
CTQ3ODMJNDgwOQk0ODE5CTQ4ODEJNDkwMgk0OTA3CTQ5MDkJNDkxMC4uCTQ5MTIJNDkxMy4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSA4
NxtbMG0KLgk0OTE1CTQ5MTYuCTQ5MTkuCTQ5MjAJNDkyMS4uCTQ5MjIuLgk0OTI2CTQ5Mjcu
CTQ5MjguLgk0OTI5CTQ5MzQJNDkzNi4JNDk0MC4JNDk0Mi4uLgk0OTQ0CTQ5NTIJNDk2MQk0
OTgwCTQ5OTAJNDk5MS4uCTQ5OTIuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sx
OzM1bWFkZF90b19ydW5fcXVldWUgOBtbMG0KCTQ5OTMJNDk5OC4uCTUwMDAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiAzNTYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDggc3RlcHMpCls0M2JjYjQwMmY4NGZlNDU5MTAyMTIwYjRlMmQyOGQ3MTE3ZjE2Y2Qw
XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdhc29jL3RvcGljL3dtODk5NCcgaW50
byBhc29jLW5leHQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9kcm0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC90aXA6cGVyZjp1cmdl
bnQ6NDNiY2I0MDJmODRmZTQ1OTEwMjEyMGI0ZTJkMjhkNzExN2YxNmNkMDpiaXNlY3QtZHJt
CgoyMDEzLTEwLTA0LTA1OjQzOjEzIDQzYmNiNDAyZjg0ZmU0NTkxMDIxMjBiNGUyZDI4ZDcx
MTdmMTZjZDAgY29tcGlsaW5nCjQwMiByZWFsICAxODE5IHVzZXIgIDQ5NyBzeXMgIDU3NS4z
OSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4CgoyMDEzLTEwLTA0LTA1OjUwOjUw
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC1yYzYtMDAzMjEtZzQzYmNiNDAuLgk0CTEw
CTE3CTI3CTM5CTQ4CTUxCTU2CTYxCTcwCTc3CTg3CTk1CTk5CTEwNwkxMTAJMTE5CTEyMy4J
MTMwCTEzNC4JMTM2LgkxMzcJMTQ1CTE1MAkxNTIJMTYyCTE2NgkxNzMJMTc3CTE3OAkxNzkJ
MTg2CTE4OAkxOTcJMjAwCTIwMwkyMTgJMjIxCTIyNgkyMjkuCTIzMi4JMjM2CTI0NwkyNTAJ
MjU1CTI2MQkyNjYJMjY5CTI3MQkyNzUJMjc3LgkyNzgJMjgyCTI4MwkyODcJMjkzCTI5Ngkz
MDMJMzA3CTMyMQkzMjgJMzMxCTMzNgkzNDAJMzQxCTM0NgkzNTAJMzUzCTM1OAkzNTkJMzYx
LgkzNjQJMzY3CTM2OAkzNjkuCTM3MS4JMzcyCTM3OQkzODQJMzkxLgkzOTYJNDA0CTQwNgk0
MTAJNDEzCTQxNwk0MjAJNDIzCTQyNi4JNDI4CTQzMQk0MzUuCTQzNwk0NDIuCTQ0NQk0NDkJ
NDUxCTQ1OQk0NjkJNDcxCTQ3NQk0NzkJNDg3CTQ5MQk0OTYJNDk3CTQ5OQk1MDcJNTExCTUx
Mgk1MjEJNTM2CTU0Mwk1NTEJNTYzCTU2OQk1NzIJNTc5CTU4NQk1OTMJNjA0CTYxMQk2MTcJ
NjI0CTYzMwk2NDEJNjUwCTY1Mwk2NjEJNjY2CTY3Mwk2ODIJNjkxCTY5Ngk2OTkJNzEzCTcy
MAk3MjgJNzQxCTc0OQk3NTEJNzU2CTc2MAk3NjUJNzcwCTc4MAk3ODIJNzkwCTc5MS4JNzky
CTc5Ngk3OTkJODAwCTgwNwk4MTAJODExCTgxMgk4MTMuCTgxOAk4MjUJODMyCTgzNwk4NDEJ
ODQzCTg0OAk4NTMJODU1Lgk4NjQJODcwCTg3OAk4ODIJODg0CTg4Ngk4OTIJODk3CTg5OAk4
OTkuCTkwMQk5MDMuCTkwNAk5MDUJOTEwCTkxNwk5MjMuCTkzMQk5NDEJOTQ5CTk1Mwk5NjEJ
OTYzCTk2OAk5NzEJOTc0CTk4Mgk5ODYJOTg4CTk5Mwk5OTQuCTk5OAkxMDAyCTEwMTQJMTAx
NwkxMDIyCTEwMzIJMTAzNgkxMDQ1CTEwNDkJMTA2NAkxMDc3CTEwODkJMTA5NwkxMTA5CTEx
MTgJMTEyOQkxMTM3CTExNTAuCTExNzIJMTE4NQkxMTkxCTExOTkJMTIwMwkxMjE3CTEyMjIJ
MTIyOAkxMjQ0CTEyNjAJMTI3MQkxMjg0CTEyOTcJMTMwNAkxMzE5CTEzMjUJMTMzOQkxMzQ2
CTEzNjAJMTM2NgkxMzc2CTEzODgJMTM5MAkxMzk0CTEzOTcJMTQwMgkxNDA2CTE0MDgJMTQx
MAkxNDEzLgkxNDE2CTE0MzIJMTQ0MQkxNDQyCTE0NDgJMTQ1NgkxNDY1CTE0NzgJMTQ4Mwkx
NDg5CTE1MDIJMTUxNgkxNTMyCTE1NDMJMTU1MwkxNTU0CTE1NzEJMTU4MQkxNTkzCTE2MTIJ
MTYyNgkxNjQzCTE2NjAJMTY3MgkxNjgyCTE3MDMJMTcxOAkxNzM2CTE3NTYJMTc2OAkxNzc5
CTE3OTQJMTgwNQkxODE4CTE4MjUJMTgzNQkxODUwCTE4NjQJMTg3OAkxODg1CTE4OTYJMTkw
NAkxOTEwLgkxOTE2CTE5MTcJMTkzMQkxOTU0CTE5NTkJMTk2NgkxOTc5CTE5OTYJMjAwOAky
MDE3CTIwMjEJMjAyNgkyMDM5CTIwNTMJMjA2NwkyMDgwCTIwOTgJMjExMwkyMTIxCTIxMjYJ
MjEzMQkyMTQ4CTIxNTYJMjE2OQkyMTc1CTIxOTQJMjIwOAkyMjExCTIyMjkJMjI0MAkyMjYw
CTIyNzAJMjI3NQkyMjg3CTIzMDEJMjMyMAkyMzMxCTIzNDgJMjM2MwkyMzc3CTIzOTEJMjQw
OAkyNDMxCTI0NDAJMjQ1MQkyNDYyCTI0NzcJMjQ5MgkyNTAyCTI1MDYJMjUxMwkyNTMxCTI1
MzgJMjU1MAkyNTUzCTI1NjIJMjU3MwkyNTg0CTI1OTIJMjYwMgkyNjEzCTI2MTkJMjYyNAky
NjMxCTI2NDAJMjY0NQkyNjUwCTI2NTgJMjY2MQkyNjcwCTI2NzQJMjY4NQkyNjk4CTI3MTYJ
MjcyNAkyNzI5CTI3MzgJMjc1MgkyNzU5CTI3NzAJMjc3MwkyNzg0CTI3ODcJMjc5NAkyODA3
CTI4MTIJMjgxNgkyODE4CTI4MjYJMjgzMgkyODM4CTI4NTEJMjg1NgkyODYxCTI4NzAJMjg3
MwkyODc5CTI4ODQJMjg5MAkyODk1CTI5MDYJMjkxNgkyOTIwCTI5MjcJMjkyOQkyOTQxCTI5
NTYJMjk2NgkyOTc2CTI5ODQJMjk5MAkyOTk5CTMwMTIJMzAxNgkzMDI1CTMwNDQJMzA0OAkz
MDU1CTMwNjIJMzA2NgkzMDc5CTMwODQJMzA5MAkzMDk3CTMxMDIJMzEwOQkzMTE5CTMxMjQJ
MzEyNwkzMTI5CTMxMzIJMzEzNgkzMTM4CTMxNDQJMzE0NwkzMTUxCTMxNTYJMzE2MAkzMTY1
CTMxNjgJMzE3NC4JMzE3OQkzMTgxCTMxODMJMzE5MQkzMTk2CTMyMDYJMzIwOAkzMjEyCTMy
MTcJMzIyNQkzMjI5CTMyMzUJMzI0MwkzMjQ0CTMyNDgJMzI1MgkzMjU1CTMyNjAJMzI2MQkz
MjY2LgkzMjczCTMyNzQJMzI4MQkzMjkxCTMyOTMJMzI5OQkzMzA2CTMzMTAJMzMxMgkzMzE2
CTMzMTgJMzMyMAkzMzIxCTMzMjIJMzMyOAkzMzM0CTMzMzYJMzMzOC4JMzM0MQkzMzQ2CTMz
NTAJMzM1NgkzMzYxCTMzNjIJMzM2MwkzMzY1CTMzNjYJMzM2OQkzMzc0CTMzNzYJMzM4Mwkz
Mzg0CTMzODcJMzM5MwkzMzk1Li4JMzM5NwkzNDAwCTM0MDUJMzQwNgkzNDA4CTM0MDkuCTM0
MTMJMzQxOAkzNDE5CTM0MjAuCTM0MzIuCTM0MzQJMzQzNQkzNDM3CTM0MzkJMzQ0MQkzNDQy
LgkzNDQ3CTM0NTAJMzQ1MQkzNDU0CTM0NTYJMzQ2MwkzNDc1CTM0NzgJMzQ4NAkzNDg4CTM0
OTUJMzUwMAkzNTA1CTM1MTEJMzUyMgkzNTI4CTM1MzQJMzU0NAkzNTU5CTM1NjUJMzU3Mwkz
NTgxCTM1ODgJMzU5NQkzNjAyCTM2MDYJMzYwOQkzNjE1CTM2MjMJMzYzMwkzNjQwCTM2NDQJ
MzY1MgkzNjU1CTM2NjMJMzY3MAkzNjczCTM2NzgJMzY5NAkzNzAzCTM3MTIJMzcyMAkzNzI5
CTM3MzUJMzc0MAkzNzQ4CTM3NTYJMzc2MgkzNzY0CTM3NzMJMzc3OQkzNzg3CTM3ODgJMzc5
NQkzODAxCTM4MDgJMzgyNAkzODMwCTM4MzcJMzg0MQkzODQ5CTM4NjEJMzg3MQkzODc3CTM4
ODcJMzg5MQkzOTAzCTM5MTMJMzkyMwkzOTM1CTM5NDQJMzk1NgkzOTY2CTM5NzkJMzk5NQk0
MDAzCTQwMTAJNDAyNQk0MDMxCTQwNDIJNDA0Nwk0MDUzCTQwNjMJNDA3MQk0MDcyCTQwOTAu
CTQwOTcJNDExMAk0MTM3CTQxNDkJNDE3MQk0MTg5CTQyMDcJNDIyNAk0MjM1CTQyNzAJNDI4
NAk0Mjk3CTQzMTcJNDMyOQk0MzUyCTQzNjIJNDM3Mgk0NDAyCTQ0MjUJNDQ0MQk0NDUzCTQ0
NzkJNDQ5Ngk0NTEyCTQ1MjkJNDU0Mgk0NTUzCTQ1NjkJNDU3Nwk0NTkzCTQ2MDkJNDYxOAk0
NjM1CTQ2MzkJNDY2Mgk0Njc4CTQ3MDEJNDcxNgk0NzI0CTQ3NTUJNDc3Mwk0Nzk1CTQ4MDYJ
NDgyMQk0ODM3CTQ4NDMJNDg3Mgk0ODc2CTQ4ODMJNDg5NQk0OTAxCTQ5MDIuLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgOTgbWzBtCi4u
Li4uCTQ5MDQuCTQ5MDUuLi4uCTQ5MDYuLi4uLgk0OTA5CTQ5MTUuLi4JNDk0MAk0OTQ0CTQ5
NDYuCTQ5NDcJNDk1Mgk0OTU2CTQ5NTgJNDk2MAk0OTYxLgk0OTY0CTQ5NjYJNDk2OQk0OTcx
CTQ5NzIJNDk3My4JNDk3Ngk0OTc3CTQ5ODAJNDk4Mgk0OTkyLgk0OTkzLgk0OTk0CTQ5OTcu
CTUwMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMDcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCltiMDU0MDg3ZGJhY2VlMzBhOWRkZGFlZjJj
OWE5NjMxMjE0NmJlMDRlXSBBTFNBOiBoZGEgLSBSZS1zZXR1cCBIRE1JIHBpbiBhbmQgYXVk
aW8gaW5mb2ZyYW1lIG9uIHN0cmVhbSBzd2l0Y2hlcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14
MS0wOTI4L3RpcDpwZXJmOnVyZ2VudDpiMDU0MDg3ZGJhY2VlMzBhOWRkZGFlZjJjOWE5NjMx
MjE0NmJlMDRlOmJpc2VjdC1kcm0KCjIwMTMtMTAtMDQtMTQ6MjU6NDUgYjA1NDA4N2RiYWNl
ZTMwYTlkZGRhZWYyYzlhOTYzMTIxNDZiZTA0ZSBjb21waWxpbmcKNjYzIHJlYWwgIDE3NzQg
dXNlciAgNDc2IHN5cyAgMzM5LjMxJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgK
CjIwMTMtMTAtMDQtMTQ6Mzc6MzAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjNy0w
MDQ3MC1nYjA1NDA4Ny4uCTgJMTcJMTgJMTkJMjIJMjMJMjYJMjkJMzIuCTM3CTQyCTQ5CTUy
CTU3CTYxCTY5CTc3CTg2CTk1CTEwNAkxMTMJMTIwCTEyNQkxMzIJMTM3CTE1MQkxNTYJMTYz
CTE3MAkxNzcJMTkxCTIwMQkyMTEJMjI1CTIzNQkyNDYJMjUxCTI2MQkyNjcJMjc3CTI5NAkz
MDIJMzE2CTMyMwkzMjcJMzMwCTMzNgkzNDAJMzQ2CTM1MwkzNTgJMzY1CTM3MAkzNzgJMzg4
CTQwNgk0MTkJNDI2CTQ0MAk0NTUJNDYyCTQ2OQk0NzcJNDg1CTQ5NAk0OTgJNTA3CTUxNAk1
MjIJNTI1CTUyNgk1MzEJNTM0CTU0Mgk1NTAJNTU2CTU2MAk1NjYJNTcyCTU3Nwk1ODcJNTk0
CTU5OAk2MDUJNjA5CTYxMwk2MTgJNjIyCTYyNi4JNjI3CTYzMgk2MzUJNjM2CTYzOQk2NDEJ
NjQ3CTY1MQk2NTUJNjU3CTY1OAk2NTkJNjYwCTY2Mgk2NjQJNjY4CTY2OS4JNjcyCTY3Mwk2
NzQJNjc2CTY4MAk2ODEJNjg0CTY5MQk2OTQJNjk2CTY5OQk3MDUJNzEyCTcxNgk3MTkJNzI1
CTcyOAk3MzcJNzQwCTc0Mwk3NDcJNzU1CTc1OAk3NjYJNzY4CTc3Mwk3NzUJNzc3CTc4Mgk3
ODkJNzk2CTc5Nwk4MDQJODA2CTgxMQk4MTgJODI1CTgzMwk4NDIJODQ2CTg1Mgk4NTUJODY0
CTg3Mgk4NzUJODc4CTg4NAk4ODgJODkzCTkwMgk5MDgJOTEzCTkxNwk5MjkJOTM0CTkzNwk5
NDAJOTUwCTk1Ngk5NjAJOTY4CTk3MAk5NzUJOTgyCTk5MgkxMDAxCTEwMDQJMTAwOAkxMDEx
CTEwMjYJMTAzNgkxMDQ2CTEwNDcJMTA1NQkxMDU4CTEwNjUJMTA3MQkxMDc3CTEwODAJMTA4
NQkxMDkxCTEwOTgJMTEwMAkxMTAzCTExMDcJMTExMAkxMTEyCTExMTkJMTEzMAkxMTM0CTEx
NDUJMTE1MwkxMTU1CTExNjIJMTE2NAkxMTc3CTExODEJMTE4NAkxMTg3CTExOTAJMTIwMgkx
MjA0CTEyMTYJMTIyMAkxMjIyCTEyMjkuCTEyMzAuCTEyNDIJMTI0NgkxMjQ3CTEyNDkJMTI1
MS4JMTI1NwkxMjYwCTEyNjQJMTI2NwkxMjc1CTEyNzkJMTI4MAkxMjg4CTEyOTYJMTMwMAkx
MzA3CTEzMTQJMTMyMAkxMzIxCTEzMjYJMTMzMAkxMzMxCTEzMzYJMTM0MQkxMzQ0CTEzNDUJ
MTM2MQkxMzYyCTEzNjUuCTEzNjkJMTM3MQkxMzc0CTEzNzkJMTM4MgkxMzg0CTEzODgJMTM5
MQkxMzk0CTEzOTYJMTQwMAkxNDA5CTE0MTIJMTQxOAkxNDE5CTE0MjEJMTQyMgkxNDIzLgkx
NDI1CTE0MjYJMTQyNwkxNDI4Li4uCTE0MjkJMTQzMAkxNDMyCTE0MzMuCTE0MzUJMTQzNwkx
NDQxCTE0NDQJMTQ0OQkxNDUzCTE0NTQuCTE0NTUJMTQ1NwkxNDYzCTE0NjQJMTQ2NgkxNDcy
CTE0NzcuCTE0ODAJMTQ4NAkxNDkxCTE1MDAJMTUwNAkxNTEwCTE1MTMJMTUxNwkxNTE5Lgkx
NTIyLi4JMTUyNAkxNTI2Li4JMTUyNy4JMTUyOS4JMTUzMAkxNTMxCTE1MzIJMTUzMwkxNTM1
CTE1MzcJMTU0NAkxNTQ3CTE1NDkJMTU1MQkxNTU2CTE1NTguCTE1NjIJMTU2MwkxNTY0Li4J
MTU3MS4JMTU4MwkxNTkxCTE2MDAJMTYwNwkxNjEzCTE2MjQJMTYyOQkxNjM5CTE2NDcJMTY1
MQkxNjUyCTE2NjEJMTY2NgkxNjcyCTE2NzgJMTY4MQkxNjkzCTE3MDIJMTcxNAkxNzI1CTE3
MzEuCTE3MzcJMTc0Mi4JMTc1MQkxNzU3CTE3NjEJMTc2NAkxNzcxCTE3NzIJMTc3NgkxNzgy
CTE3ODQJMTc5MQkxNzk3CTE4MDYJMTgxMAkxODIwCTE4MzAJMTgzNwkxODQwCTE4NDMJMTg0
NgkxODQ5CTE4NTUJMTg1NgkxODYxCTE4NjQJMTg2OQkxODc4LgkxODg0CTE4OTAJMTg5Mgkx
ODk3CTE5MDIJMTkxMgkxOTE0CTE5MTgJMTkyMQkxOTI0CTE5MzAJMTkzNC4JMTkzNwkxOTQz
CTE5NDYJMTk1MgkxOTU0CTE5NTYJMTk1OAkxOTYzCTE5NjkJMTk3NAkxOTc2CTE5NzgJMTk4
NwkxOTkwCTE5OTYJMjAwMgkyMDA1CTIwMDgJMjAxNQkyMDIxCTIwMjYJMjAzMQkyMDM1CTIw
NDEJMjA0OAkyMDU1CTIwNTkJMjA2MgkyMDY0CTIwNzIJMjA4MQkyMDg1CTIwOTIJMjEwMS4J
MjEwNAkyMTEyCTIxMTQJMjExNQkyMTE5CTIxMjMJMjEyNQkyMTI3CTIxMzIJMjEzMwkyMTM1
CTIxMzgJMjE0MQkyMTQ1CTIxNDYJMjE0OQkyMTUzCTIxNTcJMjE1OAkyMTU5CTIxNjEJMjE2
NC4JMjE2NS4JMjE2OQkyMTc1CTIxNzcJMjE4MgkyMTg1CTIxODgJMjE5MAkyMTk2CTIyMTIJ
MjIxNQkyMjI3CTIyMjgJMjI0NQkyMjU4CTIyNzAJMjI3OQkyMjg5CTIyOTIJMjI5OAkyMzA3
CTIzMDkJMjMxOQkyMzI2CTIzMzIJMjMzNgkyMzQxCTIzNDkJMjM2MgkyMzY1CTIzNzMJMjM4
NAkyMzk0CTI0MDUJMjQxNAkyNDIzCTI0MzMJMjQ0MAkyNDQ1CTI0NDgJMjQ1OAkyNDY0CTI0
NjgJMjQ3MQkyNDg1CTI0OTMuCTI0OTQJMjUwMAkyNTAyCTI1MDQuCTI1MDUuCTI1MDcJMjUw
OQkyNTEwCTI1MTMJMjUyMQkyNTI2CTI1MjkuCTI1MzguCTI1NDIJMjU0NgkyNTQ3CTI1NTQJ
MjU2MQkyNTY3CTI1NjkJMjU3NQkyNTg0CTI1OTEJMjU5NS4uCTI2MjAJMjYzNQkyNjQzCTI2
NDcJMjY1MAkyNjUxCTI2NTYJMjY2MS4JMjY2NAkyNjc1LgkyNjgwLgkyNjg4CTI2OTMuCTI2
OTguLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjg3
MS4uLi4uLi4uLi4uLi4uLi4uLgkyOTM2Li4uLi4uCTI5NTMuLi4uLi4uLi4uLi4uLi4uLi4J
MzAwNi4uLi4JMzAyMy4uLi4uLi4uLi4uLi4uLi4uLgkzMDgzLi4uLi4uLi4uCTMxMjUuLi4J
MzE0Ni4JMzE1OQkzMTYwCTMxNjcuLgkzMTc2LgkzMTc4LgkzMTgxLgkzMTg0CTMxODcuCTMx
ODkuLgkzMTkyLgkzMTk3CTMxOTgJMzIwMQkzMjAzCTMyMDQJMzIwNwkzMjExCTMyMTIJMzIx
NAkzMjE4CTMyMjEJMzIyMgkzMjI1CTMyMzMJMzIzOQkzMjQxCTMyNDMuLgkzMjQ4LgkzMjQ5
CTMyNTIJMzI1Ni4JMzI1NwkzMjYwLgkzMjY3CTMyNzAJMzI3MgkzMjczCTMyNzQJMzI3Nwkz
MjgwCTMyODMJMzI4OAkzMjk0CTMzMDAJMzMwMy4JMzMwNgkzMzEzCTMzMTgJMzMyMgkzMzIz
CTMzMjQuCTMzMjcJMzMzMQkzMzM5CTMzNDEJMzM0MwkzMzQ1CTMzNDcJMzM0OQkzMzU3CTMz
NTkJMzM2NQkzMzczCTMzODEJMzM4NAkzMzk3CTM0MDAJMzQwNi4JMzQxMQkzNDE1CTM0MTcu
CTM0MjAJMzQyNgkzNDMyCTM0MzgJMzQ0NAkzNDUyCTM0NjQJMzQ2OAkzNDczCTM0ODEJMzQ5
MS4JMzUwMQkzNTEyCTM1MTYJMzUyMwkzNTMzCTM1NDQJMzU0NgkzNTUxCTM1NjAJMzU2NQkz
NTc4CTM1ODIJMzU5MQkzNjAxCTM2MDMJMzYxNgkzNjIyCTM2MjMJMzYyOQkzNjMxCTM2MzIJ
MzYzMwkzNjM2CTM2MzgJMzYzOS4uCTM2NDIJMzY0My4uLgkzNjQ2LgkzNjQ4Li4uCTM2NDku
Li4uCTM2NTUJMzY1OAkzNjY1CTM2NjcJMzY2OAkzNjczCTM2NzcJMzY3OQkzNjg0CTM2ODYJ
MzY4OQkzNjk2CTM3MDUJMzcxMQkzNzIxCTM3MzEJMzczOQkzNzQ1CTM3NDkJMzc1MAkzNzU0
CTM3NTcJMzc1OS4JMzc2MS4uCTM3NjIJMzc2MwkzNzY2CTM3NjcuCTM3NjgJMzc2OS4uLgkz
NzcwCTM3NzEuCTM3NzIuCTM3NzMJMzc3NAkzNzc4CTM3OTAJMzc5MgkzODA5CTM4MTIJMzgx
OAkzODIxCTM4MzEJMzgzNgkzODQwCTM4NDUJMzg1MAkzODU0Li4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk0MDYxCTQwNzEJNDA3OQk0MDgzCTQwODYJ
NDA4OAk0MDkyCTQwOTYJNDEwNAk0MTA1CTQxMDcJNDExMgk0MTE2CTQxMTkJNDEyMQk0MTI3
CTQxMzUJNDE0Mgk0MTQ0CTQxNTIJNDE2MAk0MTcxCTQxNzUJNDE4Nwk0MTk1CTQxOTgJNDE5
OQk0MjAzCTQyMDUJNDIwNgk0MjEwCTQyMTEuLi4uLi4uLi4uLi4uLi4uLi4uCTQyOTEuCTQz
MDIJNDMwNgk0MzA4CTQzMTQJNDMyNS4uLi4uLi4uLi4JNDM5NS4uCTQ0MjMJNDQyNwk0NDM4
CTQ0NDUJNDQ1NAk0NDYxCTQ0NjYJNDQ2OQk0NDczCTQ0NzUJNDQ3Ngk0NDc5CTQ0ODAJNDQ4
Mgk0NDkxCTQ0OTYJNDQ5OQk0NTA1CTQ1MDkJNDUxMQk0NTIyCTQ1MjQJNDUyNgk0NTI4CTQ1
MzEJNDUzOQk0NTQwCTQ1NDQJNDU1Mgk0NTUzLgk0NTU5CTQ1NjEJNDU2Ngk0NTcyCTQ1NzYJ
NDU4Mgk0NTg1CTQ1ODcJNDU5OQk0NjA2CTQ2MTQJNDYxNwk0NjIzCTQ2MzIJNDYzOQk0NjQ1
CTQ2NDkJNDY2MAk0NjY0CTQ2NjcJNDY3Mwk0Njc1CTQ2NzYJNDY4MQk0NjkzCTQ3MDAJNDcw
Ngk0NzE3CTQ3MjIJNDcyNwk0NzMyCTQ3MzYJNDc0MAk0NzQ2CTQ3NTMJNDc1Nwk0NzU5CTQ3
NjUJNDc2Nwk0NzcxCTQ3NzYJNDc3Nwk0Nzc4CTQ3ODcJNDc5MAk0Nzk2CTQ3OTkJNDgwMwk0
ODA2CTQ4MTAJNDgxNwk0ODIyCTQ4MjkJNDgzMgk0ODM5CTQ4NDMJNDg0NQk0ODQ5CTQ4NTMJ
NDg1Ngk0ODYxCTQ4NjIJNDg2OAk0ODcyCTQ4NzUJNDg3Ny4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4JNDg3OC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNDg4MAk0ODgxCTQ4ODMJNDg4Ngk0ODg3
CTQ4ODkJNDg5Mgk0ODk1CTQ4OTgJNDkwMwk0OTA0CTQ5MDcuLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk0OTA4Lgk0OTEwCTQ5MTIu
Lgk0OTE2Lgk0OTE4Li4uLgk0OTIzCTQ5MjYJNDkyNy4JNDkyOQk0OTMwLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTQ5MzQuCTQ5Mzgu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTQ5NTIuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLgk0OTU0CTQ5NTcuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk0OTYyCTQ5NjUJNDk2Ngk0
OTcwCTQ5NzEJNDk3NC4uCTQ5NzUuCTQ5NzYuLgk0OTc3Li4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4JNDk3OAk0OTc5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4J
NDk5MC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNDk5OS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLgk1MDAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTAzIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbMWNiOTUzOTU4
NzBkNjhmOWZmNjc5ZGI0MmZhMTVlYTAzMjAxZmMwOF0gcGluY3RybDogcm9ja2NoaXA6IFNp
bXBsaWZ5IGZvciBsb29wIGl0ZXJhdGlvbgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1h
IC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4
L3RpcDpwZXJmOnVyZ2VudDoxY2I5NTM5NTg3MGQ2OGY5ZmY2NzlkYjQyZmExNWVhMDMyMDFm
YzA4OmJpc2VjdC1kcm0KCjIwMTMtMTAtMDUtMTA6MDI6MjYgMWNiOTUzOTU4NzBkNjhmOWZm
Njc5ZGI0MmZhMTVlYTAzMjAxZmMwOCBjb21waWxpbmcKNjExIHJlYWwgIDE4MjQgdXNlciAg
NDkwIHN5cyAgMzc4LjMwJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgKCjIwMTMt
MTAtMDUtMTA6MTM6MjcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLXJjMS0wMDEwNC1n
MWNiOTUzOS4uCTMJMTIJMTYJMTgJMjYJMzYJNDcJNTUJNjQJNjkJODMJOTEJOTcJMTExCTEx
NQkxMTcJMTE5CTEyOQkxMzUJMTQ1CTE2MQkxNjgJMTcyCTE4NwkxOTUJMjAwCTIwNwkyMjIJ
MjMzCTI0MAkyNTUJMjYxCTI2NAkyNzIJMjgyCTI4OAkyOTIJMzAyCTMxMQkzMTcJMzIyCTMz
MQkzMzYJMzM4CTM1MQkzNTgJMzYxCTM2NgkzNjgJMzc0CTM4MQkzODYJMzkzCTM5OQk0MTYJ
NDE5CTQzMAk0MzMJNDQyCTQ0Nwk0NjAJNDcwCTQ3NQk0ODUJNDk1CTUwMAk1MDcJNTE0CTUx
OAk1MjIJNTI1CTUzMwk1NDAJNTQzCTU0OQk1NTQJNTYwCTU2NQk1NzAuCTU3Nwk1ODIJNTg5
CTU5NQk2MDQJNjA4CTYxNAk2MjUJNjMxCTYzNAk2NDcJNjQ5CTY1Mwk2NjQJNjcwCTY3Ngk2
ODUJNjkxCTY5Mwk2OTkJNzA4CTcxMwk3MTcJNzI0CTcyNwk3MzEJNzQwCTc0Nwk3NTMJNzU1
CTc1OQk3NjgJNzcyCTc3NQk3ODUJNzg5CTc5MQk3OTgJODAwCTgwMwk4MDcJODEwCTgxNgk4
MjIJODMyCTgzOQk4NDcJODUxCTg1OAk4NjUJODY4CTg3Ngk4ODEJODg0CTg5Mwk5MDIJOTEw
CTkxOAk5MjYJOTMyCTkzNwk5NDcJOTU1CTk2MAk5NjQJOTc2CTk3OQk5ODYJOTk1CTEwMDMJ
MTAxMQkxMDE4CTEwMjEJMTAyNQkxMDMyCTEwNDEJMTA1MAkxMDUyCTEwNjQJMTA3MQkxMDc0
CTEwODAJMTA4NgkxMDk3CTExMDQJMTExNAkxMTE5CTExMjcJMTE0MAkxMTQ3CTExNTEJMTE2
NQkxMTcxCTExNzcJMTE4NAkxMTg5CTExOTAJMTE5NgkxMjAxCTEyMDcJMTIxMgkxMjE1CTEy
MTkJMTIyNAkxMjI5CTEyMzUJMTI0NAkxMjQ5CTEyNTkJMTI2MAkxMjY4CTEyNzYJMTI3Nwkx
Mjg4CTEyOTQJMTI5NgkxMjk5CTEzMTMJMTMyMAkxMzI2CTEzMzMJMTMzNQkxMzQzCTEzNTIJ
MTM1NQkxMzU5CTEzNjgJMTM4NQkxMzg5CTEzOTYJMTQwOQkxNDExCTE0MTYuCTE0MjQuLi4J
MTQzOAkxNDc0CTE0ODEJMTQ4OQkxNDkzCTE1MTIJMTUxOAkxNTI1CTE1MzQJMTU0MQkxNTQ3
CTE1NTUJMTU3MAkxNTg5CTE2MDIJMTYwNwkxNjE4CTE2MzMJMTY0MAkxNjY0CTE2NzgJMTcw
MQkxNzE1CTE3MzIJMTc1NAkxNzY2CTE3NzcJMTc5MAkxODE0CTE4MjkJMTg0OAkxODY0CTE4
NzAJMTg5NQkxOTEwCTE5MTkJMTk0MQkxOTQ5CTE5NjUJMTk5MQkyMDA2CTIwMTYJMjAzMwky
MDUzCTIwNjYJMjA4NQkyMDk1CTIxMDUJMjEyNwkyMTM1CTIxNDkJMjE2NQkyMTc0CTIxODEJ
MjE5OAkyMjA5CTIyMjAJMjIzNQkyMjU0CTIyNzgJMjI4NwkyMzA5CTIzMjUJMjMzNwkyMzU1
CTIzNzUJMjM4MAkyMzk3CTI0MTcJMjQzMwkyNDUyCTI0NjcJMjQ3OQkyNDk5CTI1MjUJMjU0
MQkyNTU4CTI1NzcJMjU4NQkyNTg2LgkyNjI4CTI2MzkJMjY2NwkyNjg1CTI3MDQJMjcxOAky
NzQwCTI3NTIJMjc2MwkyNzg4CTI4MDYJMjgxMwkyODUxCTI4NjIJMjg3NgkyODkwCTI5MDEJ
MjkyMgkyOTQ5CTI5NjkJMjk4NwkzMDEyCTMwMjYJMzA0NAkzMDU5CTMwODAJMzEwNwkzMTIw
CTMxMzUJMzE1NAkzMTY2CTMxOTYJMzIzNgkzMjU3CTMyODIJMzMxMAkzMzIyCTMzNDYJMzM3
OAkzMzk1CTM0MTIJMzQ0MgkzNDYwCTM0ODQJMzUwNwkzNTM0CTM1NDIJMzU4NQkzNjE0CTM2
NDEJMzY1OQkzNjk1CTM3MTUJMzc0MgkzNzY1CTM4MDUJMzgzNQkzODUyCTM4ODkJMzkyNAkz
OTYwCTM5ODUJNDAxOQk0MDM5CTQwNjgJNDEwMwk0MTI1CTQxMzgJNDE3NQk0MjI0CTQyNDYJ
NDI2NAk0MzAwCTQzMjQJNDM2MAk0Mzg1CTQ0MDgJNDQ0OAk0NDcwCTQ0OTkJNDUzMQk0NTU5
CTQ1ODIJNDYxMgk0NjQxCTQ2NzAJNDY5Ngk0NzI3CTQ3ODIJNDgxNQk0ODQzCTQ4NzkJNDkx
NQk0OTQwCTQ5NjkJNDk3Mi4uLgk0OTczLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
LhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDI3G1swbQouLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLgk1MDAwIFNVQ0NFU1MKCkJpc2VjdGluZzogNTEgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpClthZTY3ZDlhODg4YTAwMGE5
ZGY0M2RlMTBlYjk5NTAwNzVlOTM1MDhjXSBNZXJnZSB0YWcgJ2V4dDRfZm9yX2xpbnVzJyBv
ZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdHl0c28v
ZXh0NApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L3RpcDpwZXJmOnVyZ2VudDphZTY3
ZDlhODg4YTAwMGE5ZGY0M2RlMTBlYjk5NTAwNzVlOTM1MDhjOmJpc2VjdC1kcm0KCjIwMTMt
MTAtMDUtMTY6MjE6MTAgYWU2N2Q5YTg4OGEwMDBhOWRmNDNkZTEwZWI5OTUwMDc1ZTkzNTA4
YyBjb21waWxpbmcKMzM3IHJlYWwgIDE5MDEgdXNlciAgNDkyIHN5cyAgNzA5LjczJSBjcHUg
CXg4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgKCjIwMTMtMTAtMDUtMTY6Mjc6MjQgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLTAzNzQ2LWdhZTY3ZDlhLi4uLi4uLgkyMDcuLi4uLi4J
MjE2CTQ2OS4JNTU5Li4uLi4uLi4JNjU4CTg2Mi4JOTU1CTEwMDMuCTEwNjIJMTExOAkxMTc2
CTEyMzIJMTI3NwkxMzEzCTEzNDcJMTM2OQkxNDIzCTE0OTEJMTU1NwkxNjQyCTE3MTYJMTc4
NwkxODU4CTE5MjAJMTk5MAkyMDY3CTIxMTkJMjE4MgkyMjUwCTIzMjgJMjM4NQkyNDM2CTI1
MTIJMjU2NgkyNjM1CTI3MDMJMjc2MwkyODIxCTI4OTYJMjkyOQkyOTgwCTMwMjQuCTMwNTEJ
MzEzMwkzMjU5CTMzNDIJMzQyNwkzNTQ5CTM2NjUJMzc1NgkzODgwCTM5ODQJNDA2NQk0MjAz
CTQzMDQJNDQwNwk0NDk4CTQ2MDMJNDczNQk0ODIyLi4uLgk0ODU5CTUwMDAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiAyMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgNSBzdGVwcykKWzMzOThkMjUyYTRkYTgwYzQ3ZmU5YjgwMjE4NGZhMGE3OTIzODc3MzJd
IE1lcmdlIHRhZyAnbW9kdWxlcy1uZXh0LWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3J1c3R5L2xpbnV4CnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvZHJt
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLXgxLTA5MjgvdGlwOnBlcmY6dXJnZW50OjMzOThkMjUyYTRkYTgwYzQ3ZmU5
YjgwMjE4NGZhMGE3OTIzODc3MzI6YmlzZWN0LWRybQoKMjAxMy0xMC0wNS0xNzoxMjo1NiAz
Mzk4ZDI1MmE0ZGE4MGM0N2ZlOWI4MDIxODRmYTBhNzkyMzg3NzMyIGNvbXBpbGluZwoyNzcg
cmVhbCAgMTg5OSB1c2VyICA1MzUgc3lzICA4NzguNzElIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWcteDEtMDkyOAoKMjAxMy0xMC0wNS0xNzoxODowNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjExLjAtMDM3NzQtZzMzOThkMjUJMTgJNDEJNzAJMTA2CTE2MAkyMjAJMjc0CTMyOQkzNjkJ
NDE3CTQ2OAk1MTEJNTM4CTU4OQk2MTEJNjQ1CTY2Ny4JNzA1CTczMAk3NjMJNzkxCTgxMQk4
NDQJODc1CTg5OAk5MzEJOTU0CTk3OQkxMDA0CTEwMzAJMTA1OQkxMDgyCTExMDQJMTE0NAkx
MTc1CTEyMTEJMTI0MgkxMjY4CTEyODkJMTMwNgkxMzIxCTEzMzYJMTM0MC4JMTM0NAkxMzc4
CTE0NDkJMTQ4OQkxNTUyCTE2MTQJMTY3NwkxNzM1CTE3ODMJMTgzOQkxODk5CTE5NTMJMjAx
MAkyMDY4CTIxMjcJMjE5MwkyMjU3CTIzMTYJMjM3OAkyNDE5CTI0NjkJMjUyNAkyNTcyCTI2
MjEJMjY3MgkyNzI3CTI3NjUJMjgxMwkyODY4CTI5MTIJMjk2MwkzMDE1CTMwNjkJMzEzMAkz
MTkwCTMyNTIJMzMxMwkzMzUxLgkzMzg1CTM0NDQJMzUwNAkzNTYzCTM2MjEJMzY4MgkzNzQ0
CTM4MDMJMzg2MQkzOTIwCTM5NzkJNDAzNwk0MDk1CTQxNTMJNDIxMgk0MjcwCTQzMjgJNDM4
Ngk0NDQ1CTQ1MDMJNDU2Mwk0NjIxCTQ3MDQJNDgxOQk0OTM5CTUwMDAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAxMSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
NCBzdGVwcykKW2ZiNThlMzAwOTFjNzQ5NjdmNmI4ZTk4YjNjMWYyOTI3ODJmOTJiNDFdIHg4
Ni94ZW46IGRpc2FibGUgcHJlbXB0aW9uIHdoZW4gZW5hYmxpbmcgbG9jYWwgaXJxcwpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUv
d2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L3RpcDpwZXJmOnVyZ2VudDpmYjU4ZTMwMDkxYzc0
OTY3ZjZiOGU5OGIzYzFmMjkyNzgyZjkyYjQxOmJpc2VjdC1kcm0KCjIwMTMtMTAtMDUtMTg6
MTM6MTEgZmI1OGUzMDA5MWM3NDk2N2Y2YjhlOThiM2MxZjI5Mjc4MmY5MmI0MSBjb21waWxp
bmcKMjc2IHJlYWwgIDE4ODcgdXNlciAgNTMxIHN5cyAgODc1LjUwJSBjcHUgCXg4Nl82NC1y
YW5kY29uZmlnLXgxLTA5MjgKCjIwMTMtMTAtMDUtMTg6MTg6MjUgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMS4wLXJjNC0wMDAxMi1nZmI1OGUzMC4uLi4uCTEuLi4JMi4uLi4uCTcJMTEu
LgkxMgkxNgkyNAkzNQk0NAk1Mwk2NQk4MAk4Ngk5OQkxMDkJMTE3CTEyOQkxNDEJMTUzCTE2
MwkxODAJMTk2CTIxNgkyMjIJMjI5CTIzNAkyNDQJMjUxCTI2OQkzMTUJMzgyCTQ1MAk1MzYJ
NjE5CTcwOQk4MDkJODk3CTk5NQkxMDY2CTExNDYJMTI1MwkxMzU2CTE0MzMJMTUxMwkxNjA0
CTE3MTQJMTc5OAkxOTAzCTE5OTcJMjA4NQkyMTgyCTIyODkJMjM3MgkyNDgyCTI1NjYJMjY2
NAkyNzQ2CTI4NDIJMjkyNgkyOTY0LgkzMTQxCTMyMTUJMzMyNQkzNDQ1CTM1MzQJMzYyMAkz
NjgxCTM3NjgJMzg2OQkzOTQ1CTQwMDkJNDEyNQk0MjEwCTQyOTQJNDM5NQk0NDUzCTQ1NDcJ
NDY1MAk0NzE2CTQ3OTkJNDg1OQk0OTE0CTQ5MjIJNDk5Mwk0OTk4Li4JNTAwMCBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDMgc3RlcHMpCls2NjliMGFlOTYxZTg3YzgyNDIzMzQ3NWU5ODdiMmQzOTk5NmQ0ODQ5
XSB4ZW4vcHZodm06IEluaXRpYWxpemUgeGVuIHBhbmljIGhhbmRsZXIgZm9yIFBWSFZNIGd1
ZXN0cwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L3RpcDpwZXJmOnVyZ2VudDo2Njli
MGFlOTYxZTg3YzgyNDIzMzQ3NWU5ODdiMmQzOTk5NmQ0ODQ5OmJpc2VjdC1kcm0KCjIwMTMt
MTAtMDUtMTk6MTA6MjggNjY5YjBhZTk2MWU4N2M4MjQyMzM0NzVlOTg3YjJkMzk5OTZkNDg0
OSBjb21waWxpbmcKMjQyIHJlYWwgIDQ1NiB1c2VyICAzODggc3lzICAzNDguMDUlIGNwdSAJ
eDg2XzY0LXJhbmRjb25maWcteDEtMDkyOAoKMjAxMy0xMC0wNS0xOToxNTowOSBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjExLjAtcmM0LTAwMDE4LWc2NjliMGFlLi4uCTEuCTIuLi4uLi4u
Li4JMy4JNC4uLi4uLgk1Li4JNi4JNwk5LgkxMAkxMQkxMi4JMTMuCTE0CTE1Li4JMTYJMTcu
CTE4LgkxOQkyNAk3NgkxMjQJMTY0CTI1MAkzMzUJNDA3CTUxMgk1OTIJNjU1CTcyOAk3ODQJ
ODI2CTkyMwk5NjUJMTA1MQkxMTMyCTExOTEJMTI0MAkxMzAwCTEzNzAJMTQzNgkxNDkyCTE1
NjcJMTYyMgkxNjkwCTE3NDQJMTc4NAkxODQ3CTE4ODUJMTkzNAkxOTkwCTIwMzYJMjA2NQky
MTQyCTIxODcJMjI1MQkyMzAyCTIzNDIJMjM5MAkyNDM5CTI0ODcJMjUyNgkyNTU5CTI2MDAJ
MjYyNAkyNjU0CTI3MDEJMjcyOAkyNzYwCTI4MDEJMjg0MAkyODczCTI5MDIJMjkzMgkyOTg5
CTMwMjMJMzA1MAkzMTAyCTMxNDEJMzE3MgkzMjI2CTMyNTgJMzMwMwkzMzMyCTMzNjcJMzQw
MAkzNDM5CTM0NzMJMzUwNAkzNTM4CTM1ODUJMzYxMwkzNjQ2CTM2OTMJMzcyNwkzNzUwCTM3
NjgJMzgxMgkzODI5CTM4NzMJMzkwMwkzOTI3CTM5NjMJMzk5OQk0MDM0CTQwNjIJNDA5Ngk0
MTI2CTQxNTgJNDE4Nwk0MjI1CTQyNTgJNDI3OAk0Mjg4CTQzMzIJNDM4MAk0NDEyCTQ0NjEJ
NDQ4Mgk0NTE4CTQ1NDcJNDU4NQk0NjE5CTQ2NTkJNDY5NAk0NzIxCTQ3NjYJNDc5MAk0ODI3
CTQ4NjEJNDg5NAk0OTM0CTQ5NTYJNDk4Mwk0OTk5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDEbWzBtCi4uCTUwMDAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAyIHN0ZXBzKQpbMDQ2NjBiYjVkMGU0MTA0ZTAxYThmYzM0ZTVkNTFkZTFkODRjMDliZl0g
eGVuL2JhbGxvb246IGRvbid0IHNldCBQMk0gZW50cnkgZm9yIGF1dG8gdHJhbnNsYXRlZCBn
dWVzdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2hvbWUvd2ZnL2RybS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L3RpcDpwZXJmOnVyZ2VudDowNDY2
MGJiNWQwZTQxMDRlMDFhOGZjMzRlNWQ1MWRlMWQ4NGMwOWJmOmJpc2VjdC1kcm0KCjIwMTMt
MTAtMDUtMjM6MDk6MjAgMDQ2NjBiYjVkMGU0MTA0ZTAxYThmYzM0ZTVkNTFkZTFkODRjMDli
ZiBjb21waWxpbmcKMjU3IHJlYWwgIDQ3NCB1c2VyICAzMTAgc3lzICAzMDUuMjAlIGNwdSAJ
eDg2XzY0LXJhbmRjb25maWcteDEtMDkyOAoKMjAxMy0xMC0wNS0yMzoxNDo1NyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjExLjAtcmM0LTAwMDIxLWcwNDY2MGJiLi4JNAkyMQk0NAk2MAk5
NwkxMTYJMTU3CTE5NAkyMjkJMjUzCTMxNQkzNjEJNDMwCTQ1Nwk0ODQJNTMxCTU1OAk2MDIJ
NjU5CTY4NQk2OTcJNzAwCTcwMQk3MTMJNzE3CTcyNwk3MzgJNzUzCTc2Ngk3ODkJODE0CTg5
OAkxMDAxCTEwNjgJMTI2MC4JMTQwNAkxNDcxLi4JMTU0NQkxNjIxCTE2NzkJMTc1MQkxOTE0
CTIxMDgJMjI3MgkyMzgwCTI0NTkJMjUzMQkyNTM4CTI2MDQJMjY3NwkyNzUxCTI4MjQJMjg5
NwkyOTY5CTMwNDAJMzEwNwkzMTQ0CTMyMTMJMzI4MQkzMzUxCTM0MjEJMzQ4OQkzNTU4CTM2
MjgJMzcwMAkzODQ3CTQwMjMJNDIyNQk0NDA1CTQ2MjIJNDg0NQk1MDAwIFNVQ0NFU1MKCkJp
c2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MSBzdGVwKQpbMjNiN2VhZjgyMjA3MjE4OTI5NzU2MTBkZDBhZTVjODQ2YTM0ZGNiNF0gaHZj
X3hlbjogUmVtb3ZlIHVubmVjZXNzYXJ5IF9fR0ZQX1pFUk8gZnJvbSBremFsbG9jCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93
ZmcvZHJtL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvdGlwOnBlcmY6dXJnZW50OjIzYjdlYWY4MjIwNzIx
ODkyOTc1NjEwZGQwYWU1Yzg0NmEzNGRjYjQ6YmlzZWN0LWRybQoKMjAxMy0xMC0wNS0yMzo1
MzoyOSAyM2I3ZWFmODIyMDcyMTg5Mjk3NTYxMGRkMGFlNWM4NDZhMzRkY2I0IGNvbXBpbGlu
ZwoyMjcgcmVhbCAgNDcxIHVzZXIgIDM2MCBzeXMgIDM2NS42MSUgY3B1IAl4ODZfNjQtcmFu
ZGNvbmZpZy14MS0wOTI4CgoyMDEzLTEwLTA1LTIzOjU3OjUxIGRldGVjdGluZyBib290IHN0
YXRlIDMuMTEuMC1yYzQtMDAwMjMtZzIzYjdlYWYuLgk0MwkxNDUJMTk1CTMyNQk0NTUJNjEx
CTcxMgk4NDMJOTM1CTEwMTUJMTA5MAkxMTkyCTEyOTUJMTM2NQkxNDM3CTE1MjYJMTYxMgkx
NjU5CTE3MjkJMTc4NQkxODcxCTE5MzYJMjAwMQkyMDY0CTIxMTQJMjE2NgkyMjE2CTIyODEJ
MjM1MAkyMzk0CTI0NzIJMjUyMgkyNTgyCTI2MzkJMjcxOAkyNzgwCTI4NzkJMjkyNwkyOTY0
CTMwNjgJMzE0OQkzMjIyCTMyODAJMzMxMgkzMzU5CTM0MDcJMzQ0OQkzNDk2CTM1MzEJMzU1
NAkzNTg0CTM2MzQJMzY1OQkzNjkzCTM3MjYJMzc2MAkzNzk3CTM4MjUJMzg1NwkzODkwCTM5
MjAJMzk1NQkzOTkzCTQwMTcJNDA0NQk0MDcwCTQxMDAJNDEzOAk0MTczCTQyMTQJNDI0NAk0
Mjc4Lgk0MzE2Lgk0MzgwCTQzODcJNDQ1Nwk0NTE1CTQ1NDEJNDU4Mgk0NjA3CTQ2NDgJNDY3
NAk0NzA2CTQ3MzkJNDc2OAk0Nzk2CTQ4MjYJNDg0OQk0ODgzCTQ5MTIJNDk1Mgk0OTg5CTQ5
OTQJNDk5NS4JNDk5Ni4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRk
X3RvX3J1bl9xdWV1ZSA0G1swbQouLgk1MDAwIFNVQ0NFU1MKCmNmMzljOGU1MzUyYjRmYjll
ZmVkZmU3ZTlhY2I1NjZhODVlZDg0N2MgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKYmlzZWN0
IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy14MS0wOTI4L3RpcDpwZXJmOnVyZ2VudDozMzk4ZDI1MmE0ZGE4MGM0N2Zl
OWI4MDIxODRmYTBhNzkyMzg3NzMyOmJpc2VjdC1kcm0KCjIwMTMtMTAtMDYtMDM6MjA6MDAg
MzM5OGQyNTJhNGRhODBjNDdmZTliODAyMTg0ZmEwYTc5MjM4NzczMiByZXVzZSAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvMzM5OGQyNTJhNGRhODBjNDdmZTliODAyMTg0
ZmEwYTc5MjM4NzczMi92bWxpbnV6LTMuMTEuMC0wMzc3NC1nMzM5OGQyNQobWzE7MzVtYWRk
X3RvX3J1bl9xdWV1ZTogcmVxdWVzdGVkIDEwMDAwLCBsaW1pdCB0byA1MDAwG1swbQoKMjAx
My0xMC0wNi0wMzoyMDoxMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMTEJMjMJNDEJNDcJNTgJ
NjQJNzIJNzYJOTIJMTE3CTEyNwkxNDkJMTY2CTE4MQkyMTMJMjI0CTI0MAkyNjEJMjc2CTMw
NwkzMjEJMzMyCTM1MAkzNjAJMzkyCTQwMAk0MDgJNDE5CTQyNQk0MzAJNDM3CTQ0NQk0NTAJ
NDU3CTQ2Ngk0NzIJNDc5CTQ5MAk1MDQJNTI3CTU0NQk1NjUJNTczCTU5Nwk2MTEJNjI0CTYz
NQk2NTEJNjU3CTY3NAk3MDEJNzI2CTc0Mgk3NTEJNzU2Li4JNzYyLi4uCTc3OQk4MDcJODQx
CTg1MAk4NTIJODU5CTg2MQk4NjkJODc1CTg4MAk4ODkJODkyCTg5Ngk5MDgJOTE0CTkyMAk5
MzAJOTM3CTkzOQk5NDIJOTYyCTk2Mwk5NjkJOTc2CTk3OQk5ODQJOTg1CTk4OAk5ODkJOTkx
CTk5NAk5OTgJMTAwMgkxMDA0CTEwMDkJMTAxNQkxMDE4CTEwMjYJMTA0MgkxMDU4CTEwNzYJ
MTA4NAkxMTAwCTExMDEuCTExMDQJMTEyNi4JMTE1MgkxMTc4CTExODgJMTIxMgkxMjQ0Lgkx
MjYxCTEyNzcJMTI5OAkxMzIzLgkxMzMxCTEzNTMJMTM4OAkxNDE0CTE0NDYuCTE0NjQJMTUw
NQkxNTIwCTE1MzQJMTU0OQkxNTY0Li4JMTU4NAkxNjExCTE2NDEJMTY0OQkxNjkzCTE3MTMJ
MTcyMAkxNzMyCTE3NDYJMTc1NgkxNzU5CTE3NjEJMTc3MgkxNzgxCTE3ODgJMTc5MgkxODE2
CTE4NDQJMTg1MgkxODY5CTE4NzkJMTg4MwkxODg3CTE4OTMJMTkwMwkxOTEwCTE5MTgJMTk0
MAkxOTU3LgkxOTY1CTE5ODAJMTk4NAkyMDAzCTIwMDQuCTIwNDYJMjA2NgkyMDc1CTIwNzgJ
MjA4OQkyMDk0CTIwOTkuCTIxMDguCTIxNDcJMjE2NQkyMTc3CTIxODYJMjE4OS4JMjE5MAky
MjAwCTIyMDYJMjIxMgkyMjI0CTIyMzcJMjIzOQkyMjQyLgkyMjUxCTIyNzcJMjI4MQkyMjk5
CTIzMTIJMjMyNQkyMzI2LgkyMzM5CTIzNTkJMjM4NQkyMzk0CTI0MDYJMjQxOS4uCTI0MjMJ
MjQ0MAkyNDY5CTI0NzcJMjQ4MwkyNDkxCTI0OTQJMjQ5NS4JMjUxNQkyNTE5CTI1MjEJMjUy
OAkyNTM5CTI1NDYuLgkyNTY2CTI1NjgJMjU3OQkyNTgyCTI1OTUuLi4JMjYwNQkyNjQ4CTI2
ODEJMjY5OQkyNzA5CTI3MTkJMjcyMAkyNzIzCTI3MjkJMjc1NQkyNzU4CTI3NzIJMjc3OAky
Nzg0CTI3ODUJMjc5MC4JMjc5NwkyODAxCTI4MDcJMjgxMgkyODE2CTI4MTgJMjgyMS4JMjgz
NwkyODUwCTI4NTkuCTI4NjMJMjg2NgkyODY3CTI4NzguCTI5MDgJMjkyOQkyOTM4CTI5NTQJ
Mjk2MAkyOTYyLi4JMjk3NwkzMDAzCTMwMDQJMzAwNwkzMDA4CTMwMTAJMzAxMS4uCTMwMjUJ
MzAzMAkzMDMxCTMwMzgJMzA0MQkzMDQyLi4JMzA0NAkzMDYyCTMwNzYJMzA4MwkzMDk0CTMw
OTgJMzEwMi4uCTMxMzcJMzE0MAkzMTU0CTMxNjcJMzE2OQkzMTczCTMxNzQJMzE3NwkzMTgy
CTMxODkJMzIwMQkzMjA2CTMyMTIJMzIxNwkzMjIwCTMyMjYuLgkzMjcxCTMyOTIJMzMwMgkz
MzEyCTMzMjkJMzMzMy4JMzM0NQkzMzY4CTMzOTIJMzQwNAkzNDIwCTM0MzMuCTM0NDEJMzQ1
MwkzNDYwCTM0ODIJMzUwNAkzNTIzCTM1MzgJMzU1MQkzNTUzLi4JMzU2OQkzNTkxCTM2MDkJ
MzYxOAkzNjM2CTM2NDEuCTM2NTMuCTM2ODkJMzcwMQkzNzE1CTM3MjkJMzczNS4uCTM3NDUJ
Mzc2MQkzNzg1CTM4MDAJMzgxMAkzODI1CTM4MzEuCTM4MzkuCTM4NzYJMzg5MQkzODk5CTM5
MjIJMzkzMgkzOTM0CTM5NDguCTM5NzEJMzk4MAkzOTkxCTQwMDEJNDAxMAk0MDEzLi4JNDAz
OAk0MDcwCTQwODcJNDA5Mwk0MTEwCTQxMTcuLgk0MTI0CTQxNTYJNDE3Mwk0MTkyCTQyMDgJ
NDIyMwk0MjMxLgk0MjMzCTQyNDEJNDI4MQk0Mjg5CTQzMDMJNDMxMwk0MzE2CTQzMjIuCTQz
MzQJNDM1MQk0MzU2CTQzNjIJNDM2OAk0MzczLgk0Mzc4Lgk0Mzk2CTQ0NDAJNDQ0Mgk0NDcw
CTQ0ODMJNDQ4NQk0NDg4CTQ1MDIuCTQ1MjkJNDU1Ngk0NTcxCTQ1ODQJNDYwMgk0NjA2Lgk0
NjE5Lgk0NjU0CTQ2NTkJNDY3Ny4JNDcyNwk0NzQxCTQ3NDUJNDc1OAk0NzYxCTQ3ODQJNDgw
MQk0ODI0CTQ4MzkJNDg1OAk0ODYxCTQ4NzQuCTQ4NzgJNDkyMAk0OTQ2CTQ5NjQJNDk3OAk0
OTg5CTQ5OTAJNDk5Mi4JNDk5Mwk0OTk1Lgk0OTk2Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDUwMDQbWzBtChtbMTszNW1hZGRfdG9f
cnVuX3F1ZXVlOiByZXF1ZXN0ZWQgNTAwNCwgbGltaXQgdG8gNTAwMBtbMG0KLi4uLi4uLi4u
Li4uCTUwMzAJNTA3Mgk1MTE0CTUxNTkJNTIwNwk1MjYwCTUzMDUJNTM1MAk1Mzk1CTU0NDIJ
NTQ5Mgk1NTQwCTU1ODUJNTYzMwk1NjgxCTU3MjkJNTc3Ngk1ODI0CTU4NDIuLi4uLi4uLi4u
CTU4ODEJNTkyMAk1OTYwCTYwMDUJNjA0OQk2MDkzCTYxMzcJNjE4MAk2MjI2CTYyNzEJNjMx
Mgk2MzU0CTYzOTcJNjQzOQk2NDg1CTY1MjkJNjU3Mwk2NjE2CTY2NjAJNjY5OQk2NzQwCTY3
ODIJNjgyNQk2ODY5CTY5MDgJNjk0Ngk2OTg3CTcwMzAJNzA3Ngk3MTE5CTcxNTgJNzE4OAk3
MjMwCTcyNjIJNzI5Mwk3MzM0CTczNzgJNzQyNAk3NDU0CTc0OTMJNzUzNwk3NTgyCTc2MjUJ
NzY2OAk3NzA5CTc3NDIJNzc3OQk3ODI1CTc4NjUJNzkwMQk3OTQzCTc5ODgJODAyNwk4MDY3
CTgxMjUJODIxMwk4MjM4CTgyNjgJODMyMAk4MzUzCTgzNzkJODQyMQk4NDU5CTg1MDEJODU0
Mwk4NTg0CTg2MjQJODY2Nwk4NzEwCTg3NTYJODc5NQk4ODM1CTg4NzUJODkyMgk4OTc4CTkw
NTAJOTEwOQk5MTM4CTkxNzkJOTIyMgk5MjUyCTkyOTMJOTMzNAk5Mzc1CTk0MTcJOTQ2Mgk5
NTEwCTk1NTIJOTU5Ngk5NjU2CTk3MjUJOTc5MAk5ODIxCTk4NjIJOTkwNwk5OTE4Li4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLhtbMTszNW1hZGRfdG9fcnVuX3F1ZXVlIDgyG1sw
bQouLi4uLi4uLi4uLi4JOTkyMgk5OTU5CTEwMDAwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L3RpcDpwZXJm
OnVyZ2VudDoyM2I3ZWFmODIyMDcyMTg5Mjk3NTYxMGRkMGFlNWM4NDZhMzRkY2I0OmJpc2Vj
dC1kcm0KCjIwMTMtMTAtMDYtMTM6MzU6NDcgMjNiN2VhZjgyMjA3MjE4OTI5NzU2MTBkZDBh
ZTVjODQ2YTM0ZGNiNCByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjgv
MjNiN2VhZjgyMjA3MjE4OTI5NzU2MTBkZDBhZTVjODQ2YTM0ZGNiNC92bWxpbnV6LTMuMTEu
MC1yYzQtMDAwMjMtZzIzYjdlYWYKCjIwMTMtMTAtMDYtMTM6MzY6MzMgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4uLgk1MDI3CTUwNDkJNTA5OAk1MTUyCTUyMDMJ
NTI1Ngk1MzA1CTUzNTMJNTQwNAk1NDU2CTU1MTgJNTU2NAk1NjI0CTU2OTMJNTc0NQk1Nzky
CTU4NjgJNjAxNgk2MjAyCTYyNjEJNjI5MQk2MzQwLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTYz
NjQJNjQxMAk2NDU0CTY0OTkJNjU0NQk2NTkzCTY2NDIJNjY5Mgk2NzQ0CTY3OTYJNjg1MQk2
OTA1CTY5NTEJNzAwNwk3MDU4CTcxMTAJNzE2Mgk3MjEyCTcyNzcJNzQwOQk3NTUwCTc2NjcJ
Nzc1NQk3ODUxCTc5MDUJNzkyMAk3OTY1CTgwMTEJODAyNAk4MDUzCTgxOTIJODMxOAk4NDI4
CTg0ODgJODU1NQk4NjEzCTg2MjIJODY1Nwk4NjkzCTg3MTYJODc1Ngk4ODE1CTg5MzkJOTA4
Mgk5MTg5CTkyNTAJOTMxMQk5MzQ2CTkzNzcJOTM3OC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uCTk0MTcJOTQ2MQk5NTA3CTk1NTQJOTYwOQk5NjU3CTk3MTkJOTc3OQk5
ODg1CTEwMDAwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L3RpcDpwZXJmOnVyZ2VudDoxNDk1MWYyMmYxY2M4
Mzc1ZWFkMzQ1ZDJjYTA4NDU1ZTkxZjIxNTJiOmJpc2VjdC1kcm0KIFRFU1QgRkFJTFVSRQpb
ICAgNzIuMDU5MjM0XSBTY2FubmluZyBkZXZpY2UgZm9yIGJhZCBibG9ja3MKWyAgIDcyLjcz
Mjg1OF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICA3Mi43MzUy
MTddIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQga2VybmVsL3dvcmtxdWV1ZS5jOjU5MyBz
ZXRfd29ya19kYXRhKzB4MzMvMHg1MCgpClsgICA3Mi43MzYzNDRdIENQVTogMCBQSUQ6IDEg
Q29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTIuMC1yYzItMDAxNTMtZzE0OTUxZjIg
IzEyOQpbICAgNzIuNzM2MzQ0XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBmMDAzZDgw
IGZmZmZmZmZmODE4NGQ1ZmUgMDAwMDAwMDAwMDAwMDAwMApbICAgNzIuNzM2MzQ0XSAgZmZm
Zjg4MDAwZjAwM2RiOCBmZmZmZmZmZjgxMDhmYTY2IGZmZmZmZmZmODEwOWU0MTEgZmZmZjg4
MDAwY2M3ZDg2MApbICAgNzIuNzM2MzQ0XSAgZmZmZjg4MDAwZjAxMzQwMCAwMDAwMDAwMDAw
MDAwMDA1IGZmZmY4ODAwMGYwMTE2NDAgZmZmZjg4MDAwZjAwM2RjOApbICAgNzIuNzM2MzQ0
XSBDYWxsIFRyYWNlOgpbICAgNzIuNzM2MzQ0XSAgPElSUT4gIFs8ZmZmZmZmZmY4MTg0ZDVm
ZT5dIGR1bXBfc3RhY2srMHg0ZS8weDgyClsgICA3Mi43MzYzNDRdICBbPGZmZmZmZmZmODEw
OGZhNjY+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDcwLzB4ODkKWyAgIDcyLjczNjM0NF0g
IFs8ZmZmZmZmZmY4MTA5ZTQxMT5dID8gc2V0X3dvcmtfZGF0YSsweDMzLzB4NTAKWyAgIDcy
LjczNjM0NF0gIFs8ZmZmZmZmZmY4MTA4ZmI0MT5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDE1
LzB4MTcKWyAgIDcyLjczNjM0NF0gIFs8ZmZmZmZmZmY4MTA5ZTQxMT5dIHNldF93b3JrX2Rh
dGErMHgzMy8weDUwClsgICA3Mi43MzYzNDRdICBbPGZmZmZmZmZmODEwOWYxMjc+XSBpbnNl
cnRfd29yaysweDI3LzB4NjUKWyAgIDcyLjczNjM0NF0gIFs8ZmZmZmZmZmY4MTA5ZjMzND5d
IF9fcXVldWVfd29yaysweDFjZi8weDFlZQpbICAgNzIuNzM2MzQ0XSAgWzxmZmZmZmZmZjgx
MDlmMzUzPl0gPyBfX3F1ZXVlX3dvcmsrMHgxZWUvMHgxZWUKWyAgIDcyLjczNjM0NF0gIFs8
ZmZmZmZmZmY4MTA5ZjM2Yz5dIGRlbGF5ZWRfd29ya190aW1lcl9mbisweDE5LzB4MWIKWyAg
IDcyLjczNjM0NF0gIFs8ZmZmZmZmZmY4MTA5NjViOD5dIGNhbGxfdGltZXJfZm4rMHg2Yy8w
eGRmClsgICA3Mi43MzYzNDRdICBbPGZmZmZmZmZmODEwOTY1NGM+XSA/IHByb2Nlc3NfdGlt
ZW91dCsweGIvMHhiClsgICA3Mi43MzYzNDRdICBbPGZmZmZmZmZmODEwOWYzNTM+XSA/IF9f
cXVldWVfd29yaysweDFlZS8weDFlZQpbICAgNzIuNzM2MzQ0XSAgWzxmZmZmZmZmZjgxMDk2
Y2M3Pl0gcnVuX3RpbWVyX3NvZnRpcnErMHgxNzAvMHgxYjgKWyAgIDcyLjczNjM0NF0gIFs8
ZmZmZmZmZmY4MTA5MzBjYT5dIF9fZG9fc29mdGlycSsweGM4LzB4MThkClsgICA3Mi43MzYz
NDRdICBbPGZmZmZmZmZmODEwOTMyYTQ+XSBpcnFfZXhpdCsweDU2LzB4OTcKWyAgIDcyLjcz
NjM0NF0gIFs8ZmZmZmZmZmY4MTAyYjgzMT5dIGRvX0lSUSsweDg4LzB4OWYKWyAgIDcyLjcz
NjM0NF0gIFs8ZmZmZmZmZmY4MTg1ODkzMj5dIGNvbW1vbl9pbnRlcnJ1cHQrMHg3Mi8weDcy
ClsgICA3Mi43MzYzNDRdICA8RU9JPiAgWzxmZmZmZmZmZjgxNGRjZDAzPl0gPyBuYW5kX3Jl
bGVhc2VfZGV2aWNlLmlzcmEuMTYrMHgxNC8weDU4ClsgICA3Mi43MzYzNDRdICBbPGZmZmZm
ZmZmODE4NTdjYmE+XSA/IF9yYXdfc3Bpbl9sb2NrKzB4M2MvMHg0MQpbICAgNzIuNzM2MzQ0
XSAgWzxmZmZmZmZmZjgxODU3Y2JhPl0gPyBfcmF3X3NwaW5fbG9jaysweDNjLzB4NDEKWyAg
IDcyLjczNjM0NF0gIFs8ZmZmZmZmZmY4MTRkY2QwMz5dID8gbmFuZF9yZWxlYXNlX2Rldmlj
ZS5pc3JhLjE2KzB4MTQvMHg1OApbICAgNzIuNzM2MzQ0XSAgWzxmZmZmZmZmZjgxNGRjZDAz
Pl0gbmFuZF9yZWxlYXNlX2RldmljZS5pc3JhLjE2KzB4MTQvMHg1OApbICAgNzIuNzM2MzQ0
XSAgWzxmZmZmZmZmZjgxNGRkYWE5Pl0gbmFuZF9yZWFkX29vYisweDI1Ny8weDI3MApbICAg
NzIuNzM2MzQ0XSAgWzxmZmZmZmZmZjgxMGFmMmQ5Pl0gPyBfX3dha2VfdXArMHgxZC8weDQ2
ClsgICA3Mi43MzYzNDRdICBbPGZmZmZmZmZmODE0YzY5Njg+XSBtdGRfcmVhZF9vb2IrMHgy
Ni8weDRjClsgICA3Mi43MzYzNDRdICBbPGZmZmZmZmZmODE0ZTA0ZDQ+XSBjcmVhdGVfYmJ0
KzB4MjBmLzB4MjlhClsgICA3Mi43MzYzNDRdICBbPGZmZmZmZmZmODE0ZTA1ZGU+XSBuYW5k
X3NjYW5fYmJ0KzB4N2YvMHg0ZGQKWyAgIDcyLjczNjM0NF0gIFs8ZmZmZmZmZmY4MTExOWZk
Yj5dID8gX19rbWFsbG9jKzB4OTAvMHhiYgpbICAgNzIuNzM2MzQ0XSAgWzxmZmZmZmZmZjgx
NGUwYjFiPl0gbmFuZF9kZWZhdWx0X2JidCsweGRmLzB4ZTQKWyAgIDcyLjczNjM0NF0gIFs8
ZmZmZmZmZmY4MWU0Yzg1Yz5dIG5zX2luaXRfbW9kdWxlKzB4NTY5LzB4Y2YzClsgICA3Mi43
MzYzNDRdICBbPGZmZmZmZmZmODEyMjYxYTE+XSA/IGZyZWVfcnMrMHg3NS8weDc4ClsgICA3
Mi43MzYzNDRdICBbPGZmZmZmZmZmODFlNGMyZjM+XSA/IG5mdGxfc2Nhbl9iYnQrMHgzMTIv
MHgzMTIKWyAgIDcyLjczNjM0NF0gIFs8ZmZmZmZmZmY4MWUyMmRkND5dIGRvX29uZV9pbml0
Y2FsbCsweDhlLzB4MTMyClsgICA3Mi43MzYzNDRdICBbPGZmZmZmZmZmODEwYTQ2MDA+XSA/
IHBhcmFtX3NldF9jaGFycCsweDViLzB4ZGEKWyAgIDcyLjczNjM0NF0gIFs8ZmZmZmZmZmY4
MTBhNDg1OD5dID8gcGFyc2VfYXJncysweDE4NC8weDI0MgpbICAgNzIuNzM2MzQ0XSAgWzxm
ZmZmZmZmZjgxZTIyZmNjPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxNTQvMHgxZDAKWyAg
IDcyLjczNjM0NF0gIFs8ZmZmZmZmZmY4MWUyMjZkYT5dID8gZG9fZWFybHlfcGFyYW0rMHg4
OC8weDg4ClsgICA3Mi43MzYzNDRdICBbPGZmZmZmZmZmODE4NDczMDk+XSA/IHJlc3RfaW5p
dCsweGJkLzB4YmQKWyAgIDcyLjczNjM0NF0gIFs8ZmZmZmZmZmY4MTg0NzMxMj5dIGtlcm5l
bF9pbml0KzB4OS8weGNjClsgICA3Mi43MzYzNDRdICBbPGZmZmZmZmZmODE4NTkxNGM+XSBy
ZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgNzIuNzM2MzQ0XSAgWzxmZmZmZmZmZjgxODQ3
MzA5Pl0gPyByZXN0X2luaXQrMHhiZC8weGJkClsgICA3Mi43MzYzNDRdIC0tLVsgZW5kIHRy
YWNlIDVmNzA1NTZjNGQxYWE5NjAgXS0tLQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgx
LTA5MjgvMTQ5NTFmMjJmMWNjODM3NWVhZDM0NWQyY2EwODQ1NWU5MWYyMTUyYi9kbWVzZy15
b2N0by1iZW5zLTQ6MjAxMzEwMDIyMjM2MDE6My4xMi4wLXJjMi0wMDE1My1nMTQ5NTFmMjox
MjkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4LzE0OTUxZjIyZjFjYzgzNzVl
YWQzNDVkMmNhMDg0NTVlOTFmMjE1MmIvZG1lc2cteW9jdG8tbGtwLXR0MDItNjoyMDEzMDky
OTEzMjkzMjozLjEyLjAtcmMyLTAwMTUzLWcxNDk1MWYyOjEyOQoKSEVBRCBpcyBub3cgYXQg
MTQ5NTFmMiBSZXZlcnQgInBlcmYgc3ltYm9sczogRGVtYW5nbGUgY2xvbmVkIGZ1bmN0aW9u
cyIKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjgv
dGlwOnBlcmY6dXJnZW50OmU2MjA2M2Q2OTkxMTg4NmE1YTkyYzcxOWQyNjJhMmE4N2UxZTVi
NjA6YmlzZWN0LWRybQoKMjAxMy0xMC0wNi0xNDo1NTozMSBlNjIwNjNkNjk5MTE4ODZhNWE5
MmM3MTlkMjYyYTJhODdlMWU1YjYwIGNvbXBpbGluZwobWzE7MzVtYWRkX3RvX3J1bl9xdWV1
ZTogcmVxdWVzdGVkIDEwMDAwLCBsaW1pdCB0byA1MDAwG1swbQoKMjAxMy0xMC0wNi0xNTow
NTo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMzLTAwMzUxLWdlNjIwNjNkLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMzcJMTEwCTE4NgkyNjMJMzM4CTQxNAk0ODkJ
NTYyCTYzNgk3MDkJNzgzCTg1NQk5MzQJMTEwNAkxMzI2CTE0NDQgVEVTVCBGQUlMVVJFClsg
ICA1Ni44NTkxNDBdIFNjYW5uaW5nIGRldmljZSBmb3IgYmFkIGJsb2NrcwpbICAgNTcuMjY5
OTU4XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgIDU3LjI3MzM1
OF0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCAvYy93ZmcvbGludXgtZHJtL2tlcm5lbC93
b3JrcXVldWUuYzo1OTMgc2V0X3dvcmtfZGF0YSsweDMzLzB4NTAoKQpbICAgNTcuMjczNDQ1
XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjEyLjAtcmMz
LTAwMzUxLWdlNjIwNjNkICMxNTgKWyAgIDU3LjI3MzQ0NV0gIDAwMDAwMDAwMDAwMDAwMDAg
ZmZmZjg4MDAwZjAwM2Q1MCBmZmZmZmZmZjgxODRmODJlIDAwMDAwMDAwMDAwMDAwMDAKWyAg
IDU3LjI3MzQ0NV0gIGZmZmY4ODAwMGYwMDNkODggZmZmZmZmZmY4MTA4ZmI2NiBmZmZmZmZm
ZjgxMDllNTI0IGZmZmY4ODAwMGNjN2Y4NjAKWyAgIDU3LjI3MzQ0NV0gIGZmZmY4ODAwMGYw
MTM0MDAgMDAwMDAwMDAwMDAwMDAwNSBmZmZmODgwMDBmMDExNjQwIGZmZmY4ODAwMGYwMDNk
OTgKWyAgIDU3LjI3MzQ0NV0gQ2FsbCBUcmFjZToKWyAgIDU3LjI3MzQ0NV0gIDxJUlE+ICBb
PGZmZmZmZmZmODE4NGY4MmU+XSBkdW1wX3N0YWNrKzB4NGUvMHg4MgpbICAgNTcuMjczNDQ1
XSAgWzxmZmZmZmZmZjgxMDhmYjY2Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3MC8weDg5
ClsgICA1Ny4yNzM0NDVdICBbPGZmZmZmZmZmODEwOWU1MjQ+XSA/IHNldF93b3JrX2RhdGEr
MHgzMy8weDUwClsgICA1Ny4yNzM0NDVdICBbPGZmZmZmZmZmODEwOGZjNDE+XSB3YXJuX3Ns
b3dwYXRoX251bGwrMHgxNS8weDE3ClsgICA1Ny4yNzM0NDVdICBbPGZmZmZmZmZmODEwOWU1
MjQ+XSBzZXRfd29ya19kYXRhKzB4MzMvMHg1MApbICAgNTcuMjczNDQ1XSAgWzxmZmZmZmZm
ZjgxMDlmMjNhPl0gaW5zZXJ0X3dvcmsrMHgyNy8weDY1ClsgICA1Ny4yNzM0NDVdICBbPGZm
ZmZmZmZmODEwOWY0NDc+XSBfX3F1ZXVlX3dvcmsrMHgxY2YvMHgxZWUKWyAgIDU3LjI3MzQ0
NV0gIFs8ZmZmZmZmZmY4MTA5ZjQ2Nj5dID8gX19xdWV1ZV93b3JrKzB4MWVlLzB4MWVlClsg
ICA1Ny4yNzM0NDVdICBbPGZmZmZmZmZmODEwOWY0N2Y+XSBkZWxheWVkX3dvcmtfdGltZXJf
Zm4rMHgxOS8weDFiClsgICA1Ny4yNzM0NDVdICBbPGZmZmZmZmZmODEwOTY2Yjg+XSBjYWxs
X3RpbWVyX2ZuKzB4NmMvMHhkZgpbICAgNTcuMjczNDQ1XSAgWzxmZmZmZmZmZjgxMDk2NjRj
Pl0gPyBwcm9jZXNzX3RpbWVvdXQrMHhiLzB4YgpbICAgNTcuMjczNDQ1XSAgWzxmZmZmZmZm
ZjgxMDlmNDY2Pl0gPyBfX3F1ZXVlX3dvcmsrMHgxZWUvMHgxZWUKWyAgIDU3LjI3MzQ0NV0g
IFs8ZmZmZmZmZmY4MTA5NmRjNz5dIHJ1bl90aW1lcl9zb2Z0aXJxKzB4MTcwLzB4MWI4Clsg
ICA1Ny4yNzM0NDVdICBbPGZmZmZmZmZmODEwOTMxY2E+XSBfX2RvX3NvZnRpcnErMHhjOC8w
eDE4ZApbICAgNTcuMjczNDQ1XSAgWzxmZmZmZmZmZjgxODVjNzdjPl0gY2FsbF9zb2Z0aXJx
KzB4MWMvMHgyNgpbICAgNTcuMjczNDQ1XSAgWzxmZmZmZmZmZjgxMDJiYzVjPl0gZG9fc29m
dGlycSsweDQ1LzB4OWYKWyAgIDU3LjI3MzQ0NV0gIFs8ZmZmZmZmZmY4MTA5MzNhND5dIGly
cV9leGl0KzB4NTYvMHg5NwpbICAgNTcuMjczNDQ1XSAgWzxmZmZmZmZmZjgxMDJiOGYyPl0g
ZG9fSVJRKzB4ODgvMHg5ZgpbICAgNTcuMjczNDQ1XSAgWzxmZmZmZmZmZjgxODVhYjcyPl0g
Y29tbW9uX2ludGVycnVwdCsweDcyLzB4NzIKWyAgIDU3LjI3MzQ0NV0gIDxFT0k+ICBbPGZm
ZmZmZmZmODEwYWYwNzA+XSA/IGFkZF9wcmVlbXB0X2NvdW50KzB4ZS8weDk4ClsgICA1Ny4y
NzM0NDVdICBbPGZmZmZmZmZmODEyMTgyYTQ+XSBkZWxheV90c2MrMHgxYS8weGM4ClsgICA1
Ny4yNzM0NDVdICBbPGZmZmZmZmZmODEyMTgzOTI+XSBfX2RlbGF5KzB4YS8weGMKWyAgIDU3
LjI3MzQ0NV0gIFs8ZmZmZmZmZmY4MTIxODNiOD5dIF9fY29uc3RfdWRlbGF5KzB4MjQvMHgy
NgpbICAgNTcuMjczNDQ1XSAgWzxmZmZmZmZmZjgxNGRlMzA4Pl0gbmFuZF9jb21tYW5kKzB4
MTdiLzB4MThlClsgICA1Ny4yNzM0NDVdICBbPGZmZmZmZmZmODE0ZGM3OWE+XSBuYW5kX3Jl
YWRfb29iX3N0ZCsweDE5LzB4MzIKWyAgIDU3LjI3MzQ0NV0gIFs8ZmZmZmZmZmY4MTRkZTk5
MD5dIG5hbmRfcmVhZF9vb2IrMHgxNTYvMHgyNzAKWyAgIDU3LjI3MzQ0NV0gIFs8ZmZmZmZm
ZmY4MTg1YWMzNz5dID8gcmV0aW50X3Jlc3RvcmVfYXJncysweDEzLzB4MTMKWyAgIDU3LjI3
MzQ0NV0gIFs8ZmZmZmZmZmY4MTRjNzhmYj5dIG10ZF9yZWFkX29vYisweDI2LzB4NGMKWyAg
IDU3LjI3MzQ0NV0gIFs8ZmZmZmZmZmY4MTRlMTRjNj5dIGNyZWF0ZV9iYnQrMHgyMGYvMHgy
OWEKWyAgIDU3LjI3MzQ0NV0gIFs8ZmZmZmZmZmY4MTRlMTVkMD5dIG5hbmRfc2Nhbl9iYnQr
MHg3Zi8weDRkZApbICAgNTcuMjczNDQ1XSAgWzxmZmZmZmZmZjgxMTFhMTllPl0gPyBfX2tt
YWxsb2MrMHg5MC8weGJiClsgICA1Ny4yNzM0NDVdICBbPGZmZmZmZmZmODE0ZTFiMGQ+XSBu
YW5kX2RlZmF1bHRfYmJ0KzB4ZGYvMHhlNApbICAgNTcuMjczNDQ1XSAgWzxmZmZmZmZmZjgx
ZTRjODllPl0gbnNfaW5pdF9tb2R1bGUrMHg1NjkvMHhjZjMKWyAgIDU3LjI3MzQ0NV0gIFs8
ZmZmZmZmZmY4MTIyNjZiMT5dID8gZnJlZV9ycysweDc1LzB4NzgKWyAgIDU3LjI3MzQ0NV0g
IFs8ZmZmZmZmZmY4MWU0YzMzNT5dID8gbmZ0bF9zY2FuX2JidCsweDMxMi8weDMxMgpbICAg
NTcuMjczNDQ1XSAgWzxmZmZmZmZmZjgxZTIyZGQ0Pl0gZG9fb25lX2luaXRjYWxsKzB4OGUv
MHgxMzIKWyAgIDU3LjI3MzQ0NV0gIFs8ZmZmZmZmZmY4MTBhNDgwMD5dID8gcGFyYW1lcW4r
MHgzMy8weDM2ClsgICA1Ny4yNzM0NDVdICBbPGZmZmZmZmZmODEwYTQ5YTY+XSA/IHBhcnNl
X2FyZ3MrMHgxODQvMHgyNDIKWyAgIDU3LjI3MzQ0NV0gIFs8ZmZmZmZmZmY4MWUyMmZjYz5d
IGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTU0LzB4MWQwClsgICA1Ny4yNzM0NDVdICBbPGZm
ZmZmZmZmODFlMjI2ZGE+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgNTcuMjcz
NDQ1XSAgWzxmZmZmZmZmZjgxODQ5NDk5Pl0gPyByZXN0X2luaXQrMHhiZC8weGJkClsgICA1
Ny4yNzM0NDVdICBbPGZmZmZmZmZmODE4NDk0YTI+XSBrZXJuZWxfaW5pdCsweDkvMHhjYwpb
ICAgNTcuMjczNDQ1XSAgWzxmZmZmZmZmZjgxODViMzhjPl0gcmV0X2Zyb21fZm9yaysweDdj
LzB4YjAKWyAgIDU3LjI3MzQ0NV0gIFs8ZmZmZmZmZmY4MTg0OTQ5OT5dID8gcmVzdF9pbml0
KzB4YmQvMHhiZApbICAgNTcuMjczNDQ1XSAtLS1bIGVuZCB0cmFjZSA0YzAzYTg4NzUyYWU1
ZjRlIF0tLS0KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L2U2MjA2M2Q2OTkx
MTg4NmE1YTkyYzcxOWQyNjJhMmE4N2UxZTViNjAvZG1lc2cteW9jdG8tYmVucy0yOjIwMTMx
MDA2MTUwOTExOng4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4xMi4wLXJjMy0wMDM1MS1n
ZTYyMDYzZDoxNTgKCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KRmV0Y2hpbmcg
bmV4dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25m
aWcteDEtMDkyOC90aXA6cGVyZjp1cmdlbnQ6YTBjZjFhYmMyNWFjMTk3ZGQ5N2I4NTdjMGY2
MzQxMDY2YThjYjFjZjpiaXNlY3QtZHJtCiBURVNUIEZBSUxVUkUKWyAgIDMzLjUxMjE0NV0g
b3B0aW9uczogMHg0MgpbICAgMzMuNTU0NjAzXSBTY2FubmluZyBkZXZpY2UgZm9yIGJhZCBi
bG9ja3MKWyAgIDM0LjQwMTI4Nl0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxM
IHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwMDAwMDAwMDAwOApbICAgMzQuNDAyMTA3
XSBJUDogWzxmZmZmZmZmZjgxMDllZjk4Pl0gcnVuX3RpbWVyX3NvZnRpcnErMHgxMmMvMHgx
YjgKWyAgIDM0LjQwMzgwOF0gUEdEIDAgClsgICAzNC40MDQyNzZdIE9vcHM6IDAwMDIgWyMx
XSBQUkVFTVBUIFNNUCBERUJVR19QQUdFQUxMT0MKWyAgIDM0LjQwNDI3Nl0gQ1BVOiAwIFBJ
RDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMi4wLXJjMi1uZXh0LTIwMTMw
OTI3LTAzMTAwLWdhMGNmMWFiICMxNTIKWyAgIDM0LjQwNDI3Nl0gdGFzazogZmZmZjg4MDAw
MDA3YzA0MCB0aTogZmZmZjg4MDAwMDA3ZTAwMCB0YXNrLnRpOiBmZmZmODgwMDAwMDdlMDAw
ClsgICAzNC40MDQyNzZdIFJJUDogMDAxMDpbPGZmZmZmZmZmODEwOWVmOTg+XSAgWzxmZmZm
ZmZmZjgxMDllZjk4Pl0gcnVuX3RpbWVyX3NvZnRpcnErMHgxMmMvMHgxYjgKWyAgIDM0LjQw
NDI3Nl0gUlNQOiAwMDE4OmZmZmY4ODAwMGYwMDNlZTAgIEVGTEFHUzogMDAwMDAwMDIKWyAg
IDM0LjQwNDI3Nl0gUkFYOiBmZmZmODgwMDBmMDAzZWUwIFJCWDogZmZmZmZmZmY4MWYzYmE4
MCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDIKWyAgIDM0LjQwNDI3Nl0gUkRYOiAwMDAwMDAwMDAw
MDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAyOCBSREk6IGZmZmZmZmZmODEwOWVlYTgKWyAg
IDM0LjQwNDI3Nl0gUkJQOiBmZmZmODgwMDBmMDAzZjE4IFIwODogMDAwMDAwMDAwMDAwMDAw
MiBSMDk6IDAwMDAwMDAwMDAwMDAwMDEKWyAgIDM0LjQwNDI3Nl0gUjEwOiBmZmZmZmZmZjgx
MDllZWE4IFIxMTogZmZmZmZmZmY4MTBjNWM3NiBSMTI6IGZmZmY4ODAwMGNjN2U4YTAKWyAg
IDM0LjQwNDI3Nl0gUjEzOiBmZmZmODgwMDBmMDAzZWUwIFIxNDogZmZmZmZmZmY4MTBhNzY4
YyBSMTU6IGZmZmY4ODAwMGNjN2U4NjAKWyAgIDM0LjQwNDI3Nl0gRlM6ICAwMDAwMDAwMDAw
MDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMGYwMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAw
MDAwMDAwMApbICAgMzQuNDA0Mjc2XSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1Iw
OiAwMDAwMDAwMDgwMDUwMDNiClsgICAzNC40MDQyNzZdIENSMjogMDAwMDAwMDAwMDAwMDAw
OCBDUjM6IDAwMDAwMDAwMDFjNjUwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmIwClsgICAzNC40
MDQyNzZdIERSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAgRFIy
OiAwMDAwMDAwMDAwMDAwMDAwClsgICAzNC40MDQyNzZdIERSMzogMDAwMDAwMDAwMDAwMDAw
MCBEUjY6IDAwMDAwMDAwMDAwMDAwMDAgRFI3OiAwMDAwMDAwMDAwMDAwMDAwClsgICAzNC40
MDQyNzZdIFN0YWNrOgpbICAgMzQuNDA0Mjc2XSAgZmZmZjg4MDAwY2M3ZThhMCBmZmZmODgw
MDBjYzdlMGEwIDAwMDAwMDAwMDAwMDAwMDEgZmZmZmZmZmY4MWM2MTA4OApbICAgMzQuNDA0
Mjc2XSAgMDAwMDAwMDAwMDAwMDAwYSAwMDAwMDAwMDAwMDAwMTAxIDAwMDAwMDAwMDAwMDAw
MDEgZmZmZjg4MDAwZjAwM2Y2OApbICAgMzQuNDA0Mjc2XSAgZmZmZmZmZmY4MTA5YjQxNSAw
MDAwMDAwMDAwMDAwMDAxIDAwMjA0MTQwMDAwMDAwMDAgMDAwMDAwMDBmZmZlZmNhMQpbICAg
MzQuNDA0Mjc2XSBDYWxsIFRyYWNlOgpbICAgMzQuNDA0Mjc2XSAgPElSUT4gClsgICAzNC40
MDQyNzZdICBbPGZmZmZmZmZmODEwOWI0MTU+XSBfX2RvX3NvZnRpcnErMHhjNi8weDE5Ngpb
ICAgMzQuNDA0Mjc2XSAgWzxmZmZmZmZmZjgxMDliNWVlPl0gaXJxX2V4aXQrMHg1MC8weDg2
ClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODEwMmI3YWE+XSBkb19JUlErMHg4OC8weDlm
ClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE4NjA1YjI+XSBjb21tb25faW50ZXJydXB0
KzB4NzIvMHg3MgpbICAgMzQuNDA0Mjc2XSAgPEVPST4gClsgICAzNC40MDQyNzZdICBbPGZm
ZmZmZmZmODE0ZTRjZTE+XSA/IG5hbmRfZ2V0X2RldmljZS5pc3JhLjE1KzB4NGQvMHhmNQpb
ICAgMzQuNDA0Mjc2XSAgWzxmZmZmZmZmZjgxNGU0Y2UxPl0gPyBuYW5kX2dldF9kZXZpY2Uu
aXNyYS4xNSsweDRkLzB4ZjUKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4MTRlNGQzNj5d
ID8gbmFuZF9nZXRfZGV2aWNlLmlzcmEuMTUrMHhhMi8weGY1ClsgICAzNC40MDQyNzZdICBb
PGZmZmZmZmZmODEwZDU2ZWY+XSA/IGxvY2tfcmVsZWFzZV9ub25fbmVzdGVkKzB4MjFkLzB4
MjFkClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE4NWY5YjY+XSA/IF9yYXdfc3Bpbl9s
b2NrKzB4M2MvMHg0MQpbICAgMzQuNDA0Mjc2XSAgWzxmZmZmZmZmZjgxODVmYWI5Pl0gPyBf
cmF3X3NwaW5fdW5sb2NrKzB4MWEvMHg0MApbICAgMzQuNDA0Mjc2XSAgWzxmZmZmZmZmZjgx
NGU0ZDM2Pl0gbmFuZF9nZXRfZGV2aWNlLmlzcmEuMTUrMHhhMi8weGY1ClsgICAzNC40MDQy
NzZdICBbPGZmZmZmZmZmODEwYjhhZTI+XSA/IHdha2VfdXBfc3RhdGUrMHhkLzB4ZApbICAg
MzQuNDA0Mjc2XSAgWzxmZmZmZmZmZjgxNGU1OTUyPl0gbmFuZF9yZWFkX29vYisweDU1LzB4
MjcwClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE0Y2U5YmI+XSBtdGRfcmVhZF9vb2Ir
MHgyNi8weDRjClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE0ZTg1YjE+XSBjcmVhdGVf
YmJ0KzB4MjBmLzB4MjlhClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE0ZTg2YmI+XSBu
YW5kX3NjYW5fYmJ0KzB4N2YvMHg0ZGQKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4MTEy
MWQ4Nz5dID8gX19rbWFsbG9jKzB4OTAvMHhiYgpbICAgMzQuNDA0Mjc2XSAgWzxmZmZmZmZm
ZjgxNGU4YmY4Pl0gbmFuZF9kZWZhdWx0X2JidCsweGRmLzB4ZTQKWyAgIDM0LjQwNDI3Nl0g
IFs8ZmZmZmZmZmY4MWU1Nzc2OT5dIG5zX2luaXRfbW9kdWxlKzB4NTZjLzB4ZDI4ClsgICAz
NC40MDQyNzZdICBbPGZmZmZmZmZmODEyMmYxYmQ+XSA/IGZyZWVfcnMrMHg3NS8weDc4Clsg
ICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODFlNTcxZmQ+XSA/IG5mdGxfc2Nhbl9iYnQrMHgz
MTIvMHgzMTIKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4MWUyZGRkND5dIGRvX29uZV9p
bml0Y2FsbCsweDhlLzB4MTM0ClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODEwYWNhMDA+
XSA/IHBhcmFtX3NldF9jaGFycCsweDhhLzB4ZGEKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZm
ZmY4MTBhY2MyOT5dID8gcGFyc2VfYXJncysweDE4NC8weDI0MgpbICAgMzQuNDA0Mjc2XSAg
WzxmZmZmZmZmZjgxZTJkZmNlPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxNTQvMHgxZDUK
WyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4MWUyZDZkYT5dID8gZG9fZWFybHlfcGFyYW0r
MHg4OC8weDg4ClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE4NGY1MDk+XSA/IHJlc3Rf
aW5pdCsweGJkLzB4YmQKWyAgIDM0LjQwNDI3Nl0gIFs8ZmZmZmZmZmY4MTg0ZjUxMj5dIGtl
cm5lbF9pbml0KzB4OS8weGNjClsgICAzNC40MDQyNzZdICBbPGZmZmZmZmZmODE4NjBkY2M+
XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgMzQuNDA0Mjc2XSAgWzxmZmZmZmZmZjgx
ODRmNTA5Pl0gPyByZXN0X2luaXQrMHhiZC8weGJkClsgICAzNC40MDQyNzZdIENvZGU6IDhi
IDY1IGM4IDRkIDM5IGVjIDBmIDg0IDJmIGZmIGZmIGZmIDQxIDhiIDRjIDI0IDE4IDRkIDhi
IDc0IDI0IDIwIDRkIDhiIDdjIDI0IDI4IDRjIDg5IDYzIDM4IDQ5IDhiIDQ0IDI0IDA4IDQ5
IDhiIDE0IDI0IDgzIGUxIDAyIDw0OD4gODkgNDIgMDggNDggODkgMTAgNDggYjggMDAgMDIg
MjAgMDAgMDAgMDAgYWQgZGUgNDEgZjYgNDQgMjQgClsgICAzNC40MDQyNzZdIFJJUCAgWzxm
ZmZmZmZmZjgxMDllZjk4Pl0gcnVuX3RpbWVyX3NvZnRpcnErMHgxMmMvMHgxYjgKWyAgIDM0
LjQwNDI3Nl0gIFJTUCA8ZmZmZjg4MDAwZjAwM2VlMD4KWyAgIDM0LjQwNDI3Nl0gQ1IyOiAw
MDAwMDAwMDAwMDAwMDA4ClsgICAzNC40MDQyNzZdIC0tLVsgZW5kIHRyYWNlIGU1MzhlMDk4
ZTBmMmIxNTUgXS0tLQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvYTBjZjFh
YmMyNWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1iZW5zLTI6
MjAxMzEwMDUyMTQ4NDM6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5l
eHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2Rt
ZXNnLXlvY3RvLWxrcC10dDAyLTEyOjIwMTMxMDA1MTIzMzI0Ong4Nl82NC1yYW5kY29uZmln
LXgxLTA5Mjg6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdhMGNmMWFiOjE1Mgov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvYTBjZjFhYmMyNWFjMTk3ZGQ5N2I4
NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1sa3AtdHQwMi0xNDoyMDEzMTAwNTEy
MjIwNDp4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4OjMuMTIuMC1yYzItbmV4dC0yMDEzMDky
Ny0wMzEwMC1nYTBjZjFhYjoxNTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4
L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2YvZG1lc2cteW9jdG8t
bGtwLXR0MDItMTU6MjAxMzEwMDUxMjI1MzU6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODoz
LjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEw
NjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC10dDAyLTE2OjIwMTMxMDA1MTIxODUwOng4Nl82
NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4xMi4wLXJjMi1uZXh0LTIwMTMwOTI3LTAzMTAwLWdh
MGNmMWFiOjE1Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXgxLTA5MjgvYTBjZjFhYmMy
NWFjMTk3ZGQ5N2I4NTdjMGY2MzQxMDY2YThjYjFjZi9kbWVzZy15b2N0by1sa3AtdHQwMi0x
NzoyMDEzMTAwNTEyMjEwMTp4ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4OjMuMTIuMC1yYzIt
bmV4dC0yMDEzMDkyNy0wMzEwMC1nYTBjZjFhYjoxNTIKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy14MS0wOTI4L2EwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2Yv
ZG1lc2cteW9jdG8tbGtwLXR0MDItMTg6MjAxMzEwMDUxMjE4NDk6eDg2XzY0LXJhbmRjb25m
aWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3
Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC10dDAyLTQ6MjAxMzEwMDUx
MjE4MTM6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5
MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDky
OC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3Rv
LWxrcC10dDAyLTQ6MjAxMzEwMDUxMjIyMjU6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODoz
LjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEw
NjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC10dDAyLTc6MjAxMzEwMDUxMjE3MDE6eDg2XzY0
LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2Ew
Y2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1
YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC10dDAyLTc6
MjAxMzEwMDUxMjE3MTk6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5l
eHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2Rt
ZXNnLXlvY3RvLWxrcC10dDAyLTg6MjAxMzEwMDUxMjIwNTQ6eDg2XzY0LXJhbmRjb25maWct
eDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1
N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxrcC10dDAyLTk6MjAxMzEwMDUxMjE3
NDI6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5Mjct
MDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWcteDEtMDkyOC9h
MGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZhOGNiMWNmL2RtZXNnLXlvY3RvLWxr
cC10dDAyLTk6MjAxMzEwMDUxMjE4MDA6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEy
LjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWI6MTUyCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWcteDEtMDkyOC9hMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYzNDEwNjZh
OGNiMWNmL2RtZXNnLXlvY3RvLWxrcC10dDAyLTk6MjAxMzEwMDUxMjI4MzY6eDg2XzY0LXJh
bmRjb25maWcteDEtMDkyODozLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2Yx
YWI6MTUyCgoKPT09PT09PT09IHRpcC9tYXN0ZXIgPT09PT09PT09CkZldGNoaW5nIHRpcAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWcteDEt
MDkyOC90aXA6cGVyZjp1cmdlbnQ6YjMxODAxOTY2NjExNjRlMjA4ZmUyNjc3ZmM5MzhmMDc3
MzJjNjIyZDpiaXNlY3QtZHJtCgoyMDEzLTEwLTA2LTE1OjI5OjE5IGIzMTgwMTk2NjYxMTY0
ZTIwOGZlMjY3N2ZjOTM4ZjA3NzMyYzYyMmQgY29tcGlsaW5nChtbMTszNW1hZGRfdG9fcnVu
X3F1ZXVlOiByZXF1ZXN0ZWQgMTAwMDAsIGxpbWl0IHRvIDUwMDAbWzBtCgoyMDEzLTEwLTA2
LTE1OjM1OjE1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzMtMDE3NDctZ2IzMTgw
MTkuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNjEJMTMzCTIwNQkyNzcJ
MzcxCTU2NQk3MjggVEVTVCBGQUlMVVJFCi9ldGMva2VybmVsLXRlc3RzLzk5LXRyaW5pdHk6
IGxpbmUgMTc6IC91c3Ivc2Jpbi9jaHJvb3Q6IG5vdCBmb3VuZAovZXRjL2tlcm5lbC10ZXN0
cy85OS10cmluaXR5OiBsaW5lIDE4OiAvdXNyL3NiaW4vY2hyb290OiBub3QgZm91bmQKWyAg
ICAzLjE0MDEwMF0gSU5GTzogdHJ5aW5nIHRvIHJlZ2lzdGVyIG5vbi1zdGF0aWMga2V5Lgpb
ICAgIDMuMTQxMDAyXSB0aGUgY29kZSBpcyBmaW5lIGJ1dCBuZWVkcyBsb2NrZGVwIGFubm90
YXRpb24uClsgICAgMy4xNDE5MjBdIHR1cm5pbmcgb2ZmIHRoZSBsb2NraW5nIGNvcnJlY3Ru
ZXNzIHZhbGlkYXRvci4KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4L2IzMTgw
MTk2NjYxMTY0ZTIwOGZlMjY3N2ZjOTM4ZjA3NzMyYzYyMmQvZG1lc2cteW9jdG8tYXRoZW5z
LTM1OjIwMTMxMDA2MTUzNjUyOng4Nl82NC1yYW5kY29uZmlnLXgxLTA5Mjg6My4xMi4wLXJj
My0wMTc0Ny1nYjMxODAxOToxNTkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy14MS0wOTI4
L2IzMTgwMTk2NjYxMTY0ZTIwOGZlMjY3N2ZjOTM4ZjA3NzMyYzYyMmQvZG1lc2cteW9jdG8t
YmF5LTI6MjAxMzEwMDYxNTM2MjA6eDg2XzY0LXJhbmRjb25maWcteDEtMDkyODozLjEyLjAt
cmMzLTAxNzQ3LWdiMzE4MDE5OjE1OQoK

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc2-00153-g14951f2"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0-rc2 Kernel Configuration
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
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
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
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
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
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

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
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
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
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
# CONFIG_RDS_TCP is not set
CONFIG_RDS_DEBUG=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_MAC802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
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
CONFIG_KINGSUN_DONGLE=y
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_NCI_SPI=y
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
# CONFIG_NFC_SIM is not set
CONFIG_NFC_PN544=y
CONFIG_NFC_PN544_I2C=y
CONFIG_NFC_MICROREAD=y
# CONFIG_NFC_MICROREAD_I2C is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
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
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
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
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=y
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_PCMCIA is not set
CONFIG_MTD_GPIO_ADDR=y
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
# CONFIG_M25PXX_USE_FAST_READ is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
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
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_VMWARE_VMCI=y
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
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
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
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_WALKERA0701=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
CONFIG_TOUCHSCREEN_USB_ITM=y
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_PCAP=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
# CONFIG_INPUT_AD714X_SPI is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_PCAP=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_ADXL34X_SPI is not set
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=y
# CONFIG_INPUT_CMA3000_I2C is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

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
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MRST_MAX3110 is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
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
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_ATMEL=y
CONFIG_SPI_BCM2835=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_EP93XX=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_IMX=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_FSL_DSPI=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_OMAP24XX=y
# CONFIG_SPI_TI_QSPI is not set
# CONFIG_SPI_OMAP_100K is not set
# CONFIG_SPI_ORION is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_SH is not set
# CONFIG_SPI_SH_HSPI is not set
CONFIG_SPI_TEGRA114=y
CONFIG_SPI_TEGRA20_SFLASH=y
# CONFIG_SPI_TEGRA20_SLINK is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_TXX9=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
CONFIG_GPIO_MC33880=y
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
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
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_LP8788 is not set
# CONFIG_BACKLIGHT_OT200 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_APPLEIR=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_ELO=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_HUION=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LCD is not set
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
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
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_SSB is not set
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
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
# CONFIG_USB_MDC800 is not set
CONFIG_USB_DWC3=y
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
# CONFIG_USB_DWC3_OMAP is not set
# CONFIG_USB_DWC3_EXYNOS is not set
# CONFIG_USB_DWC3_PCI is not set

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
CONFIG_USB_DWC3_VERBOSE=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
# CONFIG_AM335X_PHY_USB is not set
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_I1480U is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
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
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_OMAP_HS is not set
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SPI=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX8997=y
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TPS6586X=y
CONFIG_RTC_DRV_TPS65910=y
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_SLICOSS=y
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
CONFIG_USBIP_HOST=y
CONFIG_USBIP_DEBUG=y
CONFIG_ECHO=y
# CONFIG_PANEL is not set
CONFIG_TRANZPORT=y
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16203 is not set
CONFIG_ADIS16204=y
CONFIG_ADIS16209=y
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=y
CONFIG_LIS3L02DQ=y
CONFIG_SCA3000=y

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y
# CONFIG_AD7780 is not set
# CONFIG_AD7816 is not set
# CONFIG_AD7192 is not set
CONFIG_AD7280=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=y
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#
CONFIG_AD5930=y
CONFIG_AD9832=y
CONFIG_AD9834=y
# CONFIG_AD9850 is not set
CONFIG_AD9852=y
CONFIG_AD9910=y
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
CONFIG_ADE7754=y
# CONFIG_ADE7758 is not set
CONFIG_ADE7759=y
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
CONFIG_ADE7854_SPI=y

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
CONFIG_AD2S1200=y
CONFIG_AD2S1210=y

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_SIMPLE_DUMMY=y
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_ZSMALLOC=y
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
CONFIG_FT1000=y
CONFIG_FT1000_USB=y
CONFIG_FT1000_PCMCIA=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
CONFIG_WIMAX_GDM72XX=y
# CONFIG_WIMAX_GDM72XX_QOS is not set
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
CONFIG_WIMAX_GDM72XX_USB_PM=y
CONFIG_CED1401=y
# CONFIG_DGRP is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_MAX8997 is not set
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
CONFIG_BMA180=y
CONFIG_HID_SENSOR_ACCEL_3D=y
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7476 is not set
CONFIG_AD7791=y
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
CONFIG_AD7923=y
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
CONFIG_MCP320X=y
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
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
# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5360=y
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5446=y
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_AD5686 is not set
CONFIG_AD5755=y
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
CONFIG_AD7303=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

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
CONFIG_ADIS16260=y
CONFIG_ADXRS450=y
CONFIG_HID_SENSOR_GYRO_3D=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
CONFIG_HID_SENSOR_ALS=y
CONFIG_SENSORS_LM3533=y
CONFIG_SENSORS_TSL2563=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_VME_USER=y
# CONFIG_VME_PIO2 is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
# CONFIG_FMC_WRITE_EEPROM is not set
# CONFIG_FMC_CHARDEV is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_LOGFS=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
# CONFIG_NFSD_V3 is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_RPCSEC_GSS_KRB5 is not set
CONFIG_CEPH_FS=y
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
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
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
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
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
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
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DEBUG_PREEMPT=y

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
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
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
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
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
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=y
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
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
# CONFIG_CRC8 is not set
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
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--xHFwDpU9dbj6ez1V--
