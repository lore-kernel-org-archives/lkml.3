Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbaHHVsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:48:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932AbaHHVqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:46:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.16 00/17] 3.16.1-stable review
Date: Fri,  8 Aug 2014 14:35:22 -0700
Message-Id: <20140808213457.511493898@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.16.1 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Aug 10 21:34:49 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.16.1-rc1

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

Prashant Sreedharan <prashant@broadcom.com>
    tg3: Modify tg3_tso_bug() to handle multiple TX rings

Eric Dumazet <edumazet@google.com>
    sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Fabio Estevam <fabio.estevam@freescale.com>
    Revert "net: phy: Set the driver when registering an MDIO bus device"

Sven Eckelmann <sven@narfation.org>
    batman-adv: Fix out-of-order fragmentation support

Sasha Levin <sasha.levin@oracle.com>
    iovec: make sure the caller actually wants anything in memcpy_fromiovecend

Vlad Yasevich <vyasevic@redhat.com>
    net: Correctly set segment mac_len in skb_segment().

Vlad Yasevich <vyasevic@redhat.com>
    macvlan: Initialize vlan_features to turn on offload support.

Ivan Vecera <ivecera@redhat.com>
    bna: fix performance regression

Christoph Paasch <christoph.paasch@uclouvain.be>
    tcp: Fix integer-overflow in TCP vegas

Christoph Paasch <christoph.paasch@uclouvain.be>
    tcp: Fix integer-overflows in TCP veno

Dmitry Popov <ixaphire@qrator.net>
    ip_tunnel(ipv4): fix tunnels with "local any remote $remote_ip"


-------------

Diffstat:

 Makefile                                |  4 ++--
 arch/sparc/include/asm/tlbflush_64.h    | 12 ++----------
 arch/sparc/kernel/ldc.c                 |  2 +-
 arch/sparc/math-emu/math_32.c           |  2 +-
 arch/sparc/mm/init_64.c                 | 31 +++++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/tg3.c     | 22 ++++++++++++----------
 drivers/net/ethernet/brocade/bna/bnad.c |  2 +-
 drivers/net/macvlan.c                   |  1 +
 drivers/net/phy/mdio_bus.c              |  1 -
 drivers/sbus/char/bbc_envctrl.c         |  6 ++++++
 drivers/sbus/char/bbc_i2c.c             | 11 ++++++++---
 drivers/tty/serial/sunsab.c             |  9 +++++++++
 include/net/ip_tunnels.h                |  1 +
 lib/iovec.c                             |  4 ++++
 net/batman-adv/fragmentation.c          | 10 +++++++---
 net/core/skbuff.c                       |  2 +-
 net/ipv4/ip_tunnel.c                    | 29 ++++++++++++++++++-----------
 net/ipv4/tcp_vegas.c                    |  3 ++-
 net/ipv4/tcp_veno.c                     |  2 +-
 net/sctp/output.c                       |  2 +-
 20 files changed, 109 insertions(+), 47 deletions(-)


