Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963AbaHNECe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 00:02:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaHNECd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 00:02:33 -0400
Date: Thu, 14 Aug 2014 12:01:50 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.103
Message-ID: <20140814040150.GA6957@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.103 kernel.

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

 Makefile                             |    2=20
 arch/sparc/include/asm/pgtable_64.h  |    6 +-
 arch/sparc/include/asm/tlbflush_64.h |   12 ----
 arch/sparc/kernel/ldc.c              |    2=20
 arch/sparc/kernel/smp_64.c           |    6 +-
 arch/sparc/kernel/sys32.S            |    2=20
 arch/sparc/kernel/unaligned_64.c     |   12 +++-
 arch/sparc/lib/NG2memcpy.S           |    1=20
 arch/sparc/math-emu/math_32.c        |    2=20
 arch/sparc/mm/fault_64.c             |  102 ++++++++++++++++++------------=
-----
 arch/sparc/mm/init_64.c              |   27 +++++++++
 arch/sparc/mm/tsb.c                  |   14 ++++
 drivers/net/macvlan.c                |    1=20
 drivers/net/ppp/pptp.c               |    2=20
 drivers/sbus/char/bbc_envctrl.c      |    6 ++
 drivers/sbus/char/bbc_i2c.c          |   11 ++-
 drivers/tty/serial/sunsab.c          |    9 +++
 include/net/inetpeer.h               |   14 ----
 include/net/ip.h                     |   31 ++++------
 include/net/ipip.h                   |    2=20
 include/net/ipv6.h                   |    9 ++-
 include/net/secure_seq.h             |    2=20
 net/compat.c                         |    9 +--
 net/core/iovec.c                     |   10 ++-
 net/core/secure_seq.c                |   23 -------
 net/core/skbuff.c                    |    2=20
 net/ipv4/igmp.c                      |    4 -
 net/ipv4/inetpeer.c                  |   18 ------
 net/ipv4/ip_output.c                 |    7 +-
 net/ipv4/ipmr.c                      |    2=20
 net/ipv4/raw.c                       |    2=20
 net/ipv4/route.c                     |   78 +++++++++++++++-----------
 net/ipv4/tcp_vegas.c                 |    3 -
 net/ipv4/tcp_veno.c                  |    2=20
 net/ipv4/xfrm4_mode_tunnel.c         |    2=20
 net/ipv6/ip6_output.c                |   25 +++-----
 net/netfilter/ipvs/ip_vs_xmit.c      |    2=20
 net/sctp/associola.c                 |    1=20
 net/sctp/output.c                    |    2=20
 39 files changed, 250 insertions(+), 217 deletions(-)

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

Eric Dumazet (3):
      inetpeer: get rid of ip_id_count
      ip: make IP identifiers less predictable
      sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Greg Kroah-Hartman (1):
      Linux 3.4.103

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


--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT7DSuAAoJEDjbvchgkmk+CJ0P/1XoL/8Oly4GsW2auuATsHNP
b4/hF88hBWfRGSciavWcTvJQEsX44XeWap344KjPqOdQTFAGlXjvRb6lNxI2gqaM
lmho3tGa9FXnKJQxowhkRXNlvXiuNVO6/+rGTLx5W91QqI50MNQZbIdXfedcBTdd
IjDAsdL2wNwJwtUluLFkmtKfiF1Dyn2ubdxfEkKVB5iN7YU/0ykmASsAXR6QsxgB
n3xD8gXuVzWSvXibHBvbxqgcf46LpjyrxcKCpdDc1HKrrxE12AlMkzom25+bCkCh
MP/jULfkaPkNacGJBA2zS/y4uiytY3bECeZWKBp3VisblTFHcKt/uugcYWb2IN8F
djSe8nceCfcTZASpzvwl+zGcCHqm00nEBGzCBg5ZdJ3I97kjiu0zAPmO6ZFnQenk
bg4zjWIS82A8rCoW+5b3NrKAGyukedB2WXYOreIzppQLq18fM6QitaM+W0s5agoW
LlG7CuftgW0ugwkpvTN0/y/Pe7Cu/7Q7yMV/FT7xyqiY5bXR9LMvp70l1sb6jsYJ
/LMREgjxc0K4PUubu3OPjeHW6CSWSnC0IrQcs4/AfOckhr43fi9ysBwPcW/D0aOK
YIO5s48n1anzW6Cc5/So/6qp7DYaTro8VcwbHBlcVtaSZ+wj8ygomcW3OWXlnF/6
04EzflBQWMkB5K65lBGe
=0G5W
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
