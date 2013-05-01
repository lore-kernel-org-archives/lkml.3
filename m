Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3EARFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:05:52 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:54628 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3EARFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:05:45 -0400
Date: Wed, 1 May 2013 10:05:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.76
Message-ID: <20130501170542.GA3343@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.76 kernel.

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

 Makefile                             |    2=20
 arch/sparc/Kconfig                   |    1=20
 arch/sparc/include/asm/atomic_32.h   |    2=20
 arch/sparc/include/asm/pgtable_64.h  |    1=20
 arch/sparc/include/asm/system_64.h   |    3=20
 arch/sparc/include/asm/tlbflush_64.h |   37 +++++++++-
 arch/sparc/kernel/smp_64.c           |   41 ++++++++++--
 arch/sparc/mm/tlb.c                  |   39 ++++++++++-
 arch/sparc/mm/tsb.c                  |   57 ++++++++++++----
 arch/sparc/mm/ultra.S                |  119 +++++++++++++++++++++++++++---=
-----
 drivers/net/atl1e/atl1e.h            |    2=20
 drivers/net/atl1e/atl1e_main.c       |    1=20
 drivers/net/bonding/bond_main.c      |    1=20
 drivers/tty/tty_io.c                 |   14 +++-
 include/linux/netdevice.h            |    2=20
 include/linux/skbuff.h               |    8 ++
 include/linux/socket.h               |    3=20
 include/net/scm.h                    |    2=20
 net/atm/common.c                     |    2=20
 net/ax25/af_ax25.c                   |    1=20
 net/bluetooth/af_bluetooth.c         |    4 -
 net/bluetooth/rfcomm/sock.c          |    1=20
 net/caif/caif_socket.c               |    2=20
 net/core/dev.c                       |    1=20
 net/core/dev_addr_lists.c            |    6 -
 net/core/rtnetlink.c                 |    4 -
 net/core/sock.c                      |   14 ++--
 net/ipv4/esp4.c                      |    6 -
 net/ipv4/ip_fragment.c               |   15 +++-
 net/ipv4/syncookies.c                |    4 -
 net/ipv4/tcp_input.c                 |   65 +++++++++----------
 net/ipv6/addrconf.c                  |   27 +++++++
 net/ipv6/reassembly.c                |   13 +++
 net/irda/af_irda.c                   |    2=20
 net/iucv/af_iucv.c                   |    2=20
 net/llc/af_llc.c                     |    2=20
 net/netrom/af_netrom.c               |    1=20
 net/rose/af_rose.c                   |    1=20
 net/sched/sch_cbq.c                  |    5 +
 net/sctp/auth.c                      |    2=20
 net/tipc/socket.c                    |    7 ++
 net/unix/af_unix.c                   |    2=20
 42 files changed, 404 insertions(+), 120 deletions(-)

Balakumaran Kannan (1):
      net IPv6 : Fix broken IPv6 routing table after loopback down-up

Daniel Borkmann (1):
      net: sctp: sctp_auth_key_put: use kzfree instead of kfree

David S. Miller (1):
      sparc64: Fix race in TLB batch processing.

Dmitry Popov (1):
      tcp: incoming connections might use wrong route under synflood

Eric Dumazet (2):
      tcp: call tcp_replace_ts_recent() from tcp_ack()
      net: drop dst before queueing fragments

Eric W. Biederman (1):
      af_unix: If we don't care about credentials coallesce all messages

Greg Kroah-Hartman (1):
      Linux 3.0.76

Hannes Frederic Sowa (1):
      atl1e: limit gso segment size to prevent generation of wrong ip lengt=
h fields

Jiri Slaby (2):
      TTY: do not update atime/mtime on read/write
      TTY: fix atime/mtime regression

Linus Torvalds (1):
      net: fix incorrect credentials passing

Mathias Krause (11):
      atm: update msg_namelen in vcc_recvmsg()
      ax25: fix info leak via msg_name in ax25_recvmsg()
      Bluetooth: fix possible info leak in bt_sock_recvmsg()
      Bluetooth: RFCOMM - Fix missing msg_namelen update in rfcomm_sock_rec=
vmsg()
      caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()
      irda: Fix missing msg_namelen update in irda_recvmsg_dgram()
      iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()
      llc: Fix missing msg_namelen update in llc_ui_recvmsg()
      netrom: fix info leak via msg_name in nr_recvmsg()
      rose: fix info leak via msg_name in rose_recvmsg()
      tipc: fix info leaks via msg_name in recv_msg/recv_stream

Michael Riesch (1):
      rtnetlink: Call nlmsg_parse() with correct header length

Patrick McHardy (1):
      netfilter: don't reset nf_trace in nf_reset()

Sam Ravnborg (1):
      sparc32: support atomic64_t

Vasily Averin (1):
      cbq: incorrect processing of high limits

Vlad Yasevich (1):
      net: count hw_addr syncs so that unsync works properly.

Wei Yongjun (2):
      esp4: fix error return code in esp_output()
      netrom: fix invalid use of sizeof in nr_recvmsg()

nikolay@redhat.com (1):
      bonding: IFF_BONDING is not stripped on enslave failure


--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgUtmAAoJEDjbvchgkmk+E9MP/3oBnhYEHnGCvhO5J3ukZFzV
oeO98TpSbMTZfxgmNlqGdT26g3RbK4bLF4bcstMcDp85lV4ndZ6AqVtB87L8K2Ul
MXrN7YUDqogdD+YwNFPQhhV76zXMZ1VZnFbs/Arvk3lTbmx9mfs4zdYZ+l6QLRWn
haE7OdngeWWSYAW1wqho3Bn+O6HLlwPVSYRExHbSagjCNHgppA4QvzvbIAOMYLSV
4+YYAgm1OsybVVs8S63/0R8CwiqFYBww8nCsZJdXZYtrOrrnExY1oBWCsIH+HQss
Jas2+Rw2PDZbP0GPzJD4dTYxd3xnNqO/gcCvfCd2DtD+MqWCt0enZsGfUyD0x4kI
J1hJSckpikleJDYcq1O1GX4mxattX507oaOlLm8wXpjzdZ8UPtdpmmMhPocQk/ud
FP+LXkqbJwhqnR0JVFMxiaO9ZrT/3V9xAxET7e05LQXseRNiPvC7VTy0bnxrCl6w
7QGs6QZjyyip4OX6qOlgU+nRChTuqw14q1ZAIxiD6N5z/KwIhciTPs2XjgGxirxT
SZnn4sIpHWH5Uuuw9+mCJuRzdsCD1n2rah1ODJjoSRWG2Z6x1Hv2SWKmAbOkisbL
ZhJyqOPr/ppBDUCQkmw74mgBC13ELkuedSR0RNnF9OIS/Jx2LcHTJsq8Ka8EvedD
UgojybWY85myGfW7DVHa
=mvXS
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
