Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaL0Kf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 05:35:29 -0500
Received: from down.free-electrons.com ([37.187.137.238]:47261 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750826AbaL0Kf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 05:35:26 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 0/3] ata: libahci: Allow using a regulator for each port
Date: Sat, 27 Dec 2014 11:34:40 +0100
Message-Id: <1419676483-10346-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The current implementation of the libahci allows using one PHY per
port but we still have one single regulator for the whole
controller. This series adds the support of multiple regulators. Until
now it was mandatory to have a PHY under a subnode, now a port subnode
can contain either a regulator or a PHY (or both).

While I was working on it I also did a small clean-up, it is the
purpose of the 1st patch.

The main patch of the series (the 3rd one) also depends of a patch of
the regulator framework that I submitted yesterday: "regulator: core:
Add the device tree version to the regulator_get family",
https://lkml.org/lkml/2014/12/26/155

I refactored the PHY support in the same time, so I would like to have
a feedback from the Berlin platform to ensure that no regressions was
introduced.

Thanks,

Grégory


Gregory CLEMENT (3):
  ata: libahci: Clean-up the ahci_platform_en/disable_phys functions
  Documentation: bindings: Add the regulator property to the sub-nodes
    AHCI bindings
  ata: libahci: Allow to use multiple regulators

 .../devicetree/bindings/ata/ahci-platform.txt      |   3 +-
 drivers/ata/ahci.h                                 |   2 +-
 drivers/ata/ahci_imx.c                             |  14 +-
 drivers/ata/libahci_platform.c                     | 212 ++++++++++++++-------
 include/linux/ahci_platform.h                      |   2 +
 5 files changed, 153 insertions(+), 80 deletions(-)

-- 
1.9.1

