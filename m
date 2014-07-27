Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaG0UCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 16:02:12 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:36885 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaG0UCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 16:02:08 -0400
MIME-Version: 1.0
Date: Sun, 27 Jul 2014 13:02:06 -0700
X-Google-Sender-Auth: Gm06GZxmdcaABYDh02rLcvZTzsk
Message-ID: <CA+55aFwyNWy2BE=4BHujYpJ_CfuYpT2qPg+eJMupgE4R+v1-Lw@mail.gmail.com>
Subject: Linux 3.16-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm happy to say that things have calmed down a bit, and things look
to be on track.

Which didn't actually seem to be the case at all earlier this week -
we had what appeared to be really nasty core bugs, and together with
rc6 being bigger than previous rc's, I was really not feeling all that
good about this release there for a while.

But the worst "nasty bugs" ended up clearing up and not being kernel
bugs at all. One turned out to be a compiler issue (which is always
very scary and hard to debug and very annoying), and it even had a
fairly simple workaround so that we didn't end up having to blacklist
compilers. Another turned out to be lockdep just being too aggressive,
and a false positive.

We obviously *do* have various real fixes in here, but none of them
look all that special or worrisome. And rc7 is finally noticeable
smaller than previous rc's, so we clearly are calming down. So unlike
my early worries, this might well be the last rc, we'll see how next
week looks/feels.

In numbers, rc7 is about one third arch (xtensa, powerpc, x86, s390,
blackfin), one third drivers (gpu, media, networking), and one third
"random" (networking, mm). But it's all fairly small. Shortlog
appended.

                 Linus

---

Alex Deucher (1):
      drm/radeon/TN: only enable bapm on MSI systems

Alexander Graf (3):
      PPC: Add _GLOBAL_TOC for 32bit
      KVM: PPC: Book3S PR: Fix ABIv2 on LE
      KVM: PPC: RTAS: Do byte swaps explicitly

Alexey Asemov (1):
      libata: EH should handle AMNF error condition as a media error

Amir Vadai (1):
      net/mlx4_en: cq->irq_desc wasn't set in legacy EQ's

Andrew Gallagher (1):
      fuse: add FUSE_NO_OPEN_SUPPORT flag to INIT

Andrey Utkin (1):
      drivers/ata/pata_ep93xx.c: use signed int type for result of
platform_get_irq()

Andy Lutomirski (1):
      kprobes/x86: Don't try to resolve kprobe faults from userspace

Aneesh Kumar K.V (2):
      KVM: PPC: BOOK3S: HV: Use base page size when comparing against slb value
      powerpc: subpage_protect: Increase the array size to take care of 64TB

Anton Blanchard (1):
      KVM: PPC: Assembly functions exported to modules need _GLOBAL_TOC()

Antonio Quartulli (1):
      batman-adv: fix TT VLAN inconsistency on VLAN re-add

Antti Palosaari (8):
      [media] si2168: add one missing parenthesis
      [media] si2157: add one missing parenthesis
      [media] si2168: firmware download fix
      [media] af9035: override tuner id when bad value set into eeprom
      [media] tda10071: force modulation to QPSK on DVB-S
      [media] tda10071: add missing DVB-S2/PSK-8 FEC AUTO
      [media] tda10071: fix spec inversion reporting
      [media] tda10071: fix returned symbol rate calculation

Arnd Bergmann (1):
      [media] staging: tighten omap4iss dependencies

Bandan Das (1):
      KVM: x86: Check for nested events if there is an injectable interrupt

Ben Hutchings (1):
      dns_resolver: Null-terminate the right string

Bjorn Helgaas (1):
      Input: sirfsoc-onkey - fix GPL v2 license string typo

Bjørn Mork (2):
      net: qmi_wwan: add two Sierra Wireless/Netgear devices
      net: huawei_cdc_ncm: add "subclass 3" devices

Boaz Harrosh (1):
      direct-io: fix uninitialized warning in do_direct_IO()

Borislav Petkov (1):
      x86, MCE: Robustify mcheck_init_device

Catalin Marinas (1):
      arm64: Create non-empty ZONE_DMA when DRAM starts above 4GB

Chris Wilson (2):
      drm/i915: Reorder the semaphore deadlock check, again
      drm/i915: Simplify i915_gem_release_all_mmaps()

