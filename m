Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaAOXmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:42:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaAOXl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:41:58 -0500
Date: Wed, 15 Jan 2014 15:42:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.77
Message-ID: <20140115234237.GB14618@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.77 kernel.

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

 Makefile                                          |    2=20
 arch/arm/kernel/traps.c                           |    8 +++
 arch/arm/mach-shmobile/board-mackerel.c           |    4 -
 arch/x86/include/asm/fpu-internal.h               |   13 +++--
 drivers/net/ethernet/broadcom/tg3.c               |    3 +
 drivers/net/ethernet/calxeda/xgmac.c              |    2=20
 drivers/net/ethernet/ibm/ehea/ehea_main.c         |    2=20
 drivers/net/ethernet/tehuti/tehuti.c              |    1=20
 drivers/net/ethernet/xilinx/ll_temac_main.c       |    2=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    2=20
 drivers/net/hamradio/hdlcdrv.c                    |    2=20
 drivers/net/hamradio/yam.c                        |    1=20
 drivers/net/hyperv/netvsc_drv.c                   |    1=20
 drivers/net/macvtap.c                             |   20 +++------
 drivers/net/tun.c                                 |    2=20
 include/linux/net.h                               |    2=20
 include/linux/netdevice.h                         |    9 ++++
 kernel/sched/core.c                               |    9 +++-
 kernel/sched/fair.c                               |   48 +++++++++++++++--=
-----
 kernel/sched/sched.h                              |    3 -
 net/8021q/vlan_dev.c                              |   19 ++++++++
 net/bridge/br_multicast.c                         |    4 -
 net/core/drop_monitor.c                           |    1=20
 net/core/sock.c                                   |    2=20
 net/ipv4/inet_diag.c                              |   16 +++++++
 net/ipv6/route.c                                  |    8 ---
 net/llc/af_llc.c                                  |    5 +-
 net/rds/ib.c                                      |    3 -
 net/rds/ib_send.c                                 |    5 --
 net/rose/af_rose.c                                |   16 +------
 net/unix/af_unix.c                                |   16 +++++--
 31 files changed, 152 insertions(+), 79 deletions(-)

Ben Segall (3):
      sched: Fix race on toggling cfs_bandwidth_used
      sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining
      sched: Fix hrtimer_cancel()/rq->lock deadlock

Changli Gao (1):
      net: drop_monitor: fix the value of maxattr

Curt Brune (1):
      bridge: use spin_lock_bh() in br_multicast_set_hash_max

Daniel Borkmann (2):
      net: inet_diag: zero out uninitialized idiag_{src,dst} fields
      net: llc: fix use after free in llc_ui_recvmsg

David S. Miller (1):
      vlan: Fix header ops passthru when doing TX VLAN offload.

Eric Dumazet (1):
      net: do not pretend FRAGLIST support

Florian Westphal (1):
      net: rose: restore old recvmsg behavior

Greg Kroah-Hartman (1):
      Linux 3.4.77

Hannes Frederic Sowa (1):
      ipv6: don't count addrconf generated routes against gc limit

Jason Wang (2):
      macvtap: signal truncated packets
      netvsc: don't flush peers notifying work during setting mtu

Laurent Pinchart (1):
      ARM: shmobile: mackerel: Fix coherent DMA mask

Linus Torvalds (1):
      x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Nat Gurumoorthy (1):
      tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0

Paul Turner (1):
      sched: Guarantee new group-entities always have weight

Russell King (1):
      ARM: fix "bad mode in ... handler" message for undefined instructions

Salva Peir=F3 (1):
      hamradio/yam: fix info leak in ioctl

Sasha Levin (3):
      net: unix: allow set_peek_off to fail
      net: unix: allow bind to fail on mutex lock
      rds: prevent dereference of a NULL device

Venkat Venkatsubra (1):
      rds: prevent BUG_ON triggered on congestion update to loopback

Vlad Yasevich (1):
      macvtap: Do not double-count received packets

Wenliang Fan (1):
      drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()

Zhi Yong Wu (2):
      macvtap: update file current position
      tun: update file current position


--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1xztAAoJEDjbvchgkmk+E1EQALvToN1rvFPoqqtMk/QGY6hY
MZxoDXKyJYVDiiuFKrsAO0PNTJO09yeHIODiQ1rPENXCWN0UL9/rSc8ih1eceCwC
gimF6sGIgX3U3SNgimE67xksQZCp0JL6C25YPMs5zJc+B+KUvuMpzRB2cyE7c/jI
WgfAnUKyPbSoyvLjo5kve5roS3x1XrNTJo4esHTGoOgI4tFuPmLuqs262RF1hiBu
yd8lqOWWRc/sDBTZ3sgSlwDeHZTaw710nSnrpP/3TRv0fOrJcRUMISLotZMF/yO2
4qTZxLgPpCp7GCV6/WjwdrzFSzOhRfA8LfJcYi4uUNnv+6uOaK8fPSA8/+1NDkPs
Bx34h3WhBNilfet5aCnxXxfeJ91d4sfn5+7Siju4iVg7dGE7Bf9gflRQyzsVvypF
lXpiTF/cMBdC2eFOCRdrGyjm/mSLWSL7K+o/JFm9e9Gta9hxLVamcUw5q/PnAlpY
RYJr6IvRPb5Mb46LYawGoOuST+N4gVI4NZZrRt6yqVuiWKGV9df4iFWFVq946gFF
V6bdD8P6Z2I6YWlEmwh5Ido3jd4Vj0zxKMrESEmgiOn3PykoqY/gMKMSXWEDBsJC
j3j1bySdD7iUhyX4svcFX+0Hqh+RXGI4sPNaueumKgsB16Fnj54VQv/rUyvHWlf0
utf8TZNzSJGgGgr+/lWs
=CvcP
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
