Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbbAMOX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:23:28 -0500
Received: from down.free-electrons.com ([37.187.137.238]:34280 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751052AbbAMOXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:23:24 -0500
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
Subject: [PATCH v3 0/4] ata: libahci: Allow using a regulator for each port
Date: Tue, 13 Jan 2015 15:22:29 +0100
Message-Id: <1421158953-2957-1-git-send-email-gregory.clement@free-electrons.com>
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

This is the third version of the series.

I use now the same binding introduced in the first version. This one
was acked in the first place by Hans and was discussed during the
review of the second version.

To be able to use it, I made the port the platform devices when the
device tree was used. An other change was to manage the deferred
case. The regulator were now attached to a different device that the
SATA host, so the devres_release_group don't manage them, and they
have to be released in a separate call.

Thanks,

Grégory

Changelog:
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
 drivers/ata/libahci_platform.c                     | 233 ++++++++++++++-------
 include/linux/ahci_platform.h                      |   2 +
 6 files changed, 302 insertions(+), 84 deletions(-)

-- 
1.9.1

