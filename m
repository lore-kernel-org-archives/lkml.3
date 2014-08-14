Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaHNEFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 00:05:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaHNEFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 00:05:13 -0400
Date: Thu, 14 Aug 2014 12:04:31 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.15.10
Message-ID: <20140814040431.GA7220@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.15.10 kernel.

Note, this is the LAST 3.15.y kernel release, it is now end-of-life,
please move to 3.16.y now.

All users of the 3.15 kernel series must upgrade.

The updated 3.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.15.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/sparc/include/asm/tlbflush_64.h            |   12 ----
 arch/sparc/include/uapi/asm/unistd.h            |    3 -
 arch/sparc/kernel/ldc.c                         |    2=20
 arch/sparc/kernel/sys32.S                       |    1=20
 arch/sparc/kernel/systbls_32.S                  |    1=20
 arch/sparc/kernel/systbls_64.S                  |    2=20
 arch/sparc/math-emu/math_32.c                   |    2=20
 arch/sparc/mm/init_64.c                         |   31 +++++++++++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h     |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    9 +++
 drivers/net/ethernet/broadcom/genet/bcmgenet.c  |    5 +
 drivers/net/ethernet/brocade/bna/bnad.c         |    2=20
 drivers/net/macvlan.c                           |    1=20
 drivers/net/phy/phy_device.c                    |    2=20
 drivers/net/ppp/pptp.c                          |    2=20
 drivers/sbus/char/bbc_envctrl.c                 |    6 ++
 drivers/sbus/char/bbc_i2c.c                     |   11 +++-
 drivers/tty/serial/sunsab.c                     |    9 +++
 fs/xfs/xfs_log.h                                |   19 ++++---
 fs/xfs/xfs_log_cil.c                            |    7 +-
 include/net/inetpeer.h                          |   16 +-----
 include/net/ip.h                                |   31 +++++------
 include/net/ip_tunnels.h                        |    1=20
 include/net/ipv6.h                              |    2=20
 include/net/secure_seq.h                        |    2=20
 net/batman-adv/fragmentation.c                  |   10 ++-
 net/compat.c                                    |    9 +--
 net/core/iovec.c                                |   10 ++-
 net/core/secure_seq.c                           |   25 ---------
 net/core/skbuff.c                               |    2=20
 net/ipv4/igmp.c                                 |    4 -
 net/ipv4/inetpeer.c                             |   18 ------
 net/ipv4/ip_output.c                            |    7 +-
 net/ipv4/ip_tunnel.c                            |   29 ++++++-----
 net/ipv4/ip_tunnel_core.c                       |    2=20
 net/ipv4/ipmr.c                                 |    2=20
 net/ipv4/raw.c                                  |    2=20
 net/ipv4/route.c                                |   63 ++++++++++++++-----=
-----
 net/ipv4/tcp_vegas.c                            |    3 -
 net/ipv4/tcp_veno.c                             |    2=20
 net/ipv4/xfrm4_mode_tunnel.c                    |    2=20
 net/ipv6/ip6_output.c                           |   14 +++++
 net/ipv6/output_core.c                          |   25 ---------
 net/netfilter/ipvs/ip_vs_xmit.c                 |    2=20
 net/sctp/associola.c                            |    1=20
 net/sctp/output.c                               |    2=20
 net/xfrm/xfrm_policy.c                          |    2=20
 net/xfrm/xfrm_user.c                            |    7 +-
 49 files changed, 229 insertions(+), 196 deletions(-)

Andrey Ryabinin (1):
      net: sendmsg: fix NULL pointer dereference

Andrey Utkin (1):
      arch/sparc/math-emu/math_32.c: drop stray break operator

Christoph Paasch (2):
      tcp: Fix integer-overflows in TCP veno
      tcp: Fix integer-overflow in TCP vegas

Christopher Alexander Tobias Schulze (2):
      bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000
      sunsab: Fix detection of BREAK on sunsab serial console

Daniel Borkmann (1):
      net: sctp: inherit auth_capable on INIT collisions

Dave Chinner (1):
      xfs: log vector rounding leaks log space

David S. Miller (3):
      sparc: Hook up renameat2 syscall.
      sparc64: Do not insert non-valid PTEs into the TSB hash table.
      sparc64: Guard against flushing openfirmware mappings.

Dmitry Kravkov (1):
      bnx2x: fix crash during TSO tunneling

Dmitry Popov (1):
      ip_tunnel(ipv4): fix tunnels with "local any remote $remote_ip"

Eric Dumazet (3):
      inetpeer: get rid of ip_id_count
      ip: make IP identifiers less predictable
      sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Florian Fainelli (2):
      net: bcmgenet: correctly pad short packets
      net: phy: re-apply PHY fixups during phy_register_device

Greg Kroah-Hartman (1):
      Linux 3.15.10

Ivan Vecera (1):
      bna: fix performance regression

Sasha Levin (1):
      iovec: make sure the caller actually wants anything in memcpy_fromiov=
ecend

Sowmini Varadhan (1):
      sparc64: ldc_connect() should not return EINVAL when handshake is in =
progress.

Steffen Klassert (1):
      xfrm: Fix refcount imbalance in xfrm_lookup

Sven Eckelmann (1):
      batman-adv: Fix out-of-order fragmentation support

Tobias Brunner (1):
      xfrm: Fix installation of AH IPsec SAs

Vlad Yasevich (2):
      macvlan: Initialize vlan_features to turn on offload support.
      net: Correctly set segment mac_len in skb_segment().


--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT7DVPAAoJEDjbvchgkmk+wnEQAKv2ghUYAdFCcBuSNp+6ttA1
BGIfXCgLjEPBLbacjj5Ew8mWeqHbrqMcp0kCzba8FQg4q3Gr5Mp65659lniB7WKW
4VKQJxpujQwPH65K3QcfYQcs7xSiSTf53lWKRhnZdBkq66rkIKT7KshTui2JyLrw
hpl0Ml0A9TyUpoa7MVgAlU5EyfPEogoaoi3Uago9515FIoEZr3cJIXFrGw+FCHuW
D8EPRbge1VqywWyjE2CBlVouoql3G7Nj2LNX2j6L9R3QyZ6waTXwN5RaExfGJG5H
DnVluv63kMHNDUG/4ZFAeB7zjv3Rq/YarM2Ko2o/X63Yr0cfpvwviASkXUYuhWFu
z198wpU1246cOt/Z0pdbjGVMFYAPOrj+xrMsbeUOxrfmNVM4SRLHk7mF2j4KkZJu
4OoGbRPdd6m7mO8706aVF7ECwBHsQRBouWD4QA2/7TTNrUPpDMjDp2kl0fryeUeZ
1qrKIoepZlkP38zQtpXNLMyFRZ3UkYFo/sEcKfdKp4w15VXdjQZqGe3bs/M9oFbL
Q9hogOpzXAcEadDN9aWecPyqzraqVtdp1Vra7O8FplMkK0lcKJxBHZQJ/TQzvY73
6OWO7LZQ2Ase9/v6i+3nAWbVNz9RLtWXNcC4/6+J5Sa8GjdzoLtg8+u7bbC90jWO
r4BI4SPxcL5De08Tc0q/
=ubrt
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
