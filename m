Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbbAJCff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:35:35 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:59712 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbbAJCfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:31 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 02/16] mips: add struct pci_ops member names to initialization
Date: Fri,  9 Jan 2015 20:34:36 -0600
Message-Id: <1420857290-8373-3-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420857290-8373-1-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some instances of pci_ops initialization rely on the read/write members'
location in the struct. This is fragile and may break when adding new
members to the beginning of the struct.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/pci/pci-bcm1480.c |  4 ++--
 arch/mips/pci/pci-octeon.c  |  4 ++--
 arch/mips/pci/pcie-octeon.c | 12 ++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/mips/pci/pci-bcm1480.c b/arch/mips/pci/pci-bcm1480.c
index 5ec2a7b..f2355e3 100644
--- a/arch/mips/pci/pci-bcm1480.c
+++ b/arch/mips/pci/pci-bcm1480.c
@@ -173,8 +173,8 @@ static int bcm1480_pcibios_write(struct pci_bus *bus, unsigned int devfn,
 }
 
 struct pci_ops bcm1480_pci_ops = {
-	bcm1480_pcibios_read,
-	bcm1480_pcibios_write,
+	.read = bcm1480_pcibios_read,
+	.write = bcm1480_pcibios_write,
 };
 
 static struct resource bcm1480_mem_resource = {
diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
index d07e041..bedb72b 100644
--- a/arch/mips/pci/pci-octeon.c
+++ b/arch/mips/pci/pci-octeon.c
@@ -327,8 +327,8 @@ static int octeon_write_config(struct pci_bus *bus, unsigned int devfn,
 
 
 static struct pci_ops octeon_pci_ops = {
-	octeon_read_config,
-	octeon_write_config,
+	.read = octeon_read_config,
+	.write = octeon_write_config,
 };
 
 static struct resource octeon_pci_mem_resource = {
diff --git a/arch/mips/pci/pcie-octeon.c b/arch/mips/pci/pcie-octeon.c
index 5e36c33..eb4a17b 100644
--- a/arch/mips/pci/pcie-octeon.c
+++ b/arch/mips/pci/pcie-octeon.c
@@ -1792,8 +1792,8 @@ static int octeon_dummy_write_config(struct pci_bus *bus, unsigned int devfn,
 }
 
 static struct pci_ops octeon_pcie0_ops = {
-	octeon_pcie0_read_config,
-	octeon_pcie0_write_config,
+	.read = octeon_pcie0_read_config,
+	.write = octeon_pcie0_write_config,
 };
 
 static struct resource octeon_pcie0_mem_resource = {
@@ -1813,8 +1813,8 @@ static struct pci_controller octeon_pcie0_controller = {
 };
 
 static struct pci_ops octeon_pcie1_ops = {
-	octeon_pcie1_read_config,
-	octeon_pcie1_write_config,
+	.read = octeon_pcie1_read_config,
+	.write = octeon_pcie1_write_config,
 };
 
 static struct resource octeon_pcie1_mem_resource = {
@@ -1834,8 +1834,8 @@ static struct pci_controller octeon_pcie1_controller = {
 };
 
 static struct pci_ops octeon_dummy_ops = {
-	octeon_dummy_read_config,
-	octeon_dummy_write_config,
+	.read = octeon_dummy_read_config,
+	.write = octeon_dummy_write_config,
 };
 
 static struct resource octeon_dummy_mem_resource = {
-- 
2.1.0

