Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaCYCkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 22:40:10 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:64754 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaCYCkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 22:40:08 -0400
MIME-Version: 1.0
Date: Mon, 24 Mar 2014 19:40:06 -0700
X-Google-Sender-Auth: EwvSnaT2W_vWEaEshtji8ZTGlUo
Message-ID: <CA+55aFzFj_XMNha5gcDHfmLE_Jb-O2OpdTbZyQdarJnip1gSBQ@mail.gmail.com>
Subject: Linux 3.14-rc8
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I delayed things a day from my normal schedule, hoping I'd feel more
comfortable doing a 3.14 release, but that was not to be. So here's an
rc8, and I expect to do the final 3.14 release next weekend.

There wasn't that much scary stuff going on, but there's a few vfs
fixes still pending, and we did end up having some interesting core
fixes last week too (not new regressions, but newly detected by
Trinity. Kudos to Hugh Dickins for figuring them out and fixing the
causes). There's also some networking fixes and random noise (mainly
MIPS).  So I really wanted another week before release after all.

                   Linus

---
Alex Smith (1):
      MIPS: Fix possible build error with transparent hugepages enabled

Andreas Herrmann (1):
      MIPS: Octeon: Fix warning in of_device_alloc on cn3xxx

Arnaldo Carvalho de Melo (1):
      perf bench numa: Make no args mean 'run all tests'

Ben Pfaff (1):
      openvswitch: Correctly report flow used times for first 5
minutes after boot.

Ben Widawsky (1):
      drm/i915: Fix PSR programming

Benedikt Spranger (1):
      net: cpsw: do not register cpts twice

Bjorn Helgaas (1):
      Revert "[PATCH] Insert GART region into resource map"

Bjørn Mork (1):
      net: cdc_ncm: fix control message ordering

Boris BREZILLON (1):
      ARM: at91: fix network interface ordering for sama5d36

Charles Keepax (1):
      ALSA: compress: Pass through return value of open ops callback

Chris Wilson (1):
      drm/i915: Disable stolen memory when DMAR is active

Christian Riesch (2):
      net: davinci_emac: Replace devm_request_irq with request_irq
      net: davinci_emac: Fix rollback of emac_dev_open()

Clemens Ladisch (1):
      ALSA: oxygen: Xonar DG(X): fix Stereo Upmixing regression

Colin Ian King (1):
      MIPS: Octeon: Fix fall through on bar type OCTEON_DMA_BAR_TYPE_SMALL

Daniel Kurtz (1):
      drm/exynos: Fix (more) freeing issues in exynos_drm_drv.c

Daniel Vetter (2):
      drm/i915: Don't enable display error interrupts from the start
      drm: Fix use-after-free in the shadow-attache exit code

Dave Jones (2):
      brcmfmac: fix skb leak in brcmf_sdio_txpkt_prep_sg error path.
      block: free q->flush_rq in blk_init_allocated_queue error paths

Dave Kleikamp (1):
      sparc64: don't treat 64-bit syscall return codes as 32-bit

David Miller (1):
      sparc: serial: Clean up the locking for -rt

David S. Miller (1):
      sparc64: Make sure %pil interrupts are enabled during hypervisor yield.

David Stevens (2):
      vxlan: fix potential NULL dereference in arp_reduce()
      vxlan: fix nonfunctional neigh_reduce()

Deng-Cheng Zhu (4):
      MIPS: APRP: Fix the linking of rtlx interrupt hook
      MIPS: APRP: Unregister rtlx interrupt hook at module exit
      MIPS: APRP: Choose the correct VPE loader by fixing the linking
      MIPS: math-emu: Fix prefx detection and COP1X function field definition

Doug Wilson (1):
      sparc64:tsb.c:use array size macro rather than number

Eric Dumazet (1):
      tcp: syncookies: do not use getnstimeofday()

Erik Hugne (1):
      tipc: fix spinlock recursion bug for failed subscriptions

Felix Fietkau (1):
      ath9k_hw: fix unreachable code in baseband hang detection code

Fernando Luis Vázquez Cao (1):
      HID: hidraw: fix warning destroying hidraw device files after parent

Frank Praznik (1):
      HID: sony: Fix work queue issues.

Helge Deller (2):
      partly revert commit 8a10bc9: parisc/sti_console: prefer Linux
fonts over built-in ROM fonts
      parisc: wire up sys_utimes

Helmut Schaa (1):
      ath9k: Fix sequence number assignment for non-data frames

