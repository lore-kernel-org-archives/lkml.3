Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab3KLTIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:08:40 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:44243 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3KLTHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:07:37 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: [PATCH 04/12] PCI/portdrv: Remove superfluous name cast
Date: Tue, 12 Nov 2013 20:07:17 +0100
Message-Id: <1384283245-9419-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
References: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_driver.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/pcie/portdrv_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 31063ac30992..833c18c3eb96 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -553,7 +553,7 @@ int pcie_port_service_register(struct pcie_port_service_driver *new)
 	if (pcie_ports_disabled)
 		return -ENODEV;
 
-	new->driver.name = (char *)new->name;
+	new->driver.name = new->name;
 	new->driver.bus = &pcie_port_bus_type;
 	new->driver.probe = pcie_port_probe_service;
 	new->driver.remove = pcie_port_remove_service;
-- 
1.7.9.5

