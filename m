Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965840Ab3FTT3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:29:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161077Ab3FTT3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:29:15 -0400
Date: Thu, 20 Jun 2013 12:29:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.50
Message-ID: <20130620192914.GA27830@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.50 kernel.

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

 Makefile                                   |    2=20
 arch/powerpc/include/asm/exception-64s.h   |    2=20
 arch/powerpc/kernel/irq.c                  |    2=20
 arch/powerpc/kernel/process.c              |    4=20
 arch/x86/kernel/relocate_kernel_64.S       |    2=20
 drivers/block/cciss.c                      |   32 +++----
 drivers/gpu/drm/gma500/cdv_intel_display.c |   14 +++
 drivers/gpu/drm/gma500/psb_intel_display.c |   14 +++
 drivers/gpu/drm/i915/intel_sdvo.c          |   10 +-
 drivers/md/raid1.c                         |   12 ++
 drivers/md/raid10.c                        |   12 ++
 drivers/net/wireless/ath/ath9k/Kconfig     |   10 +-
 drivers/net/wireless/ath/ath9k/Makefile    |    2=20
 drivers/net/wireless/ath/ath9k/init.c      |    7 -
 drivers/net/wireless/ath/ath9k/rc.h        |    2=20
 drivers/net/wireless/b43/main.c            |    2=20
 drivers/rtc/rtc-twl.c                      |    1=20
 fs/ceph/locks.c                            |   73 +++++++++++-------
 fs/ceph/mds_client.c                       |   90 ++++++++++++----------
 fs/ceph/super.c                            |    7 +
 fs/ceph/super.h                            |   11 +-
 include/linux/ceph/auth.h                  |   18 ++++
 include/linux/cpu.h                        |    4=20
 include/linux/swapops.h                    |    3=20
 include/net/bluetooth/hci_core.h           |    1=20
 include/net/bluetooth/mgmt.h               |    1=20
 kernel/cpu.c                               |   55 +++++--------
 kernel/sys.c                               |   29 ++++++-
 mm/hugetlb.c                               |    2=20
 mm/migrate.c                               |   23 ++++-
 mm/swap_state.c                            |   18 ++++
 net/bluetooth/hci_core.c                   |    6 +
 net/bluetooth/mgmt.c                       |   21 +++++
 net/ceph/auth.c                            |  117 ++++++++++++++++++++++++=
-----
 net/ceph/auth_x.c                          |   24 +++++
 net/ceph/auth_x.h                          |    1=20
 net/ceph/messenger.c                       |    3=20
 net/ceph/mon_client.c                      |    7 -
 net/ceph/osd_client.c                      |   29 +++----
 39 files changed, 478 insertions(+), 195 deletions(-)

Alex Elder (1):
      libceph: must hold mutex for reset_changed_osds()

Alex Lyakas (1):
      md/raid1: consider WRITE as successful only if at least one non-Fault=
y and non-rebuilding drive completed it.

Benjamin Herrenschmidt (1):
      powerpc: Fix missing/delayed calls to irq_work

Daniel Vetter (1):
      drm/i915: prefer VBT modes for SVDO-LVDS over EDID

Greg Kroah-Hartman (1):
      Linux 3.4.50

Jim Schutt (2):
      ceph: add cpu_to_le32() calls when encoding a reconnect capability
      ceph: ceph_pagelist_append might sleep while atomic

Johan Hedberg (1):
      Bluetooth: Fix mgmt handling of power on failures

Kees Cook (2):
      b43: stop format string leaking into error msgs
      x86: Fix typo in kexec register clearing

Michael Ellerman (1):
      powerpc: Fix stack overflow crash in resume_kernel when ftracing

Naoya Horiguchi (1):
      mm: migration: add migrate_entry_wait_huge()

Patrik Jakobsson (2):
      drm/gma500/psb: Unpin framebuffer on crtc disable
      drm/gma500/cdv: Unpin framebuffer on crtc disable

Rafael Aquini (1):
      swap: avoid read_swap_cache_async() race to deadlock while waiting on=
 discard I/O completion

Robin Holt (1):
      reboot: rigrate shutdown/reboot to boot cpu

Sage Weil (6):
      libceph: clear messenger auth_retry flag when we authenticate
      libceph: fix authorizer invalidation
      libceph: add update_authorizer auth method
      libceph: wrap auth ops in wrapper functions
      libceph: wrap auth methods in a mutex
      ceph: fix statvfs fr_size

Srivatsa S. Bhat (1):
      CPU hotplug: provide a generic helper to disable/enable CPU hotplug

Stephen M. Cameron (1):
      cciss: fix broken mutex usage in ioctl

Sujith Manoharan (2):
      ath9k: Disable PowerSave by default
      ath9k: Use minstrel rate control by default

Tony Lindgren (1):
      drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted w=
ith device tree


--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRw1gKAAoJEDjbvchgkmk+aPIQAMHqJgUC8lDJa0y6PioyoRJ6
hZbKJZc5gIdZF5TjAmgdDkzMWJeqvT9kfiuZDaMvtpBLd5GsUyNtv1thF7MreF0L
R9zC93g3ON1sjMcJTgotW6wEIAf+vPRr3vaAK+/N1aZkJJCGLKOxTiJkUA2gfR7p
44Pzr5BaRClSWFWxpuLkIMJBHCnD1wT42gyowmTyhvFSB4QGutY46mlUsedcRPWd
uJpL5TL7aUoXkZ6dKpN26vwsltr6Bn1+mDlP692RIvAwLO5/na6FwZFdO4vbCLAb
7ik6kAG5p4spgcrgBKjEqvypzij4QB6oQ3biV6Vcv079Y0chXuWjLbsdafZPFpHK
XUV9x8p4rMnowDckZjgiRAmD0EldUaG/5N921801wINJOfSRENKriNbIFG/+JwZy
QOF/D63sLUJB2KtLypyCSgd3qc7bg3JPZuZEoTDJ4E/Aq8koFpB4RvEaJw8mi62v
4fL8qqUVRqiZr54yWXiXEE0xNzjzOuJxua8wXpym7W0SMBmi1ztzEWODZgzWwRe+
xs7NnGeWlqJlAUfc2jX2cIhzid1WiS6J0ka2fmhkjDLvGVyOGYR6X7eda2QnNQ14
nhuXLcHIlAvh2ZGvBaLwYjzGmIN5q3tejRr22OuFoRtKp2lil9bPvjMRAb6E0aGi
xJWK+i+iW1cK2DAW28Vq
=7+xK
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
