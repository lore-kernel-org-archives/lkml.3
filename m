Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbbAIKk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:57 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38750 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756452AbbAIKkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:40:55 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH v2 0/4] ata: libahci: Allow using a regulator for each port
Date: Fri,  9 Jan 2015 11:39:45 +0100
Message-Id: <1420799989-10645-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The current implementation of the libahci allows using one PHY per
port but we still have one single regulator for the whole
controller. This series adds the support of multiple regulators.

This is the second version of the series.

The previous version depended of a patch set for the regulator
framework which was not accepted. Then I needed to do this in a
different way that it was done for the PHY. As result the regulator
need to be associated to each port as the host node level using the
property target-port<n>-supply, where <n> is the port number. But it
is however mandatory to have one port sub-node for each port
associated to a regulator.

Since the 1st version I also took into account the comments from Hans
and added a patch to use the new binding for the device tree of the
Armada 38x GP. This last patch should be merged through the mvebu
tree.

Thanks,

Grégory

Changelog:

 v1 -> v2:
- Kept the case when no child node are present under the ahci node
- Fix the test done under the label disable_target_pwrs
- No more use an of_ version of the regulator framework and instead
  associate each regulator of a port with an unique name.
- Added the acked-by on the clean-up patch

Gregory CLEMENT (4):
  ata: libahci: Clean-up the ahci_platform_en/disable_phys functions
  Documentation: bindings: Add the regulator property to the sub-nodes
    AHCI bindings
  ata: libahci: Allow using multiple regulators
  ARM: mvebu: Armada 385 GP: Add regulators to the SATA port

 .../devicetree/bindings/ata/ahci-platform.txt      |   9 +-
 arch/arm/boot/dts/armada-388-gp.dts                | 126 ++++++++++++
 drivers/ata/ahci.h                                 |   2 +-
 drivers/ata/ahci_imx.c                             |  14 +-
 drivers/ata/libahci_platform.c                     | 224 ++++++++++++++-------
 include/linux/ahci_platform.h                      |   2 +
 6 files changed, 294 insertions(+), 83 deletions(-)

-- 
1.9.1

