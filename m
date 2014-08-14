Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaHNEDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 00:03:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaHNEDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 00:03:34 -0400
Date: Thu, 14 Aug 2014 12:02:52 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.53
Message-ID: <20140814040252.GA7072@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.53 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/sparc/include/asm/pgtable_64.h             |    6 -
 arch/sparc/include/asm/tlbflush_64.h            |   12 --
 arch/sparc/kernel/ldc.c                         |    2=20
 arch/sparc/kernel/smp_64.c                      |    6 -
 arch/sparc/kernel/sys32.S                       |    2=20
 arch/sparc/kernel/unaligned_64.c                |   12 ++
 arch/sparc/lib/NG2memcpy.S                      |    1=20
 arch/sparc/math-emu/math_32.c                   |    2=20
 arch/sparc/mm/fault_64.c                        |  102 ++++++++++++-------=
-----
 arch/sparc/mm/init_64.c                         |   27 ++++++
 arch/sparc/mm/tsb.c                             |   14 +++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h     |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    9 ++
 drivers/net/macvlan.c                           |    1=20
 drivers/net/ppp/pptp.c                          |    2=20
 drivers/net/vxlan.c                             |    2=20
 drivers/sbus/char/bbc_envctrl.c                 |    6 +
 drivers/sbus/char/bbc_i2c.c                     |   11 +-
 drivers/tty/serial/sunsab.c                     |    9 ++
 include/net/inetpeer.h                          |   16 ---
 include/net/ip.h                                |   31 +++----
 include/net/ipv6.h                              |   11 +-
 include/net/secure_seq.h                        |    2=20
 net/compat.c                                    |    9 +-
 net/core/iovec.c                                |   10 +-
 net/core/secure_seq.c                           |   25 -----
 net/core/skbuff.c                               |    2=20
 net/ipv4/igmp.c                                 |    4=20
 net/ipv4/inetpeer.c                             |   18 ----
 net/ipv4/ip_output.c                            |    7 -
 net/ipv4/ip_tunnel.c                            |    2=20
 net/ipv4/ipmr.c                                 |    2=20
 net/ipv4/raw.c                                  |    2=20
 net/ipv4/route.c                                |   69 ++++++++++------
 net/ipv4/tcp_vegas.c                            |    3=20
 net/ipv4/tcp_veno.c                             |    2=20
 net/ipv4/xfrm4_mode_tunnel.c                    |    2=20
 net/ipv6/ip6_output.c                           |   17 ++++
 net/ipv6/output_core.c                          |   23 -----
 net/ipv6/sit.c                                  |    2=20
 net/netfilter/ipvs/ip_vs_xmit.c                 |    2=20
 net/sctp/associola.c                            |    1=20
 net/sctp/output.c                               |    2=20
 44 files changed, 269 insertions(+), 224 deletions(-)

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

David S. Miller (8):
      sparc64: Fix argument sign extension for compat_sys_futex().
      sparc64: Handle 32-bit tasks properly in compute_effective_address().
      sparc64: Fix top-level fault handling bugs.
      sparc64: Don't bark so loudly about 32-bit tasks generating 64-bit fa=
ult addresses.
      sparc64: Fix huge TSB mapping on pre-UltraSPARC-III cpus.
      sparc64: Add membar to Niagara2 memcpy code.
      sparc64: Do not insert non-valid PTEs into the TSB hash table.
      sparc64: Guard against flushing openfirmware mappings.

Dmitry Kravkov (1):
      bnx2x: fix crash during TSO tunneling

Eric Dumazet (3):
      inetpeer: get rid of ip_id_count
      ip: make IP identifiers less predictable
      sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Greg Kroah-Hartman (1):
      Linux 3.10.53

Kirill Tkhai (1):
      sparc64: Make itc_sync_lock raw

Sasha Levin (1):
      iovec: make sure the caller actually wants anything in memcpy_fromiov=
ecend

Sowmini Varadhan (1):
      sparc64: ldc_connect() should not return EINVAL when handshake is in =
progress.

Vlad Yasevich (2):
      macvlan: Initialize vlan_features to turn on offload support.
      net: Correctly set segment mac_len in skb_segment().


--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT7DTsAAoJEDjbvchgkmk+BVYP/j0EVohIeZitwm9xf4YZMHXN
XYLI9MKj0ydajz7yza3zcaT5p0QXy+dbBQyzWVtdnnJrmbMt6WNTmUTQLMEaAidP
HARe94W2Sdk9mdIulNxULjPIXolccRi8QZ9OGzrSlngW4gP2UfvtpqfCD2z86wpJ
W64aLuIGiiH6MiYMRgz9VKKKvkss6dajpfS40q9/HgwyAW4XOOF8xoG6YqK8Vu25
rR2YZPab2UNxtK/jNbcBpD2GF9B7QqHXRHhZM7CJKVcuPiYEEaxk5QIyWlFd39lT
4GETurZndcZG3w0K+ZkTDf9kYrJ4CAiUx/y9xxGNnoKK4nx4SgGZXN8bLaYOiFmh
O5bJwFOx9dFdGCjdx9EVUp/uqAQ3okFZzeskuT3c2UK4ldBc6PADe2MUX6byJJmR
nNXN1h0g5zzBnRW2p/kCCaYMhwSogOt3JxMSkNPVujxbp0BMQ7x5hzTRb643JEOs
dhHm1oelHghS9BhaPxMlt+9JPFcE74sN4tRG/DTS+/Jb4ykprEB3V1bPJqAcS7Y1
br/ihn7prF/XZIXtC2ab5+p9AQ6YynmICZipzHUZozYB3+TWY4RHoGihcWhHSLAt
nnVtvgGWWgxIxQoWwG4sd82reXXBItT+h7LXBVK+rVrY22gwULshblzANYPv4vdo
v86jatcE5CyVH0CWksPE
=OzHP
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
