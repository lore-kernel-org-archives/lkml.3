Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab3LHOkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 09:40:41 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:64223 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab3LHOki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 09:40:38 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mugunthan V N <mugunthanvnm@ti.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/6] net: phy: Ethernet PHY powerdown optimization
Date: Sun,  8 Dec 2013 15:40:25 +0100
Message-Id: <1386513631-11284-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1386171888-28190-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1386171888-28190-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is real v1 based on two RFCs sent earlier [1][2] to reduce power
consumption of network PHYs with link that are either unused or the
corresponding netdev is down.

Last RFC got Acked-by/Reviewed-by from Mugunthan and Florian, so it
was time to elevate the RFC to a real patch set. Compared to RFCv2
there is a simplification of phydev reference in patch 5, which was
suggested by Sergei Shtylyov.

Again, a branch with v1 applied to v3.13-rc2 can also be found at
https://github.com/shesselba/linux-dove.git topic/ethphy-power-v1

[1] http://lwn.net/Articles/574426/
[2] http://www.spinics.net/lists/netdev/msg259575.html

Sebastian Hesselbarth (6):
  net: mv643xx_eth: properly start/stop phy device
  net: phy: marvell: provide genphy suspend/resume
  net: phy: provide phy_resume/phy_suspend helpers
  net: phy: resume/suspend PHYs on attach/detach
  net: phy: suspend unused PHYs on mdio_bus in late_initcall
  net: phy: suspend phydev when going to HALTED

 drivers/net/ethernet/marvell/mv643xx_eth.c |  4 +++-
 drivers/net/phy/marvell.c                  | 22 ++++++++++++++++++++++
 drivers/net/phy/mdio_bus.c                 | 23 +++++++++++++++++++++++
 drivers/net/phy/phy.c                      |  6 +++++-
 drivers/net/phy/phy_device.c               | 27 +++++++++++++++++++++++++++
 include/linux/phy.h                        |  2 ++
 6 files changed, 82 insertions(+), 2 deletions(-)

---
Cc: David Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Mugunthan V N <mugunthanvnm@ti.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.8.4.rc3

