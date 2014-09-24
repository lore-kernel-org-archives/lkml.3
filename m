Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaIXPif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:38:35 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50511 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbaIXPiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:38:11 -0400
From: Robert Richter <rric@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Sunil Goutham <sgoutham@cavium.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>
Subject: [PATCH 6/6] pci, thunder: Enable Cavium Thunder PCIe host controller
Date: Wed, 24 Sep 2014 17:37:48 +0200
Message-Id: <1411573068-12952-7-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411573068-12952-1-git-send-email-rric@kernel.org>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rrichter@cavium.com>

Enable Cavium Thunder PCIe host controller driver.

IOV is enabled per default if drivers with IOV support are
enabled. IOV can be disabled.

Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm64/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 97777e1ef5a7..bd9724e5c8a1 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -172,6 +172,14 @@ config PCI
 config PCI_MSI
 	def_bool PCI
 
+config NO_PCI_IOV
+	def_bool PCI
+	depends on !PCI_THUNDER
+
+config PCI_IOV
+	def_bool PCI
+	depends on !NO_PCI_IOV
+
 config PCI_DOMAINS
 	def_bool PCI
 
@@ -185,6 +193,9 @@ source "drivers/pci/Kconfig"
 source "drivers/pci/pcie/Kconfig"
 source "drivers/pci/hotplug/Kconfig"
 
+config PCI_THUNDER
+	def_bool PCI
+
 endmenu
 
 menu "Kernel Features"
-- 
2.1.0

