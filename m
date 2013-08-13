Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab3HMM0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:26:16 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:50558 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab3HMM0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:26:11 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 0/5] ARM: dove: DT PCIe support
Date: Tue, 13 Aug 2013 14:25:19 +0200
Message-Id: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the PCIe controllers found on Marvell
Dove SoCs. It depends on mvebu-pci patches sent by Thomas Petazzoni.
The ARM Dove related patches have already been taken by Jason Cooper
and have been removed from v2 of this patch set. Changelog is added
to the individual patch emails.

Patches 1 and 2 fix some minor issues with pci-mvebu by moving
clk_prepare_enable before accessing any controller registers and
counting sucessfully registered ports only.

Patch 3 converts pci-mvebu from subsys_initcall registration to
normal platform driver registration to allow it to fail with
EPROBE_DEFER later.

Patch 4 adds DT parsing for reset (PERST#) GPIO pins and delay to
wait for PCIe devices after reset de-assertion.

Patch 5 finally adds a compatible to pci-mvebu for Dove SoCs.

[Patch 6-9 have already been taken by Jason Cooper]

Sebastian Hesselbarth (5):
  PCI: mvebu: move clock enable before register access
  PCI: mvebu: increment nports only for registered ports
  PCI: mvebu: remove subsys_initcall
  PCI: mvebu: add support for reset on GPIO
  PCI: mvebu: add support for Marvell Dove SoCs

 .../devicetree/bindings/pci/mvebu-pci.txt          |    7 ++
 drivers/pci/host/Kconfig                           |    2 +-
 drivers/pci/host/pci-mvebu.c                       |   99 +++++++++++++-------
 3 files changed, 71 insertions(+), 37 deletions(-)

---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pci@vger.kernel.org
-- 
1.7.10.4

