Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638Ab3DCOqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:46:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761463Ab3DCOpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:45:55 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 09/12] ARM: tegra: tec: Add PCIe support
Date: Wed,  3 Apr 2013 16:45:15 +0200
Message-Id: <1365000318-28256-10-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:hBYfM0lBDOyIlTocQzYx9ZawSOislQB0X50bIOp5rqB
 im1BynwHay8VXBhg6ukb1HOjwC2MEpMhc1u56nEuk7cYHnmQOE
 nMNgEaMhbklJ7bT2Bem9U8zu0R5uCPp5qWLdRXVUKhGCcfndXg
 E+6lxYfxaLJDpNbuwAUASyuIOyDoRp5LZDGAIRaY7FbQG615sQ
 I4JPqj6KGlunNi3s27t1SNVwuEfCt+3iLK+Knm/aiLihFpogbZ
 BIm+JrH7LjzaKScrpU7wUVCGAwbuaKq8cRwy/2m/M8hMeImpNy
 LnzGo6V0QhIWdu3jHntJHJcuoJ3HwtR7i1mr1c3wUfIrHE8Esh
 2WDBQ6bQnbaZhZmME4aU2qjWC6vPvN/dp+tUWDlRgi6gB2NKzr
 7QTlXaX51o9hlGZFoc+YL98ZbRJNHOi8Z7TgiXBq0agmHBLjWo
 8j+j2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the first PCIe root port which is connected to an FPGA on the
Tamonten Evaluation Carrier and add device nodes for each of the PCI
endpoints available in the standard configuration.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v2:
- remove duplicate nodes and properties defined in tegra20-tamonten.dtsi

Changes in v3:
- remove PCIe endpoint device tree nodes, all devices can be discovered
  via standard PCI enumeration

 arch/arm/boot/dts/tegra20-tec.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegra20-tec.dts
index 1ae37ba..e396cb2 100644
--- a/arch/arm/boot/dts/tegra20-tec.dts
+++ b/arch/arm/boot/dts/tegra20-tec.dts
@@ -64,6 +64,14 @@
 		};
 	};
 
+	pcie-controller {
+		status = "okay";
+
+		pci@1,0 {
+			status = "okay";
+		};
+	};
+
 	sound {
 		compatible = "ad,tegra-audio-wm8903-tec",
 			     "nvidia,tegra-audio-wm8903";
-- 
1.8.2

