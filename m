Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaA2GAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 01:00:48 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:51613 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaA2GAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 01:00:45 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v2 0/4] 
Date: Wed, 29 Jan 2014 10:00:14 +0400
Message-Id: <1390975218-13863-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David, Ben, Florian, Chris and everybody,

this series improves ethoc behavior in gigabit environment:
- first patch introduces two phylib setters for 'advertising' and 'supported'
  fields of struct phy_device;
- second patch disables gigabit advertisement in the attached PHY making
  possible to use gigabit link without any additional setup;
- third patch adds support to set up MII management bus frequency, adding
  new fields to platform data and to OF bindings;
- fourth patch adds basic ethtool support to ethoc driver.

These changes allow to use KC-705 board with 50MHz xtensa core and OpenCores
10/100 Mbps MAC connected to gigabit network without any additional setup.

Changes v1->v2:
- new patch "phy: provide accessors for 'advertising' and 'supported' fields";
- disable both gigabit advertisement and support;
- drop MDIO bus frequency configurability, always configure for standard
  2.5MHz;
- allow using common clock framework to provide ethoc clock;
- new patch: "net: ethoc: implement ethtool operations";
- drop device tree bindings documentation patch until common bindings format
  for network drivers is decided.

Max Filippov (4):
  phy: provide accessors for 'advertising' and 'supported' fields
  net: ethoc: don't advertise gigabit speed on attached PHY
  net: ethoc: set up MII management bus clock
  net: ethoc: implement ethtool operations

 drivers/net/ethernet/ethoc.c | 130 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/phy.h          |  12 ++++
 include/net/ethoc.h          |   1 +
 3 files changed, 141 insertions(+), 2 deletions(-)

-- 
1.8.1.4
