Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab3HMLMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:12:37 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:34795 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab3HMLMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:12:35 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: [RFC 0/3] ARM: Allow PCI host drivers to be unloaded
Date: Tue, 13 Aug 2013 13:12:23 +0200
Message-Id: <1376392346-14127-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a set of experimental patches that allow ARM PCI host drivers to
be unloaded. The first two patches enhance the ARM core PCI code with
functions to tear down fixed PCI I/O mappings and unregister a PCI host
bridge. The third patch uses the new functionality to allow the Tegra
PCIe driver to unbind from a device.

I'm sending this as an RFC because, while I've been able to successfully
unbind and rebind the Tegra PCIe driver and verifying that a NIC
connected via PCIe still works after each new probe, I haven't fully
investigated yet whether there may be memory leaks due to missing
cleanup.

Thierry

Thierry Reding (3):
  ARM: Allow unmapping of fixed PCI I/O mappings
  ARM: Introduce pci_common_exit()
  PCI: tegra: Support driver unbinding

 arch/arm/include/asm/io.h       |  1 +
 arch/arm/include/asm/mach/pci.h |  6 ++++++
 arch/arm/kernel/bios32.c        | 29 ++++++++++++++++++++++++++---
 arch/arm/mm/ioremap.c           |  6 ++++++
 drivers/pci/host/pci-tegra.c    | 37 ++++++++++++++++++++++++++++++++++++-
 5 files changed, 75 insertions(+), 4 deletions(-)

-- 
1.8.3.4

