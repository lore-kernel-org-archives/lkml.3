Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaHCWwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 18:52:10 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:64843 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaHCWwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 18:52:06 -0400
MIME-Version: 1.0
Date: Sun, 3 Aug 2014 15:52:04 -0700
X-Google-Sender-Auth: VBkEYnii0hfMYwvM1fVk6CIv66o
Message-ID: <CA+55aFxsvKryEZ=czAPkxJJe5Gk=uDn2u7ZZZx7TozdiBtLCTA@mail.gmail.com>
Subject: Linux 3.16
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So nothing particularly exciting happened this week, and 3.16 is out there.

And as usual (previous release being the exception) that means that
the merge window for 3.17 is obviously open. And for the third time in
a row, the timing sucks for me, as I have travel coming up the second
week of the merge window. Many other core developers will be traveling
too, since it's just before the kernel summit in Chicago.

So we'll see how the next merge window goes, but I'm not going to
worry about it overmuch. If I end up not having time to do all the
merges, I might delay things into the week of the kernel summit, but
I'll hope to get most of the big merging done this upcoming week
before any travel takes place, so maybe it won't come to that. So this
is just a heads-up that the merge window *might* be extended.

Anyway, back to the changes since -rc7: it's really fairly small stuff
randomly all over, with a third being architecture updates, a third
drivers, and a third "misc" (mainly mm and networking). The
architecture stuff is small ARM updates (mostly DT), some x86 Xen
fixups, some random small powerpc things.  The shortlog gives a good
idea of what kind of stuff it all is, but it's really just 83 commits
(plus merges and the release commit) and about a third of them are
marked for stable.

So while 3.16 looked a bit iffy for a while, things cleared up nicely,
and there was no reason to do extra release candidates like I feared
just a couple of weeks ago.

          Linus

---

Alexandre Bounine (1):
      rapidio/tsi721_dma: fix failure to obtain transaction descriptor

Alexey Khoroshilov (1):
      isdn/bas_gigaset: fix a leak on failure path in gigaset_probe()

Andreas Färber (1):
      MAINTAINERS: Update Tegra Git URL

Andrey Ryabinin (2):
      net: sendmsg: fix NULL pointer dereference
      mm: debugfs: move rounddown_pow_of_two() out from do_fault path

Andy Lutomirski (1):
      x86_64/entry/xen: Do not invoke espfix64 on Xen

Anssi Hannula (1):
      dm cache: fix race affecting dirty block count

Atsushi Kumagai (1):
      kexec: export free_huge_page to VMCOREINFO

Christoph Fritz (1):
      ARM: OMAP2+: gpmc: fix gpmc_hwecc_bch_capable()

Christoph Hellwig (1):
      direct-io: fix AIO regression

Daniel Borkmann (1):
      net: sctp: inherit auth_capable on INIT collisions

David Howells (1):
      AFS: Correctly assemble the client UUID

David L Stevens (1):
      sunvnet: only use connected ports when sending

David Rientjes (2):
      mm, thp: do not allow thp faults to avoid cpuset restrictions
      kexec: fix build error when hugetlbfs is disabled

David Vrabel (1):
      x86/xen: safely map and unmap grant frames when in atomic context

Dmitry Kravkov (1):
      bnx2x: fix crash during TSO tunneling

Eliad Peller (2):
      cfg80211: fix mic_failure tracing
      iwlwifi: mvm: pass beacons from foreign APs

Emmanuel Grumbach (1):
      iwlwifi: mvm: fix merge damage

Eric Biggers (1):
      vfs: fix check for fallocate on active swapfile

Eric Dumazet (1):
      ip: make IP identifiers less predictable

Ezequiel Garcia (2):
      net: phy: Set the driver when registering an MDIO bus device
      net: phy: Ensure the MDIO bus module is held

Felix Fietkau (2):
      mac80211: fix crash on getting sta info with uninitialized rate control
      ath9k: fix aggregation session lockup

Florian Fainelli (2):
      net: bcmgenet: correctly pad short packets
      net: phy: re-apply PHY fixups during phy_register_device

George Cherian (1):
      can: c_can_platform: Fix raminit, use devm_ioremap() instead of
devm_ioremap_resource()

Greg Thelen (1):
      dm bufio: fully initialize shrinker

Haojian Zhuang (1):
      ARM: dts: fix L2 address in Hi3620

