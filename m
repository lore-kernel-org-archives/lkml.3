Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbbAJCfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:35:38 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:51141 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbbAJCff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:35:35 -0500
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 04/16] powerpc: add struct pci_ops member names to initialization
Date: Fri,  9 Jan 2015 20:34:38 -0600
Message-Id: <1420857290-8373-5-git-send-email-robh@kernel.org>
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
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: cbe-oss-dev@lists.ozlabs.org
---
 arch/powerpc/platforms/cell/celleb_scc_pciex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/celleb_scc_pciex.c b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
index f223875..94170e4 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_pciex.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
@@ -399,8 +399,8 @@ static int scc_pciex_write_config(struct pci_bus *bus, unsigned int devfn,
 }
 
 static struct pci_ops scc_pciex_pci_ops = {
-	scc_pciex_read_config,
-	scc_pciex_write_config,
+	.read = scc_pciex_read_config,
+	.write = scc_pciex_write_config,
 };
 
 static void pciex_clear_intr_all(unsigned int __iomem *base)
-- 
2.1.0

