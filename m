Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbaHZPLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:11:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62452 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaHZPLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:11:42 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] PCI: tegra: Fixes and Tegra124 support
Date: Tue, 26 Aug 2014 17:11:32 +0200
Message-Id: <1409065898-26887-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This series implements various fixes and adds support for Tegra124 to the
Tegra PCIe controller driver.

Patches 1 and 2 were already sent out separately earlier on but haven't been
applied yet, so I'm including them here for convenience.

Patches 3 to 5 are various fixes that should make the driver more reliable,
though they don't (except maybe for patch 4) fix any known issues.

Patch 6 finally adds support for Tegra124.

Thierry

Eric Yuen (1):
  PCI: tegra: Make sure the PCIe PLL is really reset

Peter Daifuku (1):
  PCI: tegra: Fix extended configuration space mapping

Thierry Reding (4):
  resource: Add device-managed request/release_resource()
  PCI: tegra: Implement a proper resource hierarchy
  PCI: tegra: Clear CLKREQ# enable on port disable
  PCI: tegra: Add Tegra124 support

 .../bindings/pci/nvidia,tegra20-pcie.txt           |  25 +-
 Documentation/driver-model/devres.txt              |   2 +
 drivers/pci/host/pci-tegra.c                       | 257 ++++++++++++++++++---
 include/linux/ioport.h                             |   5 +
 kernel/resource.c                                  |  70 ++++++
 5 files changed, 323 insertions(+), 36 deletions(-)

-- 
2.0.4

