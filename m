Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3EARGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:06:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33877 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab3EARGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:06:16 -0400
Date: Wed, 1 May 2013 10:06:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.43
Message-ID: <20130501170614.GA7821@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.43 kernel.

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

 Makefile                                        |    2=20
 arch/sparc/include/asm/pgtable_64.h             |    1=20
 arch/sparc/include/asm/switch_to_64.h           |    3=20
 arch/sparc/include/asm/tlbflush_64.h            |   37 ++++++-
 arch/sparc/kernel/smp_64.c                      |   41 +++++++-
 arch/sparc/mm/tlb.c                             |   39 +++++++
 arch/sparc/mm/tsb.c                             |   57 ++++++++---
 arch/sparc/mm/ultra.S                           |  119 +++++++++++++++++++=
-----
 drivers/net/bonding/bond_main.c                 |   10 ++
 drivers/net/ethernet/atheros/atl1e/atl1e.h      |    2=20
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |    1=20
 drivers/tty/tty_io.c                            |   14 ++
 fs/aio.c                                        |    2=20
 include/linux/netdevice.h                       |    2=20
 include/linux/skbuff.h                          |    7 +
 include/linux/socket.h                          |    3=20
 include/net/scm.h                               |    2=20
 net/atm/common.c                                |    2=20
 net/ax25/af_ax25.c                              |    1=20
 net/bluetooth/af_bluetooth.c                    |    4=20
 net/bluetooth/rfcomm/sock.c                     |    1=20
 net/caif/caif_socket.c                          |    2=20
 net/core/dev.c                                  |    4=20
 net/core/dev_addr_lists.c                       |    6 -
 net/core/rtnetlink.c                            |    4=20
 net/core/sock.c                                 |   14 ++
 net/ipv4/esp4.c                                 |    6 -
 net/ipv4/ip_fragment.c                          |   15 ++-
 net/ipv4/syncookies.c                           |    4=20
 net/ipv4/tcp_input.c                            |   65 ++++++-------
 net/ipv4/tcp_output.c                           |    8 +
 net/ipv6/addrconf.c                             |   27 +++++
 net/ipv6/reassembly.c                           |   13 ++
 net/irda/af_irda.c                              |    2=20
 net/iucv/af_iucv.c                              |    2=20
 net/llc/af_llc.c                                |    2=20
 net/netrom/af_netrom.c                          |    1=20
 net/nfc/llcp/sock.c                             |    2=20
 net/rose/af_rose.c                              |    1=20
 net/sched/sch_cbq.c                             |    5 -
 net/sctp/auth.c                                 |    2=20
 net/tipc/socket.c                               |    7 +
 net/unix/af_unix.c                              |    2=20
 43 files changed, 421 insertions(+), 123 deletions(-)

Balakumaran Kannan (1):
      net IPv6 : Fix broken IPv6 routing table after loopback down-up

Ben Greear (1):
      net: rate-limit warn-bad-offload splats.

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
      Linux 3.4.43

Hannes Frederic Sowa (1):
      atl1e: limit gso segment size to prevent generation of wrong ip lengt=
h fields

Jiri Slaby (2):
      TTY: do not update atime/mtime on read/write
      TTY: fix atime/mtime regression

Linus Torvalds (1):
      net: fix incorrect credentials passing

Mathias Krause (12):
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
      NFC: llcp: fix info leaks via msg_name in llcp_sock_recvmsg()
      rose: fix info leak via msg_name in rose_recvmsg()
      tipc: fix info leaks via msg_name in recv_msg/recv_stream

Michael Riesch (1):
      rtnetlink: Call nlmsg_parse() with correct header length

Patrick McHardy (1):
      netfilter: don't reset nf_trace in nf_reset()

Thomas Graf (1):
      tcp: Reallocate headroom if it would overflow csum_start

Vasily Averin (1):
      cbq: incorrect processing of high limits

Vlad Yasevich (1):
      net: count hw_addr syncs so that unsync works properly.

Wei Yongjun (2):
      netrom: fix invalid use of sizeof in nr_recvmsg()
      esp4: fix error return code in esp_output()

Zhao Hongjiang (1):
      aio: fix possible invalid memory access when DEBUG is enabled

nikolay@redhat.com (2):
      bonding: fix bonding_masters race condition in bond unloading
      bonding: IFF_BONDING is not stripped on enslave failure


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgUuFAAoJEDjbvchgkmk+wsIP/2bLZYgRB8dL8GpOJcUJ2ihM
6nbTqvqdMb6QrdMmaWQCI48jxfJZWZQXCSls7L4qpgeM/JhHCqQLRFulc0XbRmj+
dp3EBG5ObVYGQySB7DyiCmRKiqe2StZSqsw2LieiLawjoVjzWO71MyirJCobk7fM
k6vlyK436xLeG/58m2QAQNFtVbLBwhVmbeQ2ZiFvVgShUJCBPa/9dYX+Lk5QYOUY
cd28hWrP6XuNlKMSFmwkWbOV443RfWQlPgKUm7JH/5IGg06KWQZnwbwS6cOtT/Ge
pUKMghJ/3/kqdwCm2CeVxWqJOutzn5xjkFseo/+ygzcXdqeDLDJ6F/z8lmR921eV
HJyWtCeZzvc8CWEEHs9N4XGtskmejp5qff0TE4F/5EVxl3Gn0x1fcg6ARTMPBTbt
zhW5+28n9kncs3mtzV0UkvMkKXNv9d71VDIlTvBMhyqZBAND/fLu4HJJYtYOD7EG
zUARmOAmnHWxmm3j7pGO5ggzkTXzapEMlQK9UGvj6+tORg56+VRDJbUcW6Wm9v25
cq2e/CaG1lavekK7R5x6wVaQcsy+qqJyJjVCCVns4d6bkjdPPCaIk5k4ngdJGwkU
qj4s+2hE+znHbg974qXfPjC94nM8/SRc/6VYMAoc/3g1TQNUNgLZBoi55huFJ/vW
Ewz8ZFurYWnQMoIhaKx5
=TZye
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
