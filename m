Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305AbaHZO5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:57:52 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33983 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaHZO5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:57:50 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] PCI: tegra: Fixes and Tegra124 support
Date: Tue, 26 Aug 2014 16:57:38 +0200
Message-Id: <1409065064-17617-1-git-send-email-thierry.reding@gmail.com>
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

