Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3BSA21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 19:28:27 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:55763 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab3BSA2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 19:28:25 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Feb 2013 16:28:03 -0800
X-Google-Sender-Auth: Y3yAWrcmeFCBNRslqM-GxAga_l4
Message-ID: <CA+55aFwdyYa0ajqgzUoAQmUD2frBe2-gvxgny_9gD6PCoOYrqw@mail.gmail.com>
Subject: Linux 3.8
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The release got delayed a couple of days because I was waiting for
confirmation of a small patch, but hey, we could also say that it was
all intentional, and that this is the special "Presidents' Day
Release". It sounds more planned that way, no?

Anyway, the really good news is that things calmed down a lot on the
last week. There are noticeably fewer commits, and they are also all
quite small. The few commits with more than just a couple of lines
tend to be due to a couple of reverts, and two architecture patches
where some identifiers got renamed (tile), or some defines got moved
from the uapi file to a private header (x86). And there's one radeon
patch that uses a helper function instead of reading bytes directly.

And even those "bigger" patches weren't really that big.

There was a pending btrfs fix that might have merited another -rc, but
instead of delaying things I just didn't pull that one at all, and
we'll just do it as a stable patch instead. It's not even a new
problem anyway.

Anyway, thanks to everybody who kept last week calm.

                 Linus

---
Alexander Duyck (1):
      ixgbe: Only set gso_type to SKB_GSO_TCPV4 as RSC does not support IPv6

Bjørn Mork (1):
      net: qmi_wwan: add Yota / Megafon M100-1 4g modem

Borislav Petkov (1):
      x86, MCE: Retract most UAPI exports

Chris Bagwell (1):
      Input: wacom - fix wacom_set_report retry logic

Chris Metcalf (9):
      tile: remove an unused variable in copy_thread()
      tile: include kernel/Kconfig.freezer in tile Kconfig
      drivers/input/joystick/analog.c: enable precise timer
      tile: provide "screen_info" when enabling VT
      tile: avoid defining INT_MASK macro in <arch/interrupts.h>
      drm: fix compile failure by including <linux/swiotlb.h>
      tile: export a handful of symbols appropriately
      tile: fix memcpy_*io functions for allnoconfig
      tile: tag some code with #ifdef CONFIG_COMPAT

Cong Ding (2):
      sparc: kernel/sbus.c: fix memory leakage
      mac80211: fix error in sizeof() usage

Cyril Roelandt (1):
      xen: remove redundant NULL check before unregister_and_remove_pcpu().

Dan Carpenter (1):
      ipvs: freeing uninitialized pointer on error

Daniel Borkmann (2):
      ipvs: sctp: fix checksumming on snat and dnat handlers
      net: sctp: sctp_v6_get_dst: fix boolean test in dst cache

David S. Miller (3):
      sparc64: Add missing HAVE_ARCH_TRANSPARENT_HUGEPAGE.
      sparc64: Fix get_user_pages_fast() wrt. THP.
      sunvdc: Fix off-by-one in generic_request().

Dmitry Torokhov (1):
      Input: document that unregistering managed devices is not necessary

Eric Dumazet (2):
      arp: fix possible crash in arp_rcv()
      net: fix infinite loop in __skb_recv_datagram()

Eric W. Biederman (1):
      kernel/pid.c: reenable interrupts when alloc_pid() fails because
init has exited

Francois Romieu (2):
      Revert "r8169: enable ALDPS for power saving".
      Revert "r8169: enable internal ASPM and clock request settings".

Gerald Schaefer (1):
      mm: don't overwrite mm->def_flags in do_mlockall()

Giuseppe CAVALLARO (2):
      stmmac: fix macro used for debugging the xmit
      stmmac: mdio register has to fail if the phy is not found

Glauber Costa (1):
      memcg: fix kmemcg registration for late caches

Greg Ungerer (1):
      m68knommu: fix trap on execing /bin/init

H. Peter Anvin (1):
      x86, doc: Add a bootloader ID for OVMF

Heiko Carstens (1):
      s390/timer: avoid overflow when programming clock comparator

Helge Deller (1):
      unbreak automounter support on 64-bit kernel with 32-bit userspace (v2)

Huang, Xiong (1):
      atl1c: add error checking for pci_map_single functions

Jan Beulich (1):
      x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

Jerome Glisse (1):
      drm/radeon: enforce use of radeon_get_ib_value when reading user cmd

Jiri Pirko (1):
      htb: fix values in opt dump

Johannes Berg (2):
      mac80211: fix managed mode channel context use
      mac80211: fix channel selection bug

Jonas Gorski (1):
      mwl8k: fix band for supported channels

Kees Cook (2):
      x86: Do not leak kernel page mapping locations
      net, sctp: remove CONFIG_EXPERIMENTAL

Konrad Rzeszutek Wilk (2):
      Revert "xen/PVonHVM: fix compile warning in init_hvm_pv_info"
      Revert "xen PVonHVM: use E820_Reserved area for shared_info"

Linus Torvalds (2):
      mm: fix pageblock bitmap allocation
      Linux 3.8

Linus Walleij (1):
      drivers/rtc/rtc-pl031.c: restore ST variant functionality

Maarten Lankhorst (1):
      drm/nouveau: use different register to wait for secret scrubber

Marcin Slusarz (1):
      drm/nouveau: add lockdep annotations

Marek Szyprowski (1):
      mm: cma: fix accounting of CMA pages placed in high memory

Mauro Carvalho Chehab (1):
      Revert "[media] dvb_frontend: return -ENOTTY for unimplement IOCTL"

Mel Gorman (1):
      x86/mm: Check if PUD is large when validating a kernel address

Michael S. Tsirkin (3):
      ixgbe: fix gso type
      qlcnic: set gso_type
      bnx2x: set gso_type

NeilBrown (1):
      OMAPDSS: add FEAT_DPI_USES_VDDS_DSI to omap3630_dss_feat_list

Nickolai Zeldovich (1):
      Input: lm8323 - fix checking PWM interrupt status

Nicolas Ferre (1):
      net/macb: fix race with RX interrupt while doing NAPI

Pau Koning (1):
      batman-adv: Fix NULL pointer dereference in DAT hash collision avoidance

Rafael J. Wysocki (1):
      PCI/PM: Clean up PME state when removing a device

Rob Herring (3):
      ARM: scu: add empty scu_enable for !CONFIG_SMP
      ARM: scu: mask cluster id from cpu_logical_map
      ARM: highbank: mask cluster id from cpu_logical_map

Roy Spliet (1):
      drm/nv50/fb: Fix nullptr-deref on IGPs

Satoru Takeuchi (1):
      efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi"
boot parameter

Stephen Hemminger (1):
      bridge: set priority of STP packets

Stoney Wang (1):
      x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server systems

Tomi Valkeinen (1):
      omapdrm: fix the dependency to omapdss

Wolfram Sang (1):
      MAINTAINERS: change my email and repos

YOSHIFUJI Hideaki / 吉藤英明 (3):
      netfilter: ip6t_NPT: Fix adjustment calculation
      netfilter: ip6t_NPT: Fix prefix mangling
      netfilter: ip6t_NPT: Ensure to check lower part of prefixes are zero