James Bottomley (1):
      scsi: handle flush errors properly

Jan Kara (1):
      timer: Fix lock inversion between hrtimer_bases.lock and scheduler locks

Jes Sorensen (1):
      staging: rtl8723au: rtw_resume(): release semaphore before exit on error

Johannes Berg (1):
      Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"

Josh Triplett (1):
      Josh has moved

Julian Anastasov (1):
      ipvs: avoid netns exit crash on ip_vs_conn_drop_conntrack

Jun Zhao (1):
      neighbour : fix ndm_type type error issue

Konstantin Khlebnikov (1):
      ARM: 8115/1: LPAE: reduce damage caused by idmap to virtual memory layout

Lars-Peter Clausen (1):
      iio: buffer: Fix demux table creation

Laura Abbott (3):
      of: Split early_init_dt_scan into two parts
      of: Add memory limiting function for flattened devicetrees
      arm: Add devicetree fixup machine function

Linus Torvalds (2):
      Revert "cdc_subset: deal with a device that needs reset for timeout"
      Linux 3.16

Linus Walleij (1):
      ARM: nomadik: fix up double inversion in DT

Malcolm Priestley (2):
      staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
      staging: vt6655: Fix disassociated messages every 10 seconds

Maxim Patlasov (1):
      mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()

Michael Ellerman (1):
      powerpc/perf: Fix MMCR2 handling for EBB

Michal Hocko (1):
      memcg: oom_notify use-after-free fix

Mikulas Patocka (2):
      crypto: arm64-aes - fix encryption of unaligned data
      crypto: arm-aes - fix encryption of unaligned data

Milan Broz (1):
      crypto: af_alg - properly label AF_ALG socket

Naoya Horiguchi (2):
      hwpoison: fix hugetlbfs/thp precheck in hwpoison_user_mappings()
      hwpoison: call action_result() in failure path of hwpoison_user_mappings()

Nishanth Menon (1):
      pinctrl: dra: dt-bindings: Fix pull enable/disable

Oliver Neukum (2):
      cdc_subset: deal with a device that needs reset for timeout
      cdc-ether: clean packet filter upon probe

Omar Sandoval (1):
      ARM: 8124/1: don't enter kgdb when userspace executes a kgdb
break instruction

Peter Meerwald (2):
      iio:bma180: Fix scale factors to report correct acceleration units
      iio:bma180: Missing check for frequency fractional part

Peter Ujfalusi (1):
      clk: ti: clk-7xx: Correct ABE DPLL configuration

Rafael J. Wysocki (1):
      ACPI / PNP: Fix acpi_pnp_match()

Randy Dunlap (2):
      mm: fix page_alloc.c kernel-doc warnings
      mm: fix filemap.c pagecache_get_page() kernel-doc warnings

Russell King (3):
      ARM: DMA: ensure that old section mappings are flushed from the TLB
      ARM: fix alignment of keystone page table fixup
      ARM: idmap: add identity mapping usage note

Sebastian Hesselbarth (1):
      ARM: 8100/1: Fix preemption disable in iwmmxt_task_enable()

Sekhar Nori (1):
      ARM: OMAP2+: l2c: squelch warning dump on power control setting

Shinobu Uehara (1):
      ARM: shmobile: r8a7791: Fix SD2CKCR register address

Steffen Klassert (1):
      xfrm: Fix refcount imbalance in xfrm_lookup

Stephen Boyd (1):
      sched_clock: Avoid corrupting hrtimer tree during suspend

Thomas Falcon (1):
      powerpc: Fix endianness of flash_block_list in rtas_flash

Tobias Brunner (1):
      xfrm: Fix installation of AH IPsec SAs

Tony Lindgren (1):
      ARM: dts: Revert enabling of twl configuration for n900

Uwe Kleine-König (1):
      ARM: 8112/1: only select ARM_PATCH_PHYS_VIRT if MMU is enabled

Vasant Hegde (1):
      powerpc/powernv: Change BUG_ON to WARN_ON in elog code

Wei Yongjun (2):
      amd-xgbe: Fix error return code in xgbe_probe()
      hyperv: Fix error return code in netvsc_init_buf()

Will Deacon (1):
      kvm: arm64: vgic: fix hyp panic with 64k pages on juno platform

Yaniv Rosner (1):
      bnx2x: fix set_setting for some PHYs

hayeswang (1):
      r8152: fix the checking of the usb speed
