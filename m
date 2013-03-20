Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3CTUNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:13:52 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:52924 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3CTUNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:13:49 -0400
Date: Wed, 20 Mar 2013 13:15:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.37
Message-ID: <20130320201514.GA18219@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.37 kernel.

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

 Makefile                                  |    2=20
 arch/powerpc/kernel/cputable.c            |    2=20
 arch/powerpc/mm/hash_utils_64.c           |    2=20
 arch/s390/include/asm/tlbflush.h          |    2=20
 arch/s390/kernel/entry.S                  |    3=20
 arch/s390/kernel/entry64.S                |    5=20
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   10=20
 arch/x86/power/cpu.c                      |    2=20
 drivers/block/loop.c                      |   24 +-
 drivers/char/hw_random/virtio-rng.c       |   13 +
 drivers/gpu/drm/i915/i915_gem.c           |    5=20
 drivers/gpu/drm/i915/intel_display.c      |    2=20
 drivers/hwmon/lineage-pem.c               |    2=20
 drivers/hwmon/pmbus/ltc2978.c             |   14 -
 drivers/hwmon/sht15.c                     |    2=20
 drivers/net/macvlan.c                     |    1=20
 drivers/net/tun.c                         |    2=20
 drivers/staging/vt6656/main_usb.c         |    4=20
 drivers/tty/pty.c                         |    1=20
 drivers/tty/serial/8250/8250_pci.c        |    4=20
 drivers/tty/serial/Kconfig                |    2=20
 drivers/usb/class/cdc-wdm.c               |   23 +-
 drivers/usb/host/ehci-q.c                 |   18 +
 drivers/usb/serial/cp210x.c               |   20 +
 drivers/usb/serial/option.c               |    5=20
 drivers/usb/serial/qcaux.c                |    1=20
 drivers/usb/storage/initializers.c        |   76 ------
 drivers/usb/storage/initializers.h        |    4=20
 drivers/usb/storage/unusual_devs.h        |  329 +++++++++++++++++++++++++=
++++-
 drivers/video/atmel_lcdfb.c               |   22 +-
 drivers/w1/w1.c                           |    3=20
 drivers/xen/xen-pciback/pciback_ops.c     |    3=20
 fs/block_dev.c                            |    4=20
 fs/btrfs/volumes.c                        |    6=20
 fs/ext3/super.c                           |    4=20
 include/linux/perf_event.h                |    6=20
 include/video/atmel_lcdc.h                |    1=20
 kernel/signal.c                           |    3=20
 net/core/dev.c                            |    1=20
 net/core/rtnetlink.c                      |    1=20
 net/dcb/dcbnl.c                           |    7=20
 net/ieee802154/6lowpan.h                  |    2=20
 net/ipv4/tcp_input.c                      |    6=20
 net/ipv6/ip6_input.c                      |    3=20
 net/ipv6/route.c                          |    3=20
 net/l2tp/l2tp_ppp.c                       |    1=20
 net/netlabel/netlabel_unlabeled.c         |   27 +-
 net/rds/message.c                         |    3=20
 security/selinux/xfrm.c                   |    2=20
 sound/core/seq/seq_timer.c                |    8=20
 50 files changed, 540 insertions(+), 156 deletions(-)

Alan Stern (1):
      USB: EHCI: don't check DMA values in QH overlays

Amit Shah (1):
      virtio: rng: disallow multiple device registrations, fixes crashes

Axel Lin (1):
      hwmon: (lineage-pem) Add missing terminating entry for pem_[input|fan=
]_attributes

Ben Hutchings (1):
      hwmon: (sht15) Fix memory leak if regulator_enable() fails

Benjamin Herrenschmidt (2):
      powerpc: Fix STAB initialization
      powerpc: Fix cputable entry for 970MP rev 1.0

Bj=F8rn Mork (2):
      USB: option: add Huawei E5331
      USB: storage: fix Huawei mode switching regression

Christian Schmiedl (1):
      USB: added support for Cinterion's products AH6 and PLS8

Cong Wang (1):
      rds: limit the size allocated by rds_message_alloc()

Cristian Bercaru (1):
      bridging: fix rx_handlers return code

Dan Carpenter (1):
      selinux: use GFP_ATOMIC under spin_lock

Dan Williams (1):
      qcaux: add Franklin U600

David Rientjes (1):
      perf,x86: fix link failure for non-Intel configs

Dmitry Rogozhkin (1):
      drm/i915: EBUSY status handling added to i915_gem_fault().

Eric Dumazet (1):
      tun: add a missing nf_reset() in tun_net_xmit()

Eric Sandeen (1):
      btrfs: use rcu_barrier() to wait for bdev puts at unmount

