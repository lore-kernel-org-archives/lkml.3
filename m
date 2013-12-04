Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab3LDPpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:45:00 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54393 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab3LDPo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:44:58 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mugunthan V N <mugunthanvnm@ti.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFCv2 0/6] net: phy: Ethernet PHY powerdown optimization
Date: Wed,  4 Dec 2013 16:44:42 +0100
Message-Id: <1386171888-28190-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of an RFC sent earlier [1] to reduce power consumption of network
PHYs with link that are either unused or the corresponding netdev is down.

In contrast to RFCv1, this now integrates phy_suspend/phy_resume transparent
to the netdev drivers. Also, phy_suspend now only suspends the PHY if WOL is
disabled. Moreover, the phy state machine calls phy_suspend on entering
HALTED state.

Again, a branch with RFCv2 applied to v3.13-rc2 can also be found at
https://github.com/shesselba/linux-dove.git topic/ethphy-power-rfc-v2

[1] http://lwn.net/Articles/574426/

Sebastian Hesselbarth (6):
  net: mv643xx_eth: properly start/stop phy device
  net: phy: marvell: provide genphy suspend/resume
  net: phy: provide phy_resume/phy_suspend helpers
  net: phy: resume/suspend PHYs on attach/detach
  net: phy: suspend unused PHYs on mdio_bus in late_initcall
  net: phy: suspend phydev when going to HALTED

 drivers/net/ethernet/marvell/mv643xx_eth.c |    4 +++-
 drivers/net/phy/marvell.c                  |   22 ++++++++++++++++++++++
 drivers/net/phy/mdio_bus.c                 |   25 +++++++++++++++++++++++++
 drivers/net/phy/phy.c                      |    6 +++++-
 drivers/net/phy/phy_device.c               |   27 +++++++++++++++++++++++++++
 include/linux/phy.h                        |    2 ++
 6 files changed, 84 insertions(+), 2 deletions(-)

---
Cc: David Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Mugunthan V N <mugunthanvnm@ti.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.2.5