Huacai Chen (1):
      MIPS: FPU: Fix conflict of register usage

Hugh Dickins (2):
      mm: fix bad rss-counter if remap_file_pages raced migration
      mm: fix swapops.h:131 bug if remap_file_pages raced migration

Jani Nikula (1):
      Revert "drm/i915: don't touch the VDD when disabling the panel"

Jarno Rajahalme (2):
      openvswitch: Read tcp flags only then the tranport header is present.
      openvswitch: Fix race.

Jens Axboe (1):
      mtip32xx: fix bad use of smp_processor_id()

Jim Quinlan (1):
      MIPS: Make local_irq_disable macro safe for non-Mipsr2

Jiri Pirko (1):
      ovs: fix dp check in ovs_dp_reset_user_features

Joe Perches (1):
      MAINTAINERS: Add linux.nics@intel.com to INTEL ETHERNET DRIVERS

John David Anglin (1):
      parisc: Remove unused CONFIG_PARISC_TMPALIAS code

Lars Persson (1):
      MIPS: Fix syscall tracing interface

Li RongQing (1):
      netpoll: fix the skb check in pkt_is_ns

Li Zefan (1):
      cgroup: fix a failure path in create_css()

Linus Torvalds (2):
      futex: revert back to the explicit waiter counting code
      Linux 3.14-rc8

Manuel Lauss (1):
      MIPS: Alchemy: Fix unchecked kstrtoul return value

Markos Chandras (2):
      MIPS: bcm47xx: Include missing errno.h for ENXIO
      MIPS: asm: syscall: Fix copying system call arguments

Michael Chan (3):
      cnic: Use proper ulp_ops for per device operations.
      cnic,bnx2i,bnx2fc: Fix inconsistent use of page size
      cnic: Update version to 2.5.20 and copyright year.

Mike Snitzer (2):
      block: fix q->flush_rq NULL pointer crash on dm-mpath flush
      block: change flush sequence list addition back to front add

Nicolas Dichtel (3):
      rtnetlink: fix fdb notification flags
      ipmr: fix mfc notification flags
      ip6mr: fix mfc notification flags

Nikolay Aleksandrov (2):
      net: af_key: fix sleeping under rcu
      selinux: add gfp argument to security_xfrm_policy_alloc and fix callers

Nishanth Menon (1):
      net: micrel : ks8851-ml: add vdd-supply support

Patrick Palka (1):
      perf bench: Fix NULL pointer dereference in "perf bench all"

Paul Bolle (2):
      MIPS: Replace CONFIG_MIPS64 and CONFIG_MIPS32_R2
      isdn/capi: Make Middleware depend on CAPI2.0

Paul Burton (1):
      MIPS: mark O32+FP64 experimental for now

Paul Mackerras (2):
      KVM: PPC: Book3S HV: Remove bogus duplicate code
      KVM: PPC: Book3S HV: Fix register usage when loading/saving VRSAVE

Peter Senna Tschudin (2):
      ATHEROS-ALX: Use dma_set_mask_and_coherent and fix a bug
      ATHEROS-ATL1E: Convert iounmap to pci_iounmap

Rafał Miłecki (1):
      MIPS: BCM47XX: Check all (32) GPIOs when looking for a pin

Ralf Baechle (1):
      MIPS: Fix randconfig build error.

Roger Luethi (1):
      via-rhine: Disable device in error path

Sebastian Hesselbarth (1):
      net: phy: fix uninitalized ethtool_wolinfo in phy_suspend

Shawn Guo (1):
      MAINTAINERS: update IMX kernel git tree

Simon Wood (1):
      HID: hid-lg4ff: Support new version of G27

Stanislaw Gruszka (1):
      Revert "rt2x00: rt2800lib: Update BBP register initialization for RT53xx"

Stefan Agner (1):
      clocksource: vf_pit_timer: use complement for sched_clock reading

Vaibhav Nagarnaik (1):
      tracing: Fix array size mismatch in format string

Ville Syrjälä (2):
      drm/i915: Add a workaround for HSW scanline counter weirdness
      drm/i915: Fix scanline counter fixup on BDW

Viller Hsiao (2):
      MIPS: ftrace: Fix icache flush range error
      MIPS: ftrace: Tweak safe_load()/safe_store() macros

Will Deacon (1):
      parisc: locks: remove redundant arch_*_relax operations

lucien (1):
      ipv6: ip6_append_data_mtu do not handle the mtu of the second
fragment properly

stephen hemminger (1):
      netlink: fix setsockopt in mmap examples in documentation