Greg Kroah-Hartman (1):
      Linux 3.4.37

Guenter Roeck (1):
      hwmon: (pmbus/ltc2978) Fix temperature reporting

Guillaume Nault (1):
      l2tp: Restore socket refcount when sendmsg succeeds

Guo Chao (3):
      block: use i_size_write() in bd_set_size()
      loopdev: fix a deadlock
      loopdev: remove an user triggerable oops

Hannes Frederic Sowa (1):
      ipv6: stop multicast forwarding to process interface scoped addresses

Heiko Carstens (1):
      s390/mm: fix flush_tlb_kernel_range()

Jiri Slaby (1):
      TTY: do not reset master's packet mode

Johan Hovold (1):
      atmel_lcdfb: fix 16-bpp modes on older SOCs

Kees Cook (1):
      signal: always clear sa_restorer on execve

Konrad Rzeszutek Wilk (1):
      xen/pciback: Don't disable a PCI device that is already disabled.

Lars-Peter Clausen (1):
      ext3: Fix format string issues

Linus Torvalds (1):
      perf,x86: fix wrmsr_on_cpu() warning on suspend/resume

Lorenzo Colitti (1):
      net: ipv6: Don't purge default router if accept_ra=3D2

Malcolm Priestley (1):
      staging: vt6656: Fix oops on resume from suspend.

Marcin Jurkowski (1):
      w1: fix oops when w1_search is called from netlink connector

Martin Schwidefsky (1):
      s390: critical section cleanup vs. machine checks

Mathias Krause (2):
      rtnl: fix info leak on RTM_GETLINK request for VF devices
      dcbnl: fix various netlink info leaks

Matwey V. Kornilov (1):
      usb: cp210x new Vendor/Device IDs

Neal Cardwell (1):
      tcp: fix double-counted receiver RTT when leaving receiver fast path

Oliver Neukum (1):
      USB: cdc-wdm: fix buffer overflow

Paul Bolle (1):
      tty: serial: fix typo "ARCH_S5P6450"

Paul Moore (1):
      netlabel: correctly list all the static label mappings

Stephane Eranian (1):
      perf,x86: fix kernel crash with PEBS/BTS after suspend/resume

Steve Conklin (1):
      usb: serial: Add Rigblaster Advantage to device table

St=E9phane Marchesin (1):
      drm/i915: Increase the RC6p threshold.

Takashi Iwai (1):
      ALSA: seq: Fix missing error handling in snd_seq_timer_open()

Vlad Yasevich (1):
      macvlan: Set IFF_UNICAST_FLT flag to prevent unnecessary promisc mode.

Wang YanQing (1):
      serial: 8250_pci: add support for another kind of NetMos Technology P=
CI 9835 Multi-I/O Controller

YOSHIFUJI Hideaki (1):
      6lowpan: Fix endianness issue in is_addr_link_local().


--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRShjSAAoJEDjbvchgkmk+ZZYQAJvO7+IMnabScJpyOoG/C1vQ
DGhkBC8dIQ7StCi6gz7+QA9FARDKcv/FOiS/c99zIM/GnzANJq9bZ7mS2VrQXFWh
Xo0Z3QvmKLRQeGWgjWOii8GVt0jSycBPa8PJFJGzUe59V/cA2DusxcnN2kwNnYW7
3piAz1a8I+IwUsM3kLz3ehXcXJU/Hv2Bqrfm9UaBrOjwbTsijHVPfsIHr4Dqbrwa
jqk6jX6vbGo+FWq+dIhRJuyAyM2rY3r+h5ht4KA3iC731MZkcnRdw5kMa9PZsHbO
QFV9KZyplymvEiWlZan9vxLF7zjq8xrf91+3Th5ii005YiyHu3f3sa+wEt4BoEuN
VRb6VisBPHC4DxnAxJnD2I5bCUyaHi7OKd07/wPNYl0iQ9Mc3BLJs9vQFSrL3e2H
+ECRaS6oB41Epgz07HBtN+fj2jJ4kazB9k+32aafGCjDof3c29xcKow+it3ThOC9
UJxEO4kORXrER59xZ9BKzdOt9VNYvN7dD7OYzoqhXFVf0+HxteeY77pvLR8ftqJo
3LynpDjiKklQJIrWkdExtEE6Wriyszv2DVHtkFoEoIydHFIfjLCKWtAD2d5G0EEE
JO8M4M0yGKrJ6DRovgxqIjDdppAnADv1XiEaljAAMv5Po40qtAG0x/Z8wTHMgmuT
JJmabsFN/VREx6GkxZCR
=T2Vn
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
