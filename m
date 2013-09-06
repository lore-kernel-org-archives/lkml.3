Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3IFTkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:40:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35473 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3IFTkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:40:11 -0400
Date: Fri, 06 Sep 2013 15:40:08 -0400 (EDT)
Message-Id: <20130906.154008.785108838030163101.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Sep 2013 12:40:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A quick set of fixes, some to deal with fallout from yesterday's
net-next merge.

1) Fix compilation of bnx2x driver with CONFIG_BNX2X_SRIOV disabled, from
   Dmitry Kravkov.

2) Fix a bnx2x regression caused by one of Dave Jones's mistaken braces
   changes, from Eilon Greenstein.

3) Add some protective filtering in the netlink tap code, from Daniel
   Borkmann.

4) Fix TCP congestion window growth regression after timeouts, from
   Yuchung Cheng.

5) Correctly adjust TCP's rcv_ssthresh for out of order packets, from
   Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit 2e032852245b3dcfe5461d7353e34eb6da095ccf:

  Merge branch 'for-linus' of git://git.linaro.org/people/rmk/linux-arm (2013-09-05 18:07:32 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to 4e4f1fc226816905c937f9b29dabe351075dfe0f:

  tcp: properly increase rcv_ssthresh for ofo packets (2013-09-06 14:43:49 -0400)

----------------------------------------------------------------
Daniel Borkmann (1):
      net: netlink: filter particular protocols from analyzers

Dmitry Kravkov (1):
      bnx2x: fix broken compilation with CONFIG_BNX2X_SRIOV is not set

Eilon Greenstein (1):
      bnx2x: Restore a call to config_init

Eric Dumazet (1):
      tcp: properly increase rcv_ssthresh for ofo packets

Florian Fainelli (1):
      net: add documentation for BQL helpers

Michael Opdenacker (1):
      mlx5: remove unused MLX5_DEBUG param in Kconfig

Yuchung Cheng (1):
      tcp: fix no cwnd growth after timeout

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c  |  9 +++------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig   | 10 ----------
 include/linux/netdevice.h                         | 26 ++++++++++++++++++++++++++
 net/ipv4/tcp_input.c                              | 11 ++++++-----
 net/netlink/af_netlink.c                          | 30 ++++++++++++++++++++++++++++++
 6 files changed, 67 insertions(+), 21 deletions(-)
