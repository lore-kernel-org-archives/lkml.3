Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaKKSqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:46:21 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:42858 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaKKSqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:46:18 -0500
From: Johan Hovold <johan@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/3] net: phy: add module_phy_driver macro
Date: Tue, 11 Nov 2014 19:45:56 +0100
Message-Id: <1415731559-10015-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add module_phy_driver macro that can be used by PHY drivers that only
calls phy_driver_register or phy_drivers_register (and the corresponding
unregister functions) in their module init (and exit).

This allows us to eliminate a lot of boilerplate code.

Split in three patches (actual macro and two driver change classes) in
order to facilitate review.

Johan


Johan Hovold (3):
  net: phy: add module_phy_driver macro
  net: phy: replace phy_driver_register calls
  net: phy: replace phy_drivers_register calls

 drivers/net/phy/amd-xgbe-phy.c | 15 +--------------
 drivers/net/phy/amd.c          | 17 +++--------------
 drivers/net/phy/at803x.c       | 14 +-------------
 drivers/net/phy/bcm63xx.c      | 15 +--------------
 drivers/net/phy/bcm7xxx.c      | 15 +--------------
 drivers/net/phy/bcm87xx.c      | 14 +-------------
 drivers/net/phy/broadcom.c     | 15 +--------------
 drivers/net/phy/cicada.c       | 15 +--------------
 drivers/net/phy/davicom.c      | 15 +--------------
 drivers/net/phy/et1011c.c      | 17 +++--------------
 drivers/net/phy/icplus.c       | 15 +--------------
 drivers/net/phy/lxt.c          | 15 +--------------
 drivers/net/phy/marvell.c      | 15 +--------------
 drivers/net/phy/micrel.c       | 15 +--------------
 drivers/net/phy/national.c     | 17 +++--------------
 drivers/net/phy/qsemi.c        | 17 +++--------------
 drivers/net/phy/realtek.c      | 13 +------------
 drivers/net/phy/smsc.c         | 14 +-------------
 drivers/net/phy/ste10Xp.c      | 15 +--------------
 drivers/net/phy/vitesse.c      | 14 +-------------
 include/linux/phy.h            | 24 ++++++++++++++++++++++++
 21 files changed, 52 insertions(+), 274 deletions(-)

-- 
2.0.4

