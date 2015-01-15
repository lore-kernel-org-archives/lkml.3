Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbbAOOKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:10:21 -0500
Received: from down.free-electrons.com ([37.187.137.238]:53735 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753760AbbAOOKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:10:12 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
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
Subject: [PATCH v4 0/4] ata: libahci: Allow using a regulator for each port
Date: Thu, 15 Jan 2015 15:09:34 +0100
Message-Id: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of the libahci allows using one PHY per
port but we still have one single regulator for the whole
controller. This series adds the support of multiple regulators.

This is the forth version of the series.

The improvement of this version is the use of
ahci_platform_put_resources to put the reference to the regulators.

Thanks,

Grégory

Changelog:

 v3 -> v4
- Moved putting the reference to the regulators into the
  ahci_platform_put_resources function.
- Tested the port_dev pointer before dereferencing.

 v2 -> v3:
- put back the regulator inside the sub-node ports
- made the ports platform devices when the device tree is used
- released the regulator in case of error in the probe function

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
 arch/arm/boot/dts/armada-388-gp.dts                | 126 +++++++++++
 drivers/ata/ahci.h                                 |   2 +-
 drivers/ata/ahci_imx.c                             |  14 +-
 drivers/ata/libahci_platform.c                     | 236 ++++++++++++++-------
 include/linux/ahci_platform.h                      |   2 +
 6 files changed, 305 insertions(+), 84 deletions(-)

-- 
1.9.1

