Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3DZE3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 00:29:34 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43853 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3DZE3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 00:29:32 -0400
Date: Thu, 25 Apr 2013 21:29:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.42
Message-ID: <20130426042929.GA22499@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.42 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/arm/kernel/perf_event.c                         |    5 +
 arch/arm/mm/cache-feroceon-l2.c                      |    1=20
 arch/arm/mm/proc-arm920.S                            |    2=20
 arch/arm/mm/proc-arm926.S                            |    2=20
 arch/arm/mm/proc-sa1100.S                            |    2=20
 arch/arm/mm/proc-v6.S                                |    2=20
 arch/arm/mm/proc-xsc3.S                              |    2=20
 arch/arm/mm/proc-xscale.S                            |    2=20
 arch/x86/include/asm/kvm_host.h                      |    4 -
 arch/x86/kernel/cpu/perf_event_intel.c               |   15 ++++-
 arch/x86/kvm/x86.c                                   |   43 +++++++-------=
---
 crypto/algif_hash.c                                  |    2=20
 crypto/algif_skcipher.c                              |    1=20
 drivers/char/hpet.c                                  |   14 -----
 drivers/gpu/vga/vga_switcheroo.c                     |    3 +
 drivers/mtd/mtdchar.c                                |   32 ------------
 drivers/net/can/sja1000/sja1000_of_platform.c        |   31 +++++-------
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h |    2=20
 drivers/net/wireless/ath/ath9k/htc_drv_init.c        |    2=20
 drivers/net/wireless/b43/phy_n.c                     |    3 -
 drivers/ssb/driver_chipcommon_pmu.c                  |   29 +++++++++++
 drivers/video/console/fbcon.c                        |   11 +++-
 drivers/video/fbmem.c                                |   42 ++++++--------=
--
 fs/btrfs/tree-log.c                                  |   48 ++++++++++++++=
++---
 fs/hfsplus/extents.c                                 |    2=20
 include/linux/kvm_host.h                             |    2=20
 include/linux/kvm_types.h                            |    1=20
 include/linux/mm.h                                   |    2=20
 include/linux/ssb/ssb_driver_chipcommon.h            |    2=20
 kernel/events/core.c                                 |    2=20
 kernel/hrtimer.c                                     |    3 -
 kernel/sched/core.c                                  |    6 +-
 kernel/signal.c                                      |    2=20
 mm/hugetlb.c                                         |   12 ++++
 mm/memory.c                                          |   47 ++++++++++++++=
++++
 sound/core/pcm_native.c                              |   12 ----
 virt/kvm/ioapic.c                                    |    7 +-
 virt/kvm/kvm_main.c                                  |   47 ++++++++++++++=
----
 39 files changed, 283 insertions(+), 166 deletions(-)

Andrew Honig (1):
      KVM: Allow cross page reads and writes from cached translations.

Andy Honig (3):
      KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME =
(CVE-2013-1796)
      KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use gfn_to_hva_cache functio=
ns (CVE-2013-1797)
      KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-=
1798)

Christoph Fritz (1):
      can: sja1000: fix handling on dt properties on little endian systems

Dave Airlie (1):
      fbcon: fix locking harder

Emese Revfy (1):
      kernel/signal.c: stop info leak via the tkill and the tgkill syscalls

Felix Fietkau (2):
      ath9k_htc: accept 1.x firmware newer than 1.3
      ath9k_hw: change AR9580 initvals to fix a stability issue

Greg Kroah-Hartman (1):
      Linux 3.4.42

Illia Ragozin (1):
      ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon

Josef Bacik (1):
      Btrfs: make sure nbytes are right after log replay

Linus Torvalds (5):
      vm: add vm_iomap_memory() helper function
      vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
      vm: convert fb_mmap to vm_iomap_memory() helper
      vm: convert HPET mmap to vm_iomap_memory() helper
      vm: convert mtdchar mmap to vm_iomap_memory() helper

Mathias Krause (1):
      crypto: algif - suppress sending source address information in recvmsg

Michael Bohan (1):
      hrtimer: Don't reinitialize a cpu_base lock on CPU_UP

Naoya Horiguchi (1):
      hugetlbfs: add swap entry check in follow_hugetlb_page()

Rafa=C5=82 Mi=C5=82ecki (1):
      ssb: implement spurious tone avoidance

Russell King (1):
      ARM: Do 15e0d9e37c (ARM: pm: let platforms select cpu_suspend support=
) properly

Stephane Eranian (1):
      perf/x86: Fix offcore_rsp valid mask for SNB/IVB

Tejun Heo (1):
      sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s

Tommi Rantala (1):
      perf: Treat attr.config as u64 in perf_swevent_init()

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()

Will Deacon (1):
      ARM: 7698/1: perf: fix group validation when using enable_on_exec


--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRegKpAAoJEDjbvchgkmk+6i4P/3UEwhwxSHRzxTl6Iu1JKczK
wYQve7FJL3MqfsDt2Iczr8DYXswjvaj0h+IG5MvV35YSUCq951PIEn7cuFXV14Tv
Th0uzvLZXZWJeno8Ag4hwvLGFANayfVt/zoLIy/y343fHNZn7tvcWd8z0CN1y0Jr
KNBhRdaTT+2WtUxz8pTx4DSQZi5aM4Ngm+7CEKpBMROro9zaIKuFtVj2dtapzLvS
TqU9fwjqvGmySTCjprTZVyMDWLhh1WtEGIKrEf0y5b7M1Xg9eSkwGdb4Hz4gO1TH
uOZqK+IB1Gmq6odNaRNJRjme5s+yO/ZiibA7KneA6dcXnubpoHnRKsko2K8Fpl8J
XDFN3s0AMDZlfGp12r+fKz/5XzNS1YH84WdCdW86jlt3T9SNVxmK01LuXE7cOYGa
pc7Jtd/Lmqt2Qq3dT0zDeRnKXsq9lfULYRAkeT/IMO/7nv/6UchlBj0932Slo3Nm
g4HkiXmFVDcOFFJJxGkA1srGeVVKxJ5uYdAdFXA7wLivJssK8me8alMSPLHOOkE3
6Zc/+TpdUAgMMr5iN6ftGfy6WCW1m/heqXm6QZSgoGiCmPV0gSzAZXFHUsi99mG9
TOqh64dc0VsNMR1SJhPKGF4Lf0FM+UkZ8xpKyWo6o6BNODrmR8oRDKsjFGAxA371
TctsfDZM/V/Ft5SGTsfT
=jay3
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
