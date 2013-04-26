Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab3DZEaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 00:30:22 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:37314 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3DZEaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 00:30:20 -0400
Date: Thu, 25 Apr 2013 21:30:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.75
Message-ID: <20130426043017.GA22553@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.75 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                      |    2 -
 arch/arm/mm/cache-feroceon-l2.c               |    1=20
 arch/x86/include/asm/kvm_host.h               |    4 +-
 arch/x86/kvm/x86.c                            |   40 ++++++++-------------
 crypto/algif_hash.c                           |    2 +
 crypto/algif_skcipher.c                       |    1=20
 drivers/char/hpet.c                           |   14 -------
 drivers/gpu/vga/vga_switcheroo.c              |    3 +
 drivers/mtd/mtdchar.c                         |   32 +----------------
 drivers/net/can/sja1000/sja1000_of_platform.c |   31 ++++++++--------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 -
 drivers/video/console/fbcon.c                 |   11 ++++-
 drivers/video/fbmem.c                         |   42 ++++++++--------------
 fs/btrfs/tree-log.c                           |   48 +++++++++++++++++++++=
+----
 fs/hfsplus/extents.c                          |    2 -
 fs/sysfs/dir.c                                |   14 -------
 include/linux/kvm_host.h                      |    2 -
 include/linux/kvm_types.h                     |    1=20
 include/linux/mm.h                            |    2 +
 kernel/events/core.c                          |    2 -
 kernel/hrtimer.c                              |    3 -
 kernel/sched.c                                |    6 ++-
 kernel/signal.c                               |    2 -
 mm/hugetlb.c                                  |   12 +++++-
 mm/memory.c                                   |   47 +++++++++++++++++++++=
++++
 net/8021q/vlan.c                              |   14 +++----
 sound/core/pcm_native.c                       |   12 +-----
 virt/kvm/ioapic.c                             |    7 ++-
 virt/kvm/kvm_main.c                           |   39 ++++++++++++++++-----
 29 files changed, 227 insertions(+), 171 deletions(-)

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

Felix Fietkau (1):
      ath9k_htc: accept 1.x firmware newer than 1.3

Greg Kroah-Hartman (2):
      Revert "8021q: fix a potential use-after-free"
      Linux 3.0.75

Illia Ragozin (1):
      ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon

Jiri Kosina (1):
      Revert "sysfs: fix race between readdir and lseek"

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

Tejun Heo (1):
      sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s

Tommi Rantala (1):
      perf: Treat attr.config as u64 in perf_swevent_init()

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()


--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRegLZAAoJEDjbvchgkmk+/W8QAMJ1BD7kQ6OVVGGXudyu6ADF
2TkcE+HdnFhKQZ4+NLfWLNezvK8FjTSngSsyd8+W9WLkdQ12rCbVpr7E5Mfrvupp
dqKkElclD16r5vPljHSB84bHTDejARyFCQtjPn3kGquZXisarBgoDBz1Aav5F/8g
iPsZVoc2CsqFGaeOEBeDW+KRTKFXDJGZgqKuUIGECzPJep6nE8cP0Onk/gFojMC4
iiCPpaZ8HwGhCj/YzElJ/u/NxyXwPkLDi6LSuxe4NrADlsG8pwNNyu7qG7VwIf9A
jKnR70FHoxHZzghRxQ/zKA7Hp1WLXzTFD2Fyypl/f7fwwtqxcaz4fcotQZ+GEhds
U/gFSZR4q+DVIP2UpmOI9coJOoqDA2dS+KsIgFTK/Fv1il3OmVCC91YGgnsESkH2
1DnL0svjaHIYt1Mf49ggdhCrH9lzomxvuj5qPZFZmppMBgidEYCjZOTNfXa4ahS/
Ftoo71tvvlkmbEbUNGNmfTPVUaB80yG5j1uK4jzqc9K3yvu/zoIiDGn1UFOYDq+M
jIxzsiRsePoGw6AZkY68utlSXvtz86JywKK75NzoE7rpKTqCmBlrkfsaND+w6J/Z
DexuNtLM6B7/K/mk8Hy8C/Ouo18cRkMVrLr0lU1iKLJiryhMkfraiMG7NfSqj2cD
qhK9yfdPeNiDhOpVmYGe
=t4zh
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
