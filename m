Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbaHHVxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:53:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916AbaHHVgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.15 00/26] 3.15.10-stable review
Date: Fri,  8 Aug 2014 14:35:07 -0700
Message-Id: <20140808213413.648794968@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.15.10 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Aug 10 21:34:03 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.15.10-rc1

Dave Chinner <dchinner@redhat.com>
    xfs: log vector rounding leaks log space

Andrey Utkin <andrey.krieger.utkin@gmail.com>
    arch/sparc/math-emu/math_32.c: drop stray break operator

Sowmini Varadhan <sowmini.varadhan@oracle.com>
    sparc64: ldc_connect() should not return EINVAL when handshake is in progress.

Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>
    sunsab: Fix detection of BREAK on sunsab serial console

Christopher Alexander Tobias Schulze <cat.schulze@alice-dsl.net>
    bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000

David S. Miller <davem@davemloft.net>
    sparc64: Guard against flushing openfirmware mappings.

David S. Miller <davem@davemloft.net>
    sparc64: Do not insert non-valid PTEs into the TSB hash table.

David S. Miller <davem@davemloft.net>
    sparc: Hook up renameat2 syscall.

Eric Dumazet <edumazet@google.com>
    sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix out-of-order fragmentation support

Sasha Levin <sasha.levin@oracle.com>
    iovec: make sure the caller actually wants anything in memcpy_fromiovecend

Vlad Yasevich <vyasevic@redhat.com>
    net: Correctly set segment mac_len in skb_segment().

Vlad Yasevich <vyasevic@redhat.com>
    macvlan: Initialize vlan_features to turn on offload support.

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: inherit auth_capable on INIT collisions

Ivan Vecera <ivecera@redhat.com>
    bna: fix performance regression

Christoph Paasch <christoph.paasch@uclouvain.be>
    tcp: Fix integer-overflow in TCP vegas

Eric Dumazet <edumazet@google.com>
    ip: make IP identifiers less predictable

Eric Dumazet <edumazet@google.com>
    inetpeer: get rid of ip_id_count

Christoph Paasch <christoph.paasch@uclouvain.be>
    tcp: Fix integer-overflows in TCP veno

Dmitry Popov <ixaphire@qrator.net>
    ip_tunnel(ipv4): fix tunnels with "local any remote $remote_ip"

Florian Fainelli <f.fainelli@gmail.com>
    net: phy: re-apply PHY fixups during phy_register_device

Andrey Ryabinin <ryabinin.a.a@gmail.com>
    net: sendmsg: fix NULL pointer dereference

Dmitry Kravkov <Dmitry.Kravkov@qlogic.com>
    bnx2x: fix crash during TSO tunneling

Tobias Brunner <tobias@strongswan.org>
    xfrm: Fix installation of AH IPsec SAs

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix refcount imbalance in xfrm_lookup

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: correctly pad short packets


-------------

Diffstat:

 Makefile                                        |  4 +-
 arch/sparc/include/asm/tlbflush_64.h            | 12 +----
 arch/sparc/include/uapi/asm/unistd.h            |  3 +-
 arch/sparc/kernel/ldc.c                         |  2 +-
 arch/sparc/kernel/sys32.S                       |  1 +
 arch/sparc/kernel/systbls_32.S                  |  1 +
 arch/sparc/kernel/systbls_64.S                  |  2 +
 arch/sparc/math-emu/math_32.c                   |  2 +-
 arch/sparc/mm/init_64.c                         | 31 ++++++++++++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h     |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |  9 ++++
 drivers/net/ethernet/broadcom/genet/bcmgenet.c  |  5 ++
 drivers/net/ethernet/brocade/bna/bnad.c         |  2 +-
 drivers/net/macvlan.c                           |  1 +
 drivers/net/phy/phy_device.c                    |  2 +-
 drivers/net/ppp/pptp.c                          |  2 +-
 drivers/sbus/char/bbc_envctrl.c                 |  6 +++
 drivers/sbus/char/bbc_i2c.c                     | 11 +++--
 drivers/tty/serial/sunsab.c                     |  9 ++++
 fs/xfs/xfs_log.h                                | 19 +++++---
 fs/xfs/xfs_log_cil.c                            |  7 +--
 include/net/inetpeer.h                          | 16 ++-----
 include/net/ip.h                                | 31 ++++++------
 include/net/ip_tunnels.h                        |  1 +
 include/net/ipv6.h                              |  2 -
 include/net/secure_seq.h                        |  2 -
 net/batman-adv/fragmentation.c                  | 10 ++--
 net/compat.c                                    |  9 ++--
 net/core/iovec.c                                | 10 ++--
 net/core/secure_seq.c                           | 25 ----------
 net/core/skbuff.c                               |  2 +-
 net/ipv4/igmp.c                                 |  4 +-
 net/ipv4/inetpeer.c                             | 18 -------
 net/ipv4/ip_output.c                            |  7 ++-
 net/ipv4/ip_tunnel.c                            | 29 +++++++-----
 net/ipv4/ip_tunnel_core.c                       |  2 +-
 net/ipv4/ipmr.c                                 |  2 +-
 net/ipv4/raw.c                                  |  2 +-
 net/ipv4/route.c                                | 63 +++++++++++++++----------
 net/ipv4/tcp_vegas.c                            |  3 +-
 net/ipv4/tcp_veno.c                             |  2 +-
 net/ipv4/xfrm4_mode_tunnel.c                    |  2 +-
 net/ipv6/ip6_output.c                           | 14 ++++++
 net/ipv6/output_core.c                          | 25 ----------
 net/netfilter/ipvs/ip_vs_xmit.c                 |  2 +-
 net/sctp/associola.c                            |  1 +
 net/sctp/output.c                               |  2 +-
 net/xfrm/xfrm_policy.c                          |  2 +
 net/xfrm/xfrm_user.c                            |  7 ++-
 49 files changed, 230 insertions(+), 197 deletions(-)


