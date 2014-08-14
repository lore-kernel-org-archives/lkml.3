Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaHNEEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 00:04:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaHNEEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 00:04:10 -0400
Date: Thu, 14 Aug 2014 12:03:27 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.17
Message-ID: <20140814040327.GA7150@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.17 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/sparc/include/asm/pgtable_64.h             |   89 ++++++++++++-------=
--
 arch/sparc/include/asm/tlbflush_64.h            |   12 --
 arch/sparc/include/asm/tsb.h                    |    3=20
 arch/sparc/kernel/head_64.S                     |    4=20
 arch/sparc/kernel/ktlb.S                        |    2=20
 arch/sparc/kernel/ldc.c                         |    2=20
 arch/sparc/kernel/smp_64.c                      |    6 -
 arch/sparc/kernel/sys32.S                       |    2=20
 arch/sparc/kernel/unaligned_64.c                |   12 ++
 arch/sparc/lib/NG2memcpy.S                      |    1=20
 arch/sparc/math-emu/math_32.c                   |    2=20
 arch/sparc/mm/fault_64.c                        |   98 ++++++++++++-------=
-----
 arch/sparc/mm/gup.c                             |    2=20
 arch/sparc/mm/init_64.c                         |   43 +++++++++-
 arch/sparc/mm/tlb.c                             |   26 ++++--
 arch/sparc/mm/tsb.c                             |   14 +++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h     |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    9 ++
 drivers/net/ethernet/brocade/bna/bnad.c         |    2=20
 drivers/net/macvlan.c                           |    1=20
 drivers/net/phy/phy_device.c                    |    2=20
 drivers/net/ppp/pptp.c                          |    2=20
 drivers/sbus/char/bbc_envctrl.c                 |    6 +
 drivers/sbus/char/bbc_i2c.c                     |   11 +-
 drivers/tty/serial/sunsab.c                     |    9 ++
 fs/xfs/xfs_log.h                                |   19 +++-
 fs/xfs/xfs_log_cil.c                            |    7 -
 include/net/inetpeer.h                          |   16 ---
 include/net/ip.h                                |   31 +++----
 include/net/ip_tunnels.h                        |    1=20
 include/net/ipv6.h                              |    2=20
 include/net/secure_seq.h                        |    2=20
 net/batman-adv/fragmentation.c                  |   10 +-
 net/compat.c                                    |    9 +-
 net/core/iovec.c                                |   10 +-
 net/core/secure_seq.c                           |   25 ------
 net/core/skbuff.c                               |    2=20
 net/ipv4/igmp.c                                 |    4=20
 net/ipv4/inetpeer.c                             |   18 ----
 net/ipv4/ip_output.c                            |    7 -
 net/ipv4/ip_tunnel.c                            |   29 ++++---
 net/ipv4/ip_tunnel_core.c                       |    2=20
 net/ipv4/ipmr.c                                 |    2=20
 net/ipv4/raw.c                                  |    2=20
 net/ipv4/route.c                                |   63 +++++++++------
 net/ipv4/tcp_vegas.c                            |    3=20
 net/ipv4/tcp_veno.c                             |    2=20
 net/ipv4/xfrm4_mode_tunnel.c                    |    2=20
 net/ipv6/ip6_output.c                           |   14 +++
 net/ipv6/output_core.c                          |   23 -----
 net/netfilter/ipvs/ip_vs_xmit.c                 |    2=20
 net/sctp/associola.c                            |    1=20
 net/sctp/output.c                               |    2=20
 net/xfrm/xfrm_user.c                            |    7 -
 55 files changed, 378 insertions(+), 302 deletions(-)

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

David S. Miller (17):
      sparc64: Fix argument sign extension for compat_sys_futex().
      sparc64: Fix executable bit testing in set_pmd_at() paths.
      sparc64: Fix huge PMD invalidation.
      sparc64: Fix bugs in get_user_pages_fast() wrt. THP.
      sparc64: Fix hex values in comment above pte_modify().
      sparc64: Don't use _PAGE_PRESENT in pte_modify() mask.
      sparc64: Handle 32-bit tasks properly in compute_effective_address().
      sparc64: Fix top-level fault handling bugs.
      sparc64: Fix range check in kern_addr_valid().
      sparc64: Use 'ILOG2_4MB' instead of constant '22'.
      sparc64: Add basic validations to {pud,pmd}_bad().
      sparc64: Give more detailed information in {pgd,pmd}_ERROR() and kill=
 pte_ERROR().
      sparc64: Don't bark so loudly about 32-bit tasks generating 64-bit fa=
ult addresses.
      sparc64: Fix huge TSB mapping on pre-UltraSPARC-III cpus.
      sparc64: Add membar to Niagara2 memcpy code.
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

Florian Fainelli (1):
      net: phy: re-apply PHY fixups during phy_register_device

Greg Kroah-Hartman (1):
      Linux 3.14.17

Ivan Vecera (1):
      bna: fix performance regression

Kirill Tkhai (1):
      sparc64: Make itc_sync_lock raw

Sasha Levin (1):
      iovec: make sure the caller actually wants anything in memcpy_fromiov=
ecend

Sowmini Varadhan (1):
      sparc64: ldc_connect() should not return EINVAL when handshake is in =
progress.

Sven Eckelmann (1):
      batman-adv: Fix out-of-order fragmentation support

Tobias Brunner (1):
      xfrm: Fix installation of AH IPsec SAs

Vlad Yasevich (2):
      macvlan: Initialize vlan_features to turn on offload support.
      net: Correctly set segment mac_len in skb_segment().


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT7DUPAAoJEDjbvchgkmk+CY0QAL2DpzZOLhz/Jo7zIIlxrJ/g
SEcuSDiqnbb1DrgZrIFJMjJIJD3SPHve1P0FYBBA/t5yBJdn2m6vyd1f+aP0gjxf
6d6Rn8bOq6WNKVUwmuvGsOCViFlO1h37mqMuibxCjNfYkWbLlvZJLBPyhGZ9GyWm
sJqAlsLSTr+jFnm+4iqJRz3Bu+7U7MJhbuU+YxNpbZzvSAF0XsEu8+Q9vaOMDZAY
asMCIW7hnzQQumNcmw6tTegA0OwpOZN/HVRA0ZHpBzyWUflwpfYoIVfarkLvaq+g
rEs+e1Xbmp94Di0ca4jr4zp+YtWhbZ7hQaMi53l9RmJzMMsmIcouafpxqiciCfXp
4dYdv57bRhlM3/xZwY8k2oRx93zN/cF9uWW30fQHZnpjOf62c/1MHVAz7FNJKjOu
WW02I9GI1B0weJ/A34o8t7qmyQScckArCPv/F8LBMdO7iaIbBwxM4bDfqo//ZzBt
XKi5jjMkBqKpXGB1/iRE5D/FkXWeZ7e98xhT2AgVjPRdVZSbCj7c5cOHXAssr6ZG
MHrch2gYPBHnuIHi5cTNZNdUnCstiOVljrrglgu70AyIJhLXiNeE3kmmufX4QNtN
+2T//jf8cvWcTZwW6d1VGAo/nRTgvmfd6Dt9jKSLWbfEY1wXIKL3Y1q20uaSlcNX
RLAeRigmpzTZixz3mx3K
=Ajwg
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
