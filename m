Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab3JMWTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 18:19:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3JMWS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 18:18:58 -0400
Date: Sun, 13 Oct 2013 15:19:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.100
Message-ID: <20131013221954.GA7608@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

------------------------------
NOTE!  The 3.0.x kernel series will be moving to End-Of-Life soon,
within a week.  Please move anything that is relying on this kernel
version to the other longterm kernel releases (3.4.x or 3.10.x) as soon
as possible.  If anyone has any questions about this, please let me
know.
------------------------------

I'm announcing the release of the 3.0.100 kernel.

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

 Makefile                                 |    2=20
 arch/powerpc/kernel/iommu.c              |    2=20
 arch/powerpc/kernel/vio.c                |   12 +++--
 arch/powerpc/lib/checksum_64.S           |    4 -
 arch/sparc/kernel/entry.S                |    2=20
 arch/sparc/kernel/ktlb.S                 |    3 -
 arch/sparc/kernel/syscalls.S             |    8 +--
 arch/sparc/kernel/trampoline_64.S        |    2=20
 arch/sparc/lib/ksyms.c                   |    9 ---
 arch/tile/include/asm/percpu.h           |   34 +++++++++++++-
 drivers/acpi/acpi_ipmi.c                 |   24 ++++++----
 drivers/block/cciss.c                    |    1=20
 drivers/block/cpqarray.c                 |    1=20
 drivers/net/bonding/bond_main.c          |   13 ++++-
 drivers/net/ll_temac_main.c              |    6 ++
 drivers/net/pptp.c                       |    2=20
 drivers/net/tg3.c                        |    7 ++-
 drivers/net/usb/dm9601.c                 |    2=20
 drivers/net/via-rhine.c                  |    9 +++
 drivers/net/wireless/p54/p54usb.c        |    1=20
 drivers/net/wireless/rtlwifi/wifi.h      |    2=20
 drivers/pci/intel-iommu.c                |   72 +++++++++++++++-----------=
-----
 drivers/scsi/esp_scsi.c                  |   14 +++---
 drivers/scsi/esp_scsi.h                  |    1=20
 drivers/staging/comedi/drivers/ni_65xx.c |   26 ++++-------
 drivers/staging/hv/tools/hv_kvp_daemon.c |   10 +++-
 drivers/usb/serial/option.c              |    3 +
 fs/btrfs/relocation.c                    |   14 +++---
 fs/ext4/namei.c                          |    3 -
 include/net/ip.h                         |   12 +++--
 include/net/ipip.h                       |    2=20
 net/bridge/br_private.h                  |    1=20
 net/bridge/br_stp.c                      |   23 ++++++---
 net/bridge/br_stp_if.c                   |   12 ++++-
 net/caif/cfctrl.c                        |    3 -
 net/core/netpoll.c                       |    9 +--
 net/ipv4/igmp.c                          |    8 +--
 net/ipv4/inetpeer.c                      |    4 -
 net/ipv4/ip_output.c                     |    6 +-
 net/ipv4/ipmr.c                          |    2=20
 net/ipv4/raw.c                           |    2=20
 net/ipv4/xfrm4_mode_tunnel.c             |    2=20
 net/ipv6/ip6_output.c                    |   53 +++++++++-------------
 net/ipv6/mcast.c                         |    4 -
 net/netfilter/ipvs/ip_vs_xmit.c          |    2=20
 net/sctp/ipv6.c                          |   42 +++++-------------
 sound/soc/codecs/88pm860x-codec.c        |    3 +
 sound/soc/codecs/max98095.c              |    4 -
 48 files changed, 267 insertions(+), 216 deletions(-)

Alex Williamson (1):
      intel-iommu: Fix leaks in pagetable freeing

Ansis Atteka (1):
      ip: generate unique IP identificator if local fragmentation is allowed

Chris Healy (1):
      resubmit bridge: fix message_age_timer calculation

Chris Metcalf (1):
      tile: use a more conservative __my_cpu_offset in CONFIG_PREEMPT

Christian Lamparter (1):
      p54usb: add USB ID for Corega WLUSB2GTST USB adapter

Dan Carpenter (4):
      cpqarray: fix info leak in ida_locked_ioctl()
      cciss: fix info leak in cciss_ioctl32_passthru()
      ASoC: max98095: a couple array underflows
      ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()

