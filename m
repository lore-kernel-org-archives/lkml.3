Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3CTUNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:13:13 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39473 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3CTUNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:13:10 -0400
Date: Wed, 20 Mar 2013 13:14:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.70
Message-ID: <20130320201434.GA18160@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.70 kernel.

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

 Makefile                                  |    2=20
 arch/powerpc/kernel/cputable.c            |    2=20
 arch/s390/include/asm/tlbflush.h          |    2=20
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   10=20
 arch/x86/power/cpu.c                      |    2=20
 drivers/block/loop.c                      |    2=20
 drivers/char/hw_random/virtio-rng.c       |   13 +
 drivers/gpu/drm/i915/i915_gem.c           |    5=20
 drivers/hwmon/lineage-pem.c               |    2=20
 drivers/hwmon/sht15.c                     |    2=20
 drivers/md/md.c                           |    4=20
 drivers/net/tun.c                         |    2=20
 drivers/staging/vt6656/main_usb.c         |    4=20
 drivers/tty/pty.c                         |    1=20
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
 drivers/w1/w1.c                           |    3=20
 fs/block_dev.c                            |    4=20
 fs/btrfs/volumes.c                        |    6=20
 fs/ext3/super.c                           |    4=20
 include/linux/perf_event.h                |    6=20
 kernel/signal.c                           |    3=20
 net/core/dev.c                            |    1=20
 net/core/rtnetlink.c                      |    1=20
 net/dcb/dcbnl.c                           |    7=20
 net/ipv4/tcp_input.c                      |    6=20
 net/ipv6/ip6_input.c                      |    3=20
 net/ipv6/route.c                          |    3=20
 net/l2tp/l2tp_ppp.c                       |    1=20
 net/netlabel/netlabel_unlabeled.c         |   27 +-
 net/rds/message.c                         |    3=20
 security/selinux/xfrm.c                   |    2=20
 sound/core/seq/seq_timer.c                |    8=20
 tools/perf/util/trace-event-parse.c       |    2=20
 41 files changed, 488 insertions(+), 133 deletions(-)

Alan Stern (1):
      USB: EHCI: don't check DMA values in QH overlays

Amit Shah (1):
      virtio: rng: disallow multiple device registrations, fixes crashes

Axel Lin (1):
      hwmon: (lineage-pem) Add missing terminating entry for pem_[input|fan=
]_attributes

Ben Hutchings (1):
      hwmon: (sht15) Fix memory leak if regulator_enable() fails

Benjamin Herrenschmidt (1):
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

Greg Kroah-Hartman (2):
      Revert duplicated perf commit.
      Linux 3.0.70

Guillaume Nault (1):
      l2tp: Restore socket refcount when sendmsg succeeds

Guo Chao (2):
      block: use i_size_write() in bd_set_size()
      loopdev: fix a deadlock

Hannes Frederic Sowa (1):
      ipv6: stop multicast forwarding to process interface scoped addresses

Heiko Carstens (1):
      s390/mm: fix flush_tlb_kernel_range()

Jiri Slaby (1):
      TTY: do not reset master's packet mode

Kees Cook (1):
      signal: always clear sa_restorer on execve

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

Sebastian Riemer (1):
      md: protect against crash upon fsync on ro array

Stephane Eranian (1):
      perf,x86: fix kernel crash with PEBS/BTS after suspend/resume

Steve Conklin (1):
      usb: serial: Add Rigblaster Advantage to device table

Takashi Iwai (1):
      ALSA: seq: Fix missing error handling in snd_seq_timer_open()


--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRShiqAAoJEDjbvchgkmk+6xwP/1CG/BWpUAhcF/eCmh6RSh5P
tZwXrd/KLkolhF6T5OJOvcYoZZJo1u0OE0nAFOHdFAPxGq2pNtev5/2EITe9X2h9
39XWuiZJVKeTzil0FwiGMRw4eA5lLFBn7W2UTpIvUm4sri7sZulzLbVGpJzb0FbL
4xLa2nUUBpBu/4Q9HLC5Hrpg73hbp/KeB+7nONVFYYZleXPu3d7QozDcNmgrSEHg
Eo4qgEcz3QRz1x3mbPQgoBwU03o9cyOPeLFD3ClcdBvMr3zQtca43T76LKSStnfn
rYORAbsTVFheTQJfbQl4xFjTATpA7FvMmNSqKHSvTxpNzV2PE2D5fXgKFDoNQDje
/hEvXl97u7FpPg03oleau9ly5lGoC9iXhzeJu4si8GA7ZIZHvJ5hiQUkGQG3aYMR
vYd39tSzH5fhNth2ddHddx9Hj95P53KWIP5ARMIJTUB+STjpGN+GYNjbpu1M3lNS
qnB0hHcrKBfc1yoGERksT/t8X6kfWkmPanPZAM87YFbZzxdULwFVhW+RxS/WiAFn
9uRk0HBJfBDhbNdOCK0ErJ9JeqVnA440soJv5NWnb3XkaNDBqmA4ejF9OqF8BevC
7C38VYgJt8UYNmV52W8gSmmxubStwlH1xCFwGpFJSMyNVN8VA2a7B20Dd/WgXK2w
EYNCSJ1Q+VBi742C0pw/
=S8vV
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