Christian König (5):
      drm/radeon: let's use GB for vm_size (v2)
      drm/radeon: fix handling of radeon_vm_bo_rmv v3
      drm/radeon: fix VM IB handling
      drm/radeon: fix error handling in radeon_vm_bo_set_addr
      drm/radeon: fix irq ring buffer overflow handling

Christoph Hellwig (1):
      block: don't assume last put of shared tags is for the host

Christoph Schulz (1):
      net: ppp: fix creating PPP pass and active filters

Cong Wang (1):
      net_sched: avoid generating same handle for u32 filters

Dan Carpenter (2):
      [media] davinci: vpif: missing unlocks on error
      wan/x25_asy: integer overflow in x25_asy_change_mtu()

David Hildenbrand (1):
      s390: require mvcos facility, not tod clock steering facility

David Rientjes (1):
      perf/x86/intel: Avoid spamming kernel log for BTS buffer failure

David S. Miller (1):
      sparc: Hook up renameat2 syscall.

Dmitry Torokhov (1):
      Input: fix defuzzing logic

Eric Dumazet (2):
      netfilter: nf_tables: 64bit stats need some extra synchronization
      ipv4: fix buffer overflow in ip_options_compile()

Felipe Balbi (1):
      Input: ti_am335x_tsc - warn about incorrect spelling

Geert Uytterhoeven (1):
      sh: also try passing -m4-nofpu for SH2A builds

Guenter Roeck (1):
      hwmon: (smsc47m192) Fix temperature limit and vrm write operations

HIMANGI SARAOGI (1):
      parisc: Eliminate memset after alloc_bootmem_pages

Hans Verkuil (2):
      [media] saa7134: use unlocked_ioctl instead of ioctl
      [media] hdpvr: fix two audio bugs

Hans de Goede (3):
      MAINTAINERS: Add Hans de Goede as ahci-platform maintainer
      [media] gspca_pac7302: Add new usb-id for Genius i-Look 317
      Input: synaptics - add min/max quirk for pnp-id LEN2002 (Edge E531)

Hugh Dickins (6):
      drm/i915: fix freeze with blank screen booting highmem
      shmem: fix faulting into a hole, not taking i_mutex
      shmem: fix splicing from a hole while it's punched
      mm/fs: fix pessimization in hole-punching pagecache
      simple_xattr: permit 0-size extended attributes
      mm: fix direct reclaim writeback regression

Ingo Tuchscherer (1):
      s390/zcrypt: improve device probing for zcrypt adapter cards

Jean Delvare (2):
      ide: Fix CS5520 and CS5530 dependencies
      ide: Fix SC1200 dependencies

Jerome Glisse (1):
      drm/radeon: fix cut and paste issue for hawaii.

Jerry Chu (1):
      net-gre-gro: Fix a bug that breaks the forwarding path

Jiri Kosina (1):
      Input: i8042 - add Acer Aspire 5710 to nomux blacklist

Joel Stanley (1):
      powerpc: Disable doorbells on Power8 DD1.x

John David Anglin (1):
      parisc: Remove SA_RESTORER define

Kan Liang (1):
      perf/x86/intel: Protect LBR and extra_regs against KVM lying

Kevin Hao (1):
      libata: support the ata host which implements a queue depth less than 32

Kinglong Mee (1):
      NFSD: Fix crash encoding lock reply on 32-bit

Konstantin Khlebnikov (1):
      mm: do not call do_fault_around for non-linear fault

Lars Ellenberg (1):
      drbd: fix regression 'out of mem, failed to invoke fence-peer helper'

Laurent Pinchart (2):
      MAINTAINERS: Add entry for the Renesas pin controller driver
      gpio: rcar: Add support for DT IRQ flags

Li Zhong (1):
      powerpc: use _GLOBAL_TOC for memmove

Linus Torvalds (2):
      Fix gcc-4.9.0 miscompilation of load_balance()  in scheduler
      Linux 3.16-rc7

Martin Schwidefsky (3):
      s390/3270: correct size detection with the read-partition command
      s390/ptrace: fix PSW mask check
      s390: fix restore of invalid floating-point-control

Masami Hiramatsu (1):
      kprobes: Fix "Failed to find blacklist" probing errors on ia64 and ppc64