Daniel Borkmann (1):
      net: sctp: fix ipv6 ipsec encryption bug in sctp_v6_xmit

Dave Jones (1):
      caif: Add missing braces to multiline if in cfctrl_linkup_request

David S. Miller (2):
      esp_scsi: Fix tag state corruption when autosensing.
      sparc64: Fix off by one in trampoline TLB mapping installation loop.

Greg Kroah-Hartman (1):
      Linux 3.0.100

Hannes Frederic Sowa (1):
      ipv6: udp packets following an UFO enqueued packet need also be handl=
ed by UFO

Herbert Xu (1):
      bridge: Clamp forward_delay when enabling STP

Ian Abbott (1):
      staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice

Josef Bacik (1):
      Btrfs: change how we queue blocks for backref checking

Kees Cook (1):
      tg3: fix length overflow in VPD firmware parsing

Kirill Tkhai (4):
      sparc64: Fix ITLB handler of null page
      sparc64: Remove RWSEM export leftovers
      sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall
      sparc32: Fix exit flag passed from traced sys_sigreturn

Larry Finger (1):
      rtlwifi: Align private space in rtl_priv struct

Lv Zheng (1):
      ACPI / IPMI: Fix atomic context requirement of ipmi_msg_handler()

Michal Mal=FD (1):
      USB: serial: option: Ignore card reader interface on Huawei E1750

Neil Horman (1):
      bonding: Fix broken promiscuity reference counting issue

Nikolay Aleksandrov (1):
      netpoll: fix NULL pointer dereference in netpoll_cleanup

Nishanth Aravamudan (1):
      powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_tab=
le()

Olaf Hering (1):
      Tools: hv: verify origin of netlink connector message

Paul E. McKenney (1):
      powerpc: Fix parameter clobber in csum_partial_copy_generic()

Peter Korsgaard (1):
      dm9601: fix IFF_ALLMULTI handling

Prarit Bhargava (1):
      powerpc/vio: Fix modalias_show return values

Ricardo Ribalda (1):
      ll_temac: Reset dma descriptors indexes on ndo_open

Roger Luethi (1):
      via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)

Salam Noureddine (2):
      ipv6 mcast: use in6_dev_put in timer handlers instead of __in6_dev_put
      ipv4 igmp: use in_dev_put in timer handlers instead of __in_dev_put

Theodore Ts'o (1):
      ext4: avoid hang when mounting non-journal filesystems with orphan li=
st


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSWxyKAAoJEDjbvchgkmk+7+EQAKR1Bb2urVkJCFG17aUqSDt2
M1rO6uN7nx44nd1viPCvSIN9EDWp4EqcHEzI5De66DocYJthq206+t2QwRHm7832
2nso/igsf0q5qdct4lw5XAL/4tr0Y/Do4Gj0pCx4QTH23PAjmU/Qm63LSA+gAnZg
jQjtR+JEniJv2VT3m7e2hhJfV386Y9++ZoZna/fdi5rSsu1uMMgTtcyVhhWtr/Nh
CEJHjwEXjYTmKvrZazfJw2p0i34BRRWke9bnYfvESjGXUyXMmS/KelH7iMAZOpaV
Rfw8Qp0EHiQujlmcC2C2Ek1y+9gcnbvNkJC75YHXBcGHJ4afUE52KePQNpc33y+B
W6G/nz6n/Vo2IUKruq8uk7fd0DZW+pdhtO1CFvE3Uriny2FdHtYMTW38U8pBwY8l
B3TgVlKPwDeOhqGM7PLJm5lbxHLZq0PwE84xJWn7DdpNHdP16YFjq5i2oZnSTwLJ
MiRaMO/iSWX5MsuTs2szaRg+JUInavHDsROyyvrr4ttsEu2ZisQQ/7Qn8fr5fDxb
YQejg00zm5TgHbuoaH0WJfeWB1SY7CJkGRsGTmIaxSarHByWbKqHXwDR33+LRAt6
6V/0uXGOQg9xCmG/GpRmkQDXTPOCUHpcE5cJVD8mzKraziuelu56jQ0bRj2dtMHm
1L64UT0Btc0QDRNGXdjn
=LXtP
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
