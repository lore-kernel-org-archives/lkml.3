Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaIXPiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:38:14 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:50908 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbaIXPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:38:09 -0400
From: Robert Richter <rric@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Sunil Goutham <sgoutham@cavium.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>
Subject: [PATCH 5/6] arm64, defconfig: Enable PCI
Date: Wed, 24 Sep 2014 17:37:47 +0200
Message-Id: <1411573068-12952-6-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411573068-12952-1-git-send-email-rric@kernel.org>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rrichter@cavium.com>

Enable the PCI subsystem in defconfig. There will be more and more
systems with pci support, so default enable it. This also implicitly
enables the MSI feature.

Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm64/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ca3f7e9afd4d..97777e1ef5a7 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -163,11 +163,15 @@ config ARM_AMBA
 
 config PCI
 	bool "PCI support"
+	default y
 	help
 	  This feature enables support for PCIe bus system. If you say Y
 	  here, the kernel will include drivers and infrastructure code
 	  to support PCIe bus devices.
 
+config PCI_MSI
+	def_bool PCI
+
 config PCI_DOMAINS
 	def_bool PCI
 
-- 
2.1.0