Max Filippov (2):
      xtensa: add fixup for double exception raised in window overflow
      xtensa: fix sysmem reservation at the end of existing block

Maxime COQUELIN (1):
      pinctrl: st: Fix irqmux handler

Michael Schmitz (1):
      m68k/atari - ide: do not register interrupt if host->get_lock is set

Michel Dänzer (1):
      r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40

Mihai Caraman (1):
      KVM: PPC: Book3E: Unlock mmu_lock when setting caching atttribute

Miklos Szeredi (1):
      fuse: s_time_gran fix

Mikulas Patocka (2):
      slab_common: fix the check for duplicate slab names
      block: provide compat ioctl for BLKZEROOUT

Minchan Kim (1):
      zram: avoid lockdep splat by revalidate_disk

Naoya Horiguchi (2):
      mm/rmap.c: fix pgoff calculation to handle hugepage correctly
      mm: hugetlb: fix copy_hugetlb_page_range()

Pablo Neira Ayuso (3):
      netfilter: nf_tables: skip transaction if no update flags in tables
      netfilter: nf_tables: safe RCU iteration on list when dumping
      netfilter: nf_tables: set NLM_F_DUMP_INTR if netlink dumping is stale

Paul Mackerras (1):
      powerpc: Fix bugs in emulate_step()

Peter Hutterer (1):
      Input: document INPUT_PROP_TOPBUTTONPAD

Peter Zijlstra (3):
      perf: Revert ("perf: Always destroy groups on exit")
      perf: Fix lockdep warning on process exit
      x86, cpu: Fix cache topology for early P4-SMT

Ping Cheng (1):
      Input: wacom - cleanup multitouch code when touch_max is 2

Randy Dunlap (1):
      parport: fix menu breakage

Rickard Strandqvist (1):
      [media] media: v4l2-core: v4l2-dv-timings.c: Cleaning up code
wrong value used in aspect ratio

Romain Degez (1):
      ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)

Silesh C V (1):
      coredump: fix the setting of PF_DUMPCORE

Simon Wunderlich (1):
      batman-adv: drop QinQ claim frames in bridge loop avoidance

Sonic Zhang (1):
      blackfin: bind different groups of one pinmux function to
different state name

Sowmini Varadhan (1):
      sunvnet: clean up objects created in vnet_new() on vnet_exit()

Stefan Richter (1):
      firewire: ohci: disable MSI for VIA VT6315 again

Stephane Eranian (1):
      perf/x86/intel/uncore: Fix SNB-EP/IVT Cbox filter mappings

Steven Miao (5):
      pm: bf609: cleanup smc nor flash
      blackfin: fix some bf5xx boards build for missing <linux/gpio.h>
      irq: blackfin sec: drop duplicated sec priority set
      defconfig: BF609: update spi config name
      blackfin: vmlinux.lds.S: reserve 32 bytes space at the end of
data section for XIP kernel

Sven Wegener (1):
      x86_32, entry: Store badsys error code in %eax

Takashi Sakamoto (4):
      ALSA: bebob: Fix a missing to unlock mutex in error handling case
      ALSA: bebob: Use different labels for digital input/output
      ALSA: bebob: Correction for return value of .put callback
      ALSA: bebob: Correction for return value of special_clk_ctl_put() in error

Tejun Heo (2):
      blkcg: don't call into policy draining if root_blkg is already gone
      libata: introduce ata_host->n_tags to avoid oops on SAS controllers

Tobias Klauser (1):
      Input: st-keyscan - fix 'defined but not used' compiler warnings

Tony Luck (1):
      tracing: Fix wraparound problems in "uptime" trace clock

Tyrel Datwyler (1):
      powerpc/pseries: dynamically added OF nodes need to call of_node_init

Vasily Averin (1):
      fs: umount on symlink leaks mnt count

Vince Weaver (1):
      perf/x86/intel: Use proper dTLB-load-misses event on IvyBridge

Yijing Wang (1):
      s390/MSI: Use standard mask and unmask funtions

Zoltan Kiss (4):
      xen-netback: Fix handling frag_list on grant op error path
      xen-netback: Fix releasing frag_list skbs in error path
      xen-netback: Fix releasing header slot on error path
      xen-netback: Fix pointer incrementation to avoid incorrect logging
