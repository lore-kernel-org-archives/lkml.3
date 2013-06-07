Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab3FGPnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:43:20 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50091 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab3FGPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:42:29 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] i2c-mv64xxx: Add I2C Transaction Generator support
Date: Fri,  7 Jun 2013 17:42:21 +0200
Message-Id: <1370619743-15245-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this patch set adds support for the I2C Transaction Generator which
offloads CPU from managing I2C transfer step by step. This feature is
currently only available on the I2C controller IP embedded in the
Armada XP SoC. That's why usage of this mechanism is optional and
activated through device tree.

The first patch modifies the driver itself and should go through i2c
subsystem.

Due to the recent changes in i2c-mv64xxx.c file caused by Russell
King's fixes, I based this patch on the for-next branch of the i2c git
repository.

The second patch updates the device tree to be able to use this new
feature and should go through mvebu subsystem.

The 2 patches are independents for building or even at runtime, but of
course we need both of them to be able to use the I2C Transaction
Generator on the Armada XP SoC.

Thanks

Gregory CLEMENT (1):
  ARM: dts: mvebu: Add the i2c-bridge capability to the mv64xxx-i2c

Zbigniew Bodek (1):
  i2c-mv64xxx: Add I2C Transaction Generator support

 .../devicetree/bindings/i2c/i2c-mv64xxx.txt        |   6 +
 arch/arm/boot/dts/armada-370-xp.dtsi               |   2 -
 arch/arm/boot/dts/armada-370.dtsi                  |   8 ++
 arch/arm/boot/dts/armada-xp.dtsi                   |  10 ++
 drivers/i2c/busses/i2c-mv64xxx.c                   | 143 ++++++++++++++++++++-
 5 files changed, 163 insertions(+), 6 deletions(-)

-- 
1.8.1.2

